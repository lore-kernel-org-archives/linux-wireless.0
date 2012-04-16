Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:41187 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab2DPURs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 16:17:48 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: [RFC PATCH 1/8] brcm80211: smac: don't set up tx power limits during initialization
Date: Mon, 16 Apr 2012 15:17:35 -0500
Message-Id: <1334607462-5387-2-git-send-email-seth.forshee@canonical.com> (sfid-20120416_221750_690684_18042E05)
In-Reply-To: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This code is unnecessary, and in fact it's never executed because the
interface is never up when brcms_c_channels_commit() is called. Removing
it helps simplify the implementation of proper regulatory support.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/channel.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 0efe88e..71fce2c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -908,7 +908,6 @@ static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 	uint chan;
-	struct txpwr_limits txpwr;
 
 	/* search for the existence of any valid channel */
 	for (chan = 0; chan < MAXCHANNEL; chan++) {
@@ -949,13 +948,6 @@ static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm)
 		wlc_phy_chanspec_ch14_widefilter_set(wlc->band->pi,
 						     brcms_c_japan(wlc) ? true :
 						     false);
-
-	if (wlc->pub->up && chan != INVCHANNEL) {
-		brcms_c_channel_reg_limits(wlc_cm, wlc->chanspec, &txpwr);
-		brcms_c_channel_min_txpower_limits_with_local_constraint(wlc_cm,
-			&txpwr, BRCMS_TXPWR_MAX);
-		wlc_phy_txpower_limit_set(wlc->band->pi, &txpwr, wlc->chanspec);
-	}
 }
 
 static int
-- 
1.7.9.5

