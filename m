Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40195 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbbGXApA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2015 20:45:00 -0400
Date: Fri, 24 Jul 2015 03:44:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: gregkh@linuxfoundation.org, rachel.kim@atmel.com,
	dean.lee@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com
Subject: Re: [PATCH V2 1/3] staging: wilc1000: coreconfigurator.c: remove
 WILC_MALLOC
Message-ID: <20150724004454.GU5371@mwanda> (sfid-20150724_024503_919836_FD10D946)
References: <1437695755-9731-1-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1437695755-9731-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 24, 2015 at 08:55:53AM +0900, Chaehyun Lim wrote:
> Use kmalloc and kmalloc_array instead of WILC_MALLOC.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
> V2: Use GFP_KERNEL flag instead of GFP_ATOMIC

This is probably the correct thing but how did you check that we aren't
holding a spin_lock or in IRQ context?

regards,
dan carpenter

