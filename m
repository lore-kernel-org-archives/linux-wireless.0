Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37320 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbcDRLXy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 07:23:54 -0400
Received: by mail-wm0-f52.google.com with SMTP id n3so119427975wmn.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2016 04:23:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56C4A5ED.4060802@openwrt.org>
References: <1455710131-9967-1-git-send-email-grzegorz.bajorski@tieto.com>
	<56C4A5ED.4060802@openwrt.org>
Date: Mon, 18 Apr 2016 13:23:52 +0200
Message-ID: <CA+BoTQnf953+s++Wiug=BgEw2Ahu7cN1fbatmgyWi_6iAg_v2Q@mail.gmail.com> (sfid-20160418_132426_466069_2ABE47F4)
Subject: Re: [RFC] mac80211: add extap functionality
From: Michal Kazior <michal.kazior@tieto.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Grzegorz Bajorski <grzegorz.bajorski@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 February 2016 at 17:55, Felix Fietkau <nbd@openwrt.org> wrote:
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

You can't really implement complete IPv6 support in relayd though.
Link-local routing is forbidden by the spec explicitly and a patch
I've cooked up was rejected[1].

I guess this leaves either the kernel's wireless stack to take up the
task or a special link device (for which I'm soliciting feedback now
[2]).

Thoughts?


[1]: http://marc.info/?l=linux-netdev&m=146084698311664&w=2
[2]: http://marc.info/?l=linux-netdev&m=146097234002385&w=2


Michal
