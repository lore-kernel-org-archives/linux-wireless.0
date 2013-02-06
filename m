Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29561 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3BFMJH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 07:09:07 -0500
Date: Wed, 6 Feb 2013 15:09:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath6kl: move ath6kl_wmi_startscan_cmd()
Message-ID: <20130206120906.GT4989@mwanda> (sfid-20130206_130911_607138_B9F93577)
References: <20121127072531.GB8239@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121127072531.GB8239@elgon.mountain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whatever happened with this?

regards,
dan carpenter

On Tue, Nov 27, 2012 at 10:25:32AM +0300, Dan Carpenter wrote:
> Hello Kalle Valo,
> 
> The patch c8c72b74e289: "ath6kl: move ath6kl_wmi_startscan_cmd()" 
> from Jul 19, 2012, leads to the following warning:
> drivers/net/wireless/ath/ath6kl/wmi.c:2016 ath6kl_wmi_beginscan_cmd()
> 	 error: buffer overflow 'sc->supp_rates' 2 <= 2
> 
> drivers/net/wireless/ath/ath6kl/wmi.c
> 
>   2009          for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
>                                       ^^^^^^^^^^^^^^^^^^^
> This is 3.
> 
>   2010                  sband = ar->wiphy->bands[band];
>   2011  
>   2012                  if (!sband)
>   2013                          continue;
>   2014  
>   2015                  ratemask = rates[band];
>   2016                  supp_rates = sc->supp_rates[band].rates;
> 
> ->supp_rates has only ATH6KL_NUM_BANDS (2) elements so we are reading
> one element beyond the end.
> 
>   2017                  num_rates = 0;
> 
> regards,
> dan carpenter
