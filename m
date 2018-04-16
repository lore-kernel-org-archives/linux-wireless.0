Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44334 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750946AbeDPLc6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 07:32:58 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: cjhuang@codeaurora.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 2/2] ath10k: support MAC address randomization in scan
References: <1522379640-6442-1-git-send-email-cjhuang@codeaurora.org>
        <1522379640-6442-3-git-send-email-cjhuang@codeaurora.org>
        <20180412205954.GA34456@rodete-desktop-imager.corp.google.com>
        <e16557d0891352ae0b83902faee97023@codeaurora.org>
        <877epbs5v7.fsf@kamboji.qca.qualcomm.com>
        <5AD11D7C.1030603@broadcom.com>
        <242be71eb87140c9560163c4000255b2@codeaurora.org>
Date: Mon, 16 Apr 2018 14:32:47 +0300
In-Reply-To: <242be71eb87140c9560163c4000255b2@codeaurora.org>
        (cjhuang@codeaurora.org's message of "Mon, 16 Apr 2018 13:16:10
        +0800")
Message-ID: <8736zvqtcw.fsf@kamboji.qca.qualcomm.com> (sfid-20180416_133303_777382_9235A19F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cjhuang@codeaurora.org writes:

> On 2018-04-14 05:13, Arend van Spriel wrote:
>> On 4/13/2018 1:28 PM, Kalle Valo wrote:
>>> cjhuang@codeaurora.org writes:
>>>
>>>>>> +	if (test_bit(WMI_SERVICE_SPOOF_MAC_SUPPORT, ar->wmi.svc_map)) {
>>>>>> +		ret = ath10k_wmi_scan_prob_req_oui(ar, ar->mac_addr);
>>>>>> +		if (ret) {
>>>>>> +			ath10k_err(ar, "failed to set prob req oui: %i\n", ret);
>>>>>> +			goto err_dfs_detector_exit;
>>>>>> +		}
>>>>>> +
>>>>>> +		ar->hw->wiphy->features |=
>>>>>> +			NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
>>>>>
>>>>> Do you support NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR too?
>>>>
>>>> I'll add this flag too.
>>>
>>> Are you going to send v2 or what's the plan?
>>
>> Maybe a stupid question, but does ath10k support scheduled scan?

AFAICS ath10k does not support it (sched_scan_start() op).

> The reason is AVL test case needs this flag to enable random mac
> address scan. Maybe Brian Can explain why this flag is necessary.

If ath10k does not support scheduled scan what's the point? Shouldn't
the test case then be it fixed instead of making hacks in ath10k?

-- 
Kalle Valo
