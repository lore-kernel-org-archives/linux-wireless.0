Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33875 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbbGIOFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 10:05:07 -0400
Received: by oiab3 with SMTP id b3so71692901oia.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 07:05:06 -0700 (PDT)
Date: Thu, 9 Jul 2015 09:04:17 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Wei Zhong <wzhong@google.com>, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: wireless-regdb: update CA rules for 5600 - 5650 mHz
Message-ID: <20150709140417.GA142895@ubuntu-hedt> (sfid-20150709_160511_738405_386FDE0E)
References: <CAHr=Vq=hJr6WUQgFXftMSG2zYgwtCXgoTaXBzRfM8-kQa2-K2w@mail.gmail.com>
 <55966D1B.1040603@neratec.com>
 <CAHr=VqnpJ_+ovmB3gqm+X9WX98ZeVuO8VZ2cq6OFPcdjy8Rkgg@mail.gmail.com>
 <5596A3C0.6020303@neratec.com>
 <20150706132707.GA22962@ubuntu-hedt>
 <559A9378.7000006@neratec.com>
 <20150707201126.GB369@ubuntu-xps13>
 <559CF926.8000508@neratec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <559CF926.8000508@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 08, 2015 at 12:19:18PM +0200, Zefir Kurtisi wrote:
> My claim is that in its current state the regdb does not exactly formalize the
> limitations given by regulatory for a simple reason: it uses channel semantics
> where it should only handle frequency ranges. Take the discussed rules for CA at
> hand: while the linked document considers frequencies from 5150 to 5350, the
> according rule for CA is defined as (5170 - 5250 @ 80). Why 5170 instead of 5150?
> Because we know there is no channel defined below 5170 - but why do we need to
> embed this information as a rule when it is already handled by SW?
> 
> In the current regdb, both semantics are used, e.g. UA (5150-5350) vs. CA
> (5170-5250) or ES (5470-5725) vs. FI (5490-5710)).

I'm not surprised. I don't know that anyone has given it that much
thought before.

> This might sound like an irrelevant difference, but here is why it matters: the
> above mentioned rules for ES and FI would give the same channel lists - as long as
> we think in HT20 and HT40. But only ES gives access to 10 and 5MHz operation on
> channel 144.

Good example.

> My bottom line is: regulatory rules must not contain channel semantics - this is
> done by the SW. Rules must be a literal formalization of the country's regulatory,
> which always uses frequency ranges within defined band edges.

I'm generally in agreement. I'll try to pay closer attention to this in
the future.

> Sorry for this going off-topic. It has nothing to do with the changes proposed by
> Wei, but is more about something to keep in mind when considering upcoming support
> for narrow band channels at band edges.

Except that it seems to have inspired Wei to change the patch to do
exactly what you're arguing against ;-)

Seth
