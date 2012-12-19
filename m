Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:58420 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab2LSJf2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2012 04:35:28 -0500
Message-ID: <50D18A5A.2020505@openwrt.org> (sfid-20121219_103533_212983_84D71427)
Date: Wed, 19 Dec 2012 10:35:22 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Stanislaw Gruszka <stf_xl@wp.pl>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Golle <dgolle@allnet.de>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 2/2] rt2x00: rt2800pci: allow to load EEPROM
 data via firmware API
References: <1355847743-16659-1-git-send-email-juhosg@openwrt.org> <1355847743-16659-2-git-send-email-juhosg@openwrt.org> <20121218222226.GB4825@localhost.localdomain>
In-Reply-To: <20121218222226.GB4825@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012.12.18. 23:22 keltezéssel, Stanislaw Gruszka írta:
> On Tue, Dec 18, 2012 at 05:22:23PM +0100, Gabor Juhos wrote:
>> Currently the driver fetches the EEPROM data
>> from a fixed memory location for SoC devices
>> for SoC devices with a built-in wireless MAC.
>>
>> The usability of this approach is quite
>> limited, because it is only suitable if the
>> location of the EEPROM data is mapped into
>> the memory. This condition is true on embedded
>> boards equipped which are using a parallel NOR
>> flash, but it is not true for boards equipped
>> with SPI or NAND flashes. The fixed location
>> also does not work in all cases, because the
>> offset of the EEPROM data varies between
>> different boards.
>>
>> Additionally, various embedded boards are using
>> a PCI/PCIe chip soldered directly onto the PCB.
>> Such boards usually does not have a separate
>> EEPROM chip for the PCI/PCIe devices, the data
>> of the EEPROM is stored in the main flash
>> instead.
>>
>> The patch makes it possible to load the EEPROM
>> data via firmware API. This new method works
>> regardless of the type of the flash, and it is
>> usable with built-in and with PCI/PCIe devices.
>>
>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> 
> I understand this patch will not broke NOR boards, which use
> ioremap approach currently?

The change will break those obviously, so those boards must be converted to use
the new method. I have added sanity check into the 'rt2800soc_probe' function
which ensures that the users of such boards will be informed about that. FWIW,
that approach is used by out-of-tree boards only.

>> +	init_completion(&ec.complete);
>> +	retval = request_firmware_nowait(THIS_MODULE, 1, name,
>> +					 rt2x00dev->dev, GFP_KERNEL, &ec,
>> +					 rt2800pci_eeprom_request_cb);
>> +	if (retval < 0) {
>> +		ERROR(rt2x00dev, "EEPROM request failed\n");
>> +		return retval;
>> +	}
>> +
>> +	wait_for_completion(&ec.complete);
> Since we use completion here, why we can not just use normal synchronous
> version of request_firmware? I heard of request_firmware drawbacks, so
> this approach can be correct. Just want to know if we do not complicate
> things not necessarily here.

If the driver is built into the kernel, then the synchronous version would fail
because user-space is not up during probe time.

The initial version of the patch used the synchronous version, but Gertjan had
concerns about that:

http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2012-December/005526.html

>> +		goto release_eeprom;
>> +	}
>> +
>> +	memcpy(rt2x00dev->eeprom, ec.blob->data, EEPROM_SIZE);
>> +	retval = 0;
>> +
>> +release_eeprom:
> We do not free memory - I guess we should do relase_firmware(ec.blob)?

Yes. I'm sure that I have added that call once, but it seems lost in the rebase
process. Will send and updated version.

Thank you for the comments!

-Gabor
