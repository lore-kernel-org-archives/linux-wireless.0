Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:17486 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaDXIpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 04:45:36 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: don't allow stand alone monitor mode for non-AP firmware
References: <1398327250-12923-1-git-send-email-yeohchunyeow@gmail.com>
	<87d2g7m90w.fsf@kamboji.qca.qualcomm.com>
	<CAEFj986h0FtMOpbTbYYQzLxZrEcL_og0+qpQkfj36xMWM9LG5g@mail.gmail.com>
Date: Thu, 24 Apr 2014 11:45:24 +0300
In-Reply-To: <CAEFj986h0FtMOpbTbYYQzLxZrEcL_og0+qpQkfj36xMWM9LG5g@mail.gmail.com>
	(Yeoh Chun-Yeow's message of "Thu, 24 Apr 2014 16:40:24 +0800")
Message-ID: <878uqvm7yz.fsf@kamboji.qca.qualcomm.com> (sfid-20140424_104542_428786_A5817656)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yeoh Chun-Yeow <yeohchunyeow@gmail.com> writes:

>>> +     if (ar->fw_version_build == 636) {
>>
>> Checking for firmware version in ath10k is a big no. For a functinality
>> change like this you should add a new feature flag to enum
>> ath10k_fw_features (and I need to then recreate the firmware image).
>>
> Should we just use the ATH10K_FW_FEATURE_WMI_10X?

That's a bit dangerous if in the future there's a new firmware which
doesn't have ATH10K_FW_FEATURE_WMI_10X but still doesn't support stand
alone monitor mode.

-- 
Kalle Valo
