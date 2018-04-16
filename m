Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59132 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750732AbeDPFQL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 01:16:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 16 Apr 2018 13:16:10 +0800
From: cjhuang@codeaurora.org
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 2/2] ath10k: support MAC address randomization in scan
In-Reply-To: <5AD11D7C.1030603@broadcom.com>
References: <1522379640-6442-1-git-send-email-cjhuang@codeaurora.org>
 <1522379640-6442-3-git-send-email-cjhuang@codeaurora.org>
 <20180412205954.GA34456@rodete-desktop-imager.corp.google.com>
 <e16557d0891352ae0b83902faee97023@codeaurora.org>
 <877epbs5v7.fsf@kamboji.qca.qualcomm.com> <5AD11D7C.1030603@broadcom.com>
Message-ID: <242be71eb87140c9560163c4000255b2@codeaurora.org> (sfid-20180416_071615_467681_2CF976B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-04-14 05:13, Arend van Spriel wrote:
> On 4/13/2018 1:28 PM, Kalle Valo wrote:
>> cjhuang@codeaurora.org writes:
>> 
>>>>> +	if (test_bit(WMI_SERVICE_SPOOF_MAC_SUPPORT, ar->wmi.svc_map)) {
>>>>> +		ret = ath10k_wmi_scan_prob_req_oui(ar, ar->mac_addr);
>>>>> +		if (ret) {
>>>>> +			ath10k_err(ar, "failed to set prob req oui: %i\n", ret);
>>>>> +			goto err_dfs_detector_exit;
>>>>> +		}
>>>>> +
>>>>> +		ar->hw->wiphy->features |=
>>>>> +			NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
>>>> 
>>>> Do you support NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR too?
>>> 
>>> I'll add this flag too.
>> 
>> Are you going to send v2 or what's the plan?
> 
> Maybe a stupid question, but does ath10k support scheduled scan?
> 
The reason is AVL test case needs this flag to enable random mac address 
scan. Maybe Brian
Can explain why this flag is necessary.

Thanks,
Carl
