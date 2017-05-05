Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39620 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752729AbdEEMvV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 May 2017 08:51:21 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: merge extended peer info data with existing peers info
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20161217174634.4531-1-chunkeey@googlemail.com>
References: <20161217174634.4531-1-chunkeey@googlemail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
        "Mohammed Shafi Shajakhan" <mohammed@codeaurora.org>
Message-ID: <02c99a9342f546488356517e56bc7a4c@eusanexr01a.eu.qualcomm.com> (sfid-20170505_145128_914980_A20716CE)
Date: Fri, 5 May 2017 05:51:16 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@googlemail.com> wrote:
> The 10.4 firmware adds extended peer information to the
> firmware's statistics payload. This additional info is
> stored as a separate data field. During review of
> "ath10k: add accounting for the extended peer statistics" [0]
> 
> Mohammed Shafi Shajakhan commented that the extended peer statistics
> lists are of little use:"... there is not much use in appending
> the extended peer stats (which gets periodically updated) to the
> linked list '&ar->debug.fw_stats.peers_extd)' and should we get
> rid of the below (and the required cleanup as well)
> 
> list_splice_tail_init(&stats.peers_extd,
>                 &ar->debug.fw_stats.peers_extd);
> 
> since rx_duration is getting updated periodically to the per sta
> information."
> 
> This patch replaces the extended peers list with a lookup and
> puts the retrieved data (rx_duration) into the existing
> ath10k_fw_stats_peer entry that was created earlier.
> 
> [0] <https://lkml.kernel.org/r/992a4e2676037a06f482cdbe2d3d39e287530be5.1480974623.git.chunkeey@googlemail.com>
> Cc: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>

The discussion with this bug was quite hard to follow, so what is the
conclusion from this? The patch still applies using three way merge but there
are compilation errors:

drivers/net/wireless/ath/ath10k/debug.c: In function 'ath10k_debug_fw_stats_process':
drivers/net/wireless/ath/ath10k/debug.c:388:4: error: implicit declaration of function 'ath10k_fw_extd_stats_peers_free' [-Werror=implicit-function-declaration]
drivers/net/wireless/ath/ath10k/debug.c:388:55: error: 'struct ath10k_fw_stats' has no member named 'peers_extd'
drivers/net/wireless/ath/ath10k/debug.c:400:32: error: 'struct ath10k_fw_stats' has no member named 'peers_extd'
drivers/net/wireless/ath/ath10k/debug.c:401:31: error: 'struct ath10k_fw_stats' has no member named 'peers_extd'

I admit that I didn't look this patch very carefully, but I'm not really seeing
how this patch makes things better? wmi.c gets more complicated and a new
ifdef is added. We have tried hard to keep all ar->debug access in debug.c,
this way there's no need to sprinkle ifdefs in the code.

-- 
https://patchwork.kernel.org/patch/9479079/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
