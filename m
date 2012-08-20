Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33405 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab2HTHEg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 03:04:36 -0400
Message-ID: <5031E17F.9030504@qca.qualcomm.com> (sfid-20120820_090440_236355_9AFBA28B)
Date: Mon, 20 Aug 2012 10:04:31 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: rework scheduled scan
References: <1345074684-4662-1-git-send-email-c_tpeder@qca.qualcomm.com> <5031DEC2.9020103@qca.qualcomm.com>
In-Reply-To: <5031DEC2.9020103@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/20/2012 09:52 AM, Kalle Valo wrote:
> On 08/16/2012 02:51 AM, Thomas Pedersen wrote:
>> This patch reflects changes in the firmware scheduled scan
>> implementation to behave better in cases with multiple concurrent vifs.
>> Major changes:
>>
>> 	- scheduled scan filters and state are now programmed per-vif.
>> 	- decouple scheduled scan from host sleep.
>>
>> To maintain graceful failure with old firmwares, a new firmware
>> capability bit is introduced: ATH6KL_FW_CAPABILITY_SCHED_SCAN_V2.
>> ath6kl simply won't advertise scheduled scan to cfg80211 if the
>> SCHED_SCAN_V2 is not supported.
>>
>> Since firmwares from here on out won't support the previous implicit API
>> for scheduled scan (set WoW filters and host sleep), bump the firmware
>> API to protect old drivers.
> 
> Patch looks good but it doesn't apply. Can you rebase and resend, please?

Heh, yet another monday morning screw up. I was applying a wrong patch,
no wonder it didn't apply :)

Kalle
