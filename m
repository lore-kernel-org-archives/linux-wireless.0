Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:52402 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764Ab2BDWme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Feb 2012 17:42:34 -0500
Received: by obcva7 with SMTP id va7so5563543obc.19
        for <linux-wireless@vger.kernel.org>; Sat, 04 Feb 2012 14:42:34 -0800 (PST)
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Sat, 4 Feb 2012 14:42:14 -0800
Message-ID: <CAObL_7E2eW9aqz3VLsBU-=4+kMXrfPvfz6wCNUEdDHuJWVaSLA@mail.gmail.com> (sfid-20120204_234238_548136_9F1CD9F9)
Subject: 6300agn: queue stuck and driver doesn't recover
To: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've recently started to notice wireless failures -- after being
connected for a few minutes, the connection dies.  Other devices on
the same network continue to work.  'iw dev wlan0 disconnect' will fix
it.

I'm not at all sure, but I think this is a 3.2 regression.  My kernel
is 3.2.2-1.fc16.x86_64.

My device reports as:

[    9.971111] iwlwifi 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    9.971121] iwlwifi 0000:03:00.0: setting latency timer to 64
[    9.971155] iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
[    9.971156] iwlwifi 0000:03:00.0: pci_resource_base = ffffc900050dc000
[    9.971158] iwlwifi 0000:03:00.0: HW Revision ID = 0x35
[    9.971256] iwlwifi 0000:03:00.0: irq 50 for MSI/MSI-X
[    9.971307] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
[    9.971309] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[    9.971310] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[    9.971312] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[    9.971313] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
[    9.971319] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R)
Ultimate-N 6300 AGN, REV=0x74
[    9.971373] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[    9.981946] iwlwifi 0000:03:00.0: device EEPROM VER=0x436, CALIB=0x6
[    9.981949] iwlwifi 0000:03:00.0: Device SKU: 0x1F0
[    9.981951] iwlwifi 0000:03:00.0: Valid Tx ant: 0x7, Valid Rx ant: 0x7
[    9.981982] iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 24
802.11a channels
[   10.119812] iwlwifi 0000:03:00.0: loaded firmware version 9.221.4.1
build 25532

and the failure and subsequent forced reconnect looks like:

[  659.272849] cfg80211: Calling CRDA for country: US
[  659.280937] cfg80211: Regulatory domain changed to country: US
[  659.280945] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  659.280952] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2700 mBm)
[  659.280957] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 1700 mBm)
[  659.280962] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  659.280968] cfg80211:   (5490000 KHz - 5600000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  659.280973] cfg80211:   (5650000 KHz - 5710000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  659.280977] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 3000 mBm)
[  659.372989] wlan0: moving STA xx:xx:xx:xx:xx:xx to state 3
[  682.786577] iwlwifi 0000:03:00.0: Tx aggregation enabled on ra =
xx:xx:xx:xx:xx:xx tid = 0
[  686.067870] iwlwifi 0000:03:00.0: Queue 12 stuck for 2000 ms.
[  686.067874] iwlwifi 0000:03:00.0: Current SW read_ptr 6 write_ptr 99
[  686.067907] iwlwifi 0000:03:00.0: Current HW read_ptr 6 write_ptr 99
[  686.067918] iwlwifi 0000:03:00.0: On demand firmware reload
[  686.068318] ieee80211 phy0: Hardware restart was requested
[  686.068385] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[  686.068521] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1

Most of the time, though, the connection dies with nothing printed to dmesg.
