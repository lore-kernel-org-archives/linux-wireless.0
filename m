Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D9826B971
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 07:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785571117; cv=none; b=Gt6Sgi+eiBM8z4SitoAnn3jDdQ/JUxpW02cNL/glBSiY0ZeIbKlcnYUKat4/Ry8LrQaBIS1FbBNKRGpRefAKxw0YBEIkio31pBFq3UDKenXRPUHv+CO5v5Qs3OnJobctwKZLZkLLR8yGlPaf4oVLq0+FjlZLmDl36aQtwUdswH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785571117; c=relaxed/simple;
	bh=RHGOpprH5dhoXqc+oA+YmY6Ge7yMRa/BCMb/1G1j2+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Az8I1wjVVIhoI0IIaeAlg8X672HBiHGnOix5IoI5SMRF7P4p9gwGVzXgRmKoKnil+i7ezCB27t/dPFF9a69DfE6C+If0dZKJ08bcry1LEehkwJ/0KBn9/6cxcTP8AWos+H5J/NPoX/A3c7QKcVnYPqcJc8NP5F4rOhgy3NceiWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=aG2ZtwBw; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="aG2ZtwBw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=d55puPp+XmWcdOf6WEUw6Z7pm0Y16W3nWNXzpQbzh30=;
	t=1785571115; x=1786780715; b=aG2ZtwBw34OV4Z+JopmUC9D++J/bMQ97Xpfq9aqr83gwHNt
	NexmYHwrtKq/DfB34xYR+iOzbt7F1ceCVNDxXJ/3NaVZMcL1Tb2Ec+46BYVe1xwydD65S3wYeNoY4
	Hjl2/aMdVeVTTjP4OXSH2MgrpZvYD5QJISSlV1oAodRVfjJp6q3EK9LKu7oCloY3Uc4PRUXv78+aH
	ExC9wuzWzvUK9/G3tNJawQaaIfu6xT2LKRxdlVVuhjwZ1adQ0dExi4LGdX87Y532Xoy/EwouzW1SC
	h2SUEbo6akUKTuf2XD9WKus7xHl0nJcPuPHpcZ3WQ2D5LEpcnA8jKCPzqAaytC6Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wq4by-0000000ErOv-2tw5;
	Sat, 01 Aug 2026 09:58:26 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 01/12] wifi: cfg80211: support C/B/I/GTK per AP in client modes
