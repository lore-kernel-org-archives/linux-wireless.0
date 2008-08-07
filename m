Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:41626 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYHGIUx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 04:20:53 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: swap short slot time dcf values
Date: Thu, 7 Aug 2008 10:22:28 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808071022.29289.chunkeey@web.de> (sfid-20080807_102058_947724_70E4499A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

these "magic" values must to be the other way round...

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---

--- a/drivers/net/wireless/p54/p54common.c	2008-08-07 00:37:18.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-08-07 09:01:34.000000000 +0200
@@ -803,8 +803,8 @@ static void p54_set_vdcf(struct ieee8021
 
 	if (dev->conf.flags & IEEE80211_CONF_SHORT_SLOT_TIME) {
 		vdcf->slottime = 9;
-		vdcf->magic1 = 0x00;
-		vdcf->magic2 = 0x10;
+		vdcf->magic1 = 0x10;
+		vdcf->magic2 = 0x00;
 	} else {
 		vdcf->slottime = 20;
 		vdcf->magic1 = 0x0a;

