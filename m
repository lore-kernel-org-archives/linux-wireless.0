Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43444 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750738AbeDQFKv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 01:10:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 16 Apr 2018 22:10:50 -0700
From: pradeepc@codeaurora.org
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k:add support for multicast rate control
Message-ID: <fe1af65b1042bc3c2b551dcbe7d53f3c@codeaurora.org> (sfid-20180417_071055_344458_911E0F27)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-04-12 01:00, Sven Eckelmann wrote:
> On Mittwoch, 11. April 2018 21:04:46 CEST Pradeep Kumar Chitrapu wrote:
>> Issues wmi command to firmware when multicast rate change is received
>> with the new BSS_CHANGED_MCAST_RATE flag.
> [...]
>> 
>> +	if (changed & BSS_CHANGED_MCAST_RATE &&
>> +	    !WARN_ON(ath10k_mac_vif_chan(arvif->vif, &def))) {
>> +		band = def.chan->band;
>> +		sband = &ar->mac.sbands[band];
>> +		vdev_param = ar->wmi.vdev_param->mcast_data_rate;
>> +		rate_index = vif->bss_conf.mcast_rate[band] - 1;
>> +		rate = ATH10K_HW_MCS_RATE(sband->bitrates[rate_index].hw_value);
>> +		ath10k_dbg(ar, ATH10K_DBG_MAC,
>> +			   "mac vdev %d mcast_rate %d\n",
>> +			   arvif->vdev_id, rate);
>> +
>> +		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
>> +						vdev_param, rate);
>> +		if (ret)
>> +			ath10k_warn(ar,
>> +				    "failed to set mcast rate on vdev"
>> +				    " %i: %d\n", arvif->vdev_id,  ret);
>> +	}
>> +
>>  	mutex_unlock(&ar->conf_mutex);
>>  }
>> 
>> 
> 
> I see two major problems here without checking the actual 
> implementation
> details:
> 
> * hw_value is incorrect for a couple of devices. Some devices use a 
> different
>   mapping when they receive rates inforamtion (hw_value) then the ones 
> you use
>   for the mcast/bcast/beacon rate setting. I've handled in my POC patch 
> like
>   this:
> 
>     +		if (ath10k_mac_bitrate_is_cck(sband->bitrates[i].bitrate)) {
>     +			preamble = WMI_RATE_PREAMBLE_CCK;
>     +
>     +			/* QCA didn't use the correct rate values for CA99x0
>     +			 * and above (ath10k_g_rates_rev2)
>     +			 */
>     +			switch (sband->bitrates[i].bitrate) {
>     +			case 10:
>     +				hw_value = ATH10K_HW_RATE_CCK_LP_1M;
>     +				break;
>     +			case 20:
>     +				hw_value = ATH10K_HW_RATE_CCK_LP_2M;
>     +				break;
>     +			case 55:
>     +				hw_value = ATH10K_HW_RATE_CCK_LP_5_5M;
>     +				break;
>     +			case 110:
>     +				hw_value = ATH10K_HW_RATE_CCK_LP_11M;
>     +				break;
>     +			}
>     +		} else {
>     +			preamble = WMI_RATE_PREAMBLE_OFDM;
>     +		}
> 

Isn't this already fixed in https://patchwork.kernel.org/patch/9150145/ 
?

> * bcast + mcast (+ mgmt) have to be set separately

Can you please let me know why this would be necessary?
Although I see minstrel rate control is currently seems using the 
mcast_rate
setting to set MGMT/BCAST/MCAST rates, will this not be misleading to 
user
passed value with 'iw set mcast_rate' for MGMT traffic as well?

> 
> I have attached my POC patch (which I was using for packet loss based 
> mesh
> metrics) and to work around (using debugfs) the silly mgmt vs. 
> mcast/bcast
> settings of the QCA fw for APs.
> 
> Many of the information came from Ben Greears ath10k-ct driver
> https://github.com/greearb/ath10k-ct
> 
> Kind regards,
> 	Sven
