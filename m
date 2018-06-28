Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33108 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933194AbeF1J2B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jun 2018 05:28:01 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath10k: Update the phymode along with bandwidth change
 request
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1528482759-12604-1-git-send-email-ryanhsu@codeaurora.org>
References: <1528482759-12604-1-git-send-email-ryanhsu@codeaurora.org>
To: Ryan Hsu <ryanhsu@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        timur.kristof@gmail.com
Message-Id: <20180628092800.AB68E60B10@smtp.codeaurora.org> (sfid-20180628_112804_707333_26D2ACFD)
Date: Thu, 28 Jun 2018 09:28:00 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ryan Hsu <ryanhsu@codeaurora.org> wrote:

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
> below scenario:
> 
> AP xxx changed bandwidth, new config is 5200 MHz, width 2 (5190/0 MHz)
> disconnect from AP xxx for new auth to yyy
> RX ReassocResp from xxx (capab=0x1111 status=0 aid=102)
> associated
> 
> ....
> 
> AP xxx changed bandwidth, new config is 5200 MHz, width 2 (5190/0 MHz)
> AP xxx changed bandwidth, new config is 5200 MHz, width 3 (5210/0 MHz)
> 
> ....
> 
> firmware register dump:
> [00]: 0x05030000 0x000015B3 0x00987291 0x00955B31
> [04]: 0x00987291 0x00060730 0x00000004 0x00000001
> [08]: 0x004089F0 0x00955A00 0x000A0B00 0x00400000
> [12]: 0x00000009 0x00000000 0x00952CD0 0x00952CE6
> [16]: 0x00952CC4 0x0098E25F 0x00000000 0x0091080D
> [20]: 0x40987291 0x0040E7A8 0x00000000 0x0041EE3C
> [24]: 0x809ABF05 0x0040E808 0x00000000 0xC0987291
> [28]: 0x809A650C 0x0040E948 0x0041FE40 0x004345C4
> [32]: 0x809A5C63 0x0040E988 0x0040E9AC 0x0042D1A8
> [36]: 0x8091D252 0x0040E9A8 0x00000002 0x00000001
> [40]: 0x809FDA9D 0x0040EA58 0x0043D554 0x0042D554
> [44]: 0x809F8B22 0x0040EA78 0x0043D554 0x00000001
> [48]: 0x80911210 0x0040EAC8 0x00000010 0x004041D0
> [52]: 0x80911154 0x0040EB28 0x00400000 0x00000000
> [56]: 0x8091122D 0x0040EB48 0x00000000 0x00400600
> 
> Reported-by: Rouven Czerwinski <rouven@czerwinskis.de>
> Tested-by: Timur Kristóf <timur.kristof@gmail.com>
> Signed-off-by: Ryan Hsu <ryanhsu@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-current branch of ath.git, thanks.

9191fc2a431b ath10k: update the phymode along with bandwidth change request

-- 
https://patchwork.kernel.org/patch/10454965/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
