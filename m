Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:33391 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab0EFWRI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 18:17:08 -0400
MIME-Version: 1.0
In-Reply-To: <g2wf69abfc31005060752w6876439cm45f5be68001c8382@mail.gmail.com>
References: <r2xf69abfc31005050326oe123cb60s131ab4969341ef57@mail.gmail.com>
	<g2wf69abfc31005060752w6876439cm45f5be68001c8382@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 6 May 2010 15:16:48 -0700
Message-ID: <p2l43e72e891005061516o4c274892n6d1edf08ead74a4@mail.gmail.com>
Subject: Re: 2.6.33.2: Turn tx power off/on for Atheros card
To: Yegor Yefremov <yegorslists@googlemail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 6, 2010 at 7:52 AM, Yegor Yefremov
<yegorslists@googlemail.com> wrote:
> On Wed, May 5, 2010 at 12:26 PM, Yegor Yefremov
> <yegorslists@googlemail.com> wrote:
>> I'm using kernel 2.6.33.2 with AR2413 WLAN card. Issuing
>>
>> iwconfig wlan0 txpower off
>>
>> turns txpower off. I can see this status by iwconfig wlan0 and the
>> communication with AP terminates. But when I turn the txpower on
>>
>> iwconfig wlan0 txpower on
>>
>> nothing happens. Though iwconfig shows the previous tx power value.
>> Only ifconfig wlan0 down and then up recovers the transmission.
>>
>> Is it a known bug or I'm doing something wrong?
>
> I made some debugging and found out that after iwconfig wlan0 txpower
> off dev_close() will be invoked, so that local->open_count will be 0.
> The next time txpower on will be called, it will be checked if
> local->open_count > 0 and this conditions fails, so no  hardware
> configuration will be made.
>
> I've made a quick and dirty hack, that opens the wireless device by
> enabling the txpower, if it was closed before. Is there any proper
> solution? Is it really necessary to close device to tunr txpower off?

Depends on the type of interfaces you have. For a monitor device it
makes no sense to close the device as you should be able to still RX.
It also is possible to TX over a monitor device using frame injection
so technically setting tx power to off would just mute it and would
seem useful.

  Luis
