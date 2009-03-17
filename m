Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35134 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbZCQUAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 16:00:35 -0400
Date: Tue, 17 Mar 2009 15:59:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/7] p54: refractor beacon_update and stop path
Message-ID: <20090317195939.GH6737@tuxdriver.com> (sfid-20090317_210039_414142_61FCAF7A)
References: <200903052133.32337.chunkeey@web.de> <200903061638.16207.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200903061638.16207.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 06, 2009 at 04:38:16PM +0100, Michael Buesch wrote:
> On Thursday 05 March 2009 21:33:32 Christian Lamparter wrote:
> > According to the LMAC API Section 3.2.2, we don't have to cancel the previous
> > beacon manually. The firmware will automatically return it to the driver
> > through the feedback mechanism. 
> > And while we're at it, we can remove some left over code as well.
> > 
> > Signed-off-by: Christian Lamparter <chunkeey@web.de>
> > ---
> > diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
> > --- a/drivers/net/wireless/p54/p54common.c	2009-03-05 15:42:57.000000000 +0100
> > +++ b/drivers/net/wireless/p54/p54common.c	2009-03-05 15:50:10.000000000 +0100
> > @@ -2015,18 +2015,14 @@ static int p54_beacon_update(struct ieee
> >  	struct sk_buff *beacon;
> >  	int ret;
> >  
> > -	if (priv->cached_beacon) {
> > -		p54_tx_cancel(dev, priv->cached_beacon);
> > -		/* wait for the last beacon the be freed */
> > -		msleep(10);
> > -	}
> > -
> >  	beacon = ieee80211_beacon_get(dev, vif);
> >  	if (!beacon)
> >  		return -ENOMEM;
> >  	ret = p54_beacon_tim(beacon);
> >  	if (ret)
> >  		return ret;
> > +
> > +	/* the firmware will automatically cancel old beacons. */ 
> >  	ret = p54_tx(dev, beacon);
> >  	if (ret)
> >  		return ret;
> > @@ -2072,17 +2068,21 @@ out:
> >  static void p54_stop(struct ieee80211_hw *dev)
> >  {
> >  	struct p54_common *priv = dev->priv;
> > -	struct sk_buff *skb;
> >  
> >  	mutex_lock(&priv->conf_mutex);
> >  	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
> > +	p54_setup_mac(dev);
> >  	cancel_delayed_work_sync(&priv->work);
> > -	if (priv->cached_beacon)
> > -		p54_tx_cancel(dev, priv->cached_beacon);
> > +
> > +	/*
> > +	 * p54spi uses mac80211's workqueue to write the frames into
> > +	 * device's memory. Therefore, we should give the queue a chance
> > +	 * to complete all outstanding work, before the device is stopped.
> > +	 */
> > +	msleep(25);
> 
> What about flush_workqueue()?

I agree, we should use an actual API here and not just "wait long
enough (we hope)"...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
