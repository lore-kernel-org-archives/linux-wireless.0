Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:48125 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752658AbYECN2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 09:28:16 -0400
Received: from mailgate.roxsoft.co.uk ([80.177.246.34] helo=[128.0.0.8])
	by anchor-post-37.mail.demon.net with esmtp (Exim 4.68)
	id 1JsHmf-0000CA-P4
	for linux-wireless@vger.kernel.org; Sat, 03 May 2008 13:28:14 +0000
Message-ID: <481C6864.40308@RoxSoft.co.uk> (sfid-20080503_152759_790365_4A8EA964)
Date: Sat, 03 May 2008 14:28:04 +0100
From: Peter Flanigan <pjf@RoxSoft.co.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Unexpected disassociations iwl3945 v1.2.25
Content-Type: multipart/mixed;
 boundary="------------050809070102030707060604"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050809070102030707060604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

As you know this driver replaced ipw3945 in the Ubuntu 8.04 LTS release. 
It is  randomly disassociating connections on my IBM Thinkpad Z61m. 
Attached is the relevant sections of dmesg output which covers a cold 
boot, a hibernate/resume cycle, and a couple of unexpected drops. The 
lines ending reason=6 were probably me experimenting unsuccessfully with 
the open/restricted security setting. This system has been running on 
the old driver for 10 months no problems. My cell is the only cell 
displayed on the iwlist scan output and the iwconfig output is 
reproduced below

wlan0     IEEE 802.11g  ESSID:"RoxSoft Prime"  Nickname:"RoxSoft Prime"
          Mode:Managed  Frequency:2.437 GHz  Access Point: 00:09:5B:5B:5D:EF
          Bit Rate=11 Mb/s   Tx-Power=27 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2346 B
          Encryption key:<was my hex key WEP string>
          Power Management:off
          Link Quality=80/100  Signal level=-54 dBm  Noise level=-127 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

This link quality figure is typical, there is only one WAP and one 
laptop in this system. I think I have fixed all the issues relating to 
the change from eth1 to wlan0

Regards


--------------050809070102030707060604
Content-Type: text/plain;
 name="iwl3945_dmesg_output"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iwl3945_dmesg_output"

[   38.596680] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.25
[   38.596816] iwl3945: Copyright(c) 2003-2007 Intel Corporation
[   38.607896] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
[   38.608185] PCI: Setting latency timer of device 0000:03:00.0 to 64
[   38.608204] iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connection
[   38.731065] intel_rng: FWH not detected
[   38.750318] wmaster0: Selected rate control algorithm 'iwl-3945-rs'

[  431.739523] NET: Registered protocol family 17
[  431.988654] ACPI: PCI interrupt for device 0000:03:00.0 disabled
[  431.997073] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
[  431.997199] PM: Writing back config space on device 0000:03:00.0 at offset 1 (was 100102, writing 100106)
[  432.039789] Registered led device: iwl-phy0:RX
[  432.039809] Registered led device: iwl-phy0:TX
[  432.277944] wlan0: privacy configuration mismatch and mixed-cell disabled - disassociate
[  436.324651] ACPI: PCI interrupt for device 0000:03:00.0 disabled
[  436.330024] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
[  436.330152] PM: Writing back config space on device 0000:03:00.0 at offset 1 (was 100102, writing 100106)
[  436.375808] Registered led device: iwl-phy0:RX
[  436.375826] Registered led device: iwl-phy0:TX
[  436.473193] wlan0: Initial auth_alg=0
[  436.473202] wlan0: authenticate with AP 00:09:5b:5b:5d:ef
[  436.474947] wlan0: RX authentication from 00:09:5b:5b:5d:ef (alg=0 transaction=2 status=0)
[  436.474950] wlan0: authenticated
[  436.474952] wlan0: associate with AP 00:09:5b:5b:5d:ef
[  436.477725] wlan0: RX AssocResp from 00:09:5b:5b:5d:ef (capab=0x11 status=0 aid=26)
[  436.477728] wlan0: associated

[   48.893166] PM: Writing back config space on device 0000:03:00.0 at offset 1 (was 100106, writing 100102)
[   48.893259] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21

