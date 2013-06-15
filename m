Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:57547 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410Ab3FOUT2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Jun 2013 16:19:28 -0400
Received: from mailout-de.gmx.net ([10.1.76.31]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MWdT3-1Uqx4m1Ex1-00XweT for
 <linux-wireless@vger.kernel.org>; Sat, 15 Jun 2013 22:19:27 +0200
Message-ID: <51BCCC4C.9090605@rempel-privat.de> (sfid-20130615_221932_410522_C83DFE1F)
Date: Sat, 15 Jun 2013 22:19:24 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: George Nychis <gnychis@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>
Subject: Re: unable to force transmission rate on injection
References: <CA+7oygcTxgPiVbup6BT-+sJWFNy=nMTc8C7OeCew9Xc6WgQinw@mail.gmail.com> <51BC16A2.8070104@rempel-privat.de> <CA+7oygfLTK87AugE7u7jeLJW=46+Aa-TvcA99foAONxEFECLRg@mail.gmail.com>
In-Reply-To: <CA+7oygfLTK87AugE7u7jeLJW=46+Aa-TvcA99foAONxEFECLRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi George,

Am 15.06.2013 21:58, schrieb George Nychis:
> Hi Oleksij,
>
> Thanks for the heads up that the rate control is in the firmware.  I
> hadn't realized this was open source.  I'll look through it and see
> what I can do.  If anyone out there already has a pre-baked version of
> the firmware to fix this, just let me know.  Otherwise, I'll post a
> patch when done.

you are welcome.
I don't think some one already done this.


> On Sat, Jun 15, 2013 at 3:24 AM, Oleksij Rempel <linux@rempel-privat.de> wrote:
>> Hi George,
>>
>> ath9k_htc use internal rate controller which is located insight of firmware.
>> If you have time, i'll suggest to take it in your hands.
>>
>> Am 15.06.2013 01:58, schrieb George Nychis:
>>>
>>> I have an ath9k_htc card that I am trying to force a transmission rate
>>> on injection.  I did some digging around and found this patch from
>>> Pavel:
>>>
>>> http://article.gmane.org/gmane.linux.kernel.wireless.general/47441
>>>
>>> I updated and implemented that patch in to my kernel, and I see my
>>> injected packets coming down through the code.  I see that the rates I
>>> am trying to transmit pass the test to make sure that the rate is
>>> available:
>>>
>>> [ 1244.647325] *** gnychis: OK on rate 540 -- idx: 11
>>> [ 1244.682061] *** gnychis: OK on rate 480 -- idx: 10
>>> [ 1244.741305] *** gnychis: OK on rate 360 -- idx: 9
>>> ...
>>>
>>> And then I double checked to make sure that, given the flag,
>>> ieee80211_tx_h_rate_ctrl() is *not* being called.  So, to the best of
>>> my knowledge the patch supplied seems to keeping the supplied rate and
>>> disabling rate control.
>>>
>>> But, for some reason it still keeps getting transmitted at a rate of
>>> 1Mbps.  I have verified this with an independent receiver.  If I do a
>>> pcapdump on the transmitting interface, I see two packets for every
>>> transmission.  One at the rate I am trying to transmit at, and another
>>> at 1Mbps:
>>> http://users.ece.cmu.edu/~gnychis/bad_tx.pcap
>>>
>>> Am I missing something else in mac80211 to inject at a specific rate?
>>>
>>> Thanks!
>>> George
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Regards,
Oleksij
