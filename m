Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f160.google.com ([209.85.217.160]:34409 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbZDHO6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 10:58:45 -0400
Received: by gxk4 with SMTP id 4so320708gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 08 Apr 2009 07:58:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49DCA8E3.3060603@gmail.com>
References: <49DCA8E3.3060603@gmail.com>
Date: Wed, 8 Apr 2009 10:58:42 -0400
Message-ID: <b6c5339f0904080758k2be9ae3dm1a98b564f3b10867@mail.gmail.com> (sfid-20090408_165848_526493_1A4F6624)
Subject: Re: [Fwd: Re: Trouble Associating with ath5k on AR5212]
From: Bob Copeland <me@bobcopeland.com>
To: Will Keaney <keaneyw@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 8, 2009 at 9:38 AM, Will Keaney <keaneyw@gmail.com> wrote:
>> Hmm, you should be seeing association requests in any case. =A0How a=
re
>> you starting the wireless network? =A0Can you try setting the -dd op=
tion
>> to wpa_supplicant?
>>
> I'm starting it by modprobing ath5k or ath_pci, depending on what nee=
ds
> to be tested. =A0udev calls Gentoo's init script for the interface th=
at's
> created, which starts wpa_supplicant. =A0I can add debugging flags as=
 well.

Ok, please do and post the log.

> When testing with the guest wireless at work today, I got the attache=
d
> error in dmesg. =A0I only got it once, and haven't been able to repro=
duce
> it, but thought it might be of interest.

Very much so, thanks for the report (probably has no bearing on your ca=
se,
but this is the first example since we added more debugging).

> [ 6260.056213] Hardware name: 6459CTO
> [ 6260.056218] invalid hw_rix: 1a

0x1a is ATH5K_RATE_CODE_2M, certainly a valid rate for 2 GHz.. somethin=
g's
broken.  This is pretty rare though so I think it is some sort of race
condition when switching over to 5 GHz.

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
