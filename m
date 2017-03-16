Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50590 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751121AbdCPIxC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 04:53:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Disallow DFS simulation if DFS channel is not enabled
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1487777591-29743-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1487777591-29743-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <378958af71da4bfb906a652cca95a269@euamsexm01a.eu.qualcomm.com> (sfid-20170316_095400_907533_F2680F5C)
Date: Thu, 16 Mar 2017 09:52:53 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> If DFS is not enabled in hostapd (ieee80211h=0) DFS channels shall
> not be available for use even though the hardware may have the capability
> to support DFS. With this configuration (DFS disabled in hostapd) trying to
> bring up ath10k device in DFS channel for AP mode fails and trying to
> simulate DFS in ath10k debugfs results in a warning in cfg80211 complaining
> invalid channel and this should be avoided in the driver itself rather than
> false propogating RADAR detection to mac80211/cfg80211. Fix this by
> checking for the first vif 'is_started' state(should work for client mode
> as well) as all the vifs shall be configured for the same channel
> 
> sys/kernel/debug/ieee80211/phy1/ath10k# echo 1 > dfs_simulate_radar
> 
> WARNING: at net/wireless/chan.c:265 cfg80211_radar_event+0x24/0x60
> Workqueue: phy0 ieee80211_dfs_radar_detected_work [mac80211]
> [<c022f2d4>] (warn_slowpath_null) from
> [<bf72dab8>] (cfg80211_radar_event+0x24/0x60 [cfg80211])
> [<bf72dab8>] (cfg80211_radar_event [cfg80211]) from
> [<bf7813e0>] (ieee80211_dfs_radar_detected_work+0x94/0xa0 [mac80211])
> [<bf7813e0>] (ieee80211_dfs_radar_detected_work [mac80211]) from
> [<c0242320>] (process_one_work+0x20c/0x32c)
> 
> WARNING: at net/wireless/nl80211.c:2488 nl80211_get_mpath+0x13c/0x4cc
>  Workqueue: phy0 ieee80211_dfs_radar_detected_work [mac80211]
> [<c022f2d4>] (warn_slowpath_null) from
> [<bf72dab8>] (cfg80211_radar_event+0x24/0x60 [cfg80211])
> [<bf72dab8>] (cfg80211_radar_event [cfg80211]) from
> [<bf7813e0>] (ieee80211_dfs_radar_detected_work+0x94/0xa0 [mac80211])
> [<bf7813e0>] (ieee80211_dfs_radar_detected_work [mac80211]) from
> [<c0242320>] (process_one_work+0x20c/0x32c)
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

ca07baab0b1e ath10k: disallow DFS simulation if DFS channel is not enabled

-- 
https://patchwork.kernel.org/patch/9587041/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
