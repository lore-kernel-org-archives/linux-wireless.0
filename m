Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44123 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752487AbdASNTQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 08:19:16 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Fix per station tx bit rate reporting
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1484303403-8908-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1484303403-8908-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <4ded1e01b9ae4c168a0d2ca73b7b72c2@euamsexm01a.eu.qualcomm.com> (sfid-20170119_141920_741571_496719FC)
Date: Thu, 19 Jan 2017 14:19:02 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Not clearing the previous tx bit rate status
> results in a ambigous tx bit rate reporting to
> mac80211/cfg80211, for example the previous bit
> rate status would have been marked as legacy rate
> , while the current rate would have been an HT/VHT
> rate with the tx bit rate flags set and this results
> in exporting tx bitrate as legacy rate but with HT/VHT
> rate flags set, fix this by clearing the tx bitrate
> status for each event. This also fixes the below
> warning when we do:
> 
> iw dev wlan#N station dump
> 
> WARNING: net/wireless/util.c:1222 cfg80211
> 
> [<c022f104>] (warn_slowpath_null) from [<bf3b9adc>]
> (cfg80211_calculate_bitrate+0x110/0x1f4 [cfg80211])
> [<bf3b9adc>] (cfg80211_calculate_bitrate [cfg80211]) from
> [<bf3dcd54>] (nl80211_put_sta_rate+0x44/0x1dc [cfg80211])
> [<bf3dcd54>] (nl80211_put_sta_rate [cfg80211]) from
> [<bf3cbc34>] (nl80211_set_interface+0x724/0xd70 [cfg80211])
> [<bf3cbc34>] (nl80211_set_interface [cfg80211]) from
> [<bf3d0a18>] (nl80211_dump_station+0xdc/0x100 [cfg80211])
> [<bf3d0a18>] (nl80211_dump_station [cfg80211])
> 
> Fixes: cec17c382140 ("ath10k: add per peer htt tx stats support for 10.4")
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

0f8a2b7772f7 ath10k: fix per station tx bit rate reporting

-- 
https://patchwork.kernel.org/patch/9514989/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
