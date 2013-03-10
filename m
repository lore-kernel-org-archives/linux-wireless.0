Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20539 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab3CJF4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Mar 2013 00:56:40 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Subject: Re: ath6kl: move ath6kl_wmi_startscan_cmd()
References: <20121127072531.GB8239@elgon.mountain>
Date: Sun, 10 Mar 2013 07:56:34 +0200
In-Reply-To: <20121127072531.GB8239@elgon.mountain> (Dan Carpenter's message
	of "Tue, 27 Nov 2012 10:25:32 +0300")
Message-ID: <87620zlrvx.fsf@kamboji.qca.qualcomm.com> (sfid-20130310_065643_713729_2C7E9F23)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:

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

This shouldn't happen as only the first two bands are set in
ar->wiphy->bands so the 'if (!sband)' will cover rest of the bands. But
I want to be careful and I sent a patch which adds an extra check there.

-- 
Kalle Valo
