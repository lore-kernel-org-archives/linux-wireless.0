Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38892 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751534AbeAZF7b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 00:59:31 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Update the phymode along with bandwidth change request
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1516842604-31447-1-git-send-email-ryanhsu@codeaurora.org>
References: <1516842604-31447-1-git-send-email-ryanhsu@codeaurora.org>
To: ryanhsu@codeaurora.org
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        rouven@czerwinskis.de, ryanhsu@codeaurora.org
Message-Id: <20180126055930.A92E76028B@smtp.codeaurora.org> (sfid-20180126_065934_984657_D3D5ED9E)
Date: Fri, 26 Jan 2018 05:59:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ryanhsu@codeaurora.org wrote:

> From: Ryan Hsu <ryanhsu@codeaurora.org>
> 
> In the case of Station connects to AP with narrower bandwidth at beginning.
> And later the AP changes the bandwidth to winder bandwidth, the AP will
> beacon with wider bandwidth IE, eg VHT20->VHT40->VHT80 or VHT40->VHT80.
> 
> Since the supported BANDWIDTH will be limited by the PHYMODE, so while
> Station receives the bandwidth change request, it will also need to
> reconfigure the PHYMODE setting to firmware instead of just configuring
> the BANDWIDTH info, otherwise it'll trigger a firmware crash with
> non-support bandwidth.
> 
> The issue was observed in WLAN.RM.4.4.1-00051-QCARMSWP-1, QCA6174 with
> below scenario.

Fails to compile:

drivers/net/wireless/ath/ath10k/mac.c: In function ‘ath10k_sta_rc_update_wk’:
drivers/net/wireless/ath/ath10k/mac.c:6000:3: error: ‘mode’ undeclared (first use in this function)
   mode = chan_to_phymode(&def);
   ^
drivers/net/wireless/ath/ath10k/mac.c:6000:3: note: each undeclared identifier is reported only once for each function it appears in
drivers/net/wireless/ath/ath10k/mac.c:6006:7: error: ‘WMI_PEER_PHYMODE’ undeclared (first use in this function)
       WMI_PEER_PHYMODE, mode);
       ^
make[5]: *** [drivers/net/wireless/ath/ath10k/mac.o] Error 1
make[4]: *** [drivers/net/wireless/ath/ath10k] Error 2
make[3]: *** [drivers/net/wireless/ath] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers] Error 2

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10183453/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
