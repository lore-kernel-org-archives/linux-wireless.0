Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42803 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab1EECGD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 22:06:03 -0400
Received: by bwz15 with SMTP id 15so1471426bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 19:06:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19906.621.413439.414030@gargle.gargle.HOWL>
References: <BANLkTinJK3B_dcX4Qmuo=hC5j654YLLmCA@mail.gmail.com>
 <19906.158.278401.536454@gargle.gargle.HOWL> <19906.621.413439.414030@gargle.gargle.HOWL>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Wed, 4 May 2011 19:05:41 -0700
Message-ID: <BANLkTimp=tZbBoFBGo9xyLfe1Jx=A+b=0g@mail.gmail.com> (sfid-20110505_040607_143036_03AC7D30)
Subject: Re: bug: 2 second wireless stall on ath9k link
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 4, 2011 at 6:50 PM, Sujith <m.sujith@gmail.com> wrote:
> Sujith wrote:
>> Daniel Halperin wrote:
>> > Hi,
>> >
>> > I have two identical Dell Inspiron 530n desktops running latest w-t
>> > (07e789c5094735747b3df8a7840f61467575ba9e, master 2011-05-04) on
>> > Ubuntu 10.04.2 LTS. I have uninstalled network-manager from both
>> > devices and, as far as I can tell, no software processes or daemons
>> > interfere with my wireless configurations.
>> >
>> > The AP machine has an AR9280-based device and an IWL5300 based device.
>> > I blacklist ath9k and iwlagn modules from loading on boot. It is
>> > running latest hostap.git, though I've seen the same issue with older
>> > versions.
>> >
>> > The client machine has one AR9380-based NIC, one IWL5300-based NIC,
>> > and one RT2800pci NIC. I blacklist ath9k, iwlagn, and rt2800pci from
>> > loading on boot.
>> >
>> > When I set up the client to connect (using iwconfig essid) to the AP
>> > (no encryption, channel 48 with HT40-) and run iperf, I sometimes see
>> > 2-second drops of the connection. I run iperf to generate elastic TCP
>> > flows that see ~150 Mbps, and in parallel I run ping <AP> -i 0.2.
>> > Here's the ping log:
>>
>> Your timing couldn't be better. :)
>> https://patchwork.kernel.org/patch/753862/

Thanks! I'll give it a whirl.

>
> Hm, is ath9k in AP mode ?
> That fix is meant primarily for station mode.
>
> Disabling ANI would be useful to narrow down the issue.
> (Since long calibration is every 30 seconds).

Yes, one side is AP and the other side is client.

What is ANI and how do I disable it? (Is there a website I should be
looking at? A quick search didn't pull anything up).

Thanks!
Dan
