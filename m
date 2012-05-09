Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52169 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932494Ab2EIWRs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 18:17:48 -0400
Message-ID: <4FAAED03.4090008@hauke-m.de> (sfid-20120510_001752_853655_866922E3)
Date: Thu, 10 May 2012 00:17:39 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>, zajec5@gmail.com
CC: linville@tuxdriver.com, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, arend@broadcom.com
Subject: Re: [PATCH 0/4] bcma: add PCI functions from brcmsmac
References: <1335658732-24351-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1335658732-24351-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/29/2012 02:18 AM, Hauke Mehrtens wrote:
> This patch series contains the functions regarding the PCIe core from 
> brcmsmac for the supported PCIe core revisions.
> 
> Some of these functions have to be called on resume after suspend, but 
> I do not know which or if all have to be called. I do not have a PCIe 
> based device supported by brcmsmac, so I can not test this. Could 
> someone which such a device do some tests and create a patch with the 
> functions, which have to be called on resume.
> 
> The goal of theses patches is to remove the PCIe code from brcmsmac to 
> get one step ahead in making brcmsmac support non pcie based devices.
> 
> This is based on wireless-testing/master.
> 
> Hauke Mehrtens (4):
>   bcma: implement setting core clock mode to dynamic
>   bcma: add bcma_core_pci_extend_L1timer
>   bcma: add bcma_core_pci_fixcfg()
>   bcma: add bcma_core_pci_config_fixup()
> 
>  drivers/bcma/core.c                  |    2 +-
>  drivers/bcma/driver_pci.c            |   53 ++++++++++++++++++++++++++++++++--
>  include/linux/bcma/bcma_driver_pci.h |   11 +++++++
>  3 files changed, 63 insertions(+), 3 deletions(-)
> 

Hi Rafał,

could you give me an ack or a nack about this patch series and the other
(ssb/bcma/bcm47xx: extend boardinfo and sprom).

I have tested them with b43 and brcmsmac on bcma and ssb based SoCs
(bcm4718 + bcm43224, bcm4705 + 2x bcm4322, bcm4704 + bcm4318)  and have
not found any problems.

Hauke
