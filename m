Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51220 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab0LZL4l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 06:56:41 -0500
Received: by qyj19 with SMTP id 19so9608123qyj.19
        for <linux-wireless@vger.kernel.org>; Sun, 26 Dec 2010 03:56:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101226112414.31775.62053.stgit@fate.lan>
References: <20101226112404.31775.77854.stgit@fate.lan>
	<20101226112414.31775.62053.stgit@fate.lan>
Date: Sun, 26 Dec 2010 12:56:40 +0100
Message-ID: <AANLkTinY7jdtrr85qnm-HP6BLMR++F=Ouem7U=vYBW40@mail.gmail.com>
Subject: Re: [RFC PATCH 1/6] zd1211rw: fix beacon interval setup
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	zd1211-devs@lists.sourceforge.net,
	Ulrich Kunitz <kune@deine-taler.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/26 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>:
> Vendor driver uses CR_BNC_INTERVAL at various places, one is HW_EnableBeacon()
> that combinies beacon interval with BSS-type flag and DTIM value in upper
> 16bit of u32. The other one is HW_UpdateBcnInterval() that set_aw_pt_bi()
> appears to be based on. HW_UpdateBcnInterval() takes interval argument as u16
> and uses that for calculations, set_aw_pt_bi() uses u32 value that has flags
> and dtim in upper part. This clearly seems wrong. Also HW_UpdateBcnInterval()
> updates only lower 16bit part of CR_BNC_INTERVAL.
>
> So make set_aw_pt_bi() do calculations on only lower u16 part of
> s->beacon_interval.

It seems correct, we have for example:
#define BCN_MODE_IBSS			0x2000000
which can be set in beacon_interval.

AFAICS pre_tbtt should contain only interval, without additional flags.

Do I get it right?


>        if (s->pre_tbtt < 4 || s->pre_tbtt >= s->beacon_interval)
> -               s->pre_tbtt = s->beacon_interval - 1;
> +               s->pre_tbtt = (s->beacon_interval & 0xffff) - 1;

So if I am right, in condition here you should extract interval from
beacon_interval and compare it with pre_tbtt. Extracting from pre_tbtt
should not be needed, as it's plain interval.

Maybe use some local variable like
b_interval = s->beacon_interval & 0xffff
?

-- 
Rafał
