Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:63785 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab3CPNuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 09:50:22 -0400
Received: by mail-oa0-f45.google.com with SMTP id o6so4384196oag.18
        for <linux-wireless@vger.kernel.org>; Sat, 16 Mar 2013 06:50:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1363273116.4853.58.camel@i7.infradead.org>
References: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
	<1363171283.32099.343.camel@i7.infradead.org>
	<CACna6ryEBFqg1ORRcbob+FWcFGiMt9fOfQAkAov9wmoR8M4Fxw@mail.gmail.com>
	<1363273116.4853.58.camel@i7.infradead.org>
Date: Sat, 16 Mar 2013 14:50:21 +0100
Message-ID: <CACna6ry4bxZROnoBpu7S39e+cDure79nmzhLY8228Zuxecdt3w@mail.gmail.com> (sfid-20130316_145035_627612_274F0A2B)
Subject: Re: [PATCH 00/13] b43: implement basic TX power mgmt
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/14 David Woodhouse <dwmw2@infradead.org>:
> On Thu, 2013-03-14 at 00:19 +0100, Rafał Miłecki wrote:
>>
>> > If you have a git tree I can pull this from, I'd be happy to give it
>> > some testing...
>>
>> You can try wireless-testing:
>> http://git.kernel.org/cgit/linux/kernel/git/linville/wireless-testing.git
>
> Thanks. This is not an improvement here.
>
> Sitting at my desk, about 5m from my WNDR3800 access point with walls
> and chimney in between them, I was previously seeing a TX rate of 48Mb/s
> up to 54Mb/s (reported by 'iwconfig wlan0' and also as the RX rate for
> the corresponding wireless client in OpenWRT's status page).
>
> A primitive test copying a 143MiB file to a wired host would take 35
> seconds, averaging 4.1MiB/s.
>
> With these changes I get TX rates of about 18-24Mb/s and copying the
> same file takes 82 seconds, averaging 1.7MiB/s

I was thinking about this and analyzing dump a bit more. My theory
(that makes the most sense for me) is that:
1) Cards differ by default TX configuration. Your default
configuration works pretty well in your environment (32.8Mib/s? that's
really nice!). My card is probably different and in default
configuration can barely transmit anything).
2) With the recent changes we put cards in some semi-optimal configuration
3) To achieve full performance we still have to implement dynamic TX
power management

In your case... well it probably was better to don't touch TX power at
all ;) Unfortunately it has to be finally implemented, to allow all
cards work with some acceptable performance.


> That's comparing the Fedora 3.8.2-206.fc18.x86_64 kernel with current
> wireless-testing, rather than wireless-testing from before and after
> your changes. But that shouldn't matter, presumably?
>
> Do you want me to do some more specific tests?

To verify my theory, could you try reverting
4969b41798e512689bba57c8c44d873216eba814, AKA
b43: HT-PHY: enable basic TX power setup
? Does reverting this patch brings you back ~4.1MiB/s?

If it doesn't, could you bisect? Two another patches I would suspect;
b43: HT-PHY: implement spurious tone avoidance
b43: HT-PHY: implement MAC reclocking

-- 
Rafał
