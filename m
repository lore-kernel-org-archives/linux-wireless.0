Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46002 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757731AbcK2PcG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 10:32:06 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: adm80211: Removed unused 'io_addr' 'mem_addr' variables
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161124064045.GA8836@google.com>
References: <20161124064045.GA8836@google.com>
To: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Message-Id: <20161129153206.0E7EF611A6@smtp.codeaurora.org> (sfid-20161129_163213_362521_5F725EC8)
Date: Tue, 29 Nov 2016 15:32:06 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kirtika Ruchandani <kirtika.ruchandani@gmail.com> wrote:
> Initial commit cc0b88cf5ecf ([PATCH] Add adm8211 802.11b wireless driver)
> introduced variables mem_addr and io_addr in adm80211_probe() that are
> set but not used. Compiling with W=1 gives the following warnings,
> fix them.
> 
> drivers/net/wireless/admtek/adm8211.c: In function ‘adm8211_probe’:
> drivers/net/wireless/admtek/adm8211.c:1769:15: warning: variable ‘io_addr’ set but not used [-Wunused-but-set-variable]
>   unsigned int io_addr, io_len;
>                ^
> drivers/net/wireless/admtek/adm8211.c:1768:16: warning: variable ‘mem_addr’ set but not used [-Wunused-but-set-variable]
>   unsigned long mem_addr, mem_len;
>                 ^
> 
> These are harmless warnings and are only being fixed to reduce the
> noise with W=1 in the kernel. The calls to pci_resource_start do not
> have any side-effects and are safe to remove.
> 
> Fixes: cc0b88cf5ecf ("[PATCH] Add adm8211 802.11b wireless driver")
> Cc: Michael Wu <flamingice@sourmilk.net>
> Cc: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Kirtika Ruchandani <kirtika@chromium.org>

The patch failed to apply:

fatal: corrupt patch at line 14
Applying: adm80211: Removed unused 'io_addr' 'mem_addr' variables
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0001 adm80211: Removed unused 'io_addr' 'mem_addr' variables

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9444901/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
