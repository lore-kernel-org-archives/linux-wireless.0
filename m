Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57652 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754589AbeDML2R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 07:28:17 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: cjhuang@codeaurora.org
Cc: Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 2/2] ath10k: support MAC address randomization in scan
References: <1522379640-6442-1-git-send-email-cjhuang@codeaurora.org>
        <1522379640-6442-3-git-send-email-cjhuang@codeaurora.org>
        <20180412205954.GA34456@rodete-desktop-imager.corp.google.com>
        <e16557d0891352ae0b83902faee97023@codeaurora.org>
Date: Fri, 13 Apr 2018 14:28:12 +0300
In-Reply-To: <e16557d0891352ae0b83902faee97023@codeaurora.org>
        (cjhuang@codeaurora.org's message of "Fri, 13 Apr 2018 14:53:25
        +0800")
Message-ID: <877epbs5v7.fsf@kamboji.qca.qualcomm.com> (sfid-20180413_132823_718501_A9F8CAE3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cjhuang@codeaurora.org writes:

>>> +	if (test_bit(WMI_SERVICE_SPOOF_MAC_SUPPORT, ar->wmi.svc_map)) {
>>> +		ret = ath10k_wmi_scan_prob_req_oui(ar, ar->mac_addr);
>>> +		if (ret) {
>>> +			ath10k_err(ar, "failed to set prob req oui: %i\n", ret);
>>> +			goto err_dfs_detector_exit;
>>> +		}
>>> +
>>> +		ar->hw->wiphy->features |=
>>> +			NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
>>
>> Do you support NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR too?
>
> I'll add this flag too.

Are you going to send v2 or what's the plan?

-- 
Kalle Valo
