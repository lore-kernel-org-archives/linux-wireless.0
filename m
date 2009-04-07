Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:40291 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbZDGStA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 14:49:00 -0400
Received: by fxm2 with SMTP id 2so2466040fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 07 Apr 2009 11:48:58 -0700 (PDT)
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: yi.zhu@intel.com
Subject: 2.6.29 linus tree: iwlagn  Failed to register hw (error -2) on first try. Success on unload and retry
Date: Tue, 7 Apr 2009 22:48:56 +0200
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Message-Id: <200904072248.56413.a.miskiewicz@gmail.com> (sfid-20090407_204908_564470_22DBD0C0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

Some recent commits (in last 2 days I guess) broke iwlagn driver.
Using Linus tree as of aeeae86859f4319de0a4946b44771d9926eeed54

[    5.431753] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux=
, 1.3.27ks
[    5.431755] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[    5.431836] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) ->=
 IRQ 17
[    5.431863] iwlagn 0000:03:00.0: setting latency timer to 64
[    5.431965] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5=
350AGN REV=3D0x24
[    5.451117] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 8=
02.11a channels
[    5.451202] iwlagn 0000:03:00.0: irq 30 for MSI/MSI-X
[    5.451591] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    5.458313] phy0: Failed to initialize wep: -2
[    5.489134] iwlagn 0000:03:00.0: Failed to register hw (error -2)
[    5.489214] iwlagn 0000:03:00.0: PCI INT A disabled
[    5.489221] iwlagn: probe of 0000:03:00.0 failed with error -2

but later I can rmmod iwlagn, modprobe iwlagnt and it starts working

[ 6081.289816] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux=
, 1.3.27ks
[ 6081.289823] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[ 6081.289961] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) ->=
 IRQ 17
[ 6081.289980] iwlagn 0000:03:00.0: setting latency timer to 64
[ 6081.290048] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5=
350AGN REV=3D0x24
[ 6081.311015] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 8=
02.11a channels
[ 6081.311135] iwlagn 0000:03:00.0: irq 31 for MSI/MSI-X
[ 6081.315120] phy1: Selected rate control algorithm 'iwl-agn-rs'
[ 6081.352904] udev: renamed network interface wlan0 to eth1
[ 6081.412073] lo: Disabled Privacy Extensions
[ 6081.456266] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[ 6081.512131] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[ 6081.512781] ADDRCONF(NETDEV_UP): eth0: link is not ready
[ 6087.465024] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-1=
=2Eucode
[ 6087.508361] iwlagn 0000:03:00.0: loaded firmware version 5.4.1.16
[ 6087.663653] Registered led device: iwl-phy1::radio
[ 6087.663709] Registered led device: iwl-phy1::assoc
[ 6087.663760] Registered led device: iwl-phy1::RX
[ 6087.663812] Registered led device: iwl-phy1::TX
[ 6087.684486] ADDRCONF(NETDEV_UP): eth1: link is not ready
[ 6088.796677] eth1: authenticate with AP 00:11:22:33:44:57
[ 6088.798752] eth1: authenticated
[ 6088.798758] eth1: associate with AP 00:11:22:33:44:57
[ 6088.801710] eth1: RX AssocResp from 00:11:22:33:44:57 (capab=3D0x411=
 status=3D0 aid=3D1)
[ 6088.801745] eth1: associated
[ 6088.809628] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[ 6088.810615] eth1: authenticate with AP 00:11:22:33:44:57
[ 6088.817482] eth1: authenticated
[ 6088.817488] eth1: associate with AP 00:11:22:33:44:57
[ 6088.820115] eth1: RX ReassocResp from 00:11:22:33:44:57 (capab=3D0x4=
11 status=3D0 aid=3D1)
[ 6088.820121] eth1: associated

relevant /proc/interrupts
 30:      40965          0   PCI-MSI-edge      i915
 31:       7515       7589   PCI-MSI-edge      iwlagn

but i915 was registering later

[arekm@t400 /usr/src/linux-git]$ dmesg|grep -E "(iwl|i915)"
[    5.431753] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux=
, 1.3.27ks
[    5.431755] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[    5.431836] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) ->=
 IRQ 17
[    5.431863] iwlagn 0000:03:00.0: setting latency timer to 64
[    5.431965] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5=
350AGN REV=3D0x24
[    5.451117] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 8=
02.11a channels
[    5.451202] iwlagn 0000:03:00.0: irq 30 for MSI/MSI-X
[    5.451591] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    5.489134] iwlagn 0000:03:00.0: Failed to register hw (error -2)
[    5.489214] iwlagn 0000:03:00.0: PCI INT A disabled
[    5.489221] iwlagn: probe of 0000:03:00.0 failed with error -2
[   36.476810] i915 0000:00:02.0: power state changed by ACPI to D0
[   36.476828] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[   36.476837] i915 0000:00:02.0: setting latency timer to 64
[   36.519222] i915 0000:00:02.0: irq 30 for MSI/MSI-X
[   37.572136] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 o=
n minor 0
[ 6081.289816] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux=
, 1.3.27ks
[ 6081.289823] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[ 6081.289961] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) ->=
 IRQ 17
[ 6081.289980] iwlagn 0000:03:00.0: setting latency timer to 64
[ 6081.290048] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5=
350AGN REV=3D0x24
[ 6081.311015] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 8=
02.11a channels
[ 6081.311135] iwlagn 0000:03:00.0: irq 31 for MSI/MSI-X
[ 6081.315120] phy1: Selected rate control algorithm 'iwl-agn-rs'
[ 6087.465024] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-1=
=2Eucode
[ 6087.508361] iwlagn 0000:03:00.0: loaded firmware version 5.4.1.16
[ 6087.663653] Registered led device: iwl-phy1::radio
[ 6087.663709] Registered led device: iwl-phy1::assoc
[ 6087.663760] Registered led device: iwl-phy1::RX
[ 6087.663812] Registered led device: iwl-phy1::TX

CONFIG_IWLWIFI=3Dm
CONFIG_IWLWIFI_LEDS=3Dy
CONFIG_IWLWIFI_RFKILL=3Dy
CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT=3Dy
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLAGN=3Dm
# CONFIG_IWL4965 is not set
CONFIG_IWL5000=3Dy
# CONFIG_IWL3945 is not set

03:00.0 Network controller: Intel Corporation PRO/Wireless 5350 AGN [Ec=
ho Peak] Network Connection

--=20
Arkadiusz Mi=C5=9Bkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
