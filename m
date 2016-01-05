Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:45743 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbcAEKyc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 05:54:32 -0500
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
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Matthias May <matthias.may@neratec.com>
Message-ID: <568BA0E3.5080905@neratec.com> (sfid-20160105_115436_179512_0DC38BEB)
Date: Tue, 5 Jan 2016 11:54:27 +0100
MIME-Version: 1.0
In-Reply-To: <1451987939.12357.18.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/01/16 10:58, Johannes Berg wrote:
> On Tue, 2016-01-05 at 10:47 +0100, Matthias May wrote:
>
>>
>> We've encountered exactly this problem in a mix of devices where one
>> applies key material faster than the other. (ath9k and aquilla)
>> As a workaround we check on the STA if we are authorized when
>> updating/checking CCMP. (see attached patches)
>>
>
> Those don't really seem safe to use either.
>
> johannes
>

Not safe as in "access to stuff which has to be locked", or not safe as 
in "a CCMP replay attack is possible"?
When changing this we argumented that since we are not really connected 
yet, a CCMP replay attack doesn't really make sense.

Matthias
