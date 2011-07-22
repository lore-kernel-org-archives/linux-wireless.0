Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:56387 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab1GVKcf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 06:32:35 -0400
Received: by mail-fx0-f52.google.com with SMTP id 18so5086698fxd.11
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jul 2011 03:32:35 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2 3.1???] b43: bcma: drop BROKEN
Date: Fri, 22 Jul 2011 13:11:05 +0200
Message-Id: <1311333065-12561-2-git-send-email-zajec5@gmail.com> (sfid-20110722_123238_030389_374799D6)
In-Reply-To: <1311333065-12561-1-git-send-email-zajec5@gmail.com>
References: <1311333065-12561-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We've fixed the last issue with BCMA support which caused memory
corruption on loading and unloading b43. Support for BCMA in b43 was
tested with 14e4:4353, 14e4:4357, 14e4:4727 and 14e4:4331. First two
cards (BCM43224 and BCM43225) are supported.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
John: after fixing memory corruption we have finally stable driver for
BCMA. It works with my BCM43224 and BCM43225 cards, all the problems
seem to be resolved.

I know it's few hours after opening merge window, but maybe you could
make an exception for this patch and take it for 3.1?
---
 drivers/net/wireless/b43/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index d2293dc..3cab843 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -28,7 +28,7 @@ config B43
 
 config B43_BCMA
 	bool "Support for BCMA bus"
-	depends on B43 && BCMA && BROKEN
+	depends on B43 && BCMA
 	default y
 
 config B43_SSB
-- 
1.7.3.4

