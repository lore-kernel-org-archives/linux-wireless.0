Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36509 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753868AbYAZVwZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 16:52:25 -0500
From: Helge Deller <deller@gmx.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] use is_valid_ether_addr() macro in wireless drivers
Date: Sat, 26 Jan 2008 22:52:22 +0100
Cc: linux-wireless@vger.kernel.org
References: <200801262238.18719.deller@gmx.de> <200801262245.40184.mb@bu3sch.de>
In-Reply-To: <200801262245.40184.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801262252.22626.deller@gmx.de> (sfid-20080126_215228_930595_1B7AE113)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 26 January 2008, Michael Buesch wrote:
> On Saturday 26 January 2008 22:38:18 Helge Deller wrote:
> > use is_valid_ether_addr() macro instead of hand-coded checks for 
> > valid IP address.
> > 
> 
> > diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
> > index 42a36b3..7251e71 100644
> > --- a/drivers/net/wireless/wl3501_cs.c
> > +++ b/drivers/net/wireless/wl3501_cs.c
> > @@ -1577,13 +1577,12 @@ static int wl3501_set_wap(struct net_device *dev, struct iw_request_info *info,
> >  			  union iwreq_data *wrqu, char *extra)
> >  {
> >  	struct wl3501_card *this = netdev_priv(dev);
> > -	static const u8 bcast[ETH_ALEN] = { 255, 255, 255, 255, 255, 255 };
> >  	int rc = -EINVAL;
> >  
> >  	/* FIXME: we support other ARPHRDs...*/
> >  	if (wrqu->ap_addr.sa_family != ARPHRD_ETHER)
> >  		goto out;
> > -	if (!memcmp(bcast, wrqu->ap_addr.sa_data, ETH_ALEN)) {
> > +	if (!is_valid_ether_addr(wrqu->ap_addr.sa_data)) {
> >  		/* FIXME: rescan? */
> >  	} else
> >  		memcpy(this->bssid, wrqu->ap_addr.sa_data, ETH_ALEN);
> 
> This is a semantical change.
> If the original code is correct, this should be is_broadcast_ether_addr()

Yes, but the original code is probably wrong.
So I think my patch fixes a bug here as well.

Helge
