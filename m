Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2158 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab1IBOA6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 10:00:58 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 06/12] staging: brcm80211: cleaned up softmac phy
 macro's affecting code flow
Date: Fri, 2 Sep 2011 16:00:33 +0200
Message-ID: <1314972039-27098-7-git-send-email-rvossen@broadcom.com> (sfid-20110902_160124_542756_6115A351)
In-Reply-To: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
References: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Substituted macro's.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |    6 ++++--
 drivers/staging/brcm80211/brcmsmac/types.h       |    5 -----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index b52b305..5f30de2 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -204,7 +204,8 @@ u16 read_radio_reg(struct brcms_phy *pi, u16 addr)
 
 	switch (pi->pubpi.phy_type) {
 	case PHY_TYPE_N:
-		CASECHECK(PHYTYPE, PHY_TYPE_N);
+		if (!CONF_HAS(PHYTYPE, PHY_TYPE_N))
+			break;
 		if (NREV_GE(pi->pubpi.phy_rev, 7))
 			addr |= RADIO_2057_READ_OFF;
 		else
@@ -212,7 +213,8 @@ u16 read_radio_reg(struct brcms_phy *pi, u16 addr)
 		break;
 
 	case PHY_TYPE_LCN:
-		CASECHECK(PHYTYPE, PHY_TYPE_LCN);
+		if (!CONF_HAS(PHYTYPE, PHY_TYPE_LCN))
+			break;
 		addr |= RADIO_2064_READ_OFF;
 		break;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index cf65f6e..792df07 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -220,11 +220,6 @@
 #define PHYTYPE_IS(var, val)\
 	(PHYCONF_HAS(val) && (PHYCONF_IS(val) || ((var) == (val))))
 
-/* Finally, early-exit from switch case if anyone wants it... */
-
-#define CASECHECK(config, val)	if (!(CONF_HAS(config, val))) break
-#define CASEMSK(config, mask)	if (!(CONF_MSK(config, mask))) break
-
 /* Set up PHYTYPE automatically: (depends on PHY_TYPE_X, from d11.h) */
 
 #define _PHYCONF_N (1 << PHY_TYPE_N)
-- 
1.7.4.1


