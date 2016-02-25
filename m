Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.11]:52939 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbcBYXDQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 18:03:16 -0500
In-Reply-To: <1456439339-18458-1-git-send-email-colin.king@canonical.com>
References: <1456439339-18458-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] mt7601u: do not free dma_buf when ivp allocation fails
From: Kuba Kicinski <kubakici@wp.pl>
Date: Thu, 25 Feb 2016 17:56:26 -0500
To: Colin King <colin.king@canonical.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org
Message-ID: <63E1009A-F983-4D81-82AE-B4C6E4D060B5@wp.pl> (sfid-20160226_000320_965356_A16D387E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 February 2016 17:28:59 GMT-05:00, Colin King <colin.king@canonical.com> wrote:
>From: Colin Ian King <colin.king@canonical.com>
>
>If the allocation of ivp fails the error handling attempts to
>free an uninitialized dma_buf; this data structure just contains
>garbage on the stack, so the freeing will cause issues when the
>urb, buf and dma fields are cleaned. Fix this by handling the
>ivp check and

Commit message looks truncated?

>Signed-off-by: Colin Ian King <colin.king@canonical.com>
>---
> drivers/net/wireless/mediatek/mt7601u/mcu.c | 11 ++++++-----
> 1 file changed, 6 insertions(+), 5 deletions(-)
>
>diff --git a/drivers/net/wireless/mediatek/mt7601u/mcu.c
>b/drivers/net/wireless/mediatek/mt7601u/mcu.c
>index fbb1986..06ac657 100644
>--- a/drivers/net/wireless/mediatek/mt7601u/mcu.c
>+++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
>@@ -359,13 +359,13 @@ mt7601u_upload_firmware(struct mt7601u_dev *dev,
>const struct mt76_fw *fw)
> 	struct mt7601u_dma_buf dma_buf;
> 	void *ivb;
> 	u32 ilm_len, dlm_len;
>-	int i, ret;
>+	int i, ret = -ENOMEM;

No need...

> 
> 	ivb = kmemdup(fw->ivb, sizeof(fw->ivb), GFP_KERNEL);
>-	if (!ivb || mt7601u_usb_alloc_buf(dev, MCU_FW_URB_SIZE, &dma_buf)) {
>-		ret = -ENOMEM;
>+	if (!ivb)
>+		goto error_ivb;

...just return -ENOMEM here, because...

>+error_ivb:
>+	kfree(ivb);

...calling kfree on a null pointer is redundant.

Thanks!!
[trimming To/CC a bit]
