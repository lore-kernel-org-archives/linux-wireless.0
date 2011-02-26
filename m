Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44949 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab1BZBdX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 20:33:23 -0500
Received: by mail-yw0-f46.google.com with SMTP id 3so667885ywj.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Feb 2011 17:33:23 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>
Subject: [PATCH 4/5] nl80211: New constant definitions for SAE
Date: Fri, 25 Feb 2011 17:32:39 -0800
Message-Id: <1298683960-20835-5-git-send-email-thomas@cozybit.com>
In-Reply-To: <1298683960-20835-1-git-send-email-thomas@cozybit.com>
References: <1298683960-20835-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

---
 include/linux/nl80211.h |    2 ++
 net/mac80211/mlme.c     |    3 +++
 net/wireless/nl80211.c  |    3 ++-
 3 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 7f53bdf..528cd4c 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1814,6 +1814,7 @@ enum nl80211_bss_status {
  * @NL80211_AUTHTYPE_SHARED_KEY: Shared Key authentication (WEP only)
  * @NL80211_AUTHTYPE_FT: Fast BSS Transition (IEEE 802.11r)
  * @NL80211_AUTHTYPE_NETWORK_EAP: Network EAP (some Cisco APs and mainly LEAP)
+ * @NL80211_AUTHTYPE_SAE: Simultaneous Authentication of Equals
  * @__NL80211_AUTHTYPE_NUM: internal
  * @NL80211_AUTHTYPE_MAX: maximum valid auth algorithm
  * @NL80211_AUTHTYPE_AUTOMATIC: determine automatically (if necessary by
@@ -1825,6 +1826,7 @@ enum nl80211_auth_type {
 	NL80211_AUTHTYPE_SHARED_KEY,
 	NL80211_AUTHTYPE_FT,
 	NL80211_AUTHTYPE_NETWORK_EAP,
+	NL80211_AUTHTYPE_SAE,
 
 	/* keep last */
 	__NL80211_AUTHTYPE_NUM,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f77adf1..2dbe703 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2260,6 +2260,9 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	case NL80211_AUTHTYPE_NETWORK_EAP:
 		auth_alg = WLAN_AUTH_LEAP;
 		break;
+	case NL80211_AUTHTYPE_SAE:
+		auth_alg = WLAN_AUTH_SAE;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dc21ab5..4651bcf 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3591,7 +3591,8 @@ static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
 		return -EOPNOTSUPP;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT)
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT)
 		return -EOPNOTSUPP;
 
 	bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
-- 
1.7.0.4

