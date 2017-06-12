Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:59752 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752524AbdFLOsB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Jun 2017 10:48:01 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,2/3] ath10k: Configure rxnss_override for 10.4 firmware.
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170609110750.14950-2-sven.eckelmann@openmesh.com>
References: <20170609110750.14950-2-sven.eckelmann@openmesh.com>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
CC: <ath10k@lists.infradead.org>, Ben Greear <greearb@candelatech.com>,
        <linux-wireless@vger.kernel.org>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Message-ID: <6eeaab36e33747e3ac057888070acb2b@eusanexr01a.eu.qualcomm.com> (sfid-20170612_164806_082365_FD1ECD42)
Date: Mon, 12 Jun 2017 07:47:57 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven.eckelmann@openmesh.com> wrote:

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
> [sven.eckelmann@openmesh.com: rebase, cleanup, drop 160Mhz workaround cleanup]
> Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

This one had warnings, fixed in pending branch:

drivers/net/wireless/ath/ath10k/mac.c:4436:52: warning: incorrect type in assignment (different base types)
drivers/net/wireless/ath/ath10k/mac.c:4436:52:    expected restricted __le16 [assigned] [usertype] rx_highest
drivers/net/wireless/ath/ath10k/mac.c:4436:52:    got int
drivers/net/wireless/ath/ath10k/mac.c:4437:52: warning: incorrect type in assignment (different base types)
drivers/net/wireless/ath/ath10k/mac.c:4437:52:    expected restricted __le16 [assigned] [usertype] tx_highest
drivers/net/wireless/ath/ath10k/mac.c:4437:52:    got int

-- 
https://patchwork.kernel.org/patch/9778087/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
