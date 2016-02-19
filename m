Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37301 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423419AbcBSQYk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2016 11:24:40 -0500
Subject: Re: [RFC] mac80211: add extap functionality
To: Grzegorz Bajorski <grzegorz.bajorski@tieto.com>
References: <1455710131-9967-1-git-send-email-grzegorz.bajorski@tieto.com>
 <56C4A5ED.4060802@openwrt.org>
 <CAPGg_YC4Scq_s4bR5qMjJgRErFODhVm1MUy0SyvFAwzxA0U2Nw@mail.gmail.com>
 <56C5D066.8010405@openwrt.org>
 <CAPGg_YBiL+sx4qXcu63nL5rGcV2kKy4MY_wX0Yr0d_8pVsgoSQ@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56C741C0.90002@openwrt.org> (sfid-20160219_172445_120767_E63584DB)
Date: Fri, 19 Feb 2016 17:24:32 +0100
MIME-Version: 1.0
In-Reply-To: <CAPGg_YBiL+sx4qXcu63nL5rGcV2kKy4MY_wX0Yr0d_8pVsgoSQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-02-19 13:05, Grzegorz Bajorski wrote:
> 2016-02-18 15:08 GMT+01:00 Felix Fietkau <nbd@openwrt.org>:
>> On 2016-02-18 14:36, Grzegorz Bajorski wrote:
>>> 2016-02-17 17:55 GMT+01:00 Felix Fietkau <nbd@openwrt.org>:
>>>> On 2016-02-17 12:55, Grzegorz Bajorski wrote:
>>>>> Client interface briding was only possible when 4addr frames were used with
>>>>> a 4addr/WDS aware AP. It was not possible to do it otherwise due to 3addr
>>>>> frame limitation.
>>>>>
>>>>> The extap logic introduces a smart MAC address masking/translation
>>>>> (including modyfing packets beyond SA/DA, e.g. DHCP broadcast flag is set).
>>>>>
>>>>> There are still some unsolved problems and bugs:
>>>>>  - due to bridge port routing and sk_buff payload sharing skb_copy() is
>>>>>    performed; this ideally should be reworked
>>>>>  - ipv6 support is still not finished
>>>>>  - extap is enabled by default currently; it should be configurable via
>>>>>    nl80211 the same way 4addr is
>>>>>
>>>>> There's also an idea to move this as a generic link driver (just like
>>>>> macvlan, et al) which would allow unmodified cfg80211 drivers to enjoy the
>>>>> extap functionality. Thoughts?
>>>>>
>>>>> Note: This changes cfg80211 file in this single patch only for reviewing
>>>>> convienence.
>>>>>
>>>>> This is an early draft to solicit comments on the design.
>>>>>
>>>>> Signed-off-by: Grzegorz Bajorski <grzegorz.bajorski@tieto.com>
>>>> You can get a lot of the same effect (sharing the same subnet between
>>>> hosts behind multiple interfaces and having forwarding between them)
>>>> without any changes to mac80211.
>>>>
>>>> OpenWrt uses a daemon called 'relayd' which I wrote some years ago. It
>>>> does ARP translation, DHCP packet mangling and sets up policy routing to
>>>> forward packets between multiple interfaces.
>>>>
>>>> You can find it here:
>>>> http://git.openwrt.org/?p=project/relayd.git;a=summary
>>>> git://git.openwrt.org/project/relayd.git
>>>>
>>>> Since you can cover the same use cases with user space code, I don't
>>>> think it's a good idea to put bridge emulation hacks in the kernel's
>>>> wireless stack.
>>>
>>> What about performance? Quick test show that is slow ~ 100-120 mbps
>>> (UDP tests) and procesor is overloaded. Am I missing something? I
>>> would expect it to be greater. (4 x 4 antena setup VHT80)
>> What platform are you testing it on, and what kind of UDP test are you
>> running?
> 
> My setup it is as follows:
> [laptop1] --eth-- [EA6500 AP] ~~rf~~ [AP148 STA w/ QCA99X0] --eth--
> [laptop2]. I run UDP traffic between Laptop1 and Laptop2 using iperf.
> Laptop1: iperf -s -i1 -u
> Laptop2: iperf -i1 -c 192.168.1.108 -b 200M -t100 -u -P5 (without -P5,
> I got similar results)
So what kind of kernel are you running? Maybe you should use perf to
figure out why routing is so slow.

- Felix
