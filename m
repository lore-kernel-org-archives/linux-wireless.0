Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35966 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbbKBNgT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 08:36:19 -0500
Date: Mon, 2 Nov 2015 16:36:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Glen Lee <glen.lee@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 29/38] staging: wilc1000: remove goto from
 linux_wlan_start_firmware
Message-ID: <20151102133602.GE18797@mwanda> (sfid-20151102_143622_825339_215C4975)
References: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
 <1446454281-22484-29-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446454281-22484-29-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 02, 2015 at 05:51:12PM +0900, Glen Lee wrote:
>  	PRINT_D(INIT_DBG, "Waiting for Firmware to get ready ...\n");
>  	ret = linux_wlan_lock_timeout(&wilc->sync_event, 5000);
>  	if (ret) {
>  		PRINT_D(INIT_DBG, "Firmware start timed out");
> -		goto _fail_;
> +		return ret;
>  	}
>  	PRINT_D(INIT_DBG, "Firmware successfully started\n");
>  
> -_fail_:
>  	return ret;

In a later patch, could you change this from "return ret;" to
"return 0;"

regards,
dan carpenter

