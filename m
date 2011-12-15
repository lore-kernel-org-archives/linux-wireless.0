Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:56498 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058Ab1LOLYC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 06:24:02 -0500
Date: Thu, 15 Dec 2011 14:23:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] brcm80211: smac: precendence bug in wlc_phy_attach()
Message-ID: <20111215112332.GA3906@elgon.mountain> (sfid-20111215_122421_219707_6788C077)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Negate has higher precendence than compare and since neither zero nor
one are equal to four or eight the original condition is always false.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
index 5b57caa..264f8c4 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -482,8 +482,8 @@ wlc_phy_attach(struct shared_phy *sh, struct bcma_device *d11core,
 	pi->pubpi.phy_corenum = PHY_CORE_NUM_2;
 	pi->pubpi.ana_rev = (phyversion & PV_AV_MASK) >> PV_AV_SHIFT;
 
-	if (!pi->pubpi.phy_type == PHY_TYPE_N &&
-	    !pi->pubpi.phy_type == PHY_TYPE_LCN)
+	if (pi->pubpi.phy_type != PHY_TYPE_N &&
+	    pi->pubpi.phy_type != PHY_TYPE_LCN)
 		goto err;
 
 	if (bandtype == BRCM_BAND_5G) {
