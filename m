Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:10605 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751208AbdJDJtY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 05:49:24 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "silexcommon@gmail.com" <silexcommon@gmail.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Alagu Sankar <alagusankar@silex-india.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 08/11] ath10k_sdio: common read write
Date: Wed, 4 Oct 2017 09:49:18 +0000
Message-ID: <87wp4bw8de.fsf@kamboji.qca.qualcomm.com> (sfid-20171004_114927_596666_B337A984)
References: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
        <1506793068-27445-9-git-send-email-alagusankar@silex-india.com>
In-Reply-To: <1506793068-27445-9-git-send-email-alagusankar@silex-india.com>
        (silexcommon@gmail.com's message of "Sat, 30 Sep 2017 23:07:45 +0530")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

silexcommon@gmail.com writes:

> From: Alagu Sankar <alagusankar@silex-india.com>
>
> convert different read write functions in sdio hif to bring it under a
> single read-write path. This helps in having a common dma bounce buffer
> implementation. Also helps in address modification that is required
> specific to change in certain mbox addresses of sdio_write.
>
> Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>

This didn't compile for me:

drivers/net/wireless/ath/ath10k/sdio.c:320:12: error: conflicting types for=
 'ath10k_sdio_read'
drivers/net/wireless/ath/ath10k/sdio.c:39:12: note: previous declaration of=
 'ath10k_sdio_read' was here
drivers/net/wireless/ath/ath10k/sdio.c:365:12: error: conflicting types for=
 'ath10k_sdio_write'
drivers/net/wireless/ath/ath10k/sdio.c:41:12: note: previous declaration of=
 'ath10k_sdio_write' was here
drivers/net/wireless/ath/ath10k/sdio.c:39:12: warning: 'ath10k_sdio_read' u=
sed but never defined
drivers/net/wireless/ath/ath10k/sdio.c:41:12: warning: 'ath10k_sdio_write' =
used but never defined

gcc (Ubuntu 5.4.0-6ubuntu1~16.04.4) 5.4.0 20160609

I fixed it like below in the pending branch. But I'll review more
carefully later, I have quite a lot of patches pending right now.

--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -37,9 +37,9 @@
 #define ATH10K_SDIO_DMA_BUF_SIZE       (32 * 1024)
=20
 static int ath10k_sdio_read(struct ath10k *ar, u32 addr, void *buf,
-                           u32 len, bool incr);
+                           size_t len, bool incr);
 static int ath10k_sdio_write(struct ath10k *ar, u32 addr, const void *buf,
-                            u32 len, bool incr);
+                            size_t len, bool incr);
=20
 /* inlined helper functions */

--=20
Kalle Valo=
