Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51306 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbXLGSds (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 13:33:48 -0500
Subject: Re: [PATCH] libertas: implement new scanning logic
From: David Woodhouse <dwmw2@infradead.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <1197051857.30465.30.camel@localhost.localdomain>
References: <200711290927.15915.hs4233@mail.mn-solutions.de>
	 <1196787130.4772.2.camel@localhost.localdomain>
	 <200712071547.37944.hs4233@mail.mn-solutions.de>
	 <1197050263.30465.7.camel@localhost.localdomain>
	 <1197050743.13978.606.camel@pmac.infradead.org>
	 <1197050996.30465.17.camel@localhost.localdomain>
	 <1197051573.13978.612.camel@pmac.infradead.org>
	 <1197051857.30465.30.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 07 Dec 2007 18:33:32 +0000
Message-Id: <1197052412.13978.620.camel@pmac.infradead.org> (sfid-20071207_183351_998517_439D3A93)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 2007-12-07 at 13:24 -0500, Dan Williams wrote:
> You can really just take that NOKEY line out completely, you don't need
> anything else in this patch.

Well, there's no point in setting/clearing IW_ENCODE_DISABLED twice,
which is why I removed that bit...

> > -	if (   adapter->secinfo.wep_enabled
> > -	    || adapter->secinfo.WPAenabled
> > -	    || adapter->secinfo.WPA2enabled) {
> > -		dwrq->flags &= ~IW_ENCODE_DISABLED;
> > -	} else {
> > -		dwrq->flags |= IW_ENCODE_DISABLED;
> > -	}
> > -
> >  	memset(extra, 0, 16);
> >  
> >  	mutex_lock(&adapter->lock);


And since I don't see anywhere that we'd copy a WPA key into the
response, I figured it made sense to keep IW_ENCODE_NOKEY in this bit
too: 

> > @@ -1150,14 +1142,13 @@ static int lbs_get_encode(struct net_device *dev,
> >  		   || (adapter->secinfo.WPA2enabled)) {
> >  		/* return WPA enabled */
> >  		dwrq->flags &= ~IW_ENCODE_DISABLED;
> > +		dwrq->flags |= IW_ENCODE_NOKEY;
> >  	} else {
> >  		dwrq->flags |= IW_ENCODE_DISABLED;
> >  	}

I'd want to set up an AP with WPA and test it if I was going to actually
make it find and return the WPA key.

-- 
dwmw2

