Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:45175 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751126AbXLIX2Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 18:28:24 -0500
Date: Mon, 10 Dec 2007 00:21:58 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/T][PATCH 1/3] rc80211-pid: introduce rate behaviour
 learning algorithm
Message-ID: <20071210002158.654ed960@morte> (sfid-20071209_232831_024055_0E75AD5C)
In-Reply-To: <1197239150.7543.13.camel@localhost>
References: <20071209211547.2d7fca32@morte>
	<20071209211931.26ff42fa@morte>
	<1197239150.7543.13.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 09 Dec 2007 23:25:50 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> > +static int rate_control_pid_shift_adjust(struct rc_pid_rateinfo *r,
> > +					 int adj, int cur, int l)
> > +{
> > +	int i, j, k, tmp;
> > +
> > +	if (cur + adj < 0)
> > +		return 0;
> > +	if (cur + adj >= l)
> > +		return l - 1;
> > +
> > +	for (i = 0; i < l; i++)
> > +		if (r[i].index == cur + adj)
> > +			break;
> > +	if (unlikely(!r[i].valid))
> > +		return cur + adj;
> > +	for (j = 0; j < l; j++)
> > +		if (r[j].index == cur)
> > +			break;
> > +
> > +	if (adj < 0) {
> > +		if (r[i].diff > r[j].diff)
> > +			return cur;
> 
> This prevents switching down if the rate we're switching to is worse
> than the current. But if |adj| > 1, we could still find an acceptable
> rate in between i and j, couldn't we?

Right. I even thought about this, but then forgot to implement it. I'll fix
it.
 
> > +	} else {
> > +		tmp = r[i].diff;
> > +		for (k = i + 1; k + cur < l; k++)
> > +			if (r[k].valid && r[k].diff <= tmp) {
> > +				tmp = r[k].diff;
> > +				adj = k;
> > +			}
> 
> This increases the rate even more if following rates are better than the
> one actually selected by the PID controller.

This is intentional (see fast_start, e.g.).

> I'm not too happy with
> this, because it defeats the idea that the PID controller can decide how
> far it wants to switch by the absolute value of adj.

Please remember that normalization is periodically performed. So, this will
happen only if we noticed that in very recent events that it doesn't make
sense not to switch to an higher rate. We can tune this behaviour with the
norm_factor parameter. I tested this briefly and turned out to yield some
performance advantage in most cases (norm_factor set to 3 seems to be
optimal).

> > +/* Normalize the failed frames per-rate differences. */
> > +static void rate_control_pid_normalize(struct rc_pid_rateinfo *r, int l)
> > +{
> > +	int i;
> > +
> > +	if (r[0].diff > RC_PID_NORM_FACTOR)
> > +		r[0].diff -= RC_PID_NORM_FACTOR;
> > +	else if (r[0].diff < -RC_PID_NORM_FACTOR)
> > +		r[0].diff += RC_PID_NORM_FACTOR;
> > +	for (i = 0; i < l - 1; i++)
> > +		if (likely(r[i + 1].valid)) {
> > +			if (r[i + 1].diff > r[i].diff + RC_PID_NORM_FACTOR)
> > +				r[i + 1].diff -= RC_PID_NORM_FACTOR;
> > +			else if (r[i + 1].diff <= r[i].diff)
> > +				r[i + 1].diff += RC_PID_NORM_FACTOR;
> > +		}
> 
> If I understand correctly, you apply an offset to all valid entries. So
> I'd rather call it RC_PID_NORM_OFFSET.

Well, I don't care that much. I was referring to this definition of factor:

n., 1. One that actively contributes to an accomplishment, result, or process

Anyway "offset" may be more clear. Will fix it.

> Furthermore, what if the diff
> values are larger than k * RC_PID_NORM_OFFSET (with k an integer)? If
> you first compute the offset, you can just loop over the array and apply
> the offset without checking for the condition.

I frankly don't get your point here. No offsets are computed...

> > +}
> > +
> >  static void rate_control_pid_sample(struct rc_pid_info *pinfo,
> >  				    struct ieee80211_local *local,
> >  				    struct sta_info *sta)
> >  {
> >  	struct rc_pid_sta_info *spinfo = sta->rate_ctrl_priv;
> > +	struct rc_pid_rateinfo *rinfo = pinfo->rinfo;
> > +	struct ieee80211_hw_mode *mode;
> >  	u32 pf;
> >  	s32 err_avg;
> >  	s32 err_prop;
> >  	s32 err_int;
> >  	s32 err_der;
> > -	int adj;
> > +	int adj, i, j, tmp;
> >  
> > +	mode = local->oper_hw_mode;
> >  	spinfo = sta->rate_ctrl_priv;
> >  	spinfo->last_sample = jiffies;
> >  
> > @@ -194,6 +282,31 @@ static void rate_control_pid_sample(stru
> >  		spinfo->tx_num_failed = 0;
> >  	}
> >  
> > +	/* If we just switched rate, update the rate behaviour info. */
> > +	if (pinfo->oldrate != sta->txrate) {
> > +		for (i = 0; i < mode->num_rates; i++)
> > +			if (rinfo[i].index == pinfo->oldrate)
> > +				break;
> > +		for (j = 0; j < mode->num_rates; j++)
> > +			if (rinfo[j].index == sta->txrate) {
> > +				rinfo[j].valid = 1;
> > +				break;
> > +			}
> 
> This is no 3 and 4 of the call sites to the to be written
> find_index_for_rate() function ;-)
>
> Or what about this idea: Store direct indices into the rinfo table, so
> you needn't convert them back from the mode->rates indexing everywhere.

This makes sense. Unless you are working to the find_index_for_rate()
function, which would make more sense.

> > -	/* We need to do an arithmetic right shift. ISO C says this is
> > -	 * implementation defined for negative left operands. Hence, be
> > -	 * careful to get it right, also for negative values. */
> > +	/* Arithmetic right shift, see above. */
> >  	adj = (adj < 0) ? -((-adj) >> (2 * RC_PID_ARITH_SHIFT)) :
> >  			  adj >> (2 * RC_PID_ARITH_SHIFT);
> 
> If we use it twice, IMHO it's worth factoring it into a macro.

Will do.

> >  static void *rate_control_pid_alloc(struct ieee80211_local *local)
> >  {
> >  	struct rc_pid_info *pinfo;
> > +	struct rc_pid_rateinfo *rinfo;
> > +	struct ieee80211_hw_mode *mode;
> > +	int i, j, tmp;
> > +	bool s;
> >  
> >  	pinfo = kmalloc(sizeof(*pinfo), GFP_ATOMIC);
> > +	if (!pinfo)
> > +		return NULL;
> > +
> > +	mode = local->oper_hw_mode;
> > +	rinfo = kmalloc(sizeof(*rinfo) * mode->num_rates, GFP_ATOMIC);
> > +	if (!rinfo) {
> > +		kfree(pinfo);
> > +		return NULL;
> > +	}
> 
> What if the mode is changed? Have you checked the rate control algorithm
> gets reinitialized? If not, we're scheduling a crash here, when
> mode->num_rates changes.

No, I didn't because I thought that was obvious. But no, it seems that it
doesn't get reinitialized. This has to be addressed, IMHO.

> > +
> > +	/* Sort the rates. This is optimized for the most common case (i.e.
> > +	 * almost-sorted CCK+OFDM rates). */
> > +	for (i = 0; i < mode->num_rates; i++) {
> > +		rinfo[i].index = i;
> > +		if (RC_PID_FAST_START) {
> > +			rinfo[i].valid = 1;
> > +			rinfo[i].diff = 0;
> > +		} else
> > +			rinfo[i].valid = 0;
> 
> Maybe use an #ifdef RC_PID_FAST_START_HERE?

So that it can't be turned into a parameter? Nah.

> > +	}
> > +	for (i = 1; i < mode->num_rates; i++) {
> > +		s = 0;
> > +		for (j = 0; j < mode->num_rates - i; j++)
> > +			if (unlikely(mode->rates[rinfo[j].index].rate >
> > +				     mode->rates[rinfo[j + 1].index].rate)) {
> > +				tmp = rinfo[j].index;
> > +				rinfo[j].index = rinfo[j + 1].index;
> > +				rinfo[j + 1].index = tmp;
> > +				s = 1;
> > +			}
> > +		if (!s)
> > +			break;
> > +	}
> 
> There is include/linux/sort.h. I guess using this would make the code
> clearer. It took me a moment to recognize the code as bubble sort.

Heapsort (please see lib/sort.c) is suboptimal here. I think that
bubblesort is the right compromise between insertion sort (performance) and
readability here.

> What just came to my mind: Maybe it's not a good idea to actually break
> up the 80211.b then 80211.g sorting of the rates: If you have an AP,
> it'll compute separate tx rates for all stations it knows. But there
> might also be 80211.b only stations. If we have 6Mbit/s and 9Mbit/s OFDM
> rates before the 11Mbit/s OFDM rate, will we ever be able to switch to
> 11Mbit/s?

(11Mbit/s is a CCK rate)

We should be able to switch to 11Mbit/s:
[in rate_control_pid_adjust_rate()]:

        while (newidx != sta->txrate) {
                if (rate_supported(sta, mode, newidx) &&
                    (maxrate < 0 || newidx <= maxrate)) {
                        sta->txrate = newidx;
                        break;
                }

                newidx += back;
        }

> Overall, I'm still not too convinced whether this learning approach is
> worth the effort, but this is something to be figured out by testing.

Well, I didn't test this extensively. But at least I got rid of the
11-6-9-11M loop and this yields best performance (~1.5mbit/s more with
iperf) for scenarios with good signal and varying noise (tested with b43).
I have to fix a bug in b43 before further testing, though.


--
Ciao
Stefano
