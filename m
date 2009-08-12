Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:49818 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbZHLTAW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 15:00:22 -0400
Received: by bwz22 with SMTP id 22so190651bwz.18
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 12:00:21 -0700 (PDT)
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linville\@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel\@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Guy\, Wey-Yi W" <wey-yi.w.guy@intel.com>
Subject: Re: [PATCH 16/16] iwlwifi: disable powersave mode
References: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
	<1249684912-22936-17-git-send-email-reinette.chatre@intel.com>
	<878whun256.fsf@litku.valot.fi> <1249760168.30019.5588.camel@rc-desk>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 12 Aug 2009 21:54:09 +0300
In-Reply-To: <1249760168.30019.5588.camel@rc-desk> (reinette chatre's message of "Sat\, 08 Aug 2009 12\:36\:08 -0700")
Message-ID: <87k518kgmm.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reinette chatre <reinette.chatre@intel.com> writes:

> Hi Kalle,

Hello,

> Thank you for looking at our patches. You have great feedback.

Thank you for listening :)

>> You are again creating driver specific parameters. But we should be
>> moving away from this and instead use just generic interfaces. Please,
>> think three times (or even more) whenever creating new driver specific
>> interfaces, be it module parameters, sysfs files etc.. It's a
>> maintenance nightmare and also very confusing for the users. We need to
>> focus on nl80211 and make it work properly with all drivers.
>
> What we have done here is not intended to be maintained at all - this is
> why the module parameter description reads "power save support
> (deprecated) (default disabled)" - it is deprecated from the beginning.

Yes, I understand this. But creating a new module parameters should be
added carefully only when really needed, just to avoid confusion within
users. And it sounds wrong to create a new variable which is deprecated
from the beginning. If it needs to be deprecated, don't create it at
all. Simple as that.

What I'm worried is the complexity of the driver interfaces and
configuration methods. For iwlwifi power save, after this patch, we have
now:

o Wireless Extensions
o sysfs
o CONFIG_CFG80211_DEFAULT_PS Kconfig parameter
o module parameter

Just think how confused an average Linux user will be? Instead of adding
more, we should instead decrease the ways to configure power save. sysfs
and the module parameter are high on my list for removal.

>> For the problem at hand, I see two options:
>> 
>> 1. Users seeing the problem disable power save either via wext or with
>>    CONFIG_CFG80211_DEFAULT_PS and everyone else still can use power
>>    save. The issue will be investigated and fixed. If the AP is buggy,
>>    there isn't much we can do.
>
> Please take a look at those bug reports. What we are seeing is huge ping
> delays ( > 1000ms rtt), dropped frames which is stalling connections,
> and throughput dropping in half. This is too severe to have powersave
> enabled at this time.

Yes, that makes sense. Then disable power save from iwlwifi until the
problem is solved (or analysed that it's a problem on AP), but don't
create a new module parameter.

>> 2. If you think the problem is widespread, remove
>>    IEEE80211_HW_SUPPORTS_PS from the driver, fix the issues and renable
>>    power save support.
>
> Yes - this is the goal of this patch. At the same time we would also
> like to make it easier for the people who are testing this issue right
> now and having the module parameter makes their life easier.

The very few users who want to test this can apply a patch or edit the
source code. It's a oneliner anyway.

> This module parameter is a temporary measure used to help us fix the
> power save issues. When the issues have been resolved we will enable
> power save support by default and remove the module parameter.

I'm not going to fight about this, for now, but in the future I hope
that people would consider carefully before adding hacks like this. If
all drivers create their own configuration parameters all the time, in
the end it will become a maintenance nightmare.

-- 
Kalle Valo
