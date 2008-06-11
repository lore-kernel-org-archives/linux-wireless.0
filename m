Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:4344 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbYFKV1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 17:27:14 -0400
Received: by an-out-0708.google.com with SMTP id d40so782555and.103
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 14:27:12 -0700 (PDT)
Message-ID: <43e72e890806111426n19059d84v598f7629f57b3b04@mail.gmail.com> (sfid-20080611_232717_677521_00CFF830)
Date: Wed, 11 Jun 2008 14:26:39 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: pommnitz@yahoo.com
Subject: Re: [RFC] First CRDA integration work
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <684075.48049.qm@web51410.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890806110309l2600637p82866531cf2f7e6c@mail.gmail.com>
	 <684075.48049.qm@web51410.mail.re2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2008 at 1:38 PM, Joerg Pommnitz <pommnitz@yahoo.com> wrote:
> --- Luis R. Rodriguez <lrodriguez@atheros.com> wrote am Mi, 11.6.2008:
>
>> Can you elaborate a bit more on it. Why do you need two
>> separate WLAN
>> devices on one node where each one of them is using very
>> different
>> regulatory rules?
>
> The interface connected to the amplifier provides long range communication (up to 5km) on reserved channels. The nodes work as routers/APs that provide access to "normal" WLAN devices (this is where the second wireless device comes into play). So:
> * two WLAN devices: 1x long range with amplifier, 1x short range as AP
> * different regulatory settings: the regulatory rules for the device with amplifier differ from those without amplifier.

OK then yes the current CRDA design covers this. You have a PtP link
(long range 4W) and a PtMP setup (the AP). You can define PtP rules
which are different from PtMP rules. We however still need to then
make mac80211 aware of these differences of type of links. But yes,
the design covers it.

Check out

regdb.h from CRDA, we have RRF_PTP_ONLY and RRF_PTMP_ONLY flags.

So you can just define your own rules with your own db.txt. You know
what you're getting into. Not everyone is allowed to output at 4W so
you can define your own db.txt and sign it yourself.

>> Do they both use the same frequency
>> ranges?
>
> This is not required. Currently both use channels in the 2.4GHz range, but there is a very good chance that we will move into the 5GHz range for the amplified backbone (yes, we know that this will come at a cost).
>
>>   Luis
>
> Thanks for taking an interest

Thanks for reviewing.

  Luis
