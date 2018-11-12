Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31DEFC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 13:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E423E223DD
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 13:26:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="HsS1Hg/K"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E423E223DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729540AbeKLXTN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 18:19:13 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8400 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbeKLXTN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 18:19:13 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5be97f5d0000>; Mon, 12 Nov 2018 05:25:49 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 12 Nov 2018 05:25:55 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 12 Nov 2018 05:25:55 -0800
Received: from [10.26.11.85] (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 12 Nov
 2018 13:25:53 +0000
Subject: Re: [REGRESSION] brcmfmac: NULL pointer deference starting
 next-20181107
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Hans de Goede <hdegoede@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <dbc5e8f9-6f14-77d2-be2a-f0738e13b773@nvidia.com>
Message-ID: <529421e6-84a4-11bd-5f9e-1a767dd5f7b5@nvidia.com>
Date:   Mon, 12 Nov 2018 13:25:49 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <dbc5e8f9-6f14-77d2-be2a-f0738e13b773@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL108.nvidia.com (172.18.146.13) To
 HQMAIL101.nvidia.com (172.20.187.10)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1542029149; bh=npbN4Pz9gDFDExl69Bj8fkDT4hC94cj/v1j0LpiNJ2g=;
        h=X-PGP-Universal:Subject:From:To:References:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=HsS1Hg/KVZVTY890UVqr1xnIKqGIqzUXI5QkLGt0EIkqQ0aZObJqtLbbm6WZe3vok
         4o0OplowyQq8VQVWl/kwQcy94e5K3RymxczjH5h+eD4M0ZumcWspMe74J3LyTKIVza
         yYP/puRyXxKXliDVTzORcrLWaq8TA/sJZd3ckDDtVXMATo85cgulK/gSYoocMl87g6
         M/D8WgYHUGoDnTQR3ig13aAc9pAgP9mGsol7aBEkumQ8I4cMYVv+OBn1OHqW8Je/Vj
         UGMEWbwLRR3hqrDrEHn+V6nredTmAX/lNpDtveOiou5jbGYyPk1pAeZ11mD6YZ2viP
         SOUqHSPoroPOw==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I forgot to mention the critical piece of information that the bisect
points to ...

commit ce2e6db554fad444fa0b3904fc3015336e0ef765
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Thu Oct 11 11:51:06 2018 +0200

    brcmfmac: Add support for getting nvram contents from EFI variables

Cheers,
Jon


On 12/11/2018 13:24, Jon Hunter wrote:
> Hi Hans, Kalle,
> 
> Starting with next-20181107 I am seeing the following NULL pointer
> deference on Tegra (note the firmware is missing on this board) ...
> 
> [   14.072883] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4329-sdio for chip BCM4329/3
> 
> [   14.130287] brcmfmac mmc1:0001:1: Direct firmware load for brcm/brcmfmac4329-sdio.nvidia,cardhu-a04.txt failed with error -2
> 
> [   14.156283] brcmfmac mmc1:0001:1: Direct firmware load for brcm/brcmfmac4329-sdio.txt failed with error -2
> 
> [   14.177769] Unable to handle kernel NULL pointer dereference at virtual address 00000008
> 
> [   14.197303] pgd = 60bfa5f1
> 
> [   14.211842] [00000008] *pgd=00000000
> 
> [   14.227373] Internal error: Oops: 5 [#1] SMP ARM
> 
> [   14.244244] Modules linked in: brcmfmac sha256_generic sha256_arm snd cfg80211 brcmutil soundcore snd_soc_tegra30_ahub tegra_wdt
> 
> [   14.269109] CPU: 1 PID: 114 Comm: kworker/1:2 Not tainted 4.20.0-rc1-next-20181107-gd881de3 #1
> 
> [   14.269114] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
> 
> [   14.269154] Workqueue: events request_firmware_work_func
> 
> [   14.269177] PC is at efivar_entry_size+0x28/0x90
> 
> [   14.269362] LR is at brcmf_fw_complete_request+0x3f8/0x8d4 [brcmfmac]
> 
> [   14.269369] pc : [<c0c40718>]    lr : [<bf2a3ef4>]    psr: a00d0113
> 
> [   14.269374] sp : ede7fe28  ip : ee983410  fp : c1787f30
> 
> [   14.269378] r10: 00000000  r9 : 00000000  r8 : bf2b2258
> 
> [   14.269384] r7 : ee983000  r6 : c1604c48  r5 : ede7fe88  r4 : edf337c0
> 
> [   14.269389] r3 : 00000000  r2 : 00000000  r1 : ede7fe88  r0 : c17712c8
> 
> [   14.269398] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> 
> [   14.269404] Control: 10c5387d  Table: ad16804a  DAC: 00000051
> 
> [   14.269417] Process kworker/1:2 (pid: 114, stack limit = 0x984bfbff)
> 
> [   14.269423] Stack: (0xede7fe28 to 0xede80000)
> 
> [   14.269434] fe20:                   00000000 c1604c48 edf336e0 edf337c0 ee983000 c1604c48
> 
> [   14.269447] fe40: edf336e0 bf2a3ef4 edf339db c0466bcc edf339c0 edd1417c edd14008 00000000
> 
> [   14.269460] fe60: 006000c0 edf33b40 edf339c0 edf33250 c0f9110c edf33b40 c17db2d0 edf339c0
> 
> [   14.269471] fe80: 00000000 edd14008 00000000 0076006e 00610072 0000006d edf33940 00000003
> 
> [   14.269482] fea0: edf33980 c0923f84 edf33840 edf33940 edf33980 ede7ff1c c0f9110c c0924410
> 
> [   14.269492] fec0: 7fffffff d9025ae9 00000001 edf337c0 00000000 ef7b9e00 edf33804 ef7bd000
> 
> [   14.269512] fee0: 00000000 00000000 c1787f30 bf2a4438 ee952280 00000000 edf33800 ee952280
> 
> [   14.678917] ff00: ef7b9e00 edf33804 ef7bd000 c0924738 00000000 00000003 00000001 edf33940
> 
> [   14.678931] ff20: edf33800 c035ee0c ef7b9e00 ef7b9e18 ede7e018 ee952280 ef7b9e00 ef7b9e18
> 
> [   14.720757] ff40: ede7e018 c17878b8 ee952294 c1603d00 00000008 c035f130 eea99d9c ede7e000
> 
> [   14.720769] ff60: ee970740 c1603d00 eea99d9c eea99d80 ee970740 00000000 eea99d9c ee952280
> 
> [   14.720785] ff80: c035f0f0 ee911ebc 00000000 c0364418 ee970740 c03642f0 00000000 00000000
> 
> [   14.783682] ffa0: 00000000 00000000 00000000 c03010e8 00000000 00000000 00000000 00000000
> 
> [   14.783693] ffc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> 
> [   14.783707] ffe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
> 
> [   14.846132] [<c0c40718>] (efivar_entry_size) from [<bf2a3ef4>] (brcmf_fw_complete_request+0x3f8/0x8d4 [brcmfmac])
> 
> [   14.846253] [<bf2a3ef4>] (brcmf_fw_complete_request [brcmfmac]) from [<bf2a4438>] (brcmf_fw_request_done+0x68/0x11c [brcmfmac])
> 
> [   14.893363] [<bf2a4438>] (brcmf_fw_request_done [brcmfmac]) from [<c0924738>] (request_firmware_work_func+0x40/0x68)
> 
> [   14.893396] [<c0924738>] (request_firmware_work_func) from [<c035ee0c>] (process_one_work+0x164/0x448)
> 
> [   14.939206] [<c035ee0c>] (process_one_work) from [<c035f130>] (worker_thread+0x40/0x524)
> 
> [   14.939228] [<c035f130>] (worker_thread) from [<c0364418>] (kthread+0x128/0x158)
> 
> [   14.981096] [<c0364418>] (kthread) from [<c03010e8>] (ret_from_fork+0x14/0x2c)
> 
> [   14.981102] Exception stack(0xede7ffb0 to 0xede7fff8)
> 
> [   14.981112] ffa0:                                     00000000 00000000 00000000 00000000
> 
> [   15.041390] ffc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> 
> [   15.041399] ffe0: 00000000 00000000 00000000 00000000 00000013 00000000
> 
> [   15.041415] Code: e1a07000 e30102c8 e34c0177 e1a05001 (e5926008) 
> 
> [   15.041491] ---[ end trace 06697c36d390de92 ]---
> 

-- 
nvpublic
