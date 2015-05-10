Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36396 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbbEJHUt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 May 2015 03:20:49 -0400
Received: by iecmd7 with SMTP id md7so11647383iec.3
        for <linux-wireless@vger.kernel.org>; Sun, 10 May 2015 00:20:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ioc3p61i.fsf@kamboji.qca.qualcomm.com>
References: <1430900994-20509-1-git-send-email-eliad@wizery.com>
	<87ioc3p61i.fsf@kamboji.qca.qualcomm.com>
Date: Sun, 10 May 2015 10:20:48 +0300
Message-ID: <CAB3XZEdb3kNjquZp4J2qxZFLW9kPjeZVMH=OQfBGapVEZ76c2w@mail.gmail.com> (sfid-20150510_092310_886299_F97E5FE9)
Subject: Re: [PATCH] wl18xx: fallback to default conf in case of invalid conf file
From: Eliad Peller <eliad@wizery.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 8, 2015 at 4:12 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Eliad Peller <eliad@wizery.com> writes:
>
> > If the wl18xx-conf.bin file is missing or invalid (e.g. due
> > to recent driver change), fallback to default configuration
> > instead of failing driver load.
> >
> > Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
> > Signed-off-by: Eliad Peller <eliad@wizery.com>
>
> This tells me that wl18xx is doing something wrong. The driver should
> still work normally even if user space is old (and vice versa). Should
> this configuration file (whatever that even is) have a version number in
> file name to handle incompatible changes in a backwards compatible
> manner?
>
the configuration file has a version number only in the header.
it is not backward compatible.

this is certainly not the optimal way to go, but since the driver will
now fallback to the default configuration, i guess it should be good
enough, and won't (completely) break current users.
(most users will use the default configuration anyway, so the conf
file is not that important)

Eliad.
