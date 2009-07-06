Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:58226 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbZGFUUt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 16:20:49 -0400
Received: by fxm18 with SMTP id 18so4413350fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jul 2009 13:20:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1246900337.20908.15.camel@johannes.local>
References: <f76a32050907061006k3bed082fg3428a50370b0889b@mail.gmail.com>
	 <1246900337.20908.15.camel@johannes.local>
Date: Mon, 6 Jul 2009 22:20:51 +0200
Message-ID: <f76a32050907061320n18f3c4c9j4d5589c9c9e45c02@mail.gmail.com>
Subject: Re: rt73 in AP mode: PS frames buffered but missing TIM bit?
From: Stefan Steuerwald <salsasepp@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/7/6 Johannes Berg <johannes@sipsolutions.net>
>
> On Mon, 2009-07-06 at 19:06 +0200, Stefan Steuerwald wrote:
> >
> > Summary:
> > - I suspect a missing TIM bit when using rt73 in AP mode with my
> > powersaving iPod Touch.
> > - Despite frames being buffered no TIM bit is getting set (I thought
> > it should), station stays asleep.
>
> Sounds like a driver problem, it must not be reacting to set_tim()
> properly.
>
> johannes

Looking at rt73usb.c:2242, there isn't any initializer for .set_tim .
Plausible explanation.
It may be totally beyond me to just implement it. Let me find someone
to ask nicely ;-) ...
