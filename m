Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:10452 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366Ab2LRWWd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2012 17:22:33 -0500
Date: Tue, 18 Dec 2012 23:22:26 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Golle <dgolle@allnet.de>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 2/2] rt2x00: rt2800pci: allow to load
 EEPROM data via firmware API
Message-ID: <20121218222226.GB4825@localhost.localdomain> (sfid-20121218_232238_772736_F78E3617)
References: <1355847743-16659-1-git-send-email-juhosg@openwrt.org>
 <1355847743-16659-2-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1355847743-16659-2-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 18, 2012 at 05:22:23PM +0100, Gabor Juhos wrote:
> Currently the driver fetches the EEPROM data
> from a fixed memory location for SoC devices
> for SoC devices with a built-in wireless MAC.
> 
> The usability of this approach is quite
> limited, because it is only suitable if the
> location of the EEPROM data is mapped into
> the memory. This condition is true on embedded
> boards equipped which are using a parallel NOR
> flash, but it is not true for boards equipped
> with SPI or NAND flashes. The fixed location
> also does not work in all cases, because the
> offset of the EEPROM data varies between
> different boards.
> 
> Additionally, various embedded boards are using
> a PCI/PCIe chip soldered directly onto the PCB.
> Such boards usually does not have a separate
> EEPROM chip for the PCI/PCIe devices, the data
> of the EEPROM is stored in the main flash
> instead.
> 
> The patch makes it possible to load the EEPROM
> data via firmware API. This new method works
> regardless of the type of the flash, and it is
> usable with built-in and with PCI/PCIe devices.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

I understand this patch will not broke NOR boards, which use
ioremap approach currently?

> +	init_completion(&ec.complete);
> +	retval = request_firmware_nowait(THIS_MODULE, 1, name,
> +					 rt2x00dev->dev, GFP_KERNEL, &ec,
> +					 rt2800pci_eeprom_request_cb);
> +	if (retval < 0) {
> +		ERROR(rt2x00dev, "EEPROM request failed\n");
> +		return retval;
> +	}
> +
> +	wait_for_completion(&ec.complete);
Since we use completion here, why we can not just use normal synchronous
version of request_firmware? I heard of request_firmware drawbacks, so
this approach can be correct. Just want to know if we do not complicate
things not necessarily here.

> +		goto release_eeprom;
> +	}
> +
> +	memcpy(rt2x00dev->eeprom, ec.blob->data, EEPROM_SIZE);
> +	retval = 0;
> +
> +release_eeprom:
We do not free memory - I guess we should do relase_firmware(ec.blob)?

Thanks
Stanislaw
