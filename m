Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37380 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab1J2Ko7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Oct 2011 06:44:59 -0400
Received: by iaby12 with SMTP id y12so4997131iab.19
        for <linux-wireless@vger.kernel.org>; Sat, 29 Oct 2011 03:44:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111029102502.GA10582@nautica>
References: <1319880615-3000-1-git-send-email-arend@broadcom.com> <20111029102502.GA10582@nautica>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 29 Oct 2011 21:44:38 +1100
Message-ID: <CAGRGNgWfn=Q-=7AbVpQ3wRNtB0-6K750qxmXG+QbQhwxDMWuwg@mail.gmail.com> (sfid-20111029_124502_895635_6354FF30)
Subject: Re: [PATCH] brcm80211: smac: eliminate a null pointer dereference in dma.c
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, Julia Lawall <julia@diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sat, Oct 29, 2011 at 21:25, Dominique Martinet
<asmadeus@codewreck.org> wrote:
> Hi,
>
>
> Arend van Spriel wrote on Sat, Oct 29, 2011:
>> Though it's unlikely, di may be null, so we can't dereference
>> di->dma.dmactrlflags until we've checked it.
>
> I've got no experience whatsoever in kernel coding so feel free to tell
> me that's stupid, but if you say it's unlikely why not use the
> unlikely() macro as well for the check?

I'm not sure the check for whether di is NULL is necessary at all, as
my very quick check of where this function is called from turned up
only one place that it's called from, where di is most definitely not
null.

As for using unlikely() it produces an instruction for the compiler to
mangle the if statement into assembler in a certain way and, as I
understand it, is mostly used where we *know* that:
1. The test is unlikely to be true and
2. Telling the compiler to write the assembly code like this will
produce a performance improvement.

I.e. a good place to stick an unlikely is in a "fast-path", e.g. the
packet receive code - if we don't process packets fast enough, the
hardware will start dropping them, so a performance improvement of a
couple of cycles - which is what unlikely() will give us - may visibly
improve performance.

That said, there are a couple of reasons why we shouldn't:
- Compilers are getting smarter all the time, and can probably figure
out that we're unlikely to hit the test often
- Premature optimisation is considered harmful.
- If, as I suspect, this function is only used in one location, the
compiler will probably inline the function, then optimise it from
there - the only caller I could find calls the function with a proper
value for di, so the compiler will probably drop the entire if
statement.

I'm sure that there are many other things that could be worked on in
this driver before we start worrying about whether we should stick
unlikely()s in the code.

> (also, that's not the point of this patch, but can't hurt to point that
> out)

This is what I spend my life doing - this patch was just another
instance of this =)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
