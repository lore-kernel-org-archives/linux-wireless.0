Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:4850 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbYFLUrs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 16:47:48 -0400
Received: by py-out-1112.google.com with SMTP id p76so1772736pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2008 13:47:45 -0700 (PDT)
Message-ID: <1ba2fa240806121347x211af015w51a9ca3cabaac96c@mail.gmail.com> (sfid-20080612_224809_443822_F2DA80ED)
Date: Thu, 12 Jun 2008 23:47:45 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: fix beacon interval value
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1213301313.3730.47.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1213299517-24042-1-git-send-email-tomas.winkler@intel.com>
	 <1213299706.3730.39.camel@johannes.berg>
	 <1ba2fa240806121305h721c6bd2x8073660d41653b92@mail.gmail.com>
	 <1213301313.3730.47.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 12, 2008 at 11:08 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-06-12 at 23:05 +0300, Tomas Winkler wrote:
>> On Thu, Jun 12, 2008 at 10:41 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> >
>> >> 1. in register_hw it honors value requested by the driver
>> >
>> > I don't think the driver should be able to "request" a value.
>>
>> Yes and no.
>> The problem is that we don't have user space interface to tune this
>> for IBSS so in this circumstances
>> driver can choose what value is best for it.
>
> I don't see how the beacon interval has any relation to "what is best
> for the hardware/driver".

Usually this affect power management if implemented.

 And doing this just creates hard to debug
> differences between drivers. All differences between different drivers
> are causing problems at some point.

Get assimilated :)

> Wrt. configurability, yes, we should maybe allow this. Although it's
> only used for IBSS (in BSS it is configurable already)
You mean probably AP

What should be the proper interface  sysfs or iw(nl) ?

>so I'm not
> entirely sure... users are probably not able to make an informed
> decision anyway.

Are you talking about Linux users ? :). Usually vendors take such decisions.

>
>> >> 2. It uses default 100 instead of 1000 or 10000. Scanning for beacon
>> >> interval ~1sec and above is not sane
>> >
>> > Yeah, 10000 seems a bit excessive.
>>
>> Actually this never took affect as there is no way that 0 is assigned
>> to hw->conf.beacon_int but even 1000 is edgy and not suitable for a
>> default value.
>
> Sure, I'm fine with changing both values to 100.

Good.

Tomas
