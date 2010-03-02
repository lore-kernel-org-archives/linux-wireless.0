Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:35667 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab0CBWrE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 17:47:04 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 4/4] rndis_wlan: Implement cfg80211 PMKSA API
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 03 Mar 2010 00:38:41 +0200
Message-ID: <20100302223841.2794.92692.stgit@fate.lan>
In-Reply-To: <20100302223825.2794.13615.stgit@fate.lan>
References: <20100302223825.2794.13615.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for cfg80211 set_pmksa/del_pmksa/flush_pmksa. Updating PMKID
entry list is done on driver side since NDIS API requires full list update.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |  271 +++++++++++++++++++++++++++++++++++++
 1 files changed, 271 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 4054b70..65f5236 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -372,6 +372,18 @@ struct ndis_80211_capability {
 	struct ndis_80211_auth_encr_pair auth_encr_pair[0];
 } __attribute__((packed));
 
+struct ndis_80211_bssid_info {
+	u8 bssid[6];
+	u8 padding[2];
+	u8 pmkid[16];
+};
+
+struct ndis_80211_pmkid {
+	__le32 length;
+	__le32 bssid_info_count;
+	struct ndis_80211_bssid_info bssid_info[0];
+};
+
 /*
  *  private data
  */
@@ -542,6 +554,14 @@ static int rndis_get_station(struct wiphy *wiphy, struct net_device *dev,
 static int rndis_dump_station(struct wiphy *wiphy, struct net_device *dev,
 			       int idx, u8 *mac, struct station_info *sinfo);
 
+static int rndis_set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
+				struct cfg80211_pmksa *pmksa);
+
+static int rndis_del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
+				struct cfg80211_pmksa *pmksa);
+
+static int rndis_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev);
+
 static struct cfg80211_ops rndis_config_ops = {
 	.change_virtual_intf = rndis_change_virtual_intf,
 	.scan = rndis_scan,
@@ -558,6 +578,9 @@ static struct cfg80211_ops rndis_config_ops = {
 	.set_default_key = rndis_set_default_key,
 	.get_station = rndis_get_station,
 	.dump_station = rndis_dump_station,
+	.set_pmksa = rndis_set_pmksa,
+	.del_pmksa = rndis_del_pmksa,
+	.flush_pmksa = rndis_flush_pmksa,
 };
 
 static void *rndis_wiphy_privid = &rndis_wiphy_privid;
@@ -1565,6 +1588,190 @@ static void set_multicast_list(struct usbnet *usbdev)
 						le32_to_cpu(filter), ret);
 }
 
