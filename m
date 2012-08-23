Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51480 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab2HWGuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 02:50:07 -0400
Received: by wicr5 with SMTP id r5so616816wic.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Aug 2012 23:50:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <503540FC.9030408@openwrt.org>
References: <CAHNKnsRVh_BXqW0CLfxO5WZCJ8UH7O=cHN-zh7AuM_pQj0xUqg@mail.gmail.com>
 <20120820111321.71c6f07e@mj> <503540FC.9030408@openwrt.org>
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Thu, 23 Aug 2012 10:49:45 +0400
Message-ID: <CAHNKnsTKuNNkKuNTUX5HQmU2QdvhQ0SSkPj++=0bd-tHyAa3_A@mail.gmail.com> (sfid-20120823_085012_267405_B662EAAE)
Subject: Re: Per sta interfaces in WDS (4-address) mode
To: Felix Fietkau <nbd@openwrt.org>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel, Felix thanks for the quick response. Appears that I missed the
discussion of this solution.

2012/8/23 Felix Fietkau <nbd@openwrt.org>:
> On 2012-08-20 5:13 PM, Pavel Roskin wrote:
>> On Sun, 19 Aug 2012 21:51:27 +0400
>> Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>>
>>> Hello dear all,
>>>
>>> please tell me, why in the WDS mode, the stack creates a new interface
>>> for each WDS station, and this interface hostapd adds to the parent AP
>>> interface bridge? Why we couldn't simply pass this frames via AP
>>> interface?
>>
>> You may want to use a completely different IP address and netmask on the
>> WDS interface.  Using the AP interface would take away that option.
>>
>> hostapd is not a part of the kernel.  It should be possible not to add
>> WDS interfaces to the bridge.
> It's not just that. If the WDS station communication were done over the
> AP interface, mac80211 would have to keep a table of which MAC address
> is reachable behind which WDS station, which is something that the
> bridge layer is supposed to do.
> I've seen such a design mistake in various drivers, and I've seen the
> weird quirks that this usually produces in more complex network
> topologies ;)
>
Implementing WDS support directly in the driver (or stack) - it is
really a complex task. Several years ago, had to spend a lot of time
catching bugs in the madwifi code. But when we use virtual interfaces
and generic bridge there a few questions.
1. How to isolate the clients and hosts behind them?
2. How to tag outgoing packets with 802.1Q tags? If we do:
ip link add link wlan0 name wlan0.15 type vlan id 15
it will only tagged packets going directly to client stations, but not
to hosts behind them.

-- 
BR Sergey
