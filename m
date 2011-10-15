Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56494 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab1JONla convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 09:41:30 -0400
Received: by wwe6 with SMTP id 6so182322wwe.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Oct 2011 06:41:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN=pzd+8b9cqc6BgvaF8vdq-CywJ7mNTVpeXz92ZvwJwefJOkA@mail.gmail.com>
References: <CAN=pzd+TcY+n90RBMU+Cpp0Bt9d_eAGgY4yffO+PSStWSzbf-Q@mail.gmail.com>
	<4E9970A6.10305@openwrt.org>
	<CAN=pzd+ou1DXL_d_W0dvTcYrNMfH9NjSoFUa=07fE4BYJ+N7bQ@mail.gmail.com>
	<4E997413.8010008@openwrt.org>
	<CAN=pzd+R42SArWR+gEgqvJ7h1_6ZnB61xyKzOo8FqNxkRhxqrQ@mail.gmail.com>
	<4E997A54.2080004@openwrt.org>
	<CAN=pzdLBxCB7U1+ig+ctPJKZMgC3D2V0KHOXXZH8ZVBgi67BQg@mail.gmail.com>
	<4E997F13.7060602@openwrt.org>
	<CAN=pzd+8b9cqc6BgvaF8vdq-CywJ7mNTVpeXz92ZvwJwefJOkA@mail.gmail.com>
Date: Sat, 15 Oct 2011 17:41:28 +0400
Message-ID: <CAN=pzdJgba-mdJHLDC+_LpgSiMwff4vbB-oUp2VDwYsSouedPA@mail.gmail.com> (sfid-20111015_154141_751722_CD51D59E)
Subject: Re: Ath9k, single antenna on ar9280
From: Stanislav Demakov <s.demakov@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And the last question...
Can you confirm that after setting antenna configuration to 1x1 I can
safely detach 2nd physical connector from the adapter? I mean is there
a guarantees that device will only use the 1st antenna.

2011/10/15 Stanislav Demakov <s.demakov@gmail.com>:
> I've found it. Hostapd was the reason. After killing it set antenna works.
> Thanks. :)
>
> 2011/10/15 Felix Fietkau <nbd@openwrt.org>:
>> On 2011-10-15 2:24 PM, Stanislav Demakov wrote:
>>>
>>> I'm running Ubuntu Server 11.10 - (kernel:  Linux server
>>> 3.0.0-12-generic x86_64)
>>>
>>> ath9k from compat-wireless-2011-10-12 and current iw from git compiled
>>> with libnl1.
>>>
>>> The wireless chip is AR9280. (2x2 MIMO)
>>>
>>> Also
>>> echo 1>  /sys/kernel/debug/ieee80211/phy0/ath9k/rx_chainmask
>>> echo 1>  /sys/kernel/debug/ieee80211/phy0/ath9k/tx_chainmask
>>> is written at boot.
>>>
>>> Is something wrong above?
>>
>> Do not mess with the rx_chainmask/tx_chainmask parameters, that may be the
>> reason why it's not working for you.
>>
>> - Felix
>>
>
