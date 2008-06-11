Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.238]:50916 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbYFKNq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 09:46:26 -0400
Received: by wr-out-0506.google.com with SMTP id 69so1824179wri.5
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 06:46:25 -0700 (PDT)
Message-ID: <43e72e890806110646o439c1620t204e68034434968d@mail.gmail.com> (sfid-20080611_154630_612633_DCD675B8)
Date: Wed, 11 Jun 2008 06:46:25 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [compat-masters] Backported MQ requirement on 802.11n for older kernels
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	compat-masters@lists.madwifi.org,
	"Tim Gardner" <tim.gardner@canonical.com>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240806110627g467940b1k9ca4a43cd140506f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890806080855p284f85brd0ff1f1dfce96bf8@mail.gmail.com>
	 <43e72e890806090201q55bff8e3m694121ebd4befee6@mail.gmail.com>
	 <43e72e890806090325y5a1aebadq68204695044f4b6f@mail.gmail.com>
	 <1ba2fa240806101657w14599f30x67f58acbc7fe9e80@mail.gmail.com>
	 <43e72e890806102132q1aaba42ehd76bdd30b8d4080a@mail.gmail.com>
	 <43e72e890806102136jb8e695fla98a8594dde14396@mail.gmail.com>
	 <43e72e890806110403nddfca7cn66b91a938919e1f0@mail.gmail.com>
	 <7ba851519c84785f96af3637e9bab65b.squirrel@secure.sipsolutions.net>
	 <20080611125857.GG17936@ruslug.rutgers.edu>
	 <1ba2fa240806110627g467940b1k9ca4a43cd140506f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2008 at 6:27 AM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Wed, Jun 11, 2008 at 3:58 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Wed, Jun 11, 2008 at 02:12:41PM +0200, Johannes Berg wrote:
>>>
>>> > Johannes -- why do we have the requirement for NETDEVICES_MULTIQUEUE
>>> > on CONFIG_MAC80211_QOS? My current config doesn't have it it and
>>> > CONFIG_MAC80211_QOS still works right now enabled. Of course the
>>> > driver I'm testing doesn't have 11n though.
>>>
>>> because otherwise skb_get_queu_mapping always returns 0 and you use only
>>> one queue.
>>>
>>> > Shouldn't we just make MAC80211_QOS depend on NET_SCHED and figure out
>>> > we can't support 11n based on NETDEVICES_MULTIQUEUE?
>>>
>>> no, 11e also needs multiple queues.
>>
>> Thanks, since MAC80211_QOS was there before the issue is some
>> kernels may have this enabled but they never got to MQ. This is why
>> certain compiles will complain about missing symbols.
>>
>> So how about we disable it if we determine MQ and NET_SCHED are off?
>> Like this:
>>
>> diff --git a/config.mk b/config.mk
>> index e8dc469..b72e37e 100644
>> --- a/config.mk
>> +++ b/config.mk
>> @@ -27,7 +27,16 @@ ifeq ($(shell test $(KERNEL_SUBLEVEL) -lt 23 && echo yes),yes)
>>  CONFIG_MAC80211_QOS=y
>>  else
>>  ifeq ($(CONFIG_NETDEVICES_MULTIQUEUE),)
>> -$(warning "WARNING: You are running a kernel >= 2.6.23, you should enable CONFIG_NETDEVICES_MULTIQUEUE for 802.11n support")
>> +ifeq ($(CONFIG_NET_SCHED),)
>> +$(warning "WARNING: You are running a kernel >= 2.6.23, you should enable CONFIG_NETDEVICES_MULTIQUEUE and CONFIG_NET_SCHED for 802.11[ne] support")
>> +else
>> +# Disable CONFIG_MAC80211_QOS if you had it enabled befofre in your old .config
>> +$(warning "WARNING: You are running a kernel >= 2.6.23, you should enable CONFIG_NETDEVICES_MULTIQUEUE for 802.11[ne] support")
>> +CONFIG_MAC80211_QOS=n
>> +endif
>> +else
>> +# Disable CONFIG_MAC80211_QOS if you had it enabled befofre in your old .config
>> +CONFIG_MAC80211_QOS=n
>>  endif
>>  endif
>>  endif
>>
> One thing it's not clear for me. What do you mean by old .config
> CONFIG_MAC80211_QOS flags is available only in wireless-testing?
> The makefile is feed by compat.mk and DOTconfig from the target kernel
> (KLIB) (in my case 2.6.25)
> From what I see the flags from wireless-testing  need to be always
> reflected in compat.mk.

Bleh, you're right, it should be in only as of 2.6.27... something
else is causing some unresolved symbols if CONFIG_MAC80211_QOS is left
disabled on 2.6.24.

  Luis
