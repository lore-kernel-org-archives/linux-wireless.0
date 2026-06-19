Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E823233ED
	for <linux-wireless@vger.kernel.org>; Fri, 19 Jun 2026 12:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781871680; cv=none; b=MpFMtHQDEjeEaq9MWYUdXtaGUXwzHkUd7r3e5A5bA5SmNrTEObytQHR+ei6zz8Twi1YGfw8Up1Suvlw3+UxirflUCfkJhJmN1sOxLEeWEZ2FK42u0suXeBtFPA+KodDSZy5c/h9xbXvNpVGEZ+gONKkS9gvPmzL7OO9oC/ajMdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781871680; c=relaxed/simple;
	bh=d23Ru1dl5KEDD43gU9puByylM0FcmzLk0fzu9oCO4ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GRKbjMnowXnKbHGwit45Bl8vnMOR7UYOqFz+z0O5Cp86Ysaf3iG97tG30mzu57/ASZyxZIiqBXv6BwDH6C1lKww5Y0eL1o7LY24NCYcK5kKYtX40MyVYpiRzNma+OUc6H94wEzO1MUh0LExdd8qT+2jvJVZzPMuHuVMyqG4fJpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=EcyazAJ6; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="EcyazAJ6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=Bv+EVBd7FbsbY9yZL993jVbP3FAWwH0raZVrEZBOFYE=; t=1781871673; x=1783081273; 
	b=EcyazAJ6AQ6KO2/R1+fDtAQ+ZlMYoIC/6z3s5pfMVpYLK1R060MazZGzKkN4DF6MRIbpqjmDBFf
	2rmZAF/ihy2BFJMHITqUcmUfkGSxB9dGskQ10WalUzCzNLbufMyi0KN4Qq5Hhq13i6/OgiWOFV/DR
	p9yeo25A+k2HWFC96JXq0vQc+WEd7dRD4Yp9AVpujqsPW9HIoLPQ5XJ7RBn96bJV7XxYcILEwv3Tt
	X1Z61WGKFDA56P3yWNCiqCGNNgcHaORfNtDvpcEb9LBnuoE34/7F8XRFrOzWxj6mXzBrHllUoZMKa
	E9TeB18RSHcPbBV+8NHDTlIKskFHws5ag+uw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1waYDd-000000071io-2Yi2;
	Fri, 19 Jun 2026 14:21:09 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: cfg80211: remove WIPHY_FLAG_DISABLE_WEXT
Date: Fri, 19 Jun 2026 14:21:07 +0200
Message-ID: <20260619142107.150f1bbe3b83.I9ff3d419bad54313c76fa4c3485148c122e67fb3@changeid>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

There are only two drivers left setting it, but they're
both also setting WIPHY_FLAG_SUPPORTS_MLO for the relevant
devices, so we can now remove WIPHY_FLAG_DISABLE_WEXT.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath12k/mac.c     | 6 ------
 drivers/net/wireless/realtek/rtw89/core.c | 3 ---
 include/net/cfg80211.h                    | 3 +--
 net/wireless/wext-core.c                  | 6 ++----
 4 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index af354bef5c0d..9775a87b3db3 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -14871,12 +14871,6 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 
 	wiphy->features |= NL80211_FEATURE_TX_POWER_INSERTION;
 
-	/* MLO is not yet supported so disable Wireless Extensions for now
-	 * to make sure ath12k users don't use it. This flag can be removed
-	 * once WIPHY_FLAG_SUPPORTS_MLO is enabled.
-	 */
-	wiphy->flags |= WIPHY_FLAG_DISABLE_WEXT;
-
 	/* Copy over MLO related capabilities received from
 	 * WMI_SERVICE_READY_EXT2_EVENT if single_chip_mlo_supp is set.
 	 */
diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 68dad6090f87..0f0e46cb4260 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -7432,9 +7432,6 @@ static int rtw89_core_register_hw(struct rtw89_dev *rtwdev)
 	if (!chip->support_rnr)
 		hw->wiphy->flags |= WIPHY_FLAG_SPLIT_SCAN_6GHZ;
 
-	if (chip->chip_gen == RTW89_CHIP_BE)
-		hw->wiphy->flags |= WIPHY_FLAG_DISABLE_WEXT;
-
 	if (rtwdev->support_mlo) {
 		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_MLO;
 		hw->wiphy->iftype_ext_capab = rtw89_iftypes_ext_capa;
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8188ad200de5..69bb864ac34d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5690,7 +5690,6 @@ struct cfg80211_ops {
  *	set this flag to update channels on beacon hints.
  * @WIPHY_FLAG_SUPPORTS_NSTR_NONPRIMARY: support connection to non-primary link
  *	of an NSTR mobile AP MLD.
- * @WIPHY_FLAG_DISABLE_WEXT: disable wireless extensions for this device
  */
 enum wiphy_flags {
 	WIPHY_FLAG_SUPPORTS_EXT_KEK_KCK		= BIT(0),
@@ -5702,7 +5701,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_4ADDR_STATION		= BIT(6),
 	WIPHY_FLAG_CONTROL_PORT_PROTOCOL	= BIT(7),
 	WIPHY_FLAG_IBSS_RSN			= BIT(8),
-	WIPHY_FLAG_DISABLE_WEXT			= BIT(9),
+	/* reuse bit 9 */
 	WIPHY_FLAG_MESH_AUTH			= BIT(10),
 	WIPHY_FLAG_SUPPORTS_EXT_KCK_32          = BIT(11),
 	WIPHY_FLAG_SUPPORTS_NSTR_NONPRIMARY	= BIT(12),
diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index c19dece2bc6e..db77912b3994 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -660,8 +660,7 @@ struct iw_statistics *get_wireless_stats(struct net_device *dev)
 	    dev->ieee80211_ptr->wiphy->wext &&
 	    dev->ieee80211_ptr->wiphy->wext->get_wireless_stats) {
 		wireless_warn_cfg80211_wext();
-		if (dev->ieee80211_ptr->wiphy->flags & (WIPHY_FLAG_SUPPORTS_MLO |
-							WIPHY_FLAG_DISABLE_WEXT))
+		if (dev->ieee80211_ptr->wiphy->flags & WIPHY_FLAG_SUPPORTS_MLO)
 			return NULL;
 		return dev->ieee80211_ptr->wiphy->wext->get_wireless_stats(dev);
 	}
@@ -703,8 +702,7 @@ static iw_handler get_handler(struct net_device *dev, unsigned int cmd)
 #ifdef CONFIG_CFG80211_WEXT
 	if (dev->ieee80211_ptr && dev->ieee80211_ptr->wiphy) {
 		wireless_warn_cfg80211_wext();
-		if (dev->ieee80211_ptr->wiphy->flags & (WIPHY_FLAG_SUPPORTS_MLO |
-							WIPHY_FLAG_DISABLE_WEXT))
+		if (dev->ieee80211_ptr->wiphy->flags & WIPHY_FLAG_SUPPORTS_MLO)
 			return NULL;
 		handlers = dev->ieee80211_ptr->wiphy->wext;
 	}
-- 
2.53.0

