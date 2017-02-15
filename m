Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64229 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750987AbdBOJ1D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 04:27:03 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Configure rxnss_override for 10.4 firmware.
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1486771745-15150-1-git-send-email-greearb@candelatech.com>
References: <1486771745-15150-1-git-send-email-greearb@candelatech.com>
To: Ben Greear <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>,
        Ben Greear <greearb@candelatech.com>,
        <ath10k@lists.infradead.org>
Message-ID: <e379002d2a6a4563baefb435b4552586@eusanexr01a.eu.qualcomm.com> (sfid-20170215_102720_837495_33DFAC58)
Date: Wed, 15 Feb 2017 01:26:58 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> QCA9984 hardware can do 4x4 at 80Mhz, but only 2x2 at 160Mhz.
> 
> First, report this to user-space by setting the max-tx-speed
> and max-rx-speed vht capabilities.
> 
> Second, if the peer rx-speed is configured, and if we
> are in 160 or 80+80 mode, and the peer rx-speed matches
> the max speed for 2x2 or 1x1 at 160Mhz (long guard interval),
> then use that info to set the peer_bw_rxnss_override appropriately.
> 
> Without this, a 9984 firmware will not use 2x2 ratesets when
> transmitting to peer (it will be stuck at 1x1), because
> the firmware would not have configured the rxnss_override.
> 
> This could use some testing....
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Does not apply:

error: patch failed: drivers/net/wireless/ath/ath10k/mac.c:2760
error: drivers/net/wireless/ath/ath10k/mac.c: patch does not apply
error: patch failed: drivers/net/wireless/ath/ath10k/wmi.h:6173
error: drivers/net/wireless/ath/ath10k/wmi.h: patch does not apply
stg import: Diff does not apply cleanly

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9567655/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
