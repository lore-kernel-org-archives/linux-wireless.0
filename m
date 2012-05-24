Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:49722 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab2EXGjM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 02:39:12 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: allow setting default U-APSD queues/max_sp_len for STA
References: <1337760813-27055-1-git-send-email-arik@wizery.com>
	<87wr436utp.fsf@purkki.adurom.net>
	<CA+XVXfeju02Ou=jZ=eyq+0e4Rm1-5=b6-m8bMyZ8kAWO6F-sXQ@mail.gmail.com>
	<87mx4z6u4n.fsf@purkki.adurom.net>
	<CA+XVXfc3R8CrMfercPpRfYGjvKDdDkwJax+oLiaMrQQPwLCc0Q@mail.gmail.com>
	<87ipfn6koz.fsf@purkki.adurom.net>
	<CA+XVXfcZAE0Drbn_JTBt1p0GAaFrsxZfHNE1Syp=1G=PNsvkbQ@mail.gmail.com>
	<87ehqa6u2d.fsf@purkki.adurom.net>
	<CA+XVXffb3tZ2_kWwx0wBWUac-y0BPTT_KBJ5yhxNjPVp4U7HGw@mail.gmail.com>
	<CAFED-jmwuA2f3joC-V_cf7RACMraR3sLH2pF5e+8b8cka0ovZA@mail.gmail.com>
Date: Thu, 24 May 2012 09:39:11 +0300
In-Reply-To: <CAFED-jmwuA2f3joC-V_cf7RACMraR3sLH2pF5e+8b8cka0ovZA@mail.gmail.com>
	(Janusz Dziedzic's message of "Thu, 24 May 2012 08:05:41 +0200")
Message-ID: <8762bm6q28.fsf@purkki.adurom.net> (sfid-20120524_083914_616295_5C00AF36)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@gmail.com> writes:

> 2012/5/24 Arik Nemtsov <arik@wizery.com>:
>
>> Maybe you can offer a better solution?
>>
>
> I am not sure this is better.
> We do this litte bit different.
> So disable all ACs by default in mac80211.
>
> Next we are using wpa_supplicant:
> p2p_set client_apsd - and pass required params via nl80211 to mac80211.
> So, we could decide which ACs set.
> Reassoc from supplicat is required after that.

I was also thinking of something similar:

Be concervative in mac80211 and only enable U-APSD for VO, just like
Arik was planning to do only for wl12xx. And then add a userspace
interface for making it possible to control this and enable/disable
classes individually.

Or do we already have a user space interface for that?

-- 
Kalle Valo