[   67.243854] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.25
[   67.243859] iwl3945: Copyright(c) 2003-2007 Intel Corporation
[   67.243968] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
[   67.243988] PCI: Setting latency timer of device 0000:03:00.0 to 64
[   67.244006] iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connection
[   67.360682] wmaster0: Selected rate control algorithm 'iwl-3945-rs'

[   68.459359] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
[   69.260711] iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
[   69.263859] Registered led device: iwl-phy0:RX
[   69.263876] Registered led device: iwl-phy0:TX
[   72.106784] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
[   72.153932] Registered led device: iwl-phy0:RX
[   72.153951] Registered led device: iwl-phy0:TX
[   72.161095] wlan0: Initial auth_alg=0
[   72.161099] wlan0: authenticate with AP 00:09:5b:5b:5d:ef
[   72.163150] wlan0: RX authentication from 00:09:5b:5b:5d:ef (alg=0 transaction=2 status=0)
[   72.163154] wlan0: authenticated
[   72.163156] wlan0: associate with AP 00:09:5b:5b:5d:ef
[   72.165636] wlan0: RX AssocResp from 00:09:5b:5b:5d:ef (capab=0x11 status=0 aid=2)
[   72.165639] wlan0: associated
[ 1985.582400] iwl3945: Microcode SW error detected.  Restarting 0x82000008.
[ 1985.582412] iwl3945: Error Reply type 0x00000005 cmd REPLY_TX (0x1C) seq 0x0217 ser 0x0000004B
[ 1986.575941] iwl3945: Can't stop Rx DMA.
[ 1986.733970] Registered led device: iwl-phy0:RX
[ 1986.733990] Registered led device: iwl-phy0:TX
[ 7124.165146] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
[ 7124.210259] Registered led device: iwl-phy0:RX
[ 7124.210277] Registered led device: iwl-phy0:TX
[ 7124.430342] wlan0: privacy configuration mismatch and mixed-cell disabled - disassociate
[ 7128.442336] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
[ 7128.485648] Registered led device: iwl-phy0:RX
[ 7128.485666] Registered led device: iwl-phy0:TX
[ 7128.523237] wlan0: Initial auth_alg=0
[ 7128.523243] wlan0: authenticate with AP 00:09:5b:5b:5d:ef
[ 7128.719474] wlan0: authenticate with AP 00:09:5b:5b:5d:ef
[ 7128.721210] wlan0: RX authentication from 00:09:5b:5b:5d:ef (alg=0 transaction=2 status=0)
[ 7128.721214] wlan0: authenticated
[ 7128.721216] wlan0: associate with AP 00:09:5b:5b:5d:ef
[ 7128.723886] wlan0: RX AssocResp from 00:09:5b:5b:5d:ef (capab=0x11 status=0 aid=3)
[ 7128.723889] wlan0: associated
[10920.956092] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
[10921.002343] Registered led device: iwl-phy0:RX
[10921.002362] Registered led device: iwl-phy0:TX
[10921.294750] wlan0: privacy configuration mismatch and mixed-cell disabled - disassociate
[10926.892798] wlan0: RX deauthentication from 00:09:5b:5b:5d:ef (reason=6)
[10926.892803] wlan0: deauthenticated
[10926.892807] wlan0: RX deauthentication from 00:09:5b:5b:5d:ef (reason=6)

[10926.892895] wlan0: RX deauthentication from 00:09:5b:5b:5d:ef (reason=6)
[10926.893825] wlan0: Initial auth_alg=0
[10926.893829] wlan0: authenticate with AP 00:09:5b:5b:5d:ef
[10926.895567] wlan0: RX authentication from 00:09:5b:5b:5d:ef (alg=0 transaction=2 status=0)
[10926.895570] wlan0: authenticated
[10926.895573] wlan0: associate with AP 00:09:5b:5b:5d:ef
[10926.898310] wlan0: RX AssocResp from 00:09:5b:5b:5d:ef (capab=0x11 status=0 aid=4)
[10926.898313] wlan0: associated
[10927.081668] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
[10927.123077] Registered led device: iwl-phy0:RX
[10927.123111] Registered led device: iwl-phy0:TX
[10972.477393] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
[10972.519593] Registered led device: iwl-phy0:RX
[10972.519612] Registered led device: iwl-phy0:TX
[10972.755800] wlan0: privacy configuration mismatch and mixed-cell disabled - disassociate
[10978.343720] wlan0: RX deauthentication from 00:09:5b:5b:5d:ef (reason=6)
[10978.343725] wlan0: deauthenticated
[10978.343729] wlan0: RX deauthentication from 00:09:5b:5b:5d:ef (reason=6)

