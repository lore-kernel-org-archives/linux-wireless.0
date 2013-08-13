Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2109 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758958Ab3HMUEe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 16:04:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
cc: "Arend van Spriel" <arend@broadcom.com>,
	"Jonas Gorski" <jogo@openwrt.org>,
	"David Herrmann" <dh.herrmann@gmail.com>,
	"Maximilian Engelhardt" <maxi@daemonizer.de>,
	"David Costa" <david@zarel.net>
Subject: [RFT V2 02/13] brcmsmac: change pa_gain for bcm4313 iPA
Date: Tue, 13 Aug 2013 22:03:29 +0200
Message-ID: <1376424220-10765-3-git-send-email-arend@broadcom.com> (sfid-20130813_220442_032348_842B79F2)
In-Reply-To: <1376424220-10765-1-git-send-email-arend@broadcom.com>
References: <1376424220-10765-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function wlc_lcnphy_load_tx_gain_table() has a target PA
gain specified for the iPA variant of the bcm4313. This gain
value is reduced to avoid PA distortion. The if-statement is
removed because it was rather redundant in the first place.
Please not that this patch does not provide full iPA support.

Cc: Jonas Gorski <jogo@openwrt.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: David Costa <david@zarel.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
index e646ba0..8dc5d0f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -4282,13 +4282,10 @@ wlc_lcnphy_load_tx_gain_table(struct brcms_phy *pi,
 	u16 pa_gain;
 	u16 gm_gain;
 
-	if (CHSPEC_IS5G(pi->radio_chanspec))
-		pa_gain = 0x70;
-	else
-		pa_gain = 0x70;
-
 	if (pi->sh->boardflags & BFL_FEM)
 		pa_gain = 0x10;
+	else
+		pa_gain = 0x60;
 	tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
 	tab.tbl_width = 32;
 	tab.tbl_len = 1;
-- 
1.7.10.4


