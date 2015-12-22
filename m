Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22850 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbbLVIF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2015 03:05:26 -0500
Date: Tue, 22 Dec 2015 11:04:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org, ldv-project@linuxtesting.org,
	Chris Park <chris.park@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	linux-wireless@vger.kernel.org, Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Leo Kim <leo.kim@atmel.com>
Subject: Re: [PATCH] staging: wilc1000: fix double mutex_unlock on failure
 path in wilc_wlan_cleanup()
Message-ID: <20151222080446.GZ5284@mwanda> (sfid-20151222_090644_003629_6F8A9D13)
References: <20151218225010.GA26812@kroah.com>
 <1450648011-1381-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1450648011-1381-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 21, 2015 at 12:46:51AM +0300, Alexey Khoroshilov wrote:
> diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
> index a73e99f..4b7c8e9 100644
> --- a/drivers/staging/wilc1000/wilc_wlan.c
> +++ b/drivers/staging/wilc1000/wilc_wlan.c
> @@ -1459,15 +1459,16 @@ void wilc_wlan_cleanup(struct net_device *dev)
>  	ret = p->hif_func.hif_read_reg(wilc, WILC_GP_REG_0, &reg);
>  	if (!ret) {
>  		PRINT_ER("Error while reading reg\n");
> -		release_bus(wilc, RELEASE_ALLOW_SLEEP);
> +		goto _unlock;

If you're redoing this anyway, could we get rid of the underscore in the
label name?  Just unlock: is fine.

regards,
dan carpenter

