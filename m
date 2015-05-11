Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60856 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbbEKQRq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 12:17:46 -0400
Message-ID: <5550D629.2090501@candelatech.com> (sfid-20150511_181749_924304_96B58075)
Date: Mon, 11 May 2015 09:17:45 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Liu CF/TW <cfliu.tw@gmail.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k/mac80211: add rawtxrx, nohwcrypt module param
 for raw tx injection, sw crypto support.
References: <CAG5N3qG7090vB6XoUaQSHvQw7GpE+gXvJAbKrv7def3nV0OFJw@mail.gmail.com> <873837qo6l.fsf@kamboji.qca.qualcomm.com> <554CE438.5000208@candelatech.com> <CAG5N3qFB=yZJYSokUqF2=eNcS5SoCOntOyan6_OuahtFF5r=Bw@mail.gmail.com> <871tinjosq.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <871tinjosq.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/11/2015 05:12 AM, Kalle Valo wrote:
> "Liu CF/TW" <cfliu.tw@gmail.com> writes:
> 
>>>> I wonder does it make any sense to have nohwcrypt parameter? Especially
>>>> if ath10k doesn't support case rawtxrx=0 and nohwcrypt=1. One
>>>> possibility I came up is to have multiple values for rawtxrx, for
>>>> example is rawtxrx=1 means HW crypt enabled and rawtxrx=2 HW crypt
>>>> disabled. Ideas welcome.
>>
>> Indeed. I picked nohwcrypt because it seems to be the convention in
>> previous Atheros drivers for this feature.
> 
> Yeah, but I don't think we need to follow that in ath10k. Especially not
> until we get SW encryption working in all cases.

What do you mean 'all cases'?  Many upstream firmware builds will just
crash if you try raw tx, regardless of any encryption options.


>> In this case, I will drop nohwcrypt and do as you suggested.
>>
>> rawmode = 0: Raw mode disabled. Use the default native WiFi mode. In
>> this mode, only HW crypto is supported.
>> rawmode = 1: Use Raw rx decap + raw tx encap mode. Supports both SW
>> and HW crypto.
>> rawmode = 2: Same as 1, but with HW crypto engine globally disabled.
> 
> I would guess that HW crypto globally disabled (value 2 above) will be
> more popular, right? So would it make sense to reverse the values and
> use value 1 for that?

You are combining multiple different (but related) things into a single
enum.  Maybe make it a bitfield instead so that new combinations can be
added later w/out making such a mess in the code?


>> When rawmode = 1, I want a further per BSS control to make some BSS
>> use HW crypto and some BSS bypass HW crypto.
>> For those BSS that have HW crypto bypassed, their data frames may come
>> from either the normal wlan interfaces (therefore mac80211 sw crypto
>> used), or from monitor interfaces (therefore Tx injected frames
>> already encrypted + Rx frames still encrypted)
> 
> Ok, we need to think how to configure this. Maybe a debugfs interface?

I'm curious the order of operations...seems like you will have to create
and start using the BSS before you get access to it in debugfs?  Or are you
going to create a table of mac-addresses or something like that?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

