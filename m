Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26100 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbcEZRcg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2016 13:32:36 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Sven Eckelmann <sven.eckelmann@open-mesh.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] ath10k: Add support for QCA9887
Date: Thu, 26 May 2016 17:32:30 +0000
Message-ID: <87mvnc67yq.fsf@kamboji.qca.qualcomm.com> (sfid-20160526_193240_336501_4CF501D0)
References: <1568876.Six5hABE57@bentobox>
In-Reply-To: <1568876.Six5hABE57@bentobox> (Sven Eckelmann's message of "Fri,
	20 May 2016 16:40:46 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven.eckelmann@open-mesh.com> writes:

> the QCA9887 chip is similar to the QCA988x chips. But it requires a special
> firmware and uses a different calibration data source. Unfortunately, no
> working firmware currently exists. But it is possible to create a semi working
> one by binary patching the current version.

So what works and what doesn't?

>     # download new fw + set ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX+ATH10K_FW_FEATURE_NO_P2P
>     curl -o firmware-5.bin https://raw.githubusercontent.com/kvalo/ath10k-firmware/master/QCA9887/firmware-5.bin_10.2.3.31.7-1
>     echo -en '\x0c'|dd conv=notrunc bs=1 seek=231112 of=firmware-5.bin
>     mkdir -p /lib/firmware/ath10k/QCA9887/hw1.0/
>     mv firmware-5.bin /lib/firmware/ath10k/QCA9887/hw1.0/firmware-5.bin
>
> I am also guessing that ATH10K_FW_FEATURE_SUPPORTS_SKIP_CLOCK_INIT should
> also be set but this would require a ie_len of 2.

I can upload a new version. So I need to add these flags:

ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX
ATH10K_FW_FEATURE_NO_P2P
ATH10K_FW_FEATURE_SUPPORTS_SKIP_CLOCK_INIT

Anything else?

> The QCA9887 support should be considered really experimental because we don't
> have any information how the interface to firmware actually looks like. The
> workarounds mentioned above were just implemented because we saw the firmware
> crashing and then guessed the most plausible reason for it.

Should we add a warning message to ath10k that the QCA9887 support is
experimental? That way users don't need to wonder why there are so many
problems.

There were some conflicts in patch 1. I fixed those now and pushed the
patches to the pending branch for further testing:

https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/log/?h=master-pending

Unfortunately I don't have QCA9887 myself so I can't test these myself.
I hope I didn't break anything.

-- 
Kalle Valo