Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:57457 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbZEDSdS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 14:33:18 -0400
Received: by ewy24 with SMTP id 24so4224329ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2009 11:33:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49FF3453.7020802@gmail.com>
References: <1241452330.8683.49.camel@johannes.local> <49FF2AE5.6040104@gmail.com>
	<1241460130.8683.85.camel@johannes.local> <49FF2FE8.8010004@gmail.com>
	<1241460944.8683.92.camel@johannes.local> <49FF3453.7020802@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 4 May 2009 11:33:01 -0700
Message-ID: <43e72e890905041133h1da905a5k1145496d7fdfbfa3@mail.gmail.com>
Subject: Re: [PATCH] mac80211: report operating frequency rather than current
To: Richard Farina <sidhayn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 4, 2009 at 11:30 AM, Richard Farina <sidhayn@gmail.com> wro=
te:
> Johannes Berg wrote:
>>
>> On Mon, 2009-05-04 at 14:11 -0400, Richard Farina wrote:
>>
>>
>>>
>>> Yes, and at what point does it seem like a good idea to hide the ch=
annel
>>> the wifi card is on? =C2=A0If I set channel 11 and it is scanning i=
nstead of
>>> locked on channel 11 then I should see the current channel the hard=
ware is
>>> on. =C2=A0This seems like an aweful idea to me, granted, it may hel=
p a few people
>>> that don't understand how scanning works, but hiding the truth is n=
ever a
>>> good idea. NACK.
>>>
>>
>> It's not really about hiding the truth. Besides, many many devices a=
re
>> _already_ "hiding the truth" (to use your words) because they do
>> scanning in firmware and you never know what channel they're on (e.g=
=2E
>> all Intel wireless hardware).
>>
>> I think it's completely pointless for us to reply to the question "w=
hat
>> channel am I on" with the answer "currently the receiver is tuned to
>> 132", when we can say "you're associated to a network on channel 11"=
=2E
>>
>>
>
> And if the card claims to be associated but ends up stuck on another
> channel? =C2=A0I can't see a good reason for this at all but if no on=
e agrees
> with me then it is well without your power to simply overrule me.
>
> I think it is an awful idea, and intel being broken isn't an excuse t=
o break
> everything else. =C2=A0If the card isn't on the right channel because=
 of some
> random failure this patch ensures there is no way to troubleshoot. =C2=
=A0If you
> want to display current channel that is the hardware channel, if you =
want to
> display "Channel the AP I'm associated to is on" then call it somethi=
ng
> other than "Current Channel"
>
> My 0.02.

Why not show both through iw and for wext just use whatever wext did
for most devices?

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
