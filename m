Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34889 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab2EYJ73 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 05:59:29 -0400
Received: by qcro28 with SMTP id o28so449318qcr.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 May 2012 02:59:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXffm=wMjcTxJf333R3TCTAKeyznsCSvis-cjFfT_g4zdRw@mail.gmail.com>
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
	<8762bm6q28.fsf@purkki.adurom.net>
	<CA+XVXffm=wMjcTxJf333R3TCTAKeyznsCSvis-cjFfT_g4zdRw@mail.gmail.com>
Date: Fri, 25 May 2012 11:59:28 +0200
Message-ID: <CAFED-jku-eR52yaUUeJYy+qPak5EC=YKua9FbRLwBsqiUjZtEA@mail.gmail.com> (sfid-20120525_115933_542186_04052202)
Subject: Re: [PATCH] mac80211: allow setting default U-APSD queues/max_sp_len
 for STA
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: Kalle Valo <kvalo@adurom.com>, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/5/25 Arik Nemtsov <arik@wizery.com>:
> On Thu, May 24, 2012 at 9:39 AM, Kalle Valo <kvalo@adurom.com> wrote:
>> Janusz Dziedzic <janusz.dziedzic@gmail.com> writes:
>>
>>> 2012/5/24 Arik Nemtsov <arik@wizery.com>:
>>>
>>>> Maybe you can offer a better solution?
>>>>
>>>
>>> I am not sure this is better.
>>> We do this litte bit different.
>>> So disable all ACs by default in mac80211.
>>>
>>> Next we are using wpa_supplicant:
>>> p2p_set client_apsd - and pass required params via nl80211 to mac80211.
>>> So, we could decide which ACs set.
>>> Reassoc from supplicat is required after that.
>>
>> I was also thinking of something similar:
>>
>> Be concervative in mac80211 and only enable U-APSD for VO, just like
>> Arik was planning to do only for wl12xx. And then add a userspace
>> interface for making it possible to control this and enable/disable
>> classes individually.
>>
>> Or do we already have a user space interface for that?
>
> Well I'm fine with hard-coding it in mac80211 to be VO only.
>
> Are we sure there are real use-cases for changing this dynamically?
> One would have to find out the AP is "bad" (how?), change the queues
> and then re-associate.
> That's why I this user-space is an overkill. But if the consensus here
> is that user space is preferred, I can live with that too.
>
> Janusz - It seems driver_nl80211.c doesn't really pass down the
> "uapsd" parameter to kernel, and consequently mac80211 doesn't get it.
> Are you working with a non-cfg80211 based driver? Or maybe you have an
> internal patch to fix this?
> Btw, it seems the "uapsd" param can be set via the regular wpa_s
> control interface, not only in p2p mode. It's not hard to enable this
> from user space as well (and maybe add it to the config file).
>

Yes, we are using cfg80211/mac80211 and have a patch for that.
But this is for old-compat so I think this should be rewritten for new
one, while WMM and MAX_SP attr was added in meantime...

Question is if this is best interface for application that required UAPSD?
For Android it could be fine, but for linux I am not sure. Maybe iw
param should be added?



BR
Janusz
