Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D5CC65BAE
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 08:45:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6043F20851
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 08:45:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="M6Jd/Sr8";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="M6Jd/Sr8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6043F20851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbeLCIpK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 03:45:10 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60400 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbeLCIpK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 03:45:10 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DDE4C60913; Mon,  3 Dec 2018 08:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543826705;
        bh=EtYLzU1ajrf3/fwS+ZTOxjyFYlygKmdJmqDJNCFkZdA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=M6Jd/Sr8vIcsXoReS9pEE1xNCNnqMdq9Sj+uY2ZHplOvPZXoLy9CzkSyhmEZ/vFva
         fZvX5VuNz518M4as40wZCXxBy6W9VF/xmQG/kW2tYULQCDvHtrzHLX7f4okNyMoRUA
         C/cyGy/INRRL1xMHS5QfLVv0EDyTEUoVNZJ/rroA=
Received: from x230.qca.qualcomm.com (37-33-92-201.bb.dnainternet.fi [37.33.92.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3847A60350;
        Mon,  3 Dec 2018 08:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543826705;
        bh=EtYLzU1ajrf3/fwS+ZTOxjyFYlygKmdJmqDJNCFkZdA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=M6Jd/Sr8vIcsXoReS9pEE1xNCNnqMdq9Sj+uY2ZHplOvPZXoLy9CzkSyhmEZ/vFva
         fZvX5VuNz518M4as40wZCXxBy6W9VF/xmQG/kW2tYULQCDvHtrzHLX7f4okNyMoRUA
         C/cyGy/INRRL1xMHS5QfLVv0EDyTEUoVNZJ/rroA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3847A60350
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     jacek.anaszewski@gmail.com, linux-leds@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: trigger named just "tx" in drivers/net/wireless/atmel/at76c50x-usb.c
References: <20181201143144.GC31631@amd>
Date:   Mon, 03 Dec 2018 10:45:01 +0200
In-Reply-To: <20181201143144.GC31631@amd> (Pavel Machek's message of "Sat, 1
        Dec 2018 15:31:44 +0100")
Message-ID: <87lg57f182.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> While grepping something else, I came across LED trigger that is named
> just "tx".
>
> That's a bit too generic afaict?
>
> +++ b/drivers/net/wireless/atmel/at76c50x-usb.c
> @@ -520,7 +520,7 @@ static int at76_usbdfu_download(struct usb_device
> *udev, u8 *buf, u32 size,
>  static int tx_activity;
>   static void at76_ledtrig_tx_timerfunc(struct timer_list *unused);
>    static DEFINE_TIMER(ledtrig_tx_timer, at76_ledtrig_tx_timerfunc);
>    -DEFINE_LED_TRIGGER(ledtrig_tx);
>    +DEFINE_LED_TRIGGER(ledtrig_tx); /* Hey! "tx" is a bit too generic
>    name for a trigger! */

This is an ancient driver, my guess is that nobody uses it anymore. I
should orphan it and maybe even remove it at some point.

-- 
Kalle Valo
