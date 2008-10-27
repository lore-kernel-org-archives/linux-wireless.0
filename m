Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:18504 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYJ0Uik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 16:38:40 -0400
Received: by yx-out-2324.google.com with SMTP id 8so568353yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Oct 2008 13:38:39 -0700 (PDT)
Message-ID: <40f31dec0810271331n7f374562x77da8ae55b9032db@mail.gmail.com> (sfid-20081027_213845_210400_CB2B5E1D)
Date: Mon, 27 Oct 2008 22:31:22 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Elias Oltmanns" <eo@nebensachen.de>
Subject: Re: [PATCH] ath5k: Fix reset sequence for AR5212 in general and RF5111 in particular
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Jiri Slaby" <jirislaby@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <87r663t1ds.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <87prlr9mna.fsf@denkblock.local>
	 <40f31dec0810251621l3d720a69mf21b5253e9135010@mail.gmail.com>
	 <87abcrtfa8.fsf@denkblock.local>
	 <40f31dec0810261132w2747d66em2a2a53ff9e1ecc04@mail.gmail.com>
	 <87wsfvt76q.fsf@denkblock.local>
	 <40f31dec0810261533g3143bd9bue0f3eff88c6936e9@mail.gmail.com>
	 <87r663t1ds.fsf@denkblock.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/27 Elias Oltmanns <eo@nebensachen.de>:
> "Nick Kossifidis" <mickflemm@gmail.com> wrote:
>> 2008/10/26 Elias Oltmanns <eo@nebensachen.de>:
>>>
>>
>>>                /*
>>>                 * Write some more initial register settings
>>>                 */
>>> -               if (ah->ah_version == AR5K_AR5212) {
>>> +               if (ah->ah_version == AR5K_AR5212 &&
>>> +                   ah->ah_radio > AR5K_RF5111) {
>>
>> even better: ah->ah_phy_revision > AR5K_SREV_PHY_5212
>
> Just to be absolutely sure: ah->ah_phy_revision >= AR5K_SREV_PHY_5212
> right?
>

AR5K_SREV_PHY_5212 is bb rev 1 so its

ah->ah_phy > AR5K_SREV_PHY_5212

>
> Well, I'm always happy to leave the work to others ;-). The only reason
> why I kept resending patches was to make sure that a minimal fix would
> get merged into a stable release eventually. Presumably, a rework of the
> reset sequence in itself would not be appropriate for stable. Still, if
> you'll take care get something into stable, that's fine with me.
> Otherwise, just let me know and I'll keep those patches coming and you
> occupied reviewing them ;-).
>
> Regards,
>
> Elias
>

O.K. then we 'll include your patch on stable and my work will go on
wireless-dev for further testing ;-)

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
