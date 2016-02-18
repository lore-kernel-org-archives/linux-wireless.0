Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:34635 "EHLO
	mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1425276AbcBRNgl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 08:36:41 -0500
Received: by mail-yw0-f170.google.com with SMTP id h129so39890717ywb.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Feb 2016 05:36:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56C4A5ED.4060802@openwrt.org>
References: <1455710131-9967-1-git-send-email-grzegorz.bajorski@tieto.com>
	<56C4A5ED.4060802@openwrt.org>
Date: Thu, 18 Feb 2016 14:36:40 +0100
Message-ID: <CAPGg_YC4Scq_s4bR5qMjJgRErFODhVm1MUy0SyvFAwzxA0U2Nw@mail.gmail.com> (sfid-20160218_143645_710635_70A08F14)
Subject: Re: [RFC] mac80211: add extap functionality
From: Grzegorz Bajorski <grzegorz.bajorski@tieto.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2016-02-17 17:55 GMT+01:00 Felix Fietkau <nbd@openwrt.org>:
> On 2016-02-17 12:55, Grzegorz Bajorski wrote:
>> Client interface briding was only possible when 4addr frames were used with
>> a 4addr/WDS aware AP. It was not possible to do it otherwise due to 3addr
>> frame limitation.
>>
>> The extap logic introduces a smart MAC address masking/translation
>> (including modyfing packets beyond SA/DA, e.g. DHCP broadcast flag is set).
>>
>> There are still some unsolved problems and bugs:
>>  - due to bridge port routing and sk_buff payload sharing skb_copy() is
>>    performed; this ideally should be reworked
>>  - ipv6 support is still not finished
>>  - extap is enabled by default currently; it should be configurable via
>>    nl80211 the same way 4addr is
>>
>> There's also an idea to move this as a generic link driver (just like
>> macvlan, et al) which would allow unmodified cfg80211 drivers to enjoy the
>> extap functionality. Thoughts?
>>
>> Note: This changes cfg80211 file in this single patch only for reviewing
>> convienence.
>>
>> This is an early draft to solicit comments on the design.
>>
>> Signed-off-by: Grzegorz Bajorski <grzegorz.bajorski@tieto.com>
> You can get a lot of the same effect (sharing the same subnet between
> hosts behind multiple interfaces and having forwarding between them)
> without any changes to mac80211.
>
> OpenWrt uses a daemon called 'relayd' which I wrote some years ago. It
> does ARP translation, DHCP packet mangling and sets up policy routing to
> forward packets between multiple interfaces.
>
> You can find it here:
> http://git.openwrt.org/?p=project/relayd.git;a=summary
> git://git.openwrt.org/project/relayd.git
>
> Since you can cover the same use cases with user space code, I don't
> think it's a good idea to put bridge emulation hacks in the kernel's
> wireless stack.

What about performance? Quick test show that is slow ~ 100-120 mbps
(UDP tests) and procesor is overloaded. Am I missing something? I
would expect it to be greater. (4 x 4 antena setup VHT80)

/Grzegorz
