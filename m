Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:54591 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750821AbeEEJpb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 May 2018 05:45:31 -0400
Subject: Re: [PATCH 2/2] ath10k: DFS Host Confirmation
To: Kalle Valo <kvalo@codeaurora.org>,
        Peter Oh <peter.oh@bowerswilkins.com>
Cc: Sriram R <srirrama@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
References: <1525110339-25326-1-git-send-email-srirrama@codeaurora.org>
 <1525110339-25326-3-git-send-email-srirrama@codeaurora.org>
 <0c224b54-dd10-576f-944f-2d20d1cb2c46@bowerswilkins.com>
 <87d0ye2t75.fsf@kamboji.qca.qualcomm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <3f762586-a757-636c-2eb4-3fa3e193b3dd@dd-wrt.com> (sfid-20180505_114535_935633_BF93CE2A)
Date: Sat, 5 May 2018 11:45:28 +0200
MIME-Version: 1.0
In-Reply-To: <87d0ye2t75.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 02.05.2018 um 13:27 schrieb Kalle Valo:
> Peter Oh <peter.oh@bowerswilkins.com> writes:
>
>> On 04/30/2018 10:45 AM, Sriram R wrote:
>>> In the 10.4-3.6 firmware branch there's a new DFS Host confirmation
>>> feature which is advertised using WMI_SERVICE_HOST_DFS_CHECK_SUPPORT flag.
>>>
>>> This new features enables the ath10k host to send information to the
>>> firmware on the specifications of detected radar type. This allows the
>>> firmware to validate if the host's radar pattern detector unit is
>>> operational and check if the radar information shared by host matches
>>> the radar pulses sent as phy error events from firmware. If the check
>>> fails the firmware won't allow use of DFS channels on AP mode when using
>>> FCC regulatory region.
>> What's the main reason you introduce this feature?
>> What are you trying to solve with this change?
> Otherwise one cannot use DFS channels on FCC regions with a firmware
> from 10.4-3.6 branch.
>
>>> @@ -3765,25 +3834,46 @@ static void ath10k_dfs_radar_report(struct ath10k *ar,
>>>      	ATH10K_DFS_STAT_INC(ar, pulses_detected);
>>>    -	if (!ar->dfs_detector->add_pulse(ar->dfs_detector, &pe, NULL))
>>> {
>>> +	if (!ar->dfs_detector->add_pulse(ar->dfs_detector, &pe, &rs)) {
>>>    		ath10k_dbg(ar, ATH10K_DBG_REGULATORY,
>>>    			   "dfs no pulse pattern detected, yet\n");
>>>    		return;
>>>    	}
>>>    -radar_detected:
>>> -	ath10k_dbg(ar, ATH10K_DBG_REGULATORY, "dfs radar detected\n");
>>> -	ATH10K_DFS_STAT_INC(ar, radar_detected);
>>> +	if ((test_bit(WMI_SERVICE_HOST_DFS_CHECK_SUPPORT, ar->wmi.svc_map)) &&
>>> +	    ar->dfs_detector->region == NL80211_DFS_FCC) {
>> I feel risky that host drivers have no way to control this new feature
>> and totally rely on FW feature mask. We should have a host drivers'
>> feature mask such as module param and set it false (don't use) by
>> default until it proves safe to use.
> This is for regulatory enforcement so it's not possible to disable the
> feature from host.
mmh from what i see it is possible to disable it from host since the 
firmware seem to be sensitive on the regdomain set by the host
so if host sets anything else than a FCC regdomain, it will still work 
in the old way. so its more a pseudo enforcement. dont know if this is
usefull and it also will it make impossible to fix radar detection 
issues for certification as mentioned by peter and adrian.

Sebastian
>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
