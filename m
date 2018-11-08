Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC503C32789
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82DDD20892
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:53:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BjgE0WYo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82DDD20892
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbeKHV20 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 16:28:26 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:39317 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbeKHV2Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 16:28:25 -0500
Received: by mail-yw1-f65.google.com with SMTP id v8-v6so6288181ywh.6
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2018 03:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:subject:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=rSk3yBjWmJqCbrcbmqfX1iJIf36P/vJpLQ+hSNiXjNs=;
        b=BjgE0WYoZpfIEQctbMMJmHV/r9EAHmrkVBI7qZC949mjLl9rtXI//wNHigQf0Hbl+w
         RGHGVvTyC03nCOAKob/FuUT5cqmTMRIn4YrMkAzWJyAjQVzmeD1XLY7T1eQy61AYSCQZ
         Xy89bLsN24z6/Fs259Ur64i790pLEXvSk3K3Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=rSk3yBjWmJqCbrcbmqfX1iJIf36P/vJpLQ+hSNiXjNs=;
        b=nHTGxEAsmfoWfD2+9Iwa2qazYuqY5aNNPdbN0spA4Otz/D7JekG3pixEr5TZM/qx+i
         FMoyWFY1CQPe8KTMjNIij2TuhrL6Op2fayFtbumy0HgtH9tWjM5Uh1cDBx0zc69crsQQ
         k5XFuUYGKuXHhIr5AVOVPXZlNZeJK59AyCLkXq85IW/oqk7i3v6WqtSmlLGFfrb/9i4z
         n6gnAXsEw2xAViGXFG1GdGKbb7gqdAi8cvlcVIpgiswGIA8aHp4b87cXbE3CUsPvq/E+
         YKQTcgsfQ1mOcX8HcVUwY+uAyN9qnM4KdeYex7gg8KtJZ+LIwAX/FpkobHNvNXg2HpJ8
         pibA==
X-Gm-Message-State: AGRZ1gLmOsy2LdwIu/gbft7Q5LtAGwBje17T0gjyqOmdR+NI+59uqNNf
        VukeCWrh4EVCaecSYnqXsix7lB9eb0QCpQ==
X-Google-Smtp-Source: AJdET5cCtSKmin2pFA/fXqplysBW17kxW3sa+jp0xcDU3G+MOq4Vvz6PNke8VQOcZipWWYtsqAkt6g==
X-Received: by 2002:a81:1d5:: with SMTP id 204-v6mr3868867ywb.111.1541677996364;
        Thu, 08 Nov 2018 03:53:16 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id r18-v6sm1098847ywa.16.2018.11.08.03.53.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Nov 2018 03:53:15 -0800 (PST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 02/11] brcmfmac: set F2 watermark to 256 for 4373
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
 <1541476188-75475-3-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Message-ID: <702baa16-c2ba-eab2-5aca-a684ca9505d0@broadcom.com>
Date:   Thu, 8 Nov 2018 12:53:13 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1541476188-75475-3-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/6/2018 4:50 AM, Chi-Hsien Lin wrote:
> From: Wright Feng <wright.feng@cypress.com>
>
> We got SDIO_CRC_ERROR with 4373 on SDR104 when doing bi-directional
> throughput test. Enable watermark to 256 to guarantee the operation
> stability.

Maybe it would be better to clarify the unit of the watermark. Here you 
use bytes, but in the register it needs number of words (word being 4 
bytes). So is this really only applicable to 4373? I have had question 
about SDIO crc errors before for other chips. Other than that....

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 25 ++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index b2e1ab5adb64..541d54661c9e 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -49,6 +49,9 @@
>  #define DCMD_RESP_TIMEOUT	msecs_to_jiffies(2500)
>  #define CTL_DONE_TIMEOUT	msecs_to_jiffies(2500)

Mention the unit so:

+/* watermark expressed in number of words */
> +#define DEFAULT_F2_WATERMARK    0x8
> +#define CY_4373_F2_WATERMARK    0x40

or

+#define DEFAULT_F2_WATERMARK	(32 >> 2)
+@define CY_4373_F2_WATERMARK   (256 >> 2)
