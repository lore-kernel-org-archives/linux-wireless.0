Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120]:60471 "EHLO
	pne-smtpout3-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750767AbYAWNVU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 08:21:20 -0500
Received: from [10.0.0.10] (80.220.119.243) by pne-smtpout3-sn1.fre.skanova.net (7.3.129)
        id 478149BD000F38BE for linux-wireless@vger.kernel.org; Wed, 23 Jan 2008 14:20:11 +0100
Subject: Re: [PATCH 00/14] RFC: Driver for Wireless RNDIS USB devices.
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080120001342.25718.83669.stgit@fate.lan>
References: <20080120001342.25718.83669.stgit@fate.lan>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 15:21:15 +0200
Message-Id: <1201094475.7733.1.camel@localhost> (sfid-20080123_132124_359813_3B040B12)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Any change of getting driver merged in 2.6.25?

 - Jussi

On Sun, 2008-01-20 at 02:13 +0200, Jussi Kivilinna wrote:
> Hello,
> 
> This is second try on wireless RNDIS patchset started by Bjorge Dijkstra. Since
> Bjorge has disappeared, I claim maintainership of rndis_wext and this patchset
> until he returns.
> 
> This patchset adds support for various 802.11 USB devices based on Broadcom
> 4320 chip. Chip uses RNDIS to communicate with the host, so module depend
> heavily on rndis_host/cdc_ether/usbnet and needs some changes on these 
> modules in order to work.
> 
> Patches 1-6 are from first patchset:
>  1. Fix sparse warning: returning void valued expression
>  2. [cdc_ether] Hardwire CDC descriptors when missing
>  3. [rndis_host] Use 1KB buffer in rndis_unbind
>  4. [rndis_host] Halt device if rndis_bind fails
>  5. [rndis_host] Fix rndis packet filter flags
>  6. [usbnet] Use wlan device name for RNDIS wireless devices
> 
> Of these 1, 3 and 4 are not required for this version of rndis_wext to work.
> 
> Actual wireless part is changed from extension on rndis_host to separate 
> driver. Different devices are detected by device specific USB vendor/product 
> IDs as the way done with Windows drivers instead of detecting RNDIS media type 
> like in first patchset.
> 
> New patches 7-14:
>  7. [rndis_host] Split up rndis_host.c
>  8. [rndis_host] export functions
>  9. [usbnet] add driver_priv pointer to 'struct usbnet'
> 10. [rndis_host] Add rndis_early_init function pointer to 'struct rndis_data'.
> 11. [rndis_host] Add rndis_link_change function pointer to 'struct rndis_data'.
> 12. Move usbnet.h and rndis_host.h to include/linux/usb
> 13. [rndis_host] blacklist known wireless RNDIS devices
> 14. Add new driver 'rndis_wext' for wireless RNDIS devices.
> 
> Patches should be applied in order, series apply cleanly to 2.6.24-rc8.
> 
>  - Jussi Kivilinna
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