[10978.343797] wlan0: RX deauthentication from 00:09:5b:5b:5d:ef (reason=6)
[10978.343808] wlan0: privacy configuration mismatch and mixed-cell disabled - disassociate
[10978.344513] wlan0: RX deauthentication from 00:09:5b:5b:5d:ef (reason=6)
[10979.099569] wlan0: Initial auth_alg=0
[10979.099574] wlan0: authenticate with AP 00:09:5b:5b:5d:ef
[10979.101567] wlan0: RX authentication from 00:09:5b:5b:5d:ef (alg=0 transaction=2 status=0)
[10979.101570] wlan0: authenticated
[10979.101572] wlan0: associate with AP 00:09:5b:5b:5d:ef
[10979.104097] wlan0: RX AssocResp from 00:09:5b:5b:5d:ef (capab=0x11 status=0 aid=5)
[10979.104100] wlan0: associated
[10979.265951] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
[10979.309017] Registered led device: iwl-phy0:RX
[10979.309035] Registered led device: iwl-phy0:TX
[11003.376394] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
[11003.419100] Registered led device: iwl-phy0:RX
[11003.419118] Registered led device: iwl-phy0:TX
[11003.653189] wlan0: privacy configuration mismatch and mixed-cell disabled - disassociate
[11009.451872] wlan0: RX deauthentication from 00:09:5b:5b:5d:ef (reason=6)
[11009.451877] wlan0: deauthenticated
[11009.451880] wlan0: RX deauthentication from 00:09:5b:5b:5d:ef (reason=6)

[11009.451952] wlan0: RX deauthentication from 00:09:5b:5b:5d:ef (reason=6)
[11009.451956] wlan0: privacy configuration mismatch and mixed-cell disabled - disassociate
[11009.455695] wlan0: RX deauthentication from 00:09:5b:5b:5d:ef (reason=6)

[11015.379268] wlan0: RX deauthentication from 00:09:5b:5b:5d:ef (reason=6)
[11015.379281] wlan0: privacy configuration mismatch and mixed-cell disabled - disassociate
[11015.379993] wlan0: RX deauthentication from 00:09:5b:5b:5d:ef (reason=6)
[11016.339796] wlan0: Initial auth_alg=0
[11016.339801] wlan0: authenticate with AP 00:09:5b:5b:5d:ef
[11016.341537] wlan0: RX authentication from 00:09:5b:5b:5d:ef (alg=0 transaction=2 status=0)
[11016.341540] wlan0: authenticated
[11016.341542] wlan0: associate with AP 00:09:5b:5b:5d:ef
[11016.343826] wlan0: RX AssocResp from 00:09:5b:5b:5d:ef (capab=0x11 status=0 aid=6)
[11016.343829] wlan0: associated
[11016.485777] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
[11016.531874] Registered led device: iwl-phy0:RX
[11016.531892] Registered led device: iwl-phy0:TX
[11172.175116] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
[11172.220930] Registered led device: iwl-phy0:RX
[11172.220949] Registered led device: iwl-phy0:TX
[11181.077930] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
[11181.122569] Registered led device: iwl-phy0:RX
[11181.122587] Registered led device: iwl-phy0:TX
[11181.362319] wlan0: privacy configuration mismatch and mixed-cell disabled - disassociate
[11186.250056] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
[11186.296212] Registered led device: iwl-phy0:RX
[11186.296233] Registered led device: iwl-phy0:TX
[11186.376044] wlan0: Initial auth_alg=0
[11186.376050] wlan0: authenticate with AP 00:09:5b:5b:5d:ef
[11186.377791] wlan0: RX authentication from 00:09:5b:5b:5d:ef (alg=0 transaction=2 status=0)
[11186.377794] wlan0: authenticated
[11186.377796] wlan0: associate with AP 00:09:5b:5b:5d:ef
[11186.380079] wlan0: RX AssocResp from 00:09:5b:5b:5d:ef (capab=0x11 status=0 aid=7)
[11186.380082] wlan0: associated

--------------050809070102030707060604--
