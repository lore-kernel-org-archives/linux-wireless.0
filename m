Return-Path: <SRS0=yVm+=OT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D04C5CFFE
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 17:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48D1D2064D
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 17:31:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HFqHq6b2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TOeD1S51"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48D1D2064D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbeLJRbD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Dec 2018 12:31:03 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37116 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbeLJRbC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Dec 2018 12:31:02 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5094360A33; Mon, 10 Dec 2018 17:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544463061;
        bh=Rm48TMtEqo+i+SNX4708GD3xygjw1+jcuWX8RW+KyRk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HFqHq6b2Mpv9JQBq3WVRdhAhUjVManZOjbFDBTUEB76K+NKs2psgi/QuS03Umkt4y
         dBAnEIDeU6/kLNgruh3uICPrAeB+eC7Y/DFQug6BASptLdU8KRgTlZU4yi+BmmhBj6
         +iyAOB189yeXgCCuy1hwOV8u76QN9/OFhMJ4kpmU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A375760115;
        Mon, 10 Dec 2018 17:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544463060;
        bh=Rm48TMtEqo+i+SNX4708GD3xygjw1+jcuWX8RW+KyRk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TOeD1S51PEhGa/xCeZbSC2yOMxN21EDj9tzBDF/7P0B0wAP4DryJkYYtkmNSrSRpM
         Ry0IadzXcXtJHiIzZlFT0kRDJmRgT3CbpiI5BnPp7g8Pz44eHl4v3ETsEElLdpbZh3
         7YEysib6B8gsmcn5KAOinpcgjB5fxW/2ibpDvBw8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A375760115
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     jacek.anaszewski@gmail.com, linux-leds@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: trigger named just "tx" in drivers/net/wireless/atmel/at76c50x-usb.c
References: <20181201143144.GC31631@amd> <87lg57f182.fsf@codeaurora.org>
        <20181209200844.GA12756@amd>
Date:   Mon, 10 Dec 2018 19:30:56 +0200
In-Reply-To: <20181209200844.GA12756@amd> (Pavel Machek's message of "Sun, 9
        Dec 2018 21:08:44 +0100")
Message-ID: <87zhtd1e7j.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> On Mon 2018-12-03 10:45:01, Kalle Valo wrote:
>> Pavel Machek <pavel@ucw.cz> writes:
>> 
>> > While grepping something else, I came across LED trigger that is named
>> > just "tx".
>> >
>> > That's a bit too generic afaict?
>> >
>> > +++ b/drivers/net/wireless/atmel/at76c50x-usb.c
>> > @@ -520,7 +520,7 @@ static int at76_usbdfu_download(struct usb_device
>> > *udev, u8 *buf, u32 size,
>> >  static int tx_activity;
>> >   static void at76_ledtrig_tx_timerfunc(struct timer_list *unused);
>> >    static DEFINE_TIMER(ledtrig_tx_timer, at76_ledtrig_tx_timerfunc);
>> >    -DEFINE_LED_TRIGGER(ledtrig_tx);
>> >    +DEFINE_LED_TRIGGER(ledtrig_tx); /* Hey! "tx" is a bit too generic
>> >    name for a trigger! */
>> 
>> This is an ancient driver, my guess is that nobody uses it anymore. I
>> should orphan it and maybe even remove it at some point.
>
> Are you willing to add a fixme there? I really don't want people to
> copy that example.

Sure, patches welcome.

-- 
Kalle Valo
