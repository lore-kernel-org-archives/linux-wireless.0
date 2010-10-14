Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab0JNI3t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 04:29:49 -0400
Date: Thu, 14 Oct 2010 10:32:05 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] iwlwifi: fix set_tx_power vs scan
Message-ID: <20101014083204.GA2286@redhat.com>
References: <1286977193-12144-1-git-send-email-sgruszka@redhat.com>
 <1286983100.10446.1.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1286983100.10446.1.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wey

On Wed, Oct 13, 2010 at 08:18:20AM -0700, Guy, Wey-Yi wrote:
> >  		IWL_WARN(priv,
> >  			 "Requested user TXPOWER %d below lower limit %d.\n",
> > @@ -1226,6 +1228,12 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
> >  		return -EINVAL;
> >  	}
> >  
> > +	if (test_bit(STATUS_SCANNING, &priv->status)) {
> > +		priv->tx_power_next = tx_power;
> > +		IWL_DEBUG_INFO(priv, "Deferring tx power set while scanning\n");
> > +		return 0;
> > +	}
> > +
[snip]
> >  	/* Since setting the TXPOWER may have been deferred while
> >  	 * performing the scan, fire one off */
> > -	iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
> > +	iwl_set_tx_power(priv, priv->tx_power_next, true);

Doh, this patch introduce a bug, when tx_power_next is not set (because
there was no scan during set_tx_power), but then when someone request
a scan and it finish, tx_power_next is written to hardware. I should
read tx_power using device sysfs not iwconfig when testing, will fix
that.

> Looks good, the only thing is if priv->tx_power_user_lmt ==
> priv->tx_power_next, we don't even have to call set_tx_power, but I
> guess calling it won't hurt, so its your decision check or not.

I'll will call iwl_set_tx_power( ... , false); what seems to be right
thing to do.

Stanislaw
