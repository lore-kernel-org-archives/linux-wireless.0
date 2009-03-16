Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:58070 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbZCPPd0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 11:33:26 -0400
Received: by fxm24 with SMTP id 24so3535753fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 16 Mar 2009 08:33:23 -0700 (PDT)
Subject: Re: [PATCH 1/2] ath5k: support LEDs on Acer Aspire One netbook
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Bob Copeland <me@bobcopeland.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <20090316134156.GB8437@rhlx01.hs-esslingen.de>
References: <1230840105-30960-1-git-send-email-me@bobcopeland.com>
	 <20090111131015.GA31037@rhlx01.hs-esslingen.de>
	 <20090111144227.GB13109@hash.localnet>
	 <20090316100447.GA13819@rhlx01.hs-esslingen.de>
	 <1237198577.27769.9.camel@johannes.local>
	 <20090316104433.GA24968@rhlx01.hs-esslingen.de>
	 <1237206117.15040.7.camel@localhost>
	 <20090316134156.GB8437@rhlx01.hs-esslingen.de>
Content-Type: text/plain
Date: Mon, 16 Mar 2009 17:33:19 +0200
Message-Id: <1237217599.2572.16.camel@maxim-laptop> (sfid-20090316_163329_524569_BC6F689E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-03-16 at 14:41 +0100, Andreas Mohr wrote:
> Hi,
> 
> On Mon, Mar 16, 2009 at 02:21:57PM +0200, Maxim Levitsky wrote:
> > On the other hand think about my main notebook, acer 5720.
> > There suspend to ram doesn't work, and no this isn't due to GFX driver,
> > or anything like that. It just that BIOS doesn't pass control to linux
> > on resume. It doesn't like something in hardware....
> > This would I call a NOTHING...
> 
> Hmm. So the resume vector itself doesn't even get invoked?
Exactly.


> AFAIR there's some debugging options at the asm entry point,
> but I'm sure you (and several other people) have already looked at this...
I did my own.. I put there code to write to RTC alarm, and when it hangs
alarm doesn't update.

RTC alarm registers are usually preserved during boots and even during
full power cycle.
This is the case here.



> Plus booting into a minimal setup (init=/bin/sh) with almost no drivers
> loaded at all (thus no fumbled hardware) didn't manage to make resume
> work either I guess?
Exactly, I tried this and very many other debug approaches, but none
help.

Despite the fact that my system has nvidia which I blamed for this bug,
it appears that I am not alone and many acer systems around 5720 are
affected, and don't have an nvidia device.


> 
> > I recommend to to install (if you didn't do that yet) the
> > compat-wireless package, or even better compile wireless-testing.
> 
> Thanks, forgot to install this for the newly installed Jaunty's 2.6.28.

> 
> > You could also patch in latest patches that fix TX power for ath5k, or
> > wait few days till they are in wireless-testings (maybe they are there
> > already...)
> 
> I'll wait until I know how well ath5k works on -rc8.
Here wireless-testing + Nick's pathches work great.


The reason internal microphone doesn't work is that many programs
attempt to record mono from it, but alsa-lib has some bug that make this
work as was described before (works only when there is large difference
between left and right channel)


When I have time I'll fix that, it shouldn't be hard with help of source
and debugger.


(But internal mic is such low quality device, that it hardly worth all
the trouble  - it has same quality in windows, and only way to hear
anything is to yell at it, or bear that horrible noise that appears once
you increase gain level all the way up)


Speaking of the led, I don't understand why you want that patch to be
applied at all. yes it makes the led work, but did you notice how well
it works? It blinks very fast, it often inverts the blinking, so it
constantly on and goes  of when there is activety, or stops blinking at
all. I was told that this is due to low quality code in mac80222 that
controls the leds. Other drivers work around that by using this code
only as a suggestion, and implementing their own ad-hoc timers and
statistics to power the led. Again I will see what I can do there to
improve it. 

Currently I disable the led all together because of that.


Best regards,
	Maxim Levitsky


> 
> Thanks,
> 
> Andreas Mohr

