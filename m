Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:32785 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3JURWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:22:53 -0400
Received: by mail-we0-f173.google.com with SMTP id u57so6798254wes.4
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:22:52 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 04/14] brcm80211: consolidate no-ibss and passive scan to no-ir
Date: Mon, 21 Oct 2013 19:22:28 +0200
Message-Id: <1382376158-25586-5-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_192256_171076_91965325)
In-Reply-To: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |  2 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  6 +-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  | 33 ++++-------
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  | 66 +++++++++++-----------
 4 files changed, 48 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index d7a9745..fd0a497 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -812,7 +812,7 @@ static s32 brcmf_p2p_run_escan(struct brcmf_cfg80211_info *cfg,
 			struct ieee80211_channel *chan = request->channels[i];
 
 			if (chan->flags & (IEEE80211_CHAN_RADAR |
-					   IEEE80211_CHAN_PASSIVE_SCAN))
+					   IEEE80211_CHAN_NO_IR))
 				continue;
 
 			chanspecs[i] = channel_to_chanspec(&p2p->cfg->d11inf,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 571f013..b32a8a3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -202,7 +202,7 @@ static struct ieee80211_supported_band __wl_band_5ghz_a = {
 
 /* This is to override regulatory domains defined in cfg80211 module (reg.c)
  * By default world regulatory domain defined in reg.c puts the flags
- * NL80211_RRF_PASSIVE_SCAN and NL80211_RRF_NO_IBSS for 5GHz channels (for
+ * NL80211_RRF_NO_IR for 5GHz channels (for
  * 36..48 and 149..165). With respect to these flags, wpa_supplicant doesn't
  * start p2p operations on 5GHz channels. All the changes in world regulatory
  * domain are to be done here.
@@ -5197,10 +5197,10 @@ static s32 brcmf_construct_reginfo(struct brcmf_cfg80211_info *cfg, u32 bw_cap)
 					if (channel & WL_CHAN_RADAR)
 						band_chan_arr[index].flags |=
 							(IEEE80211_CHAN_RADAR |
-							IEEE80211_CHAN_NO_IBSS);
+							 IEEE80211_CHAN_NO_IR);
 					if (channel & WL_CHAN_PASSIVE)
 						band_chan_arr[index].flags |=
-						    IEEE80211_CHAN_PASSIVE_SCAN;
+						    IEEE80211_CHAN_NO_IR;
 				}
 			}
 			if (!update)
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index cc87926..c99364f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -59,23 +59,18 @@
 
 #define BRCM_2GHZ_2412_2462	REG_RULE(2412-10, 2462+10, 40, 0, 19, 0)
 #define BRCM_2GHZ_2467_2472	REG_RULE(2467-10, 2472+10, 20, 0, 19, \
-					 NL80211_RRF_PASSIVE_SCAN | \
-					 NL80211_RRF_NO_IBSS)
+					 NL80211_RRF_NO_IR)
 
 #define BRCM_5GHZ_5180_5240	REG_RULE(5180-10, 5240+10, 40, 0, 21, \
-					 NL80211_RRF_PASSIVE_SCAN | \
-					 NL80211_RRF_NO_IBSS)
+					 NL80211_RRF_NO_IR)
 #define BRCM_5GHZ_5260_5320	REG_RULE(5260-10, 5320+10, 40, 0, 21, \
-					 NL80211_RRF_PASSIVE_SCAN | \
 					 NL80211_RRF_DFS | \
-					 NL80211_RRF_NO_IBSS)
+					 NL80211_RRF_NO_IR)
 #define BRCM_5GHZ_5500_5700	REG_RULE(5500-10, 5700+10, 40, 0, 21, \
-					 NL80211_RRF_PASSIVE_SCAN | \
 					 NL80211_RRF_DFS | \
-					 NL80211_RRF_NO_IBSS)
+					 NL80211_RRF_NO_IR)
 #define BRCM_5GHZ_5745_5825	REG_RULE(5745-10, 5825+10, 40, 0, 21, \
-					 NL80211_RRF_PASSIVE_SCAN | \
-					 NL80211_RRF_NO_IBSS)
+					 NL80211_RRF_NO_IR)
 
 static const struct ieee80211_regdomain brcms_regdom_x2 = {
 	.n_reg_rules = 6,
@@ -395,7 +390,7 @@ brcms_c_channel_set_chanspec(struct brcms_cm_info *wlc_cm, u16 chanspec,
 		brcms_c_set_gmode(wlc, wlc->protection->gmode_user, false);
 
 	brcms_b_set_chanspec(wlc->hw, chanspec,
-			      !!(ch->flags & IEEE80211_CHAN_PASSIVE_SCAN),
+			      !!(ch->flags & IEEE80211_CHAN_NO_IR),
 			      &txpwr);
 }
 
@@ -657,8 +652,7 @@ static void brcms_reg_apply_radar_flags(struct wiphy *wiphy)
 		 */
 		if (!(ch->flags & IEEE80211_CHAN_DISABLED))
 			ch->flags |= IEEE80211_CHAN_RADAR |
-				     IEEE80211_CHAN_NO_IBSS |
-				     IEEE80211_CHAN_PASSIVE_SCAN;
+				     IEEE80211_CHAN_NO_IR;
 	}
 }
 
