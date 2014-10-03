Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46241 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaJCMNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2014 08:13:40 -0400
Date: Fri, 3 Oct 2014 15:13:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: c_manoha@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath: Add support for tracing
Message-ID: <20141003121331.GK5865@mwanda> (sfid-20141003_141346_707909_08D664A5)
References: <20141003121101.GA23748@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141003121101.GA23748@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 03, 2014 at 03:11:01PM +0300, Dan Carpenter wrote:
> Hello Sujith Manoharan,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch e6664dff0608: "ath: Add support for tracing" from Sep 27, 
> 2014, leads to the following Smatch complaint:
> 
> drivers/net/wireless/ath/main.c:88 ath_printk()
> 	 error: we previously assumed 'common->hw' could be null (see line 82)
> 
> drivers/net/wireless/ath/main.c
>     81	
>     82		if (common && common->hw && common->hw->wiphy)

Oh.  And also common is assumed to be possibly NULL as well.

regards,
dan carpenter

>                               ^^^^^^^^^^
> Existing code assumes common->hw can be NULL.
> 
>     83			printk("%sath: %s: %pV",
>     84			       level, wiphy_name(common->hw->wiphy), &vaf);
>     85		else
>     86			printk("%sath: %pV", level, &vaf);
>     87	
>     88		trace_ath_log(common->hw->wiphy, &vaf);
>                               ^^^^^^^^^^^^^^^^^
> New code dereferences it without checking for NULL.
> 
>     89	
>     90		va_end(args);
> 
> regards,
> dan carpenter
