Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41801 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab1B0UyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 15:54:16 -0500
Received: by bwz15 with SMTP id 15so3223988bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Feb 2011 12:54:15 -0800 (PST)
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: [PATCH 1/2] staging: brcm80211: Add buf_size parameter to ampdu_action handler function
Date: Sun, 27 Feb 2011 21:54:14 +0100
Message-Id: <1298840055-5044-1-git-send-email-martinez.javier@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct ieee80211_ops.ampdu_action function pointer definition now includes a
u8 buf_size parameter.

Update wl_ops_ampdu_action handler function according to this new signature.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 7645c6c..345243b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -142,7 +142,8 @@ static int wl_ops_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 static int wl_ops_ampdu_action(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       enum ieee80211_ampdu_mlme_action action,
-			       struct ieee80211_sta *sta, u16 tid, u16 *ssn);
+			       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+			       u8 buf_size);
 static void wl_ops_rfkill_poll(struct ieee80211_hw *hw);
 
 static int wl_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
@@ -609,7 +610,8 @@ static int
 wl_ops_ampdu_action(struct ieee80211_hw *hw,
 		    struct ieee80211_vif *vif,
 		    enum ieee80211_ampdu_mlme_action action,
-		    struct ieee80211_sta *sta, u16 tid, u16 *ssn)
+		    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+		    u8 buf_size)
 {
 #if defined(BCMDBG)
 	struct scb *scb = (struct scb *)sta->drv_priv;
-- 
1.7.2.3