@@ -688,15 +682,10 @@ brcms_reg_apply_beaconing_flags(struct wiphy *wiphy,
 				if (IS_ERR(rule))
 					continue;
 
-				if (!(rule->flags & NL80211_RRF_NO_IBSS))
-					ch->flags &= ~IEEE80211_CHAN_NO_IBSS;
-				if (!(rule->flags & NL80211_RRF_PASSIVE_SCAN))
-					ch->flags &=
-						~IEEE80211_CHAN_PASSIVE_SCAN;
-			} else if (ch->beacon_found) {
-				ch->flags &= ~(IEEE80211_CHAN_NO_IBSS |
-					       IEEE80211_CHAN_PASSIVE_SCAN);
-			}
+				if (!(rule->flags & NL80211_RRF_NO_IR))
+					ch->flags &= ~IEEE80211_CHAN_NO_IR;
+			} else if (ch->beacon_found)
+				ch->flags &= ~IEEE80211_CHAN_NO_IR;
 		}
 	}
 }
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index edc5d10..15283e0 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -125,13 +125,13 @@ static struct ieee80211_channel brcms_2ghz_chantable[] = {
 	CHAN2GHZ(10, 2457, IEEE80211_CHAN_NO_HT40PLUS),
 	CHAN2GHZ(11, 2462, IEEE80211_CHAN_NO_HT40PLUS),
 	CHAN2GHZ(12, 2467,
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_IBSS |
+		 IEEE80211_CHAN_NO_IR |
 		 IEEE80211_CHAN_NO_HT40PLUS),
 	CHAN2GHZ(13, 2472,
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_IBSS |
+		 IEEE80211_CHAN_NO_IR |
 		 IEEE80211_CHAN_NO_HT40PLUS),
 	CHAN2GHZ(14, 2484,
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_IBSS |
+		 IEEE80211_CHAN_NO_IR |
 		 IEEE80211_CHAN_NO_HT40PLUS | IEEE80211_CHAN_NO_HT40MINUS |
 		 IEEE80211_CHAN_NO_OFDM)
 };
@@ -144,51 +144,51 @@ static struct ieee80211_channel brcms_5ghz_nphy_chantable[] = {
 	CHAN5GHZ(48, IEEE80211_CHAN_NO_HT40PLUS),
 	/* UNII-2 */
 	CHAN5GHZ(52,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IR |
+		 IEEE80211_CHAN_NO_HT40MINUS),
 	CHAN5GHZ(56,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IR |
+		 IEEE80211_CHAN_NO_HT40PLUS),
 	CHAN5GHZ(60,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IR |
+		 IEEE80211_CHAN_NO_HT40MINUS),
 	CHAN5GHZ(64,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IR |
+		 IEEE80211_CHAN_NO_HT40PLUS),
 	/* MID */
 	CHAN5GHZ(100,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IR |
+		 IEEE80211_CHAN_NO_HT40MINUS),
 	CHAN5GHZ(104,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IR |
+		 IEEE80211_CHAN_NO_HT40PLUS),
 	CHAN5GHZ(108,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IR |
+		 IEEE80211_CHAN_NO_HT40MINUS),
 	CHAN5GHZ(112,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IR |
+		 IEEE80211_CHAN_NO_HT40PLUS),
 	CHAN5GHZ(116,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IR |
+		 IEEE80211_CHAN_NO_HT40MINUS),
 	CHAN5GHZ(120,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IR |
+		 IEEE80211_CHAN_NO_HT40PLUS),
 	CHAN5GHZ(124,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IR |
+		 IEEE80211_CHAN_NO_HT40MINUS),
 	CHAN5GHZ(128,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IR |
+		 IEEE80211_CHAN_NO_HT40PLUS),
 	CHAN5GHZ(132,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IR |
+		 IEEE80211_CHAN_NO_HT40MINUS),
 	CHAN5GHZ(136,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IR |
+		 IEEE80211_CHAN_NO_HT40PLUS),
 	CHAN5GHZ(140,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS |
+		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IR |
+		 IEEE80211_CHAN_NO_HT40PLUS |
 		 IEEE80211_CHAN_NO_HT40MINUS),
 	/* UNII-3 */
 	CHAN5GHZ(149, IEEE80211_CHAN_NO_HT40MINUS),
-- 
1.8.4.rc3

