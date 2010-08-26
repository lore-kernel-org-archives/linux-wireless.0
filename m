Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab0HZMGV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Aug 2010 08:06:21 -0400
Date: Thu, 26 Aug 2010 14:03:59 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] iwlwifi: rewrite iwl-scan.c to avoid race conditions
Message-ID: <20100826120359.GA21646@redhat.com>
References: <20100820133226.GB4725@redhat.com>
 <1282820764.3812.22.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1282820764.3812.22.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 26, 2010 at 01:06:04PM +0200, Johannes Berg wrote:
> Hi Stanislaw,
> 
> Sorry for the long delay here.

No problem, thanks for review.

> >  	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->status)) {
> > +		bool scan_pending = false;
> > +
> >  		mutex_lock(&priv->mutex);
> >  		priv->vif = NULL;
> >  		priv->is_open = 0;
> > +		if (test_bit(STATUS_SCANNING, &priv->status) &&
> > +		    !priv->is_internal_short_scan) {
> > +			scan_pending = true;
> > +			clear_bit(STATUS_SCAN_HW, &priv->status);
> > +			clear_bit(STATUS_SCAN_ABORTING, &priv->status);
> > +		}
> >  		mutex_unlock(&priv->mutex);
> > +
> > +		if (scan_pending)
> > +			ieee80211_scan_completed(priv->hw, true);
> 
> Since we've had locking problems in such situations a lot, I'm just
> going to allow mac80211 to call scan_completed() from any context.
> That'll get rid of all the problems with the mutx here, so that you can
> move this code into a helper function (based on your description, I
> suspect I'll see it again in the patch)

This is mutex recursion problem, scan_completed() call
ieee80211_hw_config() -> iwl_mac_config() -> mutex_lock(&priv->mutex).
I should put short comment about that. Even on possibly removal
of ieee80211_hw_config (for example when aborted==true) we still
can have possible deadlock, because of mac80211 local->mtx and
iwlwifi priv->mutex locking ordering.

> > +	if (test_bit(STATUS_SCANNING, &priv->status)) {
> > +		if (test_and_set_bit(STATUS_SCAN_ABORTING, &priv->status))
> > +			IWL_DEBUG_SCAN(priv, "Scan abort in progress.\n");
> > +		else {
> > +			ret = iwl_send_scan_abort(priv);
> > +			if (ret) {
> > +				clear_bit(STATUS_SCANNING, &priv->status);
> > +				clear_bit(STATUS_SCAN_HW, &priv->status);
> > +				clear_bit(STATUS_SCAN_ABORTING, &priv->status);
> > +
> > +				/* If we did internal scan and mac80211 does
> > +				 * not schedule scan by itself we do not
> > +				 * have to complete it */
> > +				if (priv->is_internal_short_scan &&
> > +				    priv->scan_request == NULL)
> > +					ret = 0;
> 
> Is that && really correct? It's just an extra check, right? I mean,
> scan_request is always NULL for internal short scans...
Nope, your commit f84b29ec0a1ab767679d3f2428877b65f94bc3ff changed
that :-)

> Also, if I make the change I just talked about earlier, could this
> function call ieee80211_scan_completed() itself?

Yep, if scan_completed() could be called with priv->mutex that will
be great. I'm not sure if you can do this ...

> > +	unsigned long now = jiffies;
> >  
> > -	/* Make sure there is enough space for the probe request,
> > -	 * two mandatory IEs and the data */
> > -	left -= 24;
> > -	if (left < 0)
> > -		return 0;
> > +	ret = iwl_do_scan_abort(priv);
> > +	mutex_unlock(&priv->mutex);
> 
> I'd prefer if we never dropped the mutex in a function that requires
> being called with it held. That can break locking really badly in the
> caller without anybody noticing.

Yes, this patch have a bug, I'm working on second version to eliminate
it.  

> 
> > +	if (ret) {
> > +		ieee80211_scan_completed(priv->hw, true);
> > +		goto out;
> > +	}
> 
> I guess it's just because of this though, so that should go away.

This is one reason.

>  
> > -	len += 24;
> > +	while (time_before(jiffies, now + msecs_to_jiffies(ms))) {
> > +		if (!test_bit(STATUS_SCANNING, &priv->status))
> > +			break;
> > +		msleep(20);
> > +	}
> 
> Or because of this?

Second reason, we can not have priv->mutex locked, otherwise 
iwl_bg_scan_completed will not be able to start. Maybe is possible
to keep mutex locked here by changing logic - I'm thinking about that.  

>  
> > -	/* ...next IE... */
> > -	pos = &frame->u.probe_req.variable[0];
> > +	/* XXX: race condtion: we can sucessufly cancel scan, but
> > +	 *	a new scan request could arrive, so we can still
> > +	 *	have scanning pending */ 
> 
> Can a new request really arrive? mac80211 needs to be processing the
> completed first? Or is this maybe for internal short scans?

W can scan_completed() from other function and new scan can arrive when we
sleep here. Internal scan is problem here as well. 

> Hmm, an only tangentially related question: do we really need to do all
> these atomic bit operations? We hold the mutex everywhere anyway, no?

No. This my way to write things in one line instead of two, but perhaps
two lines version should be used to not confuse readers.

> > +	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
> > +		/* just live w/ bad key and rely briefly on SW decryption */
> >  		return;
> >  	}
> > +	/* XXX: race condition: nothing prevent to start HW scanning now */
> 
> TBH, I don't even understand why we need to cancel the scan here. We're
> just updating a key ... and we don't really do that while scanning
> anyway since it's triggered only by receiving frames successfully...

I don't understand this also.

Stanislaw
