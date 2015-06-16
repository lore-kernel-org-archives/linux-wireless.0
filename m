Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:33942 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbbFPIKJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 04:10:09 -0400
Date: Tue, 16 Jun 2015 13:39:55 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: "Abdul, Hussain (H.)" <habdul@visteon.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"Dighe, Niranjan (N.)" <ndighe@visteon.com>,
	"chris.park@atmel.com" <chris.park@atmel.com>,
	"Ravindran, Madhusudhanan (M.)" <mravindr@visteon.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"johnny.kim@atmel.com" <johnny.kim@atmel.com>,
	"rachel.kim@atmel.com" <rachel.kim@atmel.com>,
	"dean.lee@atmel.com" <dean.lee@atmel.com>
Subject: Re: [PATCH] Staging: wilc1000: Boolean tests don't need comparisons
Message-ID: <20150616080955.GA1007@sudip-PC> (sfid-20150616_101028_265593_823FB687)
References: <1434439941-6369-1-git-send-email-habdul@visteon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434439941-6369-1-git-send-email-habdul@visteon.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 16, 2015 at 07:33:42AM +0000, Abdul, Hussain (H.) wrote:
> From: Abdul Hussain <habdul@visteon.com>
> 
> This patch removes unwanted true and false from boolean tests.
> 
> Signed-off-by: Abdul Hussain <habdul@visteon.com>
> ---
<snip>
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 17ab5cd..be1f6bf 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -7816,7 +7816,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
>  					pNewJoinBssParam->rsn_cap[1] = pu8IEs[rsnIndex + 1];
>  					rsnIndex += 2;
>  				}
> -				pNewJoinBssParam->rsn_found = 1;
> +				pNewJoinBssParam->rsn_found = true;
But this is not a boolean test, this is an assignement.

regards
sudip
