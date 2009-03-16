Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:40732 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbZCPQAr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 12:00:47 -0400
Date: Mon, 16 Mar 2009 17:00:44 +0100
From: Andreas Mohr <andi@lisas.de>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Bob Copeland <me@bobcopeland.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 1/2] ath5k: support LEDs on Acer Aspire One netbook
Message-ID: <20090316160044.GA4458@rhlx01.hs-esslingen.de> (sfid-20090316_170052_062360_47355B48)
References: <1230840105-30960-1-git-send-email-me@bobcopeland.com> <20090111131015.GA31037@rhlx01.hs-esslingen.de> <20090111144227.GB13109@hash.localnet> <20090316100447.GA13819@rhlx01.hs-esslingen.de> <1237198577.27769.9.camel@johannes.local> <20090316104433.GA24968@rhlx01.hs-esslingen.de> <1237206117.15040.7.camel@localhost> <20090316134156.GB8437@rhlx01.hs-esslingen.de> <1237217599.2572.16.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1237217599.2572.16.camel@maxim-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Mar 16, 2009 at 05:33:19PM +0200, Maxim Levitsky wrote:
> On Mon, 2009-03-16 at 14:41 +0100, Andreas Mohr wrote:
> > Hmm. So the resume vector itself doesn't even get invoked?
> Exactly.
> 
> 
> > AFAIR there's some debugging options at the asm entry point,
> > but I'm sure you (and several other people) have already looked at this...
> I did my own.. I put there code to write to RTC alarm, and when it hangs
> alarm doesn't update.
> 
> RTC alarm registers are usually preserved during boots and even during
> full power cycle.
> This is the case here.

Perhaps this is because the suspend command/process itself is (slightly?)
wrong (at least "wrong" in the mental universe of this BIOS ;)
and the machine sort-of suspends but due to this doesn't really resume...

> it appears that I am not alone and many acer systems around 5720 are
> affected, and don't have an nvidia device.

So 5520 (I've seen this one already, didn't try resuming) as well perhaps.

> Speaking of the led, I don't understand why you want that patch to be
> applied at all. yes it makes the led work, but did you notice how well
> it works? It blinks very fast, it often inverts the blinking, so it
> constantly on and goes  of when there is activety, or stops blinking at
> all. I was told that this is due to low quality code in mac80222 that
> controls the leds. Other drivers work around that by using this code
> only as a suggestion, and implementing their own ad-hoc timers and
> statistics to power the led. Again I will see what I can do there to
> improve it. 
> 
> Currently I disable the led all together because of that.

Yeah, of course, but the first step would be to activate it, then the
second step should be done (and more LED users would be annoyed about LED
behaviour, thus it would hopefully be fixed soon ;)).

Plus, and that's the more important part, there's certainly not only
one trigger type available but several (some of which without frantic
blinking). Without LED support you'd simply lose all trigger types ;)

Andreas
