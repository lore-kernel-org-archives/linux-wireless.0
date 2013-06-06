Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48432 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3FFER2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 00:17:28 -0400
Message-ID: <51B00D50.9080606@candelatech.com> (sfid-20130606_061732_117963_5E6A4D6B)
Date: Wed, 05 Jun 2013 21:17:20 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ath9k: Use minstrel rate control by default
References: <1370488216-11626-1-git-send-email-sujith@msujith.org> <51B006AE.6080309@candelatech.com> <20912.2720.990590.284874@gargle.gargle.HOWL>
In-Reply-To: <20912.2720.990590.284874@gargle.gargle.HOWL>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2013 09:05 PM, Sujith Manoharan wrote:
> Ben Greear wrote:
>> If you will just delete that code above, then you can compile in both ath9k
>> and minstrel rate controls and select at run-time by twiddling the mac80211
>> rate control module option.
>
> I am not sure if a user is going to change the rate control at run-time by
> reloading mac80211 and what would be point in using ath9k RC which has basic
> connectivity problems ?
>
>> Last I tested there were still advantages to ath9k rate control in our environment,
>> (including when running through an attenuator and over-the-air),
>> so I think it should be left in to keep minstrel honest if nothing else.
>
> ath9k RC shows slightly higher throughput numbers in an _ideal_ environment,
> but that is hardly the case in real-world usage. I agree that the code can
> be left in the driver, it will be useful for comparison with minstrel.

Then default to minstrel, but no need to make people re-compile their
kernel to try a different rate control.  For some users/systems this is
effectively impossible, and for the rest, it is an extra bit of pain.

The point of leaving ath9k rate control in is exactly to help make sure
minstrel has something to compare against.  And if a user happens to know
they have a clean environment always and forever, then ath9k may be
the best solution for them.

It is a trivial amount of change to your patch to enable this
behaviour.  In fact, if you just remove the code I mentioned then
they will *automatically* get defaulted to minstrel regardless of
their kernel config.  The only way to use ath9k rate control after
that is to set the module option in mac80211 (and enable ath9k rate
control for compilation).

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

