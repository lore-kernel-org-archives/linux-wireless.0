Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.191]:59219 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523AbYLPQHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 11:07:18 -0500
Received: by rn-out-0910.google.com with SMTP id k40so2602316rnd.17
        for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2008 08:07:16 -0800 (PST)
Message-ID: <e27b78a40812160807j7549e1a5hf3bee474b31c29b7@mail.gmail.com> (sfid-20081216_170722_990812_216D3B4A)
Date: Tue, 16 Dec 2008 16:07:16 +0000
From: Keir <keirlawson@gmail.com>
To: sbrown@cortland.com
Subject: Re: Mesh now completely broken on ath5k, latest git
Cc: linux-wireless@vger.kernel.org,
	"Andrey Yurovsky" <andrey@cozybit.com>, javier@cozybit.com
In-Reply-To: <4947ABAF.9060205@cortland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e27b78a40812160405h2241e1acqa0dc8e593d6ebfad@mail.gmail.com>
	 <4947ABAF.9060205@cortland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been working on the commit previous to the PCU code breakage
(8485b7f773a8e9883e0165273940f16a086eba2b), but I'm still having
problems (beaconing is working, but links are rarely established, most
of the time to packets get through).

Cheers

Keir

2008/12/16 Steve Brown <sbrown@cortland.com>:
> Keir wrote:
>>
>> Having has no luck with an old rc6 version (basically all plink
>> packets were getting lost), I upgraded to the newest git (rc8) however
>> now when I run iw dev mesh0 station sump I don't see a single other
>> mesh point.  This would imply that presumably beaconing is broken?
>>
>> Does anyone know a revision for which ath5k is properly working? I am
>> yet to find one that works on my system.
>>
>> Cheers
>>
>> Keir
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> Beaconing seems broken by Update PCU code
> dd1c9abd167de9bb9457a57694a1ab5e5801a0c1. After this patch, beacon debug
> says beacons sent, but sniffer sees none.
>
> A snapshot of ath5k prior to this and git 12/10
> (b6d06c9669f27db31a0317fc98fedc8ff1ba4822) works for me with hostapd/wpa.
> It's been running for the past few days.
>
> Mesh beaconing also works. I didn't test two nodes; I only sniffed the
> beacons.
>
> I had to comment out 5GHz in caps.c because of too many channels. It's a
> nl80211 buffer size problem that's been discussed.
>
> Steve
>
>
>
