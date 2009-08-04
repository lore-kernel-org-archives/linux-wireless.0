Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:40613 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbZHDW1b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 18:27:31 -0400
From: Michael Buesch <mb@bu3sch.de>
To: gregor kowski <gregor.kowski@gmail.com>
Subject: Re: [RESEND] [PATCHv2] b43 add harware tkip
Date: Wed, 5 Aug 2009 00:27:29 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <83a869cd0907271349h248204at74cc1603419fc83b@mail.gmail.com> <200908050006.02754.mb@bu3sch.de> <83a869cd0908041523m7b2be0c9t4ae21dc2e22c537@mail.gmail.com>
In-Reply-To: <83a869cd0908041523m7b2be0c9t4ae21dc2e22c537@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908050027.29829.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 05 August 2009 00:23:23 gregor kowski wrote:
> On 8/5/09, Michael Buesch <mb@bu3sch.de> wrote:
> > On Wednesday 05 August 2009 00:03:11 gregor kowski wrote:
> >> On 8/4/09, Michael Buesch <mb@bu3sch.de> wrote:
> >> > On Tuesday 04 August 2009 23:54:42 gregor kowski wrote:
> >> >
> >> > You always talk about "bugs". What are these "bugs"? Is it just the
> >> > wrong
> >> > max_nr_keys assignment? That's trivial to fix.
> >> >
> >> So [1] is ok ?
> >
> > Could you answer my question?
> That's [1]. But may be my description wasn't good.
> I will try a new one.
> we can have up to 50 pairwise keys (due to RCMTA and tkip stuff).
> 
> In the case of new API :
> - max_nr_keys is set to 58
> - in b43_key_clear we call do_key_write for index in [0 ... 58]
> - in do_key_write we call keymac_write for index in [4 ... 58]
> - in keymac_write write to RCMTA index [0 ... 54]
> We write too much pairwise keys.
> 
> - max_nr_keys is set to 58
> - b43_key_write generate pairwise keys in [sta_keys_start ...
> max_nr_keys] = [0 ... 58] and call do_key_write
> - in do_key_write we call keymac_write for index in [4 ... 58]
> - in keymac_write write to RCMTA index [0 ... 54]
> We write too much pairwise keys.

Yeah, I do understand this bug. My question was if that is the only bug.

> So max_nr_keys seems wrong in case of new API.

It's not that simple, actually.
The max_nr_keys thing was never meant to specify which API we're on.
It was invented to do the RCMTA vs *oldcrappymechanismiforgotthenameof*.
max_nr_keys essentially became obsolete and dead code when b43 did not
support <rev5 anymore. I will submit a patch which removes it and cleans up
the code alltogether.

-- 
Greetings, Michael.
