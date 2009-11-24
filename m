Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f223.google.com ([209.85.218.223]:58827 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198AbZKXMDG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 07:03:06 -0500
Received: by bwz23 with SMTP id 23so6215969bwz.29
        for <linux-wireless@vger.kernel.org>; Tue, 24 Nov 2009 04:03:10 -0800 (PST)
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>
Subject: Re: [PATCH] ath9k: fix processing of TX PS null data frames
References: <1259049205-32596-1-git-send-email-lrodriguez@atheros.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 24 Nov 2009 14:03:08 +0200
In-Reply-To: <1259049205-32596-1-git-send-email-lrodriguez@atheros.com> (Luis R. Rodriguez's message of "Tue\, 24 Nov 2009 02\:53\:25 -0500")
Message-ID: <87hbskb05f.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <lrodriguez@atheros.com> writes:

> When mac80211 was telling us to go into Powersave we listened
> and immediately turned RX off. This meant hardware would not
> see the ACKs from the AP we're associated with and hardware
> we'd end up retransmiting the null data frame in a loop
> helplessly.
>
> Fix this by keeping track of the transmitted nullfunc frames
> and only when we are sure the AP has sent back an ACK do we
> go ahead and shut RX off.

[...]

> This should illustrate some changes we need on mac80211 to help
> with enabling and completing dynamic PS. 

To be exact this is not about dynamic power save but
HW_PS_NULLFUNC_STACK support.

> The If we don't get an ACK we be able to tell mac80211 enabling
> dynamic PS failed so it can stop assuming we've successfully enabled
> it.

Yes, currently mac80211 assumes that the hardware will wait for the
ack before turning off radios. It might be a bit tricky to implement
the ack delay in mac80211, for example we need to support the case
when timeout is zero. Adding more timers to mac80211 creates more
bugs.

Also mac80211 doesn't check at all if the nullfunc frame reached the
AP or not. I think that should be also fixed because it's a problem
with every driver using IEEE80211_HW_PS_NULLFUNC_STACK.

> Curious how this works with other hardware. When you enable
> dynamic PS can you easily check for the ACK from the AP?

On stlc45xx firmware does go to sleep before ACK is received.

> What can we do on mac80211 to help with this without making it
> too complex?

What drivers need this? I guess at least ath5k and ath9k? Is it
simpler if we just implement this in driver and not in mac80211? (Just
asking, I don't have an opinion yet.)

-- 
Kalle Valo
