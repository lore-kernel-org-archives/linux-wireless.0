Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:6509 "EHLO
        alexa-out-lv-01.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751147AbdHOLeD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2017 07:34:03 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [5/6] ath10k: add memory dump support for QCA6174/QCA9377
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <150278542590.22482.1613614809483892010.stgit@potku.adurom.net>
References: <150278542590.22482.1613614809483892010.stgit@potku.adurom.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-ID: <e8f8ba72414c48dea427357170975b66@euamsexm01a.eu.qualcomm.com> (sfid-20170815_133406_980879_351908B4)
Date: Tue, 15 Aug 2017 13:33:51 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> wrote:

> Add memory dump to the firmware crash data file which is provided to user space
> via devcoredump interface. This makes it easier for firmware engineers to debug
> firmware crashes.
> 
> Due to increased memory consumption the memory dump is disabled by default. To
> enable it make sure that bit 3 is set in coredump_mask module parameter:
> 
> modprobe ath10k_core coredump_mask=0xffffffff
> 
> When RAMDUMP is enabled a buffer for the dump is allocated with vmalloc during
> device probe. The actual memory layout is different in hardware versions and
> the layouts are defined in coredump.c. The memory is split to regions and, to
> get even finegrained control of what to copy, the region can split to smaller
> sections as not all registers are readable (which could cause the whole system
> to stall).
> 
> Signed-off-by: Alan Liu <alanliu@qca.qualcomm.com>
> [kvalo@qca.qualcomm.com: refactoring and cleanup]
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

kbuild bot reported:

coccinelle warnings: (new ones prefixed by >>)

>> drivers/net/wireless/ath/ath10k/pci.c:1561:2-3: Unneeded semicolon
--
>> drivers/net/wireless/ath/ath10k/pci.c:1522:6-15: WARNING: Unsigned expression compared with zero: skip_size < 0

-- 
https://patchwork.kernel.org/patch/9901255/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
