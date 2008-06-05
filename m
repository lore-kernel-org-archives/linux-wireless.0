Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51154 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbYFECKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 22:10:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Subject: RE: Problems with iwl3945 module
Date: Thu, 5 Jun 2008 10:10:01 +0800
Message-ID: <8AD95083DC3E36478732061D97524415033FE0B5@pdsmsx411.ccr.corp.intel.com> (sfid-20080605_041048_380087_C321F8F2)
In-Reply-To: <4846E57A.9000005@fbqf.unt.edu.ar>
References: <4846E57A.9000005@fbqf.unt.edu.ar>
From: "Zhu, Yi" <yi.zhu@intel.com>
To: "Cesar Luis Avila" <cavila@fbqf.unt.edu.ar>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



The HW RF Kill switch is enabled. You have to disable it in some way. I=
t looks like your hotkey Fn-F2 doesn=A1=AFt work. Please take a look at=
 http://rfswitch.sourceforge.net/

Thanks,
-yi

-----Original Message-----
=46rom: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-own=
er@vger.kernel.org] On Behalf Of Cesar Luis Avila
Sent: 2008=C4=EA6=D4=C25=C8=D5 2:57
To: linux-wireless@vger.kernel.org
Subject: Problems with iwl3945 module

Dear all,
I have an Intel Pro Wireless 3945 card installed on my laptop
03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG=20
Network Connection (rev 02)
I am running Debian Lenny (kernel 2.6.24-1). I tried to use the iwlwifi=
=20
modules that came with the kernel without success. I downloaded and=20
compiled  compat-wireless-2008-06-04  modules. After make install and=20
make load, I kept receiving the following messages on syslog

Jun  4 15:43:32 cesar kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GS=
I=20
17 (level, low) -> IRQ 17
Jun  4 15:43:32 cesar kernel: iwl3945: Radio disabled by HW RF Kill swi=
tch
Jun  4 15:43:34 cesar NetworkManager: <WARN> =20
nm_device_802_11_wireless_scan(): (wlan0): could not trigger wireless=20
scan: Network is down

I tried to enable the wireless card with Fn-F2, but the wireless led=20
only blinks once, and nothing else seems to happen.
This is the full report after I modprobe iwl3945
Jun  4 15:50:37 cesar kernel: iwl3945: Intel(R) PRO/Wireless 3945ABG/BG=
=20
Network Connection driver for Linux, 1.2.26k
Jun  4 15:50:37 cesar kernel: iwl3945: Copyright(c) 2003-2008 Intel=20
Corporation
Jun  4 15:50:37 cesar kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GS=
I=20
17 (level, low) -> IRQ 17
Jun  4 15:50:37 cesar kernel: PCI: Setting latency timer of device=20
0000:03:00.0 to 64
Jun  4 15:50:37 cesar kernel: iwl3945: Detected Intel Wireless WiFi Lin=
k=20
3945BG
Jun  4 15:50:37 cesar kernel: iwl3945: Tunable channels: 13 802.11bg, 0=
=20
802.11a channels
Jun  4 15:50:37 cesar kernel: phy0: Selected rate control algorithm=20
'iwl-3945-rs'
Jun  4 15:50:37 cesar NetworkManager: <debug> [1212605437.271359]=20
nm_hal_device_added(): New device added (hal udi is=20
'/org/freedesktop/Hal/devices/net_00_1b_77_76_07_ac').
Jun  4 15:50:37 cesar NetworkManager: <debug> [1212605437.289405]=20
nm_hal_device_added(): New device added (hal udi is=20
'/org/freedesktop/Hal/devices/net_00_1b_77_76_07_ac_0').
Jun  4 15:50:37 cesar kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GS=
I=20
17 (level, low) -> IRQ 17
Jun  4 15:50:37 cesar kernel: iwl3945: Radio disabled by HW RF Kill swi=
tch
Jun  4 15:50:39 cesar NetworkManager: <info>  wlan0: Device is=20
fully-supported using driver 'iwl3945'.
Jun  4 15:50:39 cesar NetworkManager: <info>  wlan0: driver supports=20
SSID scans (scan_capa 0x01).
Jun  4 15:50:39 cesar NetworkManager: <info>  nm_device_init(): waiting=
=20
for device's worker thread to start
Jun  4 15:50:39 cesar NetworkManager: <info>  nm_device_init(): device'=
s=20
worker thread started, continuing.
Jun  4 15:50:39 cesar NetworkManager: <info>  Now managing wireless=20
(802.11) device 'wlan0'.
Jun  4 15:50:39 cesar NetworkManager: <info>  Deactivating device wlan0=
=2E
Jun  4 15:50:39 cesar kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GS=
I=20
17 (level, low) -> IRQ 17
Jun  4 15:50:39 cesar kernel: iwl3945: Radio disabled by HW RF Kill swi=
tch
Jun  4 15:50:41 cesar NetworkManager: <WARN> =20
nm_device_802_11_wireless_scan(): (wlan0): could not trigger wireless=20
scan: Network is down

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
