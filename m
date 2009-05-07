Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:14185 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbZEGRVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2009 13:21:08 -0400
MIME-Version: 1.0
In-Reply-To: <4A02B1CA.3060708@hiramoto.org>
References: <43e72e890905070104u59eebcceu18718a733e388cc9@mail.gmail.com>
	<4A02B1CA.3060708@hiramoto.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 7 May 2009 10:20:48 -0700
Message-ID: <43e72e890905071020v26857c52p3abea96be04ef1d9@mail.gmail.com>
Subject: Re: [ath9k-devel] New kernel recommendations for ath9k
To: Karl Hiramoto <karl@hiramoto.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 7, 2009 at 3:02 AM, Karl Hiramoto <karl@hiramoto.org> wrote=
:
> Luis R. Rodriguez wrote:
>>
>> For those not subscribed to the ath9k wiki on wireless.kernel.org [1=
]
>> (which we recommend you do if you're a user) here's a quick note to
>> let you know our latest kernel recommendations for using ath9k:
>>
>> =C2=A0* =C2=A0>=3D 2.6.27.22
>> =C2=A0* =C2=A0>=3D 2.6.28.10
>> =C2=A0* =C2=A02.6.29
>>
>> If you want 802.11n support or AP support you'll want at least 2.6.2=
9.
>> If you happen to have one of our new 1x1 AR9285 devices (all AR9285
>> devices are 1x1) then you'll need at least 2.6.29. If you want to
>> start using ath9k on APs with AHB you will need at least 2.6.30 (sti=
ll
>> in RC series).
>>
>> As usual if you happen to be stuck on older kernels for one reason o=
r
>> another you can always use compat-wireless [2] and if that happens t=
o
>> be a little too bleeding edge we have now compat-wireless releases f=
or
>> stable kernel releases, starting as of the 2.6.30-rc series [3].
>>
>> =C2=A0Luis
>>
>> [1] http://wireless.kernel.org/en/users/Drivers/ath9k
>> [2] http://wireless.kernel.org/en/users/Download
>> [3] http://wireless.kernel.org/en/users/Download/stable
>>
>
> Thanks for the update. =C2=A0If i want to use multiple AP's with Ath9=
k it it
> still best to use wireless-testing? =C2=A0Is multiple AP support in 2=
=2E6.30-rc
> series net-next or wireless-next?

Yeah wireless-testing is best for that. I should also mention that if
you want to use AP mode you want to be at least on 2.6.29 (your own
kernel, not the compat-wireless one) if you care about Power Save
buffering on the AP as otherwise even if you use a compat-wireless
with code from > 2.6.29 those frames will be dropped. IIRC its due to
the way we use skb->cb for this and there not being a clean way to
backport this (so we just drop them).

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
