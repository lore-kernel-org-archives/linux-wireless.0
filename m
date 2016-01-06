Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:43765 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbcAFJJk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2016 04:09:40 -0500
Subject: Re: Mac80211 : Wpa rekeying issue
To: Johannes Berg <johannes@sipsolutions.net>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	voncken <cedric.voncken@acksys.fr>
References: <773DB8A82AB6A046AE0195C68612A31901C5B5A9@sbs2003.acksys.local>
 <CANUX_P2k-Feexi5=gBm+UxsFkoic7FeGDFcNa_D3J2ujYL2ghQ@mail.gmail.com>
 <0a5101d1424c$eb46d2d0$c1d47870$@acksys.fr>
 <0a6a01d143a2$fcb77720$f6266560$@acksys.fr>
 <CANUX_P2pF_He3mruTxMU_poBXzZpa9rXA7AgYV_RQ4BJ9wS6Mg@mail.gmail.com>
 <568B912F.8070100@neratec.com> <1451987939.12357.18.camel@sipsolutions.net>
 <568BA0E3.5080905@neratec.com> <1452009029.12357.37.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Matthias May <matthias.may@neratec.com>
Message-ID: <568CD9D1.6080001@neratec.com> (sfid-20160106_101013_553792_339308A5)
Date: Wed, 6 Jan 2016 10:09:37 +0100
MIME-Version: 1.0
In-Reply-To: <1452009029.12357.37.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/01/16 16:50, Johannes Berg wrote:
> On Tue, 2016-01-05 at 11:54 +0100, Matthias May wrote:
>>
>> Not safe as in "access to stuff which has to be locked", or not safe
>> as
>> in "a CCMP replay attack is possible"?
>> When changing this we argumented that since we are not really
>> connected
>> yet, a CCMP replay attack doesn't really make sense.
>>
>
> It's a bit more complicated than my first look suggested, it seems.
>
> However, I'm not sure what effect your patch is supposed to have.
> You're skipping CCMP replay checking and update when not authorized
> yet, at which point the station isn't receiving frames anyway (though
> they'd be checked for all this, they'd later be discarded).
>
> Once it becomes authorized, you do the checks. However, it never
> becomes unauthorized again, even for rekeying, so for the PTK rekeying
> issue at hand it's pretty much a no-op?
>
afaik it solves the issue that when a STA roames from AP1 to AP2, and 
key material is installed at different times.
We observed encrypted frames which had a wrong CCMP counter. If the STA 
updates it's counter with these frames then depending on the wrong CCMP 
value received, up to a few hundred frames were dropped.
Not exactly the same as rekeying but the effect are pretty similar.

> johannes
>
> PS: the comment in your patch is also wrong:
>
>> +               /* If we are a station update the ccmp counter only when we are
>> +                * authorised. For all other modes always update. */
>> +               if (!rx->sta ||
>> +                   (rx->sta && test_sta_flag(rx->sta, WLAN_STA_AUTHORIZED)) ) {
>
> There's no check for "if we are a station" here.
>
Yeah this doesn't make sense.
Also the check on !rx-sta seems superfluous since it's already checked a 
few lines above.

Regards
Matthias
