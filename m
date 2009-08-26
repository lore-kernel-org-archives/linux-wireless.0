Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.185]:4507 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbZHZTsz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 15:48:55 -0400
Received: by gv-out-0910.google.com with SMTP id r4so5235gve.37
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 12:48:55 -0700 (PDT)
From: =?utf-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: Remove scary message from LP-PHY's Kconfig
Date: Wed, 26 Aug 2009 21:48:52 +0200
Message-Id: <1251316132-392-1-git-send-email-netrolller.3d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: root Gábor Stefanik <netrolller.3d@gmail.com>

The most common LP-PHY device, BCM4312, is now fully functional.
So, no need to say "probably won't work for you" anymore.
It's also not "for debuggers and developers only", as it is
perfectly usable for end-users now (at least for BCM4312).

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
This should only be applied once the "Qdiv roundup" and the "Fix and update"
patches reach the tree, as those 2 patches are needed to make the BCM4312
really work.

 drivers/net/wireless/b43/Kconfig |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 87d10c8..1c0999b 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -88,9 +88,6 @@ config B43_PHY_LP
 	  and embedded devices. It supports 802.11a/g
 	  (802.11a support is optional, and currently disabled).
 
-	  This is heavily experimental, and probably will not work for you.
-	  Say N unless you want to help debug the driver.
-
 # This config option automatically enables b43 LEDS support,
 # if it's possible.
 config B43_LEDS
-- 
1.5.6

