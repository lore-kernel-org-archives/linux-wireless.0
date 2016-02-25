Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:37843 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbcBYW0X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 17:26:23 -0500
Received: by mail-ig0-f173.google.com with SMTP id z8so23897420ige.0
        for <linux-wireless@vger.kernel.org>; Thu, 25 Feb 2016 14:26:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1455704830-10088-1-git-send-email-arend@broadcom.com>
References: <1455704830-10088-1-git-send-email-arend@broadcom.com>
Date: Thu, 25 Feb 2016 23:26:22 +0100
Message-ID: <CACna6rwHtLhDtd-qZ4nfEhXsGjJaHNa-eePCn99eonff1Q0SQw@mail.gmail.com> (sfid-20160225_232627_152709_E70094A4)
Subject: Re: [PATCH 00/21] brcmfmac: driver setting concept and other changes
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 February 2016 at 11:26, Arend van Spriel <arend@broadcom.com> wrote:
> This series contain various changes for the brcmfmac driver. Here
> the list of highlights:
>
> * IPv6 Neighbor discovery offload.
> * driver settings that can be populated from different sources.
> * country code setting in firmware.
> * length checks to validate firmware events.
> * new way to determine device memory size needed for BCM4366.
> * various offloads during wowl.
> * full MFP support.
>
> This series is intended for v4.6 and applies to the master branch
> of the wireless-drivers-next repository. Patch #17 is already in
> wireless-drivers repo. The other patches apply without it, but it
> is needed to compile test the remainder of the series.

I tried this patchset on
1) SmartRG SR400ac (BCM4708 + 2 x BCM43602)
2) D-Link DIR-885L (BCM47094 + 2 x BCM4366)

BCM43602 still works correctly as expected. No obvious regressions. Nice.

BCM4366s in my DIR-885L were unusable so far due to the following
errors (one per wireless card):
[   13.249195] brcmfmac: brcmf_pcie_download_fw_nvram: FW failed to initialize
[   18.209196] brcmfmac: brcmf_pcie_download_fw_nvram: FW failed to initialize

With this patchset my first BCM4366 card works correctly:
brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Jan  8 2016
12:54:07 version 10.10.69.3309 (r610991) FWID 01-c47a91a4

Unfortunately second one - while doing a bit better - still fails:
brcmfmac: brcmf_msgbuf_query_dcmd: Timeout on response for query command
brcmfmac: brcmf_c_preinit_dcmds: Retreiving cur_etheraddr failed, -5
brcmfmac: brcmf_bus_start: failed: -5
brcmfmac: brcmf_pcie_attach_bus: dongle is not responding

We were already discussing this privately a bit and AFAIR Hante said
he suspects something about PCIe BAR. I was hoping that maybe
[PATCH] brcmfmac: use bar1 window size as provided by pci subsystem
will fix this problem, but apparently it doesn't.

Did you guys try brcmfmac on any router with 2 x BCM4366? Did you have
any more luck?
Any other ideas about what may be stopping 2nd BCM4366 card from
working correctly?

Whatever it missing to support 2nd BCM4366 in my DIR-885L, this
patchset is a nice improvement anyway, thank you!
