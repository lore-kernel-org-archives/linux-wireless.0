Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:35025 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbbEJU4O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 May 2015 16:56:14 -0400
Received: by oign205 with SMTP id n205so91312393oig.2
        for <linux-wireless@vger.kernel.org>; Sun, 10 May 2015 13:56:13 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 10 May 2015 16:56:13 -0400
Message-ID: <CAJa-X95EBdGASnz3KAdYz5R6w5g-a=dBy5VCZYwHp6SzQ+gUSw@mail.gmail.com> (sfid-20150510_225826_818266_B1B4230D)
Subject: Ath10 firmware crashing in Monitor mode(Sniffer mode)
From: s prasad <sprasad.kandregula@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

When we are trying to send De-authentication  packets using
aireplay-ng(aircrack tools) firmware getting crashed in sniffer mode.

Kernel: "3.18.1"
Drivers: "compat-wireless-2015-03-09"

Please find given below logs:

[791495.150000] ath10k_pci: Unknown symbol ath10k_warn (err 0)
[791495.160000] ath10k_pci: Unknown symbol ath10k_err (err 0)
[791495.170000] ath10k_pci: Unknown symbol ath10k_print_driver_info (err 0)
[791495.170000] ath10k_pci: Unknown symbol
ath10k_debug_get_new_fw_crash_data (err 0)
[791495.180000] ath10k_pci: Unknown symbol ath10k_core_create (err 0)
[791495.190000] ath10k_pci: Unknown symbol ath10k_core_destroy (err 0)
[791495.190000] ath10k_pci: Unknown symbol ath10k_core_register (err 0)
[791495.200000] ath10k_pci: Unknown symbol ath10k_info (err 0)
[791495.210000] ath10k_pci: Unknown symbol ath10k_core_unregister (err 0)
[791504.600000] ath10k_pci 0000:01:00.0: pci irq legacy interrupts 0
irq_mode 0 reset_mode 0
[791504.820000] ath10k_pci 0000:01:00.0: Direct firmware load for
ath10k/cal-pci-0000:01:00.0.bin failed with error -2
[791504.830000] ath10k_pci 0000:01:00.0: Falling back to user helper
[791504.900000] firmware ath10k!cal-pci-0000:01:00.0.bin:
firmware_loading_store: map pages failed
[791505.060000] ath10k_pci 0000:01:00.0: otp stream is empty, using
board.bin contents
[791505.910000] ath10k_pci 0000:01:00.0: qca988x hw2.0 (0x4100016c,
0x043202ff) fw 10.1.467.2-1 api 4 htt 2.1 wmi 2 cal otp max_sta 128
[791505.920000] ath10k_pci 0000:01:00.0: debug 0 debugfs 1 tracing 0
dfs 1 testmode 1
[791506.030000] ath: EEPROM regdomain: 0x0
[791506.030000] ath: EEPROM indicates default country code should be used
[791506.030000] ath: doing EEPROM country->regdmn map search
[791506.030000] ath: country maps to regdmn code: 0x3a
[791506.030000] ath: Country alpha2 being used: US
[791506.030000] ath: Regpair used: 0x3a
[791551.530000] ath10k_pci 0000:01:00.0: otp stream is empty, using
board.bin contents
[791718.130000] device wlan1 entered promiscuous mode
[791718.340000] ath10k_pci 0000:01:00.0: firmware crashed! (uuid
b4593209-111f-446c-a134-120ce3b2e37d)
[791718.350000] ath10k_pci 0000:01:00.0: qca988x hw2.0 (0x4100016c,
0x043202ff) fw 10.1.467.2-1 api 4 htt 2.1 wmi 2 cal otp max_sta 128
[791718.360000] ath10k_pci 0000:01:00.0: debug 0 debugfs 1 tracing 0
dfs 1 testmode 1
[791718.370000] ath10k_pci 0000:01:00.0: firmware register dump:
[791718.380000] ath10k_pci 0000:01:00.0: [00]: 0x4100016C 0x000015B3
0x0099A132 0x00955B31
[791718.380000] ath10k_pci 0000:01:00.0: [04]: 0x0099A132 0x00060730
0x0000001E 0x00000005
[791718.390000] ath10k_pci 0000:01:00.0: [08]: 0x0043DD84 0x00000000
0x004159AC 0x00002D00
[791718.400000] ath10k_pci 0000:01:00.0: [12]: 0x00000009 0x00000004
0x00958018 0x00958027
[791718.410000] ath10k_pci 0000:01:00.0: [16]: 0x00958080 0x0094085D
0x00000000 0x00000000
[791718.420000] ath10k_pci 0000:01:00.0: [20]: 0x4099A132 0x0040AD14
0x00400000 0x4987F39C
[791718.420000] ath10k_pci 0000:01:00.0: [24]: 0x8099A22E 0x0040AD74
0x00000001 0xC099A132
[791718.430000] ath10k_pci 0000:01:00.0: [28]: 0x809AB96B 0x0040AD94
0x0043DD84 0x00000002
[791718.440000] ath10k_pci 0000:01:00.0: [32]: 0x809A80FA 0x0040ADD4
0x00400000 0x004159AC
[791718.450000] ath10k_pci 0000:01:00.0: [36]: 0x809A7885 0x0040AE24
0x0040AE48 0x0041116C
[791718.460000] ath10k_pci 0000:01:00.0: [40]: 0x809486FA 0x0040AE44
0x00000001 0x00000000
[791718.470000] ath10k_pci 0000:01:00.0: [44]: 0x80948E2C 0x0040AEA4
0x0041D728 0x00411778
[791718.470000] ath10k_pci 0000:01:00.0: [48]: 0x80942EB3 0x0040AEC4
0x0041D728 0x00000001
[791718.480000] ath10k_pci 0000:01:00.0: [52]: 0x80940F18 0x0040AF14
0x00000010 0x00403AC0
[791718.490000] ath10k_pci 0000:01:00.0: [56]: 0x80940EEA 0x0040AF44
0x00400000 0x00000000
[791718.600000] ieee80211 phy3: Hardware restart was requested
[791718.600000] ath10k_pci 0000:01:00.0: failed to to request monitor
vdev 0 stop: -143
[791718.610000] ath10k_pci 0000:01:00.0: failed to synchronize monitor
vdev 0 stop: -143
[791718.620000] ath10k_pci 0000:01:00.0: failed to stop monitor vdev: -143
[791718.970000] ath10k_pci 0000:01:00.0: otp stream is empty, using
board.bin contents
[791719.820000] ath10k_pci 0000:01:00.0: device successfully recovered
[791719.900000] ath10k_pci 0000:01:00.0: firmware crashed! (uuid
7c004867-7f8c-411f-83a8-b4aa69da1ee8)
[791719.910000] ath10k_pci 0000:01:00.0: qca988x hw2.0 (0x4100016c,
0x043202ff) fw 10.1.467.2-1 api 4 htt 2.1 wmi 2 cal otp max_sta 128
[791719.920000] ath10k_pci 0000:01:00.0: debug 0 debugfs 1 tracing 0
dfs 1 testmode 1
[791719.930000] ath10k_pci 0000:01:00.0: firmware register dump:
[791719.930000] ath10k_pci 0000:01:00.0: [00]: 0x4100016C 0x000015B3
0x0099A132 0x00955B31
[791719.940000] ath10k_pci 0000:01:00.0: [04]: 0x0099A132 0x00060730
0x0000001E 0x00000005
[791719.950000] ath10k_pci 0000:01:00.0: [08]: 0x0043DD84 0x00000000
0x004159AC 0x00002D00
[791719.960000] ath10k_pci 0000:01:00.0: [12]: 0x00000009 0x00000004
0x00958018 0x00958027
[791719.970000] ath10k_pci 0000:01:00.0: [16]: 0x00958080 0x0094085D
0x00000000 0x00000000
[791719.970000] ath10k_pci 0000:01:00.0: [20]: 0x4099A132 0x0040AD14
0x00400000 0xDF7BC310
[791719.980000] ath10k_pci 0000:01:00.0: [24]: 0x8099A22E 0x0040AD74
0x00000001 0xC099A132
[791719.990000] ath10k_pci 0000:01:00.0: [28]: 0x809AB96B 0x0040AD94
0x0043DD84 0x00000002
[791720.000000] ath10k_pci 0000:01:00.0: [32]: 0x809A80FA 0x0040ADD4
0x00400000 0x004159AC
[791720.010000] ath10k_pci 0000:01:00.0: [36]: 0x809A7885 0x0040AE24
0x0040AE48 0x0041116C
[791720.010000] ath10k_pci 0000:01:00.0: [40]: 0x809486FA 0x0040AE44
0x00000001 0x00000000
[791720.020000] ath10k_pci 0000:01:00.0: [44]: 0x80948E2C 0x0040AEA4
0x0041D728 0x00411778
[791720.030000] ath10k_pci 0000:01:00.0: [48]: 0x80942EB3 0x0040AEC4
0x0041D728 0x00000001
[791720.040000] ath10k_pci 0000:01:00.0: [52]: 0x80940F18 0x0040AF14
0x00000010 0x00403AC0
[791720.050000] ath10k_pci 0000:01:00.0: [56]: 0x80940EEA 0x0040AF44
0x00400000 0x00000000
[791723.140000] ath10k_pci 0000:01:00.0: failed to transmit management
frame via WMI: -143
[791723.240000] ieee80211 phy3: Hardware restart was requested
[791723.240000] ath10k_pci 0000:01:00.0: failed to put down monitor vdev 0: -143
[791723.250000] ath10k_pci 0000:01:00.0: failed to to request monitor
vdev 0 stop: -143
[791723.260000] ath10k_pci 0000:01:00.0: failed to synchronize monitor
vdev 0 stop: -143
[791723.260000] ath10k_pci 0000:01:00.0: failed to stop monitor vdev: -143
[791723.620000] ath10k_pci 0000:01:00.0: otp stream is empty, using
board.bin contents
[791724.470000] ath10k_pci 0000:01:00.0: device successfully recovered
[791724.580000] ath10k_pci 0000:01:00.0: firmware crashed! (uuid
521f6876-093d-4741-a3c4-33bc85470260)
[791724.590000] ath10k_pci 0000:01:00.0: qca988x hw2.0 (0x4100016c,
0x043202ff) fw 10.1.467.2-1 api 4 htt 2.1 wmi 2 cal otp max_sta 128
[791724.600000] ath10k_pci 0000:01:00.0: debug 0 debugfs 1 tracing 0
dfs 1 testmode 1
[791724.610000] ath10k_pci 0000:01:00.0: firmware register dump:
[791724.620000] ath10k_pci 0000:01:00.0: [00]: 0x4100016C 0x000015B3
0x0099A132 0x00955B31
[791724.630000] ath10k_pci 0000:01:00.0: [04]: 0x0099A132 0x00060730
0x0000001E 0x00000005
[791724.640000] ath10k_pci 0000:01:00.0: [08]: 0x0043DD84 0x00000000
0x004159AC 0x00002D00
[791724.640000] ath10k_pci 0000:01:00.0: [12]: 0x00000009 0x00000004
0x00958018 0x00958027
[791724.650000] ath10k_pci 0000:01:00.0: [16]: 0x00958080 0x0094085D
0x00000000 0x00000000
[791724.660000] ath10k_pci 0000:01:00.0: [20]: 0x4099A132 0x0040AD14
0x00400000 0x4987F39C
[791724.670000] ath10k_pci 0000:01:00.0: [24]: 0x8099A22E 0x0040AD74
0x00000001 0xC099A132
[791724.680000] ath10k_pci 0000:01:00.0: [28]: 0x809AB96B 0x0040AD94
0x0043DD84 0x00000002
[791724.680000] ath10k_pci 0000:01:00.0: [32]: 0x809A80FA 0x0040ADD4
0x00400000 0x004159AC
[791724.690000] ath10k_pci 0000:01:00.0: [36]: 0x809A7885 0x0040AE24
0x0040AE48 0x0041116C
[791724.700000] ath10k_pci 0000:01:00.0: [40]: 0x809486FA 0x0040AE44
0x00000001 0x00000000
[791724.710000] ath10k_pci 0000:01:00.0: [44]: 0x80948E2C 0x0040AEA4
0x0041D728 0x00411778
[791724.720000] ath10k_pci 0000:01:00.0: [48]: 0x80942EB3 0x0040AEC4
0x0041D728 0x00000001
[791724.720000] ath10k_pci 0000:01:00.0: [52]: 0x80940F18 0x0040AF14
0x00000010 0x00403AC0
[791724.730000] ath10k_pci 0000:01:00.0: [56]: 0x80940EEA 0x0040AF44
0x00400000 0x00000000
[791732.500000] ath10k_pci 0000:01:00.0: failed to transmit management
frame via WMI: -143
[791732.600000] ieee80211 phy3: Hardware restart was requested
[791732.600000] ath10k_pci 0000:01:00.0: failed to put down monitor vdev 0: -143
[791732.610000] ath10k_pci 0000:01:00.0: failed to to request monitor
vdev 0 stop: -143
[791733.020000] ath10k_warn: 2 callbacks suppressed
[791733.020000] ath10k_pci 0000:01:00.0: otp stream is empty, using
board.bin contents
[791733.880000] ath10k_pci 0000:01:00.0: device successfully recovered



Please let me know if any further information required.
