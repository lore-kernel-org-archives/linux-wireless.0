Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:44213 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536AbaFYRRw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 13:17:52 -0400
Received: by mail-la0-f54.google.com with SMTP id mc6so1003367lab.13
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 10:17:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XRR0t0DRVBA9o6rz3pU-GckFBmRBRa17pcKpEfqGOx1Q@mail.gmail.com>
References: <CANy8jx+RY-_wbX5JqdF_xwyP+2XQ-V9Ae95Y5MOzd=fyir8KTw@mail.gmail.com>
 <CABPxzYK2xZwwQ4h+ifB6KP9wyr39RF2Z6zrsyZ=0CtC+YceRWQ@mail.gmail.com>
 <CAB=NE6XuAj8jEwLesbSDoyawWh0pWTD-w=L3Jrxx+630QSkm5w@mail.gmail.com>
 <CABPxzYJud-nmSp3gOxA+cPrZpv2Xgo_B9WeVcAnfkY1DSO_q_Q@mail.gmail.com>
 <CAB=NE6U-CaXEh7Mtd+BCNwY8QUGz2Ahc=-+_Zet9aoWDdNpevQ@mail.gmail.com>
 <CABPxzYLnfcG6m3x_QV-EUQQXhpM96n=GDvTJu9DV7Zxp=O_OxA@mail.gmail.com> <CAB=NE6XRR0t0DRVBA9o6rz3pU-GckFBmRBRa17pcKpEfqGOx1Q@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 25 Jun 2014 10:17:30 -0700
Message-ID: <CAB=NE6W-H5DiDi=GrmxSBgVTLjmwPhdiZAn14O4+5uLAhQJt1g@mail.gmail.com> (sfid-20140625_191756_133416_B48F7229)
Subject: Re: max_erip/tx_power not being set correctly
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Ben Greear <greearb@candelatech.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	John Walker <john@x109.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2014 at 2:27 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Wed, Jun 11, 2014 at 6:47 AM, Krishna Chaitanya
> <chaitanya.mgit@gmail.com> wrote:
>> I plan to submit a patch for awk script which can handle both db.txt formats
>> but could not execute it.
>>
>> Will try to submit a hack soon.
>
> OK glad to hear you will address this -- please Cc stable and specify
> the kernels that require this too.

Krishna, how's that coming along? If you don't have time I'll have to
take a stab soon.

> Please also note that there is some
> code on CRDA that could replace the awk script, db2rd but that just
> spits out regular output right now. You will have to revert the AUTO
> patches from wireless-regdb and CRDA right now though, but db2rd could
> be used as base for an implementation for something that provides the
> output of a general data structures just as the awk script does, that
> may be more manageable than the awk script, and although the code is
> under copyleft-next I'd be happy to make an exception to include code
> for a C conversion tool to data structure specifically for the kernel.
> Evne though C code may be better for upstream than the awk script in
> the long run we do need a work around for the awk stuff for stable and
> a C replacement won't fly for stable, so the best approach would be a
> fix for the awk stuff for now and then we can consider a replacement.
>
> Felix mentioned some changes to CRDA / wireless-regdb which could help
> with binary compatibility on the db, perhaps this needs to be
> coordinated with a replacement for the awk script to avoid issues like
> this in the future.
>
>  Luis
