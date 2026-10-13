Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C2C5013A8
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896774; cv=none; b=uRmNXv3P8GpFxUQMXFD48avZK17jq5+T+39pBAcKv6xJVaR1whEQ68hEaO3UnHVFN2i/F3OYTJyNCpBWkSahhfyG+gswBITq6B6hDUKb4+yNRi6t/EL03/ln3fsEZHKue5Grk8vYPTqpj4kDEnqjOZB+aQtmq+WTMOrhpkf/zd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896774; c=relaxed/simple;
	bh=8s9Ehd4UNnH8NTFDe/FkwLfTkvjq8cxQC6TA8Q+zK5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyiG6rmCBag4lSU7e/F7rdXHqTOyzh44tSLRCQyLZQsnYR62dk32gwvTocVL7TZuJyF4GtHJD6pr2KiT/aahCWPdq+vhvvCNUzVG/SYWJrx/fPxDqXdN8yD1Pm60cFWgo+/D7jwqfTEeWH9gp2OY8wBi40MDs5Ch7Gcv39RIzAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=KovjqjAx; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="KovjqjAx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=s0d1WJzTR7naERal4ndwauwZB7sKFC8Ky7K8CS871IQ=;
	t=1791896773; x=1793106373; b=KovjqjAx7uapvrjh1Wmob9QDJncePRbTsL13fmIbShdqzsm
	s/MDcGYIh4XlPcSznVBQml2IeMPjyM5bhm0HSX8B2nZ1zqF2yfn9elFYg5fJ3kKvw/3QN1Kxd/GyL
	5AeFi+FDqIMGVVJoZDFPD/vag1+lQuoZfDypmYWSX2mm1sOzjXnH/24EBgzgDCiR+AB3Y798OLqqO
	DyKSPNsyWoDqLjFHpFHaa6poo6q+SVH58wCRQPYcANVmJC3lC5YRKhldYTnBDZxYz5F9DqK7MpUJY
	epj7Mk2loZC5+Gt5CYDO95Htn5gELO0m8u9sAwETxhewJmuRpz55pPfCEkbgFgcQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcCo-0000000HPRi-2j2b;
	Tue, 13 Oct 2026 15:06:10 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 03/11] wifi: cfg80211: support C/B/I/GTK per AP in client modes
Date: Tue, 13 Oct 2026 14:59:05 +0200
Message-ID: <20261013150604.a5da07b416e7.I344497e57aa89d9430ccdd9d386466d17064d018@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013130604.254393-13-johannes@sipsolutions.net>
References: <20261013130604.254393-13-johannes@sipsolutions.net>
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
index f773856c1818..08e340724142 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5789,6 +5789,10 @@ struct cfg80211_ops {
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
@@ -5800,7 +5804,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_4ADDR_STATION		= BIT(6),
 	WIPHY_FLAG_CONTROL_PORT_PROTOCOL	= BIT(7),
 	WIPHY_FLAG_IBSS_RSN			= BIT(8),
-	/* reuse bit 9 */
+	WIPHY_FLAG_CLIENT_AP_STA_GTK		= BIT(9),
 	WIPHY_FLAG_MESH_AUTH			= BIT(10),
 	WIPHY_FLAG_SUPPORTS_EXT_KCK_32          = BIT(11),
 	WIPHY_FLAG_SUPPORTS_NSTR_NONPRIMARY	= BIT(12),
@@ -7385,6 +7389,7 @@ struct wireless_dev {
 			u8 connected_addr[ETH_ALEN] __aligned(2);
 			u8 ssid[IEEE80211_MAX_SSID_LEN];
 			u8 ssid_len;
+			bool wep_used;
 		} client;
 		struct {
 			int beacon_interval;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index e70a4f679bf5..7318cec3a956 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -483,6 +483,8 @@ bool cfg80211_cigtk_supported(struct wireless_dev *wdev,
 bool cfg80211_valid_key_idx(struct wireless_dev *wdev,
 			    int key_idx, enum nl80211_key_type type,
 			    const u8 *mac_addr);
+const u8 *cfg80211_get_key_mac_addr(struct wireless_dev *wdev, u32 cipher,
+				    bool pairwise, const u8 *mac_addr);
 int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 				   struct wireless_dev *wdev,
 				   struct key_params *params, int key_idx,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d790e204aee3..2e296057b036 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5565,6 +5565,8 @@ static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->get_key)
 		return -EOPNOTSUPP;
 
+	mac_addr = cfg80211_get_key_mac_addr(wdev, 0, pairwise, mac_addr);
+
 	if (!cfg80211_valid_key_idx(wdev, key_idx, type, mac_addr))
 		return -ENOENT;
 
@@ -5766,6 +5768,10 @@ static int nl80211_new_key(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->add_key)
 		return -EOPNOTSUPP;
 
+	mac_addr = cfg80211_get_key_mac_addr(wdev, key.p.cipher,
+					     key.type == NL80211_KEYTYPE_PAIRWISE,
+					     mac_addr);
+
 	if (cfg80211_validate_key_settings(rdev, wdev, &key.p, key.idx,
 					   key.type, mac_addr)) {
 		GENL_SET_ERR_MSG(info, "key setting validation failed");
@@ -5795,7 +5801,7 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	int err;
 	struct wireless_dev *wdev = info->user_ptr[1];
-	u8 *mac_addr = NULL;
+	const u8 *mac_addr = NULL;
 	struct key_parse key;
 	int link_id = nl80211_link_id_or_invalid(info->attrs);
 
@@ -5821,6 +5827,10 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 	}
 
+	mac_addr = cfg80211_get_key_mac_addr(wdev, 0,
+					     key.type == NL80211_KEYTYPE_PAIRWISE,
+					     mac_addr);
+
 	if (!cfg80211_valid_key_idx(wdev, key.idx, key.type, mac_addr))
 		return -EINVAL;
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index ae15cec9bf8b..7b8440c1f697 100644
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
index fde86c900f4f..861b38eb08f2 100644
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
index 59912f4a93c8..ad0e7b279111 100644
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
2.56.0

