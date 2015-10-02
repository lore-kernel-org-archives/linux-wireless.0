Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30053 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbbJBLhP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 07:37:15 -0400
Date: Fri, 2 Oct 2015 14:37:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Chaehyun Lim <chaehyun.lim@gmail.com>, gregkh@linuxfoundation.org,
	johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 08/12] staging: wilc1000: use s8 instead of int8_t
Message-ID: <20151002113701.GN7289@mwanda> (sfid-20151002_133720_521721_212B6743)
References: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
 <1443707039-18433-8-git-send-email-chaehyun.lim@gmail.com>
 <560E3628.4000105@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <560E3628.4000105@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 02, 2015 at 09:45:44AM +0200, Arend van Spriel wrote:
> On 10/01/2015 03:43 PM, Chaehyun Lim wrote:
> >This patch replaces int8_t with s8 that is a preferred type.
> >
> >Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> >---
> >  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> >diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> >index d781003..56c97c9 100644
> >--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> >+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> >@@ -263,9 +263,9 @@ static void clear_duringIP(unsigned long arg)
> >  	g_obtainingIP = false;
> >  }
> >
> >-int8_t is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
> >+s8 is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
> 
> It seems to make more sense to use bool type here.

That doesn't work, but you're right that the function is poorly named.

It could be renamed to get_ap_index_or_something() in a later patch.
Returning directly is also a good idea.

regards,
dan carpenter

