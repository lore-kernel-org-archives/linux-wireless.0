Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:32951 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3J3F0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 01:26:53 -0400
Received: by mail-bk0-f44.google.com with SMTP id mx11so270266bkb.17
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 22:26:52 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 30 Oct 2013 13:26:52 +0800
Message-ID: <CAPgLHd9HeKEN6HjFhLgo2oogGKie5Dy++09kcr6E89LnrMc=+w@mail.gmail.com> (sfid-20131030_062656_241944_5A7FBECA)
Subject: [PATCH -next] NFC: port100: convert to use le16_add_cpu()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Convert cpu_to_le16(le16_to_cpu(E1) + E2) to use le16_add_cpu().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/nfc/port100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index 8a0571e..ab7afe3 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -493,7 +493,7 @@ static void port100_tx_update_payload_len(void *_frame, int len)
 {
 	struct port100_frame *frame = _frame;
 
-	frame->datalen = cpu_to_le16(le16_to_cpu(frame->datalen) + len);
+	le16_add_cpu(&frame->datalen, len);
 }
 
 static bool port100_rx_frame_is_valid(void *_frame)

