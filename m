Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:33032 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbbFQKW6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 06:22:58 -0400
Received: by iebgx4 with SMTP id gx4so30560772ieb.0
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2015 03:22:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1434530870.1884.12.camel@sipsolutions.net>
References: <1433943751-11221-1-git-send-email-chaitanya.mgit@gmail.com> <1434530870.1884.12.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 17 Jun 2015 15:52:37 +0530
Message-ID: <CABPxzYL0rnht72K1fLcpyjC=eOM4nHxzHQRpD47iE6J=J-3sOg@mail.gmail.com> (sfid-20150617_122302_184128_C7E69B81)
Subject: Re: [PATCH V3] mac80211: wowlan: suspend: Fix power save state stuck
 in ACTIVE caused by race between suspend and Tx packet.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 17, 2015 at 2:17 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2015-06-10 at 19:12 +0530, Chaitanya T K wrote:
>> From: Chaitanya T K <chaitanya.mgit@gmail.com>
>>
>> Background: When wowlan is enabled, the chipset stays in low
>> power state maintaining the connection as per the
>> mac80211 power save state.
>>
>> If suspended during TX in progress, there can be
>> race where the driver is put of of power-save due
>> to TX and during suspend dynamic_ps_time is cancelled
>> and TX packet is flushed, leaving the driver in ACTIVE
>> even after resuming until dynamic_ps_time puts
>> driver back in DOZE. (Which only happens if there
>> is another TX).
>>
>> This can lead to high power consumption of chipset
>> during (or) after resuming.
>
> I still don't like it. I also don't believe that what you're writing is
> actually true. The only problem I can see is that it leads to higher
> power consumption *while the system is suspended* - at resume time we
> send a packet and thus kick the timers...
"If" we send a packet, but until them the system will still be
active.
>
> I was going to change it to this:
>
> -------
> mac80211: ensure powersave is enabled when going to WoWLAN
>
> If the system suspends while the client powersave mechanism
> is waiting to suspend due to a previous TX, the system will
> go to sleep with the NIC being awake (active) rather than
> in doze mode. Unless the driver handles this, it leads to
> excessive power consumption while sleeping.
> -------
Yes, i am fine with this, but wanted to include about resume
in case there is not response accepted fro the RX packet
which triggered resume.

> but I'm not convinced all of this is right.
Normally all drivers/firmware are honoring mac80211
power state to enter Doze/not. Yes, we can ask drivers
to force power save while entering suspend, but still
up on resumption we must honor the mac80211 power
save , so till the time we send any TX, chipset will be active
drawing more power.
