Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40778 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753254AbdCIIBt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Mar 2017 03:01:49 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath10k: Fix a warning during channel switch with multiple
 vaps
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1487331902-12034-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1487331902-12034-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <e4752e9419a146a18fdbc8ac2061f583@euamsexm01a.eu.qualcomm.com> (sfid-20170309_090312_019390_F0A2D889)
Date: Thu, 9 Mar 2017 09:01:36 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Doing a channel switch via hostapd_cli seems to update
> the new channel context for each VAP's appropriately as below
> in 'ath10k_mac_update_vif_chan', hence we can safely suppress the
> warning that shows up during this operation and dump the warning only
> if no vaps are available for channel switch
> 
> hostapd_cli -i wlan0 chan_switch 5 5200
> OK
> 
> ath10k_pci : mac chanctx switch n_vifs 3 mode 1
> ath10k_pci : mac chanctx switch vdev_id 2 freq 5180->5200 width 0->0
> ath10k_pci : mac chanctx switch vdev_id 1 freq 5180->5200 width 0->0
> ath10k_pci : mac chanctx switch vdev_id 0 freq 5180->5200 width 0->0
> 
> Call Trace:
> 
> WARNING: backports-20161201-3.14.77-9ab3068/drivers/net/wireless/ath/ath10k/mac.c:7126
> [<c022f2d4>] (warn_slowpath_null) from [<bf7f150c>]
> (ath10k_reconfig_complete+0xe4/0x25c [ath10k_core])
> [<bf7f150c>] (ath10k_reconfig_complete [ath10k_core])
> [<bf7f35f0>] (ath10k_mac_vif_ap_csa_work+0x214/0x370 [ath10k_core])
> [<bf7f38b8>] (ath10k_mac_op_change_chanctx+0x108/0x128 [ath10k_core])
> [<bf782ac0>] (ieee80211_recalc_chanctx_min_def+0x30c/0x430 [mac80211])
> [<bf7830a4>] (ieee80211_recalc_smps_chanctx+0x2ec/0x840 [mac80211])
> [<bf7843e8>] (ieee80211_vif_use_reserved_context+0x7c/0xf8 [mac80211])
> [<bf7843e8>] (ieee80211_vif_use_reserved_context [mac80211])
> [<bf76e5d4>] (ieee80211_csa_finalize_work+0x5c/0x88 [mac80211])
> 
> Fixes: d7bf4b4aba05 ("ath10k: fix ar->rx_channel updating logic")
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

c73f8c00330f ath10k: fix a warning during channel switch with multiple vaps

-- 
https://patchwork.kernel.org/patch/9579679/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
