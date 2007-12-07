Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191AbXLGTU4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 14:20:56 -0500
Subject: Re: [PATCH] libertas: implement new scanning logic
From: Dan Williams <dcbw@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <1197052412.13978.620.camel@pmac.infradead.org>
References: <200711290927.15915.hs4233@mail.mn-solutions.de>
	 <1196787130.4772.2.camel@localhost.localdomain>
	 <200712071547.37944.hs4233@mail.mn-solutions.de>
	 <1197050263.30465.7.camel@localhost.localdomain>
	 <1197050743.13978.606.camel@pmac.infradead.org>
	 <1197050996.30465.17.camel@localhost.localdomain>
	 <1197051573.13978.612.camel@pmac.infradead.org>
	 <1197051857.30465.30.camel@localhost.localdomain>
	 <1197052412.13978.620.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Fri, 07 Dec 2007 14:14:12 -0500
Message-Id: <1197054852.4465.7.camel@localhost.localdomain> (sfid-20071207_192104_439509_952BDF9E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-12-07 at 18:33 +0000, David Woodhouse wrote:
> On Fri, 2007-12-07 at 13:24 -0500, Dan Williams wrote:
> > You can really just take that NOKEY line out completely, you don't need
> > anything else in this patch.
> 
> Well, there's no point in setting/clearing IW_ENCODE_DISABLED twice,
> which is why I removed that bit...
> 
> > > -	if (   adapter->secinfo.wep_enabled
> > > -	    || adapter->secinfo.WPAenabled
> > > -	    || adapter->secinfo.WPA2enabled) {
> > > -		dwrq->flags &= ~IW_ENCODE_DISABLED;
> > > -	} else {
> > > -		dwrq->flags |= IW_ENCODE_DISABLED;
> > > -	}
> > > -
> > >  	memset(extra, 0, 16);
> > >  
> > >  	mutex_lock(&adapter->lock);
> 
> 
> And since I don't see anywhere that we'd copy a WPA key into the
> response, I figured it made sense to keep IW_ENCODE_NOKEY in this bit
> too: 
> 
> > > @@ -1150,14 +1142,13 @@ static int lbs_get_encode(struct net_device *dev,
> > >  		   || (adapter->secinfo.WPA2enabled)) {
> > >  		/* return WPA enabled */
> > >  		dwrq->flags &= ~IW_ENCODE_DISABLED;
> > > +		dwrq->flags |= IW_ENCODE_NOKEY;
> > >  	} else {
> > >  		dwrq->flags |= IW_ENCODE_DISABLED;
> > >  	}
> 
> I'd want to set up an AP with WPA and test it if I was going to actually
> make it find and return the WPA key.

You could, but there's not too much of a point in spending time on this
unless you've got a really good reason?  I'm sure there are more
important things to do in the driver...

Dan


