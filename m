Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:26023 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400Ab2ENU5x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 16:57:53 -0400
Date: Mon, 14 May 2012 23:57:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Brett Rudley <brudley@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] brcm80211: remove an unneeded NULL check
Message-ID: <20120514205729.GD20836@elgon.mountain> (sfid-20120514_225757_851251_915DAE6F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This code causes a static checker warning because "pi" gets dereferenced
before it is checked.  The dereference is inside the write_phy_reg()
function which is called from wlc_phy_write_txmacreg_nphy().

This code is only called from wlc_phy_init_nphy() and "pi" is a
valid pointer so we can remove the check for NULL.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
index 812b6e3..d6380f3 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
@@ -14358,7 +14358,7 @@ void wlc_phy_nphy_tkip_rifs_war(struct brcms_phy *pi, u8 rifs)
 
 	wlc_phy_write_txmacreg_nphy(pi, holdoff, delay);
 
-	if (pi && pi->sh && (pi->sh->_rifs_phy != rifs))
+	if (pi->sh && (pi->sh->_rifs_phy != rifs))
 		pi->sh->_rifs_phy = rifs;
 }
 
