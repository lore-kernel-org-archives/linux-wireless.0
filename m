Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:43126 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaJGIoo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 04:44:44 -0400
Received: by mail-wg0-f43.google.com with SMTP id m15so8538054wgh.26
        for <linux-wireless@vger.kernel.org>; Tue, 07 Oct 2014 01:44:43 -0700 (PDT)
Date: Tue, 7 Oct 2014 10:44:27 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, nbd@nbd.name, ikstream86@gmail.com
Subject: Re: [PATCH v2 2/2] mac80211: improve minstrel_ht rate sorting by
 throughput & probability
Message-ID: <20141007084427.GA9964@magnum.frso.rivierawaves.com> (sfid-20141007_104448_742732_CA5D1D65)
References: <1410297734-21187-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
 <1410297734-21187-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1410297734-21187-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Sep 09, 2014 at 11:22:14PM +0200, Thomas Huehn wrote:
> @@ -260,13 +399,14 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
>  	mi->sample_slow = 0;
>  	mi->sample_count = 0;
>  
> -	for (group = 0; group < ARRAY_SIZE(minstrel_mcs_groups); group++) {
> -		bool mg_rates_valid = false;
> +	/* Initialize global rate indexes */
> +	for(j = 0; j < MAX_THR_RATES; j++){
> +		tmp_mcs_tp_rate[j] = 0;
> +		tmp_cck_tp_rate[j] = 0;
> +	}
>  

Pb if a driver doesn't support the first entry it. 
Maybe using a mi->min_ridx set in minstrel_ht_update_caps would be
practical.

> @@ -274,24 +414,16 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
>  
>  		mi->sample_count++;
>  
> +		/* (re)Initialize group rate indexes */
> +		for(j = 0; j < MAX_THR_RATES; j++)
> +			tmp_group_tp_rate[j] = group;
> +

You meant group * MCS_GROUP_RATES, no ?
And group * MCS_GROUP_RATES + ffs(mg->supported) - 1 would be correct
but this corner case is not easily triggerable, ATM.

-- 
Karl
