Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from svenfoo.org ([82.94.215.22]:42917 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbaGAHwr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 03:52:47 -0400
Message-ID: <53B268C8.4030703@zonque.org> (sfid-20140701_095251_836484_056BFC9D)
Date: Tue, 01 Jul 2014 09:52:40 +0200
From: Daniel Mack <daniel@zonque.org>
MIME-Version: 1.0
To: Bing Zhao <bzhao@marvell.com>, Tony Lindgren <tony@atomide.com>,
	Andreas Fenkart <afenkart@gmail.com>
CC: James Cameron <quozl@laptop.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-mmc <linux-mmc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: mwifiex card reset
References: <CALtMJEBWPM+75wxM2Mp5EX_o6NWtZUJdYRCv6psbvdUn4k295w@mail.gmail.com> <20140628052220.GG10407@us.netrek.org> <20140628072322.GC7410@atomide.com> <CALtMJED5vfgkAhMBXKaDP6u9U9n41c-wziyTxt6e_7XTSxG3oQ@mail.gmail.com> <20140630061912.GA2461@atomide.com> <53B1BAC1.3090902@zonque.org> <477F20668A386D41ADCC57781B1F70430FE5F37540@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430FE5F37540@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

On 07/01/2014 08:44 AM, Bing Zhao wrote:
>> Hence, we'll need some sort of internal API for this, and a phandle
>> in dts. I wonder whether that glue logic might be better off living
>> in the mmc core, as mwifiex might well be interfaced to other
>> hosts?
> 
> I may have missed something, but doesn't the MMC_POWER_OFF and
> MMC_POWER_ON|UP handling in controller driver help? Anyway the
> clocks/GPIOs/regulators are sort of platform dependent. Would it be
> better putting it in /arch/arm/mach-xxxxx/?

Regulators are not platform specific, they never were. For GPIOs and
clocks, we can simply depend on CONFIG_GPIO_GENERIC and
CONFIG_COMMON_CLK. I wouldn't even bother to care for anything else.
This way, we also get a way of referencing the resources in dts through
phandles for free.

What I was talking about above was that conducting the actual reset from
the helper must be something that either the mmc core or individual host
implementations can trigger. We need to repeat this action every time
mwifiex decides to call its reset routine, which is currently
implemented like this:

	mmc_remove_host(target);
	mdelay(20);
	mmc_add_host(target);

But I haven't looked into possible ways of implementation yet.
MMC_POWER_* might well be a suitable thing to hook into.


Thanks,
Daniel
