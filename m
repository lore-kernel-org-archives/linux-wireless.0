Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbcFWSf5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 14:35:57 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Luis de Bethencourt <luisbg@osg.samsung.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 1/4] rtl8xxxu: remove unneeded assignments
Date: Thu, 23 Jun 2016 14:35:52 -0400
Message-Id: <1466706955-10339-2-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160623_203605_257408_425DC162)
In-Reply-To: <1466706955-10339-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1466706955-10339-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis de Bethencourt <luisbg@osg.samsung.com>

reg_eac and reg_ecc are only used if candidate is bigger than 0, and in
that case new values will be given to them. Removing the unused
assignments.

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
index 5b825fa..9a1994f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
@@ -1244,11 +1244,9 @@ static void rtl8192eu_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 		reg_e94 = result[i][0];
 		reg_e9c = result[i][1];
 		reg_ea4 = result[i][2];
-		reg_eac = result[i][3];
 		reg_eb4 = result[i][4];
 		reg_ebc = result[i][5];
 		reg_ec4 = result[i][6];
-		reg_ecc = result[i][7];
 	}
 
 	if (candidate >= 0) {
-- 
2.7.4

