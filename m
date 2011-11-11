Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47767 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1KKTAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 14:00:18 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	libertas-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: release bss references and avoid warning from cfg80211_inform_bss
Date: Fri, 11 Nov 2011 13:53:29 -0500
Message-Id: <1321037609-1806-1-git-send-email-linville@tuxdriver.com> (sfid-20111111_200022_777645_D35595E5)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/net/wireless/libertas/cfg.o
drivers/net/wireless/libertas/cfg.c: In function ‘lbs_ret_scan’:
drivers/net/wireless/libertas/cfg.c:636:24: warning: ignoring return value of ‘cfg80211_inform_bss’, declared with attribute warn_unused_result
drivers/net/wireless/libertas/cfg.c: In function ‘lbs_join_post’:
drivers/net/wireless/libertas/cfg.c:1766:21: warning: ignoring return value of ‘cfg80211_inform_bss’, declared with attribute warn_unused_result

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/libertas/cfg.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 4fcd653..89f34ad 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -485,6 +485,7 @@ static int lbs_cfg_set_channel(struct wiphy *wiphy,
 static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
 	struct cmd_header *resp)
 {
+	struct cfg80211_bss *bss;
 	struct cmd_ds_802_11_scan_rsp *scanresp = (void *)resp;
 	int bsssize;
 	const u8 *pos;
@@ -632,12 +633,14 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
 				     LBS_SCAN_RSSI_TO_MBM(rssi)/100);
 
 			if (channel &&
-			    !(channel->flags & IEEE80211_CHAN_DISABLED))
-				cfg80211_inform_bss(wiphy, channel,
+			    !(channel->flags & IEEE80211_CHAN_DISABLED)) {
+				bss = cfg80211_inform_bss(wiphy, channel,
 					bssid, le64_to_cpu(*(__le64 *)tsfdesc),
 					capa, intvl, ie, ielen,
 					LBS_SCAN_RSSI_TO_MBM(rssi),
 					GFP_KERNEL);
+				cfg80211_put_bss(bss);
+			}
 		} else
 			lbs_deb_scan("scan response: missing BSS channel IE\n");
 
@@ -1720,6 +1723,7 @@ static void lbs_join_post(struct lbs_private *priv,
 		   2 + 2 +                      /* atim */
 		   2 + 8];                      /* extended rates */
 	u8 *fake = fake_ie;
+	struct cfg80211_bss *bss;
 
 	lbs_deb_enter(LBS_DEB_CFG80211);
 
@@ -1763,14 +1767,15 @@ static void lbs_join_post(struct lbs_private *priv,
 	*fake++ = 0x6c;
 	lbs_deb_hex(LBS_DEB_CFG80211, "IE", fake_ie, fake - fake_ie);
 
-	cfg80211_inform_bss(priv->wdev->wiphy,
-			    params->channel,
-			    bssid,
-			    0,
-			    capability,
-			    params->beacon_interval,
-			    fake_ie, fake - fake_ie,
-			    0, GFP_KERNEL);
+	bss = cfg80211_inform_bss(priv->wdev->wiphy,
+				  params->channel,
+				  bssid,
+				  0,
+				  capability,
+				  params->beacon_interval,
+				  fake_ie, fake - fake_ie,
+				  0, GFP_KERNEL);
+	cfg80211_put_bss(bss);
 
 	memcpy(priv->wdev->ssid, params->ssid, params->ssid_len);
 	priv->wdev->ssid_len = params->ssid_len;
-- 
1.7.4.4

