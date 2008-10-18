Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar.linta.de ([213.133.102.198]:50732 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751120AbYJRXKt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2008 19:10:49 -0400
Date: Sun, 19 Oct 2008 01:10:46 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: 2.6.28-rc regression: Can't stop Rx DMA
Message-ID: <20081018231046.GA10977@isilmar.linta.de> (sfid-20081019_011055_153900_643DA88C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

with current Linus' tree, I cannot connet my notebook to the AP any more.

02:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network Connection (rev 02)
	Subsystem: Intel Corporation PRO/Wireless 3945ABG Network Connection
	Flags: bus master, fast devsel, latency 0, IRQ 380
	Memory at f0300000 (32-bit, non-prefetchable) [size=4K]

[   20.645198] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26ks
[   20.645337] iwl3945: Copyright(c) 2003-2008 Intel Corporation
[   20.645767] iwl3945 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   20.645913] iwl3945 0000:02:00.0: setting latency timer to 64
[   20.645996] iwl3945: Detected Intel Wireless WiFi Link 3945ABG
[   20.708706] iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
[   20.712625] phy0: Selected rate control algorithm 'iwl-3945-rs'
[   20.733199] iwl3945 0000:02:00.0: PCI INT A disabled
...
[   34.824476] iwl3945 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   34.824637] iwl3945 0000:02:00.0: restoring config space at offset 0x1 (was 0x100102, writing 0x100106)
[   34.825269] iwl3945 0000:02:00.0: firmware: requesting iwlwifi-3945-1.ucode
[   37.340901] iwl3945: Microcode SW error detected.  Restarting 0x82000008.
[   37.340944] iwl3945: Error Reply type 0x00000005 cmd REPLY_SCAN_CMD (0x80) seq 0x4413 ser 0x0000004B
[   37.342349] iwl3945: Can't stop Rx DMA.

The iwlwifi-3945-1.ucode is the one shipped with Ubuntu's 2.6.24-21-generic
kernel sources (md5sum: 26d10014b09439dc5a8573c2a6f85b0a ). And, as
mentioned in the subject, 2.6.27 or 2.6.26 work perfectly fine.

Oh, and the .config:

CONFIG_IWLWIFI=y
CONFIG_IWLCORE=y
# CONFIG_IWLWIFI_LEDS is not set
CONFIG_IWLWIFI_RFKILL=y
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLAGN is not set
CONFIG_IWL3945=m
CONFIG_IWL3945_RFKILL=y
CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
# CONFIG_IWL3945_LEDS is not set
# CONFIG_IWL3945_DEBUG is not set

Any ideas? Patches to test? Thanks!

Best,
	Dominik
