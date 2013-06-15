Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54179 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab3FOHYZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Jun 2013 03:24:25 -0400
Received: from mailout-de.gmx.net ([10.1.76.20]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0Mfl1O-1Uztwp2tEa-00NDnW for
 <linux-wireless@vger.kernel.org>; Sat, 15 Jun 2013 09:24:23 +0200
Message-ID: <51BC16A2.8070104@rempel-privat.de> (sfid-20130615_092428_341770_32BC002F)
Date: Sat, 15 Jun 2013 09:24:18 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: George Nychis <gnychis@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>
Subject: Re: unable to force transmission rate on injection
References: <CA+7oygcTxgPiVbup6BT-+sJWFNy=nMTc8C7OeCew9Xc6WgQinw@mail.gmail.com>
In-Reply-To: <CA+7oygcTxgPiVbup6BT-+sJWFNy=nMTc8C7OeCew9Xc6WgQinw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi George,

ath9k_htc use internal rate controller which is located insight of 
firmware. If you have time, i'll suggest to take it in your hands.

Am 15.06.2013 01:58, schrieb George Nychis:
> I have an ath9k_htc card that I am trying to force a transmission rate
> on injection.  I did some digging around and found this patch from
> Pavel:
>
> http://article.gmane.org/gmane.linux.kernel.wireless.general/47441
>
> I updated and implemented that patch in to my kernel, and I see my
> injected packets coming down through the code.  I see that the rates I
> am trying to transmit pass the test to make sure that the rate is
> available:
>
> [ 1244.647325] *** gnychis: OK on rate 540 -- idx: 11
> [ 1244.682061] *** gnychis: OK on rate 480 -- idx: 10
> [ 1244.741305] *** gnychis: OK on rate 360 -- idx: 9
> ...
>
> And then I double checked to make sure that, given the flag,
> ieee80211_tx_h_rate_ctrl() is *not* being called.  So, to the best of
> my knowledge the patch supplied seems to keeping the supplied rate and
> disabling rate control.
>
> But, for some reason it still keeps getting transmitted at a rate of
> 1Mbps.  I have verified this with an independent receiver.  If I do a
> pcapdump on the transmitting interface, I see two packets for every
> transmission.  One at the rate I am trying to transmit at, and another
> at 1Mbps:
> http://users.ece.cmu.edu/~gnychis/bad_tx.pcap
>
> Am I missing something else in mac80211 to inject at a specific rate?
>
> Thanks!
> George
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Regards,
Oleksij
