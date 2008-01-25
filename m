Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:5508 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbYAYBNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 20:13:17 -0500
Received: by an-out-0708.google.com with SMTP id d31so106551and.103
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2008 17:13:16 -0800 (PST)
Message-ID: <40f31dec0801241713l3c4dd74es9add7c0646d938d8@mail.gmail.com> (sfid-20080125_011321_388869_86FAFD5C)
Date: Fri, 25 Jan 2008 03:13:15 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "John Daiker" <daikerjohn@gmail.com>
Subject: Re: ath5k: 5212 / 5213A / 2413 identity crisis?
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <479934C5.3060401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <479934C5.3060401@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/1/25, John Daiker <daikerjohn@gmail.com>:
> Hello All,
>
> I've been using MadWifi since I picked up a PCMCIA card a few months
> ago.  I've tried out the ath5k driver, but can't get the card to 'iwlist
> wlan0 scan' AP's, or even connect to an unsecured AP through 'iwconfig'
> commands.
>
> I've pasted an output of my dmesg output from both MadWifi and ath5k, as
> well as lspci -v.
>
> 'sudo modprobe ath_pci'
> [ 2537.326216] ath_hal: 0.9.18.0 (AR5210, AR5211, AR5212, RF5111,
> RF5112, RF2413, RF5413)
> [ 2537.348389] wlan: 0.8.4.2 (0.9.3.3)
> [ 2537.353061] ath_pci: 0.9.4.5 (0.9.3.3)
> [ 2537.354583] ACPI: PCI Interrupt 0000:07:00.0[A] -> GSI 20 (level,
> low) -> IRQ 20
> [ 2537.620439] ath_rate_sample: 1.2 (0.9.3.3)
> [ 2537.636510] wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
> [ 2537.636704] wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps
> 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
> [ 2537.636947] wifi0: H/W encryption support: WEP AES AES_CCM TKIP
> [ 2537.637108] wifi0: mac 7.8 phy 4.5 radio 5.6
> [ 2537.637240] wifi0: Use hw queue 1 for WME_AC_BE traffic
> [ 2537.637370] wifi0: Use hw queue 0 for WME_AC_BK traffic
> [ 2537.637554] wifi0: Use hw queue 2 for WME_AC_VI traffic
> [ 2537.637685] wifi0: Use hw queue 3 for WME_AC_VO traffic
> [ 2537.637816] wifi0: Use hw queue 8 for CAB traffic
> [ 2537.637952] wifi0: Use hw queue 9 for beacons
> [ 2537.643490] wifi0: Atheros 5212: mem=0x54000000, irq=20
> [ 2537.647060] net wlan0: device_rename: sysfs_create_symlink failed (-17)
>
> 'sudo modprobe ath5k'
> [ 2590.373989] ACPI: PCI Interrupt 0000:07:00.0[A] -> GSI 20 (level,
> low) -> IRQ 20
> [ 2590.374333] ath5k_pci 0000:07:00.0: registered as 'phy7'
> [ 2590.446657] phy7: Selected rate control algorithm 'simple'
> [ 2590.471263] ath5k phy7: Atheros AR5213A chip found (MAC: 0x78, PHY: 0x45)
> [ 2590.471450] ath5k phy7: RF2112A 2GHz radio found (0x56)
> [ 2590.485529] HW CONFIG: channel=1 freq=2412 phymode=2
> [ 2590.523213] HW CONFIG: channel=1 freq=2412 phymode=2
> [ 2590.538549] phy7: TX to low-level driver (len=40) FC=0x0040
> DUR=0x0000 A1=ff:ff:ff:ff:ff:ff A2=00:13:46:d7:7f:c7 A3=ff:ff:ff:ff:ff:ff
> [ 2590.550964] HW CONFIG: channel=2 freq=2417 phymode=2
> [ 2590.579394] phy7: TX to low-level driver (len=40) FC=0x0040
> DUR=0x0000 A1=ff:ff:ff:ff:ff:ff A2=00:13:46:d7:7f:c7 A3=ff:ff:ff:ff:ff:ff
> [ 2590.591820] HW CONFIG: channel=3 freq=2422 phymode=2
> [ 2590.620239] phy7: TX to low-level driver (len=40) FC=0x0040
> DUR=0x0000 A1=ff:ff:ff:ff:ff:ff A2=00:13:46:d7:7f:c7 A3=ff:ff:ff:ff:ff:ff
> [ 2590.632661] HW CONFIG: channel=4 freq=2427 phymode=2
> [ 2590.661093] phy7: TX to low-level driver (len=40) FC=0x0040
> DUR=0x0000 A1=ff:ff:ff:ff:ff:ff A2=00:13:46:d7:7f:c7 A3=ff:ff:ff:ff:ff:ff
> [ 2590.673503] HW CONFIG: channel=5 freq=2432 phymode=2
> [ 2590.701934] phy7: TX to low-level driver (len=40) FC=0x0040
> DUR=0x0000 A1=ff:ff:ff:ff:ff:ff A2=00:13:46:d7:7f:c7 A3=ff:ff:ff:ff:ff:ff
> [ 2590.714368] HW CONFIG: channel=6 freq=2437 phymode=2
> [ 2590.742785] phy7: TX to low-level driver (len=40) FC=0x0040
> DUR=0x0000 A1=ff:ff:ff:ff:ff:ff A2=00:13:46:d7:7f:c7 A3=ff:ff:ff:ff:ff:ff
> [ 2590.755208] HW CONFIG: channel=7 freq=2442 phymode=2
> [ 2590.783636] phy7: TX to low-level driver (len=40) FC=0x0040
> DUR=0x0000 A1=ff:ff:ff:ff:ff:ff A2=00:13:46:d7:7f:c7 A3=ff:ff:ff:ff:ff:ff
> [ 2590.796057] HW CONFIG: channel=8 freq=2447 phymode=2
> [ 2590.826261] phy7: TX to low-level driver (len=40) FC=0x0040
> DUR=0x0000 A1=ff:ff:ff:ff:ff:ff A2=00:13:46:d7:7f:c7 A3=ff:ff:ff:ff:ff:ff
> [ 2590.838685] HW CONFIG: channel=9 freq=2452 phymode=2
> [ 2590.867125] phy7: TX to low-level driver (len=40) FC=0x0040
> DUR=0x0000 A1=ff:ff:ff:ff:ff:ff A2=00:13:46:d7:7f:c7 A3=ff:ff:ff:ff:ff:ff
> [ 2590.879533] HW CONFIG: channel=10 freq=2457 phymode=2
> [ 2590.907962] phy7: TX to low-level driver (len=40) FC=0x0040
> DUR=0x0000 A1=ff:ff:ff:ff:ff:ff A2=00:13:46:d7:7f:c7 A3=ff:ff:ff:ff:ff:ff
> [ 2590.920383] HW CONFIG: channel=11 freq=2462 phymode=2
> [ 2590.950586] phy7: TX to low-level driver (len=40) FC=0x0040
> DUR=0x0000 A1=ff:ff:ff:ff:ff:ff A2=00:13:46:d7:7f:c7 A3=ff:ff:ff:ff:ff:ff
> [ 2590.963012] HW CONFIG: channel=1 freq=2412 phymode=2
>
> 'lspci -v'
> 07:00.0 Ethernet controller: Atheros Communications, Inc. AR2413
> 802.11bg NIC (rev 01)
>         Subsystem: D-Link System Inc AirPlus G DWL-G630
>         Flags: bus master, medium devsel, latency 168, IRQ 20
>         Memory at 54000000 (32-bit, non-prefetchable) [size=64K]
>         Capabilities: <access denied>
>
>
> Seems as if there is a discrepancy between:
>     MadWifi    (reporting an Atheros 5212)
>     ath5k      (reporting an Atheros AR5213A chip with a RF2112A radio)
>     lspci -v   (reporting an Atheros AR2413 chip)
>
>
> I can help debug any possible solution to this.
>
> John Daiker
>
> PS> Sorry for the verbosity... just wanted all the info out there.

Thanx a lot for your input, it's a known problem and we are working on
it. We 'll soon start working on a 2413 card compex donated to us and
hopefully come up with a patch.

About chip's identity we don't identify chips by pci ids since vendors
sometimes use faulty pci ids. You can see in the logs that your mac
revision id is 0x7* and your radio revision id is 0x56, these values
match 2413/2414 cards. We already updated ath_info tool for this, a
patch series is pending for the driver (i have exams right now -again
:P-, sorry for the delay).

--
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
