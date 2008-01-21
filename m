Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44768
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758243AbYAULhI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 06:37:08 -0500
Date: Mon, 21 Jan 2008 03:37:14 -0800 (PST)
Message-Id: <20080121.033714.254598863.davem@davemloft.net> (sfid-20080121_113712_773285_88D42267)
To: mokuno@sm.sony.co.jp
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: : Emit event stream compat iw_point objects correctly.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080121194942.613C.40F06B3A@sm.sony.co.jp>
References: <20071227181439.6F59.40F06B3A@sm.sony.co.jp>
	<20080110.011602.74511551.davem@davemloft.net>
	<20080121194942.613C.40F06B3A@sm.sony.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Date: Mon, 21 Jan 2008 20:23:15 +0900

> Sorry for my intermittent posts.

No problem.

I am sorry for being to busy to get back to active work
on this patch set.

> > -prism54_translate_bss(struct net_device *ndev, char *current_ev,
> > -		      char *end_buf, struct obj_bss *bss, char noise)
> > +prism54_translate_bss(struct net_device *ndev, struct iw_request_info *info,
> > +		      char *current_ev, char *end_buf, struct obj_bss *bss,
> > +		      char noise)
> >  {
> >  	struct iw_event iwe;	/* Temporary buffer */
> >  	short cap;
> 
> <snip>
> 
> > @@ -2728,9 +2730,12 @@ prism2_ioctl_scan_req(struct net_device *ndev,
> >  	rvalue |= mgt_get_request(priv, DOT11_OID_BSSLIST, 0, NULL, &r);
> >  	bsslist = r.ptr;
> >  
> > +	info.cmd = PRISM54_HOSTAPD;
> > +	info.flags = 0;
> > +
> >  	/* ok now, scan the list and translate its info */
> >  	for (i = 0; i < min(IW_MAX_AP, (int) bsslist->nr); i++)
> > -		current_ev = prism54_translate_bss(ndev, current_ev,
> > +		current_ev = prism54_translate_bss(ndev, current_ev, &info,
> 
> The order of the arguments is wrong.
> 
> current_ev = prism54_translate_bss(ndev, &info, current_ev,

Indeed, I will fix this up in a future version.

I will also investigate why this escaped my build testing.
It is merely a PCI driver, so it should have been included
in the "make allmodconfig" test builds I do on sparc64.

Thank you.
