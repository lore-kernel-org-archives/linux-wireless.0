Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FROM,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DE96C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5800218D3
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:52:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bnVHxal1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388205AbeLTRwF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 12:52:05 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46118 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729481AbeLTRwF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 12:52:05 -0500
Received: by mail-ot1-f68.google.com with SMTP id w25so2668364otm.13
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2018 09:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=pjXSx+HP4l+xDGS35lFdaU738fpX39W4vfEqiPprcfs=;
        b=bnVHxal1QkJMXfQMl9Z4zUzXYUrjAagYeJMiXyXyTmFR0sVgts7r66Sn70wTBhy22Q
         QN7fcvu2Lf1YB2JZip58gcByOCNkgv1GH0dpm7vh+YjfXR4Vgl19MEPs/fmImRSKK4DD
         x281m9lHL1uj1RjCj0YYivRn28ZFILopZvudG2wIfFP54YUmvwjpPeIaMTupuTakwFXb
         vnJoKhl+J25Wzl1Fzr73AIyfY/tmQkGgxzH3gQGVvvNitD4IxdmZL1bBrkRnZ/UWhkU9
         W3lD/GRGIr9mU3bpqyKuBZHkuHFmsPrns+J3rbOuspLfP96uPFxwChS5lPH7DwBHggG4
         GwxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=pjXSx+HP4l+xDGS35lFdaU738fpX39W4vfEqiPprcfs=;
        b=dO0a+cqRsVydEf9/l31q1ksFFyk5BZrFfoAWCHwPQncMEqHJN7S8lpdbwm7BD5m/RJ
         2um79s/zd1e0OVBmzOlE/V4UFW5p16WSVIkJWAZucHaHuA9lEoCjzGpypzChEmsYrUq1
         o1o3TIQ2hup9noBtM1aWpVbJlJv0sVuRVsWDpsWDnqi4Cg2ESAyLEzwgvoBSoxFHoblS
         5qXCPw1o7SFeKN0fSN4cqH71ud/wS1dlp/jrw1UCSbXvwvUMhji31+0s21nBHRLOVdHp
         9O2WOdOYrR775xvxngy7vuThCX8YXq4i8/4MMfIWXDjWmT1TaVx44lX19PJPBUBTKfsw
         Sqjg==
X-Gm-Message-State: AA+aEWYo9zWMbcxz00OYc/suq38jGfCBGNwVKfMnqy4ZcSMfbdLYlSGZ
        MWTQJ5JFyhqMJOlfxFFwxpSbHLKScF5gaJWm6gk=
X-Google-Smtp-Source: AFSGD/USNSvvkEPtZ3M4bj4gbFHkBkUD0egqgUcPLMRd/o6kKUTqsULbRPvjs/Fc5rUY+A+klok4xH0o9OWedpR+480=
X-Received: by 2002:a9d:664f:: with SMTP id q15mr20725598otm.282.1545328324183;
 Thu, 20 Dec 2018 09:52:04 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9d:6c19:0:0:0:0:0 with HTTP; Thu, 20 Dec 2018 09:52:03
 -0800 (PST)
In-Reply-To: <1545318971-28351-3-git-send-email-sgruszka@redhat.com>
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com> <1545318971-28351-3-git-send-email-sgruszka@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Thu, 20 Dec 2018 18:52:03 +0100
Message-ID: <CAKR_QVJeteexpQX=pJm17WrrarmihYw56hKuTbsNagbcA6U96A@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] rt2x00: do not print error when queue is full
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Shouldn't you now also revert the commits from
https://git.openwrt.org/?p=openwrt/staging/dangole.git;a=commitdiff;h=de1c58a64bd66319e770d2587da07d8c9c90174a
since they caused throughput regression?

On 20/12/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> For unknown reasons printk() on some context can cause CPU hung on
> embedded MT7620 AP/router MIPS platforms. What can result on wifi
> disconnects.
>
> This patch move queue full messages to debug level what is consistent
> with other mac80211 drivers which drop packet silently if tx queue is
> full. This make MT7620 OpenWRT routers more stable, what was reported
> by various users.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2x00queue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
> b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
> index 92ddc19e7bf7..947fc8964e9a 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
> @@ -671,7 +671,7 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue,
> struct sk_buff *skb,
>  	spin_lock(&queue->tx_lock);
>
>  	if (unlikely(rt2x00queue_full(queue))) {
> -		rt2x00_err(queue->rt2x00dev, "Dropping frame due to full tx queue %d\n",
> +		rt2x00_dbg(queue->rt2x00dev, "Dropping frame due to full tx queue %d\n",
>  			   queue->qid);
>  		ret = -ENOBUFS;
>  		goto out;
> --
> 2.7.5
>
>
