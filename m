Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55259 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbXGKE7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2007 00:59:37 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 1/1] mac80211: Replace overly "sticky" averaging filters for rssi, signal, noise.
Date: Tue, 10 Jul 2007 21:59:13 -0700
Message-ID: <4220499A1B034C4FA93B547BA01E1FF07FC284@orsmsx413.amr.corp.intel.com>
In-Reply-To: <20070711022508.36db6129@logostar.upir.cz>
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: "Jiri Benc" <jbenc@suse.cz>, <benmcahill@gmail.com>
Cc: <flamingice@sourmilk.net>, <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 

> -----Original Message-----
> From: Jiri Benc [mailto:jbenc@suse.cz] 
> Sent: Tuesday, July 10, 2007 8:25 PM
> To: benmcahill@gmail.com
> Cc: flamingice@sourmilk.net; linux-wireless@vger.kernel.org; 
> Cahill, Ben M
> Subject: Re: [PATCH 1/1] mac80211: Replace overly "sticky" 
> averaging filters for rssi, signal, noise.
> 
> On Tue, 10 Jul 2007 19:05:05 -0400, benmcahill@gmail.com wrote:
> > From: Ben Cahill <ben.m.cahill@intel.com>
> > 
> > Replace overly "sticky" averaging filters for rssi, signal, 
> noise ...
> > 
> > In old filter, once initial values were set, it took a 
> large deviation 
> > (16) in new input values in order to nudge the filter output.  This 
> > made signal quality displays appear frozen, with (probably) 
> inaccurate data.
> > 
> > The new filter keeps high-precision (16x) running averages, then 
> > quantizes them to create the output value.  Each new input value 
> > nudges the running average a bit, and displays appear 
> reassuringly alive, with accurate data.
> > 
> > Update comments.
> > 
> > Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
> > ---
> >  net/mac80211/ieee80211.c     |   20 ++++++++++++++------
> >  net/mac80211/ieee80211_sta.c |    7 +++++++
> >  net/mac80211/sta_info.h      |    9 ++++++---
> >  3 files changed, 27 insertions(+), 9 deletions(-)
> > 
> > diff --git a/net/mac80211/ieee80211.c 
> b/net/mac80211/ieee80211.c index 
> > 873ccb0..b838d9c 100644
> > --- a/net/mac80211/ieee80211.c
> > +++ b/net/mac80211/ieee80211.c
> > @@ -3603,12 +3603,20 @@ ieee80211_rx_h_sta_process(struct 
> > ieee80211_txrx_data *rx)
> >  
> >  	sta->rx_fragments++;
> >  	sta->rx_bytes += rx->skb->len;
> > -	sta->last_rssi = (sta->last_rssi * 15 +
> > -			  rx->u.rx.status->ssi) / 16;
> > -	sta->last_signal = (sta->last_signal * 15 +
> > -			    rx->u.rx.status->signal) / 16;
> > -	sta->last_noise = (sta->last_noise * 15 +
> > -			   rx->u.rx.status->noise) / 16;
> > +
> > +	/* Low pass filter:  15/16 current avg + new.
> > +	 * Accumulated values here are 16x values sent from driver. */
> > +	sta->accum_rssi = sta->accum_rssi - (sta->accum_rssi >> 4) +
> > +			  rx->u.rx.status->ssi;
> > +	sta->accum_signal = sta->accum_signal - 
> (sta->accum_signal >> 4) +
> > +			  rx->u.rx.status->signal;
> > +	sta->accum_noise = sta->accum_noise - (sta->accum_noise >> 4) +
> > +			  rx->u.rx.status->noise;
> > +
> > +	/* Quantize the averages (divide by 16) */
> > +	sta->last_rssi = sta->accum_rssi >> 4;
> > +	sta->last_signal = sta->accum_signal >> 4;
> > +	sta->last_noise = sta->accum_noise >> 4;
> 
> First, do not obfuscate the code, please. If you want to 
> divide by 16, divide by 16. The compiler is perfectly capable 
> of optimizing it.

Cool.  I'm showing some of my old-school habits, I guess.

> 
> Second, do not obfuscate the algorithm, please. All this does 
> is postponing the division by 16 in last_rssi = (last_rssi * 
> 15 + status_rssi) / 16 to a time when last_rssi is actually used.

This is the old (current) algorithm.  With this, the difference between
last_rssi and status_rssi must be at least 16 in order to survive the
division and nudge the new last_rssi value by 1 ...

For example, if last_rssi = -50, and status_rssi is -51, the new
last_rssi will be:

(((-50 * 15) - 51) / 16) = ((-750 - 51) / 16) = (-801 / 16) = -50 

You could have an infinite number of -51s come in, or -65 for that
matter, and this algo will stick at 50.  There is no memory for new
status_rssi samples within 15 dB of last_rssi. 

> 
> Please keep all the buzzwords like "high-precision" for 
> yourself and explain how postponing a division by 16 helps.

Postponing the division keeps the running average using more significant
bits, so each new sample has a meaningful, surviving impact to the
running average.  Sorry, "high-precision" is the best term that I can
think of to describe more bits being used in the running average.  The
"binary point" is between bits 3 and 4; think of bits 3:0 as
"remainder". 

For example, if last_rssi = -50 (represented in new code by -50 * 16 =
-800), and status_rssi is -51 (represented by -51), the new last_rssi
(high precision) = 

((-800 - (-800/16) - 51) = -801   ... see below for explanation of "-
(-800/16)"

With this, there *is* memory for the (just 1 away) new sample.  And 15
more -51s would nudge last_rssi to be -816 (= -51 after a divide by 16).
No stickiness.

There is a subtle difference between:

1)  last_rssi * 15 / 16

2)  last_rssi - (last_rssi / 16)

The first one would get stuck at -801 if there were a series of -51s
coming in.
-801 * 15 / 16 would get quantized to -750 each time, so the output
would be stuck at -801 (-50 dBm).

The second one favors the high precision memory, and would progress from
-801 to -802, etc., as a series of -51s came in:
-801 - (-801/16) = -751

> 
> 
> (To make my point more clear, the code above could be rewritten as
> follows(*):
> 
> sta->last_rssi = sta->last_rssi * 15 / 16 +
> 		 rx->u.rx.status->ssi;
> sta->last_signal = sta->last_signal * 15 / 16 +
> 		   rx->u.rx.status->signal;
> sta->last_noise = sta->last_noise * 15 / 16 +
> 		  rx->u.rx.status->noise;

Very good, although for best memory/precision (see above), these should
be, e.g.:

sta->last_rssi = sta->last_rssi - (sta->last_rssi / 16) +
 		 rx->u.rx.status->ssi;

> 
> while initializing sta->last_rssi to (16 * bss->rssi) and 
> doing the division by 16 when passing last_rssi to the user space.)

Yes, we can do the division when passing to user space.  

> 
> Thanks.
> 
>  Jiri
> 
> (*) And without the three additional variables!

I saw 2 instances of sta->last_rssi being used in ieee80211_ioctl.c, and
STA_FILE(last_rssi, last_rssi, D) in debugfs_sta.c, which I didn't
understand (still don't) and was afraid to touch, so I thought the
safest thing with least impact would be to add the 3 additional
variables, and do the division in one place for each of the 3
rssi/signal/noise.

If we do the division when passing to user space, how should STA_FILE be
handled, if necessary?

Thanks for your comments.  I'll wait for your answer, and try again.

-- Ben --

> -- 
> Jiri Benc
> SUSE Labs
> 
