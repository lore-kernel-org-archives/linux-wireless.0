Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58684 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab1HBQFh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 12:05:37 -0400
Received: by fxh19 with SMTP id 19so5742029fxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2011 09:05:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201108021204.08632.anarsoul@gmail.com>
References: <20110801154327.D0BB09D4020@zog.reactivated.net>
	<201108021204.08632.anarsoul@gmail.com>
Date: Tue, 2 Aug 2011 17:05:31 +0100
Message-ID: <CAGq3pz7FCfHhdV2XY3LvZdWE6u4vPPV3HOa82SwqTY6NMHKmeA@mail.gmail.com> (sfid-20110802_180553_296209_52EB0E3B)
Subject: Re: [PATCH 2/2] libertas: implement if_sdio runtime power management
From: Daniel Drake <dsd@laptop.org>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: libertas-dev@lists.infradead.org, linville@tuxdriver.com,
	dcbw@redhat.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 August 2011 10:04, Vasily Khoruzhick <anarsoul@gmail.com> wrote:
>> +     ret = if_sdio_power_on(card);
>
> Why do you power on card here? Maybe it's possible do it in lbs_start_card?

The device must be powered while lbs_start_card() is executed. This is
because lbs_start_card() runs a few commands, such as reading the MAC
address.

Moving the poweron/poweroff into lbs_start card() is possible, and I
guess you are also finding for SPI that the only thing you need to
power up the card for during probe is to execute lbs_start_card().

But personally I think it makes more sense at the interface driver
level. Moving it into lbs_start_card() would be problematic if you
ever needed the device powered for something else during the probe
routine - you'd be forced to power-cycle the card again before or
after running lbs_start_card().

>> +     if_sdio_power_off(card);
>
> Same for power off.

The card should be powered off at this point because the network
interface is not up. It will then be powered on when userspace brings
it up.

Daniel
