Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58968 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753210AbdHXQRt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 12:17:49 -0400
Received: from mail-io0-f198.google.com ([209.85.223.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1dkupI-0000wJ-JZ
        for linux-wireless@vger.kernel.org; Thu, 24 Aug 2017 16:17:48 +0000
Received: by mail-io0-f198.google.com with SMTP id m26so9581077iod.3
        for <linux-wireless@vger.kernel.org>; Thu, 24 Aug 2017 09:17:48 -0700 (PDT)
Date: Thu, 24 Aug 2017 11:17:44 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
        simon.wunderlich@openmesh.com
Subject: Re: [PATCH] wireless-regdb: Update regulatory rules for Singapore
 (SG)
Message-ID: <20170824161744.fl5fikxgqwxjfm6t@ubuntu-xps13> (sfid-20170824_181753_498353_25392884)
References: <20170807081950.13327-1-sven.eckelmann@openmesh.com>
 <20170823205240.ycyrszsvjugtosdi@ubuntu-xps13>
 <1684208.h1AJVyQWH7@bentobox>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1684208.h1AJVyQWH7@bentobox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 24, 2017 at 09:13:42AM +0200, Sven Eckelmann wrote:
> On Mittwoch, 23. August 2017 15:52:40 CEST Seth Forshee wrote:
> [...]
> > > +# Source
> > > +# https://www.imda.gov.sg/~/media/imda/files/regulation%20licensing%20and%20consultations/ict%20standards/telecommunication%20standards/radio-comms/imdatssrd.pdf?la=en
> > > +# page 12-14
> > > +# The EIRP for 5250 – 5350 can be increased by 3dB if TPC is implemented.
> [...]
> > > +	# 5470 - 5725 is only allowed when TPC is implemented
> > > +	# (5470 - 5725 @ 160), (30), DFS
> > 
> > I'm not sure that the lack of a specific provision for operating without
> > TPC in this range means that it cannot be used. As I understand it, TPC
> > would only result in a reduction in EIRP of 3 dB, so as long as we use
> > a power limit of half of the maximum allowed we will be safe.
> > 
> > If this is incorrect I'd appreciate it if someone more knowledgable on
> > the topic could chime in.
> 
> I would also be happy about feedback regarding this part. But my current 
> settings are based on the document [1] mentioned in this change.
> 
> Let us look at the range 5250 – 5350 on page 13. There are two entries for the 
> same frequency range.
> 
>  * 28:
>    - up to 200 mW
>    - requires TPC for 5250 – 5350 Mhz
>  * 29:
>    - up to 100 mW
>    - requires *no* TPC for 5250 – 5350 Mhz
> 
> This is exactly the 3(.01029995...) dB difference which you've talked about. 
> Now to the frequency range 5470 - 5725 MHz on page 14. 
> 
>  * 30:
>    - up to 1000 mW
>    - requires TPC for 5470 - 5725 MHz
> 
> There is no extra exception rule for non-TPC mode.
> 
> Now let us check what IEEE 802.11h-2003 [2] says about TPC.

<snip detailed analysis>

> My current change now assumes following strict interpretation:
> 
>  * Singapore provides a mitigation factor of 3 dB for 5250 – 5350 Mhz (see 
>    table entry 28 + 29)
>  * Singapore provides now mitigation factor for 5470 - 5725 MHz and requires 
>    TPC
> 
> I am currently unsure whether it is now valid to say that the default 
> mitigation factor would be 3 dB and thus there is an implicit table entry (let 
> us call it 30b) which would be:
> 
>  * 30b:
>    - up to 500 mW
>    - requires *no* TPC for 5470 - 5725 MHz
> 
> Countries like AU or regions like ETSI (ETSI EN 301 893) seem to have this 
> mitigation factor always specified in their rules. But Singapore is missing it 
> for this specific frequency range.

So on the one hand I'm in agreement, it would be good to know where the
3 dB attenuation comes from and whether it's really universal. So far
it's been something I've taken on faith from folks a lot more familiar
with the subject than me.

However, it seems the same lack of information would also anyone who
does want to support TPC. The information about how much to attenuate
must either be provided on a per-regulatory-domain basis or else it must
be standardized somehow. If it's the former then it seems odd that
Singapore does not include this information.

Hopefully someone more knowledgable will chime in to help us understand
better.

Thanks,
Seth
