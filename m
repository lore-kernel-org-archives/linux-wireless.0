Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from svenfoo.org ([82.94.215.22]:60580 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757141AbaF3TaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 15:30:12 -0400
Message-ID: <53B1BAC1.3090902@zonque.org> (sfid-20140630_213020_292815_7EA0F3FD)
Date: Mon, 30 Jun 2014 21:30:09 +0200
From: Daniel Mack <daniel@zonque.org>
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>,
	Andreas Fenkart <afenkart@gmail.com>
CC: James Cameron <quozl@laptop.org>, Bing Zhao <bzhao@marvell.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-mmc <linux-mmc@vger.kernel.org>, devicetree@vger.kernel.org
Subject: Re: mwifiex card reset
References: <CALtMJEBWPM+75wxM2Mp5EX_o6NWtZUJdYRCv6psbvdUn4k295w@mail.gmail.com> <20140628052220.GG10407@us.netrek.org> <20140628072322.GC7410@atomide.com> <CALtMJED5vfgkAhMBXKaDP6u9U9n41c-wziyTxt6e_7XTSxG3oQ@mail.gmail.com> <20140630061912.GA2461@atomide.com>
In-Reply-To: <20140630061912.GA2461@atomide.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tony, everyone,

Thanks Andreas for addressing this issue! So far, we've been using a
terrible hack in the hsmmc in order to bring the card into a workable
state, and we're looking for a nicer solution for awhile.

On 06/30/2014 08:19 AM, Tony Lindgren wrote:
> * Andreas Fenkart <afenkart@gmail.com> [140629 12:43]:
>> 2014-06-28 9:23 GMT+02:00 Tony Lindgren <tony@atomide.com>:
>>> * James Cameron <quozl@laptop.org> [140628 08:24]:

>>> Wouldn't it be best to have the mwifiex properly handle the
>>> reset GPIOs and idle status pins?
>>
>> doesn't work see ref 1) above
> 
> OK so we can't do much anything at mwifiex probe time on SDIO bus because
> it won't probe unless the pins are configured.
> 
> Maybe we should have a separate mwifiex-power helper module that just
> manages the reset/idle/regulator pins? Then mwifiex-reset can be always
> loaded and configure things so mwifiex-sdio can probe properly.
> 
> And mwifiex-reset helper can also provide the user space interfaces
> for the reset/idle/regulator pins.

Yes, a helper might be the best solution. It could even be a generic
one, that just takes any number of clocks, reset GPIOs and regulators
and takes care for sequencing them. However, we need to reference that
helper from the mwifiex driver, for two reasons.

a) we need to make sure the reset helper gets to do its job before the
mwifiex driver scans the SDIO bus, and

b) the reset helper needs to be called when the mmc host controller
wants to do a card reset.

Hence, we'll need some sort of internal API for this, and a phandle in
dts. I wonder whether that glue logic might be better off living in the
mmc core, as mwifiex might well be interfaced to other hosts?


Thanks,
Daniel

