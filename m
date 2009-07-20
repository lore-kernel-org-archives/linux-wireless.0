Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f173.google.com ([209.85.221.173]:41702 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbZGTQfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2009 12:35:08 -0400
Received: by qyk3 with SMTP id 3so188293qyk.33
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2009 09:35:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ABEC48F218774102B9939CE6F5F5F856@Emiel>
References: <ABEC48F218774102B9939CE6F5F5F856@Emiel>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 20 Jul 2009 09:34:46 -0700
Message-ID: <43e72e890907200934o319e20d2y825592207b75b0f4@mail.gmail.com>
Subject: Re: Enabling and disabling Atheros AR9258 wireless card
To: Emiel Bruijntjes <emiel@bruijntjes.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 19, 2009 at 6:41 AM, Emiel Bruijntjes<emiel@bruijntjes.net> wrote:
>
> Hi,
>
> I hope this is the right channel to report a bug/feature-request.
>
> My laptop (Toshiba NB200) uses a Atheros AR9285 wireless card. Wireless is
> currently disabled, and the wireless LED is off. This is the default factory
> setting. There is no way to enable the wireless module from Linux. On
> Windows, the Fn/F8 key combination enables and disables the wireless module,
> and turns on or off the LED. On Linux however, this isn't working.
>
> The advice that I read on discussion forums on the web was to boot Windows,
> turn on wireless, and then boot Linux again (see http://tjmcgrew.com/). It
> is - as far as I know - not possible to use the Atheros AR9285 wireless card
> on a Linux computer, without running Windows first to enable it. This is not
> very good.

That would mean no one could use ath9k with AR9285 but that is
obviously not the case.

You are generalizing your issue to everyone and making wide assumptions.

> To sum up:
> - From Linux it is not possible to enable/disable the Atheros AR9285
> wireless card, and to turn on and off the wireless LED.
> - This should be fixed as the wireless card is disabled by default, and it
> is thus impossible to use it on a system without installing and running
> Windows first.

You probably just need the proper rfkill module to enable your device.
Whether your rfkill triggers are supported is another question. For
that you may want to try out the latest kernel and use a tree where
rfkill was recently re-implemented.

Please try building wireless-testing:

http://wireless.kernel.org/en/developers/Documentation/git-guide

or compat-wireless:

http://wireless.kernel.org/en/users/Download/

  Luis
