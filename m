Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:53323 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbZCVSIy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 14:08:54 -0400
Received: by rv-out-0506.google.com with SMTP id f9so1435858rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Mar 2009 11:08:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237710503.5100.731.camel@johannes.local>
References: <1237646363.5100.209.camel@johannes.local> <43e72e890903211246r5e5aa2cev7ad3e790716966ed@mail.gmail.com>
	<1237710503.5100.731.camel@johannes.local>
Date: Sun, 22 Mar 2009 11:08:37 -0700
Message-ID: <43e72e890903221108i759936ecnbc76aa7a07a3106d@mail.gmail.com> (sfid-20090322_190857_501771_D4B19ABF)
Subject: Re: Japan regulations
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 22, 2009 at 1:28 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2009-03-21 at 12:46 -0700, Luis R. Rodriguez wrote:
>
>> > country JP:
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0(2402.000 - 2472.000 @ 40.000), (N/A, 2=
0.00)
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0(2457.000 - 2482.000 @ 20.000), (N/A, 2=
0.00)
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0(2474.000 - 2494.000 @ 20.000), (N/A, 2=
0.00), NO-OFDM
>
>> > Also, how
>> > should the 2.4GHz part be interpreted?
>>
>> Channels 1-11 allow 40 width channels, so HT40 is allowed.
>> Channels 12, 13 only allow 20 MHz width channels, so HT40 is disallo=
wed.
>> Channel 14 only allows OFDM.
>
> s/OFDM/non-OFDM/
>
> Ok, this is a bit of a problem. Let me break out of this thread and
> propose new, slightly changed, interpretation rules.
>
>> > Currently we are not interpreting overlapping ranges properly at a=
ll --
>> > we really need to fix a set of interpretation rules.
>>
>> Sort of, we currently stick to the first reg rule which fits our
>> desired bandwidth. Right now we iterate through 2 possible max
>> bandwidths -- 40 and 20 and then set the channel max bandwidth based
>> on which one fits. Note though that we do disregard the freq_range m=
ax
>> bandwidth, which my patches correct.
>
> True. I'm rather keen on removing that code though -- it is rather
> confusing to hardcode 20/40 in there and try them.

Agreed, which is why I got rid of them in my patches too.

>> We also need to consider for future usage custom bandwidths, which I
>> guess why we had the first JP rule for 4 GHz (but yeah the second ru=
le
>> seem to imply what the first one intends on allowing). First step
>> might be to say allow drivers to use monitor mode with 10 MHz
>> bandwidth or 5 MHz bandwidth. That of course would also need further
>> work other than regulatory.
>
> Indeed. The question is how we want to capture this. So far I was alw=
ays
> thinking that we would capture this as an extra channel type -- like
> HT40+, but going the other direction -- "10MHZ"/"5MHZ".

That would work.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
