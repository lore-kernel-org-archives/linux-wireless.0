Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:54965 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbYLPSan (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 13:30:43 -0500
Received: by yw-out-2324.google.com with SMTP id 9so1386948ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2008 10:30:42 -0800 (PST)
Message-ID: <45e8e6c40812161030x1f7fb374qd4a386ef9022a853@mail.gmail.com> (sfid-20081216_193048_481868_D7680CCE)
Date: Tue, 16 Dec 2008 10:30:42 -0800
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: Keir <keirlawson@gmail.com>
Subject: Re: Mesh now completely broken on ath5k, latest git
Cc: sbrown@cortland.com, linux-wireless@vger.kernel.org,
	javier@cozybit.com
In-Reply-To: <e27b78a40812160807j7549e1a5hf3bee474b31c29b7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e27b78a40812160405h2241e1acqa0dc8e593d6ebfad@mail.gmail.com>
	 <4947ABAF.9060205@cortland.com>
	 <e27b78a40812160807j7549e1a5hf3bee474b31c29b7@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Keir.  What type of Atheros-based card are you using?  How many
antennas do you have connected?  If I understand things correctly, the
PCU code regression (with respect to mesh and maybe AP and IBSS) has
to do with having one antenna hooked up when your hardware also has an
AUX antenna connector.  If you have only one antenna, can you please
plug in a second one and try again (before and after the commit in
question)?  I will try to do the same test here.  More details from
Nick were posted here:
http://marc.info/?l=linux-wireless&m=122771338021489&w=2

On Tue, Dec 16, 2008 at 8:07 AM, Keir <keirlawson@gmail.com> wrote:
> I've been working on the commit previous to the PCU code breakage
> (8485b7f773a8e9883e0165273940f16a086eba2b), but I'm still having
> problems (beaconing is working, but links are rarely established, most
> of the time to packets get through).
>
> Cheers
>
> Keir
>
> 2008/12/16 Steve Brown <sbrown@cortland.com>:
>> Keir wrote:
>>>
>>> Having has no luck with an old rc6 version (basically all plink
>>> packets were getting lost), I upgraded to the newest git (rc8) however
>>> now when I run iw dev mesh0 station sump I don't see a single other
>>> mesh point.  This would imply that presumably beaconing is broken?
>>>
>>> Does anyone know a revision for which ath5k is properly working? I am
>>> yet to find one that works on my system.
>>>
>>> Cheers
>>>
>>> Keir
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> Beaconing seems broken by Update PCU code
>> dd1c9abd167de9bb9457a57694a1ab5e5801a0c1. After this patch, beacon debug
>> says beacons sent, but sniffer sees none.
>>
>> A snapshot of ath5k prior to this and git 12/10
>> (b6d06c9669f27db31a0317fc98fedc8ff1ba4822) works for me with hostapd/wpa.
>> It's been running for the past few days.
>>
>> Mesh beaconing also works. I didn't test two nodes; I only sniffed the
>> beacons.
>>
>> I had to comment out 5GHz in caps.c because of too many channels. It's a
>> nl80211 buffer size problem that's been discussed.
>>
>> Steve
>>
>>
>>
>



-- 
Andrey Yurovsky
cozybit Inc.
