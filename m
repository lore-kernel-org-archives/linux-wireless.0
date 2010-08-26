Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51907 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab0HZMVr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Aug 2010 08:21:47 -0400
Subject: Re: [RFC] iwlwifi: rewrite iwl-scan.c to avoid race conditions
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100826120359.GA21646@redhat.com>
References: <20100820133226.GB4725@redhat.com>
	 <1282820764.3812.22.camel@jlt3.sipsolutions.net>
	 <20100826120359.GA21646@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Aug 2010 14:21:36 +0200
Message-ID: <1282825296.3812.25.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-08-26 at 14:03 +0200, Stanislaw Gruszka wrote:

> > Since we've had locking problems in such situations a lot, I'm just
> > going to allow mac80211 to call scan_completed() from any context.
> > That'll get rid of all the problems with the mutx here, so that you can
> > move this code into a helper function (based on your description, I
> > suspect I'll see it again in the patch)
> 
> This is mutex recursion problem, scan_completed() call
> ieee80211_hw_config() -> iwl_mac_config() -> mutex_lock(&priv->mutex).
> I should put short comment about that. Even on possibly removal
> of ieee80211_hw_config (for example when aborted==true) we still
> can have possible deadlock, because of mac80211 local->mtx and
> iwlwifi priv->mutex locking ordering.

Yeah, but I see you found my other patch now, which makes
ieee80211_scan_completed() really callable everywhere :)

> > > +				if (priv->is_internal_short_scan &&
> > > +				    priv->scan_request == NULL)
> > > +					ret = 0;
> > 
> > Is that && really correct? It's just an extra check, right? I mean,
> > scan_request is always NULL for internal short scans...
> Nope, your commit f84b29ec0a1ab767679d3f2428877b65f94bc3ff changed
> that :-)

D'oh! You're right.

> > Hmm, an only tangentially related question: do we really need to do all
> > these atomic bit operations? We hold the mutex everywhere anyway, no?
> 
> No. This my way to write things in one line instead of two, but perhaps
> two lines version should be used to not confuse readers.

No, I wasn't thinking of set_bit/clear_bit etc. but rather using bool
values... Don't worry about that though, I'll go through at some point
and check all the status bits.

> > > +	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
> > > +		/* just live w/ bad key and rely briefly on SW decryption */
> > >  		return;
> > >  	}
> > > +	/* XXX: race condition: nothing prevent to start HW scanning now */
> > 
> > TBH, I don't even understand why we need to cancel the scan here. We're
> > just updating a key ... and we don't really do that while scanning
> > anyway since it's triggered only by receiving frames successfully...
> 
> I don't understand this also.

It's probably some hw requirement that failed to make it into a
comment ... Wey-yi?

johannes

