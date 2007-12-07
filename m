Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548AbXLGSbL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 13:31:11 -0500
Subject: Re: [PATCH] libertas: implement new scanning logic
From: Dan Williams <dcbw@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <1197051573.13978.612.camel@pmac.infradead.org>
References: <200711290927.15915.hs4233@mail.mn-solutions.de>
	 <1196787130.4772.2.camel@localhost.localdomain>
	 <200712071547.37944.hs4233@mail.mn-solutions.de>
	 <1197050263.30465.7.camel@localhost.localdomain>
	 <1197050743.13978.606.camel@pmac.infradead.org>
	 <1197050996.30465.17.camel@localhost.localdomain>
	 <1197051573.13978.612.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Fri, 07 Dec 2007 13:24:17 -0500
Message-Id: <1197051857.30465.30.camel@localhost.localdomain> (sfid-20071207_183115_238511_180CE3DE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-12-07 at 18:19 +0000, David Woodhouse wrote:
> On Fri, 2007-12-07 at 13:09 -0500, Dan Williams wrote:
> > On Fri, 2007-12-07 at 18:05 +0000, David Woodhouse wrote:
> > > On Fri, 2007-12-07 at 12:57 -0500, Dan Williams wrote:
> > > > Yeah, go ahead.  I got distracted because of changes in > 2.6.23 kernels
> > > > that cause the driver not to build there, and haven't chased them down
> > > > yet.
> > > 
> > > Hm, it's building for me. Where can I get hold of hardware?
> > 
> > Either get some from Manas, or find me.
> 
> I'll be in Boston next week. I'll try to find you.
> 
> Btw, is there any particular reason we're setting IW_ENCODE_NOKEY in
> lbs_get_encode()? Looks like we aren't returning it for WPA, but we
> could return it in WEP modes. This seems to work...

In GIWENCODE, NOKEY is supposed to mean that the key is write-only and
can't be read out of the card's registers or firmware.  This one came
over when harmonizing the libertas handlers with airo.  Since libertas
always caches the keys (both WEP and WPA) internally, it doesn't ever
need to set NOKEY in GIWENCODE because they are always available.

You can really just take that NOKEY line out completely, you don't need
anything else in this patch.

Dan

> diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
> index b8c93c0..1af140b 100644
> --- a/drivers/net/wireless/libertas/wext.c
> +++ b/drivers/net/wireless/libertas/wext.c
> @@ -1122,14 +1122,6 @@ static int lbs_get_encode(struct net_device *dev,
>  		break;
>  	}
>  
> -	if (   adapter->secinfo.wep_enabled
> -	    || adapter->secinfo.WPAenabled
> -	    || adapter->secinfo.WPA2enabled) {
> -		dwrq->flags &= ~IW_ENCODE_DISABLED;
> -	} else {
> -		dwrq->flags |= IW_ENCODE_DISABLED;
> -	}
> -
>  	memset(extra, 0, 16);
>  
>  	mutex_lock(&adapter->lock);
> @@ -1150,14 +1142,13 @@ static int lbs_get_encode(struct net_device *dev,
>  		   || (adapter->secinfo.WPA2enabled)) {
>  		/* return WPA enabled */
>  		dwrq->flags &= ~IW_ENCODE_DISABLED;
> +		dwrq->flags |= IW_ENCODE_NOKEY;
>  	} else {
>  		dwrq->flags |= IW_ENCODE_DISABLED;
>  	}
>  
>  	mutex_unlock(&adapter->lock);
>  
> -	dwrq->flags |= IW_ENCODE_NOKEY;
> -
>  	lbs_deb_wext("key: %02x:%02x:%02x:%02x:%02x:%02x, keylen %d\n",
>  	       extra[0], extra[1], extra[2],
>  	       extra[3], extra[4], extra[5], dwrq->length);
> 
> 

