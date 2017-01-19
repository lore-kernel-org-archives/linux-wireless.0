Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58377 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751759AbdASNTw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 08:19:52 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: dump Copy Engine registers during firmware crash
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <148458066842.22029.11182008791835649945.stgit@potku.adurom.net>
References: <148458066842.22029.11182008791835649945.stgit@potku.adurom.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-ID: <942368b5799b490bbdff933a379ea80a@euamsexm01a.eu.qualcomm.com> (sfid-20170119_141955_601217_2682959A)
Date: Thu, 19 Jan 2017 14:19:45 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Dump Copy Engine source and destination ring addresses.
> This is useful information to debug firmware crashes, assertes or hangs over long run
> assessing the Copy Engine Register status. This also enables dumping CE
> register status in debugfs Crash Dump file.
> 
> Screenshot:
> 
> ath10k_pci 0000:02:00.0: simulating hard firmware crash
> ath10k_pci 0000:02:00.0: firmware crashed! (uuid 84901ff5-d33c-456e-93ee-0165dea643cf)
> ath10k_pci 0000:02:00.0: qca988x hw2.0 target 0x4100016c chip_id 0x043202ff sub 0000:0000
> ath10k_pci 0000:02:00.0: kconfig debug 1 debugfs 1 tracing 1 dfs 1 testmode 1
> ath10k_pci 0000:02:00.0: firmware ver 10.2.4.70.59-2 api 5 features no-p2p,raw-mode,mfp,allows-mesh-bcast crc32 4159f498
> ath10k_pci 0000:02:00.0: board_file api 1 bmi_id N/A crc32 bebc7c08
> ath10k_pci 0000:02:00.0: htt-ver 2.1 wmi-op 5 htt-op 2 cal otp max-sta 128 raw 0 hwcrypto 1
> ath10k_pci 0000:02:00.0: firmware register dump:
> ath10k_pci 0000:02:00.0: [00]: 0x4100016C 0x00000000 0x009A0F2A 0x00000000
> ath10k_pci 0000:02:00.0: [04]: 0x00000000 0x00000000 0x00000000 0x00000000
> ath10k_pci 0000:02:00.0: [08]: 0x00000000 0x00000000 0x00000000 0x00000000
> ath10k_pci 0000:02:00.0: [12]: 0x00000000 0x00000000 0x00000000 0x00000000
> ath10k_pci 0000:02:00.0: [16]: 0x00000000 0x00000000 0x00000000 0x009A0F2A
> ath10k_pci 0000:02:00.0: [20]: 0x00000000 0x00401930 0x00000000 0x00000000
> ath10k_pci 0000:02:00.0: [24]: 0x00000000 0x00000000 0x00000000 0x00000000
> ath10k_pci 0000:02:00.0: [28]: 0x00000000 0x00000000 0x00000000 0x00000000
> ath10k_pci 0000:02:00.0: [32]: 0x00000000 0x00000000 0x00000000 0x00000000
> ath10k_pci 0000:02:00.0: [36]: 0x00000000 0x00000000 0x00000000 0x00000000
> ath10k_pci 0000:02:00.0: [40]: 0x00000000 0x00000000 0x00000000 0x00000000
> ath10k_pci 0000:02:00.0: [44]: 0x00000000 0x00000000 0x00000000 0x00000000
> ath10k_pci 0000:02:00.0: [48]: 0x00000000 0x00000000 0x00000000 0x00000000
> ath10k_pci 0000:02:00.0: [52]: 0x00000000 0x00000000 0x00000000 0x00000000
> ath10k_pci 0000:02:00.0: [56]: 0x00000000 0x00000000 0x00000000 0x00000000
> ath10k_pci 0000:02:00.0: Copy Engine register dump:
> ath10k_pci 0000:02:00.0: [00]: 0x00057400   7   7   3   3
> ath10k_pci 0000:02:00.0: [01]: 0x00057800  18  18  85  86
> ath10k_pci 0000:02:00.0: [02]: 0x00057c00  49  49  48  49
> ath10k_pci 0000:02:00.0: [03]: 0x00058000  16  16  17  16
> ath10k_pci 0000:02:00.0: [04]: 0x00058400   4   4  44   4
> ath10k_pci 0000:02:00.0: [05]: 0x00058800  12  12  11  12
> ath10k_pci 0000:02:00.0: [06]: 0x00058c00   3   3   3   3
> ath10k_pci 0000:02:00.0: [07]: 0x00059000   0   0   0   0
> ieee80211 phy0: Hardware restart was requested
> ath10k_pci 0000:02:00.0: device successfully recovered
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> [kvalo@qca.qualcomm.com: simplify the implementation]
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

c75c398be6ed ath10k: dump Copy Engine registers during firmware crash

-- 
https://patchwork.kernel.org/patch/9518985/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
