Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31495 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbbI2CcO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 22:32:14 -0400
Date: Tue, 29 Sep 2015 05:31:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chandra S Gorentla <csgorentla@gmail.com>
Cc: gregkh@linuxfoundation.org, johnny.kim@atmel.com,
	rachel.kim@atmel.com, dean.lee@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 1/2] drivers: staging: wilc1000: Replace message queue
 with standard Linux lists
Message-ID: <20150929023152.GD7289@mwanda> (sfid-20150929_043228_499908_397A8D57)
References: <1443464037-3591-1-git-send-email-csgorentla@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443464037-3591-1-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 28, 2015 at 11:43:55PM +0530, Chandra S Gorentla wrote:
>  - The message queue is replaced with standard Linux linked list
>  - kmem_cache is used for list members
>  - A check for return value of receive method is added
>  - GFP_ATOMIC is changed to GFP_KERNEL
>  - A few other related minor changes

These should be listed and explained.

>  
>  	while (1) {
> -		wilc_mq_recv(&gMsgQHostIF, &msg, sizeof(struct host_if_msg), &u32Ret);
> +		ret = wilc_mq_recv(&gMsgQHostIF, &msg,
> +					sizeof(struct host_if_msg), &u32Ret);
> +		if (ret)
> +			continue;
> +

I asked before if this was a forever loop and never got a response.
Also what does this have to do with list macros?

regards,
dan carpenter
