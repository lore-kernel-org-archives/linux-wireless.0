Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48133 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab0H3Un2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 16:43:28 -0400
Received: by bwz11 with SMTP id 11so4012298bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 13:43:27 -0700 (PDT)
Received: from debian64.daheim
	([192.168.0.4] helo=debian64.localnet ident=chuck)
	by debian64.daheim with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <chunkeey@googlemail.com>)
	id 1OqBCP-0002lq-11
	for linux-wireless@vger.kernel.org; Mon, 30 Aug 2010 22:43:25 +0200
From: Christian Lamparter <chunkeey@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [RFT 0/6] carl9170usb: replacement driver for ar9170usb
Date: Mon, 30 Aug 2010 22:41:07 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201008302241.08030.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Atheros merged support for their USB AR9170 2-stream 802.11n chipsets
into the Linux kernel on the v2.6.29 release through a staging driver
called Otus. The shortcomings for this driver was it required its own
custom supplicant and obviously the code quality was sub-par. Shortly
after that Johannes Berg put a lot of effort into rewriting the driver
for proper upstream inclusion. I simply had to take what was already
there, add a few finishing touches to address upstream considerations
and we got it merged on the 2.6.30 release under the ar9170usb name.
During this time a lot of good work went into stabilizing the driver
to replace the staging Otus driver from Atheros. The project had
ambitious hopes to completely supersede the original Atheros staging
driver: Otus.

But to achieve this all functionality, performance, stability and
quality must have been equally matched. In the end this proved quite
challenging even though Atheros was kind enough to provide detailed
documentations, hardware specifications and most importantly, they
actually released the firmware source code under GPLv2!

It took months to dig through all the code and during this time the
ar9170usb driver project lost most of its momentum and changes to
the driver where limited to simple USB IDs updates, API fix-ups and
serious crash fixes. Towards the beginning of 2010 a new shiny driver:
carl9170usb started brewing with the main goal of replacing the
existing driver and making use of only open firmware.

It has been 1 year, 5 months, 9 days since this merge of ar9170usb
upstream and I am very pleased to announce and submit the carl9170
driver upstream which actually ends up not only replacing but
superseding the staging Otus driver.

The carl9170 driver comes with:

	* Supports High Throughput/802.11n up to PHY speeds
	  of 300Mbits (~ RL performance of max. 100Mbit/s tcp,
	  udp goes to 130 and beyond)

	* Access-Point mode for legacy stations and a
	  few improvements for IBSS.

	* multi-rate retry support. In order to improve throughput
	  and better link stability.

	* fully-automatic recovery from a number of
	  previously fatal events.

	* an input-device for the WPS push button, which
	  is present on some devices on the market.

	* pseudo virtual interfaces
	  (useful for universal repeater mode, or multiple APs)

	* facilities for debugging, testing and data dumping
	  within the driver (DebugFS), or in an isolated
	  userspace environment (carlu).

	* AES Offload in single AP and single Station mode.

	* and a few small bits:
		* firmware images are protected against:
			- the use with the wrong driver and vice versa
			- random/non-malicious corruptions

		* configurable firmware build, thanks to Kconfig
		  and cmake.

Upstream wireless-testing.git patch:
http://www.kernel.org/pub/linux/kernel/people/chr/carl9170/drv/1.8.8.1/carl9170-driver-1.8.8.1.diff

Firmware GPLv2 binary:
http://www.kernel.org/pub/linux/kernel/people/chr/carl9170/fw/1.8.8.1/carl9170-1.fw

Firmware source code:

http://git.kernel.org/?p=linux/kernel/git/chr/carl9170fw.git

The firmware source code comes with support for building the
toolchain. Requirements for building everything:

  * make 2.8+
  * bison
  * flex
  * gperf
  * libUSB 1.0+
  * libSDL 1.2+

For more details please see:

