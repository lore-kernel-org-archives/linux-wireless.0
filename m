Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33923 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab0JBL5S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 07:57:18 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-mmc@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Cc: Chris Ball <cjb@laptop.org>, Nicolas Pitre <nico@fluxnic.net>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 00/11] SDIO Runtime PM Support
Date: Sat,  2 Oct 2010 13:54:04 +0200
Message-Id: <1286020455-28946-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce SDIO runtime PM support:

1. Power to SDIO cards is kept low until one of its functions is bound
   (i.e. a matching driver is successfully probed)

2. If the matching driver supports runtime PM, power to the card is
   dropped soon after probe() returns. It is then up to the driver
   to request power to its function, using runtime PM API (the get/put
   variants). This is demonstrated with the wl1271 driver, in which
   the power of the card power is coupled with the state of the wlan
   interface (interface up -> power is up, interface down -> power is down)

3. If a matching driver does not support runtime PM, power to the card
   is kept high during the whole lifetime of the driver

4. When the driver is removed, power to the card is immediately dropped

5. If there are multiple drivers for the same card (several SDIO functions),
   power will be pulled high before the first driver probes, and dropped
   down after the last driver is removed. In between, power will be
   maintained accrording to the accumulated usage count of the complete
   drivers group

6. SDIO suspend/resume semantics are unchanged. In addition, when the system
   comes out of suspend, it is guaranteed that the power state of the
   SDIO card will reflect its runtime PM usage count.

7. What was NOT changed:
   - Interface: drivers can still assume that the card is powered
     when probe/remove/suspend/resume are called
   - Existing behavior: drivers that do not support runtime PM
     are unchanged

Changes since v1:
- Interaction with system suspend/resume
- Better commentary

Dependencies:
- SDIO patches are against mmc-next, and have a runtime dependency on
  commit "PM / Runtime: Lenient generic runtime pm callbacks"
  (patch is in linux-next now)
- WLAN patches depend on recent wl1271 activity, and they are here
  just to demonstrate the usage of the SDIO patchset (will be
  resubmitted separately)

The full patchset, together with all its dependencies, is also available at:
git://wizery.com/pub/mmc.git runtime-pm-v2

Tests:
Besides the usual functional tests, the patchset was stress tested with
an overnight execution of (thousands of suspend-to-rams interacting with
the different possible runtime PM power states of the device/driver):

#!/bin/sh
mount -t debugfs none /sys/kernel/debug
echo core > /sys/power/pm_test

validate_module_up()
{
	lsmod | grep wl1271_sdio
	if [ "$?" -ne 0 ]; then echo "Module is not up"; exit; fi
}

validate_module_down()
{
	lsmod | grep wl1271_sdio
	if [ "$?" -eq 0 ]; then echo "Module is not down"; exit; fi
}

validate_card_is_powered()
{
	cat /sys/kernel/debug/mmc2/ios | grep "power mode" | grep "on"
	if [ "$?" -ne 0 ]; then echo "Power is not on"; exit; fi

	cat /sys/kernel/debug/mmc2/ios | grep "clock" | grep "25000000"
	if [ "$?" -ne 0 ]; then echo "Clock failure"; exit; fi

	cat /sys/kernel/debug/mmc2/ios | grep "vdd" | grep "1.65 - 1.95"
	if [ "$?" -ne 0 ]; then echo "Voltage failure"; exit; fi

	cat /sys/kernel/debug/mmc2/ios | grep "bus width" | grep "4 bits"
	if [ "$?" -ne 0 ]; then echo "Bus width failure"; exit; fi
}

validate_card_is_suspended()
{
	cat /sys/kernel/debug/mmc2/ios | grep "power mode" | grep "off"
	if [ "$?" -ne 0 ]; then echo "power is not off"; exit; fi

	cat /sys/kernel/debug/mmc2/ios | grep "vdd" | grep "invalid"
	if [ "$?" -ne 0 ]; then echo "Voltage not down ?"; exit; fi
}

while [ 1 ]
do
	echo "beginning iteration $i"

	validate_module_down
	validate_card_is_suspended

	echo mem > /sys/power/state
	validate_card_is_suspended

	insmod wl1271_sdio.ko
	validate_module_up
	validate_card_is_suspended

	echo mem > /sys/power/state
	validate_card_is_suspended

	ifconfig wlan0 up
	validate_card_is_powered

	echo mem > /sys/power/state
	validate_card_is_powered

	ifconfig wlan0 down
	validate_card_is_suspended

	echo mem > /sys/power/state
	validate_card_is_suspended

	rmmod wl1271_sdio

	let "i+=1"
done

Note: the ios values tested for are obviously specific to the
wl1271 device.

Ohad Ben-Cohen (11):
  mmc: sdio: fully reconfigure oldcard on resume
  mmc: propagate power save/restore ops return value
  sdio: add power_restore support
  mmc: add runtime PM handlers
  sdio: use the generic runtime PM handlers
  sdio: enable runtime PM for SDIO cards
  sdio: enable runtime PM for SDIO functions
  sdio: ensure mmc_sdio_detect is powered
  sdio: support suspend/resume while runtime suspended
  wl1271: sdio: enable runtime PM
  wl1271: sdio: add suspend/resume support

 drivers/mmc/core/bus.c                    |   37 +++++++++++++
 drivers/mmc/core/core.c                   |   20 +++++--
 drivers/mmc/core/core.h                   |    4 +-
 drivers/mmc/core/mmc.c                    |    8 ++-
 drivers/mmc/core/sd.c                     |    8 ++-
 drivers/mmc/core/sdio.c                   |   54 +++++++++++++++---
 drivers/mmc/core/sdio_bus.c               |   85 ++++++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/wl1271_sdio.c |   43 +++++++++++++--
 include/linux/mmc/host.h                  |    4 +-
 9 files changed, 232 insertions(+), 31 deletions(-)

