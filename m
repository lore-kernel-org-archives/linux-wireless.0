Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52361
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753094AbYGCL5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 07:57:25 -0400
Date: Thu, 03 Jul 2008 03:02:41 -0700 (PDT)
Message-Id: <20080703.030241.34728979.davem@davemloft.net> (sfid-20080703_135925_493587_7D33B487)
To: wangchen@cn.fujitsu.com
Cc: netdev@vger.kernel.org, vinay@linux.vnet.ibm.com,
	krkumar2@in.ibm.com, mchan@broadcom.com, Matheos.Worku@Sun.COM,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 06/39]: netdev: ->ingress_lock is no longer needed.
From: David Miller <davem@davemloft.net>
In-Reply-To: <486CA212.6020705@cn.fujitsu.com>
References: <20080703.000303.167904111.davem@davemloft.net>
	<486CA212.6020705@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wang Chen <wangchen@cn.fujitsu.com>
Date: Thu, 03 Jul 2008 17:55:30 +0800

> David Miller said the following on 2008-7-3 15:03:
> > @@ -2014,10 +2014,11 @@ static inline struct sk_buff *handle_macvlan(struct sk_buff *skb,
> >   */
> >  static int ing_filter(struct sk_buff *skb)
> >  {
> > -	struct Qdisc *q;
> >  	struct net_device *dev = skb->dev;
> > -	int result = TC_ACT_OK;
> >  	u32 ttl = G_TC_RTTL(skb->tc_verd);
> > +	struct netdev_queue *rxq;
> > +	int result = TC_ACT_OK;
> > +	struct Qdisc *q;
> >  
> 
> Two lines do not change anything.

They make the variables have a nice style slope from longest
lines to the shortest.

If I'm going to edit this much of the TX path, I'm going to
cleanup coding style details like this along the way.
