Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14892 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750859AbdFUNSc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 09:18:32 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,
 1/3] ath10k: Use complete VHT chan width for 160MHz workaround
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170609110750.14950-1-sven.eckelmann@openmesh.com>
References: <20170609110750.14950-1-sven.eckelmann@openmesh.com>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
CC: <ath10k@lists.infradead.org>, Ben Greear <greearb@candelatech.com>,
        <linux-wireless@vger.kernel.org>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Message-ID: <afa6ec98d286450687ed30267026d7a8@euamsexm01a.eu.qualcomm.com> (sfid-20170621_151845_607195_5C23239A)
Date: Wed, 21 Jun 2017 15:18:09 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven.eckelmann@openmesh.com> wrote:

> The ath10k firmware doesn't announce its VHT channel width capabilities in
> the vht_cap information from the "service ready event" arguments. The
> driver must therefore check whether the 160MHz short GI bit is set and
> whether the driver still doesn't set the bits for the 160/80+80 MHz
> capabilities.
> 
> The two bits for the channel width are a two bit integer and not two
> separate bits which cannot be parsed without the knowledge of the other
> bit. Using IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ (b10..) as a
> mask for this task doesn't make any sense. The correct mask for the VHT
> channel width should be used instead to make this check more readable.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> [sven.eckelmann@openmesh.com: separate 160Mhz workaround cleanup, add commit
>  message]
> Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

3 patches applied to ath-next branch of ath.git, thanks.

e509e5947708 ath10k: use complete VHT chan width for 160MHz workaround
cc914a55006e ath10k: configure rxnss_override for QCA9984
6824834946a6 ath10k: set rxnss_override for QCA9888

-- 
https://patchwork.kernel.org/patch/9778085/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
