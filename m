Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway30.websitewelcome.com ([192.185.179.30]:18775 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1030441AbeEYV7U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 17:59:20 -0400
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 6883415426
        for <linux-wireless@vger.kernel.org>; Fri, 25 May 2018 16:39:01 -0500 (CDT)
Date: Fri, 25 May 2018 16:38:54 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] mwifiex: mark expected switch fall-throughs
Message-ID: <20180525213854.GA13392@embeddedor.com> (sfid-20180525_235933_764502_094BDD76)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 4 ++++
 drivers/net/wireless/marvell/mwifiex/scan.c     | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 54a2297..16a705d 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -1158,6 +1158,7 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		case NL80211_IFTYPE_UNSPECIFIED:
 			mwifiex_dbg(priv->adapter, INFO,
 				    "%s: kept type as IBSS\n", dev->name);
+			/* fall through */
 		case NL80211_IFTYPE_ADHOC:	/* This shouldn't happen */
 			return 0;
 		default:
@@ -1188,6 +1189,7 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		case NL80211_IFTYPE_UNSPECIFIED:
 			mwifiex_dbg(priv->adapter, INFO,
 				    "%s: kept type as STA\n", dev->name);
+			/* fall through */
 		case NL80211_IFTYPE_STATION:	/* This shouldn't happen */
 			return 0;
 		default:
@@ -1210,6 +1212,7 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		case NL80211_IFTYPE_UNSPECIFIED:
 			mwifiex_dbg(priv->adapter, INFO,
 				    "%s: kept type as AP\n", dev->name);
+			/* fall through */
 		case NL80211_IFTYPE_AP:		/* This shouldn't happen */
 			return 0;
 		default:
@@ -1249,6 +1252,7 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		case NL80211_IFTYPE_UNSPECIFIED:
 			mwifiex_dbg(priv->adapter, INFO,
 				    "%s: kept type as P2P\n", dev->name);
+			/* fall through */
 		case NL80211_IFTYPE_P2P_CLIENT:
 		case NL80211_IFTYPE_P2P_GO:
 			return 0;
diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index d7ce7f7..19df92b 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1308,6 +1308,7 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 
 		case WLAN_EID_CHANNEL_SWITCH:
 			bss_entry->chan_sw_ie_present = true;
+			/* fall through */
 		case WLAN_EID_PWR_CAPABILITY:
 		case WLAN_EID_TPC_REPORT:
 		case WLAN_EID_QUIET:
-- 
2.7.4