+#ifdef DEBUG
+static void debug_print_pmkids(struct usbnet *usbdev,
+				struct ndis_80211_pmkid *pmkids,
+				const char *func_str)
+{
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
+	int i, len, count, max_pmkids;
+
+	max_pmkids = priv->wdev.wiphy->max_num_pmkids;
+	len = le32_to_cpu(pmkids->length);
+	count = le32_to_cpu(pmkids->bssid_info_count);
+
+	devdbg(usbdev, "%s: %d PMKIDs", func_str, count);
+
+	if (count > max_pmkids)
+		count = max_pmkids;
+
+	for (i = 0; i < count; i++) {
+		u32 *tmp = (u32 *)pmkids->bssid_info[i].pmkid;
+
+		devdbg(usbdev, "%s:  bssid: %pM, pmkid: %08X:%08X:%08X:%08X",
+				func_str, pmkids->bssid_info[i].bssid,
+				cpu_to_be32(tmp[0]), cpu_to_be32(tmp[1]),
+				cpu_to_be32(tmp[2]), cpu_to_be32(tmp[3]));
+	}
+}
+#else
+static void debug_print_pmkids(struct usbnet *usbdev,
+				struct ndis_80211_pmkid *pmkids,
+				const char *func_str)
+{
+	return;
+}
+#endif
+
+static struct ndis_80211_pmkid *get_device_pmkids(struct usbnet *usbdev)
+{
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
+	struct ndis_80211_pmkid *pmkids;
+	int len, ret, max_pmkids;
+
+	max_pmkids = priv->wdev.wiphy->max_num_pmkids;
+	len = sizeof(*pmkids) + max_pmkids * sizeof(pmkids->bssid_info[0]);
+
+	pmkids = kzalloc(len, GFP_KERNEL);
+	if (!pmkids)
+		return ERR_PTR(-ENOMEM);
+
+	pmkids->length = cpu_to_le32(len);
+	pmkids->bssid_info_count = cpu_to_le32(max_pmkids);
+
+	ret = rndis_query_oid(usbdev, OID_802_11_PMKID, pmkids, &len);
+	if (ret < 0) {
+		devdbg(usbdev, "get_device_pmkids(): OID_802_11_PMKID(%d, %d)"
+				" -> %d", len, max_pmkids, ret);
+
+		kfree(pmkids);
+		return ERR_PTR(ret);
+	}
+
+	if (le32_to_cpu(pmkids->bssid_info_count) > max_pmkids)
+		pmkids->bssid_info_count = cpu_to_le32(max_pmkids);
+
+	debug_print_pmkids(usbdev, pmkids, "get_device_pmkids()");
+
+	return pmkids;
+}
+
+static int set_device_pmkids(struct usbnet *usbdev,
+				struct ndis_80211_pmkid *pmkids)
+{
+	int ret, len, num_pmkids;
+
+	num_pmkids = le32_to_cpu(pmkids->bssid_info_count);
+	len = sizeof(*pmkids) + num_pmkids * sizeof(pmkids->bssid_info[0]);
+	pmkids->length = cpu_to_le32(len);
+
+	debug_print_pmkids(usbdev, pmkids, "set_device_pmkids()");
+
+	ret = rndis_set_oid(usbdev, OID_802_11_PMKID, pmkids,
+						le32_to_cpu(pmkids->length));
+	if (ret < 0) {
+		devdbg(usbdev, "set_device_pmkids(): OID_802_11_PMKID(%d, %d)"
+				" -> %d", len, num_pmkids, ret);
+	}
+
+	kfree(pmkids);
+	return ret;
+}
+
+static struct ndis_80211_pmkid *remove_pmkid(struct usbnet *usbdev,
+						struct ndis_80211_pmkid *pmkids,
+						struct cfg80211_pmksa *pmksa,
+						int max_pmkids)
+{
+	int i, len, count, newlen, err;
+
+	len = le32_to_cpu(pmkids->length);
+	count = le32_to_cpu(pmkids->bssid_info_count);
+
+	if (count > max_pmkids)
+		count = max_pmkids;
+
+	for (i = 0; i < count; i++)
+		if (!compare_ether_addr(pmkids->bssid_info[i].bssid,
+							pmksa->bssid))
+			break;
+
+	/* pmkid not found */
+	if (i == count) {
+		devdbg(usbdev, "remove_pmkid(): bssid not found (%pM)",
+								pmksa->bssid);
+		err = -ENOENT;
+		goto error;
+	}
+
+	for (; i + 1 < count; i++)
+		pmkids->bssid_info[i] = pmkids->bssid_info[i + 1];
+
+	count--;
+	newlen = sizeof(*pmkids) + count * sizeof(pmkids->bssid_info[0]);
+
+	pmkids->length = cpu_to_le32(newlen);
+	pmkids->bssid_info_count = cpu_to_le32(count);
+
+	return pmkids;
+error:
+	kfree(pmkids);
+	return ERR_PTR(err);
+}
+
+static struct ndis_80211_pmkid *update_pmkid(struct usbnet *usbdev,
+						struct ndis_80211_pmkid *pmkids,
+						struct cfg80211_pmksa *pmksa,
+						int max_pmkids)
+{
+	int i, err, len, count, newlen;
+
+	len = le32_to_cpu(pmkids->length);
+	count = le32_to_cpu(pmkids->bssid_info_count);
+
+	if (count > max_pmkids)
+		count = max_pmkids;
+
+	/* update with new pmkid */
+	for (i = 0; i < count; i++) {
+		if (compare_ether_addr(pmkids->bssid_info[i].bssid,
+							pmksa->bssid))
+			continue;
+
+		memcpy(pmkids->bssid_info[i].pmkid, pmksa->pmkid,
+								WLAN_PMKID_LEN);
+
+		return pmkids;
+	}
+
+	/* out of space, return error */
+	if (i == max_pmkids) {
+		devdbg(usbdev, "update_pmkid(): out of space");
+		err = -ENOSPC;
+		goto error;
+	}
+
+	/* add new pmkid */
+	newlen = sizeof(*pmkids) + (count + 1) * sizeof(pmkids->bssid_info[0]);
+
+	pmkids = krealloc(pmkids, newlen, GFP_KERNEL);
+	if (!pmkids) {
+		err = -ENOMEM;
+		goto error;
+	}
+
+	pmkids->length = cpu_to_le32(newlen);
+	pmkids->bssid_info_count = cpu_to_le32(count + 1);
+
+	memcpy(pmkids->bssid_info[count].bssid, pmksa->bssid, ETH_ALEN);
+	memcpy(pmkids->bssid_info[count].pmkid, pmksa->pmkid, WLAN_PMKID_LEN);
+
+	return pmkids;
+error:
+	kfree(pmkids);
+	return ERR_PTR(err);
+}
+
 /*
  * cfg80211 ops
  */
