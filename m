Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44862 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbbJONX2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 09:23:28 -0400
Date: Thu, 15 Oct 2015 16:23:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	rachel.kim@atmel.com, chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 40/40] staging: wilc1000: fixes comparison to NULL could
 be written
Message-ID: <20151015132303.GA7340@mwanda> (sfid-20151015_152332_124462_CE47AB94)
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
 <1444883121-31757-40-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444883121-31757-40-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 15, 2015 at 01:25:21PM +0900, Tony Cho wrote:
> @@ -2306,7 +2303,8 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
>  	strWID.type = WID_BIN;
>  	strWID.size = pstrSetBeaconParam->head_len + pstrSetBeaconParam->tail_len + 16;
>  	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
> -	if (strWID.val == NULL)
> +
> +	if (!strWID.val)
>  		goto ERRORHANDLER;
>  
>  	pu8CurrByte = strWID.val;

This patch is fine, but an unrelated comment is that, in wilc1000 the
pattern is to put a blank line between the allocation and the error
check but that's the wrong thing.  The allocation and the check are part
of the same step and they should go next to each other.

regards,
dan carpenter

