Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34402 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbeDMGx0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 02:53:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 13 Apr 2018 14:53:25 +0800
From: cjhuang@codeaurora.org
To: Brian Norris <briannorris@chromium.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath10k: support MAC address randomization in scan
In-Reply-To: <20180412205954.GA34456@rodete-desktop-imager.corp.google.com>
References: <1522379640-6442-1-git-send-email-cjhuang@codeaurora.org>
 <1522379640-6442-3-git-send-email-cjhuang@codeaurora.org>
 <20180412205954.GA34456@rodete-desktop-imager.corp.google.com>
Message-ID: <e16557d0891352ae0b83902faee97023@codeaurora.org> (sfid-20180413_085329_948918_7C126CE5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-04-13 04:59, Brian Norris wrote:
> Hi Carl,
> 
> On Fri, Mar 30, 2018 at 11:14:00AM +0800, Carl Huang wrote:
>> The ath10k reports the random_mac_addr capability to upper layer
>> based on the service bit firmware reported. Driver sets the
>> spoofed flag in scan_ctrl_flag to firmware if upper layer has
>> enabled this feature in scan request.
>> 
>> Test with QCA6174 hw3.0 and 
>> firmware-6.bin_WLAN.RM.4.4.1-00102-QCARMSWP-1,
>> but QCA9377 is also affected.
>> 
>> Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
>> ---
>>  drivers/net/wireless/ath/ath10k/mac.c     | 17 +++++++++++++++++
>>  drivers/net/wireless/ath/ath10k/wmi-ops.h | 22 ++++++++++++++++++++++
>>  drivers/net/wireless/ath/ath10k/wmi-tlv.c | 25 
>> +++++++++++++++++++++++++
>>  drivers/net/wireless/ath/ath10k/wmi-tlv.h | 11 +++++++++++
>>  drivers/net/wireless/ath/ath10k/wmi.c     |  5 +++++
>>  drivers/net/wireless/ath/ath10k/wmi.h     |  9 +++++++++
>>  6 files changed, 89 insertions(+)
>> 
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c 
>> b/drivers/net/wireless/ath/ath10k/mac.c
>> index ebb3f1b..c5cd5e5 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -5699,6 +5699,12 @@ static int ath10k_hw_scan(struct ieee80211_hw 
>> *hw,
>>  		arg.scan_ctrl_flags |= WMI_SCAN_FLAG_PASSIVE;
>>  	}
>> 
>> +	if (req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
>> +		arg.scan_ctrl_flags |=  WMI_SCAN_ADD_SPOOFED_MAC_IN_PROBE_REQ;
>> +		ether_addr_copy(arg.mac_addr.addr, req->mac_addr);
>> +		ether_addr_copy(arg.mac_mask.addr, req->mac_addr_mask);
>> +	}
>> +
>>  	if (req->n_channels) {
>>  		arg.n_channels = req->n_channels;
>>  		for (i = 0; i < arg.n_channels; i++)
>> @@ -8397,6 +8403,17 @@ int ath10k_mac_register(struct ath10k *ar)
>>  		goto err_dfs_detector_exit;
>>  	}
>> 
>> +	if (test_bit(WMI_SERVICE_SPOOF_MAC_SUPPORT, ar->wmi.svc_map)) {
>> +		ret = ath10k_wmi_scan_prob_req_oui(ar, ar->mac_addr);
>> +		if (ret) {
>> +			ath10k_err(ar, "failed to set prob req oui: %i\n", ret);
>> +			goto err_dfs_detector_exit;
>> +		}
>> +
>> +		ar->hw->wiphy->features |=
>> +			NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
> 
> Do you support NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR too?

I'll add this flag too.

> 
>> +	}
>> +
> 
> 
> Brian
