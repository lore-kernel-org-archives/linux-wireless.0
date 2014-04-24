Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41401 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbaDXJqp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 05:46:45 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: don't allow stand alone monitor mode for non-AP firmware
References: <1398327250-12923-1-git-send-email-yeohchunyeow@gmail.com>
	<87d2g7m90w.fsf@kamboji.qca.qualcomm.com>
	<CAEFj986h0FtMOpbTbYYQzLxZrEcL_og0+qpQkfj36xMWM9LG5g@mail.gmail.com>
	<878uqvm7yz.fsf@kamboji.qca.qualcomm.com>
	<CAEFj986VVHkgSnv=xGo_WAYg+n4Sp0_qJGkpmzjNk9thoizZCA@mail.gmail.com>
Date: Thu, 24 Apr 2014 12:46:36 +0300
In-Reply-To: <CAEFj986VVHkgSnv=xGo_WAYg+n4Sp0_qJGkpmzjNk9thoizZCA@mail.gmail.com>
	(Yeoh Chun-Yeow's message of "Thu, 24 Apr 2014 17:19:10 +0800")
Message-ID: <874n1jm54z.fsf@kamboji.qca.qualcomm.com> (sfid-20140424_114727_624293_B9215CFD)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yeoh Chun-Yeow <yeohchunyeow@gmail.com> writes:

> On Thu, Apr 24, 2014 at 4:45 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Yeoh Chun-Yeow <yeohchunyeow@gmail.com> writes:
>>
>>>>> +     if (ar->fw_version_build == 636) {
>>>>
>>>> Checking for firmware version in ath10k is a big no. For a functinality
>>>> change like this you should add a new feature flag to enum
>>>> ath10k_fw_features (and I need to then recreate the firmware image).
>>>>
>>> Should we just use the ATH10K_FW_FEATURE_WMI_10X?
>>
>> That's a bit dangerous if in the future there's a new firmware which
>> doesn't have ATH10K_FW_FEATURE_WMI_10X but still doesn't support stand
>> alone monitor mode.
>
> Then, we may need to introduce the new feature flag.

And that will create other problems. It's better to bite the bullet now
than trying to postpone it. Besides, adding the feature flag is trivial.

> But then I just wondering if the firmware 636 claimed to support STA
> mode "well" but then not allowed to be bridged. This may cause
> confusion to end user which is the best firmware for STA mode. FYI, AP
> firmware has no such issue if using as STA mode and put into
> promiscuous mode.

Yeah, maybe should change the documentation to recommend using 10.1
branch for AP, STA and monitor modes? And recommended main branch only
for Ad-Hoc and P2P?

-- 
Kalle Valo
