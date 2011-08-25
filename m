Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3664 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab1HYAuE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 20:50:04 -0400
Date: Wed, 24 Aug 2011 17:49:48 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Dan Carpenter" <error27@gmail.com>
cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110825004948.GA11501@broadcom.com> (sfid-20110825_025008_775467_30670367)
References: <20110707002034.GA17885@broadcom.com>
 <20110824222801.GA5280@broadcom.com>
 <20110824230531.GJ5975@shale.localdomain>
MIME-Version: 1.0
In-Reply-To: <20110824230531.GJ5975@shale.localdomain>
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 04:05:31PM -0700, Dan Carpenter wrote:
> On Wed, Aug 24, 2011 at 03:28:01PM -0700, Henry Ptasinski wrote:
> > diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm8021
> > index 05dad9f..73e5841 100644
> > --- a/drivers/staging/brcm80211/brcmsmac/dma.c
> > +++ b/drivers/staging/brcm80211/brcmsmac/dma.c
> > @@ -815,7 +815,7 @@ struct sk_buff *dma_rx(struct dma_pub *pub)
> >                 tail = head;
> >                 while ((resid > 0) && (p = _dma_getnextrxp(di, false))) {
> >                         tail->next = p;
> > -                       pkt_len = min(resid, (int)di->rxbufsize);
> > +                       pkt_len = min_t(int, resid, (int)di->rxbufsize);
> 
> This isn't right.  It should be:
> 			pkt_len = min_t(uint, resid, di->rxbufsize);
> 
> Casting it to int would mean that high values of ->rxbufsize would be
> treated as lower than "resid".

Good point.  I'll work that change into the next version or send a separate
patch to fix it up.

> 
> >                         __skb_trim(p, pkt_len);
> >  
> >                         tail = p;
> 
> regards,
> dan carpenter

Thanks,
- Henry

