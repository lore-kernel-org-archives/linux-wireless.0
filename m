Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61733 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2FGKPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 06:15:04 -0400
Received: by obbtb18 with SMTP id tb18so679928obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 03:15:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201206071034.03983.tvrtko.ursulin@onelan.co.uk>
References: <201205281316.15008.tvrtko.ursulin@onelan.co.uk>
	<201205291212.46377.tvrtko.ursulin@onelan.co.uk>
	<20420.48433.260465.183715@gargle.gargle.HOWL>
	<201206071034.03983.tvrtko.ursulin@onelan.co.uk>
Date: Thu, 7 Jun 2012 15:45:02 +0530
Message-ID: <CAD2nsn1tgz1WVK_=ZSpyYXP15Nink5S45VxRDJS6V1xWwjsd0g@mail.gmail.com> (sfid-20120607_121550_352883_E3B59B99)
Subject: Re: ath9k stops working (DMA trouble?) shortly after going online
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 7, 2012 at 3:04 PM, Tvrtko Ursulin
<tvrtko.ursulin@onelan.co.uk> wrote:
> On Tuesday 29 May 2012 13:12:33 Sujith Manoharan wrote:
>> > 118.779362 - 118.795238 (WARN_ON WARNING: at
>> > drivers/net/wireless/ath/ath9k/recv.c:531 ath_stoprecv+0x118/0x130
>> > [ath9k]())
>> >
>> > 524.162432 - 524.753750
>> > 1544.610658 - 1550.218324
>> > 1685.668241 - 1686.991166
>> > 1773.268867 - 1804.465933
>> >
>> > Hope this helps?
>>
>> Yes !
>>
>> Here are a couple of patches to help narrow down the issue.
>>
>> http://sujith.github.com/patches/wl/0001-ath9k-Add-some-debug-messages.patc
>> h
>> http://sujith.github.com/patches/wl/0002-ath9k-Resync-beacons-after-a-rese
>> t.patch
>>
>> The first one adds some messages, the second sets up beacons properly in
>> case a HW reset happens. Can you try these and post the log ?
>>
>> If you are willing to move to a more recent kernel, then current
>> wireless-testing would be a good choice since it has various driver fixes.
>> There are a few pending ath9k patches which have not been merged yet, you
>> can find it here:
>>
>> http://sujith.github.com/patches/wl/wl-ath9k-May-29-2012.patch
>
> For the record, we swapped the mini PCI card to a different one of the same
> model and now it seems to work fine. Could you imagine a hardware fault or
> tolerance issue causing such errors?
>

could be, i  shorted a resistor in one of the chips for some reason
and saw some Failed to stop DMA issues(well the chip
was not working at all)


-- 
thanks,
shafi
