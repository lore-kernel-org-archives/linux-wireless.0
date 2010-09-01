Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab0IAOUY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 10:20:24 -0400
Date: Wed, 1 Sep 2010 16:16:59 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH w-t] iwlwifi: rewrite iwl-scan.c to avoid race conditions
Message-ID: <20100901141658.GA20421@redhat.com>
References: <20100831150021.GA10963@redhat.com>
 <1283345553.4124.6.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1283345553.4124.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 01, 2010 at 02:52:33PM +0200, Johannes Berg wrote:
> >  static int iwl_send_scan_abort(struct iwl_priv *priv)
> >  {
> > -	int ret = 0;
> > +	int ret;
> >  	struct iwl_rx_packet *pkt;
> >  	struct iwl_host_cmd cmd = {
> >  		.id = REPLY_SCAN_ABORT_CMD,
> >  		.flags = CMD_WANT_SKB,
> >  	};
> 
> Since you're going through, and probably know where what lock is needed,
> could you annotate the places with, e.g.
> 
> 	lockdep_assert_held(&priv->mutex)?

Ok

> These "inline" annotations seem wrong, either the function is used once,
> then gcc will inline it, or it is used multiple times, then we shouldn't
> inline it.

Ok

> > +int iwl_scan_cancel_sleep(struct iwl_priv *priv)
> > +{
> > +	int ret;
> > +	unsigned long timeout = jiffies + IWL_SCAN_ABORT_SLEEP;
> > +
> > +	IWL_DEBUG_SCAN(priv, "Scan cancel wait\n");
> > +
> > +	cancel_delayed_work(&priv->scan_timeout);
> > +	iwl_do_scan_abort(priv);
> > +
> > +	while (time_before_eq(jiffies, timeout)) {
> > +		if (!test_bit(STATUS_SCAN_HW, &priv->status))
> > +			break;
> > +		msleep(20);
> > +	}
> 
> This, and
> 
> > +void iwl_wait_for_scan_end(struct iwl_priv *priv)
> > +{
> > +	unsigned long timeout = jiffies + IWL_SCAN_WAIT_END;
> > +
> > +	while (time_before_eq(jiffies, timeout)) {
> > +		if (!test_bit(STATUS_SCANNING, &priv->status))
> > +			break;
> > +		msleep(20);
> > +	}
> 
> this seems like it could use a completion?

We don't know is scanning is currently performed or not,
so we nobody could ever call complete(). Above code works
fine if no scan is running. 

Stanislaw
