Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:13410 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab2LPM3N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2012 07:29:13 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W . Linville" <linville@tuxdriver.com>
CC: Joe Perches <joe@perches.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v11] wireless: Driver for 60GHz card wil6210
Date: Sun, 16 Dec 2012 14:29:05 +0200
Message-ID: <21521831.ovaVWPCQVP@lx-vladimir> (sfid-20121216_132923_782036_5BBB255B)
In-Reply-To: <20121213205116.GQ15974@pogo>
References: <1355327278-12965-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <2874864.eaglUHDoO0@lx-vladimir> <20121213205116.GQ15974@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, December 13, 2012 12:51:16 PM Luis R. Rodriguez wrote:
> On Wed, Dec 12, 2012 at 06:25:06PM +0200, Vladimir Kondratiev wrote:
> > On Wednesday, December 12, 2012 05:04:38 PM Johannes Berg wrote:
> > > On Wed, 2012-12-12 at 17:47 +0200, Vladimir Kondratiev wrote:
> > > 
> > > > Vladimir Kondratiev (3):
> > > >   wireless: Driver for 60GHz card wil6210
> > > 
> > > Since you didn't want to hear my objections on the iftype usage ...
> > > maybe you should not Cc me any more.
> > > 
> > > johannes
> > > 
> > 
> > Johannes,
> > 
> > I do hear it, and I agree with it!!!
> > 
> > I will work to support this new
> > iftype, PBSS, properly. I just don't have enough data to do it right
> > now. Thus, I want initial driver for the 1-st ever 60g card to be merged;
> > this will serve as test bed for the next framework modifications.
> > 
> > I recall, you was asking me why do I pushing to do 60g related
> > infrastructure changes when no one driver exists. I want to address this
> > and then return to the infrastructure.
> > 
> > Let's have at least something working as 1-st step. Now, I need to assemble
> > all pieces of the puzzle:
> > 
> > - initial infrastructure (done)
> > - minimal driver (these patches)
> > - tools (wpa_supplicant partially done, other patches sent; iw - partially done)
> > - regulatory - patches submitted.
> > 
> > Then, when minimal support will be in place, I can handle new features.
> > 
> > Hope it explain why I want to merge minimal driver 1-st.
> 
> Vladimir, please only enable monitor support and STA mode to
> be used on the upstream driver submission. If you want PCP mode
> you'll have to address Johannes' concerns. If you want to enable
> PCP mode as you have you can enable it by enabling it through an
> extra crap/ category patch on compat-drivers.
> 
>   Luis

Due to progress in firmware development, now I can do even better:

Please find below patch where supported is "true" AP mode;
PCP support dropped.
Changes are mostly in the firmware, but few lines changed
in the driver as well.

Johannes: does this address your concerns?

John: can this driver get to 3.8? Is it correct,
"driver for new hardware" is eligible even if merge window already opened?

To sort all the stuff, patch set is:

1) this patch, [PATCH v11] wireless: Driver for 60GHz card wil6210
2) one of: [PATCH v10 2/3] wil6210: Local compensation for dynamic hexdump
       or: [PATCH] wil6210: alternative functions for dynamic hexdump
3) [PATCH v10 3/3] wireless: integrate wil6210 driver into build

I can re-submit all 3 patches as one set if it will serve better; just
please indicate opinions about patch 2) - which one should I pick.

Thanks, Vladimir


>From fb3a6f8eb9bff805a91af70245f2f62980d2390f Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Wed, 12 Dec 2012 16:53:32 +0200
Subject: [PATCH v11] wireless: Driver for 60GHz card wil6210

Card wil6210 by Wilocity supports operation on the 60GHz band,
accordingly to the 802.11ad standard.

This development snapshot supports:

- STA, AP and monitor modes
- security works for STA mode, not integrated yet for the AP mode
- AP limited to 1 connected STA

Using the STA and AP mode, one can assemble fully functional BSS.
throughput of 1.2Gbps achieved with iperf

To start AP mode, use wpa_supplicant or hostapd.
For wpa_supplicant, use config like:

network={
        ssid="test"
        mode=2
        frequency=60480
        key_mgmt=NONE
}

Patch for wpa_supplicant/hostapd submitted.

In the monitor mode, card is able to capture either control or non-control frames
(due to hardware/firmware limitation).

Wil6210 card have on-board flash memory for the firmware, card comes pre-flushed
and no firmware download required on the run time.

Refer to the Documentation/networking/wil6210.txt for more info.

Wiki available at http://wireless.kernel.org/en/users/Drivers/wil6210

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 Documentation/networking/wil6210.txt         |  292 +++++++
 drivers/net/wireless/ath/wil6210/Kconfig     |   30 +
 drivers/net/wireless/ath/wil6210/Makefile    |   14 +
 drivers/net/wireless/ath/wil6210/cfg80211.c  |  573 +++++++++++++
 drivers/net/wireless/ath/wil6210/debugfs.c   |  603 ++++++++++++++
 drivers/net/wireless/ath/wil6210/interrupt.c |  471 +++++++++++
 drivers/net/wireless/ath/wil6210/main.c      |  407 ++++++++++
 drivers/net/wireless/ath/wil6210/netdev.c    |  157 ++++
 drivers/net/wireless/ath/wil6210/pcie_bus.c  |  223 +++++
 drivers/net/wireless/ath/wil6210/txrx.c      |  871 ++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.h      |  362 +++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h   |  361 +++++++++
 drivers/net/wireless/ath/wil6210/wmi.c       |  975 ++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wmi.h       | 1116 ++++++++++++++++++++++++++
 14 files changed, 6455 insertions(+)
 create mode 100644 Documentation/networking/wil6210.txt
 create mode 100644 drivers/net/wireless/ath/wil6210/Kconfig
 create mode 100644 drivers/net/wireless/ath/wil6210/Makefile
 create mode 100644 drivers/net/wireless/ath/wil6210/cfg80211.c
 create mode 100644 drivers/net/wireless/ath/wil6210/debugfs.c
 create mode 100644 drivers/net/wireless/ath/wil6210/interrupt.c
 create mode 100644 drivers/net/wireless/ath/wil6210/main.c
 create mode 100644 drivers/net/wireless/ath/wil6210/netdev.c
 create mode 100644 drivers/net/wireless/ath/wil6210/pcie_bus.c
 create mode 100644 drivers/net/wireless/ath/wil6210/txrx.c
 create mode 100644 drivers/net/wireless/ath/wil6210/txrx.h
 create mode 100644 drivers/net/wireless/ath/wil6210/wil6210.h
 create mode 100644 drivers/net/wireless/ath/wil6210/wmi.c
 create mode 100644 drivers/net/wireless/ath/wil6210/wmi.h

