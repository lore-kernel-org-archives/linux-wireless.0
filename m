Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.linuxprofi.at ([93.83.54.199]:59034 "EHLO
        zimbra.linuxprofi.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751569AbdI0FUI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Sep 2017 01:20:08 -0400
Date: Wed, 27 Sep 2017 07:19:58 +0200
In-Reply-To: <1506474814-18118-1-git-send-email-miaoqing@codeaurora.org>
References: <1506474814-18118-1-git-send-email-miaoqing@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: [PATCH] ath9k: fix tx99 potential info leak
To: miaoqing@codeaurora.org, kvalo@qca.qualcomm.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        sssa@qti.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
From: =?ISO-8859-1?Q?Christoph_B=F6hmwalder?= <christoph@boehmwalder.at>
Message-ID: <01A373FA-9C6A-45B0-B793-8C87BE0DF079@boehmwalder.at> (sfid-20170927_072012_544111_5477FF15)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 27. September 2017 03:13:34 MESZ schrieb miaoqing@codeaurora.org:
>From: Miaoqing Pan <miaoqing@codeaurora.org>
>
>When the user sets count to zero the string buffer would remain
>completely uninitialized which causes the kernel to parse its
>own stack data, potentially leading to an info leak. In addition
>to that, the string might be not terminated properly when the
>user data does not contain a 0-terminator.
>
>Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
>---
> drivers/net/wireless/ath/ath9k/tx99.c | 5 +++++
> 1 file changed, 5 insertions(+)
>
>diff --git a/drivers/net/wireless/ath/ath9k/tx99.c
>b/drivers/net/wireless/ath/ath9k/tx99.c
>index 49ed1af..fe3a826 100644
>--- a/drivers/net/wireless/ath/ath9k/tx99.c
>+++ b/drivers/net/wireless/ath/ath9k/tx99.c
>@@ -179,6 +179,9 @@ static ssize_t write_file_tx99(struct file *file,
>const char __user *user_buf,
> 	ssize_t len;
> 	int r;
> 
>+	if (count < 1)
>+		return -EINVAL;
>+
> 	if (sc->cur_chan->nvifs > 1)
> 		return -EOPNOTSUPP;
> 
>@@ -186,6 +189,8 @@ static ssize_t write_file_tx99(struct file *file,
>const char __user *user_buf,
> 	if (copy_from_user(buf, user_buf, len))
> 		return -EFAULT;
> 
>+	buf[len] = '\0';
>+

I think it would be more appropriate here to check if buf[len] == '\0' and return an error otherwise.

> 	if (strtobool(buf, &start))
> 		return -EINVAL;
> 
>-- 
>1.9.1


--
Regards,
Christoph
