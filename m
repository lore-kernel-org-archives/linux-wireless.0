Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23303 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbbKIITF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2015 03:19:05 -0500
Date: Mon, 9 Nov 2015 11:18:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: glen lee <glen.lee@atmel.com>
Cc: Punit Vara <punitvara@gmail.com>, devel@driverdev.osuosl.org,
	chris.park@atmel.com, austin.shin@atmel.com,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, linux-kernel@vger.kernel.org,
	tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH V2] Staging: wilc1000: Fix build break due to undeclared
 *wilc and implicit declaration of init_irq
Message-ID: <20151109081842.GR18797@mwanda> (sfid-20151109_091910_451799_4BE4F7C8)
References: <1447018310-4524-1-git-send-email-punitvara@gmail.com>
 <20151108215953.GO18797@mwanda>
 <563FFEEB.1090307@atmel.com>
 <56405328.4040004@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56405328.4040004@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 09, 2015 at 05:02:48PM +0900, glen lee wrote:
> Hi Punit Vara,
> 
> I cannot find build errors on my build machines.
> 
> According the log which you have posted before says *wilc is undeclared in the function init_wilc_driver,
> which means WILC_SPI is selected because one of SPI or SDIO should be chosen at the moment.
> Hence, struct wilc *wilc should be compiled together.
> It looks like wilc1000 is compiled without SPI or SDIO.
> 
> Of course, there are many cases that I don't know, so you could let me know the wilc1000 build configuration?
> 
> static int __init init_wilc_driver(void)
> {
> #ifdef WILC_SPI

This should be #ifndef WILC_SDIO


> 	struct wilc *wilc;
> #endif

But the large question remains of why do we have this variable here any
way?

regards,
dan carpenter

