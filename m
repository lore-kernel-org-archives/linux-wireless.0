Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41749 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762474AbXJROjy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2007 10:39:54 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Subject: RE: [2.6 patch] iwl4965-base.c: fix off-by-one errors
Date: Thu, 18 Oct 2007 07:35:46 -0700
Message-ID: <4220499A1B034C4FA93B547BA01E1FF0017463E0@orsmsx413.amr.corp.intel.com> (sfid-20071018_154007_281745_D64EE108)
In-Reply-To: <20071014175115.GL4211@stusta.de>
References: <20071014175115.GL4211@stusta.de>
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: "Adrian Bunk" <bunk@kernel.org>, "Zhu, Yi" <yi.zhu@intel.com>
Cc: <linux-wireless@vger.kernel.org>,
	<ipw3945-devel@lists.sourceforge.net>,
	<linux-kernel@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ACK ... good catch.

-- Ben --

> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org 
> [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Adrian Bunk
> Sent: Sunday, October 14, 2007 1:51 PM
> To: Zhu, Yi
> Cc: linux-wireless@vger.kernel.org; 
> ipw3945-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: [2.6 patch] iwl4965-base.c: fix off-by-one errors
> 
> This patch fixes two off-by-one errors resulting in array 
> overflows spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  drivers/net/wireless/iwlwifi/iwl4965-base.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- linux-2.6/drivers/net/wireless/iwlwifi/iwl4965-base.c.old	
> 2007-10-14 16:52:21.000000000 +0200
> +++ linux-2.6/drivers/net/wireless/iwlwifi/iwl4965-base.c	
> 2007-10-14 16:59:37.000000000 +0200
> @@ -4489,23 +4489,23 @@ static u8 ratio2dB[100] = {
>  	39, 39, 39, 39, 39, 40, 40, 40, 40, 40  /* 90 - 99 */  };
>  
>  /* Calculates a relative dB value from a ratio of linear
>   *   (i.e. not dB) signal levels.
>   * Conversion assumes that levels are voltages (20*log), not 
> powers (10*log). */  int iwl_calc_db_from_ratio(int sig_ratio)  {
> -	/* Anything above 1000:1 just report as 60 dB */
> -	if (sig_ratio > 1000)
> +	/* 1000:1 or higher just report as 60 dB */
> +	if (sig_ratio >= 1000)
>  		return 60;
>  
> -	/* Above 100:1, divide by 10 and use table,
> +	/* 100:1 or higher, divide by 10 and use table,
>  	 *   add 20 dB to make up for divide by 10 */
> -	if (sig_ratio > 100)
> +	if (sig_ratio >= 100)
>  		return (20 + (int)ratio2dB[sig_ratio/10]);
>  
>  	/* We shouldn't see this */
>  	if (sig_ratio < 1)
>  		return 0;
>  
>  	/* Use table for ratios 1:1 - 99:1 */
>  	return (int)ratio2dB[sig_ratio];
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> 
