Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0253.hostedemail.com ([216.40.44.253]:43912 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754946AbbJ1RGZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 13:06:25 -0400
Message-ID: <1446051981.2757.118.camel@perches.com> (sfid-20151028_180628_825816_E65FF84B)
Subject: Re: [PATCH 38/80] staging: wilc1000: rename au8Bssid of struct
 ba_session_info
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Glen Lee <glen.lee@atmel.com>, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, Nicolas.FERRE@atmel.com,
	adel.noureldin@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Date: Wed, 28 Oct 2015 10:06:21 -0700
In-Reply-To: <20151028165606.GB18797@mwanda>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
	 <1446015640-29398-38-git-send-email-glen.lee@atmel.com>
	 <20151028165606.GB18797@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-10-28 at 19:56 +0300, Dan Carpenter wrote:
> On Wed, Oct 28, 2015 at 03:59:58PM +0900, Glen Lee wrote:
> > From: Leo Kim <leo.kim@atmel.com>
> > 
> > This patch renames au8Bssid of struct ba_session_info to bssid
> > to avoid CamelCase naming convention.
> > And, some debug logs modified because 80 ending line over warnings.

Don't worry about some 80 column warnings.

> > diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
[]
> > @@ -2715,10 +2715,14 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
> >  	int AddbaTimeout = 100;
> >  	char *ptr = NULL;
> >  
> > -	PRINT_D(HOSTINF_DBG, "Opening Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\nBufferSize == %d\nSessionTimeOut = %d\n",
> > -		strHostIfBASessionInfo->au8Bssid[0],
> > -		strHostIfBASessionInfo->au8Bssid[1],
> > -		strHostIfBASessionInfo->au8Bssid[2],
> > +	PRINT_D(HOSTINF_DBG, "Opening Block Ack session with \
> > +		\nBSSID = %.2x:%.2x:%.2x \
> > +		\nBufferSize == %d \
> > +		\nSessionTimeOut = %d \
> > +		\nTID=%d\n",
> > +		strHostIfBASessionInfo->bssid[0],
> > +		strHostIfBASessionInfo->bssid[1],
> > +		strHostIfBASessionInfo->bssid[2],
> >  		strHostIfBASessionInfo->u16BufferSize,
> >  		strHostIfBASessionInfo->u16SessionTimeout,
> >  		strHostIfBASessionInfo->u8Ted);
> 
> This should be a bunch of printks so that we have the correct debug
> level at the start of each line.

Also, don't use continuation \
as this adds undesired whitespace for each new line

Realistically, this should just be a single line output.

	PRINT_D(HOSTINF_DBG, "Opening Block Ack session with BSSID = %02x:%02x:%02x TID=%d BufferSize == %d SessionTimeOut = %d\n",
		etc...

But why are only 3 bytes of the bssid desired/emitted?


