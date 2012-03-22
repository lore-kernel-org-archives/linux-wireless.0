Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36011 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab2CVJYp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2012 05:24:45 -0400
Date: Thu, 22 Mar 2012 10:32:54 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Elias, Ilan" <ilane@ti.com>
Cc: "Lapuyade, Eric" <eric.lapuyade@intel.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] [PATCH] NFC: The core part should generate the target index
Message-ID: <20120322093254.GF3875@sortiz-mobl> (sfid-20120322_102449_133954_9F469BF6)
References: <20120322005305.GD3875@sortiz-mobl>
 <B30D1FD582D6484ABF57420512E5803516A896FF@DNCE03.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <B30D1FD582D6484ABF57420512E5803516A896FF@DNCE03.ent.ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ilan,

On Thu, Mar 22, 2012 at 07:56:27AM +0000, Elias, Ilan wrote:
> Hi Samuel,
>  
> > Ilan, could you please comment on this patch and also make 
> > sure that it
> > doesn't break multiple targets support for NCI ?
> It seems to me that this patch doesn't break multiple targets support for NCI.
Thanks for checking.


> > diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
> > index 5a839ce..47fcf0d 100644
> > --- a/net/nfc/rawsock.c
> > +++ b/net/nfc/rawsock.c
> > @@ -92,6 +92,18 @@ static int rawsock_connect(struct socket 
> > *sock, struct sockaddr *_addr,
> >  		goto error;
> >  	}
> >  
> > +	if (addr->target_idx > dev->target_idx - 1 ||
> > +	    addr->target_idx < dev->target_idx - dev->n_targets) {
> > +		rc = -EINVAL;
> > +		goto error;
> > +	}
> > +
> > +	if (addr->target_idx > dev->target_idx - 1 ||
> > +	    addr->target_idx < dev->target_idx - dev->n_targets) {
> > +		rc = -EINVAL;
> > +		goto error;
> > +	}
> > +
> It looks like the 'if' statement you added appears twice.
Oops, thanks for that one too.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
