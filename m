Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41554 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab0IAOZQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 10:25:16 -0400
Subject: Re: [PATCH w-t] iwlwifi: rewrite iwl-scan.c to avoid race
 conditions
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100901141658.GA20421@redhat.com>
References: <20100831150021.GA10963@redhat.com>
	 <1283345553.4124.6.camel@jlt3.sipsolutions.net>
	 <20100901141658.GA20421@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 16:24:59 +0200
Message-ID: <1283351099.4124.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-01 at 16:16 +0200, Stanislaw Gruszka wrote:

> > > +void iwl_wait_for_scan_end(struct iwl_priv *priv)
> > > +{
> > > +	unsigned long timeout = jiffies + IWL_SCAN_WAIT_END;
> > > +
> > > +	while (time_before_eq(jiffies, timeout)) {
> > > +		if (!test_bit(STATUS_SCANNING, &priv->status))
> > > +			break;
> > > +		msleep(20);
> > > +	}
> > 
> > this seems like it could use a completion?
> 
> We don't know is scanning is currently performed or not,
> so we nobody could ever call complete(). Above code works
> fine if no scan is running. 

Then I guess it should be a waitqueue?

johannes

