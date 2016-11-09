Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:33870 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbcKICbR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Nov 2016 21:31:17 -0500
Received: by mail-pf0-f169.google.com with SMTP id n85so117915232pfi.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2016 18:31:16 -0800 (PST)
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Cathy Luo <cluo@marvell.com>, security@kernel.org,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>
Subject: [PATCH] mwifiex: printk() overflow with 32-byte SSIDs
Date: Tue,  8 Nov 2016 18:28:24 -0800
Message-Id: <1478658504-31045-1-git-send-email-briannorris@chromium.org> (sfid-20161109_033138_214330_70BD8BCD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SSIDs aren't guaranteed to be 0-terminated. Let's cap the max length
when we print them out.

This can be easily noticed by connecting to a network with a 32-octet
SSID:

[ 3903.502925] mwifiex_pcie 0000:01:00.0: info: trying to associate to
'0123456789abcdef0123456789abcdef <uninitialized mem>' bssid
xx:xx:xx:xx:xx:xx

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Cc: <stable@vger.kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 39ce76ad00bc..16241d21727b 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2222,8 +2222,9 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len,
 			is_scanning_required = 1;
 		} else {
 			mwifiex_dbg(priv->adapter, MSG,
-				    "info: trying to associate to '%s' bssid %pM\n",
-				    (char *)req_ssid.ssid, bss->bssid);
+				    "info: trying to associate to '%.*s' bssid %pM\n",
+				    req_ssid.ssid_len, (char *)req_ssid.ssid,
+				    bss->bssid);
 			memcpy(&priv->cfg_bssid, bss->bssid, ETH_ALEN);
 			break;
 		}
@@ -2283,8 +2284,8 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	mwifiex_dbg(adapter, INFO,
-		    "info: Trying to associate to %s and bssid %pM\n",
-		    (char *)sme->ssid, sme->bssid);
+		    "info: Trying to associate to %.*s and bssid %pM\n",
+		    (int)sme->ssid_len, (char *)sme->ssid, sme->bssid);
 
 	if (!mwifiex_stop_bg_scan(priv))
 		cfg80211_sched_scan_stopped_rtnl(priv->wdev.wiphy);
@@ -2417,8 +2418,8 @@ mwifiex_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	mwifiex_dbg(priv->adapter, MSG,
-		    "info: trying to join to %s and bssid %pM\n",
-		    (char *)params->ssid, params->bssid);
+		    "info: trying to join to %.*s and bssid %pM\n",
+		    params->ssid_len, (char *)params->ssid, params->bssid);
 
 	mwifiex_set_ibss_params(priv, params);
 
-- 
2.8.0.rc3.226.g39d4020
