Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:50941 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbaGAIon (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 04:44:43 -0400
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430FE5F37540@SC-VEXCH1.marvell.com>
References: <CALtMJEBWPM+75wxM2Mp5EX_o6NWtZUJdYRCv6psbvdUn4k295w@mail.gmail.com>
	<20140628052220.GG10407@us.netrek.org>
	<20140628072322.GC7410@atomide.com>
	<CALtMJED5vfgkAhMBXKaDP6u9U9n41c-wziyTxt6e_7XTSxG3oQ@mail.gmail.com>
	<20140630061912.GA2461@atomide.com>
	<53B1BAC1.3090902@zonque.org>
	<477F20668A386D41ADCC57781B1F70430FE5F37540@SC-VEXCH1.marvell.com>
Date: Tue, 1 Jul 2014 10:44:42 +0200
Message-ID: <CALtMJEDkdvs_meBw-fE2Hnbn-1YZrH9v2KuXyDF6VxjFeNbzgQ@mail.gmail.com> (sfid-20140701_104450_910513_6DFDE236)
Subject: Re: mwifiex card reset
From: Andreas Fenkart <afenkart@gmail.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: Daniel Mack <daniel@zonque.org>, Tony Lindgren <tony@atomide.com>,
	James Cameron <quozl@laptop.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-mmc <linux-mmc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

2014-07-01 8:44 GMT+02:00 Bing Zhao <bzhao@marvell.com>:
[snip]
>> Yes, a helper might be the best solution. It could even be a generic one, that
>> just takes any number of clocks, reset GPIOs and regulators and takes care
>> for sequencing them. However, we need to reference that helper from the
>> mwifiex driver, for two reasons.
>>
>> a) we need to make sure the reset helper gets to do its job before the
>> mwifiex driver scans the SDIO bus, and
>>
>> b) the reset helper needs to be called when the mmc host controller wants
>> to do a card reset.
>>
>> Hence, we'll need some sort of internal API for this, and a phandle in dts. I
>> wonder whether that glue logic might be better off living in the mmc core, as
>> mwifiex might well be interfaced to other hosts?
>
> I may have missed something, but doesn't the MMC_POWER_OFF and MMC_POWER_ON|UP handling in controller driver help?
> Anyway the clocks/GPIOs/regulators are sort of platform dependent. Would it be better putting it in /arch/arm/mach-xxxxx/?

what about usb? the mwifiex can also be connected via usb to the host,
isn't the reset
logic the same in that case, independent of sdio