@@ -2164,6 +2371,70 @@ static int rndis_dump_station(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static int rndis_set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
+				struct cfg80211_pmksa *pmksa)
+{
+	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
+	struct usbnet *usbdev = priv->usbdev;
+	struct ndis_80211_pmkid *pmkids;
+
+	devdbg(usbdev, "rndis_set_pmksa()");
+
+	pmkids = get_device_pmkids(usbdev);
+	if (IS_ERR(pmkids)) {
+		/* couldn't read PMKID cache from device */
+		return PTR_ERR(pmkids);
+	}
+
+	pmkids = update_pmkid(usbdev, pmkids, pmksa, wiphy->max_num_pmkids);
+	if (IS_ERR(pmkids)) {
+		/* not found, list full, etc */
+		return PTR_ERR(pmkids);
+	}
+
+	return set_device_pmkids(usbdev, pmkids);
+}
+
+static int rndis_del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
+				struct cfg80211_pmksa *pmksa)
+{
+	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
+	struct usbnet *usbdev = priv->usbdev;
+	struct ndis_80211_pmkid *pmkids;
+
+	devdbg(usbdev, "rndis_del_pmksa()");
+
+	pmkids = get_device_pmkids(usbdev);
+	if (IS_ERR(pmkids)) {
+		/* Couldn't read PMKID cache from device */
+		return PTR_ERR(pmkids);
+	}
+
+	pmkids = remove_pmkid(usbdev, pmkids, pmksa, wiphy->max_num_pmkids);
+	if (IS_ERR(pmkids)) {
+		/* not found, etc */
+		return PTR_ERR(pmkids);
+	}
+
+	return set_device_pmkids(usbdev, pmkids);
+}
+
+static int rndis_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
+{
+	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
+	struct usbnet *usbdev = priv->usbdev;
+	struct ndis_80211_pmkid pmkid;
+
+	devdbg(usbdev, "rndis_flush_pmksa()");
+
+	memset(&pmkid, 0, sizeof(pmkid));
+
+	pmkid.length = cpu_to_le32(sizeof(pmkid));
+	pmkid.bssid_info_count = cpu_to_le32(0);
+
+	return rndis_set_oid(usbdev, OID_802_11_PMKID, &pmkid, sizeof(pmkid));
+}
+
 /*
  * workers, indication handlers, device poller
  */

