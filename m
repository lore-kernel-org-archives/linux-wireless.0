Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:35199 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119Ab1HQIt2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 04:49:28 -0400
Received: by gxk10 with SMTP id 10so830089gxk.11
        for <linux-wireless@vger.kernel.org>; Wed, 17 Aug 2011 01:49:25 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 17 Aug 2011 11:49:23 +0300
Message-ID: <CAHiDVwn3zdvQVFYjxGwW0bAK+sz_BdWL+y==GjdaJZE-+R-GyQ@mail.gmail.com> (sfid-20110817_104931_925983_1580E4A7)
Subject: pull request v3: linux-firmware - ti-connectivity 2011-08-17
From: "Levi, Shahar" <shahar_levi@ti.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear David,
This is a pull request to update TI connectivity FW for
wl12xx-fw-3 (wl12xx driver).

The new wl12xx FW had some major api changes. The main
change was the addition of multi-role concept.
Due to changing NVS name add two new sl:
- wl12xx-nvs.bin that link on one of example NVS file (default wl127x-nvs.bin)
- wl1271-nvs.bin for backward compatible

This pull request includes and replaces the pull request I sent on
2011-07-11.

Please let me know if there are problems!

All the best,
Shahar
---

The following changes since commit 13f5008494268031d569f830d0955479bd5b9dfc:

  Merge git://anongit.freedesktop.org/~dcbw/linux-firmware (2011-07-31
00:15:37 +0100)

are available in the git repository at:

  git://github.com/shaharlevi/linux-firmware-ti-connectivity.git ti-connectivity

Shahar Levi (2):
      linux-firmware: wl12xx: Updated STA & AP FW for WL128x & wl127x
      linux-firmware: wl12xx: Updated STA & AP FW for wl12xx-fw-3

 WHENCE                                             |   32 ++++++++++++++-----
 ti-connectivity/wl1271-fw-2.bin                    |  Bin 273252 ->
273880 bytes
 ti-connectivity/wl1271-fw-ap.bin                   |  Bin 272784 ->
272836 bytes
 ti-connectivity/wl1271-nvs.bin                     |  Bin 912 -> 14 bytes
 ti-connectivity/wl127x-fw-3.bin                    |  Bin 0 -> 280388 bytes
 ti-connectivity/wl127x-fw-plt-3.bin                |  Bin 0 -> 267496 bytes
 ti-connectivity/wl127x-nvs.bin                     |  Bin 0 -> 912 bytes
 ti-connectivity/wl128x-fw-3.bin                    |  Bin 0 -> 284784 bytes
 ti-connectivity/wl128x-fw-ap.bin                   |  Bin 265196 ->
265460 bytes
 ti-connectivity/wl128x-fw-plt-3.bin                |  Bin 0 -> 271932 bytes
 ti-connectivity/wl128x-fw.bin                      |  Bin 272748 ->
273324 bytes
 ...l1271-nvs-example-wl128x.bin => wl128x-nvs.bin} |  Bin 1113 -> 1113 bytes
 ti-connectivity/wl12xx-nvs.bin                     |    1 +
 13 files changed, 24 insertions(+), 9 deletions(-)
 mode change 100644 => 120000 ti-connectivity/wl1271-nvs.bin
 create mode 100644 ti-connectivity/wl127x-fw-3.bin
 create mode 100644 ti-connectivity/wl127x-fw-plt-3.bin
 create mode 100644 ti-connectivity/wl127x-nvs.bin
 create mode 100644 ti-connectivity/wl128x-fw-3.bin
 create mode 100644 ti-connectivity/wl128x-fw-plt-3.bin
 mode change 100755 => 100644 ti-connectivity/wl128x-fw.bin
 rename ti-connectivity/{wl1271-nvs-example-wl128x.bin => wl128x-nvs.bin} (100%)
 mode change 100755 => 100644
 create mode 120000 ti-connectivity/wl12xx-nvs.bin

diff --git a/WHENCE b/WHENCE
index 4b88f1f..e55cb66 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1521,19 +1521,32 @@ Driver: wl12xx - Texas Instruments 802.11
wireless LAN driver

 File: wl1271-fw.bin
 File: wl1271-fw-2.bin
-File: wl128x-fw.bin
 File: wl1271-fw-ap.bin
+File: wl127x-fw-3.bin
+File: wl127x-fw-plt-3.bin
+
+File: wl128x-fw.bin
 File: wl128x-fw-ap.bin
-File: wl1271-nvs-example-wl127x.bin
-File: wl1271-nvs-example-wl128x.bin
+File: wl128x-fw-3.bin
+File: wl128x-fw-plt-3.bin
+
+File: wl127x-nvs.bin
+File: wl128x-nvs.bin
+sl:   wl12xx-nvs.bin -> wl127x-nvs.bin
+sl:   wl1271-nvs.bin -> wl127x-nvs.bin
+

 Licence: See LICENCE.ti-connectivity for details.

     Station:      wl1271-fw.bin version 6.1.0.50.350
