Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:35615 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbYJ2At1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 20:49:27 -0400
Received: by ug-out-1314.google.com with SMTP id 39so452047ugf.37
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 17:49:25 -0700 (PDT)
Message-ID: <4907B30E.90109@gmail.com> (sfid-20081029_014931_381358_4E25664F)
Date: Wed, 29 Oct 2008 00:49:18 +0000
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-wireless@vger.kernel.org, linux-pcmcia@lists.infradead.org,
	orinoco-devel@lists.sourceforge.net
Subject: Re: [Orinoco-devel] 2.6.28-rc2: new PCMCIA device instance after
 resume - orinoco can't download firmware
References: <200810282219.51492.arvidjaar@mail.ru>
In-Reply-To: <200810282219.51492.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Borzenkov wrote:
> I am running PCMCIA based orinoco with WPA support (external firmware)
> and two patches to cache it after request_firmware to use in resume.
> 
> This worked fine in 27 and wtopped working in 28-rc. The apparent difference
> I see:

I'm seeing the same, but my laptop has never resumed very well so I put
it down to the preceding errors (which you don't have):

Oct 29 00:00:17 borken Back to C!
Oct 29 00:00:17 borken ACPI: Waking up from system sleep state S3
Oct 29 00:00:17 borken ACPI Warning (nspredef-0852): \_WAK: Return type
mismatch - found Integer, expected Package [20080926]
Oct 29 00:00:17 borken agpgart-intel 0000:00:00.0: restoring config
space at offset 0x1 (was 0x22100006, writing 0x22100106)
Oct 29 00:00:17 borken pm_op(): pci_pm_resume+0x0/0x46 returns -16
Oct 29 00:00:17 borken PM: Device 0000:00:00.0 failed to resume: error -16
Oct 29 00:00:17 borken pcmcia 0.0: pcmcia: registering new device pcmcia0.0
Oct 29 00:00:17 borken dhcpcd[6661]: eth1: carrier lost
Oct 29 00:00:17 borken eth1: Hardware identity 0001:0001:0004:0002
Oct 29 00:00:17 borken eth1: Station identity  001f:0001:0008:0048
Oct 29 00:00:17 borken eth1: Firmware determined as Lucent/Agere 8.72
Oct 29 00:00:17 borken eth1: Attempting to download firmware
agere_sta_fw.bin
Oct 29 00:00:17 borken hermes_dld: AUX enable returned 0
Oct 29 00:00:17 borken hermes_dld: AUX disable returned 0
Oct 29 00:00:17 borken hermes_dld: Actual PDA length 998, Max allowed 1000
Oct 29 00:00:17 borken eth1: Read PDA returned 0
Oct 29 00:00:17 borken orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
Oct 29 00:00:17 borken eth1: Cannot find firmware agere_sta_fw.bin


Dave.

> [  617.975868] Back to C!
> [  617.987166] ACPI: Waking up from system sleep state S3
> [  618.004377] pci 0000:00:01.0: setting latency timer to 64
 <snip>
> [  619.323782] pcmcia 0.0: pcmcia: registering new device pcmcia0.0
> [  619.404234] eth1: Hardware identity 0005:0002:0001:0002
> [  619.404345] eth1: Station identity  001f:0001:0006:000e
> [  619.404356] eth1: Firmware determined as Lucent/Agere 6.14
> [  619.404369] eth1: Attempting to download firmware agere_sta_fw.bin
> [  619.404398] hermes_dld: AUX enable returned 0
> [  619.405440] hermes_dld: AUX disable returned 0
> [  619.405448] hermes_dld: Actual PDA length 998, Max allowed 1000
> [  619.405454] eth1: Read PDA returned 0
> [  619.405464] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
> [  620.257118] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
> [  620.257128] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
> [  620.272387] ata1.00: configured for UDMA/33
> [  620.272634] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors: (20.0 GB/18.6 GiB)
> [  620.272723] sd 0:0:0:0: [sda] Write Protect is off
> [  620.272733] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [  620.272861] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [  679.403515] eth1: Cannot find firmware agere_sta_fw.bin
> [  679.403593] eth1: Hardware identity 0005:0002:0001:0002
> [  679.403704] eth1: Station identity  001f:0001:0006:000e
> [  679.403714] eth1: Firmware determined as Lucent/Agere 6.14
> [  679.403721] eth1: Ad-hoc demo mode supported
> [  679.403727] eth1: IEEE standard IBSS ad-hoc mode supported
> [  679.403733] eth1: WEP supported, 104-bit key
> [  679.403856] eth1: MAC address 00:02:2d:26:95:6c
> [  679.403962] eth1: Station name "HERMES I"
> [  679.404529] eth1: ready
> [  679.405117] eth1: orinoco_cs at 0.0, irq 11, io 0x0100-0x013f
> [  679.676707] pci 0000:00:12.0: restoring config space at offset 0xf (was 0x1ff, writing 0x10b)
> [  679.676785] pci 0000:01:00.0: restoring config space at offset 0xf (was 0x1ff, writing 0x10b)
> [  679.680310] sd 0:0:0:0: [sda] Starting disk
> [  680.109195] Restarting tasks ... done.
> [  681.184812] eth1: New link status: Disconnected (0002)
> [  688.967595] eth1: New link status: Disconnected (0002)
