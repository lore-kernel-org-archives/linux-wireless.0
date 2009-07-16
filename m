Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:56458 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757345AbZGPD65 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 23:58:57 -0400
Received: by fxm18 with SMTP id 18so3841350fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2009 20:58:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890907150925p51c1a019r95266cbdc1e762e4@mail.gmail.com>
References: <bcd1ba70907142125y35c78cf5v251953eafede0e74@mail.gmail.com>
	 <1247673740.17896.1983.camel@rc-desk>
	 <1247674310.10754.19.camel@johannes.local>
	 <43e72e890907150925p51c1a019r95266cbdc1e762e4@mail.gmail.com>
Date: Wed, 15 Jul 2009 20:58:55 -0700
Message-ID: <bcd1ba70907152058m14249f40gf0ebff1620e56674@mail.gmail.com>
Subject: Re: Unable to load iwlagn module: Failed to register hw (error -17)
From: John Ranson <ranson@analager.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The release is master-2009-07-08-3-g3615cdf

/sys/class/ieee80211/ is empty

I'm running Gentoo on an Lenovo R61. I don't think that there is
anything too special about my configuration.

Is there any more information that I can provide that will help debug?

Thanks,

John


On Wed, Jul 15, 2009 at 9:25 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> On Wed, Jul 15, 2009 at 9:11 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
>> Hi,
>>
>>> On Tue, 2009-07-14 at 21:25 -0700, John Ranson wrote:
>>> > [    4.252445] iwlagn 0000:03:00.0: Tunable channels: 11 802.11bg, 13
>>> > 802.11a channels
>>> > [    4.252556] iwlagn 0000:03:00.0: irq 30 for MSI/MSI-X
>>> > [    4.252945] iwlagn 0000:03:00.0: Failed to register hw (error -17)
>>> > [    4.253255] iwlagn 0000:03:00.0: PCI INT A disabled
>>> > [    4.253263] iwlagn: probe of 0000:03:00.0 failed with error -17
>>>
>>> This is ieee80211_register_hw() returning error 17 (EEXIST). One spot I
>>> saw where this can happen is if you are trying to register with the same
>>> name (wlanX) already used by another netdevice. Does this sound possible
>>> in your setup?
>>>
>>> Johannes - do you perhaps have an idea when this can happen?
>>
>> This is strange -- I've had one report of this with 3945 which went away
>> and seemed to have been a compat only issue, I suspect this is also just
>> a compat-wireless issue, but I have no idea.
>
> We've had a lot of changes to compat-wireless recently so this is possible.
>
> John, can you cat compat-release on your compat-wireless directory?
>
>  Luis
>
