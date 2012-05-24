Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:40409 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab2EXGFm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 02:05:42 -0400
Received: by qcro28 with SMTP id o28so5423358qcr.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2012 23:05:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXffb3tZ2_kWwx0wBWUac-y0BPTT_KBJ5yhxNjPVp4U7HGw@mail.gmail.com>
References: <1337760813-27055-1-git-send-email-arik@wizery.com>
	<87wr436utp.fsf@purkki.adurom.net>
	<CA+XVXfeju02Ou=jZ=eyq+0e4Rm1-5=b6-m8bMyZ8kAWO6F-sXQ@mail.gmail.com>
	<87mx4z6u4n.fsf@purkki.adurom.net>
	<CA+XVXfc3R8CrMfercPpRfYGjvKDdDkwJax+oLiaMrQQPwLCc0Q@mail.gmail.com>
	<87ipfn6koz.fsf@purkki.adurom.net>
	<CA+XVXfcZAE0Drbn_JTBt1p0GAaFrsxZfHNE1Syp=1G=PNsvkbQ@mail.gmail.com>
	<87ehqa6u2d.fsf@purkki.adurom.net>
	<CA+XVXffb3tZ2_kWwx0wBWUac-y0BPTT_KBJ5yhxNjPVp4U7HGw@mail.gmail.com>
Date: Thu, 24 May 2012 08:05:41 +0200
Message-ID: <CAFED-jmwuA2f3joC-V_cf7RACMraR3sLH2pF5e+8b8cka0ovZA@mail.gmail.com> (sfid-20120524_080546_445748_E5C50AA3)
Subject: Re: [PATCH] mac80211: allow setting default U-APSD queues/max_sp_len
 for STA
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: Kalle Valo <kvalo@adurom.com>, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/5/24 Arik Nemtsov <arik@wizery.com>:
> On Thu, May 24, 2012 at 8:12 AM, Kalle Valo <kvalo@adurom.com> wrote:
>> But this was a workaround for an IOP problem with certain APs, right?
>> How is firmware going to be smart in that case?
>>
>> It would help to see what you are exactly planning to do on wl12xx with
>> this interface. Currently I'm just guessing what your plans really are.
>
> The plan is to enable only VO as U-APSD (as I wrote in a previous
> email). We've had problems with some APs (can't remember the models)
> that assume non-VO ACs always use legacy PS. This would lead to
> problems - our driver would never wake up. In that sense the problem
> is general.
>
> But in wl12xx the FW handles network PS on its own (PS-poll etc.), so
> it may just be a bug with our FW. So hard-coding this into mac80211
> seems a bit of an overkill.
>
> Maybe you can offer a better solution?
>

I am not sure this is better.
We do this litte bit different.
So disable all ACs by default in mac80211.

Next we are using wpa_supplicant:
p2p_set client_apsd - and pass required params via nl80211 to mac80211.
So, we could decide which ACs set.
Reassoc from supplicat is required after that.


BR
Janusz
