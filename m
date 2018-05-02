Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33086 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750939AbeEBL1r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 07:27:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Peter Oh <peter.oh@bowerswilkins.com>
Cc: Sriram R <srirrama@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath10k: DFS Host Confirmation
References: <1525110339-25326-1-git-send-email-srirrama@codeaurora.org>
        <1525110339-25326-3-git-send-email-srirrama@codeaurora.org>
        <0c224b54-dd10-576f-944f-2d20d1cb2c46@bowerswilkins.com>
Date: Wed, 02 May 2018 14:27:42 +0300
In-Reply-To: <0c224b54-dd10-576f-944f-2d20d1cb2c46@bowerswilkins.com> (Peter
        Oh's message of "Mon, 30 Apr 2018 12:50:40 -0700")
Message-ID: <87d0ye2t75.fsf@kamboji.qca.qualcomm.com> (sfid-20180502_132751_802952_2A3A5319)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <peter.oh@bowerswilkins.com> writes:

> On 04/30/2018 10:45 AM, Sriram R wrote:
>> In the 10.4-3.6 firmware branch there's a new DFS Host confirmation
>> feature which is advertised using WMI_SERVICE_HOST_DFS_CHECK_SUPPORT flag.
>>
>> This new features enables the ath10k host to send information to the
>> firmware on the specifications of detected radar type. This allows the
>> firmware to validate if the host's radar pattern detector unit is
>> operational and check if the radar information shared by host matches
>> the radar pulses sent as phy error events from firmware. If the check
>> fails the firmware won't allow use of DFS channels on AP mode when using
>> FCC regulatory region.
>
> What's the main reason you introduce this feature?
> What are you trying to solve with this change?

Otherwise one cannot use DFS channels on FCC regions with a firmware
from 10.4-3.6 branch.

>> @@ -3765,25 +3834,46 @@ static void ath10k_dfs_radar_report(struct ath10k *ar,
>>     	ATH10K_DFS_STAT_INC(ar, pulses_detected);
>>   -	if (!ar->dfs_detector->add_pulse(ar->dfs_detector, &pe, NULL))
>> {
>> +	if (!ar->dfs_detector->add_pulse(ar->dfs_detector, &pe, &rs)) {
>>   		ath10k_dbg(ar, ATH10K_DBG_REGULATORY,
>>   			   "dfs no pulse pattern detected, yet\n");
>>   		return;
>>   	}
>>   -radar_detected:
>> -	ath10k_dbg(ar, ATH10K_DBG_REGULATORY, "dfs radar detected\n");
>> -	ATH10K_DFS_STAT_INC(ar, radar_detected);
>> +	if ((test_bit(WMI_SERVICE_HOST_DFS_CHECK_SUPPORT, ar->wmi.svc_map)) &&
>> +	    ar->dfs_detector->region == NL80211_DFS_FCC) {
>
> I feel risky that host drivers have no way to control this new feature
> and totally rely on FW feature mask. We should have a host drivers'
> feature mask such as module param and set it false (don't use) by
> default until it proves safe to use.

This is for regulatory enforcement so it's not possible to disable the
feature from host.

-- 
Kalle Valo