http://wireless.kernel.org/en/users/Drivers/carl9170 
(in the coming days, it's too dark to start now :-/ )

Christian Lamparter (6):
  carl9170usb: mac80211 glue and command interface
  carl9170usb: Hardware register, descriptors and eeprom definitions
  carl9170usb: PHY/RF and MAC routines
  carl9170usb: 802.11 rx/tx processing and usb back-end
  carl9170usb: firmware parser and debugfs code
  carl9170usb: Makefile, Kconfig files and MAINTAINERS

 MAINTAINERS                                  |    1 +
 drivers/net/wireless/ath/Kconfig             |    1 +
 drivers/net/wireless/ath/Makefile            |    1 +
 drivers/net/wireless/ath/carl9170/Kconfig    |   37 +
 drivers/net/wireless/ath/carl9170/Makefile   |    4 +
 drivers/net/wireless/ath/carl9170/carl9170.h |  597 ++++++++
 drivers/net/wireless/ath/carl9170/cmd.c      |  208 +++
 drivers/net/wireless/ath/carl9170/cmd.h      |  157 +++
 drivers/net/wireless/ath/carl9170/debug.c    |  908 +++++++++++++
 drivers/net/wireless/ath/carl9170/debug.h    |  135 ++
 drivers/net/wireless/ath/carl9170/eeprom.h   |  216 +++
 drivers/net/wireless/ath/carl9170/fw.c       |  397 ++++++
 drivers/net/wireless/ath/carl9170/fwcmd.h    |  268 ++++
 drivers/net/wireless/ath/carl9170/fwdesc.h   |  235 ++++
 drivers/net/wireless/ath/carl9170/hw.h       |  736 ++++++++++
 drivers/net/wireless/ath/carl9170/led.c      |  190 +++
 drivers/net/wireless/ath/carl9170/mac.c      |  611 +++++++++
 drivers/net/wireless/ath/carl9170/main.c     | 1873 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/carl9170/phy.c      | 1802 +++++++++++++++++++++++++
 drivers/net/wireless/ath/carl9170/phy.h      |  575 ++++++++
 drivers/net/wireless/ath/carl9170/rx.c       |  910 +++++++++++++
 drivers/net/wireless/ath/carl9170/tx.c       | 1370 +++++++++++++++++++
 drivers/net/wireless/ath/carl9170/usb.c      | 1143 ++++++++++++++++
 drivers/net/wireless/ath/carl9170/version.h  |    7 +
 drivers/net/wireless/ath/carl9170/wlan.h     |  412 ++++++
 25 files changed, 12794 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/carl9170/Kconfig
 create mode 100644 drivers/net/wireless/ath/carl9170/Makefile
 create mode 100644 drivers/net/wireless/ath/carl9170/carl9170.h
 create mode 100644 drivers/net/wireless/ath/carl9170/cmd.c
 create mode 100644 drivers/net/wireless/ath/carl9170/cmd.h
 create mode 100644 drivers/net/wireless/ath/carl9170/debug.c
 create mode 100644 drivers/net/wireless/ath/carl9170/debug.h
 create mode 100644 drivers/net/wireless/ath/carl9170/eeprom.h
 create mode 100644 drivers/net/wireless/ath/carl9170/fw.c
 create mode 100644 drivers/net/wireless/ath/carl9170/fwcmd.h
 create mode 100644 drivers/net/wireless/ath/carl9170/fwdesc.h
 create mode 100644 drivers/net/wireless/ath/carl9170/hw.h
 create mode 100644 drivers/net/wireless/ath/carl9170/led.c
 create mode 100644 drivers/net/wireless/ath/carl9170/mac.c
 create mode 100644 drivers/net/wireless/ath/carl9170/main.c
 create mode 100644 drivers/net/wireless/ath/carl9170/phy.c
 create mode 100644 drivers/net/wireless/ath/carl9170/phy.h
 create mode 100644 drivers/net/wireless/ath/carl9170/rx.c
 create mode 100644 drivers/net/wireless/ath/carl9170/tx.c
 create mode 100644 drivers/net/wireless/ath/carl9170/usb.c
 create mode 100644 drivers/net/wireless/ath/carl9170/version.h
 create mode 100644 drivers/net/wireless/ath/carl9170/wlan.h

(Text adapted from Luis)

Regards,
	Chr