-    Station:      wl1271-fw-2.bin version 6.1.3.50.58
-    Station:      wl128x-fw.bin version 7.1.3.50.58
-    Access Point: wl1271-fw-ap.bin version 6.2.0.0.47
-    Access Point: wl128x-fw-ap.bin version 7.2.0.0.47
+    Station:      wl1271-fw-2.bin version 6.1.5.50.74
+    Station:      wl128x-fw.bin version 7.1.5.50.74
+    Access Point: wl1271-fw-ap.bin version 6.2.1.0.54
+    Access Point: wl128x-fw-ap.bin version 7.2.1.0.54
+    Station & Access Point: wl127x-fw-3.bin version Rev 6.3.0.0.77
+    PLT:             wl127x-fw-3.bin version PLT 6.3.0.0.77
+    Station & Access Point: wl128x-fw-3.bin version Rev 7.3.0.0.77
+    PLT:            wl128x-fw-3.bin version PLT 7.3.0.0.77

 The nvs file includes two parts:
      - radio calibration
@@ -1543,10 +1556,11 @@ In order to have correct NVS file for your
device NVS tool should be use:
 http://linuxwireless.org/en/users/Drivers/wl12xx/calibrator

 Example NVS files (not optimal) for wl127x and wl128x includes.
-To use example NVS rename one of them to wl1271-nvs.bin
+To use example NVS set symbolic link wl12xx-nvs.bin to one of
+them (depending the chip on the platform)

 In order to use that files copy ti-connectivity directory to target FS at
-/lib/firmware/.
+/lib/firmware/ti-connectivity/.

 --------------------------------------------------------------------------

diff --git a/ti-connectivity/wl1271-fw-2.bin b/ti-connectivity/wl1271-fw-2.bin
index 8d18611..a01324e 100644
Binary files a/ti-connectivity/wl1271-fw-2.bin and
b/ti-connectivity/wl1271-fw-2.bin differ
diff --git a/ti-connectivity/wl1271-fw-ap.bin b/ti-connectivity/wl1271-fw-ap.bin
index c145a71..3a8e570 100644
Binary files a/ti-connectivity/wl1271-fw-ap.bin and
b/ti-connectivity/wl1271-fw-ap.bin differ
diff --git a/ti-connectivity/wl1271-nvs.bin b/ti-connectivity/wl1271-nvs.bin
deleted file mode 100644
index 91978f9..0000000
Binary files a/ti-connectivity/wl1271-nvs.bin and /dev/null differ
diff --git a/ti-connectivity/wl1271-nvs.bin b/ti-connectivity/wl1271-nvs.bin
new file mode 120000
index 0000000..a30a076
--- /dev/null
+++ b/ti-connectivity/wl1271-nvs.bin
@@ -0,0 +1 @@
+wl127x-nvs.bin
\ No newline at end of file
diff --git a/ti-connectivity/wl127x-fw-3.bin b/ti-connectivity/wl127x-fw-3.bin
new file mode 100644
index 0000000..d2bd1b5
Binary files /dev/null and b/ti-connectivity/wl127x-fw-3.bin differ
diff --git a/ti-connectivity/wl127x-fw-plt-3.bin
b/ti-connectivity/wl127x-fw-plt-3.bin
new file mode 100644
index 0000000..76fc71a
Binary files /dev/null and b/ti-connectivity/wl127x-fw-plt-3.bin differ
diff --git a/ti-connectivity/wl127x-nvs.bin b/ti-connectivity/wl127x-nvs.bin
new file mode 100644
index 0000000..91978f9
Binary files /dev/null and b/ti-connectivity/wl127x-nvs.bin differ
diff --git a/ti-connectivity/wl128x-fw-3.bin b/ti-connectivity/wl128x-fw-3.bin
new file mode 100644
index 0000000..831acc7
Binary files /dev/null and b/ti-connectivity/wl128x-fw-3.bin differ
diff --git a/ti-connectivity/wl128x-fw-ap.bin b/ti-connectivity/wl128x-fw-ap.bin
index 51d307b..3795717 100644
Binary files a/ti-connectivity/wl128x-fw-ap.bin and
b/ti-connectivity/wl128x-fw-ap.bin differ
diff --git a/ti-connectivity/wl128x-fw-plt-3.bin
b/ti-connectivity/wl128x-fw-plt-3.bin
new file mode 100644
index 0000000..e21b825
Binary files /dev/null and b/ti-connectivity/wl128x-fw-plt-3.bin differ
diff --git a/ti-connectivity/wl128x-fw.bin b/ti-connectivity/wl128x-fw.bin
old mode 100755
new mode 100644
index bf5344f..0fbf626
Binary files a/ti-connectivity/wl128x-fw.bin and
b/ti-connectivity/wl128x-fw.bin differ
diff --git a/ti-connectivity/wl12xx-nvs.bin b/ti-connectivity/wl12xx-nvs.bin
new file mode 120000
index 0000000..a30a076
--- /dev/null
+++ b/ti-connectivity/wl12xx-nvs.bin
@@ -0,0 +1 @@
+wl127x-nvs.bin
\ No newline at end of file
