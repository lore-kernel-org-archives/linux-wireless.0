Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:34451 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbcDRTtL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 15:49:11 -0400
Received: by mail-qg0-f53.google.com with SMTP id c6so124733050qga.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2016 12:49:11 -0700 (PDT)
From: Geoff Lansberry <geoff@kuvee.com>
To: linux-wireless@vger.kernel.org
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, mgreer@animalcreek.com, justin@kuvee.com,
	Geoff Lansberry <geoff@kuvee.com>
Subject: [PATCH 2/4] NFC: trf7970a: add TI recommended write of zero to Register 0x18
Date: Mon, 18 Apr 2016 15:48:39 -0400
Message-Id: <1461008921-15100-3-git-send-email-geoff@kuvee.com> (sfid-20160418_214915_290560_47CA7030)
In-Reply-To: <1461008921-15100-1-git-send-email-geoff@kuvee.com>
References: <1461008921-15100-1-git-send-email-geoff@kuvee.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Geoff Lansberry <geoff@kuvee.com>
---
 drivers/nfc/trf7970a.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 2c3530a..447b6c9 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -1064,6 +1064,10 @@ static int trf7970a_init(struct trf7970a *trf)
 	if (ret)
 		goto err_out;
 
+	ret = trf7970a_write(trf, TRF7970A_NFC_TARGET_LEVEL, 0);
+	if (ret)
+		goto err_out;
+
 	usleep_range(1000, 2000);
 
 	trf->chip_status_ctrl &= ~TRF7970A_CHIP_STATUS_RF_ON;
-- 
1.9.1

