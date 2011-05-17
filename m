Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34390 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab1EQQTo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 12:19:44 -0400
Received: by mail-ew0-f46.google.com with SMTP id 4so187375ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 09:19:43 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: separate ssb core reset
Date: Tue, 17 May 2011 18:57:28 +0200
Message-Id: <1305651448-23947-2-git-send-email-zajec5@gmail.com> (sfid-20110517_181947_258551_C09917C4)
In-Reply-To: <1305651448-23947-1-git-send-email-zajec5@gmail.com>
References: <1305651448-23947-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 57fd7dd..9380842 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1144,10 +1144,9 @@ void b43_power_saving_ctl_bits(struct b43_wldev *dev, unsigned int ps_flags)
 	}
 }
 
-void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags)
+static void b43_ssb_wireless_core_reset(struct b43_wldev *dev, u32 flags)
 {
 	u32 tmslow;
-	u32 macctl;
 
 	flags |= B43_TMSLOW_PHYCLKEN;
 	flags |= B43_TMSLOW_PHYRESET;
@@ -1167,6 +1166,13 @@ void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags)
 	ssb_write32(dev->sdev, SSB_TMSLOW, tmslow);
 	ssb_read32(dev->sdev, SSB_TMSLOW);	/* flush */
 	msleep(1);
+}
+
+void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags)
+{
+	u32 macctl;
+
+	b43_ssb_wireless_core_reset(dev, flags);
 
 	/* Turn Analog ON, but only if we already know the PHY-type.
 	 * This protects against very early setup where we don't know the
-- 
1.7.3.4

