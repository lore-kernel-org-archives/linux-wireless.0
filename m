Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33068 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbbFZPFj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 11:05:39 -0400
Date: Fri, 26 Jun 2015 17:11:44 +0200
From: Luis de Bethencourt <luis@debethencourt.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 3/4] staging: wilc1000: remove whitespaces before quoted
 newlines
Message-ID: <20150626151141.GA31177@goodgumbo.baconseed.org> (sfid-20150626_170545_049029_73052926)
References: <20150626144555.GA30031@goodgumbo.baconseed.org>
 <1435330172.9377.52.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435330172.9377.52.camel@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 26, 2015 at 07:49:32AM -0700, Joe Perches wrote:
> On Fri, 2015-06-26 at 16:45 +0200, Luis de Bethencourt wrote:
> > Fix all checkpatch.pl warnings:
> > WARNING: unnecessary whitespace before a quoted newline
> 
> Unassociated but:
> 
> > diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> []
> > @@ -740,7 +740,7 @@ s32 Handle_set_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
> >  	if (pu8IPAddr[0] < 192)
> >  		pu8IPAddr[0] = 0;
> >  
> > -	PRINT_INFO(HOSTINF_DBG, "Indx = %d, Handling set  IP = %d.%d.%d.%d \n", idx, pu8IPAddr[0], pu8IPAddr[1], pu8IPAddr[2], pu8IPAddr[3]);
> > +	PRINT_INFO(HOSTINF_DBG, "Indx = %d, Handling set  IP = %d.%d.%d.%d\n", idx, pu8IPAddr[0], pu8IPAddr[1], pu8IPAddr[2], pu8IPAddr[3]);
> 
> These printks with ip addresses could use vsprintf extension %pI4
> 
> 	PRINT_INFO(HOSTINF_DBG, "Indx = %d, Handling set  IP = %pI4\n",
> 		   idx, pu8IPAddr);
> 
> 

Hi Joe,

I could send this as a 5th patch in the series if you'd like, and set you as
author.

-   PRINT_INFO(HOSTINF_DBG, "Indx = %d, Handling set  IP = %d.%d.%d.%d\n", idx, pu8IPAddr[0], pu8IPAddr[1], pu8    IPAddr[2], pu8IPAddr[3]);
+   PRINT_INFO(HOSTINF_DBG, "Indx = %d, Handling set  IP = %pI4\n", idx, pu8IPAddr);

Thanks,
Luis
