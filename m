Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.214.194]:54158 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252Ab1AGCNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 21:13:45 -0500
Received: by iwb12 with SMTP id 12so191061iwb.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 18:13:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1294366072.2704.32.camel@edumazet-laptop>
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com>
 <201101070205.00886.chunkeey@googlemail.com> <1294363427.2704.23.camel@edumazet-laptop>
 <AANLkTinQ42y9Tu=Ugb92-R+56BP4U+cDBzd4tQQCES1W@mail.gmail.com> <1294366072.2704.32.camel@edumazet-laptop>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 6 Jan 2011 18:13:23 -0800
Message-ID: <AANLkTi=+F_O1_2c07zLEGVDSAkuA2_MwghwRQK9pHMN7@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath9k: Decrease skb size to fit into one page.
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	greearb@candelatech.com, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 6, 2011 at 6:07 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 06 janvier 2011 à 17:57 -0800, Luis R. Rodriguez a écrit :
>> On Thu, Jan 6, 2011 at 5:23 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> > Le vendredi 07 janvier 2011 à 02:04 +0100, Christian Lamparter a écrit :
>> >> On Friday 07 January 2011 01:46:03 greearb@candelatech.com wrote:
>> >> > From: Ben Greear <greearb@candelatech.com>
>> >> >
>> >> > Patch is from Eric Dumazet, as described here:
>> >> > https://patchwork.kernel.org/patch/104271/
>> >> >
>> >> > Reported-by: Michael Guntsche <mike@it-loops.com>
>> >> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>> >> > Signed-off-by: Ben Greear <greearb@candelatech.com>
>> >> > ---
>> >> >
>> >> > NOTE:  This needs review by ath9k and/or other informed
>> >> > people.
>> >>
>> >> Does the hardware support vector-i/o for rx (like for instance iwlagn)?
>> >> Else, this change would break A-MSDU rx - which is a mandatory feature
>> >> (although, not very popular) of 802.11n -
>> >>
>> >> See for example 802.11n-2009 9.7c:
>> >>
>> >> "Support for the reception of an A-MSDU, where [...], is mandatory for
>> >> an HT STA"
>> >>
>> >> And 7.1.2 "The maximum frame body size is determined by the maximum
>> >> MSDU size (2304 octets) OR the maximum A-MSDU (3839 or 7935 octets,
>> >> depending upon the STA's capability), plus any overhead from security
>> >> encapsulation.
>> >
>> > Then, only solution is to mark this broken, and perform a copy of each
>> > received frame, to keep a order-1 buffer(s) allocated for hardware.
>>
>> -ENOTPOSSIBLE -- its an WFA requirement to RX AMSDU.
>>
>> > Its too easy to have memory allocation failures for high order pages and
>> > freeze the card.
>>
>> Can't we us paged RX skbs, which mac80211 supports now?
>>
>> See 2f301227a1ede57504694e1f64839839f5737cac and friends.
>>
>
> Maybe you dont understand the point. A fix is needed for stable kernels.
> paged RX skbs is probably a bit complex, even if copy/pasted from other
> drivers.

The only way to accept your patch is to use a debugfs option to
disable it, we need AMSDU support enabled by default.

> If the hardware needs 8192 bytes (or 16384) buffers to perform its
> operation, it should not give them back to linux, because there is no
> guarantee it can allocate fresh ones for the next frames.

Last I looked at this the issue was not the upper used by the driver
but an issue of a roundoff by the kernel that ended up on *some*
machines going a higher order. Not all machines use the higher order.
I wondered at one point if using ksize() might help here too but
again, this is a new API. Not sure how to fix it for older kernels.

  Luis
