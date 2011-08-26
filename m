Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47152 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab1HZSsc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 14:48:32 -0400
Received: by mail-fx0-f46.google.com with SMTP id 19so2779206fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2011 11:48:31 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
	Maxime Vincent <maxime.vince@gmail.com>,
	Darren <dmbtech@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [wireless-next][PATCH 3/3] b43: make HT-PHY support experimental
Date: Fri, 26 Aug 2011 20:41:40 +0200
Message-Id: <1314384100-3492-4-git-send-email-zajec5@gmail.com> (sfid-20110826_204835_927926_16779BFB)
In-Reply-To: <1314384100-3492-2-git-send-email-zajec5@gmail.com>
References: <1314384100-3492-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was tested on three BCM4331 devices, code has been written from MMIO
dumps only, but seems to be quite stable.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index b81a2a1..0ddf0aa 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -124,12 +124,12 @@ config B43_PHY_LP
 	  (802.11a support is optional, and currently disabled).
 
 config B43_PHY_HT
-	bool "Support for HT-PHY devices (BROKEN)"
-	depends on B43 && BROKEN
+	bool "Support for HT-PHY (high throughput) devices (EXPERIMENTAL)"
+	depends on B43 && EXPERIMENTAL
 	---help---
 	  Support for the HT-PHY.
 
-	  Say N, this is BROKEN and crashes driver.
+	  Enables support for BCM4331 and possibly other chipsets with that PHY.
 
 config B43_PHY_LCN
 	bool "Support for LCN-PHY devices (BROKEN)"
-- 
1.7.1

