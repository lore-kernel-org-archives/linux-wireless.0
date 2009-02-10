Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46637 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761AbZBJWFw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 17:05:52 -0500
Subject: Re: [PATCH] ipw2x00: age scan results on resume
From: Dan Williams <dcbw@redhat.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <1234301714.1626.27.camel@rc-desk>
References: <1234280177.3119.23.camel@localhost>
	 <1234301714.1626.27.camel@rc-desk>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 17:04:18 -0500
Message-Id: <1234303458.15997.24.camel@localhost> (sfid-20090210_230556_441447_332461A2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-02-10 at 13:35 -0800, reinette chatre wrote:
> On Tue, 2009-02-10 at 07:36 -0800, Dan Williams wrote:
> > Scanned BSS entries are timestamped with jiffies, which doesn't
> > increment across suspend and hibernate.  On resume, every BSS in the
> > scan list looks like it was scanned within the last 10 seconds,
> > irregardless of how long the machine was actually asleep.  Age scan
> > results on resume with the time spent during sleep so userspace has a
> > clue how old they really are.
> > 
> > Signed-off-by: Dan Williams <dcbw@redhat.com>
> 
> This makes sense.
> 
> > ---
> > This fixes NetworkManager and wpa_supplicant trying to connect to the AP
> > associated with at suspend/hibernate time, which clearly may not exist
> > at the location where the machine is waking up.
> > 
> > diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
> > index 823c2bf..abf897d 100644
> > --- a/drivers/net/wireless/ipw2x00/ipw2100.c
> > +++ b/drivers/net/wireless/ipw2x00/ipw2100.c
> > @@ -1692,7 +1692,13 @@ static int ipw2100_up(struct ipw2100_priv *priv, int deferred)
> >  	u32 lock;
> >  	u32 ord_len = sizeof(lock);
> >  
> > -	/* Quite if manually disabled. */
> > +	/* Age scan list entries found before suspend */
> > +	if (priv->suspend_time) {
> > +		ieee80211_networks_age(priv->ieee, priv->suspend_time);
> > +		priv->suspend_time = 0;
> > +	}
> > +
> > +	/* Quiet if manually disabled. */
> >  	if (priv->status & STATUS_RF_KILL_SW) {
> >  		IPW_DEBUG_INFO("%s: Radio is disabled by Manual Disable "
> >  			       "switch\n", priv->net_dev->name);
> > @@ -6414,6 +6420,9 @@ static int ipw2100_suspend(struct pci_dev *pci_dev, pm_message_t state)
> >  	pci_disable_device(pci_dev);
> >  	pci_set_power_state(pci_dev, PCI_D3hot);
> >  
> > +	if (!priv->suspend_at)
> > +		priv->suspend_at = get_seconds();
> > +
> 
> I do not see where suspend_at is reset. Would that not confuse things
> when you suspend two or more times?

Ah right; left over from a previous iteration.  Thanks for the catch.

Dan