diff --git a/Documentation/networking/wil6210.txt b/Documentation/networking/wil6210.txt
new file mode 100644
index 0000000..24fcc51
--- /dev/null
+++ b/Documentation/networking/wil6210.txt
@@ -0,0 +1,292 @@
+Driver for wil6210 wireless network card.
+=========================================
+
+Copyright (c) 2012 Qualcomm Atheros, Inc.
+<wil6210@qca.qualcomm.com>
+
+Introduction
+============
+
+The wil6210 is 60GHz wireless card by Wilocity.
+It provides WiFi and wireless PCIE connectivity, as described in
+the WiGig WBE spec.
+
+This is PCIE device. It is combined with Atheros 2.4/5.2 GHz WiFi card.
+On the PCI, it is represented as the following hierarchy:
+
+1ae9:0101-+-1ae9:0201---168c:0034
+          +-1ae9:0201---1ae9:0301
+          +-1ae9:0201
+          \-1ae9:0201
+
+Chip consists of 1ae9:0101 is root bridge, with 4 ports 1ae9:0201.
+One port routed to separate Atheros card 168c:0034, it is handled by the
+ath9k driver.
+Another port connected to the wil6210 device 1ae9:0301, that is on chip.
+2 empty ports may be populated when connecting in WBE mode.
+
+wil6210 device, 1ae9:0301, has one 2Mb BAR.
+
+Network features
+================
+
+For the WiFi connection, it implements 802.11ad spec.
+Supported are channels 1..3 with corresponded frequencies
+58320, 60480, 62640 MHz.
+
+wil6210 use cfg80211 framework, but not mac80211.
+
+Modes supported are:
+
+- monitor
+- managed (station)
+- AP
+
+Driver designed in a way that hardware start running only when network
+interface brought up, with either 'ifconfig up' or starting AP. All settings
+made before are cached in the driver but not passed to the hardware.
+
+iw commands supported
+---------------------
+
+iw link: query link status. Report current MCS.
+
+Module parameters
+=================
+
+- rtap_include_phy_info
+     Include PHY info in the radiotap header, default - no (bool)
+- use_msi
+     Use MSI interrupt: 0 - don't, 1 - (default) - single, or 3 (int)
+- debug_fw
+     load driver if FW not ready. For FW debug (bool)
+
+wil6210 support set of interrupt handling modes:
+
+- INTx - legacy pin interrupt. Do not use if possible.
+- 1MSI - one MSI interrupt. This is the default mode.
+- 3MSI - 3 MSI interrupts for {Tx, Rx, Misc}.
+
+For interrupt handling mode, probed is highest one specified with @use_msi,
+with fallback:
+
+3MSI -> 1MSI -> INTx
+
+On the x86 platform, multiple MSI interrupts are not supported with recent
+kernel (3.7).
+
+When @debug_fw set to true, driver probe will not fail if firmware do not
+report "ready" event. This is to aid firmware boot issues debugging.
+
+Sniffer
+=======
+
+To configure wil6210 in sniffer mode (assume $WLAN set to network
+interface name):
+
+# iw $WLAN set type monitor
+
+Due to hardware/firmware deficiency, sniffer can capture either only
+control PHY (CP) or only data PHY (DP). To configure for desired PHY type
+do, after configuring for monitor mode:
+
+For CP:
+# iw $WLAN set monitor control
+For DP:
+# iw $WLAN set monitor none
+
+Finally, bring interface up:
+
+# ifconfig $WLAN up
+
+Examples for AP mode
+====================
+
+AP mode may be started using wpa_supplicant of hostapd. Use latest development
+snapshot of wpa_supplicant.
+
+For the wpa_supplicant, start AP in non-secure mode with config:
+
+---cut---
+ap_scan=2
+
+network={
+        frequency=60480
+        ssid="the_ssid_string"
+        mode=2
+        key_mgmt=NONE
+}
+---cut---
+
+To start secure AP, use config:
+
+---cut---
+ap_scan=2
+
+network={
+        frequency=60480
+        ssid="secure_ap"
+        psk="passphrase"
+        mode=2
+        key_mgmt=WPA-PSK
+        proto=RSN
+        pairwise=GCMP
+        group=GCMP
+}
+---cut---
+
+WMI commands
+============
+
+Control communication with the card is done through so called WMI commands
+and events. Target access to the mailbox within memory in BAR0 used.
+There are 2 similar mailbox structures: one for host->card commands, and one
+for card->host events.
+
+Tx/Rx
+=====
+
+DMA using 'vring' structures. Vring in consistent memory; hold descriptors
+that points to the data buffers. Card to write status back to the descriptor.
+
+There is one Rx vring. Tx vrings - multiple, per DA*TID.
+
+Debug facilities
+================
+
+Dynamic debug
+-------------
+
+Almost all messages printed to the dmesg, are "dynamic debug" ones.
+See Documentation/dynamic-debug-howto.txt for details.
+Module "wil6210" uses format prefixes to identify message groups:
+
+- "DBG[ IRQ]" for interrupt related messages. Prints every IRQ.
+- "DBG[TXRX]" for Tx/Rx path. Prints every Tx/Rx package.
+- "DBG[ WMI]" for WMI commands subsystem
+
+Groups IRQ and TXRX are heavy traffic; enable only when required.
+Group WMI is relatively low traffic, it prints only WMI messages.
+It is good idea to enable it when debugging.
+
+Debugfs
+-------
+
+All debugfs files placed under standard location for the cfg80211 devices,
+$DEBUGFS/ieee80211/$PHY/ where $PHY is phy name like 'phy1'.
+
+All wil6210 specific files placed under directory 'wil6210'.
+Facilities provided:
+
+- register access. All ICR (Interrupt Control Registers) groups represented as
+  directories, with entries per register, allowing read/write.
+  ITR (Interrupt Threshold Registers) represented as well.
+
+- raw memory access. All memory sections represented as 'blob' files, providing
+  read only access to the memory on card. Sections include:
+
++-------------------------------+---------------+
+| blob_xxx  | BAR0    | Size    | Comment       |
+| file name | offset  |         |               |
++-----------+---------+---------+---------------+
+| rgf       |     0x0 |  0xa000 | Register file |
+| fw_code   | 0x40000 | 0x40000 | FW code       |
+| fw_data   | 0x80000 |  0x8000 | FW data       |
+| fw_peri   | 0x88000 | 0x18000 | FW peripheral |
+| uc_code   | 0xa0000 | 0x10000 | Ucode code    |
+| uc_data   | 0xb0000 |  0x4000 | Ucode data    |
++-----------+---------+---------+---------------+
+
+Raw memory access used by firmware/ucode trace extractor. See below. Also,
+raw memory dump may be obtained for later analysis.
+
+- DWORD memory read, as FW see it. Files 'mem_addr' and 'mem_val' provide
+  access to the memory, using FW addresses (FW memory mapping is somewhat
+  different from what host see in BAR0). Write address to the 'mem_addr', then
+  read 'mem_val'. It will reads like "[0x%08x] = 0x%08x\n", addr, value
+
+- mailbox for WMI commands events. File 'mbox' reads like:
+
+ring tx = {
+  base = 0x008802e8
+  size = 0x0028 bytes -> 5 entries
+  tail = 0x00880300
+  head = 0x00880300
+  entry size = 1288
+  [ 0] E    0x00842490 -> 1fc9 001e 0000 00
+      : 00 00 07 00 00 00 00 00 ff ff 03 00 00 00 00 00
+      : 00 00 00 20 04 07 01 88 ff 02 00 00 01 00
+  [ 1] E    0x00841f88 -> 1fca 001e 0000 00
+      : 00 00 07 00 00 00 00 00 ff ff 03 00 00 00 00 00
+      : 00 00 00 20 04 07 01 88 ff 02 00 00 01 00
+  [ 2] E    0x00841a80 -> 1fcb 001e 0000 00
+      : 00 00 07 00 00 00 00 00 ff ff 03 00 00 00 00 00
+      : 00 00 00 20 04 07 01 88 ff 02 00 00 01 00
+  [ 3] E th 0x00841578 -> 1fc7 001e 0000 00
+      : 00 00 07 00 00 00 00 00 ff ff 03 00 00 00 00 00
+      : 00 00 00 20 04 07 01 88 ff 02 00 00 01 00
+  [ 4] E    0x00841070 -> 1fc8 001e 0000 00
+      : 00 00 07 00 00 00 00 00 ff ff 03 00 00 00 00 00
+      : 00 00 00 20 04 07 01 88 ff 02 00 00 01 00
+}
+ring rx = {
+  base = 0x00880318
+  size = 0x0040 bytes -> 8 entries
+  tail = 0x00880320
+  head = 0x00880320
+  entry size = 256
+  [ 0] E    0x00842f98 -> 24f8 000c 0000 00
+      : 00 00 0a 10 00 00 00 00 00 00 00 00
+  [ 1] E th 0x00000000 -> 2020 0f80 0000 c0
+  [ 2] E    0x00000000 -> 2020 0f80 0000 c0
+  [ 3] E    0x00000000 -> 2020 0f80 0000 c0
+  [ 4] E    0x00000000 -> 2020 0f80 0000 c0
+  [ 5] E    0x00000000 -> 2020 0f80 0000 c0
+  [ 6] E    0x00000000 -> 2020 0f80 0000 c0
+  [ 7] E    0x00000000 -> 2020 0f80 0000 c0
+}
+
+There are 2 separate rings, one for Tx, or host->card commands; and 2-nd
+for Rx, or card->host events.
+
+Printed for each ring (all addresses in FW memory mapping):
+  - base address of ring in card's memory
+  - ring size in bytes and entries
+  - tail and head pointers
+  - max. entry size. It is fake for Rx - FW may allocate entry of arbitrary size
+  - mailbox entries, format for entry:
+
+
+       /-- 'E' for empty entry, 'F' for full
+       | /+-- 't' for tail, 'h' for head
+       | ||
+ index | || address       /-mbox header---\ [seq,len,type,flags]
+    v  v vv   v           v               v
+  [ 3] E th 0x00841578 -> 1fc7 001e 0000 00
+      : 00 00 07 00 00 00 00 00 ff ff 03 00 00 00 00 00
+      : 00 00 00 20 04 07 01 88 ff 02 00 00 01 00
+        \--buffer content (if valid)------------------/
+
+- Tx/Rx DMA Vrings. File 'vrings' reads as:
+
+VRING rx = {
+  pa     = 0x00000000bb075000
+  va     = 0xffff8800bb075000
+  size   = 128
+  swtail = 127
+  swhead = 0
+  hwtail = [0x008813c8] -> 0x0000007f
+HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
+HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHS
+}
+
+There is one block for Rx DMA vring and one for every Tx DMA vring.
+
+Information printed:
+  - addresses, physical (pa) and virtual (va)
+  - size, entries
+  - software head and tail pointers
+  - hardware tail, format: [fw addr] -> value
+  - One letter per vring entry, 'H' for hardware owned and 'S'
+    for software owned ones.
+
diff --git a/drivers/net/wireless/ath/wil6210/Kconfig b/drivers/net/wireless/ath/wil6210/Kconfig
new file mode 100644
index 0000000..209c00f
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/Kconfig
@@ -0,0 +1,30 @@
+config WIL6210
+	tristate "Wilocity 60g WiFi card wil6210 support"
+	depends on CFG80211
+	depends on PCI
+	default n
+	---help---
+	  This module adds support for wireless adapter based on
+	  wil6210 chip by Wilocity. It supports operation on the
+	  60g band, covered by the IEEE802.11ad standard. See
+	  Documentation/networking/wil6210.txt and
+	  http://wireless.kernel.org/en/users/Drivers/wil6210
+	  for more information.
+	  If you choose to build it as a module, it will be called
+	  wil6210
+
+config WIL6210_ISR_COR
+	bool "Use Clear-On-Read mode for ISR registers for wil6210"
+	depends on WIL6210
+	default y
+	---help---
+	  ISR registers on wil6210 chip may operate in either
+	  COR (Clear-On-Read) or W1C (Write-1-to-Clear) mode.
+	  For production code, use COR (say y); is default since
+	  it saves extra target transaction;
+	  For ISR debug, use W1C (say n); is allows to monitor ISR
+	  registers with debugfs. If COR were used, ISR would
+	  self-clear when accessed for debug purposes, it makes
+	  such monitoring impossible.
+	  Say y unless you debug interrupts
+
diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wireless/ath/wil6210/Makefile
new file mode 100644
index 0000000..7713e4a
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/Makefile
@@ -0,0 +1,14 @@
+obj-$(CONFIG_WIL6210) += wil6210.o
+
+wil6210-objs := main.o
+wil6210-objs += netdev.o
+wil6210-objs += cfg80211.o
+wil6210-objs += pcie_bus.o
+wil6210-objs += debugfs.o
+wil6210-objs += wmi.o
+wil6210-objs += interrupt.o
+wil6210-objs += txrx.o
+
+subdir-ccflags-y += -Werror
+subdir-ccflags-y += -D__CHECK_ENDIAN__
+
diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
new file mode 100644
index 0000000..116f4e8
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -0,0 +1,573 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/sched.h>
+#include <linux/etherdevice.h>
+#include <linux/wireless.h>
+#include <linux/ieee80211.h>
+#include <linux/slab.h>
+#include <linux/version.h>
+#include <net/cfg80211.h>
+
+#include "wil6210.h"
+#include "wmi.h"
+
+#define CHAN60G(_channel, _flags) {				\
+	.band			= IEEE80211_BAND_60GHZ,		\
+	.center_freq		= 56160 + (2160 * (_channel)),	\
+	.hw_value		= (_channel),			\
+	.flags			= (_flags),			\
+	.max_antenna_gain	= 0,				\
+	.max_power		= 40,				\
+}
+
+static struct ieee80211_channel wil_60ghz_channels[] = {
+	CHAN60G(1, 0),
+	CHAN60G(2, 0),
+	CHAN60G(3, 0),
+/* channel 4 not supported yet */
+};
+
+static struct ieee80211_supported_band wil_band_60ghz = {
+	.channels = wil_60ghz_channels,
+	.n_channels = ARRAY_SIZE(wil_60ghz_channels),
+	.ht_cap = {
+		.ht_supported = true,
+		.cap = 0, /* TODO */
+		.ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K, /* TODO */
+		.ampdu_density = IEEE80211_HT_MPDU_DENSITY_8, /* TODO */
+		.mcs = {
+				/* MCS 1..12 - SC PHY */
+			.rx_mask = {0xfe, 0x1f}, /* 1..12 */
+			.tx_params = IEEE80211_HT_MCS_TX_DEFINED, /* TODO */
+		},
+	},
+};
+
+static const struct ieee80211_txrx_stypes
+wil_mgmt_stypes[NUM_NL80211_IFTYPES] = {
+	[NL80211_IFTYPE_STATION] = {
+		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_RESP >> 4),
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	},
+	[NL80211_IFTYPE_AP] = {
+		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_RESP >> 4),
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	},
+	[NL80211_IFTYPE_P2P_CLIENT] = {
+		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_RESP >> 4),
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	},
+	[NL80211_IFTYPE_P2P_GO] = {
+		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_RESP >> 4),
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	},
+};
+
+static const u32 wil_cipher_suites[] = {
+	WLAN_CIPHER_SUITE_GCMP,
+};
+
+int wil_iftype_nl2wmi(enum nl80211_iftype type)
+{
+	static const struct {
+		enum nl80211_iftype nl;
+		enum wmi_network_type wmi;
+	} __nl2wmi[] = {
+		{NL80211_IFTYPE_ADHOC,		WMI_NETTYPE_ADHOC},
+		{NL80211_IFTYPE_STATION,	WMI_NETTYPE_INFRA},
+		{NL80211_IFTYPE_AP,		WMI_NETTYPE_AP},
+		{NL80211_IFTYPE_P2P_CLIENT,	WMI_NETTYPE_P2P},
+		{NL80211_IFTYPE_P2P_GO,		WMI_NETTYPE_P2P},
+		{NL80211_IFTYPE_MONITOR,	WMI_NETTYPE_ADHOC}, /* FIXME */
+	};
+	uint i;
+
+	for (i = 0; i < ARRAY_SIZE(__nl2wmi); i++) {
+		if (__nl2wmi[i].nl == type)
+			return __nl2wmi[i].wmi;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+static int wil_cfg80211_get_station(struct wiphy *wiphy,
+				    struct net_device *ndev,
+				    u8 *mac, struct station_info *sinfo)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	int rc;
+	struct wmi_notify_req_cmd cmd = {
+		.cid = 0,
+		.interval_usec = 0,
+	};
+
+	if (memcmp(mac, wil->dst_addr[0], ETH_ALEN))
+		return -ENOENT;
+
+	/* WMI_NOTIFY_REQ_DONE_EVENTID handler fills wil->stats.bf_mcs */
+	rc = wmi_call(wil, WMI_NOTIFY_REQ_CMDID, &cmd, sizeof(cmd),
+		      WMI_NOTIFY_REQ_DONE_EVENTID, NULL, 0, 20);
+	if (rc)
+		return rc;
+
+	sinfo->generation = wil->sinfo_gen;
+
+	sinfo->filled |= STATION_INFO_TX_BITRATE;
+	sinfo->txrate.flags = RATE_INFO_FLAGS_MCS | RATE_INFO_FLAGS_60G;
+	sinfo->txrate.mcs = wil->stats.bf_mcs;
+	sinfo->filled |= STATION_INFO_RX_BITRATE;
+	sinfo->rxrate.flags = RATE_INFO_FLAGS_MCS | RATE_INFO_FLAGS_60G;
+	sinfo->rxrate.mcs = wil->stats.last_mcs_rx;
+
+	if (test_bit(wil_status_fwconnected, &wil->status)) {
+		sinfo->filled |= STATION_INFO_SIGNAL;
+		sinfo->signal = 12; /* TODO: provide real value */
+	}
+
+	return 0;
+}
+
+static int wil_cfg80211_change_iface(struct wiphy *wiphy,
+				     struct net_device *ndev,
+				     enum nl80211_iftype type, u32 *flags,
+				     struct vif_params *params)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	struct wireless_dev *wdev = wil->wdev;
+
+	switch (type) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_P2P_GO:
+		break;
+	case NL80211_IFTYPE_MONITOR:
+		if (flags)
+			wil->monitor_flags = *flags;
+		else
+			wil->monitor_flags = 0;
+
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	wdev->iftype = type;
+
+	return 0;
+}
+
+static int wil_cfg80211_scan(struct wiphy *wiphy,
+			     struct cfg80211_scan_request *request)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	struct wireless_dev *wdev = wil->wdev;
+	struct {
+		struct wmi_start_scan_cmd cmd;
+		u16 chnl[4];
+	} __packed cmd;
+	uint i, n;
+
+	if (wil->scan_request) {
+		wil_err(wil, "Already scanning\n");
+		return -EAGAIN;
+	}
+
+	/* check we are client side */
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+		break;
+	default:
+		return -EOPNOTSUPP;
+
+	}
+
+	/* FW don't support scan after connection attempt */
+	if (test_bit(wil_status_dontscan, &wil->status)) {
+		wil_err(wil, "Scan after connect attempt not supported\n");
+		return -EBUSY;
+	}
+
+	wil->scan_request = request;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.cmd.num_channels = 0;
+	n = min(request->n_channels, 4U);
+	for (i = 0; i < n; i++) {
+		int ch = request->channels[i]->hw_value;
+		if (ch == 0) {
+			wil_err(wil,
+				"Scan requested for unknown frequency %dMhz\n",
+				request->channels[i]->center_freq);
+			continue;
+		}
+		/* 0-based channel indexes */
+		cmd.cmd.channel_list[cmd.cmd.num_channels++].channel = ch - 1;
+		wil_dbg(wil, "Scan for ch %d  : %d MHz\n", ch,
+			request->channels[i]->center_freq);
+	}
+
+	return wmi_send(wil, WMI_START_SCAN_CMDID, &cmd, sizeof(cmd.cmd) +
+			cmd.cmd.num_channels * sizeof(cmd.cmd.channel_list[0]));
+}
+
+static int wil_cfg80211_connect(struct wiphy *wiphy,
+				struct net_device *ndev,
+				struct cfg80211_connect_params *sme)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	struct cfg80211_bss *bss;
+	struct wmi_connect_cmd conn;
+	const u8 *ssid_eid;
+	const u8 *rsn_eid;
+	int ch;
+	int rc = 0;
+
+	bss = cfg80211_get_bss(wiphy, sme->channel, sme->bssid,
+			       sme->ssid, sme->ssid_len,
+			       WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+	if (!bss) {
+		wil_err(wil, "Unable to find BSS\n");
+		return -ENOENT;
+	}
+
+	ssid_eid = ieee80211_bss_get_ie(bss, WLAN_EID_SSID);
+	if (!ssid_eid) {
+		wil_err(wil, "No SSID\n");
+		rc = -ENOENT;
+		goto out;
+	}
+
+	rsn_eid = sme->ie ?
+			cfg80211_find_ie(WLAN_EID_RSN, sme->ie, sme->ie_len) :
+			NULL;
+	if (rsn_eid) {
+		if (sme->ie_len > WMI_MAX_IE_LEN) {
+			rc = -ERANGE;
+			wil_err(wil, "IE too large (%td bytes)\n",
+				sme->ie_len);
+			goto out;
+		}
+		/*
+		 * For secure assoc, send:
+		 * (1) WMI_DELETE_CIPHER_KEY_CMD
+		 * (2) WMI_SET_APPIE_CMD
+		 */
+		rc = wmi_del_cipher_key(wil, 0, bss->bssid);
+		if (rc) {
+			wil_err(wil, "WMI_DELETE_CIPHER_KEY_CMD failed\n");
+			goto out;
+		}
+		/* WMI_SET_APPIE_CMD */
+		rc = wmi_set_ie(wil, WMI_FRAME_ASSOC_REQ, sme->ie_len, sme->ie);
+		if (rc) {
+			wil_err(wil, "WMI_SET_APPIE_CMD failed\n");
+			goto out;
+		}
+	}
+
+	/* WMI_CONNECT_CMD */
+	memset(&conn, 0, sizeof(conn));
+	switch (bss->capability & 0x03) {
+	case WLAN_CAPABILITY_DMG_TYPE_AP:
+		conn.network_type = WMI_NETTYPE_INFRA;
+		break;
+	case WLAN_CAPABILITY_DMG_TYPE_PBSS:
+		conn.network_type = WMI_NETTYPE_P2P;
+		break;
+	default:
+		wil_err(wil, "Unsupported BSS type, capability= 0x%04x\n",
+			bss->capability);
+		goto out;
+	}
+	if (rsn_eid) {
+		conn.dot11_auth_mode = WMI_AUTH11_SHARED;
+		conn.auth_mode = WMI_AUTH_WPA2_PSK;
+		conn.pairwise_crypto_type = WMI_CRYPT_AES_GCMP;
+		conn.pairwise_crypto_len = 16;
+	} else {
+		conn.dot11_auth_mode = WMI_AUTH11_OPEN;
+		conn.auth_mode = WMI_AUTH_NONE;
+	}
+
+	conn.ssid_len = min_t(u8, ssid_eid[1], 32);
+	memcpy(conn.ssid, ssid_eid+2, conn.ssid_len);
+
+	ch = bss->channel->hw_value;
+	if (ch == 0) {
+		wil_err(wil, "BSS at unknown frequency %dMhz\n",
+			bss->channel->center_freq);
+		rc = -EOPNOTSUPP;
+		goto out;
+	}
+	conn.channel = ch - 1;
+
+	memcpy(conn.bssid, bss->bssid, 6);
+	memcpy(conn.dst_mac, bss->bssid, 6);
+	/*
+	 * FW don't support scan after connection attempt
+	 */
+	set_bit(wil_status_dontscan, &wil->status);
+
+	rc = wmi_send(wil, WMI_CONNECT_CMDID, &conn, sizeof(conn));
+	if (rc == 0) {
+		/* Connect can take lots of time */
+		mod_timer(&wil->connect_timer,
+			  jiffies + msecs_to_jiffies(2000));
+	}
+
+ out:
+	cfg80211_put_bss(bss);
+
+	return rc;
+}
+
+static int wil_cfg80211_disconnect(struct wiphy *wiphy,
+				   struct net_device *ndev,
+				   u16 reason_code)
+{
+	int rc;
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	rc = wmi_send(wil, WMI_DISCONNECT_CMDID, NULL, 0);
+
+	return rc;
+}
+
+static int wil_cfg80211_set_channel(struct wiphy *wiphy,
+				    struct cfg80211_chan_def *chandef)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	struct wireless_dev *wdev = wil->wdev;
+
+	wdev->preset_chandef = *chandef;
+
+	return 0;
+}
+
+static int wil_cfg80211_add_key(struct wiphy *wiphy,
+				struct net_device *ndev,
+				u8 key_index, bool pairwise,
+				const u8 *mac_addr,
+				struct key_params *params)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	/* group key is not used */
+	if (!pairwise)
+		return 0;
+
+	return wmi_add_cipher_key(wil, key_index, mac_addr,
+				  params->key_len, params->key);
+}
+
+static int wil_cfg80211_del_key(struct wiphy *wiphy,
+				struct net_device *ndev,
+				u8 key_index, bool pairwise,
+				const u8 *mac_addr)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	/* group key is not used */
+	if (!pairwise)
+		return 0;
+
+	return wmi_del_cipher_key(wil, key_index, mac_addr);
+}
+
+/* Need to be present or wiphy_new() will WARN */
+static int wil_cfg80211_set_default_key(struct wiphy *wiphy,
+					struct net_device *ndev,
+					u8 key_index, bool unicast,
+					bool multicast)
+{
+	return 0;
+}
+
+static int wil_cfg80211_start_ap(struct wiphy *wiphy,
+				 struct net_device *ndev,
+				 struct cfg80211_ap_settings *info)
+{
+	int rc = 0;
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	struct wireless_dev *wdev = ndev->ieee80211_ptr;
+	struct ieee80211_channel *channel = info->chandef.chan;
+	struct cfg80211_beacon_data *bcon = &info->beacon;
+	u8 wmi_nettype = wil_iftype_nl2wmi(wdev->iftype);
+
+	if (!channel) {
+		wil_err(wil, "AP: No channel???\n");
+		return -EINVAL;
+	}
+
+	wil_dbg(wil, "AP on Channel %d %d MHz, %s\n", channel->hw_value,
+		channel->center_freq, info->privacy ? "secure" : "open");
+	print_hex_dump_bytes("SSID ", DUMP_PREFIX_OFFSET,
+			     info->ssid, info->ssid_len);
+
+	rc = wil_reset(wil);
+	if (rc)
+		return rc;
+
+	rc = wmi_set_ssid(wil, info->ssid_len, info->ssid);
+	if (rc)
+		return rc;
+
+	rc = wmi_set_channel(wil, channel->hw_value);
+	if (rc)
+		return rc;
+
+	/* MAC address - pre-requisite for other commands */
+	wmi_set_mac_address(wil, ndev->dev_addr);
+
+	/* IE's */
+	/* bcon 'head IE's are not relevant for 60g band */
+	wmi_set_ie(wil, WMI_FRAME_BEACON, bcon->beacon_ies_len,
+		   bcon->beacon_ies);
+	wmi_set_ie(wil, WMI_FRAME_PROBE_RESP, bcon->proberesp_ies_len,
+		   bcon->proberesp_ies);
+	wmi_set_ie(wil, WMI_FRAME_ASSOC_RESP, bcon->assocresp_ies_len,
+		   bcon->assocresp_ies);
+
+	wil->secure_pcp = info->privacy;
+
+	rc = wmi_set_bcon(wil, info->beacon_interval, wmi_nettype);
+	if (rc)
+		return rc;
+
+	/* Rx VRING. After MAC and beacon */
+	rc = wil_rx_init(wil);
+
+	netif_carrier_on(ndev);
+
+	return rc;
+}
+
+static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
+				struct net_device *ndev)
+{
+	int rc = 0;
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	struct wireless_dev *wdev = ndev->ieee80211_ptr;
+	u8 wmi_nettype = wil_iftype_nl2wmi(wdev->iftype);
+
+	/* To stop beaconing, set BI to 0 */
+	rc = wmi_set_bcon(wil, 0, wmi_nettype);
+
+	return rc;
+}
+
+static struct cfg80211_ops wil_cfg80211_ops = {
+	.scan = wil_cfg80211_scan,
+	.connect = wil_cfg80211_connect,
+	.disconnect = wil_cfg80211_disconnect,
+	.change_virtual_intf = wil_cfg80211_change_iface,
+	.get_station = wil_cfg80211_get_station,
+	.set_monitor_channel = wil_cfg80211_set_channel,
+	.add_key = wil_cfg80211_add_key,
+	.del_key = wil_cfg80211_del_key,
+	.set_default_key = wil_cfg80211_set_default_key,
+	/* AP mode */
+	.start_ap = wil_cfg80211_start_ap,
+	.stop_ap = wil_cfg80211_stop_ap,
+};
+
+static void wil_wiphy_init(struct wiphy *wiphy)
+{
+	/* TODO: set real value */
+	wiphy->max_scan_ssids = 10;
+	wiphy->max_num_pmkids = 0 /* TODO: */;
+	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				 BIT(NL80211_IFTYPE_AP) |
+				 BIT(NL80211_IFTYPE_MONITOR);
+	/* TODO: enable P2P when integrated with supplicant:
+	 * BIT(NL80211_IFTYPE_P2P_CLIENT) | BIT(NL80211_IFTYPE_P2P_GO)
+	 */
+	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME |
+			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
+	dev_warn(wiphy_dev(wiphy), "%s : flags = 0x%08x\n",
+		 __func__, wiphy->flags);
+	wiphy->probe_resp_offload =
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 |
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P;
+
+	wiphy->bands[IEEE80211_BAND_60GHZ] = &wil_band_60ghz;
+
+	/* TODO: figure this out */
+	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+
+	wiphy->cipher_suites = wil_cipher_suites;
+	wiphy->n_cipher_suites = ARRAY_SIZE(wil_cipher_suites);
+	wiphy->mgmt_stypes = wil_mgmt_stypes;
+}
+
+struct wireless_dev *wil_cfg80211_init(struct device *dev)
+{
+	int rc = 0;
+	struct wireless_dev *wdev;
+
+	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
+	if (!wdev)
+		return ERR_PTR(-ENOMEM);
+
+	wdev->wiphy = wiphy_new(&wil_cfg80211_ops,
+				sizeof(struct wil6210_priv));
+	if (!wdev->wiphy) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	set_wiphy_dev(wdev->wiphy, dev);
+	wil_wiphy_init(wdev->wiphy);
+
+	rc = wiphy_register(wdev->wiphy);
+	if (rc < 0)
+		goto out_failed_reg;
+
+	return wdev;
+
+out_failed_reg:
+	wiphy_free(wdev->wiphy);
+out:
+	kfree(wdev);
+
+	return ERR_PTR(rc);
+}
+
+void wil_wdev_free(struct wil6210_priv *wil)
+{
+	struct wireless_dev *wdev = wil_to_wdev(wil);
+
+	if (!wdev)
+		return;
+
+	wiphy_unregister(wdev->wiphy);
+	wiphy_free(wdev->wiphy);
+	kfree(wdev);
+}
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
new file mode 100644
index 0000000..65fc968
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -0,0 +1,603 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/pci.h>
+#include <linux/rtnetlink.h>
+
+#include "wil6210.h"
+#include "txrx.h"
+
+/* Nasty hack. Better have per device instances */
+static u32 mem_addr;
+static u32 dbg_txdesc_index;
+
+static void wil_print_vring(struct seq_file *s, struct wil6210_priv *wil,
+			    const char *name, struct vring *vring)
+{
+	void __iomem *x = wmi_addr(wil, vring->hwtail);
+
+	seq_printf(s, "VRING %s = {\n", name);
+	seq_printf(s, "  pa     = 0x%016llx\n", (unsigned long long)vring->pa);
+	seq_printf(s, "  va     = 0x%p\n", vring->va);
+	seq_printf(s, "  size   = %d\n", vring->size);
+	seq_printf(s, "  swtail = %d\n", vring->swtail);
+	seq_printf(s, "  swhead = %d\n", vring->swhead);
+	seq_printf(s, "  hwtail = [0x%08x] -> ", vring->hwtail);
+	if (x)
+		seq_printf(s, "0x%08x\n", ioread32(x));
+	else
+		seq_printf(s, "???\n");
+
+	if (vring->va && (vring->size < 1025)) {
+		uint i;
+		for (i = 0; i < vring->size; i++) {
+			volatile struct vring_tx_desc *d = &vring->va[i].tx;
+			if ((i % 64) == 0 && (i != 0))
+				seq_printf(s, "\n");
+			seq_printf(s, "%s", (d->dma.status & BIT(0)) ?
+					"S" : (vring->ctx[i] ? "H" : "h"));
+		}
+		seq_printf(s, "\n");
+	}
+	seq_printf(s, "}\n");
+}
+
+static int wil_vring_debugfs_show(struct seq_file *s, void *data)
+{
+	uint i;
+	struct wil6210_priv *wil = s->private;
+
+	wil_print_vring(s, wil, "rx", &wil->vring_rx);
+
+	for (i = 0; i < ARRAY_SIZE(wil->vring_tx); i++) {
+		struct vring *vring = &(wil->vring_tx[i]);
+		if (vring->va) {
+			char name[10];
+			snprintf(name, sizeof(name), "tx_%2d", i);
+			wil_print_vring(s, wil, name, vring);
+		}
+	}
+
+	return 0;
+}
+
+static int wil_vring_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wil_vring_debugfs_show, inode->i_private);
+}
+
+static const struct file_operations fops_vring = {
+	.open		= wil_vring_seq_open,
+	.release	= single_release,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
+static void wil_print_ring(struct seq_file *s, const char *prefix,
+			   void __iomem *off)
+{
+	struct wil6210_priv *wil = s->private;
+	struct wil6210_mbox_ring r;
+	int rsize;
+	uint i;
+
+	wil_memcpy_fromio_32(&r, off, sizeof(r));
+	wil_mbox_ring_le2cpus(&r);
+	/*
+	 * we just read memory block from NIC. This memory may be
+	 * garbage. Check validity before using it.
+	 */
+	rsize = r.size / sizeof(struct wil6210_mbox_ring_desc);
+
+	seq_printf(s, "ring %s = {\n", prefix);
+	seq_printf(s, "  base = 0x%08x\n", r.base);
+	seq_printf(s, "  size = 0x%04x bytes -> %d entries\n", r.size, rsize);
+	seq_printf(s, "  tail = 0x%08x\n", r.tail);
+	seq_printf(s, "  head = 0x%08x\n", r.head);
+	seq_printf(s, "  entry size = %d\n", r.entry_size);
+
+	if (r.size % sizeof(struct wil6210_mbox_ring_desc)) {
+		seq_printf(s, "  ??? size is not multiple of %zd, garbage?\n",
+			   sizeof(struct wil6210_mbox_ring_desc));
+		goto out;
+	}
+
+	if (!wmi_addr(wil, r.base) ||
+	    !wmi_addr(wil, r.tail) ||
+	    !wmi_addr(wil, r.head)) {
+		seq_printf(s, "  ??? pointers are garbage?\n");
+		goto out;
+	}
+
+	for (i = 0; i < rsize; i++) {
+		struct wil6210_mbox_ring_desc d;
+		struct wil6210_mbox_hdr hdr;
+		size_t delta = i * sizeof(d);
+		void __iomem *x = wil->csr + HOSTADDR(r.base) + delta;
+
+		wil_memcpy_fromio_32(&d, x, sizeof(d));
+
+		seq_printf(s, "  [%2x] %s %s%s 0x%08x", i,
+			   d.sync ? "F" : "E",
+			   (r.tail - r.base == delta) ? "t" : " ",
+			   (r.head - r.base == delta) ? "h" : " ",
+			   le32_to_cpu(d.addr));
+		if (0 == wmi_read_hdr(wil, d.addr, &hdr)) {
+			u16 len = le16_to_cpu(hdr.len);
+			seq_printf(s, " -> %04x %04x %04x %02x\n",
+				   le16_to_cpu(hdr.seq), len,
+				   le16_to_cpu(hdr.type), hdr.flags);
+			if (len <= MAX_MBOXITEM_SIZE) {
+				int n = 0;
+				unsigned char printbuf[16 * 3 + 2];
+				unsigned char databuf[MAX_MBOXITEM_SIZE];
+				void __iomem *src = wmi_buffer(wil, d.addr) +
+					sizeof(struct wil6210_mbox_hdr);
+				/*
+				 * No need to check @src for validity -
+				 * we already validated @d.addr while
+				 * reading header
+				 */
+				wil_memcpy_fromio_32(databuf, src, len);
+				while (n < len) {
+					int l = min(len - n, 16);
+					hex_dump_to_buffer(databuf + n, l,
+							   16, 1, printbuf,
+							   sizeof(printbuf),
+							   false);
+					seq_printf(s, "      : %s\n", printbuf);
+					n += l;
+				}
+			}
+		} else {
+			seq_printf(s, "\n");
+		}
+	}
+ out:
+	seq_printf(s, "}\n");
+}
+
+static int wil_mbox_debugfs_show(struct seq_file *s, void *data)
+{
+	struct wil6210_priv *wil = s->private;
+
+	wil_print_ring(s, "tx", wil->csr + HOST_MBOX +
+		       offsetof(struct wil6210_mbox_ctl, tx));
+	wil_print_ring(s, "rx", wil->csr + HOST_MBOX +
+		       offsetof(struct wil6210_mbox_ctl, rx));
+
+	return 0;
+}
+
+static int wil_mbox_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wil_mbox_debugfs_show, inode->i_private);
+}
+
+static const struct file_operations fops_mbox = {
+	.open		= wil_mbox_seq_open,
+	.release	= single_release,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
+static int wil_debugfs_iomem_x32_set(void *data, u64 val)
+{
+	iowrite32(val, (void __iomem *)data);
+	wmb(); /* make sure write propagated to HW */
+
+	return 0;
+}
+
+static int wil_debugfs_iomem_x32_get(void *data, u64 *val)
+{
+	*val = ioread32((void __iomem *)data);
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_iomem_x32, wil_debugfs_iomem_x32_get,
+			wil_debugfs_iomem_x32_set, "0x%08llx\n");
+
+static struct dentry *wil_debugfs_create_iomem_x32(const char *name,
+						   mode_t mode,
+						   struct dentry *parent,
+						   void __iomem *value)
+{
+	return debugfs_create_file(name, mode, parent, (void * __force)value,
+				   &fops_iomem_x32);
+}
+
+static int wil6210_debugfs_create_ISR(struct wil6210_priv *wil,
+				      const char *name,
+				      struct dentry *parent, u32 off)
+{
+	struct dentry *d = debugfs_create_dir(name, parent);
+
+	if (IS_ERR_OR_NULL(d))
+		return -ENODEV;
+
+	wil_debugfs_create_iomem_x32("ICC", S_IRUGO | S_IWUSR, d,
+				     wil->csr + off);
+	wil_debugfs_create_iomem_x32("ICR", S_IRUGO | S_IWUSR, d,
+				     wil->csr + off + 4);
+	wil_debugfs_create_iomem_x32("ICM", S_IRUGO | S_IWUSR, d,
+				     wil->csr + off + 8);
+	wil_debugfs_create_iomem_x32("ICS", S_IWUSR, d,
+				     wil->csr + off + 12);
+	wil_debugfs_create_iomem_x32("IMV", S_IRUGO | S_IWUSR, d,
+				     wil->csr + off + 16);
+	wil_debugfs_create_iomem_x32("IMS", S_IWUSR, d,
+				     wil->csr + off + 20);
+	wil_debugfs_create_iomem_x32("IMC", S_IWUSR, d,
+				     wil->csr + off + 24);
+
+	return 0;
+}
+
+static int wil6210_debugfs_create_pseudo_ISR(struct wil6210_priv *wil,
+					     struct dentry *parent)
+{
+	struct dentry *d = debugfs_create_dir("PSEUDO_ISR", parent);
+
+	if (IS_ERR_OR_NULL(d))
+		return -ENODEV;
+
+	wil_debugfs_create_iomem_x32("CAUSE", S_IRUGO, d, wil->csr +
+				     HOSTADDR(RGF_DMA_PSEUDO_CAUSE));
+	wil_debugfs_create_iomem_x32("MASK_SW", S_IRUGO, d, wil->csr +
+				     HOSTADDR(RGF_DMA_PSEUDO_CAUSE_MASK_SW));
+	wil_debugfs_create_iomem_x32("MASK_FW", S_IRUGO, d, wil->csr +
+				     HOSTADDR(RGF_DMA_PSEUDO_CAUSE_MASK_FW));
+
+	return 0;
+}
+
+static int wil6210_debugfs_create_ITR_CNT(struct wil6210_priv *wil,
+					  struct dentry *parent)
+{
+	struct dentry *d = debugfs_create_dir("ITR_CNT", parent);
+
+	if (IS_ERR_OR_NULL(d))
+		return -ENODEV;
+
+	wil_debugfs_create_iomem_x32("TRSH", S_IRUGO, d, wil->csr +
+				     HOSTADDR(RGF_DMA_ITR_CNT_TRSH));
+	wil_debugfs_create_iomem_x32("DATA", S_IRUGO, d, wil->csr +
+				     HOSTADDR(RGF_DMA_ITR_CNT_DATA));
+	wil_debugfs_create_iomem_x32("CTL", S_IRUGO, d, wil->csr +
+				     HOSTADDR(RGF_DMA_ITR_CNT_CRL));
+
+	return 0;
+}
+
+static int wil_memread_debugfs_show(struct seq_file *s, void *data)
+{
+	struct wil6210_priv *wil = s->private;
+	void __iomem *a = wmi_buffer(wil, cpu_to_le32(mem_addr));
+
+	if (a)
+		seq_printf(s, "[0x%08x] = 0x%08x\n", mem_addr, ioread32(a));
+	else
+		seq_printf(s, "[0x%08x] = INVALID\n", mem_addr);
+
+	return 0;
+}
+
+static int wil_memread_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wil_memread_debugfs_show, inode->i_private);
+}
+
+static const struct file_operations fops_memread = {
+	.open		= wil_memread_seq_open,
+	.release	= single_release,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
+static int wil_default_open(struct inode *inode, struct file *file)
+{
+	if (inode->i_private)
+		file->private_data = inode->i_private;
+
+	return 0;
+}
+
+static ssize_t wil_read_file_ioblob(struct file *file, char __user *user_buf,
+				size_t count, loff_t *ppos)
+{
+	enum { max_count = 4096 };
+	struct debugfs_blob_wrapper *blob = file->private_data;
+	loff_t pos = *ppos;
+	size_t available = blob->size;
+	void *buf;
+	size_t ret;
+
+	if (pos < 0)
+		return -EINVAL;
+
+	if (pos >= available || !count)
+		return 0;
+
+	if (count > available - pos)
+		count = available - pos;
+	if (count > max_count)
+		count = max_count;
+
+	buf = kmalloc(count, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	wil_memcpy_fromio_32(buf, (const volatile void __iomem *)blob->data +
+			     pos, count);
+
+	ret = copy_to_user(user_buf, buf, count);
+	kfree(buf);
+	if (ret == count)
+		return -EFAULT;
+
+	count -= ret;
+	*ppos = pos + count;
+
+	return count;
+}
+
+static const struct file_operations fops_ioblob = {
+	.read =		wil_read_file_ioblob,
+	.open =		wil_default_open,
+	.llseek =	default_llseek,
+};
+
+static
+struct dentry *wil_debugfs_create_ioblob(const char *name,
+					 mode_t mode,
+					 struct dentry *parent,
+					 struct debugfs_blob_wrapper *blob)
+{
+	return debugfs_create_file(name, mode, parent, blob, &fops_ioblob);
+}
+/*---reset---*/
+static ssize_t wil_write_file_reset(struct file *file, const char __user *buf,
+				    size_t len, loff_t *ppos)
+{
+	struct wil6210_priv *wil = file->private_data;
+	struct net_device *ndev = wil_to_ndev(wil);
+
+	/**
+	 * BUG:
+	 * this code does NOT sync device state with the rest of system
+	 * use with care, debug only!!!
+	 */
+	rtnl_lock();
+	dev_close(ndev);
+	ndev->flags &= ~IFF_UP;
+	rtnl_unlock();
+	wil_reset(wil);
+
+	return len;
+}
+
+static const struct file_operations fops_reset = {
+	.write = wil_write_file_reset,
+	.open  = wil_default_open,
+};
+/*---------Tx descriptor------------*/
+
+static int wil_txdesc_debugfs_show(struct seq_file *s, void *data)
+{
+	struct wil6210_priv *wil = s->private;
+	struct vring *vring = &(wil->vring_tx[0]);
+
+	if (!vring->va) {
+		seq_printf(s, "No Tx VRING\n");
+		return 0;
+	}
+
+	if (dbg_txdesc_index < vring->size) {
+		volatile struct vring_tx_desc *d =
+				&(vring->va[dbg_txdesc_index].tx);
+		volatile u32 *u = (volatile u32 *)d;
+		struct sk_buff *skb = vring->ctx[dbg_txdesc_index];
+
+		seq_printf(s, "Tx[%3d] = {\n", dbg_txdesc_index);
+		seq_printf(s, "  MAC = 0x%08x 0x%08x 0x%08x 0x%08x\n",
+			   u[0], u[1], u[2], u[3]);
+		seq_printf(s, "  DMA = 0x%08x 0x%08x 0x%08x 0x%08x\n",
+			   u[4], u[5], u[6], u[7]);
+		seq_printf(s, "  SKB = %p\n", skb);
+
+		if (skb) {
+			unsigned char printbuf[16 * 3 + 2];
+			int i = 0;
+			int len = skb_headlen(skb);
+			void *p = skb->data;
+
+			seq_printf(s, "    len = %d\n", len);
+
+			while (i < len) {
+				int l = min(len - i, 16);
+				hex_dump_to_buffer(p + i, l, 16, 1, printbuf,
+						   sizeof(printbuf), false);
+				seq_printf(s, "      : %s\n", printbuf);
+				i += l;
+			}
+		}
+		seq_printf(s, "}\n");
+	} else {
+		seq_printf(s, "TxDesc index (%d) >= size (%d)\n",
+			   dbg_txdesc_index, vring->size);
+	}
+
+	return 0;
+}
+
+static int wil_txdesc_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wil_txdesc_debugfs_show, inode->i_private);
+}
+
+static const struct file_operations fops_txdesc = {
+	.open		= wil_txdesc_seq_open,
+	.release	= single_release,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
+/*---------beamforming------------*/
+static int wil_bf_debugfs_show(struct seq_file *s, void *data)
+{
+	struct wil6210_priv *wil = s->private;
+	seq_printf(s,
+		   "TSF : 0x%016llx\n"
+		   "TxMCS : %d\n"
+		   "Sectors(rx:tx) my %2d:%2d peer %2d:%2d\n",
+		   wil->stats.tsf, wil->stats.bf_mcs,
+		   wil->stats.my_rx_sector, wil->stats.my_tx_sector,
+		   wil->stats.peer_rx_sector, wil->stats.peer_tx_sector);
+	return 0;
+}
+
+static int wil_bf_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wil_bf_debugfs_show, inode->i_private);
+}
+
+static const struct file_operations fops_bf = {
+	.open		= wil_bf_seq_open,
+	.release	= single_release,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+/*---------SSID------------*/
+static ssize_t wil_read_file_ssid(struct file *file, char __user *user_buf,
+				  size_t count, loff_t *ppos)
+{
+	struct wil6210_priv *wil = file->private_data;
+	struct wireless_dev *wdev = wil_to_wdev(wil);
+
+	return simple_read_from_buffer(user_buf, count, ppos,
+				       wdev->ssid, wdev->ssid_len);
+}
+
+static ssize_t wil_write_file_ssid(struct file *file, const char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	struct wil6210_priv *wil = file->private_data;
+	struct wireless_dev *wdev = wil_to_wdev(wil);
+	struct net_device *ndev = wil_to_ndev(wil);
+
+	if (*ppos != 0) {
+		wil_err(wil, "Unable to set SSID substring from [%d]\n",
+			(int)*ppos);
+		return -EINVAL;
+	}
+
+	if (count > sizeof(wdev->ssid)) {
+		wil_err(wil, "SSID too long, len = %d\n", (int)count);
+		return -EINVAL;
+	}
+	if (netif_running(ndev)) {
+		wil_err(wil, "Unable to change SSID on running interface\n");
+		return -EINVAL;
+	}
+
+	wdev->ssid_len = count;
+	return simple_write_to_buffer(wdev->ssid, wdev->ssid_len, ppos,
+				      buf, count);
+}
+
+static const struct file_operations fops_ssid = {
+	.read = wil_read_file_ssid,
+	.write = wil_write_file_ssid,
+	.open  = wil_default_open,
+};
+
+/*----------------*/
+int wil6210_debugfs_init(struct wil6210_priv *wil)
+{
+	struct dentry *dbg = wil->debug = debugfs_create_dir(WIL_NAME,
+			wil_to_wiphy(wil)->debugfsdir);
+
+	if (IS_ERR_OR_NULL(dbg))
+		return -ENODEV;
+
+	debugfs_create_file("mbox", S_IRUGO, dbg, wil, &fops_mbox);
+	debugfs_create_file("vrings", S_IRUGO, dbg, wil, &fops_vring);
+	debugfs_create_file("txdesc", S_IRUGO, dbg, wil, &fops_txdesc);
+	debugfs_create_u32("txdesc_index", S_IRUGO | S_IWUSR, dbg,
+			   &dbg_txdesc_index);
+	debugfs_create_file("bf", S_IRUGO, dbg, wil, &fops_bf);
+	debugfs_create_file("ssid", S_IRUGO | S_IWUSR, dbg, wil, &fops_ssid);
+	debugfs_create_u32("secure_pcp", S_IRUGO | S_IWUSR, dbg,
+			   &wil->secure_pcp);
+
+	wil6210_debugfs_create_ISR(wil, "USER_ICR", dbg,
+				   HOSTADDR(RGF_USER_USER_ICR));
+	wil6210_debugfs_create_ISR(wil, "DMA_EP_TX_ICR", dbg,
+				   HOSTADDR(RGF_DMA_EP_TX_ICR));
+	wil6210_debugfs_create_ISR(wil, "DMA_EP_RX_ICR", dbg,
+				   HOSTADDR(RGF_DMA_EP_RX_ICR));
+	wil6210_debugfs_create_ISR(wil, "DMA_EP_MISC_ICR", dbg,
+				   HOSTADDR(RGF_DMA_EP_MISC_ICR));
+	wil6210_debugfs_create_pseudo_ISR(wil, dbg);
+	wil6210_debugfs_create_ITR_CNT(wil, dbg);
+
+	debugfs_create_u32("mem_addr", S_IRUGO | S_IWUSR, dbg, &mem_addr);
+	debugfs_create_file("mem_val", S_IRUGO, dbg, wil, &fops_memread);
+
+	debugfs_create_file("reset", S_IWUSR, dbg, wil, &fops_reset);
+
+	wil->rgf_blob.data = (void * __force)wil->csr + 0;
+	wil->rgf_blob.size = 0xa000;
+	wil_debugfs_create_ioblob("blob_rgf", S_IRUGO, dbg, &wil->rgf_blob);
+
+	wil->fw_code_blob.data = (void * __force)wil->csr + 0x40000;
+	wil->fw_code_blob.size = 0x40000;
+	wil_debugfs_create_ioblob("blob_fw_code", S_IRUGO, dbg,
+				  &wil->fw_code_blob);
+
+	wil->fw_data_blob.data = (void * __force)wil->csr + 0x80000;
+	wil->fw_data_blob.size = 0x8000;
+	wil_debugfs_create_ioblob("blob_fw_data", S_IRUGO, dbg,
+				  &wil->fw_data_blob);
+
+	wil->fw_peri_blob.data = (void * __force)wil->csr + 0x88000;
+	wil->fw_peri_blob.size = 0x18000;
+	wil_debugfs_create_ioblob("blob_fw_peri", S_IRUGO, dbg,
+				  &wil->fw_peri_blob);
+
+	wil->uc_code_blob.data = (void * __force)wil->csr + 0xa0000;
+	wil->uc_code_blob.size = 0x10000;
+	wil_debugfs_create_ioblob("blob_uc_code", S_IRUGO, dbg,
+				  &wil->uc_code_blob);
+
+	wil->uc_data_blob.data = (void * __force)wil->csr + 0xb0000;
+	wil->uc_data_blob.size = 0x4000;
+	wil_debugfs_create_ioblob("blob_uc_data", S_IRUGO, dbg,
+				  &wil->uc_data_blob);
+
+	return 0;
+}
+
+void wil6210_debugfs_remove(struct wil6210_priv *wil)
+{
+	debugfs_remove_recursive(wil->debug);
+	wil->debug = NULL;
+}
diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
new file mode 100644
index 0000000..38049da
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -0,0 +1,471 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/interrupt.h>
+
+#include "wil6210.h"
+
+/**
+ * Theory of operation:
+ *
+ * There is ISR pseudo-cause register,
+ * dma_rgf->DMA_RGF.PSEUDO_CAUSE.PSEUDO_CAUSE
+ * Its bits represents OR'ed bits from 3 real ISR registers:
+ * TX, RX, and MISC.
+ *
+ * Registers may be configured to either "write 1 to clear" or
+ * "clear on read" mode
+ *
+ * When handling interrupt, one have to mask/unmask interrupts for the
+ * real ISR registers, or hardware may malfunction.
+ *
+ */
+
+#define WIL6210_IRQ_DISABLE	(0xFFFFFFFFUL)
+#define WIL6210_IMC_RX		BIT_DMA_EP_RX_ICR_RX_DONE
+#define WIL6210_IMC_TX		(BIT_DMA_EP_TX_ICR_TX_DONE | \
+				BIT_DMA_EP_TX_ICR_TX_DONE_N(0))
+#define WIL6210_IMC_MISC	(ISR_MISC_FW_READY | ISR_MISC_MBOX_EVT)
+
+#define WIL6210_IRQ_PSEUDO_MASK (u32)(~(BIT_DMA_PSEUDO_CAUSE_RX | \
+					BIT_DMA_PSEUDO_CAUSE_TX | \
+					BIT_DMA_PSEUDO_CAUSE_MISC))
+
+#if defined(CONFIG_WIL6210_ISR_COR)
+/* configure to Clear-On-Read mode */
+#define WIL_ICR_ICC_VALUE	(0xFFFFFFFFUL)
+
+static inline void wil_icr_clear(u32 x, void __iomem *addr)
+{
+
+}
+#else /* defined(CONFIG_WIL6210_ISR_COR) */
+/* configure to Write-1-to-Clear mode */
+#define WIL_ICR_ICC_VALUE	(0UL)
+
+static inline void wil_icr_clear(u32 x, void __iomem *addr)
+{
+	iowrite32(x, addr);
+}
+#endif /* defined(CONFIG_WIL6210_ISR_COR) */
+
+static inline u32 wil_ioread32_and_clear(void __iomem *addr)
+{
+	u32 x = ioread32(addr);
+
+	wil_icr_clear(x, addr);
+
+	return x;
+}
+
+static void wil6210_mask_irq_tx(struct wil6210_priv *wil)
+{
+	iowrite32(WIL6210_IRQ_DISABLE, wil->csr +
+		  HOSTADDR(RGF_DMA_EP_TX_ICR) +
+		  offsetof(struct RGF_ICR, IMS));
+}
+
+static void wil6210_mask_irq_rx(struct wil6210_priv *wil)
+{
+	iowrite32(WIL6210_IRQ_DISABLE, wil->csr +
+		  HOSTADDR(RGF_DMA_EP_RX_ICR) +
+		  offsetof(struct RGF_ICR, IMS));
+}
+
+static void wil6210_mask_irq_misc(struct wil6210_priv *wil)
+{
+	iowrite32(WIL6210_IRQ_DISABLE, wil->csr +
+		  HOSTADDR(RGF_DMA_EP_MISC_ICR) +
+		  offsetof(struct RGF_ICR, IMS));
+}
+
+static void wil6210_mask_irq_pseudo(struct wil6210_priv *wil)
+{
+	wil_dbg_IRQ(wil, "%s()\n", __func__);
+
+	iowrite32(WIL6210_IRQ_DISABLE, wil->csr +
+		  HOSTADDR(RGF_DMA_PSEUDO_CAUSE_MASK_SW));
+
+	clear_bit(wil_status_irqen, &wil->status);
+}
+
+static void wil6210_unmask_irq_tx(struct wil6210_priv *wil)
+{
+	iowrite32(WIL6210_IMC_TX, wil->csr +
+		  HOSTADDR(RGF_DMA_EP_TX_ICR) +
+		  offsetof(struct RGF_ICR, IMC));
+}
+
+static void wil6210_unmask_irq_rx(struct wil6210_priv *wil)
+{
+	iowrite32(WIL6210_IMC_RX, wil->csr +
+		  HOSTADDR(RGF_DMA_EP_RX_ICR) +
+		  offsetof(struct RGF_ICR, IMC));
+}
+
+static void wil6210_unmask_irq_misc(struct wil6210_priv *wil)
+{
+	iowrite32(WIL6210_IMC_MISC, wil->csr +
+		  HOSTADDR(RGF_DMA_EP_MISC_ICR) +
+		  offsetof(struct RGF_ICR, IMC));
+}
+
+static void wil6210_unmask_irq_pseudo(struct wil6210_priv *wil)
+{
+	wil_dbg_IRQ(wil, "%s()\n", __func__);
+
+	set_bit(wil_status_irqen, &wil->status);
+
+	iowrite32(WIL6210_IRQ_PSEUDO_MASK, wil->csr +
+		  HOSTADDR(RGF_DMA_PSEUDO_CAUSE_MASK_SW));
+}
+
+void wil6210_disable_irq(struct wil6210_priv *wil)
+{
+	wil_dbg_IRQ(wil, "%s()\n", __func__);
+
+	wil6210_mask_irq_tx(wil);
+	wil6210_mask_irq_rx(wil);
+	wil6210_mask_irq_misc(wil);
+	wil6210_mask_irq_pseudo(wil);
+}
+
+void wil6210_enable_irq(struct wil6210_priv *wil)
+{
+	wil_dbg_IRQ(wil, "%s()\n", __func__);
+
+	iowrite32(WIL_ICR_ICC_VALUE, wil->csr + HOSTADDR(RGF_DMA_EP_RX_ICR) +
+		  offsetof(struct RGF_ICR, ICC));
+	iowrite32(WIL_ICR_ICC_VALUE, wil->csr + HOSTADDR(RGF_DMA_EP_TX_ICR) +
+		  offsetof(struct RGF_ICR, ICC));
+	iowrite32(WIL_ICR_ICC_VALUE, wil->csr + HOSTADDR(RGF_DMA_EP_MISC_ICR) +
+		  offsetof(struct RGF_ICR, ICC));
+
+	wil6210_unmask_irq_pseudo(wil);
+	wil6210_unmask_irq_tx(wil);
+	wil6210_unmask_irq_rx(wil);
+	wil6210_unmask_irq_misc(wil);
+}
+
+static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
+{
+	struct wil6210_priv *wil = cookie;
+	u32 isr = wil_ioread32_and_clear(wil->csr +
+					 HOSTADDR(RGF_DMA_EP_RX_ICR) +
+					 offsetof(struct RGF_ICR, ICR));
+
+	wil_dbg_IRQ(wil, "ISR RX 0x%08x\n", isr);
+
+	if (!isr) {
+		wil_err(wil, "spurious IRQ: RX\n");
+		return IRQ_NONE;
+	}
+
+	wil6210_mask_irq_rx(wil);
+
+	if (isr & BIT_DMA_EP_RX_ICR_RX_DONE) {
+		wil_dbg_IRQ(wil, "RX done\n");
+		isr &= ~BIT_DMA_EP_RX_ICR_RX_DONE;
+		wil_rx_handle(wil);
+	}
+
+	if (isr)
+		wil_err(wil, "un-handled RX ISR bits 0x%08x\n", isr);
+
+	wil6210_unmask_irq_rx(wil);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t wil6210_irq_tx(int irq, void *cookie)
+{
+	struct wil6210_priv *wil = cookie;
+	u32 isr = wil_ioread32_and_clear(wil->csr +
+					 HOSTADDR(RGF_DMA_EP_TX_ICR) +
+					 offsetof(struct RGF_ICR, ICR));
+
+	wil_dbg_IRQ(wil, "ISR TX 0x%08x\n", isr);
+
+	if (!isr) {
+		wil_err(wil, "spurious IRQ: TX\n");
+		return IRQ_NONE;
+	}
+
+	wil6210_mask_irq_tx(wil);
+
+	if (isr & BIT_DMA_EP_TX_ICR_TX_DONE) {
+		uint i;
+		wil_dbg_IRQ(wil, "TX done\n");
+		isr &= ~BIT_DMA_EP_TX_ICR_TX_DONE;
+		for (i = 0; i < 24; i++) {
+			u32 mask = BIT_DMA_EP_TX_ICR_TX_DONE_N(i);
+			if (isr & mask) {
+				isr &= ~mask;
+				wil_dbg_IRQ(wil, "TX done(%i)\n", i);
+				wil_tx_complete(wil, i);
+			}
+		}
+	}
+
+	if (isr)
+		wil_err(wil, "un-handled TX ISR bits 0x%08x\n", isr);
+
+	wil6210_unmask_irq_tx(wil);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
+{
+	struct wil6210_priv *wil = cookie;
+	u32 isr = wil_ioread32_and_clear(wil->csr +
+					 HOSTADDR(RGF_DMA_EP_MISC_ICR) +
+					 offsetof(struct RGF_ICR, ICR));
+
+	wil_dbg_IRQ(wil, "ISR MISC 0x%08x\n", isr);
+
+	if (!isr) {
+		wil_err(wil, "spurious IRQ: MISC\n");
+		return IRQ_NONE;
+	}
+
+	wil6210_mask_irq_misc(wil);
+
+	if (isr & ISR_MISC_FW_READY) {
+		wil_dbg_IRQ(wil, "IRQ: FW ready\n");
+		/**
+		 * Actual FW ready indicated by the
+		 * WMI_FW_READY_EVENTID
+		 */
+		isr &= ~ISR_MISC_FW_READY;
+	}
+
+	wil->isr_misc = isr;
+
+	if (isr) {
+		return IRQ_WAKE_THREAD;
+	} else {
+		wil6210_unmask_irq_misc(wil);
+		return IRQ_HANDLED;
+	}
+}
+
+static irqreturn_t wil6210_irq_misc_thread(int irq, void *cookie)
+{
+	struct wil6210_priv *wil = cookie;
+	u32 isr = wil->isr_misc;
+
+	wil_dbg_IRQ(wil, "Thread ISR MISC 0x%08x\n", isr);
+
+	if (isr & ISR_MISC_MBOX_EVT) {
+		wil_dbg_IRQ(wil, "MBOX event\n");
+		wmi_recv_cmd(wil);
+		isr &= ~ISR_MISC_MBOX_EVT;
+	}
+
+	if (isr)
+		wil_err(wil, "un-handled MISC ISR bits 0x%08x\n", isr);
+
+	wil->isr_misc = 0;
+
+	wil6210_unmask_irq_misc(wil);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * thread IRQ handler
+ */
+static irqreturn_t wil6210_thread_irq(int irq, void *cookie)
+{
+	struct wil6210_priv *wil = cookie;
+
+	wil_dbg_IRQ(wil, "Thread IRQ\n");
+	/* Discover real IRQ cause */
+	if (wil->isr_misc)
+		wil6210_irq_misc_thread(irq, cookie);
+
+	wil6210_unmask_irq_pseudo(wil);
+
+	return IRQ_HANDLED;
+}
+
+/* DEBUG
+ * There is subtle bug in hardware that causes IRQ to raise when it should be
+ * masked. It is quite rare and hard to debug.
+ *
+ * Catch irq issue if it happens and print all I can.
+ */
+static int wil6210_debug_irq_mask(struct wil6210_priv *wil, u32 pseudo_cause)
+{
+	if (!test_bit(wil_status_irqen, &wil->status)) {
+		u32 icm_rx = wil_ioread32_and_clear(wil->csr +
+				HOSTADDR(RGF_DMA_EP_RX_ICR) +
+				offsetof(struct RGF_ICR, ICM));
+		u32 icr_rx = wil_ioread32_and_clear(wil->csr +
+				HOSTADDR(RGF_DMA_EP_RX_ICR) +
+				offsetof(struct RGF_ICR, ICR));
+		u32 imv_rx = ioread32(wil->csr +
+				HOSTADDR(RGF_DMA_EP_RX_ICR) +
+				offsetof(struct RGF_ICR, IMV));
+		u32 icm_tx = wil_ioread32_and_clear(wil->csr +
+				HOSTADDR(RGF_DMA_EP_TX_ICR) +
+				offsetof(struct RGF_ICR, ICM));
+		u32 icr_tx = wil_ioread32_and_clear(wil->csr +
+				HOSTADDR(RGF_DMA_EP_TX_ICR) +
+				offsetof(struct RGF_ICR, ICR));
+		u32 imv_tx = ioread32(wil->csr +
+				HOSTADDR(RGF_DMA_EP_TX_ICR) +
+				offsetof(struct RGF_ICR, IMV));
+		u32 icm_misc = wil_ioread32_and_clear(wil->csr +
+				HOSTADDR(RGF_DMA_EP_MISC_ICR) +
+				offsetof(struct RGF_ICR, ICM));
+		u32 icr_misc = wil_ioread32_and_clear(wil->csr +
+				HOSTADDR(RGF_DMA_EP_MISC_ICR) +
+				offsetof(struct RGF_ICR, ICR));
+		u32 imv_misc = ioread32(wil->csr +
+				HOSTADDR(RGF_DMA_EP_MISC_ICR) +
+				offsetof(struct RGF_ICR, IMV));
+		wil_err(wil, "IRQ when it should be masked: pseudo 0x%08x\n"
+				"Rx   icm:icr:imv 0x%08x 0x%08x 0x%08x\n"
+				"Tx   icm:icr:imv 0x%08x 0x%08x 0x%08x\n"
+				"Misc icm:icr:imv 0x%08x 0x%08x 0x%08x\n",
+				pseudo_cause,
+				icm_rx, icr_rx, imv_rx,
+				icm_tx, icr_tx, imv_tx,
+				icm_misc, icr_misc, imv_misc);
+
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static irqreturn_t wil6210_hardirq(int irq, void *cookie)
+{
+	irqreturn_t rc = IRQ_HANDLED;
+	struct wil6210_priv *wil = cookie;
+	u32 pseudo_cause = ioread32(wil->csr + HOSTADDR(RGF_DMA_PSEUDO_CAUSE));
+
+	/**
+	 * pseudo_cause is Clear-On-Read, no need to ACK
+	 */
+	if ((pseudo_cause == 0) || ((pseudo_cause & 0xff) == 0xff))
+		return IRQ_NONE;
+
+	/* FIXME: IRQ mask debug */
+	if (wil6210_debug_irq_mask(wil, pseudo_cause))
+		return IRQ_NONE;
+
+	wil6210_mask_irq_pseudo(wil);
+
+	/* Discover real IRQ cause
+	 * There are 2 possible phases for every IRQ:
+	 * - hard IRQ handler called right here
+	 * - threaded handler called later
+	 *
+	 * Hard IRQ handler reads and clears ISR.
+	 *
+	 * If threaded handler requested, hard IRQ handler
+	 * returns IRQ_WAKE_THREAD and saves ISR register value
+	 * for the threaded handler use.
+	 *
+	 * voting for wake thread - need at least 1 vote
+	 */
+	if ((pseudo_cause & BIT_DMA_PSEUDO_CAUSE_RX) &&
+	    (wil6210_irq_rx(irq, cookie) == IRQ_WAKE_THREAD))
+		rc = IRQ_WAKE_THREAD;
+
+	if ((pseudo_cause & BIT_DMA_PSEUDO_CAUSE_TX) &&
+	    (wil6210_irq_tx(irq, cookie) == IRQ_WAKE_THREAD))
+		rc = IRQ_WAKE_THREAD;
+
+	if ((pseudo_cause & BIT_DMA_PSEUDO_CAUSE_MISC) &&
+	    (wil6210_irq_misc(irq, cookie) == IRQ_WAKE_THREAD))
+		rc = IRQ_WAKE_THREAD;
+
+	/* if thread is requested, it will unmask IRQ */
+	if (rc != IRQ_WAKE_THREAD)
+		wil6210_unmask_irq_pseudo(wil);
+
+	wil_dbg_IRQ(wil, "Hard IRQ 0x%08x\n", pseudo_cause);
+
+	return rc;
+}
+
+static int wil6210_request_3msi(struct wil6210_priv *wil, int irq)
+{
+	int rc;
+	/*
+	 * IRQ's are in the following order:
+	 * - Tx
+	 * - Rx
+	 * - Misc
+	 */
+
+	rc = request_irq(irq, wil6210_irq_tx, IRQF_SHARED,
+			 WIL_NAME"_tx", wil);
+	if (rc)
+		return rc;
+
+	rc = request_irq(irq + 1, wil6210_irq_rx, IRQF_SHARED,
+			 WIL_NAME"_rx", wil);
+	if (rc)
+		goto free0;
+
+	rc = request_threaded_irq(irq + 2, wil6210_irq_misc,
+				  wil6210_irq_misc_thread,
+				  IRQF_SHARED, WIL_NAME"_misc", wil);
+	if (rc)
+		goto free1;
+
+	return 0;
+	/* error branch */
+free1:
+	free_irq(irq + 1, wil);
+free0:
+	free_irq(irq, wil);
+
+	return rc;
+}
+
+int wil6210_init_irq(struct wil6210_priv *wil, int irq)
+{
+	int rc;
+	if (wil->n_msi == 3)
+		rc = wil6210_request_3msi(wil, irq);
+	else
+		rc = request_threaded_irq(irq, wil6210_hardirq,
+					  wil6210_thread_irq,
+					  wil->n_msi ? 0 : IRQF_SHARED,
+					  WIL_NAME, wil);
+	if (rc)
+		return rc;
+
+	wil6210_enable_irq(wil);
+
+	return 0;
+}
+
+void wil6210_fini_irq(struct wil6210_priv *wil, int irq)
+{
+	wil6210_disable_irq(wil);
+	free_irq(irq, wil);
+	if (wil->n_msi == 3) {
+		free_irq(irq + 1, wil);
+		free_irq(irq + 2, wil);
+	}
+}
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
new file mode 100644
index 0000000..95fcd36
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -0,0 +1,407 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/sched.h>
+#include <linux/ieee80211.h>
+#include <linux/wireless.h>
+#include <linux/slab.h>
+#include <linux/moduleparam.h>
+#include <linux/if_arp.h>
+
+#include "wil6210.h"
+
+/*
+ * Due to a hardware issue,
+ * one has to read/write to/from NIC in 32-bit chunks;
+ * regular memcpy_fromio and siblings will
+ * not work on 64-bit platform - it uses 64-bit transactions
+ *
+ * Force 32-bit transactions to enable NIC on 64-bit platforms
+ *
+ * To avoid byte swap on big endian host, __raw_{read|write}l
+ * should be used - {read|write}l would swap bytes to provide
+ * little endian on PCI value in host endianness.
+ */
+void wil_memcpy_fromio_32(void *dst, const volatile void __iomem *src,
+			  size_t count)
+{
+	u32 *d = dst;
+	const volatile u32 __iomem *s = src;
+
+	/* size_t is unsigned, if (count%4 != 0) it will wrap */
+	for (count += 4; count > 4; count -= 4)
+		*d++ = __raw_readl(s++);
+}
+
+void wil_memcpy_toio_32(volatile void __iomem *dst, const void *src,
+			size_t count)
+{
+	volatile u32 __iomem *d = dst;
+	const u32 *s = src;
+
+	for (count += 4; count > 4; count -= 4)
+		__raw_writel(*s++, d++);
+}
+
+static void _wil6210_disconnect(struct wil6210_priv *wil, void *bssid)
+{
+	uint i;
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct wireless_dev *wdev = wil->wdev;
+
+	wil_dbg(wil, "%s()\n", __func__);
+
+	wil_link_off(wil);
+	clear_bit(wil_status_fwconnected, &wil->status);
+
+	switch (wdev->sme_state) {
+	case CFG80211_SME_CONNECTED:
+		cfg80211_disconnected(ndev, WLAN_STATUS_UNSPECIFIED_FAILURE,
+				      NULL, 0, GFP_KERNEL);
+		break;
+	case CFG80211_SME_CONNECTING:
+		cfg80211_connect_result(ndev, bssid, NULL, 0, NULL, 0,
+					WLAN_STATUS_UNSPECIFIED_FAILURE,
+					GFP_KERNEL);
+		break;
+	default:
+		;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(wil->vring_tx); i++)
+		wil_vring_fini_tx(wil, i);
+}
+
+static void wil_disconnect_worker(struct work_struct *work)
+{
+	struct wil6210_priv *wil = container_of(work,
+			struct wil6210_priv, disconnect_worker);
+
+	_wil6210_disconnect(wil, NULL);
+}
+
+static void wil_connect_timer_fn(ulong x)
+{
+	struct wil6210_priv *wil = (void *)x;
+
+	wil_dbg(wil, "Connect timeout\n");
+
+	/* reschedule to thread context - disconnect won't
+	 * run from atomic context
+	 */
+	schedule_work(&wil->disconnect_worker);
+}
+
+int wil_priv_init(struct wil6210_priv *wil)
+{
+	wil_dbg(wil, "%s()\n", __func__);
+
+	mutex_init(&wil->mutex);
+	mutex_init(&wil->wmi_mutex);
+
+	init_completion(&wil->wmi_ready);
+
+	wil->pending_connect_cid = -1;
+	setup_timer(&wil->connect_timer, wil_connect_timer_fn, (ulong)wil);
+
+	INIT_WORK(&wil->wmi_connect_worker, wmi_connect_worker);
+	INIT_WORK(&wil->disconnect_worker, wil_disconnect_worker);
+	INIT_WORK(&wil->wmi_event_worker, wmi_event_worker);
+
+	INIT_LIST_HEAD(&wil->pending_wmi_ev);
+	spin_lock_init(&wil->wmi_ev_lock);
+
+	wil->wmi_wq = create_singlethread_workqueue(WIL_NAME"_wmi");
+	if (!wil->wmi_wq)
+		return -EAGAIN;
+
+	wil->wmi_wq_conn = create_singlethread_workqueue(WIL_NAME"_connect");
+	if (!wil->wmi_wq_conn) {
+		destroy_workqueue(wil->wmi_wq);
+		return -EAGAIN;
+	}
+
+	/* make shadow copy of registers that should not change on run time */
+	wil_memcpy_fromio_32(&wil->mbox_ctl, wil->csr + HOST_MBOX,
+			     sizeof(struct wil6210_mbox_ctl));
+	wil_mbox_ring_le2cpus(&wil->mbox_ctl.rx);
+	wil_mbox_ring_le2cpus(&wil->mbox_ctl.tx);
+
+	return 0;
+}
+
+void wil6210_disconnect(struct wil6210_priv *wil, void *bssid)
+{
+	del_timer_sync(&wil->connect_timer);
+	_wil6210_disconnect(wil, bssid);
+}
+
+void wil_priv_deinit(struct wil6210_priv *wil)
+{
+	cancel_work_sync(&wil->disconnect_worker);
+	wil6210_disconnect(wil, NULL);
+	wmi_event_flush(wil);
+	destroy_workqueue(wil->wmi_wq_conn);
+	destroy_workqueue(wil->wmi_wq);
+}
+
+static void wil_target_reset(struct wil6210_priv *wil)
+{
+	wil_dbg(wil, "Resetting...\n");
+
+	/* register write */
+#define W(a, v) iowrite32(v, wil->csr + HOSTADDR(a))
+	/* register set = read, OR, write */
+#define S(a, v) iowrite32(ioread32(wil->csr + HOSTADDR(a)) | v, \
+		wil->csr + HOSTADDR(a))
+
+	/* hpal_perst_from_pad_src_n_mask */
+	S(RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT(6));
+	/* car_perst_rst_src_n_mask */
+	S(RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT(7));
+
+	W(RGF_USER_MAC_CPU_0,  BIT(1)); /* mac_cpu_man_rst */
+	W(RGF_USER_USER_CPU_0, BIT(1)); /* user_cpu_man_rst */
+
+	msleep(100);
+
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0xFE000000);
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_1, 0x0000003F);
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0x00000170);
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0xFFE7FC00);
+
+	msleep(100);
+
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0);
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0);
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_1, 0);
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
+
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0x00000001);
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0x00000080);
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
+
+	msleep(2000);
+
+	W(RGF_USER_USER_CPU_0, BIT(0)); /* user_cpu_man_de_rst */
+
+	msleep(2000);
+
+	wil_dbg(wil, "Reset completed\n");
+
+#undef W
+#undef S
+}
+
+void wil_mbox_ring_le2cpus(struct wil6210_mbox_ring *r)
+{
+	le32_to_cpus(&r->base);
+	le16_to_cpus(&r->entry_size);
+	le16_to_cpus(&r->size);
+	le32_to_cpus(&r->tail);
+	le32_to_cpus(&r->head);
+}
+
+static int wil_wait_for_fw_ready(struct wil6210_priv *wil)
+{
+	ulong to = msecs_to_jiffies(1000);
+	ulong left = wait_for_completion_timeout(&wil->wmi_ready, to);
+	if (0 == left) {
+		wil_err(wil, "Firmware not ready\n");
+		return -ETIME;
+	} else {
+		wil_dbg(wil, "FW ready after %d ms\n",
+			jiffies_to_msecs(to-left));
+	}
+	return 0;
+}
+
+/*
+ * We reset all the structures, and we reset the UMAC.
+ * After calling this routine, you're expected to reload
+ * the firmware.
+ */
+int wil_reset(struct wil6210_priv *wil)
+{
+	int rc;
+
+	cancel_work_sync(&wil->disconnect_worker);
+	wil6210_disconnect(wil, NULL);
+
+	wmi_event_flush(wil);
+
+	flush_workqueue(wil->wmi_wq);
+	flush_workqueue(wil->wmi_wq_conn);
+
+	wil6210_disable_irq(wil);
+	wil->status = 0;
+
+	/* TODO: put MAC in reset */
+	wil_target_reset(wil);
+
+	/* init after reset */
+	wil->pending_connect_cid = -1;
+	INIT_COMPLETION(wil->wmi_ready);
+
+	/* make shadow copy of registers that should not change on run time */
+	wil_memcpy_fromio_32(&wil->mbox_ctl, wil->csr + HOST_MBOX,
+			     sizeof(struct wil6210_mbox_ctl));
+	wil_mbox_ring_le2cpus(&wil->mbox_ctl.rx);
+	wil_mbox_ring_le2cpus(&wil->mbox_ctl.tx);
+
+	/* TODO: release MAC reset */
+	wil6210_enable_irq(wil);
+
+	/* we just started MAC, wait for FW ready */
+	rc = wil_wait_for_fw_ready(wil);
+
+	return rc;
+}
+
+
+void wil_link_on(struct wil6210_priv *wil)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+
+	wil_dbg(wil, "%s()\n", __func__);
+
+	netif_carrier_on(ndev);
+	netif_tx_wake_all_queues(ndev);
+}
+
+void wil_link_off(struct wil6210_priv *wil)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+
+	wil_dbg(wil, "%s()\n", __func__);
+
+	netif_tx_stop_all_queues(ndev);
+	netif_carrier_off(ndev);
+}
+
+static int __wil_up(struct wil6210_priv *wil)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct wireless_dev *wdev = wil->wdev;
+	struct ieee80211_channel *channel = wdev->preset_chandef.chan;
+	int rc;
+	int bi;
+	u16 wmi_nettype = wil_iftype_nl2wmi(wdev->iftype);
+
+	rc = wil_reset(wil);
+	if (rc)
+		return rc;
+
+	/* FIXME Firmware works now in PBSS mode(ToDS=0, FromDS=0) */
+	wmi_nettype = wil_iftype_nl2wmi(NL80211_IFTYPE_ADHOC);
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_STATION:
+		wil_dbg(wil, "type: STATION\n");
+		bi = 0;
+		ndev->type = ARPHRD_ETHER;
+		break;
+	case NL80211_IFTYPE_AP:
+		wil_dbg(wil, "type: AP\n");
+		bi = 100;
+		ndev->type = ARPHRD_ETHER;
+		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+		wil_dbg(wil, "type: P2P_CLIENT\n");
+		bi = 0;
+		ndev->type = ARPHRD_ETHER;
+		break;
+	case NL80211_IFTYPE_P2P_GO:
+		wil_dbg(wil, "type: P2P_GO\n");
+		bi = 100;
+		ndev->type = ARPHRD_ETHER;
+		break;
+	case NL80211_IFTYPE_MONITOR:
+		wil_dbg(wil, "type: Monitor\n");
+		bi = 0;
+		ndev->type = ARPHRD_IEEE80211_RADIOTAP;
+		/* ARPHRD_IEEE80211 or ARPHRD_IEEE80211_RADIOTAP ? */
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	/* Apply profile in the following order: */
+	/* SSID and channel for the AP */
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+		if (wdev->ssid_len == 0) {
+			wil_err(wil, "SSID not set\n");
+			return -EINVAL;
+		}
+		wmi_set_ssid(wil, wdev->ssid_len, wdev->ssid);
+		if (channel)
+			wmi_set_channel(wil, channel->hw_value);
+		break;
+	default:
+		;
+	}
+
+	/* MAC address - pre-requisite for other commands */
+	wmi_set_mac_address(wil, ndev->dev_addr);
+
+	/* Set up beaconing if required. */
+	rc = wmi_set_bcon(wil, bi, wmi_nettype);
+	if (rc)
+		return rc;
+
+	/* Rx VRING. After MAC and beacon */
+	wil_rx_init(wil);
+
+	return 0;
+}
+
+int wil_up(struct wil6210_priv *wil)
+{
+	int rc;
+
+	mutex_lock(&wil->mutex);
+	rc = __wil_up(wil);
+	mutex_unlock(&wil->mutex);
+
+	return rc;
+}
+
+static int __wil_down(struct wil6210_priv *wil)
+{
+	if (wil->scan_request) {
+		cfg80211_scan_done(wil->scan_request, true);
+		wil->scan_request = NULL;
+	}
+
+	wil6210_disconnect(wil, NULL);
+	wil_rx_fini(wil);
+
+	return 0;
+}
+
+int wil_down(struct wil6210_priv *wil)
+{
+	int rc;
+
+	mutex_lock(&wil->mutex);
+	rc = __wil_down(wil);
+	mutex_unlock(&wil->mutex);
+
+	return rc;
+}
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
new file mode 100644
index 0000000..3068b5c
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -0,0 +1,157 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/slab.h>
+
+#include "wil6210.h"
+
+static int wil_open(struct net_device *ndev)
+{
+	struct wil6210_priv *wil = ndev_to_wil(ndev);
+
+	return wil_up(wil);
+}
+
+static int wil_stop(struct net_device *ndev)
+{
+	struct wil6210_priv *wil = ndev_to_wil(ndev);
+
+	return wil_down(wil);
+}
+
+/*
+ * AC to queue mapping
+ *
+ * AC_VO -> queue 3
+ * AC_VI -> queue 2
+ * AC_BE -> queue 1
+ * AC_BK -> queue 0
+ */
+static u16 wil_select_queue(struct net_device *ndev, struct sk_buff *skb)
+{
+	static const u16 wil_1d_to_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
+	struct wil6210_priv *wil = ndev_to_wil(ndev);
+	u16 rc;
+
+	skb->priority = cfg80211_classify8021d(skb);
+
+	rc = wil_1d_to_queue[skb->priority];
+
+	wil_dbg_TXRX(wil, "%s() %d -> %d\n", __func__, (int)skb->priority,
+		     (int)rc);
+
+	return rc;
+}
+
+static const struct net_device_ops wil_netdev_ops = {
+	.ndo_open		= wil_open,
+	.ndo_stop		= wil_stop,
+	.ndo_start_xmit		= wil_start_xmit,
+	.ndo_select_queue	= wil_select_queue,
+	.ndo_set_mac_address    = eth_mac_addr,
+	.ndo_validate_addr      = eth_validate_addr,
+};
+
+void *wil_if_alloc(struct device *dev, void __iomem *csr)
+{
+	struct net_device *ndev;
+	struct wireless_dev *wdev;
+	struct wil6210_priv *wil;
+	struct ieee80211_channel *ch;
+	int rc = 0;
+
+	wdev = wil_cfg80211_init(dev);
+	if (IS_ERR(wdev)) {
+		dev_err(dev, "wil_cfg80211_init failed\n");
+		return wdev;
+	}
+
+	wil = wdev_to_wil(wdev);
+	wil->csr = csr;
+	wil->wdev = wdev;
+
+	rc = wil_priv_init(wil);
+	if (rc) {
+		dev_err(dev, "wil_priv_init failed\n");
+		goto out_wdev;
+	}
+
+	wdev->iftype = NL80211_IFTYPE_STATION; /* TODO */
+	/* default monitor channel */
+	ch = wdev->wiphy->bands[IEEE80211_BAND_60GHZ]->channels;
+	cfg80211_chandef_create(&wdev->preset_chandef, ch, NL80211_CHAN_NO_HT);
+
+	ndev = alloc_netdev_mqs(0, "wlan%d", ether_setup, WIL6210_TX_QUEUES, 1);
+	if (!ndev) {
+		dev_err(dev, "alloc_netdev_mqs failed\n");
+		rc = -ENOMEM;
+		goto out_priv;
+	}
+
+	ndev->netdev_ops = &wil_netdev_ops;
+	ndev->ieee80211_ptr = wdev;
+	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
+	wdev->netdev = ndev;
+
+	wil_link_off(wil);
+
+	return wil;
+
+ out_priv:
+	wil_priv_deinit(wil);
+
+ out_wdev:
+	wil_wdev_free(wil);
+
+	return ERR_PTR(rc);
+}
+
+void wil_if_free(struct wil6210_priv *wil)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	if (!ndev)
+		return;
+
+	free_netdev(ndev);
+	wil_priv_deinit(wil);
+	wil_wdev_free(wil);
+}
+
+int wil_if_add(struct wil6210_priv *wil)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	int rc;
+
+	rc = register_netdev(ndev);
+	if (rc < 0) {
+		dev_err(&ndev->dev, "Failed to register netdev: %d\n", rc);
+		return rc;
+	}
+
+	wil_link_off(wil);
+
+	return 0;
+}
+
+void wil_if_remove(struct wil6210_priv *wil)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+
+	unregister_netdev(ndev);
+}
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
new file mode 100644
index 0000000..0fc83ed
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -0,0 +1,223 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/netdevice.h>
+#include <linux/debugfs.h>
+#include <linux/pci.h>
+#include <linux/moduleparam.h>
+
+#include "wil6210.h"
+
+static int use_msi = 1;
+module_param(use_msi, int, S_IRUGO);
+MODULE_PARM_DESC(use_msi,
+		 " Use MSI interrupt: "
+		 "0 - don't, 1 - (default) - single, or 3");
+
+/* Bus ops */
+static int wil_if_pcie_enable(struct wil6210_priv *wil)
+{
+	struct pci_dev *pdev = wil->pdev;
+	int rc;
+
+	pci_set_master(pdev);
+
+	/*
+	 * how many MSI interrupts to request?
+	 */
+	switch (use_msi) {
+	case 3:
+	case 1:
+	case 0:
+		break;
+	default:
+		wil_err(wil, "Invalid use_msi=%d, default to 1\n",
+			use_msi);
+		use_msi = 1;
+	}
+	wil->n_msi = use_msi;
+	if (wil->n_msi) {
+		wil_dbg(wil, "Setup %d MSI interrupts\n", use_msi);
+		rc = pci_enable_msi_block(pdev, wil->n_msi);
+		if (rc && (wil->n_msi == 3)) {
+			wil_err(wil, "3 MSI mode failed, try 1 MSI\n");
+			wil->n_msi = 1;
+			rc = pci_enable_msi_block(pdev, wil->n_msi);
+		}
+		if (rc) {
+			wil_err(wil, "pci_enable_msi failed, use INTx\n");
+			wil->n_msi = 0;
+		}
+	} else {
+		wil_dbg(wil, "MSI interrupts disabled, use INTx\n");
+	}
+
+	rc = wil6210_init_irq(wil, pdev->irq);
+	if (rc)
+		goto stop_master;
+
+	/* need reset here to obtain MAC */
+	rc = wil_reset(wil);
+	if (rc)
+		goto release_irq;
+
+	return 0;
+
+ release_irq:
+	wil6210_fini_irq(wil, pdev->irq);
+	/* safe to call if no MSI */
+	pci_disable_msi(pdev);
+ stop_master:
+	pci_clear_master(pdev);
+	return rc;
+}
+
+static int wil_if_pcie_disable(struct wil6210_priv *wil)
+{
+	struct pci_dev *pdev = wil->pdev;
+
+	pci_clear_master(pdev);
+	/* disable and release IRQ */
+	wil6210_fini_irq(wil, pdev->irq);
+	/* safe to call if no MSI */
+	pci_disable_msi(pdev);
+	/* TODO: disable HW */
+
+	return 0;
+}
+
+static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct wil6210_priv *wil;
+	struct device *dev = &pdev->dev;
+	void __iomem *csr;
+	int rc;
+
+	/* check HW */
+	dev_info(&pdev->dev, WIL_NAME " device found [%04x:%04x] (rev %x)\n",
+		 (int)pdev->vendor, (int)pdev->device, (int)pdev->revision);
+
+	if (pci_resource_len(pdev, 0) != WIL6210_MEM_SIZE) {
+		dev_err(&pdev->dev, "Not " WIL_NAME "? "
+			"BAR0 size is %lu while expecting %lu\n",
+			(ulong)pci_resource_len(pdev, 0), WIL6210_MEM_SIZE);
+		return -ENODEV;
+	}
+
+	rc = pci_enable_device(pdev);
+	if (rc) {
+		dev_err(&pdev->dev, "pci_enable_device failed\n");
+		return -ENODEV;
+	}
+	/* rollback to err_disable_pdev */
+
+	rc = pci_request_region(pdev, 0, WIL_NAME);
+	if (rc) {
+		dev_err(&pdev->dev, "pci_request_region failed\n");
+		goto err_disable_pdev;
+	}
+	/* rollback to err_release_reg */
+
+	csr = pci_ioremap_bar(pdev, 0);
+	if (!csr) {
+		dev_err(&pdev->dev, "pci_ioremap_bar failed\n");
+		rc = -ENODEV;
+		goto err_release_reg;
+	}
+	/* rollback to err_iounmap */
+	dev_info(&pdev->dev, "CSR at %pR -> %p\n", &pdev->resource[0], csr);
+
+	wil = wil_if_alloc(dev, csr);
+	if (IS_ERR(wil)) {
+		rc = (int)PTR_ERR(wil);
+		dev_err(dev, "wil_if_alloc failed: %d\n", rc);
+		goto err_iounmap;
+	}
+	/* rollback to if_free */
+
+	pci_set_drvdata(pdev, wil);
+	wil->pdev = pdev;
+
+	/* FW should raise IRQ when ready */
+	rc = wil_if_pcie_enable(wil);
+	if (rc) {
+		wil_err(wil, "Enable device failed\n");
+		goto if_free;
+	}
+	/* rollback to bus_disable */
+
+	rc = wil_if_add(wil);
+	if (rc) {
+		wil_err(wil, "wil_if_add failed: %d\n", rc);
+		goto bus_disable;
+	}
+
+	wil6210_debugfs_init(wil);
+
+	/* check FW is alive */
+	wmi_echo(wil);
+
+	return 0;
+
+ bus_disable:
+	wil_if_pcie_disable(wil);
+ if_free:
+	wil_if_free(wil);
+ err_iounmap:
+	pci_iounmap(pdev, csr);
+ err_release_reg:
+	pci_release_region(pdev, 0);
+ err_disable_pdev:
+	pci_disable_device(pdev);
+
+	return rc;
+}
+
+static void wil_pcie_remove(struct pci_dev *pdev)
+{
+	struct wil6210_priv *wil = pci_get_drvdata(pdev);
+
+	wil6210_debugfs_remove(wil);
+	wil_if_pcie_disable(wil);
+	wil_if_remove(wil);
+	wil_if_free(wil);
+	pci_iounmap(pdev, wil->csr);
+	pci_release_region(pdev, 0);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(wil6210_pcie_ids) = {
+	{ PCI_DEVICE(0x1ae9, 0x0301) },
+	{ /* end: all zeroes */	},
+};
+MODULE_DEVICE_TABLE(pci, wil6210_pcie_ids);
+
+static struct pci_driver wil6210_driver = {
+	.probe		= wil_pcie_probe,
+	.remove		= wil_pcie_remove,
+	.id_table	= wil6210_pcie_ids,
+	.name		= WIL_NAME,
+};
+
+module_pci_driver(wil6210_driver);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Qualcomm Atheros <wil6210@qca.qualcomm.com>");
+MODULE_DESCRIPTION("Driver for 60g WiFi WIL6210 card");
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
new file mode 100644
index 0000000..f29c294
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -0,0 +1,871 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/hardirq.h>
+#include <net/ieee80211_radiotap.h>
+#include <linux/if_arp.h>
+#include <linux/moduleparam.h>
+
+#include "wil6210.h"
+#include "wmi.h"
+#include "txrx.h"
+
+static bool rtap_include_phy_info;
+module_param(rtap_include_phy_info, bool, S_IRUGO);
+MODULE_PARM_DESC(rtap_include_phy_info,
+		 " Include PHY info in the radiotap header, default - no");
+
+static inline int wil_vring_is_empty(struct vring *vring)
+{
+	return vring->swhead == vring->swtail;
+}
+
+static inline u32 wil_vring_next_tail(struct vring *vring)
+{
+	return (vring->swtail + 1) % vring->size;
+}
+
+static inline void wil_vring_advance_head(struct vring *vring, int n)
+{
+	vring->swhead = (vring->swhead + n) % vring->size;
+}
+
+static inline int wil_vring_is_full(struct vring *vring)
+{
+	return wil_vring_next_tail(vring) == vring->swhead;
+}
+/*
+ * Available space in Tx Vring
+ */
+static inline int wil_vring_avail_tx(struct vring *vring)
+{
+	u32 swhead = vring->swhead;
+	u32 swtail = vring->swtail;
+	int used = (vring->size + swhead - swtail) % vring->size;
+
+	return vring->size - used - 1;
+}
+
+static int wil_vring_alloc(struct wil6210_priv *wil, struct vring *vring)
+{
+	struct device *dev = wil_to_dev(wil);
+	size_t sz = vring->size * sizeof(vring->va[0]);
+	uint i;
+
+	BUILD_BUG_ON(sizeof(vring->va[0]) != 32);
+
+	vring->swhead = 0;
+	vring->swtail = 0;
+	vring->ctx = kzalloc(vring->size * sizeof(vring->ctx[0]), GFP_KERNEL);
+	if (!vring->ctx) {
+		wil_err(wil, "vring_alloc [%d] failed to alloc ctx mem\n",
+			vring->size);
+		vring->va = NULL;
+		return -ENOMEM;
+	}
+	/*
+	 * vring->va should be aligned on its size rounded up to power of 2
+	 * This is granted by the dma_alloc_coherent
+	 */
+	vring->va = dma_alloc_coherent(dev, sz, &vring->pa, GFP_KERNEL);
+	if (!vring->va) {
+		wil_err(wil, "vring_alloc [%d] failed to alloc DMA mem\n",
+			vring->size);
+		kfree(vring->ctx);
+		vring->ctx = NULL;
+		return -ENOMEM;
+	}
+	/* initially, all descriptors are SW owned
+	 * For Tx and Rx, ownership bit is at the same location, thus
+	 * we can use any
+	 */
+	for (i = 0; i < vring->size; i++) {
+		volatile struct vring_tx_desc *d = &(vring->va[i].tx);
+		d->dma.status = TX_DMA_STATUS_DU;
+	}
+
+	wil_dbg(wil, "vring[%d] 0x%p:0x%016llx 0x%p\n", vring->size,
+		vring->va, (unsigned long long)vring->pa, vring->ctx);
+
+	return 0;
+}
+
+static void wil_vring_free(struct wil6210_priv *wil, struct vring *vring,
+			   int tx)
+{
+	struct device *dev = wil_to_dev(wil);
+	size_t sz = vring->size * sizeof(vring->va[0]);
+
+	while (!wil_vring_is_empty(vring)) {
+		if (tx) {
+			volatile struct vring_tx_desc *d =
+					&vring->va[vring->swtail].tx;
+			dma_addr_t pa = d->dma.addr_low |
+					((u64)d->dma.addr_high << 32);
+			struct sk_buff *skb = vring->ctx[vring->swtail];
+			if (skb) {
+				dma_unmap_single(dev, pa, d->dma.length,
+						 DMA_TO_DEVICE);
+				dev_kfree_skb_any(skb);
+				vring->ctx[vring->swtail] = NULL;
+			} else {
+				dma_unmap_page(dev, pa, d->dma.length,
+					       DMA_TO_DEVICE);
+			}
+			vring->swtail = wil_vring_next_tail(vring);
+		} else { /* rx */
+			volatile struct vring_rx_desc *d =
+					&vring->va[vring->swtail].rx;
+			dma_addr_t pa = d->dma.addr_low |
+					((u64)d->dma.addr_high << 32);
+			struct sk_buff *skb = vring->ctx[vring->swhead];
+			dma_unmap_single(dev, pa, d->dma.length,
+					 DMA_FROM_DEVICE);
+			kfree_skb(skb);
+			wil_vring_advance_head(vring, 1);
+		}
+	}
+	dma_free_coherent(dev, sz, (void *)vring->va, vring->pa);
+	kfree(vring->ctx);
+	vring->pa = 0;
+	vring->va = NULL;
+	vring->ctx = NULL;
+}
+
+/**
+ * Allocate one skb for Rx VRING
+ *
+ * Safe to call from IRQ
+ */
+static int wil_vring_alloc_skb(struct wil6210_priv *wil, struct vring *vring,
+			       u32 i, int headroom)
+{
+	struct device *dev = wil_to_dev(wil);
+	unsigned int sz = RX_BUF_LEN;
+	volatile struct vring_rx_desc *d = &(vring->va[i].rx);
+	dma_addr_t pa;
+
+	/* TODO align */
+	struct sk_buff *skb = dev_alloc_skb(sz + headroom);
+	if (unlikely(!skb))
+		return -ENOMEM;
+
+	skb_reserve(skb, headroom);
+	skb_put(skb, sz);
+
+	pa = dma_map_single(dev, skb->data, skb->len, DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(dev, pa))) {
+		kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	d->dma.d0 = BIT(9) | RX_DMA_D0_CMD_DMA_IT;
+	d->dma.addr_low = lower_32_bits(pa);
+	d->dma.addr_high = (u16)upper_32_bits(pa);
+	/* ip_length don't care */
+	/* b11 don't care */
+	/* error don't care */
+	d->dma.status = 0; /* BIT(0) should be 0 for HW_OWNED */
+	d->dma.length = sz;
+	vring->ctx[i] = skb;
+
+	return 0;
+}
+
+/**
+ * Adds radiotap header
+ *
+ * Any error indicated as "Bad FCS"
+ *
+ * Vendor data for 04:ce:14-1 (Wilocity-1) consists of:
+ *  - Rx descriptor: 32 bytes
+ *  - Phy info
+ */
+static void wil_rx_add_radiotap_header(struct wil6210_priv *wil,
+				       struct sk_buff *skb,
+				       volatile struct vring_rx_desc *d)
+{
+	struct wireless_dev *wdev = wil->wdev;
+	struct wil6210_rtap {
+		struct ieee80211_radiotap_header rthdr;
+		/* fields should be in the order of bits in rthdr.it_present */
+		/* flags */
+		u8 flags;
+		/* channel */
+		__le16 chnl_freq __aligned(2);
+		__le16 chnl_flags;
+		/* MCS */
+		u8 mcs_present;
+		u8 mcs_flags;
+		u8 mcs_index;
+	} __packed;
+	struct wil6210_rtap_vendor {
+		struct wil6210_rtap rtap;
+		/* vendor */
+		u8 vendor_oui[3] __aligned(2);
+		u8 vendor_ns;
+		__le16 vendor_skip;
+		u8 vendor_data[0];
+	} __packed;
+	struct wil6210_rtap_vendor *rtap_vendor;
+	int rtap_len = sizeof(struct wil6210_rtap);
+	int phy_length = 0; /* phy info header size, bytes */
+	static char phy_data[128];
+	struct ieee80211_channel *ch = wdev->preset_chandef.chan;
+
+	if (rtap_include_phy_info) {
+		rtap_len = sizeof(*rtap_vendor) + sizeof(*d);
+		/* calculate additional length */
+		if (d->dma.status & RX_DMA_STATUS_PHY_INFO) {
+			/**
+			 * PHY info starts from 8-byte boundary
+			 * there are 8-byte lines, last line may be partially
+			 * written (HW bug), thus FW configures for last line
+			 * to be excessive. Driver skips this last line.
+			 */
+			int len = min_t(int, 8 + sizeof(phy_data),
+					wil_rxdesc_phy_length(d));
+			if (len > 8) {
+				void *p = skb_tail_pointer(skb);
+				void *pa = PTR_ALIGN(p, 8);
+				if (skb_tailroom(skb) >= len + (pa - p)) {
+					phy_length = len - 8;
+					memcpy(phy_data, pa, phy_length);
+				}
+			}
+		}
+		rtap_len += phy_length;
+	}
+
+	if (skb_headroom(skb) < rtap_len &&
+	    pskb_expand_head(skb, rtap_len, 0, GFP_ATOMIC)) {
+		wil_err(wil, "Unable to expand headrom to %d\n", rtap_len);
+		return;
+	}
+
+	rtap_vendor = (void *)skb_push(skb, rtap_len);
+	memset(rtap_vendor, 0, rtap_len);
+
+	rtap_vendor->rtap.rthdr.it_version = PKTHDR_RADIOTAP_VERSION;
+	rtap_vendor->rtap.rthdr.it_len = cpu_to_le16(rtap_len);
+	rtap_vendor->rtap.rthdr.it_present = cpu_to_le32(
+			(1 << IEEE80211_RADIOTAP_FLAGS) |
+			(1 << IEEE80211_RADIOTAP_CHANNEL) |
+			(1 << IEEE80211_RADIOTAP_MCS));
+	if (d->dma.status & RX_DMA_STATUS_ERROR)
+		rtap_vendor->rtap.flags |= IEEE80211_RADIOTAP_F_BADFCS;
+
+	rtap_vendor->rtap.chnl_freq = cpu_to_le16(ch ? ch->center_freq : 58320);
+	rtap_vendor->rtap.chnl_flags = cpu_to_le16(0);
+
+	rtap_vendor->rtap.mcs_present = IEEE80211_RADIOTAP_MCS_HAVE_MCS;
+	rtap_vendor->rtap.mcs_flags = 0;
+	rtap_vendor->rtap.mcs_index = wil_rxdesc_mcs(d);
+
+	if (rtap_include_phy_info) {
+		rtap_vendor->rtap.rthdr.it_present |= cpu_to_le32(1 <<
+				IEEE80211_RADIOTAP_VENDOR_NAMESPACE);
+		/* OUI for Wilocity 04:ce:14 */
+		rtap_vendor->vendor_oui[0] = 0x04;
+		rtap_vendor->vendor_oui[1] = 0xce;
+		rtap_vendor->vendor_oui[2] = 0x14;
+		rtap_vendor->vendor_ns = 1;
+		/* Rx descriptor + PHY data  */
+		rtap_vendor->vendor_skip = cpu_to_le16(sizeof(*d) +
+						       phy_length);
+		memcpy(rtap_vendor->vendor_data, (void *)d, sizeof(*d));
+		memcpy(rtap_vendor->vendor_data + sizeof(*d), phy_data,
+		       phy_length);
+	}
+}
+
+/*
+ * Fast swap in place between 2 registers
+ */
+static void wil_swap_u16(u16 *a, u16 *b)
+{
+	*a ^= *b;
+	*b ^= *a;
+	*a ^= *b;
+}
+
+static void wil_swap_ethaddr(void *data)
+{
+	struct ethhdr *eth = data;
+	u16 *s = (u16 *)eth->h_source;
+	u16 *d = (u16 *)eth->h_dest;
+
+	wil_swap_u16(s++, d++);
+	wil_swap_u16(s++, d++);
+	wil_swap_u16(s, d);
+}
+
+/**
+ * reap 1 frame from @swhead
+ *
+ * Safe to call from IRQ
+ */
+static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
+					 struct vring *vring)
+{
+	struct device *dev = wil_to_dev(wil);
+	struct net_device *ndev = wil_to_ndev(wil);
+	volatile struct vring_rx_desc *d;
+	struct sk_buff *skb;
+	dma_addr_t pa;
+	unsigned int sz = RX_BUF_LEN;
+	u8 ftype;
+	u8 ds_bits;
+
+	if (wil_vring_is_empty(vring))
+		return NULL;
+
+	d = &(vring->va[vring->swhead].rx);
+	if (!(d->dma.status & RX_DMA_STATUS_DU)) {
+		/* it is not error, we just reached end of Rx done area */
+		return NULL;
+	}
+
+	pa = d->dma.addr_low | ((u64)d->dma.addr_high << 32);
+	skb = vring->ctx[vring->swhead];
+	dma_unmap_single(dev, pa, sz, DMA_FROM_DEVICE);
+	skb_trim(skb, d->dma.length);
+
+	wil->stats.last_mcs_rx = wil_rxdesc_mcs(d);
+
+	/* use radiotap header only if required */
+	if (ndev->type == ARPHRD_IEEE80211_RADIOTAP)
+		wil_rx_add_radiotap_header(wil, skb, d);
+
+	wil_dbg_TXRX(wil, "Rx[%3d] : %d bytes\n", vring->swhead, d->dma.length);
+	wil_hex_dump_TXRX("Rx ", DUMP_PREFIX_NONE, 32, 4,
+			  (const void *)d, sizeof(*d), false);
+
+	wil_vring_advance_head(vring, 1);
+
+	/* no extra checks if in sniffer mode */
+	if (ndev->type != ARPHRD_ETHER)
+		return skb;
+	/*
+	 * Non-data frames may be delivered through Rx DMA channel (ex: BAR)
+	 * Driver should recognize it by frame type, that is found
+	 * in Rx descriptor. If type is not data, it is 802.11 frame as is
+	 */
+	ftype = wil_rxdesc_ftype(d) << 2;
+	if (ftype != IEEE80211_FTYPE_DATA) {
+		wil_dbg_TXRX(wil, "Non-data frame ftype 0x%08x\n", ftype);
+		/* TODO: process it */
+		kfree_skb(skb);
+		return NULL;
+	}
+
+	if (skb->len < ETH_HLEN) {
+		wil_err(wil, "Short frame, len = %d\n", skb->len);
+		/* TODO: process it (i.e. BAR) */
+		kfree_skb(skb);
+		return NULL;
+	}
+
+	ds_bits = wil_rxdesc_ds_bits(d);
+	if (ds_bits == 1) {
+		/*
+		 * HW bug - in ToDS mode, i.e. Rx on AP side,
+		 * addresses get swapped
+		 */
+		wil_swap_ethaddr(skb->data);
+	}
+
+	return skb;
+}
+
+/**
+ * allocate and fill up to @count buffers in rx ring
+ * buffers posted at @swtail
+ */
+static int wil_rx_refill(struct wil6210_priv *wil, int count)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct vring *v = &wil->vring_rx;
+	u32 next_tail;
+	int rc = 0;
+	int headroom = ndev->type == ARPHRD_IEEE80211_RADIOTAP ?
+			WIL6210_RTAP_SIZE : 0;
+
+	for (; next_tail = wil_vring_next_tail(v),
+			(next_tail != v->swhead) && (count-- > 0);
+			v->swtail = next_tail) {
+		rc = wil_vring_alloc_skb(wil, v, v->swtail, headroom);
+		if (rc) {
+			wil_err(wil, "Error %d in wil_rx_refill[%d]\n",
+				rc, v->swtail);
+			break;
+		}
+	}
+	iowrite32(v->swtail, wil->csr + HOSTADDR(v->hwtail));
+
+	return rc;
+}
+
+/*
+ * Pass Rx packet to the netif. Update statistics.
+ */
+static void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
+{
+	int rc;
+	unsigned int len = skb->len;
+
+	if (in_interrupt())
+		rc = netif_rx(skb);
+	else
+		rc = netif_rx_ni(skb);
+
+	if (likely(rc == NET_RX_SUCCESS)) {
+		ndev->stats.rx_packets++;
+		ndev->stats.rx_bytes += len;
+
+	} else {
+		ndev->stats.rx_dropped++;
+	}
+}
+
+/**
+ * Proceed all completed skb's from Rx VRING
+ *
+ * Safe to call from IRQ
+ */
+void wil_rx_handle(struct wil6210_priv *wil)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct vring *v = &wil->vring_rx;
+	struct sk_buff *skb;
+
+	if (!v->va) {
+		wil_err(wil, "Rx IRQ while Rx not yet initialized\n");
+		return;
+	}
+	wil_dbg_TXRX(wil, "%s()\n", __func__);
+	while (NULL != (skb = wil_vring_reap_rx(wil, v))) {
+		wil_hex_dump_TXRX("Rx ", DUMP_PREFIX_OFFSET, 16, 1,
+				  skb->data, skb_headlen(skb), false);
+
+		skb_orphan(skb);
+
+		if (wil->wdev->iftype == NL80211_IFTYPE_MONITOR) {
+			skb->dev = ndev;
+			skb_reset_mac_header(skb);
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+			skb->pkt_type = PACKET_OTHERHOST;
+			skb->protocol = htons(ETH_P_802_2);
+
+		} else {
+			skb->protocol = eth_type_trans(skb, ndev);
+		}
+
+		wil_netif_rx_any(skb, ndev);
+	}
+	wil_rx_refill(wil, v->size);
+}
+
+int wil_rx_init(struct wil6210_priv *wil)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct wireless_dev *wdev = wil->wdev;
+	struct vring *vring = &wil->vring_rx;
+	int rc;
+	struct wmi_cfg_rx_chain_cmd cmd = {
+		.action = WMI_RX_CHAIN_ADD,
+		.rx_sw_ring = {
+			.max_mpdu_size = cpu_to_le16(RX_BUF_LEN),
+		},
+		.mid = 0, /* TODO - what is it? */
+		.decap_trans_type = WMI_DECAP_TYPE_802_3,
+	};
+	struct {
+		struct wil6210_mbox_hdr_wmi wmi;
+		struct wmi_cfg_rx_chain_done_event evt;
+	} __packed evt;
+
+	vring->size = WIL6210_RX_RING_SIZE;
+	rc = wil_vring_alloc(wil, vring);
+	if (rc)
+		return rc;
+
+	cmd.rx_sw_ring.ring_mem_base = cpu_to_le64(vring->pa);
+	cmd.rx_sw_ring.ring_size = cpu_to_le16(vring->size);
+	if (wdev->iftype == NL80211_IFTYPE_MONITOR) {
+		struct ieee80211_channel *ch = wdev->preset_chandef.chan;
+
+		cmd.sniffer_cfg.mode = cpu_to_le32(WMI_SNIFFER_ON);
+		if (ch)
+			cmd.sniffer_cfg.channel = ch->hw_value - 1;
+		cmd.sniffer_cfg.phy_info_mode =
+			cpu_to_le32(ndev->type == ARPHRD_IEEE80211_RADIOTAP);
+		cmd.sniffer_cfg.phy_support =
+			cpu_to_le32((wil->monitor_flags & MONITOR_FLAG_CONTROL)
+				    ? WMI_SNIFFER_CP : WMI_SNIFFER_DP);
+	}
+	/* typical time for secure PCP is 840ms */
+	rc = wmi_call(wil, WMI_CFG_RX_CHAIN_CMDID, &cmd, sizeof(cmd),
+		      WMI_CFG_RX_CHAIN_DONE_EVENTID, &evt, sizeof(evt), 2000);
+	if (rc)
+		goto err_free;
+
+	vring->hwtail = le32_to_cpu(evt.evt.rx_ring_tail_ptr);
+
+	wil_dbg(wil, "Rx init: status %d tail 0x%08x\n",
+		le32_to_cpu(evt.evt.status), vring->hwtail);
+
+	rc = wil_rx_refill(wil, vring->size);
+	if (rc)
+		goto err_free;
+
+	return 0;
+ err_free:
+	wil_vring_free(wil, vring, 0);
+
+	return rc;
+}
+
+void wil_rx_fini(struct wil6210_priv *wil)
+{
+	struct vring *vring = &wil->vring_rx;
+
+	if (vring->va) {
+		int rc;
+		struct wmi_cfg_rx_chain_cmd cmd = {
+			.action = cpu_to_le32(WMI_RX_CHAIN_DEL),
+			.rx_sw_ring = {
+				.max_mpdu_size = cpu_to_le16(RX_BUF_LEN),
+			},
+		};
+		struct {
+			struct wil6210_mbox_hdr_wmi wmi;
+			struct wmi_cfg_rx_chain_done_event cfg;
+		} __packed wmi_rx_cfg_reply;
+
+		rc = wmi_call(wil, WMI_CFG_RX_CHAIN_CMDID, &cmd, sizeof(cmd),
+			      WMI_CFG_RX_CHAIN_DONE_EVENTID,
+			      &wmi_rx_cfg_reply, sizeof(wmi_rx_cfg_reply),
+			      100);
+		wil_vring_free(wil, vring, 0);
+	}
+}
+
+int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
+		      int cid, int tid)
+{
+	int rc;
+	struct wmi_vring_cfg_cmd cmd = {
+		.action = cpu_to_le32(WMI_VRING_CMD_ADD),
+		.vring_cfg = {
+			.tx_sw_ring = {
+				.max_mpdu_size = cpu_to_le16(TX_BUF_LEN),
+			},
+			.ringid = id,
+			.cidxtid = (cid & 0xf) | ((tid & 0xf) << 4),
+			.encap_trans_type = WMI_VRING_ENC_TYPE_802_3,
+			.mac_ctrl = 0,
+			.to_resolution = 0,
+			.agg_max_wsize = 16,
+			.schd_params = {
+				.priority = cpu_to_le16(0),
+				.timeslot_us = cpu_to_le16(0xfff),
+			},
+		},
+	};
+	struct {
+		struct wil6210_mbox_hdr_wmi wmi;
+		struct wmi_vring_cfg_done_event cmd;
+	} __packed reply;
+	struct vring *vring = &wil->vring_tx[id];
+
+	if (vring->va) {
+		wil_err(wil, "Tx ring [%d] already allocated\n", id);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	vring->size = size;
+	rc = wil_vring_alloc(wil, vring);
+	if (rc)
+		goto out;
+
+	cmd.vring_cfg.tx_sw_ring.ring_mem_base = cpu_to_le64(vring->pa);
+	cmd.vring_cfg.tx_sw_ring.ring_size = cpu_to_le16(vring->size);
+
+	rc = wmi_call(wil, WMI_VRING_CFG_CMDID, &cmd, sizeof(cmd),
+		      WMI_VRING_CFG_DONE_EVENTID, &reply, sizeof(reply), 100);
+	if (rc)
+		goto out_free;
+
+	if (reply.cmd.status != WMI_VRING_CFG_SUCCESS) {
+		wil_err(wil, "Tx config failed, status 0x%02x\n",
+			reply.cmd.status);
+		goto out_free;
+	}
+	vring->hwtail = le32_to_cpu(reply.cmd.tx_vring_tail_ptr);
+
+	return 0;
+ out_free:
+	wil_vring_free(wil, vring, 1);
+ out:
+
+	return rc;
+}
+
+void wil_vring_fini_tx(struct wil6210_priv *wil, int id)
+{
+	struct vring *vring = &wil->vring_tx[id];
+
+	if (!vring->va)
+		return;
+
+	wil_vring_free(wil, vring, 1);
+}
+
+static struct vring *wil_find_tx_vring(struct wil6210_priv *wil,
+				       struct sk_buff *skb)
+{
+	struct vring *v = &wil->vring_tx[0];
+
+	if (v->va)
+		return v;
+
+	return NULL;
+}
+
+static int wil_tx_desc_map(volatile struct vring_tx_desc *d,
+			   dma_addr_t pa, u32 len)
+{
+	d->dma.addr_low = lower_32_bits(pa);
+	d->dma.addr_high = (u16)upper_32_bits(pa);
+	d->dma.ip_length = 0;
+	/* 0..6: mac_length; 7:ip_version 0-IP6 1-IP4*/
+	d->dma.b11 = 0/*14 | BIT(7)*/;
+	d->dma.error = 0;
+	d->dma.status = 0; /* BIT(0) should be 0 for HW_OWNED */
+	d->dma.length = len;
+	d->dma.d0 = 0;
+	d->mac.d[0] = 0;
+	d->mac.d[1] = 0;
+	d->mac.d[2] = 0;
+	d->mac.ucode_cmd = 0;
+	/* use dst index 0 */
+	d->mac.d[1] |= BIT(MAC_CFG_DESC_TX_1_DST_INDEX_EN_POS) |
+		       (0 << MAC_CFG_DESC_TX_1_DST_INDEX_POS);
+	/* translation type:  0 - bypass; 1 - 802.3; 2 - native wifi */
+	d->mac.d[2] = BIT(MAC_CFG_DESC_TX_2_SNAP_HDR_INSERTION_EN_POS) |
+		      (1 << MAC_CFG_DESC_TX_2_L2_TRANSLATION_TYPE_POS);
+
+	return 0;
+}
+
+static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
+			struct sk_buff *skb)
+{
+	struct device *dev = wil_to_dev(wil);
+	volatile struct vring_tx_desc *d;
+	u32 swhead = vring->swhead;
+	int avail = wil_vring_avail_tx(vring);
+	int nr_frags = skb_shinfo(skb)->nr_frags;
+	uint f;
+	int vring_index = vring - wil->vring_tx;
+	uint i = swhead;
+	dma_addr_t pa;
+
+	wil_dbg_TXRX(wil, "%s()\n", __func__);
+
+	if (avail < vring->size/8)
+		netif_tx_stop_all_queues(wil_to_ndev(wil));
+	if (avail < 1 + nr_frags) {
+		wil_err(wil, "Tx ring full. No space for %d fragments\n",
+			1 + nr_frags);
+		return -ENOMEM;
+	}
+	d = &(vring->va[i].tx);
+
+	/* FIXME FW can accept only unicast frames for the peer */
+	memcpy(skb->data, wil->dst_addr[vring_index], ETH_ALEN);
+
+	pa = dma_map_single(dev, skb->data,
+			skb_headlen(skb), DMA_TO_DEVICE);
+
+	wil_dbg_TXRX(wil, "Tx skb %d bytes %p -> %#08llx\n", skb_headlen(skb),
+		     skb->data, (unsigned long long)pa);
+	wil_hex_dump_TXRX("Tx ", DUMP_PREFIX_OFFSET, 16, 1,
+			  skb->data, skb_headlen(skb), false);
+
+	if (unlikely(dma_mapping_error(dev, pa)))
+		return -EINVAL;
+	/* 1-st segment */
+	wil_tx_desc_map(d, pa, skb_headlen(skb));
+	d->mac.d[2] |= ((nr_frags + 1) <<
+		       MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_POS);
+	/* middle segments */
+	for (f = 0; f < nr_frags; f++) {
+		const struct skb_frag_struct *frag =
+				&skb_shinfo(skb)->frags[f];
+		int len = skb_frag_size(frag);
+		i = (swhead + f + 1) % vring->size;
+		d = &(vring->va[i].tx);
+		pa = skb_frag_dma_map(dev, frag, 0, skb_frag_size(frag),
+				DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, pa)))
+			goto dma_error;
+		wil_tx_desc_map(d, pa, len);
+		vring->ctx[i] = NULL;
+	}
+	/* for the last seg only */
+	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_EOP_POS);
+	d->dma.d0 |= BIT(9); /* BUG: undocumented bit */
+	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_DMA_IT_POS);
+	d->dma.d0 |= (vring_index << DMA_CFG_DESC_TX_0_QID_POS);
+
+	wil_hex_dump_TXRX("Tx ", DUMP_PREFIX_NONE, 32, 4,
+			  (const void *)d, sizeof(*d), false);
+
+	/* advance swhead */
+	wil_vring_advance_head(vring, nr_frags + 1);
+	wil_dbg_TXRX(wil, "Tx swhead %d -> %d\n", swhead, vring->swhead);
+	iowrite32(vring->swhead, wil->csr + HOSTADDR(vring->hwtail));
+	/* hold reference to skb
+	 * to prevent skb release before accounting
+	 * in case of immediate "tx done"
+	 */
+	vring->ctx[i] = skb_get(skb);
+
+	return 0;
+ dma_error:
+	/* unmap what we have mapped */
+	/* Note: increment @f to operate with positive index */
+	for (f++; f > 0; f--) {
+		i = (swhead + f) % vring->size;
+		d = &(vring->va[i].tx);
+		d->dma.status = TX_DMA_STATUS_DU;
+		pa = d->dma.addr_low | ((u64)d->dma.addr_high << 32);
+		if (vring->ctx[i])
+			dma_unmap_single(dev, pa, d->dma.length, DMA_TO_DEVICE);
+		else
+			dma_unmap_page(dev, pa, d->dma.length, DMA_TO_DEVICE);
+	}
+
+	return -EINVAL;
+}
+
+
+netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct wil6210_priv *wil = ndev_to_wil(ndev);
+	struct vring *vring;
+	int rc;
+
+	wil_dbg_TXRX(wil, "%s()\n", __func__);
+	if (!test_bit(wil_status_fwready, &wil->status)) {
+		wil_err(wil, "FW not ready\n");
+		goto drop;
+	}
+	if (!test_bit(wil_status_fwconnected, &wil->status)) {
+		wil_err(wil, "FW not connected\n");
+		goto drop;
+	}
+	if (wil->wdev->iftype == NL80211_IFTYPE_MONITOR) {
+		wil_err(wil, "Xmit in monitor mode not supported\n");
+		goto drop;
+	}
+	if (skb->protocol == cpu_to_be16(ETH_P_PAE)) {
+		rc = wmi_tx_eapol(wil, skb);
+	} else {
+		/* find vring */
+		vring = wil_find_tx_vring(wil, skb);
+		if (!vring) {
+			wil_err(wil, "No Tx VRING available\n");
+			goto drop;
+		}
+		/* set up vring entry */
+		rc = wil_tx_vring(wil, vring, skb);
+	}
+	switch (rc) {
+	case 0:
+		ndev->stats.tx_packets++;
+		ndev->stats.tx_bytes += skb->len;
+		dev_kfree_skb_any(skb);
+		return NETDEV_TX_OK;
+	case -ENOMEM:
+		return NETDEV_TX_BUSY;
+	default:
+		; /* goto drop; */
+		break;
+	}
+ drop:
+	netif_tx_stop_all_queues(ndev);
+	ndev->stats.tx_dropped++;
+	dev_kfree_skb_any(skb);
+
+	return NET_XMIT_DROP;
+}
+
+/**
+ * Clean up transmitted skb's from the Tx VRING
+ *
+ * Safe to call from IRQ
+ */
+void wil_tx_complete(struct wil6210_priv *wil, int ringid)
+{
+	struct device *dev = wil_to_dev(wil);
+	struct vring *vring = &wil->vring_tx[ringid];
+
+	if (!vring->va) {
+		wil_err(wil, "Tx irq[%d]: vring not initialized\n", ringid);
+		return;
+	}
+
+	wil_dbg_TXRX(wil, "%s(%d)\n", __func__, ringid);
+
+	while (!wil_vring_is_empty(vring)) {
+		volatile struct vring_tx_desc *d = &vring->va[vring->swtail].tx;
+		dma_addr_t pa;
+		struct sk_buff *skb;
+		if (!(d->dma.status & TX_DMA_STATUS_DU))
+			break;
+
+		wil_dbg_TXRX(wil,
+			     "Tx[%3d] : %d bytes, status 0x%02x err 0x%02x\n",
+			     vring->swtail, d->dma.length, d->dma.status,
+			     d->dma.error);
+		wil_hex_dump_TXRX("TxC ", DUMP_PREFIX_NONE, 32, 4,
+				  (const void *)d, sizeof(*d), false);
+
+		pa = d->dma.addr_low | ((u64)d->dma.addr_high << 32);
+		skb = vring->ctx[vring->swtail];
+		if (skb) {
+			dma_unmap_single(dev, pa, d->dma.length, DMA_TO_DEVICE);
+			dev_kfree_skb_any(skb);
+			vring->ctx[vring->swtail] = NULL;
+		} else {
+			dma_unmap_page(dev, pa, d->dma.length, DMA_TO_DEVICE);
+		}
+		d->dma.addr_low = 0;
+		d->dma.addr_high = 0;
+		d->dma.length = 0;
+		d->dma.status = TX_DMA_STATUS_DU;
+		vring->swtail = wil_vring_next_tail(vring);
+	}
+	if (wil_vring_avail_tx(vring) > vring->size/4)
+		netif_tx_wake_all_queues(wil_to_ndev(wil));
+}
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
new file mode 100644
index 0000000..45a61f5
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -0,0 +1,362 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef WIL6210_TXRX_H
+#define WIL6210_TXRX_H
+
+#define BUF_SW_OWNED    (1)
+#define BUF_HW_OWNED    (0)
+
+/* size of max. Rx packet */
+#define RX_BUF_LEN      (2048)
+#define TX_BUF_LEN      (2048)
+/* how many bytes to reserve for rtap header? */
+#define WIL6210_RTAP_SIZE (128)
+
+/* Tx/Rx path */
+/*
+ * Tx descriptor - MAC part
+ * [dword 0]
+ * bit  0.. 9 : lifetime_expiry_value:10
+ * bit     10 : interrup_en:1
+ * bit     11 : status_en:1
+ * bit 12..13 : txss_override:2
+ * bit     14 : timestamp_insertion:1
+ * bit     15 : duration_preserve:1
+ * bit 16..21 : reserved0:6
+ * bit 22..26 : mcs_index:5
+ * bit     27 : mcs_en:1
+ * bit 28..29 : reserved1:2
+ * bit     30 : reserved2:1
+ * bit     31 : sn_preserved:1
+ * [dword 1]
+ * bit  0.. 3 : pkt_mode:4
+ * bit      4 : pkt_mode_en:1
+ * bit  5.. 7 : reserved0:3
+ * bit  8..13 : reserved1:6
+ * bit     14 : reserved2:1
+ * bit     15 : ack_policy_en:1
+ * bit 16..19 : dst_index:4
+ * bit     20 : dst_index_en:1
+ * bit 21..22 : ack_policy:2
+ * bit     23 : lifetime_en:1
+ * bit 24..30 : max_retry:7
+ * bit     31 : max_retry_en:1
+ * [dword 2]
+ * bit  0.. 7 : num_of_descriptors:8
+ * bit  8..17 : reserved:10
+ * bit 18..19 : l2_translation_type:2
+ * bit     20 : snap_hdr_insertion_en:1
+ * bit     21 : vlan_removal_en:1
+ * bit 22..31 : reserved0:10
+ * [dword 3]
+ * bit  0.. 31: ucode_cmd:32
+ */
+struct vring_tx_mac {
+	u32 d[3];
+	u32 ucode_cmd;
+} __packed;
+
+/* TX MAC Dword 0 */
+#define MAC_CFG_DESC_TX_0_LIFETIME_EXPIRY_VALUE_POS 0
+#define MAC_CFG_DESC_TX_0_LIFETIME_EXPIRY_VALUE_LEN 10
+#define MAC_CFG_DESC_TX_0_LIFETIME_EXPIRY_VALUE_MSK 0x3FF
+
+#define MAC_CFG_DESC_TX_0_INTERRUP_EN_POS 10
+#define MAC_CFG_DESC_TX_0_INTERRUP_EN_LEN 1
+#define MAC_CFG_DESC_TX_0_INTERRUP_EN_MSK 0x400
+
+#define MAC_CFG_DESC_TX_0_STATUS_EN_POS 11
+#define MAC_CFG_DESC_TX_0_STATUS_EN_LEN 1
+#define MAC_CFG_DESC_TX_0_STATUS_EN_MSK 0x800
+
+#define MAC_CFG_DESC_TX_0_TXSS_OVERRIDE_POS 12
+#define MAC_CFG_DESC_TX_0_TXSS_OVERRIDE_LEN 2
+#define MAC_CFG_DESC_TX_0_TXSS_OVERRIDE_MSK 0x3000
+
+#define MAC_CFG_DESC_TX_0_TIMESTAMP_INSERTION_POS 14
+#define MAC_CFG_DESC_TX_0_TIMESTAMP_INSERTION_LEN 1
+#define MAC_CFG_DESC_TX_0_TIMESTAMP_INSERTION_MSK 0x4000
+
+#define MAC_CFG_DESC_TX_0_DURATION_PRESERVE_POS 15
+#define MAC_CFG_DESC_TX_0_DURATION_PRESERVE_LEN 1
+#define MAC_CFG_DESC_TX_0_DURATION_PRESERVE_MSK 0x8000
+
+#define MAC_CFG_DESC_TX_0_MCS_INDEX_POS 22
+#define MAC_CFG_DESC_TX_0_MCS_INDEX_LEN 5
+#define MAC_CFG_DESC_TX_0_MCS_INDEX_MSK 0x7C00000
+
+#define MAC_CFG_DESC_TX_0_MCS_EN_POS 27
+#define MAC_CFG_DESC_TX_0_MCS_EN_LEN 1
+#define MAC_CFG_DESC_TX_0_MCS_EN_MSK 0x8000000
+
+#define MAC_CFG_DESC_TX_0_SN_PRESERVED_POS 31
+#define MAC_CFG_DESC_TX_0_SN_PRESERVED_LEN 1
+#define MAC_CFG_DESC_TX_0_SN_PRESERVED_MSK 0x80000000
+
+/* TX MAC Dword 1 */
+#define MAC_CFG_DESC_TX_1_PKT_MODE_POS 0
+#define MAC_CFG_DESC_TX_1_PKT_MODE_LEN 4
+#define MAC_CFG_DESC_TX_1_PKT_MODE_MSK 0xF
+
+#define MAC_CFG_DESC_TX_1_PKT_MODE_EN_POS 4
+#define MAC_CFG_DESC_TX_1_PKT_MODE_EN_LEN 1
+#define MAC_CFG_DESC_TX_1_PKT_MODE_EN_MSK 0x10
+
+#define MAC_CFG_DESC_TX_1_ACK_POLICY_EN_POS 15
+#define MAC_CFG_DESC_TX_1_ACK_POLICY_EN_LEN 1
+#define MAC_CFG_DESC_TX_1_ACK_POLICY_EN_MSK 0x8000
+
+#define MAC_CFG_DESC_TX_1_DST_INDEX_POS 16
+#define MAC_CFG_DESC_TX_1_DST_INDEX_LEN 4
+#define MAC_CFG_DESC_TX_1_DST_INDEX_MSK 0xF0000
+
+#define MAC_CFG_DESC_TX_1_DST_INDEX_EN_POS 20
+#define MAC_CFG_DESC_TX_1_DST_INDEX_EN_LEN 1
+#define MAC_CFG_DESC_TX_1_DST_INDEX_EN_MSK 0x100000
+
+#define MAC_CFG_DESC_TX_1_ACK_POLICY_POS 21
+#define MAC_CFG_DESC_TX_1_ACK_POLICY_LEN 2
+#define MAC_CFG_DESC_TX_1_ACK_POLICY_MSK 0x600000
+
+#define MAC_CFG_DESC_TX_1_LIFETIME_EN_POS 23
+#define MAC_CFG_DESC_TX_1_LIFETIME_EN_LEN 1
+#define MAC_CFG_DESC_TX_1_LIFETIME_EN_MSK 0x800000
+
+#define MAC_CFG_DESC_TX_1_MAX_RETRY_POS 24
+#define MAC_CFG_DESC_TX_1_MAX_RETRY_LEN 7
+#define MAC_CFG_DESC_TX_1_MAX_RETRY_MSK 0x7F000000
+
+#define MAC_CFG_DESC_TX_1_MAX_RETRY_EN_POS 31
+#define MAC_CFG_DESC_TX_1_MAX_RETRY_EN_LEN 1
+#define MAC_CFG_DESC_TX_1_MAX_RETRY_EN_MSK 0x80000000
+
+/* TX MAC Dword 2 */
+#define MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_POS 0
+#define MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_LEN 8
+#define MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_MSK 0xFF
+
+#define MAC_CFG_DESC_TX_2_RESERVED_POS 8
+#define MAC_CFG_DESC_TX_2_RESERVED_LEN 10
+#define MAC_CFG_DESC_TX_2_RESERVED_MSK 0x3FF00
+
+#define MAC_CFG_DESC_TX_2_L2_TRANSLATION_TYPE_POS 18
+#define MAC_CFG_DESC_TX_2_L2_TRANSLATION_TYPE_LEN 2
+#define MAC_CFG_DESC_TX_2_L2_TRANSLATION_TYPE_MSK 0xC0000
+
+#define MAC_CFG_DESC_TX_2_SNAP_HDR_INSERTION_EN_POS 20
+#define MAC_CFG_DESC_TX_2_SNAP_HDR_INSERTION_EN_LEN 1
+#define MAC_CFG_DESC_TX_2_SNAP_HDR_INSERTION_EN_MSK 0x100000
+
+#define MAC_CFG_DESC_TX_2_VLAN_REMOVAL_EN_POS 21
+#define MAC_CFG_DESC_TX_2_VLAN_REMOVAL_EN_LEN 1
+#define MAC_CFG_DESC_TX_2_VLAN_REMOVAL_EN_MSK 0x200000
+
+/* TX MAC Dword 3 */
+#define MAC_CFG_DESC_TX_3_UCODE_CMD_POS 0
+#define MAC_CFG_DESC_TX_3_UCODE_CMD_LEN 32
+#define MAC_CFG_DESC_TX_3_UCODE_CMD_MSK 0xFFFFFFFF
+
+/* TX DMA Dword 0 */
+#define DMA_CFG_DESC_TX_0_L4_LENGTH_POS 0
+#define DMA_CFG_DESC_TX_0_L4_LENGTH_LEN 8
+#define DMA_CFG_DESC_TX_0_L4_LENGTH_MSK 0xFF
+
+#define DMA_CFG_DESC_TX_0_CMD_EOP_POS 8
+#define DMA_CFG_DESC_TX_0_CMD_EOP_LEN 1
+#define DMA_CFG_DESC_TX_0_CMD_EOP_MSK 0x100
+
+#define DMA_CFG_DESC_TX_0_CMD_DMA_IT_POS 10
+#define DMA_CFG_DESC_TX_0_CMD_DMA_IT_LEN 1
+#define DMA_CFG_DESC_TX_0_CMD_DMA_IT_MSK 0x400
+
+#define DMA_CFG_DESC_TX_0_SEGMENT_BUF_DETAILS_POS 11
+#define DMA_CFG_DESC_TX_0_SEGMENT_BUF_DETAILS_LEN 2
+#define DMA_CFG_DESC_TX_0_SEGMENT_BUF_DETAILS_MSK 0x1800
+
+#define DMA_CFG_DESC_TX_0_TCP_SEG_EN_POS 13
+#define DMA_CFG_DESC_TX_0_TCP_SEG_EN_LEN 1
+#define DMA_CFG_DESC_TX_0_TCP_SEG_EN_MSK 0x2000
+
+#define DMA_CFG_DESC_TX_0_IPV4_CHECKSUM_EN_POS 14
+#define DMA_CFG_DESC_TX_0_IPV4_CHECKSUM_EN_LEN 1
+#define DMA_CFG_DESC_TX_0_IPV4_CHECKSUM_EN_MSK 0x4000
+
+#define DMA_CFG_DESC_TX_0_TCP_UDP_CHECKSUM_EN_POS 15
+#define DMA_CFG_DESC_TX_0_TCP_UDP_CHECKSUM_EN_LEN 1
+#define DMA_CFG_DESC_TX_0_TCP_UDP_CHECKSUM_EN_MSK 0x8000
+
+#define DMA_CFG_DESC_TX_0_QID_POS 16
+#define DMA_CFG_DESC_TX_0_QID_LEN 5
+#define DMA_CFG_DESC_TX_0_QID_MSK 0x1F0000
+
+#define DMA_CFG_DESC_TX_0_PSEUDO_HEADER_CALC_EN_POS 21
+#define DMA_CFG_DESC_TX_0_PSEUDO_HEADER_CALC_EN_LEN 1
+#define DMA_CFG_DESC_TX_0_PSEUDO_HEADER_CALC_EN_MSK 0x200000
+
+#define DMA_CFG_DESC_TX_0_L4_TYPE_POS 30
+#define DMA_CFG_DESC_TX_0_L4_TYPE_LEN 2
+#define DMA_CFG_DESC_TX_0_L4_TYPE_MSK 0xC0000000
+
+
+#define TX_DMA_STATUS_DU         BIT(0)
+
+struct vring_tx_dma {
+	u32 d0;
+	u32 addr_low;
+	u16 addr_high;
+	u8  ip_length;
+	u8  b11;       /* 0..6: mac_length; 7:ip_version */
+	u8  error;     /* 0..2: err; 3..7: reserved; */
+	u8  status;    /* 0: used; 1..7; reserved */
+	u16 length;
+} __packed;
+
+/*
+ * Rx descriptor - MAC part
+ * [dword 0]
+ * bit  0.. 3 : tid:4 The QoS (b3-0) TID Field
+ * bit  4.. 6 : connection_id:3 :The Source index that  was found during
+ *  Parsing the TA.  This field is used to  define the source of the packet
+ * bit      7 : reserved:1
+ * bit  8.. 9 : mac_id:2 : The MAC virtual  Ring number (always zero)
+ * bit 10..11 : frame_type:2 : The FC Control  (b3-2) -  MPDU Type
+ *              (management, data, control  and extension)
+ * bit 12..15 : frame_subtype:4 : The FC Control  (b7-4) -  Frame Subtype
+ * bit 16..27 : seq_number:12 The received Sequence number field
+ * bit 28..31 : extended:4 extended subtype
+ * [dword 1]
+ * bit  0.. 3 : reserved
+ * bit  4.. 5 : key_id:2
+ * bit      6 : decrypt_bypass:1
+ * bit      7 : security:1
+ * bit  8.. 9 : ds_bits:2
+ * bit     10 : a_msdu_present:1  from qos header
+ * bit     11 : a_msdu_type:1  from qos header
+ * bit     12 : a_mpdu:1  part of AMPDU aggregation
+ * bit     13 : broadcast:1
+ * bit     14 : mutlicast:1
+ * bit     15 : reserved:1
+ * bit 16..20 : rx_mac_qid:5   The Queue Identifier that the packet
+ *                             is received from
+ * bit 21..24 : mcs:4
+ * bit 25..28 : mic_icr:4
+ * bit 29..31 : reserved:3
+ * [dword 2]
+ * bit  0.. 2 : time_slot:3 The timeslot that the MPDU is received
+ * bit      3 : fc_protocol_ver:1 The FC Control  (b0) - Protocol  Version
+ * bit      4 : fc_order:1 The FC Control (b15) -Order
+ * bit  5.. 7 : qos_ack_policy:3  The QoS (b6-5) ack policy Field
+ * bit      8 : esop:1 The QoS (b4) ESOP field
+ * bit      9 : qos_rdg_more_ppdu:1 The QoS (b9) RDG  field
+ * bit 10..14 : qos_reserved:5 The QoS (b14-10) Reserved  field
+ * bit     15 : qos_ac_constraint:1
+ * bit 16..31 : pn_15_0:16 low 2 bytes of PN
+ * [dword 3]
+ * bit  0..31 : pn_47_16:32 high 4 bytes of PN
+ */
+struct vring_rx_mac {
+	u32 d0;
+	u32 d1;
+	u16 w4;
+	u16 pn_15_0;
+	u32 pn_47_16;
+} __packed;
+
+/*
+ * Rx descriptor - DMA part
+ * [dword 0]
+ * bit  0.. 7 : l4_length:8 layer 4 length
+ * bit  8.. 9 : reserved:2
+ * bit     10 : cmd_dma_it:1
+ * bit 11..15 : reserved:5
+ * bit 16..29 : phy_info_length:14
+ * bit 30..31 : l4_type:2 valid if the L4I bit is set in the status field
+ * [dword 1]
+ * bit  0..31 : addr_low:32 The payload buffer low address
+ * [dword 2]
+ * bit  0..15 : addr_high:16 The payload buffer high address
+ * bit 16..23 : ip_length:8
+ * bit 24..30 : mac_length:7
+ * bit     31 : ip_version:1
+ * [dword 3]
+ *  [byte 12] error
+ *  [byte 13] status
+ * bit      0 : du:1
+ * bit      1 : eop:1
+ * bit      2 : error:1
+ * bit      3 : mi:1
+ * bit      4 : l3_identified:1
+ * bit      5 : l4_identified:1
+ * bit      6 : phy_info_included:1
+ * bit      7 : reserved:1
+ *  [word 7] length
+ *
+ */
+
+#define RX_DMA_D0_CMD_DMA_IT     BIT(10)
+
+#define RX_DMA_STATUS_DU         BIT(0)
+#define RX_DMA_STATUS_ERROR      BIT(2)
+#define RX_DMA_STATUS_PHY_INFO   BIT(6)
+
+struct vring_rx_dma {
+	u32 d0;
+	u32 addr_low;
+	u16 addr_high;
+	u8  ip_length;
+	u8  b11;
+	u8  error;
+	u8  status;
+	u16 length;
+} __packed;
+
+struct vring_tx_desc {
+	struct vring_tx_mac mac;
+	struct vring_tx_dma dma;
+} __packed;
+
+struct vring_rx_desc {
+	struct vring_rx_mac mac;
+	struct vring_rx_dma dma;
+} __packed;
+
+union vring_desc {
+	struct vring_tx_desc tx;
+	struct vring_rx_desc rx;
+} __packed;
+
+static inline int wil_rxdesc_phy_length(volatile struct vring_rx_desc *d)
+{
+	return WIL_GET_BITS(d->dma.d0, 16, 29);
+}
+
+static inline int wil_rxdesc_mcs(volatile struct vring_rx_desc *d)
+{
+	return WIL_GET_BITS(d->mac.d1, 21, 24);
+}
+
+static inline int wil_rxdesc_ds_bits(volatile struct vring_rx_desc *d)
+{
+	return WIL_GET_BITS(d->mac.d1, 8, 9);
+}
+
+static inline int wil_rxdesc_ftype(volatile struct vring_rx_desc *d)
+{
+	return WIL_GET_BITS(d->mac.d0, 10, 11);
+}
+
+#endif /* WIL6210_TXRX_H */
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
new file mode 100644
index 0000000..ef5a17f
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -0,0 +1,361 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef __WIL6210_H__
+#define __WIL6210_H__
+
+#include <linux/netdevice.h>
+#include <linux/wireless.h>
+#include <net/cfg80211.h>
+
+#define WIL_NAME "wil6210"
+
+/**
+ * extract bits [@b0:@b1] (inclusive) from the value @x
+ * it should be @b0 <= @b1, or result is incorrect
+ */
+static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
+{
+	return (x >> b0) & ((1 << (b1 - b0 + 1)) - 1);
+}
+
+#define WIL6210_MEM_SIZE (2*1024*1024UL)
+
+#define WIL6210_TX_QUEUES (4)
+
+#define WIL6210_RX_RING_SIZE (128)
+#define WIL6210_TX_RING_SIZE (128)
+#define WIL6210_MAX_TX_RINGS (24)
+
+/* Hardware definitions begin */
+
+/*
+ * Mapping
+ * RGF File      | Host addr    |  FW addr
+ *               |              |
+ * user_rgf      | 0x000000     | 0x880000
+ *  dma_rgf      | 0x001000     | 0x881000
+ * pcie_rgf      | 0x002000     | 0x882000
+ *               |              |
+ */
+
+/* Where various structures placed in host address space */
+#define WIL6210_FW_HOST_OFF      (0x880000UL)
+
+#define HOSTADDR(fwaddr)        (fwaddr - WIL6210_FW_HOST_OFF)
+
+/*
+ * Interrupt control registers block
+ *
+ * each interrupt controlled by the same bit in all registers
+ */
+struct RGF_ICR {
+	u32 ICC; /* Cause Control, RW: 0 - W1C, 1 - COR */
+	u32 ICR; /* Cause, W1C/COR depending on ICC */
+	u32 ICM; /* Cause masked (ICR & ~IMV), W1C/COR depending on ICC */
+	u32 ICS; /* Cause Set, WO */
+	u32 IMV; /* Mask, RW+S/C */
+	u32 IMS; /* Mask Set, write 1 to set */
+	u32 IMC; /* Mask Clear, write 1 to clear */
+} __packed;
+
+/* registers - FW addresses */
+#define RGF_USER_USER_SCRATCH_PAD	(0x8802bc)
+#define RGF_USER_USER_ICR		(0x880b4c) /* struct RGF_ICR */
+	#define BIT_USER_USER_ICR_SW_INT_2	BIT(18)
+#define RGF_USER_CLKS_CTL_SW_RST_MASK_0	(0x880b14)
+#define RGF_USER_MAC_CPU_0		(0x8801fc)
+#define RGF_USER_USER_CPU_0		(0x8801e0)
+#define RGF_USER_CLKS_CTL_SW_RST_VEC_0	(0x880b04)
+#define RGF_USER_CLKS_CTL_SW_RST_VEC_1	(0x880b08)
+#define RGF_USER_CLKS_CTL_SW_RST_VEC_2	(0x880b0c)
+#define RGF_USER_CLKS_CTL_SW_RST_VEC_3	(0x880b10)
+
+#define RGF_DMA_PSEUDO_CAUSE		(0x881c68)
+#define RGF_DMA_PSEUDO_CAUSE_MASK_SW	(0x881c6c)
+#define RGF_DMA_PSEUDO_CAUSE_MASK_FW	(0x881c70)
+	#define BIT_DMA_PSEUDO_CAUSE_RX		BIT(0)
+	#define BIT_DMA_PSEUDO_CAUSE_TX		BIT(1)
+	#define BIT_DMA_PSEUDO_CAUSE_MISC	BIT(2)
+
+#define RGF_DMA_EP_TX_ICR		(0x881bb4) /* struct RGF_ICR */
+	#define BIT_DMA_EP_TX_ICR_TX_DONE	BIT(0)
+	#define BIT_DMA_EP_TX_ICR_TX_DONE_N(n)	BIT(n+1) /* n = [0..23] */
+#define RGF_DMA_EP_RX_ICR		(0x881bd0) /* struct RGF_ICR */
+	#define BIT_DMA_EP_RX_ICR_RX_DONE	BIT(0)
+#define RGF_DMA_EP_MISC_ICR		(0x881bec) /* struct RGF_ICR */
+	#define BIT_DMA_EP_MISC_ICR_RX_HTRSH	BIT(0)
+	#define BIT_DMA_EP_MISC_ICR_TX_NO_ACT	BIT(1)
+	#define BIT_DMA_EP_MISC_ICR_FW_INT0	BIT(28)
+	#define BIT_DMA_EP_MISC_ICR_FW_INT1	BIT(29)
+
+/* Interrupt moderation control */
+#define RGF_DMA_ITR_CNT_TRSH		(0x881c5c)
+#define RGF_DMA_ITR_CNT_DATA		(0x881c60)
+#define RGF_DMA_ITR_CNT_CRL		(0x881C64)
+	#define BIT_DMA_ITR_CNT_CRL_EN		BIT(0)
+	#define BIT_DMA_ITR_CNT_CRL_EXT_TICK	BIT(1)
+	#define BIT_DMA_ITR_CNT_CRL_FOREVER	BIT(2)
+	#define BIT_DMA_ITR_CNT_CRL_CLR		BIT(3)
+	#define BIT_DMA_ITR_CNT_CRL_REACH_TRSH	BIT(4)
+
+/* popular locations */
+#define HOST_MBOX   HOSTADDR(RGF_USER_USER_SCRATCH_PAD)
+#define HOST_SW_INT (HOSTADDR(RGF_USER_USER_ICR) + \
+	offsetof(struct RGF_ICR, ICS))
+#define SW_INT_MBOX BIT_USER_USER_ICR_SW_INT_2
+
+/* ISR register bits */
+#define ISR_MISC_FW_READY BIT_DMA_EP_MISC_ICR_FW_INT0
+#define ISR_MISC_MBOX_EVT BIT_DMA_EP_MISC_ICR_FW_INT1
+
+/* Hardware definitions end */
+
+struct wil6210_mbox_ring {
+	u32 base;
+	u16 entry_size; /* max. size of mbox entry, incl. all headers */
+	u16 size;
+	u32 tail;
+	u32 head;
+} __packed;
+
+struct wil6210_mbox_ring_desc {
+	__le32 sync;
+	__le32 addr;
+} __packed;
+
+/* at HOST_OFF_WIL6210_MBOX_CTL */
+struct wil6210_mbox_ctl {
+	struct wil6210_mbox_ring tx;
+	struct wil6210_mbox_ring rx;
+} __packed;
+
+struct wil6210_mbox_hdr {
+	__le16 seq;
+	__le16 len; /* payload, bytes after this header */
+	__le16 type;
+	u8 flags;
+	u8 reserved;
+} __packed;
+
+#define WIL_MBOX_HDR_TYPE_WMI (0)
+
+/* max. value for wil6210_mbox_hdr.len */
+#define MAX_MBOXITEM_SIZE   (240)
+
+struct wil6210_mbox_hdr_wmi {
+	u8 reserved0[2];
+	__le16 id;
+	__le16 info1; /* bits [0..3] - device_id, rest - unused */
+	u8 reserved1[2];
+} __packed;
+
+struct pending_wmi_event {
+	struct list_head list;
+	struct {
+		struct wil6210_mbox_hdr hdr;
+		struct wil6210_mbox_hdr_wmi wmi;
+		u8 data[0];
+	} __packed event;
+};
+
+union vring_desc;
+
+struct vring {
+	dma_addr_t pa;
+	volatile union vring_desc *va; /* vring_desc[size], WriteBack by DMA */
+	u16 size; /* number of vring_desc elements */
+	u32 swtail;
+	u32 swhead;
+	u32 hwtail; /* write here to inform hw */
+	void **ctx; /* void *ctx[size] - software context */
+};
+
+enum { /* for wil6210_priv.status */
+	wil_status_fwready = 0,
+	wil_status_fwconnected,
+	wil_status_dontscan,
+	wil_status_irqen, /* FIXME: interrupts enabled - for debug */
+};
+
+struct pci_dev;
+
+struct wil6210_stats {
+	u64 tsf;
+	u32 snr;
+	u16 last_mcs_rx;
+	u16 bf_mcs; /* last BF, used for Tx */
+	u16 my_rx_sector;
+	u16 my_tx_sector;
+	u16 peer_rx_sector;
+	u16 peer_tx_sector;
+};
+
+struct wil6210_priv {
+	struct pci_dev *pdev;
+	int n_msi;
+	struct wireless_dev *wdev;
+	void __iomem *csr;
+	ulong status;
+	/* profile */
+	u32 monitor_flags;
+	u32 secure_pcp; /* create secure PCP? */
+	int sinfo_gen;
+	/* cached ISR registers */
+	u32 isr_misc;
+	/* mailbox related */
+	struct mutex wmi_mutex;
+	struct wil6210_mbox_ctl mbox_ctl;
+	struct completion wmi_ready;
+	u16 wmi_seq;
+	u16 reply_id; /**< wait for this WMI event */
+	void *reply_buf;
+	u16 reply_size;
+	struct workqueue_struct *wmi_wq; /* for deferred calls */
+	struct work_struct wmi_event_worker;
+	struct workqueue_struct *wmi_wq_conn; /* for connect worker */
+	struct work_struct wmi_connect_worker;
+	struct work_struct disconnect_worker;
+	struct timer_list connect_timer;
+	int pending_connect_cid;
+	struct list_head pending_wmi_ev;
+	/*
+	 * protect pending_wmi_ev
+	 * - fill in IRQ from wil6210_irq_misc,
+	 * - consumed in thread by wmi_event_worker
+	 */
+	spinlock_t wmi_ev_lock;
+	/* DMA related */
+	struct vring vring_rx;
+	struct vring vring_tx[WIL6210_MAX_TX_RINGS];
+	u8 dst_addr[WIL6210_MAX_TX_RINGS][ETH_ALEN];
+	/* scan */
+	struct cfg80211_scan_request *scan_request;
+
+	struct mutex mutex; /* for wil6210_priv access in wil_{up|down} */
+	/* statistics */
+	struct wil6210_stats stats;
+	/* debugfs */
+	struct dentry *debug;
+	struct debugfs_blob_wrapper fw_code_blob;
+	struct debugfs_blob_wrapper fw_data_blob;
+	struct debugfs_blob_wrapper fw_peri_blob;
+	struct debugfs_blob_wrapper uc_code_blob;
+	struct debugfs_blob_wrapper uc_data_blob;
+	struct debugfs_blob_wrapper rgf_blob;
+};
+
+#define wil_to_wiphy(i) (i->wdev->wiphy)
+#define wil_to_dev(i) (wiphy_dev(wil_to_wiphy(i)))
+#define wiphy_to_wil(w) (struct wil6210_priv *)(wiphy_priv(w))
+#define wil_to_wdev(i) (i->wdev)
+#define wdev_to_wil(w) (struct wil6210_priv *)(wdev_priv(w))
+#define wil_to_ndev(i) (wil_to_wdev(i)->netdev)
+#define ndev_to_wil(n) (wdev_to_wil(n->ieee80211_ptr))
+
+#define wil_dbg(wil, fmt, arg...) netdev_dbg(wil_to_ndev(wil), fmt, ##arg)
+#define wil_info(wil, fmt, arg...) netdev_info(wil_to_ndev(wil), fmt, ##arg)
+#define wil_err(wil, fmt, arg...) netdev_err(wil_to_ndev(wil), fmt, ##arg)
+
+#define wil_dbg_IRQ(wil, fmt, arg...) wil_dbg(wil, "DBG[ IRQ]" fmt, ##arg)
+#define wil_dbg_TXRX(wil, fmt, arg...) wil_dbg(wil, "DBG[TXRX]" fmt, ##arg)
+#define wil_dbg_WMI(wil, fmt, arg...) wil_dbg(wil, "DBG[ WMI]" fmt, ##arg)
+
+#define wil_hex_dump_TXRX(prefix_str, prefix_type, rowsize,	\
+			  groupsize, buf, len, ascii)		\
+			  print_hex_dump_debug("DBG[TXRX]" prefix_str,\
+					 prefix_type, rowsize,	\
+					 groupsize, buf, len, ascii)
+
+#define wil_hex_dump_WMI(prefix_str, prefix_type, rowsize,	\
+			 groupsize, buf, len, ascii)		\
+			 print_hex_dump_debug("DBG[ WMI]" prefix_str,	\
+					prefix_type, rowsize,	\
+					groupsize, buf, len, ascii)
+
+void wil_memcpy_fromio_32(void *dst, const volatile void __iomem *src,
+			  size_t count);
+void wil_memcpy_toio_32(volatile void __iomem *dst, const void *src,
+			size_t count);
+
+void *wil_if_alloc(struct device *dev, void __iomem *csr);
+void wil_if_free(struct wil6210_priv *wil);
+int wil_if_add(struct wil6210_priv *wil);
+void wil_if_remove(struct wil6210_priv *wil);
+int wil_priv_init(struct wil6210_priv *wil);
+void wil_priv_deinit(struct wil6210_priv *wil);
+int wil_reset(struct wil6210_priv *wil);
+void wil_link_on(struct wil6210_priv *wil);
+void wil_link_off(struct wil6210_priv *wil);
+int wil_up(struct wil6210_priv *wil);
+int wil_down(struct wil6210_priv *wil);
+void wil_mbox_ring_le2cpus(struct wil6210_mbox_ring *r);
+
+void __iomem *wmi_buffer(struct wil6210_priv *wil, __le32 ptr);
+void __iomem *wmi_addr(struct wil6210_priv *wil, u32 ptr);
+int wmi_read_hdr(struct wil6210_priv *wil, __le32 ptr,
+		 struct wil6210_mbox_hdr *hdr);
+int wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len);
+void wmi_recv_cmd(struct wil6210_priv *wil);
+int wmi_call(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len,
+	     u16 reply_id, void *reply, u8 reply_size, int to_msec);
+void wmi_connect_worker(struct work_struct *work);
+void wmi_event_worker(struct work_struct *work);
+void wmi_event_flush(struct wil6210_priv *wil);
+int wmi_set_ssid(struct wil6210_priv *wil, u8 ssid_len, const void *ssid);
+int wmi_get_ssid(struct wil6210_priv *wil, u8 *ssid_len, void *ssid);
+int wmi_set_channel(struct wil6210_priv *wil, int channel);
+int wmi_get_channel(struct wil6210_priv *wil, int *channel);
+int wmi_tx_eapol(struct wil6210_priv *wil, struct sk_buff *skb);
+int wmi_del_cipher_key(struct wil6210_priv *wil, u8 key_index,
+		       const void *mac_addr);
+int wmi_add_cipher_key(struct wil6210_priv *wil, u8 key_index,
+		       const void *mac_addr, int key_len, const void *key);
+int wmi_echo(struct wil6210_priv *wil);
+int wmi_set_ie(struct wil6210_priv *wil, u8 type, u16 ie_len, const void *ie);
+
+int wil6210_init_irq(struct wil6210_priv *wil, int irq);
+void wil6210_fini_irq(struct wil6210_priv *wil, int irq);
+void wil6210_disable_irq(struct wil6210_priv *wil);
+void wil6210_enable_irq(struct wil6210_priv *wil);
+
+int wil6210_debugfs_init(struct wil6210_priv *wil);
+void wil6210_debugfs_remove(struct wil6210_priv *wil);
+
+struct wireless_dev *wil_cfg80211_init(struct device *dev);
+void wil_wdev_free(struct wil6210_priv *wil);
+
+int wmi_set_mac_address(struct wil6210_priv *wil, void *addr);
+int wmi_set_bcon(struct wil6210_priv *wil, int bi, u8 wmi_nettype);
+void wil6210_disconnect(struct wil6210_priv *wil, void *bssid);
+
+int wil_rx_init(struct wil6210_priv *wil);
+void wil_rx_fini(struct wil6210_priv *wil);
+
+/* TX API */
+int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
+		      int cid, int tid);
+void wil_vring_fini_tx(struct wil6210_priv *wil, int id);
+
+netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev);
+void wil_tx_complete(struct wil6210_priv *wil, int ringid);
+
+/* RX API */
+void wil_rx_handle(struct wil6210_priv *wil);
+
+int wil_iftype_nl2wmi(enum nl80211_iftype type);
+
+#endif /* __WIL6210_H__ */
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
new file mode 100644
index 0000000..12915f6
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -0,0 +1,975 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/pci.h>
+#include <linux/io.h>
+#include <linux/list.h>
+#include <linux/etherdevice.h>
+
+#include "wil6210.h"
+#include "wmi.h"
+
+/**
+ * WMI event receiving - theory of operations
+ *
+ * When firmware about to report WMI event, it fills memory area
+ * in the mailbox and raises misc. IRQ. Thread interrupt handler invoked for
+ * the misc IRQ, function @wmi_recv_cmd called by thread IRQ handler.
+ *
+ * @wmi_recv_cmd reads event, allocates memory chunk  and attaches it to the
+ * event list @wil->pending_wmi_ev. Then, work queue @wil->wmi_wq wakes up
+ * and handles events within the @wmi_event_worker. Every event get detached
+ * from list, processed and deleted.
+ *
+ * Purpose for this mechanism is to release IRQ thread; otherwise,
+ * if WMI event handling involves another WMI command flow, this 2-nd flow
+ * won't be completed because of blocked IRQ thread.
+ */
+
+/**
+ * Addressing - theory of operations
+ *
+ * There are several buses present on the WIL6210 card.
+ * Same memory areas are visible at different address on
+ * the different busses. There are 3 main bus masters:
+ *  - MAC CPU (ucode)
+ *  - User CPU (firmware)
+ *  - AHB (host)
+ *
+ * On the PCI bus, there is one BAR (BAR0) of 2Mb size, exposing
+ * AHB addresses starting from 0x880000
+ *
+ * Internally, firmware uses addresses that allows faster access but
+ * are invisible from the host. To read from these addresses, alternative
+ * AHB address must be used.
+ *
+ * Memory mapping
+ * Linker address         PCI/Host address
+ *                        0x880000 .. 0xa80000  2Mb BAR0
+ * 0x800000 .. 0x807000   0x900000 .. 0x907000  28k DCCM
+ * 0x840000 .. 0x857000   0x908000 .. 0x91f000  92k PERIPH
+ */
+
+/**
+ * @fw_mapping provides memory remapping table
+ */
+static const struct {
+	u32 from; /* linker address - from, inclusive */
+	u32 to;   /* linker address - to, exclusive */
+	u32 host; /* PCI/Host address - BAR0 + 0x880000 */
+} fw_mapping[] = {
+	{0x000000, 0x040000, 0x8c0000}, /* FW code RAM 256k */
+	{0x800000, 0x808000, 0x900000}, /* FW data RAM 32k */
+	{0x840000, 0x860000, 0x908000}, /* peripheral data RAM 128k/96k used */
+	{0x880000, 0x88a000, 0x880000}, /* various RGF */
+	{0x8c0000, 0x932000, 0x8c0000}, /* trivial mapping for upper area */
+	/*
+	 * 920000..930000 ucode code RAM
+	 * 930000..932000 ucode data RAM
+	 */
+};
+
+/**
+ * return AHB address for given firmware/ucode internal (linker) address
+ * @x - internal address
+ * If address have no valid AHB mapping, return 0
+ */
+static u32 wmi_addr_remap(u32 x)
+{
+	uint i;
+
+	for (i = 0; i < ARRAY_SIZE(fw_mapping); i++) {
+		if ((x >= fw_mapping[i].from) && (x < fw_mapping[i].to))
+			return x + fw_mapping[i].host - fw_mapping[i].from;
+	}
+
+	return 0;
+}
+
+/**
+ * Check address validity for WMI buffer; remap if needed
+ * @ptr - internal (linker) fw/ucode address
+ *
+ * Valid buffer should be DWORD aligned
+ *
+ * return address for accessing buffer from the host;
+ * if buffer is not valid, return NULL.
+ */
+void __iomem *wmi_buffer(struct wil6210_priv *wil, __le32 ptr_)
+{
+	u32 off;
+	u32 ptr = le32_to_cpu(ptr_);
+
+	if (ptr % 4)
+		return NULL;
+
+	ptr = wmi_addr_remap(ptr);
+	if (ptr < WIL6210_FW_HOST_OFF)
+		return NULL;
+
+	off = HOSTADDR(ptr);
+	if (off > WIL6210_MEM_SIZE - 4)
+		return NULL;
+
+	return wil->csr + off;
+}
+
+/**
+ * Check address validity
+ */
+void __iomem *wmi_addr(struct wil6210_priv *wil, u32 ptr)
+{
+	u32 off;
+
+	if (ptr % 4)
+		return NULL;
+
+	if (ptr < WIL6210_FW_HOST_OFF)
+		return NULL;
+
+	off = HOSTADDR(ptr);
+	if (off > WIL6210_MEM_SIZE - 4)
+		return NULL;
+
+	return wil->csr + off;
+}
+
+int wmi_read_hdr(struct wil6210_priv *wil, __le32 ptr,
+		 struct wil6210_mbox_hdr *hdr)
+{
+	void __iomem *src = wmi_buffer(wil, ptr);
+	if (!src)
+		return -EINVAL;
+
+	wil_memcpy_fromio_32(hdr, src, sizeof(*hdr));
+
+	return 0;
+}
+
+static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
+{
+	struct {
+		struct wil6210_mbox_hdr hdr;
+		struct wil6210_mbox_hdr_wmi wmi;
+	} __packed cmd = {
+		.hdr = {
+			.type = WIL_MBOX_HDR_TYPE_WMI,
+			.flags = 0,
+			.len = cpu_to_le16(sizeof(cmd.wmi) + len),
+		},
+		.wmi = {
+			.id = cpu_to_le16(cmdid),
+			.info1 = 0,
+		},
+	};
+	struct wil6210_mbox_ring *r = &wil->mbox_ctl.tx;
+	struct wil6210_mbox_ring_desc d_head;
+	u32 next_head;
+	void __iomem *dst;
+	void __iomem *head = wmi_addr(wil, r->head);
+	uint retry;
+
+	if (sizeof(cmd) + len > r->entry_size) {
+		wil_err(wil, "WMI size too large: %d bytes, max is %d\n",
+			(int)(sizeof(cmd) + len), r->entry_size);
+		return -ERANGE;
+
+	}
+
+	might_sleep();
+
+	if (!test_bit(wil_status_fwready, &wil->status)) {
+		wil_err(wil, "FW not ready\n");
+		return -EAGAIN;
+	}
+
+	if (!head) {
+		wil_err(wil, "WMI head is garbage: 0x%08x\n", r->head);
+		return -EINVAL;
+	}
+	/* read Tx head till it is not busy */
+	for (retry = 5; retry > 0; retry--) {
+		wil_memcpy_fromio_32(&d_head, head, sizeof(d_head));
+		if (d_head.sync == 0)
+			break;
+		msleep(20);
+	}
+	if (d_head.sync != 0) {
+		wil_err(wil, "WMI head busy\n");
+		return -EBUSY;
+	}
+	/* next head */
+	next_head = r->base + ((r->head - r->base + sizeof(d_head)) % r->size);
+	wil_dbg_WMI(wil, "Head 0x%08x -> 0x%08x\n", r->head, next_head);
+	/* wait till FW finish with previous command */
+	for (retry = 5; retry > 0; retry--) {
+		r->tail = ioread32(wil->csr + HOST_MBOX +
+				   offsetof(struct wil6210_mbox_ctl, tx.tail));
+		if (next_head != r->tail)
+			break;
+		msleep(20);
+	}
+	if (next_head == r->tail) {
+		wil_err(wil, "WMI ring full\n");
+		return -EBUSY;
+	}
+	dst = wmi_buffer(wil, d_head.addr);
+	if (!dst) {
+		wil_err(wil, "invalid WMI buffer: 0x%08x\n",
+			le32_to_cpu(d_head.addr));
+		return -EINVAL;
+	}
+	cmd.hdr.seq = cpu_to_le16(++wil->wmi_seq);
+	/* set command */
+	wil_dbg_WMI(wil, "WMI command 0x%04x [%d]\n", cmdid, len);
+	wil_hex_dump_WMI("Cmd ", DUMP_PREFIX_OFFSET, 16, 1, &cmd,
+			 sizeof(cmd), true);
+	wil_hex_dump_WMI("cmd ", DUMP_PREFIX_OFFSET, 16, 1, buf,
+			 len, true);
+	wil_memcpy_toio_32(dst, &cmd, sizeof(cmd));
+	wil_memcpy_toio_32(dst + sizeof(cmd), buf, len);
+	/* mark entry as full */
+	iowrite32(1, wil->csr + HOSTADDR(r->head) +
+		  offsetof(struct wil6210_mbox_ring_desc, sync));
+	/* advance next ptr */
+	iowrite32(r->head = next_head, wil->csr + HOST_MBOX +
+		  offsetof(struct wil6210_mbox_ctl, tx.head));
+
+	/* interrupt to FW */
+	iowrite32(SW_INT_MBOX, wil->csr + HOST_SW_INT);
+
+	return 0;
+}
+
+int wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
+{
+	int rc;
+
+	mutex_lock(&wil->wmi_mutex);
+	rc = __wmi_send(wil, cmdid, buf, len);
+	mutex_unlock(&wil->wmi_mutex);
+
+	return rc;
+}
+
+/*=== Event handlers ===*/
+static void wmi_evt_ready(struct wil6210_priv *wil, int id, void *d, int len)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct wireless_dev *wdev = wil->wdev;
+	struct wmi_ready_event *evt = d;
+	u32 ver = le32_to_cpu(evt->sw_version);
+
+	wil_dbg_WMI(wil, "FW ver. %d; MAC %pM\n", ver, evt->mac);
+
+	if (!is_valid_ether_addr(ndev->dev_addr)) {
+		memcpy(ndev->dev_addr, evt->mac, ETH_ALEN);
+		memcpy(ndev->perm_addr, evt->mac, ETH_ALEN);
+	}
+	snprintf(wdev->wiphy->fw_version, sizeof(wdev->wiphy->fw_version),
+		 "%d", ver);
+}
+
+static void wmi_evt_fw_ready(struct wil6210_priv *wil, int id, void *d,
+			     int len)
+{
+	wil_dbg_WMI(wil, "WMI: FW ready\n");
+
+	set_bit(wil_status_fwready, &wil->status);
+	/* reuse wmi_ready for the firmware ready indication */
+	complete(&wil->wmi_ready);
+}
+
+static void wmi_evt_rx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
+{
+	struct wmi_rx_mgmt_packet_event *data = d;
+	struct wiphy *wiphy = wil_to_wiphy(wil);
+	struct ieee80211_mgmt *rx_mgmt_frame =
+			(struct ieee80211_mgmt *)data->payload;
+	int ch_no = data->info.channel+1;
+	u32 freq = ieee80211_channel_to_frequency(ch_no,
+			IEEE80211_BAND_60GHZ);
+	struct ieee80211_channel *channel = ieee80211_get_channel(wiphy, freq);
+	/* TODO convert LE to CPU */
+	s32 signal = 0; /* TODO */
+	__le16 fc = rx_mgmt_frame->frame_control;
+	u32 d_len = le32_to_cpu(data->info.len);
+	u16 d_status = le16_to_cpu(data->info.status);
+
+	wil_dbg_WMI(wil, "MGMT: channel %d MCS %d SNR %d\n",
+		    data->info.channel, data->info.mcs, data->info.snr);
+	wil_dbg_WMI(wil, "status 0x%04x len %d stype %04x\n", d_status, d_len,
+		    le16_to_cpu(data->info.stype));
+	wil_dbg_WMI(wil, "qid %d mid %d cid %d\n",
+		    data->info.qid, data->info.mid, data->info.cid);
+
+	if (!channel) {
+		wil_err(wil, "Frame on unsupported channel\n");
+		return;
+	}
+
+	if (ieee80211_is_beacon(fc) || ieee80211_is_probe_resp(fc)) {
+		struct cfg80211_bss *bss;
+		u64 tsf = le64_to_cpu(rx_mgmt_frame->u.beacon.timestamp);
+		u16 cap = le16_to_cpu(rx_mgmt_frame->u.beacon.capab_info);
+		u16 bi = le16_to_cpu(rx_mgmt_frame->u.beacon.beacon_int);
+		const u8 *ie_buf = rx_mgmt_frame->u.beacon.variable;
+		size_t ie_len = d_len - offsetof(struct ieee80211_mgmt,
+						 u.beacon.variable);
+		wil_dbg_WMI(wil, "Capability info : 0x%04x\n", cap);
+
+		bss = cfg80211_inform_bss(wiphy, channel, rx_mgmt_frame->bssid,
+					  tsf, cap, bi, ie_buf, ie_len,
+					  signal, GFP_KERNEL);
+		if (bss) {
+			wil_dbg_WMI(wil, "Added BSS %pM\n",
+				    rx_mgmt_frame->bssid);
+			cfg80211_put_bss(bss);
+		} else {
+			wil_err(wil, "cfg80211_inform_bss() failed\n");
+		}
+	}
+}
+
+static void wmi_evt_scan_complete(struct wil6210_priv *wil, int id,
+				  void *d, int len)
+{
+	if (wil->scan_request) {
+		struct wmi_scan_complete_event *data = d;
+		bool aborted = (data->status != 0);
+
+		wil_dbg_WMI(wil, "SCAN_COMPLETE(0x%08x)\n", data->status);
+		cfg80211_scan_done(wil->scan_request, aborted);
+		wil->scan_request = NULL;
+	} else {
+		wil_err(wil, "SCAN_COMPLETE while not scanning\n");
+	}
+}
+
+static void wmi_evt_connect(struct wil6210_priv *wil, int id, void *d, int len)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct wireless_dev *wdev = wil->wdev;
+	struct wmi_connect_event *evt = d;
+	int ch; /* channel number */
+	struct station_info sinfo;
+	u8 *assoc_req_ie, *assoc_resp_ie;
+	size_t assoc_req_ielen, assoc_resp_ielen;
+	/* capinfo(u16) + listen_interval(u16) + IEs */
+	const size_t assoc_req_ie_offset = sizeof(u16) * 2;
+	/* capinfo(u16) + status_code(u16) + associd(u16) + IEs */
+	const size_t assoc_resp_ie_offset = sizeof(u16) * 3;
+
+	if (len < sizeof(*evt)) {
+		wil_err(wil, "Connect event too short : %d bytes\n", len);
+		return;
+	}
+	if (len != sizeof(*evt) + evt->beacon_ie_len + evt->assoc_req_len +
+		   evt->assoc_resp_len) {
+		wil_err(wil,
+			"Connect event corrupted : %d != %d + %d + %d + %d\n",
+			len, (int)sizeof(*evt), evt->beacon_ie_len,
+			evt->assoc_req_len, evt->assoc_resp_len);
+		return;
+	}
+	ch = evt->channel + 1;
+	wil_dbg_WMI(wil, "Connect %pM channel [%d] cid %d\n",
+		    evt->bssid, ch, evt->cid);
+	wil_hex_dump_WMI("connect AI : ", DUMP_PREFIX_OFFSET, 16, 1,
+			 evt->assoc_info, len - sizeof(*evt), true);
+
+	/* figure out IE's */
+	assoc_req_ie = &evt->assoc_info[evt->beacon_ie_len +
+					assoc_req_ie_offset];
+	assoc_req_ielen = evt->assoc_req_len - assoc_req_ie_offset;
+	if (evt->assoc_req_len <= assoc_req_ie_offset) {
+		assoc_req_ie = NULL;
+		assoc_req_ielen = 0;
+	}
+
+	assoc_resp_ie = &evt->assoc_info[evt->beacon_ie_len +
+					 evt->assoc_req_len +
+					 assoc_resp_ie_offset];
+	assoc_resp_ielen = evt->assoc_resp_len - assoc_resp_ie_offset;
+	if (evt->assoc_resp_len <= assoc_resp_ie_offset) {
+		assoc_resp_ie = NULL;
+		assoc_resp_ielen = 0;
+	}
+
+	if ((wdev->iftype == NL80211_IFTYPE_STATION) ||
+	    (wdev->iftype == NL80211_IFTYPE_P2P_CLIENT)) {
+		if (wdev->sme_state != CFG80211_SME_CONNECTING) {
+			wil_err(wil, "Not in connecting state\n");
+			return;
+		}
+		del_timer_sync(&wil->connect_timer);
+		cfg80211_connect_result(ndev, evt->bssid,
+					assoc_req_ie, assoc_req_ielen,
+					assoc_resp_ie, assoc_resp_ielen,
+					WLAN_STATUS_SUCCESS, GFP_KERNEL);
+
+	} else if ((wdev->iftype == NL80211_IFTYPE_AP) ||
+		   (wdev->iftype == NL80211_IFTYPE_P2P_GO)) {
+		memset(&sinfo, 0, sizeof(sinfo));
+
+		sinfo.generation = wil->sinfo_gen++;
+
+		if (assoc_req_ie) {
+			sinfo.assoc_req_ies = assoc_req_ie;
+			sinfo.assoc_req_ies_len = assoc_req_ielen;
+			sinfo.filled |= STATION_INFO_ASSOC_REQ_IES;
+		}
+
+		cfg80211_new_sta(ndev, evt->bssid, &sinfo, GFP_KERNEL);
+	}
+	set_bit(wil_status_fwconnected, &wil->status);
+
+	/* FIXME FW can transmit only ucast frames to peer */
+	/* FIXME real ring_id instead of hard coded 0 */
+	memcpy(wil->dst_addr[0], evt->bssid, ETH_ALEN);
+
+	wil->pending_connect_cid = evt->cid;
+	queue_work(wil->wmi_wq_conn, &wil->wmi_connect_worker);
+}
+
+static void wmi_evt_disconnect(struct wil6210_priv *wil, int id,
+			       void *d, int len)
+{
+	struct wmi_disconnect_event *evt = d;
+
+	wil_dbg_WMI(wil, "Disconnect %pM reason %d proto %d wmi\n",
+		    evt->bssid,
+		    evt->protocol_reason_status, evt->disconnect_reason);
+
+	wil->sinfo_gen++;
+
+	wil6210_disconnect(wil, evt->bssid);
+	clear_bit(wil_status_dontscan, &wil->status);
+}
+
+static void wmi_evt_notify(struct wil6210_priv *wil, int id, void *d, int len)
+{
+	struct wmi_notify_req_done_event *evt = d;
+
+	if (len < sizeof(*evt)) {
+		wil_err(wil, "Short NOTIFY event\n");
+		return;
+	}
+
+	wil->stats.tsf = le64_to_cpu(evt->tsf);
+	wil->stats.snr = le32_to_cpu(evt->snr_val);
+	wil->stats.bf_mcs = le16_to_cpu(evt->bf_mcs);
+	wil->stats.my_rx_sector = le16_to_cpu(evt->my_rx_sector);
+	wil->stats.my_tx_sector = le16_to_cpu(evt->my_tx_sector);
+	wil->stats.peer_rx_sector = le16_to_cpu(evt->other_rx_sector);
+	wil->stats.peer_tx_sector = le16_to_cpu(evt->other_tx_sector);
+	wil_dbg_WMI(wil, "Link status, MCS %d TSF 0x%016llx\n"
+		    "BF status 0x%08x SNR 0x%08x\n"
+		    "Tx Tpt %d goodput %d Rx goodput %d\n"
+		    "Sectors(rx:tx) my %d:%d peer %d:%d\n",
+		    wil->stats.bf_mcs, wil->stats.tsf, evt->status,
+		    wil->stats.snr, le32_to_cpu(evt->tx_tpt),
+		    le32_to_cpu(evt->tx_goodput), le32_to_cpu(evt->rx_goodput),
+		    wil->stats.my_rx_sector, wil->stats.my_tx_sector,
+		    wil->stats.peer_rx_sector, wil->stats.peer_tx_sector);
+}
+
+/*
+ * Firmware reports EAPOL frame using WME event.
+ * Reconstruct Ethernet frame and deliver it via normal Rx
+ */
+static void wmi_evt_eapol_rx(struct wil6210_priv *wil, int id,
+			     void *d, int len)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct wmi_eapol_rx_event *evt = d;
+	u16 eapol_len = le16_to_cpu(evt->eapol_len);
+	int sz = eapol_len + ETH_HLEN;
+	struct sk_buff *skb;
+	struct ethhdr *eth;
+
+	wil_dbg_WMI(wil, "EAPOL len %d from %pM\n", eapol_len,
+		    evt->src_mac);
+
+	if (eapol_len > 196) { /* TODO: revisit size limit */
+		wil_err(wil, "EAPOL too large\n");
+		return;
+	}
+
+	skb = alloc_skb(sz, GFP_KERNEL);
+	if (!skb) {
+		wil_err(wil, "Failed to allocate skb\n");
+		return;
+	}
+	eth = (struct ethhdr *)skb_put(skb, ETH_HLEN);
+	memcpy(eth->h_dest, ndev->dev_addr, ETH_ALEN);
+	memcpy(eth->h_source, evt->src_mac, ETH_ALEN);
+	eth->h_proto = cpu_to_be16(ETH_P_PAE);
+	memcpy(skb_put(skb, eapol_len), evt->eapol, eapol_len);
+	skb->protocol = eth_type_trans(skb, ndev);
+	if (likely(netif_rx_ni(skb) == NET_RX_SUCCESS)) {
+		ndev->stats.rx_packets++;
+		ndev->stats.rx_bytes += skb->len;
+	} else {
+		ndev->stats.rx_dropped++;
+	}
+}
+
+static const struct {
+	int eventid;
+	void (*handler)(struct wil6210_priv *wil, int eventid,
+			void *data, int data_len);
+} wmi_evt_handlers[] = {
+	{WMI_READY_EVENTID,		wmi_evt_ready},
+	{WMI_FW_READY_EVENTID,		wmi_evt_fw_ready},
+	{WMI_RX_MGMT_PACKET_EVENTID,	wmi_evt_rx_mgmt},
+	{WMI_SCAN_COMPLETE_EVENTID,	wmi_evt_scan_complete},
+	{WMI_CONNECT_EVENTID,		wmi_evt_connect},
+	{WMI_DISCONNECT_EVENTID,	wmi_evt_disconnect},
+	{WMI_NOTIFY_REQ_DONE_EVENTID,	wmi_evt_notify},
+	{WMI_EAPOL_RX_EVENTID,		wmi_evt_eapol_rx},
+};
+
+/*
+ * Run in IRQ context
+ * Extract WMI command from mailbox. Queue it to the @wil->pending_wmi_ev
+ * that will be eventually handled by the @wmi_event_worker in the thread
+ * context of thread "wil6210_wmi"
+ */
+void wmi_recv_cmd(struct wil6210_priv *wil)
+{
+	struct wil6210_mbox_ring_desc d_tail;
+	struct wil6210_mbox_hdr hdr;
+	struct wil6210_mbox_ring *r = &wil->mbox_ctl.rx;
+	struct pending_wmi_event *evt;
+	u8 *cmd;
+	void __iomem *src;
+	ulong flags;
+
+	for (;;) {
+		u16 len;
+
+		r->head = ioread32(wil->csr + HOST_MBOX +
+				   offsetof(struct wil6210_mbox_ctl, rx.head));
+		if (r->tail == r->head)
+			return;
+
+		/* read cmd from tail */
+		wil_memcpy_fromio_32(&d_tail, wil->csr + HOSTADDR(r->tail),
+				     sizeof(struct wil6210_mbox_ring_desc));
+		if (d_tail.sync == 0) {
+			wil_err(wil, "Mbox evt not owned by FW?\n");
+			return;
+		}
+
+		if (0 != wmi_read_hdr(wil, d_tail.addr, &hdr)) {
+			wil_err(wil, "Mbox evt at 0x%08x?\n",
+				le32_to_cpu(d_tail.addr));
+			return;
+		}
+
+		len = le16_to_cpu(hdr.len);
+		src = wmi_buffer(wil, d_tail.addr) +
+		      sizeof(struct wil6210_mbox_hdr);
+		evt = kmalloc(ALIGN(offsetof(struct pending_wmi_event,
+					     event.wmi) + len, 4),
+			      GFP_KERNEL);
+		if (!evt) {
+			wil_err(wil, "kmalloc for WMI event (%d) failed\n",
+				len);
+			return;
+		}
+		evt->event.hdr = hdr;
+		cmd = (void *)&evt->event.wmi;
+		wil_memcpy_fromio_32(cmd, src, len);
+		/* mark entry as empty */
+		iowrite32(0, wil->csr + HOSTADDR(r->tail) +
+			  offsetof(struct wil6210_mbox_ring_desc, sync));
+		/* indicate */
+		wil_dbg_WMI(wil, "Mbox evt %04x %04x %04x %02x\n",
+			    le16_to_cpu(hdr.seq), len, le16_to_cpu(hdr.type),
+			    hdr.flags);
+		if ((hdr.type == WIL_MBOX_HDR_TYPE_WMI) &&
+		    (len >= sizeof(struct wil6210_mbox_hdr_wmi))) {
+			wil_dbg_WMI(wil, "WMI event 0x%04x\n",
+				    evt->event.wmi.id);
+		}
+		wil_hex_dump_WMI("evt ", DUMP_PREFIX_OFFSET, 16, 1,
+				 &evt->event.hdr, sizeof(hdr) + len, true);
+
+		/* advance tail */
+		r->tail = r->base + ((r->tail - r->base +
+			  sizeof(struct wil6210_mbox_ring_desc)) % r->size);
+		iowrite32(r->tail, wil->csr + HOST_MBOX +
+			  offsetof(struct wil6210_mbox_ctl, rx.tail));
+
+		/* add to the pending list */
+		spin_lock_irqsave(&wil->wmi_ev_lock, flags);
+		list_add_tail(&evt->list, &wil->pending_wmi_ev);
+		spin_unlock_irqrestore(&wil->wmi_ev_lock, flags);
+		{
+			int q =	queue_work(wil->wmi_wq,
+					   &wil->wmi_event_worker);
+			wil_dbg_WMI(wil, "queue_work -> %d\n", q);
+		}
+	}
+}
+
+int wmi_call(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len,
+	     u16 reply_id, void *reply, u8 reply_size, int to_msec)
+{
+	int rc;
+	int remain;
+
+	mutex_lock(&wil->wmi_mutex);
+
+	rc = __wmi_send(wil, cmdid, buf, len);
+	if (rc)
+		goto out;
+
+	wil->reply_id = reply_id;
+	wil->reply_buf = reply;
+	wil->reply_size = reply_size;
+	remain = wait_for_completion_timeout(&wil->wmi_ready,
+			msecs_to_jiffies(to_msec));
+	if (0 == remain) {
+		wil_err(wil, "wmi_call(0x%04x->0x%04x) timeout %d msec\n",
+			cmdid, reply_id, to_msec);
+		rc = -ETIME;
+	} else {
+		wil_dbg_WMI(wil,
+			    "wmi_call(0x%04x->0x%04x) completed in %d msec\n",
+			    cmdid, reply_id,
+			    to_msec - jiffies_to_msecs(remain));
+	}
+	wil->reply_id = 0;
+	wil->reply_buf = NULL;
+	wil->reply_size = 0;
+ out:
+	mutex_unlock(&wil->wmi_mutex);
+
+	return rc;
+}
+
+int wmi_echo(struct wil6210_priv *wil)
+{
+	struct wmi_echo_cmd cmd = {
+		.value = cpu_to_le32(0x12345678),
+	};
+
+	return wmi_call(wil, WMI_ECHO_CMDID, &cmd, sizeof(cmd),
+			 WMI_ECHO_RSP_EVENTID, NULL, 0, 20);
+}
+
+int wmi_set_mac_address(struct wil6210_priv *wil, void *addr)
+{
+	struct wmi_set_mac_address_cmd cmd;
+
+	memcpy(cmd.mac, addr, ETH_ALEN);
+
+	wil_dbg_WMI(wil, "Set MAC %pM\n", addr);
+
+	return wmi_send(wil, WMI_SET_MAC_ADDRESS_CMDID, &cmd, sizeof(cmd));
+}
+
+int wmi_set_bcon(struct wil6210_priv *wil, int bi, u8 wmi_nettype)
+{
+	struct wmi_bcon_ctrl_cmd cmd = {
+		.bcon_interval = cpu_to_le16(bi),
+		.network_type = wmi_nettype,
+		.disable_sec_offload = 1,
+	};
+
+	if (!wil->secure_pcp)
+		cmd.disable_sec = 1;
+
+	return wmi_send(wil, WMI_BCON_CTRL_CMDID, &cmd, sizeof(cmd));
+}
+
+int wmi_set_ssid(struct wil6210_priv *wil, u8 ssid_len, const void *ssid)
+{
+	struct wmi_set_ssid_cmd cmd = {
+		.ssid_len = cpu_to_le32(ssid_len),
+	};
+
+	if (ssid_len > sizeof(cmd.ssid))
+		return -EINVAL;
+
+	memcpy(cmd.ssid, ssid, ssid_len);
+
+	return wmi_send(wil, WMI_SET_SSID_CMDID, &cmd, sizeof(cmd));
+}
+
+int wmi_get_ssid(struct wil6210_priv *wil, u8 *ssid_len, void *ssid)
+{
+	int rc;
+	struct {
+		struct wil6210_mbox_hdr_wmi wmi;
+		struct wmi_set_ssid_cmd cmd;
+	} __packed reply;
+	int len; /* reply.cmd.ssid_len in CPU order */
+
+	rc = wmi_call(wil, WMI_GET_SSID_CMDID, NULL, 0, WMI_GET_SSID_EVENTID,
+		      &reply, sizeof(reply), 20);
+	if (rc)
+		return rc;
+
+	len = le32_to_cpu(reply.cmd.ssid_len);
+	if (len > sizeof(reply.cmd.ssid))
+		return -EINVAL;
+
+	*ssid_len = len;
+	memcpy(ssid, reply.cmd.ssid, len);
+
+	return 0;
+}
+
+int wmi_set_channel(struct wil6210_priv *wil, int channel)
+{
+	struct wmi_set_pcp_channel_cmd cmd = {
+		.channel = channel - 1,
+	};
+
+	return wmi_send(wil, WMI_SET_PCP_CHANNEL_CMDID, &cmd, sizeof(cmd));
+}
+
+int wmi_get_channel(struct wil6210_priv *wil, int *channel)
+{
+	int rc;
+	struct {
+		struct wil6210_mbox_hdr_wmi wmi;
+		struct wmi_set_pcp_channel_cmd cmd;
+	} __packed reply;
+
+	rc = wmi_call(wil, WMI_GET_PCP_CHANNEL_CMDID, NULL, 0,
+		      WMI_GET_PCP_CHANNEL_EVENTID, &reply, sizeof(reply), 20);
+	if (rc)
+		return rc;
+
+	if (reply.cmd.channel > 3)
+		return -EINVAL;
+
+	*channel = reply.cmd.channel + 1;
+
+	return 0;
+}
+
+int wmi_tx_eapol(struct wil6210_priv *wil, struct sk_buff *skb)
+{
+	struct wmi_eapol_tx_cmd *cmd;
+	struct ethhdr *eth;
+	u16 eapol_len = skb->len - ETH_HLEN;
+	void *eapol = skb->data + ETH_HLEN;
+	uint i;
+	int rc;
+
+	skb_set_mac_header(skb, 0);
+	eth = eth_hdr(skb);
+	wil_dbg_WMI(wil, "EAPOL %d bytes to %pM\n", eapol_len, eth->h_dest);
+	for (i = 0; i < ARRAY_SIZE(wil->vring_tx); i++) {
+		if (memcmp(wil->dst_addr[i], eth->h_dest, ETH_ALEN) == 0)
+			goto found_dest;
+	}
+
+	return -EINVAL;
+
+ found_dest:
+	/* find out eapol data & len */
+	cmd = kzalloc(sizeof(*cmd) + eapol_len, GFP_KERNEL);
+	if (!cmd)
+		return -EINVAL;
+
+	memcpy(cmd->dst_mac, eth->h_dest, ETH_ALEN);
+	cmd->eapol_len = cpu_to_le16(eapol_len);
+	memcpy(cmd->eapol, eapol, eapol_len);
+	rc = wmi_send(wil, WMI_EAPOL_TX_CMDID, cmd, sizeof(*cmd) + eapol_len);
+	kfree(cmd);
+
+	return rc;
+}
+
+int wmi_del_cipher_key(struct wil6210_priv *wil, u8 key_index,
+		       const void *mac_addr)
+{
+	struct wmi_delete_cipher_key_cmd cmd = {
+		.key_index = key_index,
+	};
+
+	if (mac_addr)
+		memcpy(cmd.mac, mac_addr, WMI_MAC_LEN);
+
+	return wmi_send(wil, WMI_DELETE_CIPHER_KEY_CMDID, &cmd, sizeof(cmd));
+}
+
+int wmi_add_cipher_key(struct wil6210_priv *wil, u8 key_index,
+		       const void *mac_addr, int key_len, const void *key)
+{
+	struct wmi_add_cipher_key_cmd cmd = {
+		.key_index = key_index,
+		.key_usage = WMI_KEY_USE_PAIRWISE,
+		.key_len = key_len,
+	};
+
+	if (!key || (key_len > sizeof(cmd.key)))
+		return -EINVAL;
+
+	memcpy(cmd.key, key, key_len);
+	if (mac_addr)
+		memcpy(cmd.mac, mac_addr, WMI_MAC_LEN);
+
+	return wmi_send(wil, WMI_ADD_CIPHER_KEY_CMDID, &cmd, sizeof(cmd));
+}
+
+int wmi_set_ie(struct wil6210_priv *wil, u8 type, u16 ie_len, const void *ie)
+{
+	int rc;
+	u16 len = sizeof(struct wmi_set_appie_cmd) + ie_len;
+	struct wmi_set_appie_cmd *cmd = kzalloc(len, GFP_KERNEL);
+	if (!cmd) {
+		wil_err(wil, "kmalloc(%d) failed\n", len);
+		return -ENOMEM;
+	}
+
+	cmd->mgmt_frm_type = type;
+	/* BUG: FW API define ieLen as u8. Will fix FW */
+	cmd->ie_len = cpu_to_le16(ie_len);
+	memcpy(cmd->ie_info, ie, ie_len);
+	rc = wmi_send(wil, WMI_SET_APPIE_CMDID, &cmd, len);
+	kfree(cmd);
+
+	return rc;
+}
+
+void wmi_event_flush(struct wil6210_priv *wil)
+{
+	struct pending_wmi_event *evt, *t;
+
+	wil_dbg_WMI(wil, "%s()\n", __func__);
+
+	list_for_each_entry_safe(evt, t, &wil->pending_wmi_ev, list) {
+		list_del(&evt->list);
+		kfree(evt);
+	}
+}
+
+static bool wmi_evt_call_handler(struct wil6210_priv *wil, int id,
+				 void *d, int len)
+{
+	uint i;
+
+	for (i = 0; i < ARRAY_SIZE(wmi_evt_handlers); i++) {
+		if (wmi_evt_handlers[i].eventid == id) {
+			wmi_evt_handlers[i].handler(wil, id, d, len);
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static void wmi_event_handle(struct wil6210_priv *wil,
+			     struct wil6210_mbox_hdr *hdr)
+{
+	u16 len = le16_to_cpu(hdr->len);
+
+	if ((hdr->type == WIL_MBOX_HDR_TYPE_WMI) &&
+	    (len >= sizeof(struct wil6210_mbox_hdr_wmi))) {
+		struct wil6210_mbox_hdr_wmi *wmi = (void *)(&hdr[1]);
+		void *evt_data = (void *)(&wmi[1]);
+		u16 id = le16_to_cpu(wmi->id);
+		/* check if someone waits for this event */
+		if (wil->reply_id && wil->reply_id == id) {
+			if (wil->reply_buf) {
+				memcpy(wil->reply_buf, wmi,
+				       min(len, wil->reply_size));
+			} else {
+				wmi_evt_call_handler(wil, id, evt_data,
+						     len - sizeof(*wmi));
+			}
+			wil_dbg_WMI(wil, "Complete WMI 0x%04x\n", id);
+			complete(&wil->wmi_ready);
+			return;
+		}
+		/* unsolicited event */
+		/* search for handler */
+		if (!wmi_evt_call_handler(wil, id, evt_data,
+					  len - sizeof(*wmi))) {
+			wil_err(wil, "Unhandled event 0x%04x\n", id);
+		}
+	} else {
+		wil_err(wil, "Unknown event type\n");
+		print_hex_dump(KERN_ERR, "evt?? ", DUMP_PREFIX_OFFSET, 16, 1,
+			       hdr, sizeof(*hdr) + len, true);
+	}
+}
+
+/*
+ * Retrieve next WMI event from the pending list
+ */
+static struct list_head *next_wmi_ev(struct wil6210_priv *wil)
+{
+	ulong flags;
+	struct list_head *ret = NULL;
+
+	spin_lock_irqsave(&wil->wmi_ev_lock, flags);
+
+	if (!list_empty(&wil->pending_wmi_ev)) {
+		ret = wil->pending_wmi_ev.next;
+		list_del(ret);
+	}
+
+	spin_unlock_irqrestore(&wil->wmi_ev_lock, flags);
+
+	return ret;
+}
+
+/*
+ * Handler for the WMI events
+ */
+void wmi_event_worker(struct work_struct *work)
+{
+	struct wil6210_priv *wil = container_of(work, struct wil6210_priv,
+						 wmi_event_worker);
+	struct pending_wmi_event *evt;
+	struct list_head *lh;
+
+	while ((lh = next_wmi_ev(wil)) != NULL) {
+		evt = list_entry(lh, struct pending_wmi_event, list);
+		wmi_event_handle(wil, &evt->event.hdr);
+		kfree(evt);
+	}
+}
+
+void wmi_connect_worker(struct work_struct *work)
+{
+	int rc;
+	struct wil6210_priv *wil = container_of(work, struct wil6210_priv,
+						wmi_connect_worker);
+
+	if (wil->pending_connect_cid < 0) {
+		wil_err(wil, "No connection pending\n");
+		return;
+	}
+
+	wil_dbg_WMI(wil, "Configure for connection CID %d\n",
+		    wil->pending_connect_cid);
+
+	rc = wil_vring_init_tx(wil, 0, WIL6210_TX_RING_SIZE,
+			       wil->pending_connect_cid, 0);
+	wil->pending_connect_cid = -1;
+	if (rc == 0)
+		wil_link_on(wil);
+}
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
new file mode 100644
index 0000000..3bbf875
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -0,0 +1,1116 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ * Copyright (c) 2006-2012 Wilocity .
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+/*
+ * This file contains the definitions of the WMI protocol specified in the
+ * Wireless Module Interface (WMI) for the Wilocity
+ * MARLON 60 Gigabit wireless solution.
+ * It includes definitions of all the commands and events.
+ * Commands are messages from the host to the WM.
+ * Events are messages from the WM to the host.
+ */
+
+#ifndef __WILOCITY_WMI_H__
+#define __WILOCITY_WMI_H__
+
+/* General */
+
+#define WMI_MAC_LEN		(6)
+#define WMI_PROX_RANGE_NUM	(3)
+
+/* List of Commands */
+enum wmi_command_id {
+	WMI_CONNECT_CMDID		= 0x0001,
+	WMI_DISCONNECT_CMDID		= 0x0003,
+	WMI_START_SCAN_CMDID		= 0x0007,
+	WMI_SET_BSS_FILTER_CMDID	= 0x0009,
+	WMI_SET_PROBED_SSID_CMDID	= 0x000a,
+	WMI_SET_LISTEN_INT_CMDID	= 0x000b,
+	WMI_BCON_CTRL_CMDID		= 0x000f,
+	WMI_ADD_CIPHER_KEY_CMDID	= 0x0016,
+	WMI_DELETE_CIPHER_KEY_CMDID	= 0x0017,
+	WMI_SET_APPIE_CMDID		= 0x003f,
+	WMI_GET_APPIE_CMDID		= 0x0040,
+	WMI_SET_WSC_STATUS_CMDID	= 0x0041,
+	WMI_PXMT_RANGE_CFG_CMDID	= 0x0042,
+	WMI_PXMT_SNR2_RANGE_CFG_CMDID	= 0x0043,
+	WMI_FAST_MEM_ACC_MODE_CMDID	= 0x0300,
+	WMI_MEM_READ_CMDID		= 0x0800,
+	WMI_MEM_WR_CMDID		= 0x0801,
+	WMI_ECHO_CMDID			= 0x0803,
+	WMI_DEEP_ECHO_CMDID		= 0x0804,
+	WMI_CONFIG_MAC_CMDID		= 0x0805,
+	WMI_CONFIG_PHY_DEBUG_CMDID	= 0x0806,
+	WMI_ADD_STATION_CMDID		= 0x0807,
+	WMI_ADD_DEBUG_TX_PCKT_CMDID	= 0x0808,
+	WMI_PHY_GET_STATISTICS_CMDID	= 0x0809,
+	WMI_FS_TUNE_CMDID		= 0x080a,
+	WMI_CORR_MEASURE_CMDID		= 0x080b,
+	WMI_TEMP_SENSE_CMDID		= 0x080e,
+	WMI_DC_CALIB_CMDID		= 0x080f,
+	WMI_SEND_TONE_CMDID		= 0x0810,
+	WMI_IQ_TX_CALIB_CMDID		= 0x0811,
+	WMI_IQ_RX_CALIB_CMDID		= 0x0812,
+	WMI_SET_UCODE_IDLE_CMDID	= 0x0813,
+	WMI_SET_WORK_MODE_CMDID		= 0x0815,
+	WMI_LO_LEAKAGE_CALIB_CMDID	= 0x0816,
+	WMI_MARLON_R_ACTIVATE_CMDID	= 0x0817,
+	WMI_MARLON_R_READ_CMDID		= 0x0818,
+	WMI_MARLON_R_WRITE_CMDID	= 0x0819,
+	WMI_MARLON_R_TXRX_SEL_CMDID	= 0x081a,
+	MAC_IO_STATIC_PARAMS_CMDID	= 0x081b,
+	MAC_IO_DYNAMIC_PARAMS_CMDID	= 0x081c,
+	WMI_SILENT_RSSI_CALIB_CMDID	= 0x081d,
+	WMI_CFG_RX_CHAIN_CMDID		= 0x0820,
+	WMI_VRING_CFG_CMDID		= 0x0821,
+	WMI_RX_ON_CMDID			= 0x0822,
+	WMI_VRING_BA_EN_CMDID		= 0x0823,
+	WMI_VRING_BA_DIS_CMDID		= 0x0824,
+	WMI_RCP_ADDBA_RESP_CMDID	= 0x0825,
+	WMI_RCP_DELBA_CMDID		= 0x0826,
+	WMI_SET_SSID_CMDID		= 0x0827,
+	WMI_GET_SSID_CMDID		= 0x0828,
+	WMI_SET_PCP_CHANNEL_CMDID	= 0x0829,
+	WMI_GET_PCP_CHANNEL_CMDID	= 0x082a,
+	WMI_SW_TX_REQ_CMDID		= 0x082b,
+	WMI_RX_OFF_CMDID		= 0x082c,
+	WMI_READ_MAC_RXQ_CMDID		= 0x0830,
+	WMI_READ_MAC_TXQ_CMDID		= 0x0831,
+	WMI_WRITE_MAC_RXQ_CMDID		= 0x0832,
+	WMI_WRITE_MAC_TXQ_CMDID		= 0x0833,
+	WMI_WRITE_MAC_XQ_FIELD_CMDID	= 0x0834,
+	WMI_MLME_PUSH_CMDID		= 0x0835,
+	WMI_BEAMFORMING_MGMT_CMDID	= 0x0836,
+	WMI_BF_TXSS_MGMT_CMDID		= 0x0837,
+	WMI_BF_SM_MGMT_CMDID		= 0x0838,
+	WMI_BF_RXSS_MGMT_CMDID		= 0x0839,
+	WMI_SET_SECTORS_CMDID		= 0x0849,
+	WMI_MAINTAIN_PAUSE_CMDID	= 0x0850,
+	WMI_MAINTAIN_RESUME_CMDID	= 0x0851,
+	WMI_RS_MGMT_CMDID		= 0x0852,
+	WMI_RF_MGMT_CMDID		= 0x0853,
+	/* Performance monitoring commands */
+	WMI_BF_CTRL_CMDID		= 0x0862,
+	WMI_NOTIFY_REQ_CMDID		= 0x0863,
+	WMI_GET_STATUS_CMDID		= 0x0864,
+	WMI_UNIT_TEST_CMDID		= 0x0900,
+	WMI_HICCUP_CMDID		= 0x0901,
+	WMI_FLASH_READ_CMDID		= 0x0902,
+	WMI_FLASH_WRITE_CMDID		= 0x0903,
+	WMI_SECURITY_UNIT_TEST_CMDID	= 0x0904,
+
+	WMI_SET_MAC_ADDRESS_CMDID	= 0xf003,
+	WMI_ABORT_SCAN_CMDID		= 0xf007,
+	WMI_SET_PMK_CMDID		= 0xf028,
+
+	WMI_SET_PROMISCUOUS_MODE_CMDID	= 0xf041,
+	WMI_GET_PMK_CMDID		= 0xf048,
+	WMI_SET_PASSPHRASE_CMDID	= 0xf049,
+	WMI_SEND_ASSOC_RES_CMDID	= 0xf04a,
+	WMI_SET_ASSOC_REQ_RELAY_CMDID	= 0xf04b,
+	WMI_EAPOL_TX_CMDID		= 0xf04c,
+	WMI_MAC_ADDR_REQ_CMDID		= 0xf04d,
+	WMI_FW_VER_CMDID		= 0xf04e,
+};
+
+/*
+ * Commands data structures
+ */
+
+/*
+ * Frame Types
+ */
+enum wmi_mgmt_frame_type {
+	WMI_FRAME_BEACON	= 0,
+	WMI_FRAME_PROBE_REQ	= 1,
+	WMI_FRAME_PROBE_RESP	= 2,
+	WMI_FRAME_ASSOC_REQ	= 3,
+	WMI_FRAME_ASSOC_RESP	= 4,
+	WMI_NUM_MGMT_FRAME,
+};
+
+/*
+ * WMI_CONNECT_CMDID
+ */
+enum wmi_network_type {
+	WMI_NETTYPE_INFRA		= 0x01,
+	WMI_NETTYPE_ADHOC		= 0x02,
+	WMI_NETTYPE_ADHOC_CREATOR	= 0x04,
+	WMI_NETTYPE_AP			= 0x10,
+	WMI_NETTYPE_P2P			= 0x20,
+	WMI_NETTYPE_WBE			= 0x40, /* PCIE over 60g */
+};
+
+enum wmi_dot11_auth_mode {
+	WMI_AUTH11_OPEN			= 0x01,
+	WMI_AUTH11_SHARED		= 0x02,
+	WMI_AUTH11_LEAP			= 0x04,
+	WMI_AUTH11_WSC			= 0x08,
+};
+
+enum wmi_auth_mode {
+	WMI_AUTH_NONE			= 0x01,
+	WMI_AUTH_WPA			= 0x02,
+	WMI_AUTH_WPA2			= 0x04,
+	WMI_AUTH_WPA_PSK		= 0x08,
+	WMI_AUTH_WPA2_PSK		= 0x10,
+	WMI_AUTH_WPA_CCKM		= 0x20,
+	WMI_AUTH_WPA2_CCKM		= 0x40,
+};
+
+enum wmi_crypto_type {
+	WMI_CRYPT_NONE			= 0x01,
+	WMI_CRYPT_WEP			= 0x02,
+	WMI_CRYPT_TKIP			= 0x04,
+	WMI_CRYPT_AES			= 0x08,
+	WMI_CRYPT_AES_GCMP		= 0x20,
+};
+
+
+enum wmi_connect_ctrl_flag_bits {
+	WMI_CONNECT_ASSOC_POLICY_USER		= 0x0001,
+	WMI_CONNECT_SEND_REASSOC		= 0x0002,
+	WMI_CONNECT_IGNORE_WPAx_GROUP_CIPHER	= 0x0004,
+	WMI_CONNECT_PROFILE_MATCH_DONE		= 0x0008,
+	WMI_CONNECT_IGNORE_AAC_BEACON		= 0x0010,
+	WMI_CONNECT_CSA_FOLLOW_BSS		= 0x0020,
+	WMI_CONNECT_DO_WPA_OFFLOAD		= 0x0040,
+	WMI_CONNECT_DO_NOT_DEAUTH		= 0x0080,
+};
+
+#define WMI_MAX_SSID_LEN    (32)
+
+struct wmi_connect_cmd {
+	u8 network_type;
+	u8 dot11_auth_mode;
+	u8 auth_mode;
+	u8 pairwise_crypto_type;
+	u8 pairwise_crypto_len;
+	u8 group_crypto_type;
+	u8 group_crypto_len;
+	u8 ssid_len;
+	u8 ssid[WMI_MAX_SSID_LEN];
+	u8 channel;
+	u8 reserved0;
+	u8 bssid[WMI_MAC_LEN];
+	__le32 ctrl_flags;
+	u8 dst_mac[WMI_MAC_LEN];
+	u8 reserved1[2];
+} __packed;
+
+
+/*
+ * WMI_RECONNECT_CMDID
+ */
+struct wmi_reconnect_cmd {
+	u8 channel;			/* hint */
+	u8 reserved;
+	u8 bssid[WMI_MAC_LEN];		/* mandatory if set */
+} __packed;
+
+
+/*
+ * WMI_SET_PMK_CMDID
+ */
+
+#define WMI_MIN_KEY_INDEX	(0)
+#define WMI_MAX_KEY_INDEX	(3)
+#define WMI_MAX_KEY_LEN		(32)
+#define WMI_PASSPHRASE_LEN	(64)
+#define WMI_PMK_LEN		(32)
+
+struct  wmi_set_pmk_cmd {
+	u8 pmk[WMI_PMK_LEN];
+} __packed;
+
+
+/*
+ * WMI_SET_PASSPHRASE_CMDID
+ */
+struct wmi_set_passphrase_cmd {
+	u8 ssid[WMI_MAX_SSID_LEN];
+	u8 passphrase[WMI_PASSPHRASE_LEN];
+	u8 ssid_len;
+	u8 passphrase_len;
+} __packed;
+
+/*
+ * WMI_ADD_CIPHER_KEY_CMDID
+ */
+enum wmi_key_usage {
+	WMI_KEY_USE_PAIRWISE	= 0,
+	WMI_KEY_USE_GROUP	= 1,
+	WMI_KEY_USE_TX		= 2,  /* default Tx Key - Static WEP only */
+};
+
+struct wmi_add_cipher_key_cmd {
+	u8 key_index;
+	u8 key_type;
+	u8 key_usage;		/* enum wmi_key_usage */
+	u8 key_len;
+	u8 key_rsc[8];		/* key replay sequence counter */
+	u8 key[WMI_MAX_KEY_LEN];
+	u8 key_op_ctrl;		/* Additional Key Control information */
+	u8 mac[WMI_MAC_LEN];
+} __packed;
+
+/*
+ * WMI_DELETE_CIPHER_KEY_CMDID
+ */
+struct wmi_delete_cipher_key_cmd {
+	u8 key_index;
+	u8 mac[WMI_MAC_LEN];
+} __packed;
+
+
+/*
+ * WMI_START_SCAN_CMDID
+ *
+ * Start L1 scan operation
+ *
+ * Returned events:
+ * - WMI_RX_MGMT_PACKET_EVENTID - for every probe resp.
+ * - WMI_SCAN_COMPLETE_EVENTID
+ */
+enum wmi_scan_type {
+	WMI_LONG_SCAN		= 0,
+	WMI_SHORT_SCAN		= 1,
+};
+
+struct wmi_start_scan_cmd {
+	u8 reserved[8];
+	__le32 home_dwell_time;	/* Max duration in the home channel(ms) */
+	__le32 force_scan_interval;	/* Time interval between scans (ms)*/
+	u8 scan_type;		/* wmi_scan_type */
+	u8 num_channels;		/* how many channels follow */
+	struct {
+		u8 channel;
+		u8 reserved;
+	} channel_list[0];	/* channels ID's */
+				/* 0 - 58320 MHz */
+				/* 1 - 60480 MHz */
+				/* 2 - 62640 MHz */
+} __packed;
+
+/*
+ * WMI_SET_PROBED_SSID_CMDID
+ */
+#define MAX_PROBED_SSID_INDEX   (15)
+
+enum wmi_ssid_flag {
+	WMI_SSID_FLAG_DISABLE	= 0,	/* disables entry */
+	WMI_SSID_FLAG_SPECIFIC	= 1,	/* probes specified ssid */
+	WMI_SSID_FLAG_ANY	= 2,	/* probes for any ssid */
+};
+
+struct wmi_probed_ssid_cmd {
+	u8 entry_index;			/* 0 to MAX_PROBED_SSID_INDEX */
+	u8 flag;			/* enum wmi_ssid_flag */
+	u8 ssid_len;
+	u8 ssid[WMI_MAX_SSID_LEN];
+} __packed;
+
+/*
+ * WMI_SET_APPIE_CMDID
+ * Add Application specified IE to a management frame
+ */
+struct wmi_set_appie_cmd {
+	u8 mgmt_frm_type;	/* enum wmi_mgmt_frame_type */
+	u8 reserved;
+	__le16 ie_len;	/* Length of the IE to be added to MGMT frame */
+	u8 ie_info[0];
+} __packed;
+
+#define WMI_MAX_IE_LEN (1024)
+
+struct wmi_pxmt_range_cfg_cmd {
+	u8 dst_mac[WMI_MAC_LEN];
+	__le16 range;
+} __packed;
+
+struct wmi_pxmt_snr2_range_cfg_cmd {
+	s8 snr2range_arr[WMI_PROX_RANGE_NUM-1];
+} __packed;
+
+/*
+ * WMI_RF_MGMT_CMDID
+ */
+enum wmi_rf_mgmt_type {
+	WMI_RF_MGMT_W_DISABLE	= 0,
+	WMI_RF_MGMT_W_ENABLE	= 1,
+	WMI_RF_MGMT_GET_STATUS	= 2,
+};
+
+struct wmi_rf_mgmt_cmd {
+	__le32 rf_mgmt_type;
+} __packed;
+
+/*
+ * WMI_SET_SSID_CMDID
+ */
+struct wmi_set_ssid_cmd {
+	__le32 ssid_len;
+	u8 ssid[WMI_MAX_SSID_LEN];
+} __packed;
+
+/*
+ * WMI_SET_PCP_CHANNEL_CMDID
+ */
+struct wmi_set_pcp_channel_cmd {
+	u8 channel;
+	u8 reserved[3];
+} __packed;
+
+/*
+ * WMI_BCON_CTRL_CMDID
+ */
+struct wmi_bcon_ctrl_cmd {
+	__le16 bcon_interval;
+	__le16 frag_num;
+	__le64 ss_mask;
+	u8 network_type;
+	u8 reserved;
+	u8 disable_sec_offload;
+	u8 disable_sec;
+} __packed;
+
+/*
+ * WMI_SW_TX_REQ_CMDID
+ */
+struct wmi_sw_tx_req_cmd {
+	u8 dst_mac[WMI_MAC_LEN];
+	__le16 len;
+	u8 payload[0];
+} __packed;
+
+/*
+ * WMI_VRING_CFG_CMDID
+ */
+
+struct wmi_sw_ring_cfg {
+	__le64 ring_mem_base;
+	__le16 ring_size;
+	__le16 max_mpdu_size;
+} __packed;
+
+struct wmi_vring_cfg_schd {
+	__le16 priority;
+	__le16 timeslot_us;
+} __packed;
+
+enum wmi_vring_cfg_encap_trans_type {
+	WMI_VRING_ENC_TYPE_802_3		= 0,
+	WMI_VRING_ENC_TYPE_NATIVE_WIFI		= 1,
+};
+
+enum wmi_vring_cfg_ds_cfg {
+	WMI_VRING_DS_PBSS			= 0,
+	WMI_VRING_DS_STATION			= 1,
+	WMI_VRING_DS_AP				= 2,
+	WMI_VRING_DS_ADDR4			= 3,
+};
+
+enum wmi_vring_cfg_nwifi_ds_trans_type {
+	WMI_NWIFI_TX_TRANS_MODE_NO		= 0,
+	WMI_NWIFI_TX_TRANS_MODE_AP2PBSS		= 1,
+	WMI_NWIFI_TX_TRANS_MODE_STA2PBSS	= 2,
+};
+
+enum wmi_vring_cfg_schd_params_priority {
+	WMI_SCH_PRIO_REGULAR			= 0,
+	WMI_SCH_PRIO_HIGH			= 1,
+};
+
+struct wmi_vring_cfg {
+	struct wmi_sw_ring_cfg tx_sw_ring;
+	u8 ringid;				/* 0-23 vrings */
+
+	#define CIDXTID_CID_POS (0)
+	#define CIDXTID_CID_LEN (4)
+	#define CIDXTID_CID_MSK (0xF)
+	#define CIDXTID_TID_POS (4)
+	#define CIDXTID_TID_LEN (4)
+	#define CIDXTID_TID_MSK (0xF0)
+	u8 cidxtid;
+
+	u8 encap_trans_type;
+	u8 ds_cfg;				/* 802.3 DS cfg */
+	u8 nwifi_ds_trans_type;
+
+	#define VRING_CFG_MAC_CTRL_LIFETIME_EN_POS (0)
+	#define VRING_CFG_MAC_CTRL_LIFETIME_EN_LEN (1)
+	#define VRING_CFG_MAC_CTRL_LIFETIME_EN_MSK (0x1)
+	#define VRING_CFG_MAC_CTRL_AGGR_EN_POS (1)
+	#define VRING_CFG_MAC_CTRL_AGGR_EN_LEN (1)
+	#define VRING_CFG_MAC_CTRL_AGGR_EN_MSK (0x2)
+	u8 mac_ctrl;
+
+	#define VRING_CFG_TO_RESOLUTION_VALUE_POS (0)
+	#define VRING_CFG_TO_RESOLUTION_VALUE_LEN (6)
+	#define VRING_CFG_TO_RESOLUTION_VALUE_MSK (0x3F)
+	u8 to_resolution;
+	u8 agg_max_wsize;
+	struct wmi_vring_cfg_schd schd_params;
+} __packed;
+
+enum wmi_vring_cfg_cmd_action {
+	WMI_VRING_CMD_ADD			= 0,
+	WMI_VRING_CMD_MODIFY			= 1,
+	WMI_VRING_CMD_DELETE			= 2,
+};
+
+struct wmi_vring_cfg_cmd {
+	__le32 action;
+	struct wmi_vring_cfg vring_cfg;
+} __packed;
+
+/*
+ * WMI_VRING_BA_EN_CMDID
+ */
+struct wmi_vring_ba_en_cmd {
+	u8 ringid;
+	u8 agg_max_wsize;
+	__le16 ba_timeout;
+} __packed;
+
+/*
+ * WMI_VRING_BA_DIS_CMDID
+ */
+struct wmi_vring_ba_dis_cmd {
+	u8 ringid;
+	u8 reserved;
+	__le16 reason;
+} __packed;
+
+/*
+ * WMI_NOTIFY_REQ_CMDID
+ */
+struct wmi_notify_req_cmd {
+	u8 cid;
+	u8 reserved[3];
+	__le32 interval_usec;
+} __packed;
+
+/*
+ * WMI_CFG_RX_CHAIN_CMDID
+ */
+enum wmi_sniffer_cfg_mode {
+	WMI_SNIFFER_OFF				= 0,
+	WMI_SNIFFER_ON				= 1,
+};
+
+enum wmi_sniffer_cfg_phy_info_mode {
+	WMI_SNIFFER_PHY_INFO_DISABLED		= 0,
+	WMI_SNIFFER_PHY_INFO_ENABLED		= 1,
+};
+
+enum wmi_sniffer_cfg_phy_support {
+	WMI_SNIFFER_CP				= 0,
+	WMI_SNIFFER_DP				= 1,
+	WMI_SNIFFER_BOTH_PHYS			= 2,
+};
+
+struct wmi_sniffer_cfg {
+	__le32 mode;		/* enum wmi_sniffer_cfg_mode */
+	__le32 phy_info_mode;	/* enum wmi_sniffer_cfg_phy_info_mode */
+	__le32 phy_support;	/* enum wmi_sniffer_cfg_phy_support */
+	u8 channel;
+	u8 reserved[3];
+} __packed;
+
+enum wmi_cfg_rx_chain_cmd_action {
+	WMI_RX_CHAIN_ADD			= 0,
+	WMI_RX_CHAIN_DEL			= 1,
+};
+
+enum wmi_cfg_rx_chain_cmd_decap_trans_type {
+	WMI_DECAP_TYPE_802_3			= 0,
+	WMI_DECAP_TYPE_NATIVE_WIFI		= 1,
+};
+
+enum wmi_cfg_rx_chain_cmd_nwifi_ds_trans_type {
+	WMI_NWIFI_RX_TRANS_MODE_NO		= 0,
+	WMI_NWIFI_RX_TRANS_MODE_PBSS2AP		= 1,
+	WMI_NWIFI_RX_TRANS_MODE_PBSS2STA	= 2,
+};
+
+struct wmi_cfg_rx_chain_cmd {
+	__le32 action;
+	struct wmi_sw_ring_cfg rx_sw_ring;
+	u8 mid;
+	u8 decap_trans_type;
+
+	#define L2_802_3_OFFLOAD_CTRL_VLAN_TAG_INSERTION_POS (0)
+	#define L2_802_3_OFFLOAD_CTRL_VLAN_TAG_INSERTION_LEN (1)
+	#define L2_802_3_OFFLOAD_CTRL_VLAN_TAG_INSERTION_MSK (0x1)
+	u8 l2_802_3_offload_ctrl;
+
+	#define L2_NWIFI_OFFLOAD_CTRL_REMOVE_QOS_POS (0)
+	#define L2_NWIFI_OFFLOAD_CTRL_REMOVE_QOS_LEN (1)
+	#define L2_NWIFI_OFFLOAD_CTRL_REMOVE_QOS_MSK (0x1)
+	#define L2_NWIFI_OFFLOAD_CTRL_REMOVE_PN_POS (1)
+	#define L2_NWIFI_OFFLOAD_CTRL_REMOVE_PN_LEN (1)
+	#define L2_NWIFI_OFFLOAD_CTRL_REMOVE_PN_MSK (0x2)
+	u8 l2_nwifi_offload_ctrl;
+
+	u8 vlan_id;
+	u8 nwifi_ds_trans_type;
+
+	#define L3_L4_CTRL_IPV4_CHECKSUM_EN_POS (0)
+	#define L3_L4_CTRL_IPV4_CHECKSUM_EN_LEN (1)
+	#define L3_L4_CTRL_IPV4_CHECKSUM_EN_MSK (0x1)
+	#define L3_L4_CTRL_TCPIP_CHECKSUM_EN_POS (1)
+	#define L3_L4_CTRL_TCPIP_CHECKSUM_EN_LEN (1)
+	#define L3_L4_CTRL_TCPIP_CHECKSUM_EN_MSK (0x2)
+	u8 l3_l4_ctrl;
+
+	#define RING_CTRL_OVERRIDE_PREFETCH_THRSH_POS (0)
+	#define RING_CTRL_OVERRIDE_PREFETCH_THRSH_LEN (1)
+	#define RING_CTRL_OVERRIDE_PREFETCH_THRSH_MSK (0x1)
+	#define RING_CTRL_OVERRIDE_WB_THRSH_POS (1)
+	#define RING_CTRL_OVERRIDE_WB_THRSH_LEN (1)
+	#define RING_CTRL_OVERRIDE_WB_THRSH_MSK (0x2)
+	#define RING_CTRL_OVERRIDE_ITR_THRSH_POS (2)
+	#define RING_CTRL_OVERRIDE_ITR_THRSH_LEN (1)
+	#define RING_CTRL_OVERRIDE_ITR_THRSH_MSK (0x4)
+	#define RING_CTRL_OVERRIDE_HOST_THRSH_POS (3)
+	#define RING_CTRL_OVERRIDE_HOST_THRSH_LEN (1)
+	#define RING_CTRL_OVERRIDE_HOST_THRSH_MSK (0x8)
+	u8 ring_ctrl;
+
+	__le16 prefetch_thrsh;
+	__le16 wb_thrsh;
+	__le32 itr_value;
+	__le16 host_thrsh;
+	u8 reserved[2];
+	struct wmi_sniffer_cfg sniffer_cfg;
+} __packed;
+
+/*
+ * WMI_RCP_ADDBA_RESP_CMDID
+ */
+struct wmi_rcp_addba_resp_cmd {
+
+	#define CIDXTID_CID_POS (0)
+	#define CIDXTID_CID_LEN (4)
+	#define CIDXTID_CID_MSK (0xF)
+	#define CIDXTID_TID_POS (4)
+	#define CIDXTID_TID_LEN (4)
+	#define CIDXTID_TID_MSK (0xF0)
+	u8 cidxtid;
+
+	u8 dialog_token;
+	__le16 status_code;
+	__le16 ba_param_set;	/* ieee80211_ba_parameterset field to send */
+	__le16 ba_timeout;
+} __packed;
+
+/*
+ * WMI_RCP_DELBA_CMDID
+ */
+struct wmi_rcp_delba_cmd {
+
+	#define CIDXTID_CID_POS (0)
+	#define CIDXTID_CID_LEN (4)
+	#define CIDXTID_CID_MSK (0xF)
+	#define CIDXTID_TID_POS (4)
+	#define CIDXTID_TID_LEN (4)
+	#define CIDXTID_TID_MSK (0xF0)
+	u8 cidxtid;
+
+	u8 reserved;
+	__le16 reason;
+} __packed;
+
+/*
+ * WMI_RCP_ADDBA_REQ_CMDID
+ */
+struct wmi_rcp_addba_req_cmd {
+
+	#define CIDXTID_CID_POS (0)
+	#define CIDXTID_CID_LEN (4)
+	#define CIDXTID_CID_MSK (0xF)
+	#define CIDXTID_TID_POS (4)
+	#define CIDXTID_TID_LEN (4)
+	#define CIDXTID_TID_MSK (0xF0)
+	u8 cidxtid;
+
+	u8 dialog_token;
+	/* ieee80211_ba_parameterset field as it received */
+	__le16 ba_param_set;
+	__le16 ba_timeout;
+	/* ieee80211_ba_seqstrl field as it received */
+	__le16 ba_seq_ctrl;
+} __packed;
+
+/*
+ * WMI_SET_MAC_ADDRESS_CMDID
+ */
+struct wmi_set_mac_address_cmd {
+	u8 mac[WMI_MAC_LEN];
+	u8 reserved[2];
+} __packed;
+
+
+/*
+* WMI_EAPOL_TX_CMDID
+*/
+struct wmi_eapol_tx_cmd {
+	u8 dst_mac[WMI_MAC_LEN];
+	__le16 eapol_len;
+	u8 eapol[0];
+} __packed;
+
+/*
+ * WMI_ECHO_CMDID
+ *
+ * Check FW is alive
+ *
+ * WMI_DEEP_ECHO_CMDID
+ *
+ * Check FW and ucode are alive
+ *
+ * Returned event: WMI_ECHO_RSP_EVENTID
+ * same event for both commands
+ */
+struct wmi_echo_cmd {
+	__le32 value;
+} __packed;
+
+/*
+ * WMI Events
+ */
+
+/*
+ * List of Events (target to host)
+ */
+enum wmi_event_id {
+	WMI_IMM_RSP_EVENTID			= 0x0000,
+	WMI_READY_EVENTID			= 0x1001,
+	WMI_CONNECT_EVENTID			= 0x1002,
+	WMI_DISCONNECT_EVENTID			= 0x1003,
+	WMI_SCAN_COMPLETE_EVENTID		= 0x100a,
+	WMI_REPORT_STATISTICS_EVENTID		= 0x100b,
+	WMI_RD_MEM_RSP_EVENTID			= 0x1800,
+	WMI_FW_READY_EVENTID			= 0x1801,
+	WMI_EXIT_FAST_MEM_ACC_MODE_EVENTID	= 0x0200,
+	WMI_ECHO_RSP_EVENTID			= 0x1803,
+	WMI_CONFIG_MAC_DONE_EVENTID		= 0x1805,
+	WMI_CONFIG_PHY_DEBUG_DONE_EVENTID	= 0x1806,
+	WMI_ADD_STATION_DONE_EVENTID		= 0x1807,
+	WMI_ADD_DEBUG_TX_PCKT_DONE_EVENTID	= 0x1808,
+	WMI_PHY_GET_STATISTICS_EVENTID		= 0x1809,
+	WMI_FS_TUNE_DONE_EVENTID		= 0x180a,
+	WMI_CORR_MEASURE_DONE_EVENTID		= 0x180b,
+	WMI_TEMP_SENSE_DONE_EVENTID		= 0x180e,
+	WMI_DC_CALIB_DONE_EVENTID		= 0x180f,
+	WMI_IQ_TX_CALIB_DONE_EVENTID		= 0x1811,
+	WMI_IQ_RX_CALIB_DONE_EVENTID		= 0x1812,
+	WMI_SET_WORK_MODE_DONE_EVENTID		= 0x1815,
+	WMI_LO_LEAKAGE_CALIB_DONE_EVENTID	= 0x1816,
+	WMI_MARLON_R_ACTIVATE_DONE_EVENTID	= 0x1817,
+	WMI_MARLON_R_READ_DONE_EVENTID		= 0x1818,
+	WMI_MARLON_R_WRITE_DONE_EVENTID		= 0x1819,
+	WMI_MARLON_R_TXRX_SEL_DONE_EVENTID	= 0x181a,
+	WMI_SILENT_RSSI_CALIB_DONE_EVENTID	= 0x181d,
+
+	WMI_CFG_RX_CHAIN_DONE_EVENTID		= 0x1820,
+	WMI_VRING_CFG_DONE_EVENTID		= 0x1821,
+	WMI_RX_ON_DONE_EVENTID			= 0x1822,
+	WMI_BA_STATUS_EVENTID			= 0x1823,
+	WMI_RCP_ADDBA_REQ_EVENTID		= 0x1824,
+	WMI_ADDBA_RESP_SENT_EVENTID		= 0x1825,
+	WMI_DELBA_EVENTID			= 0x1826,
+	WMI_GET_SSID_EVENTID			= 0x1828,
+	WMI_GET_PCP_CHANNEL_EVENTID		= 0x182a,
+	WMI_SW_TX_COMPLETE_EVENTID		= 0x182b,
+	WMI_RX_OFF_DONE_EVENTID			= 0x182c,
+
+	WMI_READ_MAC_RXQ_EVENTID		= 0x1830,
+	WMI_READ_MAC_TXQ_EVENTID		= 0x1831,
+	WMI_WRITE_MAC_RXQ_EVENTID		= 0x1832,
+	WMI_WRITE_MAC_TXQ_EVENTID		= 0x1833,
+	WMI_WRITE_MAC_XQ_FIELD_EVENTID		= 0x1834,
+
+	WMI_BEAFORMING_MGMT_DONE_EVENTID	= 0x1836,
+	WMI_BF_TXSS_MGMT_DONE_EVENTID		= 0x1837,
+	WMI_BF_RXSS_MGMT_DONE_EVENTID		= 0x1839,
+	WMI_RS_MGMT_DONE_EVENTID		= 0x1852,
+	WMI_RF_MGMT_STATUS_EVENTID		= 0x1853,
+	WMI_BF_SM_MGMT_DONE_EVENTID		= 0x1838,
+	WMI_RX_MGMT_PACKET_EVENTID		= 0x1840,
+
+	/* Performance monitoring events */
+	WMI_DATA_PORT_OPEN_EVENTID		= 0x1860,
+	WMI_WBE_LINKDOWN_EVENTID		= 0x1861,
+
+	WMI_BF_CTRL_DONE_EVENTID		= 0x1862,
+	WMI_NOTIFY_REQ_DONE_EVENTID		= 0x1863,
+	WMI_GET_STATUS_DONE_EVENTID		= 0x1864,
+
+	WMI_UNIT_TEST_EVENTID			= 0x1900,
+	WMI_FLASH_READ_DONE_EVENTID		= 0x1902,
+	WMI_FLASH_WRITE_DONE_EVENTID		= 0x1903,
+
+	WMI_SET_CHANNEL_EVENTID			= 0x9000,
+	WMI_ASSOC_REQ_EVENTID			= 0x9001,
+	WMI_EAPOL_RX_EVENTID			= 0x9002,
+	WMI_MAC_ADDR_RESP_EVENTID		= 0x9003,
+	WMI_FW_VER_EVENTID			= 0x9004,
+};
+
+/*
+ * Events data structures
+ */
+
+/*
+ * WMI_RF_MGMT_STATUS_EVENTID
+ */
+enum wmi_rf_status {
+	WMI_RF_ENABLED			= 0,
+	WMI_RF_DISABLED_HW		= 1,
+	WMI_RF_DISABLED_SW		= 2,
+	WMI_RF_DISABLED_HW_SW		= 3,
+};
+
+struct wmi_rf_mgmt_status_event {
+	__le32 rf_status;
+} __packed;
+
+/*
+ * WMI_GET_STATUS_DONE_EVENTID
+ */
+struct wmi_get_status_done_event {
+	__le32 is_associated;
+	u8 cid;
+	u8 reserved0[3];
+	u8 bssid[WMI_MAC_LEN];
+	u8 channel;
+	u8 reserved1;
+	u8 network_type;
+	u8 reserved2[3];
+	__le32 ssid_len;
+	u8 ssid[WMI_MAX_SSID_LEN];
+	__le32 rf_status;
+	__le32 is_secured;
+} __packed;
+
+/*
+ * WMI_FW_VER_EVENTID
+ */
+struct wmi_fw_ver_event {
+	u8 major;
+	u8 minor;
+	__le16 subminor;
+	__le16 build;
+} __packed;
+
+/*
+* WMI_MAC_ADDR_RESP_EVENTID
+*/
+struct wmi_mac_addr_resp_event {
+	u8 mac[WMI_MAC_LEN];
+	u8 auth_mode;
+	u8 crypt_mode;
+	__le32 offload_mode;
+} __packed;
+
+/*
+* WMI_EAPOL_RX_EVENTID
+*/
+struct wmi_eapol_rx_event {
+	u8 src_mac[WMI_MAC_LEN];
+	__le16 eapol_len;
+	u8 eapol[0];
+} __packed;
+
+/*
+* WMI_READY_EVENTID
+*/
+enum wmi_phy_capability {
+	WMI_11A_CAPABILITY		= 1,
+	WMI_11G_CAPABILITY		= 2,
+	WMI_11AG_CAPABILITY		= 3,
+	WMI_11NA_CAPABILITY		= 4,
+	WMI_11NG_CAPABILITY		= 5,
+	WMI_11NAG_CAPABILITY		= 6,
+	WMI_11AD_CAPABILITY		= 7,
+	WMI_11N_CAPABILITY_OFFSET = WMI_11NA_CAPABILITY - WMI_11A_CAPABILITY,
+};
+
+struct wmi_ready_event {
+	__le32 sw_version;
+	__le32 abi_version;
+	u8 mac[WMI_MAC_LEN];
+	u8 phy_capability;		/* enum wmi_phy_capability */
+	u8 reserved;
+} __packed;
+
+/*
+ * WMI_NOTIFY_REQ_DONE_EVENTID
+ */
+struct wmi_notify_req_done_event {
+	__le32 status;
+	__le64 tsf;
+	__le32 snr_val;
+	__le32 tx_tpt;
+	__le32 tx_goodput;
+	__le32 rx_goodput;
+	__le16 bf_mcs;
+	__le16 my_rx_sector;
+	__le16 my_tx_sector;
+	__le16 other_rx_sector;
+	__le16 other_tx_sector;
+	__le16 range;
+} __packed;
+
+/*
+ * WMI_CONNECT_EVENTID
+ */
+struct wmi_connect_event {
+	u8 channel;
+	u8 reserved0;
+	u8 bssid[WMI_MAC_LEN];
+	__le16 listen_interval;
+	__le16 beacon_interval;
+	u8 network_type;
+	u8 reserved1[3];
+	u8 beacon_ie_len;
+	u8 assoc_req_len;
+	u8 assoc_resp_len;
+	u8 cid;
+	u8 reserved2[3];
+	u8 assoc_info[0];
+} __packed;
+
+/*
+ * WMI_DISCONNECT_EVENTID
+ */
+enum wmi_disconnect_reason {
+	WMI_DIS_REASON_NO_NETWORK_AVAIL		= 1,
+	WMI_DIS_REASON_LOST_LINK		= 2, /* bmiss */
+	WMI_DIS_REASON_DISCONNECT_CMD		= 3,
+	WMI_DIS_REASON_BSS_DISCONNECTED		= 4,
+	WMI_DIS_REASON_AUTH_FAILED		= 5,
+	WMI_DIS_REASON_ASSOC_FAILED		= 6,
+	WMI_DIS_REASON_NO_RESOURCES_AVAIL	= 7,
+	WMI_DIS_REASON_CSERV_DISCONNECT		= 8,
+	WMI_DIS_REASON_INVALID_PROFILE		= 10,
+	WMI_DIS_REASON_DOT11H_CHANNEL_SWITCH	= 11,
+	WMI_DIS_REASON_PROFILE_MISMATCH		= 12,
+	WMI_DIS_REASON_CONNECTION_EVICTED	= 13,
+	WMI_DIS_REASON_IBSS_MERGE		= 14,
+};
+
+struct wmi_disconnect_event {
+	__le16 protocol_reason_status;	/* reason code, see 802.11 spec. */
+	u8 bssid[WMI_MAC_LEN];		/* set if known */
+	u8 disconnect_reason;		/* see wmi_disconnect_reason_e */
+	u8 assoc_resp_len;
+	u8 assoc_info[0];
+} __packed;
+
+/*
+ * WMI_SCAN_COMPLETE_EVENTID
+ */
+struct wmi_scan_complete_event {
+	__le32 status;
+} __packed;
+
+/*
+ * WMI_BA_STATUS_EVENTID
+ */
+enum wmi_vring_ba_status {
+	WMI_BA_AGREED			= 0,
+	WMI_BA_NON_AGREED		= 1,
+};
+
+struct wmi_vring_ba_status_event {
+	__le16 status;
+	u8 reserved[2];
+	u8 ringid;
+	u8 agg_wsize;
+	__le16 ba_timeout;
+} __packed;
+
+/*
+ * WMI_DELBA_EVENTID
+ */
+struct wmi_delba_event {
+
+	#define CIDXTID_CID_POS (0)
+	#define CIDXTID_CID_LEN (4)
+	#define CIDXTID_CID_MSK (0xF)
+	#define CIDXTID_TID_POS (4)
+	#define CIDXTID_TID_LEN (4)
+	#define CIDXTID_TID_MSK (0xF0)
+	u8 cidxtid;
+
+	u8 from_initiator;
+	__le16 reason;
+} __packed;
+
+/*
+ * WMI_VRING_CFG_DONE_EVENTID
+ */
+enum wmi_vring_cfg_done_event_status {
+	WMI_VRING_CFG_SUCCESS		= 0,
+	WMI_VRING_CFG_FAILURE		= 1,
+};
+
+struct wmi_vring_cfg_done_event {
+	u8 ringid;
+	u8 status;
+	u8 reserved[2];
+	__le32 tx_vring_tail_ptr;
+} __packed;
+
+/*
+ * WMI_ADDBA_RESP_SENT_EVENTID
+ */
+enum wmi_rcp_addba_resp_sent_event_status {
+	WMI_ADDBA_SUCCESS		= 0,
+	WMI_ADDBA_FAIL			= 1,
+};
+
+struct wmi_rcp_addba_resp_sent_event {
+
+	#define CIDXTID_CID_POS (0)
+	#define CIDXTID_CID_LEN (4)
+	#define CIDXTID_CID_MSK (0xF)
+	#define CIDXTID_TID_POS (4)
+	#define CIDXTID_TID_LEN (4)
+	#define CIDXTID_TID_MSK (0xF0)
+	u8 cidxtid;
+
+	u8 reserved;
+	__le16 status;
+} __packed;
+
+/*
+ * WMI_RCP_ADDBA_REQ_EVENTID
+ */
+struct wmi_rcp_addba_req_event {
+
+	#define CIDXTID_CID_POS (0)
+	#define CIDXTID_CID_LEN (4)
+	#define CIDXTID_CID_MSK (0xF)
+	#define CIDXTID_TID_POS (4)
+	#define CIDXTID_TID_LEN (4)
+	#define CIDXTID_TID_MSK (0xF0)
+	u8 cidxtid;
+
+	u8 dialog_token;
+	__le16 ba_param_set;	/* ieee80211_ba_parameterset as it received */
+	__le16 ba_timeout;
+	__le16 ba_seq_ctrl;	/* ieee80211_ba_seqstrl field as it received */
+} __packed;
+
+/*
+ * WMI_CFG_RX_CHAIN_DONE_EVENTID
+ */
+enum wmi_cfg_rx_chain_done_event_status {
+	WMI_CFG_RX_CHAIN_SUCCESS	= 1,
+};
+
+struct wmi_cfg_rx_chain_done_event {
+	__le32 rx_ring_tail_ptr;	/* Rx V-Ring Tail pointer */
+	__le32 status;
+} __packed;
+
+/*
+ * WMI_WBE_LINKDOWN_EVENTID
+ */
+enum wmi_wbe_link_down_event_reason {
+	WMI_WBE_REASON_USER_REQUEST	= 0,
+	WMI_WBE_REASON_RX_DISASSOC	= 1,
+	WMI_WBE_REASON_BAD_PHY_LINK	= 2,
+};
+
+struct wmi_wbe_link_down_event {
+	u8 cid;
+	u8 reserved[3];
+	__le32 reason;
+} __packed;
+
+/*
+ * WMI_DATA_PORT_OPEN_EVENTID
+ */
+struct wmi_data_port_open_event {
+	u8 cid;
+	u8 reserved[3];
+} __packed;
+
+/*
+ * WMI_GET_PCP_CHANNEL_EVENTID
+ */
+struct wmi_get_pcp_channel_event {
+	u8 channel;
+	u8 reserved[3];
+} __packed;
+
+/*
+ * WMI_SW_TX_COMPLETE_EVENTID
+ */
+enum wmi_sw_tx_status {
+	WMI_TX_SW_STATUS_SUCCESS		= 0,
+	WMI_TX_SW_STATUS_FAILED_NO_RESOURCES	= 1,
+	WMI_TX_SW_STATUS_FAILED_TX		= 2,
+};
+
+struct wmi_sw_tx_complete_event {
+	u8 status;	/* enum wmi_sw_tx_status */
+	u8 reserved[3];
+} __packed;
+
+/*
+ * WMI_GET_SSID_EVENTID
+ */
+struct wmi_get_ssid_event {
+	__le32 ssid_len;
+	u8 ssid[WMI_MAX_SSID_LEN];
+} __packed;
+
+/*
+ * WMI_RX_MGMT_PACKET_EVENTID
+ */
+struct wmi_rx_mgmt_info {
+	u8 mcs;
+	s8 snr;
+	__le16 range;
+	__le16 stype;
+	__le16 status;
+	__le32 len;
+	u8 qid;
+	u8 mid;
+	u8 cid;
+	u8 channel;	/* From Radio MNGR */
+} __packed;
+
+struct wmi_rx_mgmt_packet_event {
+	struct wmi_rx_mgmt_info info;
+	u8 payload[0];
+} __packed;
+
+/*
+ * WMI_ECHO_RSP_EVENTID
+ */
+struct wmi_echo_event {
+	__le32 echoed_value;
+} __packed;
+
+#endif /* __WILOCITY_WMI_H__ */
-- 
1.7.10.4


