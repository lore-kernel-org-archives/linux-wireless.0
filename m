Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37823 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751543AbcIQN4b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 09:56:31 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: <igor.mitsyanko.os@quantenna.com>
Cc: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
        Avinash Patil <avinashp@quantenna.com>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>
Subject: Re: [PATCH v2 RESEND] qtnfmac: announcement of new FullMAC driver for Quantenna chipsets
References: <1466460688-28160-1-git-send-email-igor.mitsyanko.os@quantenna.com>
Date: Sat, 17 Sep 2016 16:56:25 +0300
In-Reply-To: <1466460688-28160-1-git-send-email-igor.mitsyanko.os@quantenna.com>
        (igor mitsyanko os's message of "Tue, 21 Jun 2016 01:11:28 +0300")
Message-ID: <87a8f68wae.fsf@kamboji.qca.qualcomm.com> (sfid-20160917_155635_148146_87120A26)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<igor.mitsyanko.os@quantenna.com> writes:

> From: Avinash Patil <avinashp@quantenna.com>
>
> This patch adds support for new FullMAC WiFi driver for Quantenna
> QSR10G chipsets.
>
> QSR10G is Quantenna's 8x8, 160M, 11ac offering.
> QSR10G supports 2 simultaneous WMACs- one 5G and one 2G. 5G WMAC
> supports 160M, 8x8 configuration.
> FW supports 8 concurrent virtual interfaces on each WMAC.
>
> Patch introduces 2 new drivers- qtnfmac.ko for interfacing with
> kernel/cfg80211 and qtnfmac_pcie.ko for PCIe bus interface.
>
> Signed-off-by: Dmitrii Lebed <dlebed@quantenna.com>
> Signed-off-by: Sergei Maksimenko <smaksimenko@quantenna.com>
> Signed-off-by: Sergey Matyukevich <smatyukevich@quantenna.com>
> Signed-off-by: Bindu Therthala <btherthala@quantenna.com>
> Signed-off-by: Huizhao Wang <hwang@quantenna.com>
> Signed-off-by: Kamlesh Rath <krath@quantenna.com>
> Signed-off-by: Avinash Patil <avinashp@quantenna.com>
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

More comments:

> +/* FW names */
> +
> +#define QTN_PCI_FW_NAME		"pearl-linux.lzma.img"

The firmware name gives no indication what this file is about (remember
that linux-firmware.git has a lot of files). Please name it properly,
don't just use what is used in by firmware build scripts :) Take into
account also future hw support, all firmware files need to coexist in
the same repository without user invention. In a way the firmware
filename is part of kernel/userspace interface and needs to be stable.

For example, you could use something like "qtnfmac/qsr10g.img" (assuming
qsr10g is the name of chip).

I forgot already, is the firmware image ready for submission to
linux-firmware.git?

> +	pr_info("%s: %sregistered mgmt frame type 0x%x\n", __func__,
> +		reg ? "" : "un", frame_type);

The driver seems to be quite spammy with info messages:

qtnfmac/cfg80211.c:     pr_info("%s: %sregistered mgmt frame type 0x%x\n", __func__,
qtnfmac/cfg80211.c:     pr_info("QTNF: %s cipher=%x, idx=%u, pairwise=%u\n", __func__,
qtnfmac/cfg80211.c:     pr_info("QTNF: %s idx=%u, pairwise=%u\n", __func__, key_index,
qtnfmac/cfg80211.c:     pr_info("QTNF: %s idx=%u, unicast=%u, multicast=%u\n", __func__,
qtnfmac/cfg80211.c:     pr_info("QTNF: %s idx=%u\n", __func__, key_index);
qtnfmac/cfg80211.c:     pr_info("%s: initiator=%d, alpha=%c%c, macid=%d\n", __func__,
qtnfmac/cfg80211.c:     pr_info("%s: MAX_IF: %zu; MODES: %.4X; RADAR WIDTHS: %.2X\n", __func__,
qtnfmac/cfg80211.c:     pr_info("macid=%d, phymode=%#x\n", mac->macid, mac->macinfo.phymode);
qtnfmac/commands.c:                     pr_info("%s: unexpected TLV type: %.4X\n",
qtnfmac/commands.c:                     pr_info("%s: STA %pM not found\n", __func__, sta_mac);
qtnfmac/commands.c:     pr_info("country-code from EP: %c%c\n", hwinfo->country_code[0],
qtnfmac/commands.c:     pr_info("fw_version = %d, num_mac=%d, mac_bitmap=%#x\n",
qtnfmac/commands.c:                     pr_info("iface limit record count=%zu\n", record_count);
qtnfmac/commands.c:                     pr_info("MAC%d reported channels %d\n",
qtnfmac/init.c: pr_info("%s: macid=%d\n", __func__, macid);
qtnfmac/pcie.c:                 pr_info("enabled PCIE MSI interrupt\n");
qtnfmac/pcie.c: pr_info("%s: BAR[%u] vaddr=0x%p busaddr=0x%p len=%u\n",
qtnfmac/pcie.c: pr_info("%s: set mps to %d (was %d, max %d)\n",
qtnfmac/pcie.c: pr_info("fw download started: fw start addr = 0x%p, size=%d\n",
qtnfmac/pcie.c: pr_info("fw download completed: totally sent %d blocks\n", blk);
qtnfmac/pcie.c: pr_info("RC is ready to boot EP...\n");
qtnfmac/pcie.c: pr_info("starting download firmware %s...\n", bus->fwname);
qtnfmac/pcie.c:         pr_info("successful init of PCI device %x\n", pdev->device);
qtnfmac/pcie.c: pr_info("Register Quantenna FullMAC PCIE driver\n");
qtnfmac/pcie.c: pr_info("Unregister Quantenna FullMAC PCIE driver\n");
qtnfmac/trans.c:                        pr_info("%s: interrupted\n", __func__);
qtnfmac/trans.c:        pr_info("%s: skb dropped\n", __func__);

Usualle the preference is that driver is quiet until something goes
wrong. I hope some of these could be debug messages.

> --- /dev/null
> +++ b/drivers/net/wireless/quantenna/qtnfmac/pcie.c
> @@ -0,0 +1,1374 @@
> +/**
> + * Copyright (c) 2015-2016 Quantenna Communications, Inc.
> + * All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + **/
> +
> +#undef DEBUG

Why?

-- 
Kalle Valo
