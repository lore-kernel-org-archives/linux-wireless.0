Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f44.google.com ([209.85.213.44]:49577 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaDXJTL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 05:19:11 -0400
Received: by mail-yh0-f44.google.com with SMTP id f10so1966707yha.31
        for <linux-wireless@vger.kernel.org>; Thu, 24 Apr 2014 02:19:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <878uqvm7yz.fsf@kamboji.qca.qualcomm.com>
References: <1398327250-12923-1-git-send-email-yeohchunyeow@gmail.com>
	<87d2g7m90w.fsf@kamboji.qca.qualcomm.com>
	<CAEFj986h0FtMOpbTbYYQzLxZrEcL_og0+qpQkfj36xMWM9LG5g@mail.gmail.com>
	<878uqvm7yz.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 24 Apr 2014 17:19:10 +0800
Message-ID: <CAEFj986VVHkgSnv=xGo_WAYg+n4Sp0_qJGkpmzjNk9thoizZCA@mail.gmail.com> (sfid-20140424_111920_683676_2E15DB2C)
Subject: Re: [PATCH] ath10k: don't allow stand alone monitor mode for non-AP firmware
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 24, 2014 at 4:45 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Yeoh Chun-Yeow <yeohchunyeow@gmail.com> writes:
>
>>>> +     if (ar->fw_version_build == 636) {
>>>
>>> Checking for firmware version in ath10k is a big no. For a functinality
>>> change like this you should add a new feature flag to enum
>>> ath10k_fw_features (and I need to then recreate the firmware image).
>>>
>> Should we just use the ATH10K_FW_FEATURE_WMI_10X?
>
> That's a bit dangerous if in the future there's a new firmware which
> doesn't have ATH10K_FW_FEATURE_WMI_10X but still doesn't support stand
> alone monitor mode.
>

Then, we may need to introduce the new feature flag.

But then I just wondering if the firmware 636 claimed to support STA
mode "well" but then not allowed to be bridged. This may cause
confusion to end user which is the best firmware for STA mode. FYI, AP
firmware has no such issue if using as STA mode and put into
promiscuous mode.

----
Chun-Yeow
