Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50116 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbeENSKS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 14:10:18 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Peter Oh <peter.oh@bowerswilkins.com>
Cc: linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>,
        ath10k@lists.infradead.org
Subject: Re: [PATCH 2/2] ath10k: DFS Host Confirmation
References: <1525110339-25326-1-git-send-email-srirrama@codeaurora.org>
        <1525110339-25326-3-git-send-email-srirrama@codeaurora.org>
        <0c224b54-dd10-576f-944f-2d20d1cb2c46@bowerswilkins.com>
        <87d0ye2t75.fsf@kamboji.qca.qualcomm.com>
        <4c3ae0c5-0b26-3be9-ccad-ea71b325d5ad@bowerswilkins.com>
Date: Mon, 14 May 2018 21:10:12 +0300
Message-ID: <87lgcmqfaz.fsf@kamboji.qca.qualcomm.com> (sfid-20180514_201022_867761_B547884D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <peter.oh@bowerswilkins.com> writes:

> On 05/02/2018 04:27 AM, Kalle Valo wrote:
>> Peter Oh <peter.oh@bowerswilkins.com> writes:
>>
>>> On 04/30/2018 10:45 AM, Sriram R wrote:
>>>> In the 10.4-3.6 firmware branch there's a new DFS Host confirmation
>>>> feature which is advertised using WMI_SERVICE_HOST_DFS_CHECK_SUPPORT flag.
>>>>
>>>> This new features enables the ath10k host to send information to the
>>>> firmware on the specifications of detected radar type. This allows the
>>>> firmware to validate if the host's radar pattern detector unit is
>>>> operational and check if the radar information shared by host matches
>>>> the radar pulses sent as phy error events from firmware. If the check
>>>> fails the firmware won't allow use of DFS channels on AP mode when using
>>>> FCC regulatory region.
>>> What's the main reason you introduce this feature?
>>> What are you trying to solve with this change?
>> Otherwise one cannot use DFS channels on FCC regions with a firmware
>> from 10.4-3.6 branch.
>
> It's a big change and none of us knows until I asked and you answered.

I was hoping that would be clear from the commit log but I guess Sriram
could include my sentence above to enhance it?

>>>> @@ -3765,25 +3834,46 @@ static void ath10k_dfs_radar_report(struct ath10k *ar,
>>>>      	ATH10K_DFS_STAT_INC(ar, pulses_detected);
>>>>    -	if (!ar->dfs_detector->add_pulse(ar->dfs_detector, &pe, NULL))
>>>> {
>>>> +	if (!ar->dfs_detector->add_pulse(ar->dfs_detector, &pe, &rs)) {
>>>>    		ath10k_dbg(ar, ATH10K_DBG_REGULATORY,
>>>>    			   "dfs no pulse pattern detected, yet\n");
>>>>    		return;
>>>>    	}
>>>>    -radar_detected:
>>>> -	ath10k_dbg(ar, ATH10K_DBG_REGULATORY, "dfs radar detected\n");
>>>> -	ATH10K_DFS_STAT_INC(ar, radar_detected);
>>>> +	if ((test_bit(WMI_SERVICE_HOST_DFS_CHECK_SUPPORT, ar->wmi.svc_map)) &&
>>>> +	    ar->dfs_detector->region == NL80211_DFS_FCC) {
>>>
>>> I feel risky that host drivers have no way to control this new feature
>>> and totally rely on FW feature mask. We should have a host drivers'
>>> feature mask such as module param and set it false (don't use) by
>>> default until it proves safe to use.
>>
>> This is for regulatory enforcement so it's not possible to disable the
>> feature from host.
>
> Which regulatory enforcement are you talking to? Are you talking about
> such "prevent users from changing regulatory domain" or "don't provide
> a manner to change regulatory domain or channel list" ? If not, can
> you share the section of document?

Sorry, I don't have any references about that.

> In addition to that, How do you make sure if FW side DFS radar
> detection algorithm has no defects and it always categorizes phy
> errors to correct radar type? I'm asking it, because it's known that
> DFS detector in ath module does sometimes detect radar patterns as
> wrong radar type in both of ath10k and ath9k. I couldn't think FW side
> detector has no such defects at all. It's like blind patch to open
> source community, since no one can review the implementation in FW
> even though no one can guarantee its level of integrity.

It's not about replacing the DFS detector in ath.ko, it's about adding
extra checks in firmware for regulatory compliance. So at least in
theory DFS detection should still work same as before, just with an
extra roundtrip via firmware.

-- 
Kalle Valo
