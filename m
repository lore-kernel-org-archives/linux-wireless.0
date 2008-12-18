Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:40503 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYLRVCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 16:02:42 -0500
Received: by qw-out-2122.google.com with SMTP id 3so142020qwe.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2008 13:02:41 -0800 (PST)
Message-ID: <494ABA6D.8070002@cortland.com> (sfid-20081218_220250_609056_A6B8A1A8)
Date: Thu, 18 Dec 2008 16:02:37 -0500
From: Steve Brown <sbrown@cortland.com>
Reply-To: sbrown@cortland.com
MIME-Version: 1.0
To: Bob Copeland <bcopeland@gmail.com>
CC: Keir <keirlawson@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org, javier@cozybit.com
Subject: Re: Mesh now completely broken on ath5k, latest git
References: <e27b78a40812160405h2241e1acqa0dc8e593d6ebfad@mail.gmail.com>	 <4947ABAF.9060205@cortland.com>	 <e27b78a40812160807j7549e1a5hf3bee474b31c29b7@mail.gmail.com>	 <45e8e6c40812161030x1f7fb374qd4a386ef9022a853@mail.gmail.com>	 <40f31dec0812170906vd8e4445q9920c66905064df8@mail.gmail.com>	 <e27b78a40812171004r3a8d424dk7c390aaf7c757665@mail.gmail.com>	 <494A578A.7070803@cortland.com> <b6c5339f0812181138s1ba134a6qeff21eb063a87e08@mail.gmail.com>
In-Reply-To: <b6c5339f0812181138s1ba134a6qeff21eb063a87e08@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> On Thu, Dec 18, 2008 at 9:00 AM, Steve Brown <sbrown@cortland.com> wrote:
>   
>> I did a binary chop on the pcu patch. Reverting this part of the patch
>> restores ap and mesh beaconing. I've no idea why.
>>
>> 77: +               else
>> 78: +                       AR5K_REG_ENABLE_BITS(ah, AR5K_CFG,
>> AR5K_CFG_ADHOC);
>>     
>
> Hmm, that looks exactly backwards, shouldn't it be DISABLE_BITS
> (and ENABLE_BITS in the adhoc case?)
>
> I think it's supposed to be 0 for AP/STA and 1 for IBSS.
>
>   
Your interpretation matches the recently released hal source. I switched 
them around in the pcu patch and ap/mesh beacons return.

Lots of these however:
Dec 18 15:53:20 fl-ws kernel: ath5k phy23: beacon queue 7 didn't stop?

If I make the same change to the current git, still no beacons. But, the 
"queue 7" msgs persist.

Anyway, it's not antenna related.

Steve
 
