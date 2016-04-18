Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:36583 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbcDRTsz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 15:48:55 -0400
Received: by mail-qg0-f51.google.com with SMTP id f52so124599243qga.3
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2016 12:48:54 -0700 (PDT)
From: Geoff Lansberry <geoff@kuvee.com>
To: linux-wireless@vger.kernel.org
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, mgreer@animalcreek.com, justin@kuvee.com
Subject: [Patch] NFC: trf7970a: 
Date: Mon, 18 Apr 2016 15:48:37 -0400
Message-Id: <1461008921-15100-1-git-send-email-geoff@kuvee.com> (sfid-20160418_214859_396429_71163968)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current version of the trf7970a driver is missing support for several features that we needed to operate a custom board. 
We feel that these features will be useful to others as well, and we want to share them.

1: Support for using a gpio as Slave-Select. Our processor has several devices on the spi bus, and we ran out of ss lines.  This patch gives TRF7970A the ability to
 drive the ss line of the chip from a gpio that is defined in the device tree.

2. When reviewing problems we were having in our implementation with TI support staff, they recommended that during initialization, address 0x18 should be written to zero.  This patch adds that change

3. This existing version of the driver assumes that the crystal driving the trf7970a is 13.56 MHz, because there are several places in the driver code where the rel
ated register is re-written, there is clean way to change to 27.12 MHz.  This patch adds a device tree option for 27 MHz and properly or's in changes in locations w
here the register is changed.

4. the existing version of the driver assumes that 3.3 volt io is used. The trf7970a has a special register where you can configure it for 1.8 volt io.  This patch
adds a device tree option to select that this setting should be made.

 [PATCH 1/4] NFC: trf7970a: Add support for gpio as SS
 [PATCH 2/4] NFC: trf7970a: add TI recommended write of zero to
 [PATCH 3/4] NFC: trf7970a: add device tree option for 27MHz clock
 [PATCH 4/4] NFC: trf7970a: Add device tree option of 1.8 Volt IO
