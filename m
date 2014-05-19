Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37778 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaESPnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 11:43:05 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so4369854wib.17
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 08:43:03 -0700 (PDT)
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <1400510950.4273.9.camel@jlt4.sipsolutions.net>
References: <CAN8YU5Nh-FwrBWuCz-YArmHg9NSLqsS2aan_6edaVDg+i6018g@mail.gmail.com>
 <1400509775.4273.8.camel@jlt4.sipsolutions.net> <1400510950.4273.9.camel@jlt4.sipsolutions.net>
From: Andrea Merello <andrea.merello@gmail.com>
Date: Mon, 19 May 2014 17:42:43 +0200
Message-ID: <CAN8YU5OdpxQ0F7RMEFeQWC6PNzppHu6bDEt7Tv6dKntEUMy-9A@mail.gmail.com> (sfid-20140519_174309_723582_5C22A357)
Subject: Re: [RFC] mac80211: at76x50x_usb driver broken by commit 3afc216..
 and RX path involved in scan
To: Johannes Berg <johannes@sipsolutions.net>
Cc: emmanuel.grumbach@intel.com,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	joerg.albert@gmx.de, Alex Stewart <alex@foogod.com>,
	n0_5p4m_p13453@hotmail.com, Pavel Roskin <proski@gnu.org>,
	agx@sigxcpu.org, Kalle Valo <kalle.valo@iki.fi>, sesmo@gmx.net,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel, Johannes,
Thank you for your answer.

Now that it has been clearly stated that driver must report this
information, I obviously throw away the idea of modifying mac80211 :)
BTW FYI what emmanuel suggested in the last mail seems very similar to
what I tried to do as experiment, and that made the scan works again
:)

About Johannes patch.. Looks good :) But I already tried to do almost
the same thing in the at79 driver, but I failed, because despite
setting the single channel and performing a bunch of HW scan (one for
each ch), it happened that my HW did several full scans disregarding
the channel setting.

But it might be MY bug! I hope it :)
I saw the driver uses the same idea for implementing "monitor mode",
so I thought it should work (but I have not tried yet with "monitor
mode")...

As soon as I have time I'll try Johannes patch (and FYI I will also
try to finish some patches about WEP broken and DMA from stack memory)
and I will post results..

Thank you all :)
Andrea


On Mon, May 19, 2014 at 4:49 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2014-05-19 at 16:29 +0200, Johannes Berg wrote:
>
>> Since there's no "rx channel" information in this driver, but there does
>> seem to be a (currently unused) channel field in the scan request, maybe
>> we can make the driver request up to 14 single-channel scans (rather
>> than a single full scan), and then it can keep track of the current
>> channel in software and assign the pointer properly.
>>
>> This would also allow implementing regulatory for scan properly, which
>> seems like a good idea as well.
>
> Maybe something like this works?
>
> http://p.sipsolutions.net/fa75caf17c54747a.txt
>
> johannes
>
