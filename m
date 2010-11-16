Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:46334 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933951Ab0KPJMo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 04:12:44 -0500
Date: Tue, 16 Nov 2010 10:12:41 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	lrodriguez@atheros.com, ath5k-devel@lists.ath5k.org,
	linville@tuxdriver.com
Message-ID: <25599345.31289898761015.JavaMail.wlan@CHBU500181>
In-Reply-To: <1289897272-8997-1-git-send-email-Wojciech.Dubowik@neratec.com>
Subject: Re: [PATCH v4 0/9] ath5k: Add AHB support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This series of patches implements AHB bus support for ath5k driver.
> 
> General comments for AHB bus support in ath5k:
> 	* original patches came from Felix Fetikau
> 	* tried with access point functionality with WPA2 and without
> encryption
> 	* tested on AR5312 and AR2313for AHB and AR5414 and AR5212 for PCI
> 	* compat wireless 2010-11-10 from openwrt was used for testing
> 	* last two patches have to be applied together because otherwise
> 		hardware will crash on reset if only number 9 is committed.
> 		I have kept them separated for better visibility. 
> 		There are three false positive checkpatch warnings from them.
> 
> Wojciech Dubowik (9):
>   ath5k: Use Generic DMA for later support of AHB bus.     From:
> Felix
>     Fietkau <nbd@openwrt.org>
>   ath5k: Introduce ath5k_init_softc function as in ath9k     From:
>     Felix Fietkau <nbd@openwrt.org>
>   ath5k: Move PCI bus functions to separate file.     From: Felix
>     Fietkau <nbd@openwrt.org>
>   ath5k: Use generic eeprom read from common ath_bus_opts struct.    
>     From: Felix Fietkau <nbd@openwrt.org>
>   ath5k: Check if pci pdev struct is initialized in common functions. 
> 
>       From: Felix Fietkau <nbd@openwrt.org>
>   ath5k: Add a function to read chipset's MAC revision     From:
> Felix
>     Fietkau <nbd@openwrt.org>
>   ath5k: Add initial registers values for radio RF2317 chip.    
> From:
>     Felix Fietkau <nbd@openwrt.org>
>   ath5k: Add AHB bus support.     From: Felix Fietkau
> <nbd@openwrt.org>
>   ath5k: Fix reset and interrupts for AHB type of devices.     From:
>     Felix Fietkau <nbd@openwrt.org>
> 
>  drivers/net/wireless/ath/ath5k/Kconfig    |   17 +-
>  drivers/net/wireless/ath/ath5k/Makefile   |    2 +
>  drivers/net/wireless/ath/ath5k/ahb.c      |  219 ++++++++++
>  drivers/net/wireless/ath/ath5k/ath5k.h    |   37 ++-
>  drivers/net/wireless/ath/ath5k/attach.c   |   26 +-
>  drivers/net/wireless/ath/ath5k/base.c     |  626
> ++++++++++-------------------
>  drivers/net/wireless/ath/ath5k/base.h     |    5 +-
>  drivers/net/wireless/ath/ath5k/eeprom.c   |   40 +--
>  drivers/net/wireless/ath/ath5k/eeprom.h   |    2 +-
>  drivers/net/wireless/ath/ath5k/initvals.c |   23 +
>  drivers/net/wireless/ath/ath5k/led.c      |   11 +-
>  drivers/net/wireless/ath/ath5k/pci.c      |  326 +++++++++++++++
>  drivers/net/wireless/ath/ath5k/reg.h      |   25 ++
>  drivers/net/wireless/ath/ath5k/reset.c    |  116 ++++--
>  drivers/net/wireless/ath/ath5k/sysfs.c    |    4 +-
>  15 files changed, 988 insertions(+), 491 deletions(-)
>  create mode 100644 drivers/net/wireless/ath/ath5k/ahb.c
>  create mode 100644 drivers/net/wireless/ath/ath5k/pci.c

Obviously my script to send patches didn't work as expected so I will have to send them again.

Wojtek
