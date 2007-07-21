Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:64707 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755159AbXGUVmE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jul 2007 17:42:04 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw: fix filter for PSPOLL frames
Message-Id: <20070721214202.E180B7B409F@zog.reactivated.net>
Date: Sat, 21 Jul 2007 22:42:02 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ulrich Kunitz <kune@deine-taler.de>

While filling the control set the driver tests for a PSPOLL frame.
But it tested only the subtype of the packet. The full type needs
to be tested to identify those packets reliably.

[dsd@gentoo.org: backport to mainline]
Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 zd_mac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Index: linux/drivers/net/wireless/zd1211rw/zd_mac.c
===================================================================
--- linux.orig/drivers/net/wireless/zd1211rw/zd_mac.c
+++ linux/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -822,7 +822,7 @@ static void cs_set_control(struct zd_mac
 		cs->control |= ZD_CS_MULTICAST;
 
 	/* PS-POLL */
-	if (stype == IEEE80211_STYPE_PSPOLL)
+	if (ftype == IEEE80211_FTYPE_CTL && stype == IEEE80211_STYPE_PSPOLL)
 		cs->control |= ZD_CS_PS_POLL_FRAME;
 
 	/* Unicast data frames over the threshold should have RTS */
