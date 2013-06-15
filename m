Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:37760 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab3FOT6Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Jun 2013 15:58:25 -0400
Received: by mail-pa0-f41.google.com with SMTP id bj3so1650313pad.0
        for <linux-wireless@vger.kernel.org>; Sat, 15 Jun 2013 12:58:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51BC16A2.8070104@rempel-privat.de>
References: <CA+7oygcTxgPiVbup6BT-+sJWFNy=nMTc8C7OeCew9Xc6WgQinw@mail.gmail.com>
	<51BC16A2.8070104@rempel-privat.de>
Date: Sat, 15 Jun 2013 15:58:24 -0400
Message-ID: <CA+7oygfLTK87AugE7u7jeLJW=46+Aa-TvcA99foAONxEFECLRg@mail.gmail.com> (sfid-20130615_215828_119903_94C2E5FD)
Subject: Re: unable to force transmission rate on injection
From: George Nychis <gnychis@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Oleksij,

Thanks for the heads up that the rate control is in the firmware.  I
hadn't realized this was open source.  I'll look through it and see
what I can do.  If anyone out there already has a pre-baked version of
the firmware to fix this, just let me know.  Otherwise, I'll post a
patch when done.

- George

On Sat, Jun 15, 2013 at 3:24 AM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Hi George,
>
> ath9k_htc use internal rate controller which is located insight of firmware.
> If you have time, i'll suggest to take it in your hands.
>
> Am 15.06.2013 01:58, schrieb George Nychis:
>>
>> I have an ath9k_htc card that I am trying to force a transmission rate
>> on injection.  I did some digging around and found this patch from
>> Pavel:
>>
>> http://article.gmane.org/gmane.linux.kernel.wireless.general/47441
>>
>> I updated and implemented that patch in to my kernel, and I see my
>> injected packets coming down through the code.  I see that the rates I
>> am trying to transmit pass the test to make sure that the rate is
>> available:
>>
>> [ 1244.647325] *** gnychis: OK on rate 540 -- idx: 11
>> [ 1244.682061] *** gnychis: OK on rate 480 -- idx: 10
>> [ 1244.741305] *** gnychis: OK on rate 360 -- idx: 9
>> ...
>>
>> And then I double checked to make sure that, given the flag,
>> ieee80211_tx_h_rate_ctrl() is *not* being called.  So, to the best of
>> my knowledge the patch supplied seems to keeping the supplied rate and
>> disabling rate control.
>>
>> But, for some reason it still keeps getting transmitted at a rate of
>> 1Mbps.  I have verified this with an independent receiver.  If I do a
>> pcapdump on the transmitting interface, I see two packets for every
>> transmission.  One at the rate I am trying to transmit at, and another
>> at 1Mbps:
>> http://users.ece.cmu.edu/~gnychis/bad_tx.pcap
>>
>> Am I missing something else in mac80211 to inject at a specific rate?
>>
>> Thanks!
>> George
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> --
> Regards,
> Oleksij
