Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:54816 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbZCUTqX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 15:46:23 -0400
Received: by wf-out-1314.google.com with SMTP id 29so2010401wff.4
        for <linux-wireless@vger.kernel.org>; Sat, 21 Mar 2009 12:46:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237646363.5100.209.camel@johannes.local>
References: <1237646363.5100.209.camel@johannes.local>
Date: Sat, 21 Mar 2009 12:46:06 -0700
Message-ID: <43e72e890903211246r5e5aa2cev7ad3e790716966ed@mail.gmail.com> (sfid-20090321_204629_010688_0DF7E3BC)
Subject: Re: Japan regulations
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 21, 2009 at 7:39 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> The regulatory info for JP looks very odd
> (http://wireless.kernel.org/en/developers/Regulatory/Database?alpha2=3D=
JP):
>
> country JP:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(2402.000 - 2472.000 @ 40.000), (N/A, 20.0=
0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(2457.000 - 2482.000 @ 20.000), (N/A, 20.0=
0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(2474.000 - 2494.000 @ 20.000), (N/A, 20.0=
0), NO-OFDM
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(4910.000 - 4930.000 @ 10.000), (N/A, 23.0=
0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(4910.000 - 4990.000 @ 40.000), (N/A, 23.0=
0)
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(4930.000 - 4950.000 @ 10.000), (N/A, 23.0=
0)
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(5030.000 - 5045.000 @ 10.000), (N/A, 23.0=
0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(5030.000 - 5090.000 @ 40.000), (N/A, 23.0=
0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(5050.000 - 5060.000 @ 10.000), (N/A, 23.0=
0)
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(5170.000 - 5250.000 @ 40.000), (N/A, 20.0=
0)
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(5250.000 - 5330.000 @ 40.000), (N/A, 20.0=
0), DFS
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(5490.000 - 5710.000 @ 40.000), (N/A, 23.0=
0), DFS
>
> multiple of the ranges (blocked) overlap, especially the 4910 MHz par=
t
> is strange, seems like that first rule should be killed.

Yeah, I think you're right. The second rule seems to imply the 10 MHz
width part as well.

> Also, how
> should the 2.4GHz part be interpreted?

Channels 1-11 allow 40 width channels, so HT40 is allowed.
Channels 12, 13 only allow 20 MHz width channels, so HT40 is disallowed=
=2E
Channel 14 only allows OFDM.

> Currently we are not interpreting overlapping ranges properly at all =
--
> we really need to fix a set of interpretation rules.

Sort of, we currently stick to the first reg rule which fits our
desired bandwidth. Right now we iterate through 2 possible max
bandwidths -- 40 and 20 and then set the channel max bandwidth based
on which one fits. Note though that we do disregard the freq_range max
bandwidth, which my patches correct.

We also need to consider for future usage custom bandwidths, which I
guess why we had the first JP rule for 4 GHz (but yeah the second rule
seem to imply what the first one intends on allowing). First step
might be to say allow drivers to use monitor mode with 10 MHz
bandwidth or 5 MHz bandwidth. That of course would also need further
work other than regulatory.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
