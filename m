Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:45063 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750980AbeDMVNe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 17:13:34 -0400
Received: by mail-wr0-f175.google.com with SMTP id u11so11313624wri.12
        for <linux-wireless@vger.kernel.org>; Fri, 13 Apr 2018 14:13:34 -0700 (PDT)
Subject: Re: [PATCH 2/2] ath10k: support MAC address randomization in scan
To: Kalle Valo <kvalo@codeaurora.org>, cjhuang@codeaurora.org
References: <1522379640-6442-1-git-send-email-cjhuang@codeaurora.org>
 <1522379640-6442-3-git-send-email-cjhuang@codeaurora.org>
 <20180412205954.GA34456@rodete-desktop-imager.corp.google.com>
 <e16557d0891352ae0b83902faee97023@codeaurora.org>
 <877epbs5v7.fsf@kamboji.qca.qualcomm.com>
Cc: Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AD11D7C.1030603@broadcom.com> (sfid-20180413_231338_263700_C7C5007B)
Date: Fri, 13 Apr 2018 23:13:32 +0200
MIME-Version: 1.0
In-Reply-To: <877epbs5v7.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/13/2018 1:28 PM, Kalle Valo wrote:
> cjhuang@codeaurora.org writes:
>
>>>> +	if (test_bit(WMI_SERVICE_SPOOF_MAC_SUPPORT, ar->wmi.svc_map)) {
>>>> +		ret = ath10k_wmi_scan_prob_req_oui(ar, ar->mac_addr);
>>>> +		if (ret) {
>>>> +			ath10k_err(ar, "failed to set prob req oui: %i\n", ret);
>>>> +			goto err_dfs_detector_exit;
>>>> +		}
>>>> +
>>>> +		ar->hw->wiphy->features |=
>>>> +			NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
>>>
>>> Do you support NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR too?
>>
>> I'll add this flag too.
>
> Are you going to send v2 or what's the plan?

Maybe a stupid question, but does ath10k support scheduled scan?

Regards,
Arend
