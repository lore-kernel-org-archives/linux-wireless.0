Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:35745 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1L3GrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Dec 2011 01:47:06 -0500
Received: from homiemail-a30.g.dreamhost.com (caiajhbdcaib.dreamhost.com [208.97.132.81])
	by hapkido.dreamhost.com (Postfix) with ESMTP id 14CA617B13C
	for <linux-wireless@vger.kernel.org>; Thu, 29 Dec 2011 22:47:06 -0800 (PST)
Received: from homiemail-a30.g.dreamhost.com (localhost [127.0.0.1])
	by homiemail-a30.g.dreamhost.com (Postfix) with ESMTP id 4C2DF21DE58
	for <linux-wireless@vger.kernel.org>; Thu, 29 Dec 2011 22:46:26 -0800 (PST)
Received: from [192.168.10.20] (pool-173-76-33-234.bstnma.fios.verizon.net [173.76.33.234])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: smtpguy@smartfruit.com)
	by homiemail-a30.g.dreamhost.com (Postfix) with ESMTPSA id E9D6221DE56
	for <linux-wireless@vger.kernel.org>; Thu, 29 Dec 2011 22:46:25 -0800 (PST)
Message-ID: <4EFD5E40.3020606@smartfruit.com> (sfid-20111230_074729_244710_27D07D31)
Date: Fri, 30 Dec 2011 01:46:24 -0500
From: Naoyuki Tai <ntai@smartfruit.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath9k: Failed to stop TX DMA!, DMA failed to stop in 10 ms
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I've spent some time on ath9k driver getting stuck.
I set up a new system with OpenWRT, and the atheros AR922X had the problem.
I've gone through http://linuxwireless.org/en/users/Drivers/ath9k/bugs, 
and decided to give a go around with newer driver.
I went the route of Debian wheezy, so that I can use the updated 
compat-wireless more easily.
The current system is
Linux ntai11d 3.1.0-1-486 #1 Sun Dec 11 19:52:34 UTC 2011 i586 GNU/Linux

# cat /etc/debian_version
wheezy/sid

I downloaded/compiled the compat-wireless-3.1.1-1.tar.bz2, installed the 
modules, set up the hostapd.
wlan0 is running the master mode with hostapd, and I can establish the 
connection from a laptop.
wlan0 is bridged to eth0, and works fine. It runs OK until I put it 
under stress.
As soon as I do something like scp to transfer a file, it chokes up with 
the DML issue.
Both the openwrt, debian get stuck the same way.

Dec 30 01:11:06 ntai11d kernel: [ 1191.038064] ath: Failed to stop TX DMA!
Dec 30 01:11:06 ntai11d kernel: [ 1191.057713] ath: DMA failed to stop 
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
Dec 30 01:11:06 ntai11d kernel: [ 1191.073555] ath: Could not stop RX, 
we could be confusing the DMA engine when we start RX up
Dec 30 01:11:06 ntai11d kernel: [ 1191.109949] ath: DMA failed to stop 
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
Dec 30 01:11:06 ntai11d kernel: [ 1191.125908] ath: Could not stop RX, 
we could be confusing the DMA engine when we start RX up

It continues until I stop the hostapd. Once this happens, the wifi 
connection dies.

# lspci -nn | grep -i atheros
00:07.0 Network controller [0280]: Atheros Communications Inc. AR922X 
Wireless Network Adapter [168c:0029] (rev 01)

Here is the system from dmidecode.
As you can see, this is a Geode LX, 500MHz system I ebayed.
It has a CompactFlash, mini PCI slot and 2 ethernet ports.

# dmidecode 2.11
SMBIOS 2.3 present.
30 structures occupying 909 bytes.
Table at 0x000F0000.

Handle 0x0000, DMI type 0, 20 bytes
BIOS Information
     Vendor: Phoenix Technologies, LTD
     Version: 6.00 PG
     Release Date: 06/01/2007
     Address: 0xE0000
     Runtime Size: 128 kB
     ROM Size: 512 kB
     Characteristics:
         ISA is supported
         PCI is supported
         PNP is supported
         APM is supported
         BIOS is upgradeable
         BIOS shadowing is allowed
         Boot from CD is supported
         Selectable boot is supported
         BIOS ROM is socketed
         EDD is supported
         5.25"/360 kB floppy services are supported (int 13h)
         5.25"/1.2 MB floppy services are supported (int 13h)
         3.5"/720 kB floppy services are supported (int 13h)
         3.5"/2.88 MB floppy services are supported (int 13h)
         Print screen service is supported (int 5h)
         8042 keyboard services are supported (int 9h)
         Serial services are supported (int 14h)
         Printer services are supported (int 17h)
         CGA/mono video services are supported (int 10h)
         ACPI is supported
         BIOS boot specification is supported

Handle 0x0001, DMI type 1, 25 bytes
System Information
     Manufacturer: MICRO-STAR INTERNATIONAL CO., LTD
     Product Name: MS-9801
     Version: 1.0A
     Serial Number:
     UUID: Not Present
     Wake-up Type: Power Switch

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
     Manufacturer: MICRO-STAR INTERNATIONAL CO., LTD
     Product Name: MS-9801
     Version: 1.0A
     Serial Number:

Handle 0x0003, DMI type 4, 35 bytes
Processor Information
     Socket Designation: Geode LX
     Type: Central Processor
     Family: 80486
     Manufacturer: AMD
     ID: A2 05 00 00 3D A9 88 00
     Signature: Type 0, Family 5, Model 10, Stepping 2
     Version: Geode GX-MMX
     Voltage: 3.3 V
     External Clock: 64 MHz
     Max Speed: 500 MHz
     Current Speed: 500 MHz
     Status: Populated, Enabled
     Upgrade: ZIF Socket
     L1 Cache Handle: 0x0007
     L2 Cache Handle: 0x0008
     L3 Cache Handle: Not Provided
     Serial Number:
     Asset Tag:
     Part Number:


-- Tai