Date: Sat,  1 Aug 2026 09:58:17 +0200
Message-ID: <20260801095822.358df5a3a077.I344497e57aa89d9430ccdd9d386466d17064d018@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260801075822.645974-14-johannes@sipsolutions.net>
References: <20260801075822.645974-14-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Add WIPHY_FLAG_CLIENT_AP_STA_GTK indicating that the driver
does per-AP C/B/I/GTK in client/P2P-client modes. If this is
set, then cfg80211 will allow userspace to pass the AP's
(or AP MLD's) MAC address with key commands, and will also
pass the current AP's MAC address if not given by userspace
for drivers requiring it, for backward compatibility.

Per-AP C/B/I/GTK for RX will be required by mac80211 to clean
up the code as well as for SMD Transition, where group keys
for the target AP may be installed while the switch isn't
complete yet.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h     |  7 +++++-
 net/wireless/core.h        |  2 ++
 net/wireless/nl80211.c     | 12 +++++++++-
 net/wireless/rdev-ops.h    |  6 +++++
 net/wireless/sme.c         |  2 ++
 net/wireless/util.c        | 47 ++++++++++++++++++++++++++++++++++++--
 net/wireless/wext-compat.c |  5 ++++
 7 files changed, 77 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b5d98ba07239..721fbca0937c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5720,6 +5720,10 @@ struct cfg80211_ops {
  *	set this flag to update channels on beacon hints.
  * @WIPHY_FLAG_SUPPORTS_NSTR_NONPRIMARY: support connection to non-primary link
  *	of an NSTR mobile AP MLD.
+ * @WIPHY_FLAG_CLIENT_AP_STA_GTK: Handle C/B/I/GTK installation on a STA (AP
+ *	STA) basis for station and P2P client interfaces.
+ *	(Note that if userspace doesn't give the MAC address, the AP's address
+ *	is substituted to allow for older userspace versions.)
  */
 enum wiphy_flags {
 	WIPHY_FLAG_SUPPORTS_EXT_KEK_KCK		= BIT(0),
@@ -5731,7 +5735,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_4ADDR_STATION		= BIT(6),
 	WIPHY_FLAG_CONTROL_PORT_PROTOCOL	= BIT(7),
 	WIPHY_FLAG_IBSS_RSN			= BIT(8),
-	/* reuse bit 9 */
+	WIPHY_FLAG_CLIENT_AP_STA_GTK		= BIT(9),
 	WIPHY_FLAG_MESH_AUTH			= BIT(10),
 	WIPHY_FLAG_SUPPORTS_EXT_KCK_32          = BIT(11),
 	WIPHY_FLAG_SUPPORTS_NSTR_NONPRIMARY	= BIT(12),
@@ -7307,6 +7311,7 @@ struct wireless_dev {
 			u8 connected_addr[ETH_ALEN] __aligned(2);
 			u8 ssid[IEEE80211_MAX_SSID_LEN];
 			u8 ssid_len;
+			bool wep_used;
 		} client;
 		struct {
 			int beacon_interval;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 3b90aa8cc6ac..1c17c74f7129 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -448,6 +448,8 @@ bool cfg80211_cigtk_supported(struct wireless_dev *wdev,
 bool cfg80211_valid_key_idx(struct wireless_dev *wdev,
 			    int key_idx, enum nl80211_key_type type,
 			    const u8 *mac_addr);
+const u8 *cfg80211_get_key_mac_addr(struct wireless_dev *wdev, u32 cipher,
+				    bool pairwise, const u8 *mac_addr);
 int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 				   struct wireless_dev *wdev,
 				   struct key_params *params, int key_idx,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 56648f7d9c7f..628d314ac6fb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5435,6 +5435,8 @@ static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->get_key)
 		return -EOPNOTSUPP;
 
+	mac_addr = cfg80211_get_key_mac_addr(wdev, 0, pairwise, mac_addr);
+
 	if (!cfg80211_valid_key_idx(wdev, key_idx, type, mac_addr))
 		return -ENOENT;
 
@@ -5636,6 +5638,10 @@ static int nl80211_new_key(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->add_key)
 		return -EOPNOTSUPP;
 
+	mac_addr = cfg80211_get_key_mac_addr(wdev, key.p.cipher,
+					     key.type == NL80211_KEYTYPE_PAIRWISE,
+					     mac_addr);
+
 	if (cfg80211_validate_key_settings(rdev, wdev, &key.p, key.idx,
 					   key.type, mac_addr)) {
 		GENL_SET_ERR_MSG(info, "key setting validation failed");
@@ -5665,7 +5671,7 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	int err;
 	struct wireless_dev *wdev = info->user_ptr[1];
-	u8 *mac_addr = NULL;
+	const u8 *mac_addr = NULL;
 	struct key_parse key;
 	int link_id = nl80211_link_id_or_invalid(info->attrs);
 
@@ -5691,6 +5697,10 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 	}
 
+	mac_addr = cfg80211_get_key_mac_addr(wdev, 0,
+					     key.type == NL80211_KEYTYPE_PAIRWISE,
+					     mac_addr);
+
 	if (!cfg80211_valid_key_idx(wdev, key.idx, key.type, mac_addr))
 		return -EINVAL;
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index d4933bbbf0e7..d3e515db3d58 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -86,6 +86,12 @@ static inline int rdev_add_key(struct cfg80211_registered_device *rdev,
 			   mac_addr, params->mode);
 	ret = rdev->ops->add_key(&rdev->wiphy, wdev, link_id, key_index,
 				  type, mac_addr, params);
+	if (!ret &&
+	    (wdev->iftype == NL80211_IFTYPE_STATION ||
+	     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT) &&
+	    (params->cipher == WLAN_CIPHER_SUITE_WEP40 ||
+	     params->cipher == WLAN_CIPHER_SUITE_WEP104))
+		wdev->u.client.wep_used = true;
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 458f72d8351a..8320adc2a047 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -565,6 +565,7 @@ static int cfg80211_sme_connect(struct wireless_dev *wdev,
 	if (wdev->connected) {
 		cfg80211_sme_free(wdev);
 		wdev->connected = false;
+		wdev->u.client.wep_used = false;
 	}
 
 	if (wdev->conn)
@@ -1360,6 +1361,7 @@ void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 	wdev->valid_links = 0;
 	wdev->connected = false;
 	wdev->u.client.ssid_len = 0;
+	wdev->u.client.wep_used = false;
 	wdev->conn_owner_nlportid = 0;
 	kfree_sensitive(wdev->connect_keys);
 	wdev->connect_keys = NULL;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index dd166c352910..41f83577f9e7 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -274,6 +274,39 @@ bool cfg80211_cigtk_supported(struct wireless_dev *wdev,
 	return false;
 }
 
+const u8 *cfg80211_get_key_mac_addr(struct wireless_dev *wdev, u32 cipher,
+				    bool pairwise, const u8 *mac_addr)
+{
+	if (pairwise || mac_addr)
+		return mac_addr;
+
+	if (wdev->iftype != NL80211_IFTYPE_STATION &&
+	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
+		return NULL;
+
+	/*
+	 * For client side, historically the RX B/I/GTKs were set for
+	 * the AP without a MAC address parameter, just for the current
+	 * AP. With WIPHY_FLAG_CLIENT_AP_STA_GTK this has changed, and
+	 * B/I/GTK is set for RX just like other types of interfaces,
+	 * with the AP (MLD) address (for MLO the link ID was already
+	 * required.)
+	 *
+	 * For WEP, however, the address is still (required to be) NULL
+	 * since WEP keys are used for both TX and RX.
+	 */
+
+	if (!(wdev->wiphy->flags & WIPHY_FLAG_CLIENT_AP_STA_GTK))
+		return NULL;
+	if (!wdev->connected)
+		return NULL;
+	if (cipher == WLAN_CIPHER_SUITE_WEP40 ||
+	    cipher == WLAN_CIPHER_SUITE_WEP104 ||
+	    wdev->u.client.wep_used)
+		return NULL;
+	return wdev->u.client.connected_addr;
+}
+
 bool cfg80211_valid_key_idx(struct wireless_dev *wdev,
 			    int key_idx, enum nl80211_key_type type,
 			    const u8 *mac_addr)
@@ -310,7 +343,9 @@ bool cfg80211_valid_key_idx(struct wireless_dev *wdev,
 	 * For group keys, mac_addr==NULL means setting a group key
 	 * for TX, which is only supported on some interface types,
 	 * except for STATION/P2P_CLIENT, where it's setting the RX
-	 * key with the current AP (for legacy reasons.)
+	 * key with the current AP (for legacy reasons). If the
+	 * WIPHY_FLAG_CLIENT_AP_STA_GTK flag is set, userspace may
+	 * set the group key with address (except for WEP.)
 	 *
 	 * Apart from that exception, a non-NULL mac_addr means RX
 	 * key being set.
@@ -339,8 +374,12 @@ bool cfg80211_valid_key_idx(struct wireless_dev *wdev,
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
 		/* see note about exception above */
-		if (mac_addr)
+		if (mac_addr &&
+		    !(wdev->wiphy->flags & WIPHY_FLAG_CLIENT_AP_STA_GTK))
 			return false;
+		/* MAC address is OK, continue checks without */
+		if (wdev->wiphy->flags & WIPHY_FLAG_CLIENT_AP_STA_GTK)
+			mac_addr = NULL;
 		/* BIGTK support implies IGTK support */
 		if (wiphy_ext_feature_isset(wdev->wiphy,
 					    NL80211_EXT_FEATURE_BEACON_PROTECTION_CLIENT))
@@ -419,6 +458,10 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 		break;
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
+		if (mac_addr && !pairwise &&
+		    (wdev->iftype == NL80211_IFTYPE_STATION ||
+		     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT))
+			return -EINVAL;
 		if (key_idx > 3)
 			return -EINVAL;
 		break;
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index ec2389f6b8b1..5300c692355a 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -456,6 +456,9 @@ static int cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 				rejoin = true;
 			}
 
+			addr = cfg80211_get_key_mac_addr(wdev, 0, pairwise,
+							 addr);
+
 			if (!cfg80211_valid_key_idx(wdev, idx, key_type, addr))
 				err = -ENOENT;
 			else
@@ -491,6 +494,8 @@ static int cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 	if (addr)
 		tx_key = false;
 
+	addr = cfg80211_get_key_mac_addr(wdev, params->cipher, pairwise, addr);
+
 	if (cfg80211_validate_key_settings(rdev, wdev, params, idx,
 					   pairwise, addr))
 		return -EINVAL;
-- 
2.55.0

