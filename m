Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3960 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757893Ab2BIUJ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 15:09:27 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/15] brcm80211: smac: fix unintended fallthru in
 wlc_phy_radio_init_2057()
Date: Thu, 9 Feb 2012 21:08:56 +0100
Message-ID: <1328818149-4826-3-git-send-email-arend@broadcom.com> (sfid-20120209_211007_697769_69C43B52)
In-Reply-To: <1328818149-4826-1-git-send-email-arend@broadcom.com>
References: <1328818149-4826-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The radio initialization for 2057 rev 5 was using the incorrect
register table for the initialization. This patch fixes that.

Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
index ec7450d..c27ec7a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
@@ -19989,12 +19989,11 @@ static void wlc_phy_radio_init_2057(struct brcms_phy *pi)
 		switch (pi->pubpi.radiorev) {
 		case 5:
 
-			if (pi->pubpi.radiover == 0x0)
+			if (NREV_IS(pi->pubpi.phy_rev, 8))
 				regs_2057_ptr = regs_2057_rev5;
-			else if (pi->pubpi.radiover == 0x1)
+			else if (NREV_IS(pi->pubpi.phy_rev, 9))
 				regs_2057_ptr = regs_2057_rev5v1;
-			else
-				break;
+			break;
 
 		case 7:
 
-- 
1.7.5.4


