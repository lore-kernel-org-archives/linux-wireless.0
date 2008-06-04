Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.unt.edu.ar ([200.45.169.10]:55290 "EHLO
	webmail.unt.edu.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763819AbYFDWRk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 18:17:40 -0400
Received: from [10.1.4.213] (squid.unt.edu.ar [200.45.169.27])
	by webmail.unt.edu.ar (Postfix) with ESMTP id 6C7F13346EE
	for <linux-wireless@vger.kernel.org>; Wed,  4 Jun 2008 18:56:55 -0300 (ART)
Message-ID: <4846E57A.9000005@fbqf.unt.edu.ar> (sfid-20080605_001814_223740_F8905318)
Date: Wed, 04 Jun 2008 15:56:58 -0300
From: Cesar Luis Avila <cavila@fbqf.unt.edu.ar>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Problems with iwl3945 module
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,
I have an Intel Pro Wireless 3945 card installed on my laptop
03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG 
Network Connection (rev 02)
I am running Debian Lenny (kernel 2.6.24-1). I tried to use the iwlwifi 
modules that came with the kernel without success. I downloaded and 
compiled  compat-wireless-2008-06-04  modules. After make install and 
make load, I kept receiving the following messages on syslog

Jun  4 15:43:32 cesar kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 
17 (level, low) -> IRQ 17
Jun  4 15:43:32 cesar kernel: iwl3945: Radio disabled by HW RF Kill switch
Jun  4 15:43:34 cesar NetworkManager: <WARN>  
nm_device_802_11_wireless_scan(): (wlan0): could not trigger wireless 
scan: Network is down

I tried to enable the wireless card with Fn-F2, but the wireless led 
only blinks once, and nothing else seems to happen.
This is the full report after I modprobe iwl3945
Jun  4 15:50:37 cesar kernel: iwl3945: Intel(R) PRO/Wireless 3945ABG/BG 
Network Connection driver for Linux, 1.2.26k
Jun  4 15:50:37 cesar kernel: iwl3945: Copyright(c) 2003-2008 Intel 
Corporation
Jun  4 15:50:37 cesar kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 
17 (level, low) -> IRQ 17
Jun  4 15:50:37 cesar kernel: PCI: Setting latency timer of device 
0000:03:00.0 to 64
Jun  4 15:50:37 cesar kernel: iwl3945: Detected Intel Wireless WiFi Link 
3945BG
Jun  4 15:50:37 cesar kernel: iwl3945: Tunable channels: 13 802.11bg, 0 
802.11a channels
Jun  4 15:50:37 cesar kernel: phy0: Selected rate control algorithm 
'iwl-3945-rs'
Jun  4 15:50:37 cesar NetworkManager: <debug> [1212605437.271359] 
nm_hal_device_added(): New device added (hal udi is 
'/org/freedesktop/Hal/devices/net_00_1b_77_76_07_ac').
Jun  4 15:50:37 cesar NetworkManager: <debug> [1212605437.289405] 
nm_hal_device_added(): New device added (hal udi is 
'/org/freedesktop/Hal/devices/net_00_1b_77_76_07_ac_0').
Jun  4 15:50:37 cesar kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 
17 (level, low) -> IRQ 17
Jun  4 15:50:37 cesar kernel: iwl3945: Radio disabled by HW RF Kill switch
Jun  4 15:50:39 cesar NetworkManager: <info>  wlan0: Device is 
fully-supported using driver 'iwl3945'.
Jun  4 15:50:39 cesar NetworkManager: <info>  wlan0: driver supports 
SSID scans (scan_capa 0x01).
Jun  4 15:50:39 cesar NetworkManager: <info>  nm_device_init(): waiting 
for device's worker thread to start
Jun  4 15:50:39 cesar NetworkManager: <info>  nm_device_init(): device's 
worker thread started, continuing.
Jun  4 15:50:39 cesar NetworkManager: <info>  Now managing wireless 
(802.11) device 'wlan0'.
Jun  4 15:50:39 cesar NetworkManager: <info>  Deactivating device wlan0.
Jun  4 15:50:39 cesar kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 
17 (level, low) -> IRQ 17
Jun  4 15:50:39 cesar kernel: iwl3945: Radio disabled by HW RF Kill switch
Jun  4 15:50:41 cesar NetworkManager: <WARN>  
nm_device_802_11_wireless_scan(): (wlan0): could not trigger wireless 
scan: Network is down

