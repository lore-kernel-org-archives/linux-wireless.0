Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f194.google.com ([209.85.210.194]:41354 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab1AGB5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 20:57:43 -0500
Received: by iyf40 with SMTP id 40so7631710iyf.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 17:57:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1294363427.2704.23.camel@edumazet-laptop>
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com>
 <201101070205.00886.chunkeey@googlemail.com> <1294363427.2704.23.camel@edumazet-laptop>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 6 Jan 2011 17:57:22 -0800
Message-ID: <AANLkTinQ42y9Tu=Ugb92-R+56BP4U+cDBzd4tQQCES1W@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath9k: Decrease skb size to fit into one page.
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	greearb@candelatech.com, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 6, 2011 at 5:23 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le vendredi 07 janvier 2011 à 02:04 +0100, Christian Lamparter a écrit :
>> On Friday 07 January 2011 01:46:03 greearb@candelatech.com wrote:
>> > From: Ben Greear <greearb@candelatech.com>
>> >
>> > Patch is from Eric Dumazet, as described here:
>> > https://patchwork.kernel.org/patch/104271/
>> >
>> > Reported-by: Michael Guntsche <mike@it-loops.com>
>> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>> > Signed-off-by: Ben Greear <greearb@candelatech.com>
>> > ---
>> >
>> > NOTE:  This needs review by ath9k and/or other informed
>> > people.
>>
>> Does the hardware support vector-i/o for rx (like for instance iwlagn)?
>> Else, this change would break A-MSDU rx - which is a mandatory feature
>> (although, not very popular) of 802.11n -
>>
>> See for example 802.11n-2009 9.7c:
>>
>> "Support for the reception of an A-MSDU, where [...], is mandatory for
>> an HT STA"
>>
>> And 7.1.2 "The maximum frame body size is determined by the maximum
>> MSDU size (2304 octets) OR the maximum A-MSDU (3839 or 7935 octets,
>> depending upon the STA's capability), plus any overhead from security
>> encapsulation.
>
> Then, only solution is to mark this broken, and perform a copy of each
> received frame, to keep a order-1 buffer(s) allocated for hardware.

-ENOTPOSSIBLE -- its an WFA requirement to RX AMSDU.

> Its too easy to have memory allocation failures for high order pages and
> freeze the card.

Can't we us paged RX skbs, which mac80211 supports now?

See 2f301227a1ede57504694e1f64839839f5737cac and friends.

  Luis
