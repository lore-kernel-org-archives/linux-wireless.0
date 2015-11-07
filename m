Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36557 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbbKGNyo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2015 08:54:44 -0500
Date: Sat, 7 Nov 2015 16:54:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Punit Vara <punitvara@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	johnny.kim@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH] Staging: wilc1000: Fix build break due to undeclared
 *wilc and implicit declaration of init_irq
Message-ID: <20151107135427.GH18797@mwanda> (sfid-20151107_145500_756024_4CB61629)
References: <1446895909-30052-1-git-send-email-punitvara@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446895909-30052-1-git-send-email-punitvara@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 07, 2015 at 05:01:49PM +0530, Punit Vara wrote:
>  int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
>  {
> @@ -1791,6 +1794,7 @@ int wilc_netdev_init(struct wilc **wilc)
>  /*The 1st function called after module inserted*/
>  static int __init init_wilc_driver(void)
>  {
> +	struct wilc *wilc;
>  #ifdef WILC_SPI
>  	struct wilc *wilc;
>  #endif

This patch still has the same problems as before.

regards,
dan carpenter


