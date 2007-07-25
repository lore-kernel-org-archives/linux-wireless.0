Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41292 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759304AbXGYSww convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 14:52:52 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 1/1] mac80211: Replace overly "sticky" averagingfilters for rssi, signal, noise.
Date: Wed, 25 Jul 2007 11:50:29 -0700
Message-ID: <4220499A1B034C4FA93B547BA01E1FF00174623A@orsmsx413.amr.corp.intel.com>
In-Reply-To: <1184274936.6669.72.camel@johannes.berg>
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Jiri Benc" <jbenc@suse.cz>
Cc: <benmcahill@gmail.com>, <flamingice@sourmilk.net>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, had to put this aside for awhile ... Actually, I like the way
things behave without a filter at all (see other mail), but I just
wanted to follow up ... and thank Johannes for his thoughtful comments.

-- Ben --

> -----Original Message-----
> From: Johannes Berg [mailto:johannes@sipsolutions.net] 
> Sent: Thursday, July 12, 2007 5:16 PM
> To: Jiri Benc
> Cc: benmcahill@gmail.com; flamingice@sourmilk.net; 
> linux-wireless@vger.kernel.org; Cahill, Ben M
> Subject: Re: [PATCH 1/1] mac80211: Replace overly "sticky" 
> averagingfilters for rssi, signal, noise.
> 
> On Wed, 2007-07-11 at 02:25 +0200, Jiri Benc wrote:
> 
> > > +	/* Quantize the averages (divide by 16) */
> > > +	sta->last_rssi = sta->accum_rssi >> 4;
> > > +	sta->last_signal = sta->accum_signal >> 4;
> > > +	sta->last_noise = sta->accum_noise >> 4;
> > 
> > First, do not obfuscate the code, please. If you want to 
> divide by 16, 
> > divide by 16. The compiler is perfectly capable of optimizing it.
> 
> No, you're wrong, the compiler can only optimise that if it 
> knows for sure that the values can't ever be negative. And 
> quoting the patch further below:
> 
> > +	int accum_rssi; /* hi-precision running average (rssi * 16) */
> > +	int accum_signal; /* hi-precision average 
> (signal-quality * 16) */
> > +	int accum_noise; /* hi-precision running average (noise * 16) */
> 
> The compiler does some tricks to avoid the integer division 
> IIRC but it can't do a simple shift. But in principle you're 
> right, the code should say "/ 16" because either the 
> variables need to be made unsigned (only positive values are 
> put into them) or using a shift is wrong (if negative values 
> can happpen)

Actually, "arithmetic" right shift works for either signed or unsigned.
Arithmetic shift looks at the most-significant bit, and shifts more of
that in from the left, preserving the sign.  Our rssi and noise values
are negative (dBm) values, and this integer shift formula worked fine.
It's important that the variable is "int", rather than "unsigned", or
else the compiler would use a "logical" right shift, which simply shifts
in 0s from the left.

> 
> With the algorithm as I see it, each update is done by
> update(new_value):
>   avg = 15/16*avg + new_value
> 
> which means that all old samples are still influencing the 
> current output.

Exactly ... this is the characteristic of an "infinite impulse response"
(IIR) filter.  The output is fed back into the input.  If we had
infinite bits of precision in the output filter variable, the influence
of a single input would constantly decay at the 15/16 rate, but would
last forever.  Since we don't have infinite precision, the effect of a
single sample is limited.

Usually, for a given desired behavior, it's easier to build an IIR
filter than an FIR (finite impulse response) filter ... the FIR filter
does *not* use any feedback from the output ... any history must be in
the form of stored input values, which you suggest below.

> 
> Doing two updates (update(a), update(b)) yields:
> avg = 15/16 * (15/16*orig + a) + b = 225/256 * orig + 15/16 * a + b
> 
> And after 16 updates the original values still has an 
> influence of about 3.5% on the output value:
> update(a_0),...,update(a_15):
> avg = (15/16)^16*orig + \sum_{i=0}^{15} (15/16)^i * a_i
>     = 0.3560*orig + 0.3798*a_0 + ... (sum of coefficients is ~10.30)
> 
> Is this really what we want? Wouldn't it be better to have a 
> ringbuffer of the last 16 values and really do an average 
> over those? [which is what I understand as "moving average"]

This is an FIR approach, which would work just fine, and would give
results based on exactly 16 samples of history, distributed equally
(rather than weighted towards more recent samples, which actually might
be desirable), but would be more complicated to build and would use more
storage.

You might be exactly right about the definition of a "moving average".
I might have mis-used the term.

-- Ben --

> 
> johannes
> 
