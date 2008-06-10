Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:52708 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbYFJX5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 19:57:05 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2317230waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2008 16:57:05 -0700 (PDT)
Message-ID: <1ba2fa240806101657w14599f30x67f58acbc7fe9e80@mail.gmail.com> (sfid-20080611_015710_913770_D1DD5F84)
Date: Wed, 11 Jun 2008 02:57:04 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [compat-masters] Backported MQ requirement on 802.11n for older kernels
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	compat-masters@lists.madwifi.org,
	"Tim Gardner" <tim.gardner@canonical.com>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <43e72e890806090325y5a1aebadq68204695044f4b6f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <43e72e890806080855p284f85brd0ff1f1dfce96bf8@mail.gmail.com>
	 <c85cb4470806090053l5b763a23j43bbf0c87f594b0d@mail.gmail.com>
	 <1213001797.698.57.camel@johannes.berg>
	 <43e72e890806090201q55bff8e3m694121ebd4befee6@mail.gmail.com>
	 <43e72e890806090325y5a1aebadq68204695044f4b6f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 9, 2008 at 1:25 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Mon, Jun 9, 2008 at 2:01 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Mon, Jun 9, 2008 at 1:56 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>>> On Mon, 2008-06-09 at 10:53 +0300, Ron Rindjunsky wrote:
>>>> >
>>>> > I just finished trying to backport CONFIG_NETDEVICES_MULTIQUEUE
>>>> > requirement for 802.11n to older kernels by relying on the old
>>>> > internal mac80211 hacked up MQ support. I've tested the build on
>>>> > 2.6.22, 2.6.23, and 2.6.24. Let me know if you get to test this,
>>>> > particularly iwl4965 using 11n on 2.6.22.
>>>> >
>>>>
>>>> in config.mk you put MAC80211_QOS=m, and i guess that the intention was to put
>>>> CONFIG_MAC80211_QOS=m
>>>> if this is the case then the compilation fails
>>>
>>> It should be "y"
>>>
>>> johannes
>>>
>>
>> Danke
>
> OK found some more issues. v4.2 pushed out and new tarball
> regenerated. This has been tested by Intel on 802.11n on iwl4965.

I couldn't  make wme.c compiled for kernels > 22 unless I've added the
else statement  bellow into confg.mk
You've reported that it worked for you so what did I wrong?

ifeq ($(CONFIG_NETDEVICES_MULTIQUEUE),)
$(warning "WARNING: You are running a kernel >= 2.6.23, you should
enable CONFIG_NETDEVICES_MULTIQUEUE for 802.11n support")
else
CONFIG_MAC80211_QOS=y
endif

Thanks
Tomas
