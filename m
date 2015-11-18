Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:36139 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977AbbKRXW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 18:22:26 -0500
Received: by qgad10 with SMTP id d10so40470235qga.3
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2015 15:22:25 -0800 (PST)
From: Steve deRosier <derosier@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org,
	Steve deRosier <steve.derosier@lairdtech.com>
Subject: [PATCH v2 0/2] ath6kl_sdio: add control of CHIP_PWD_L via GPIO
Date: Wed, 18 Nov 2015 15:20:46 -0800
Message-Id: <1447888848-19530-1-git-send-email-steve.derosier@lairdtech.com> (sfid-20151119_002229_678114_97FEB1C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of two patches adds the ablity for ath6kl_sdio to control the
CHIP_PWD_L pin on startup and for suspend/wakeup. This is importaint because
on some platforms, this is the only way to achieve minimum power consumption.
The CHIP_PWD_L pin is used to hold the ath chip in reset and this is the
proper way to achieve its lowest power state (per QCA's datasheets).

This GPIO is controled by the kernel standard GPIOLIB and as such depends on
CONFIG_GPIOLIB. If this isn't enabled, then the various usages will generally
compile out. Even if enabled, by default the GPIO is set to an invalid number,
and each use will check: if not a valid GPIO, then behavior will be unchanged.

This adds a new module parameter to allow the user to set the GPIO to use.

To utilize:
        modprobe ath6kl_sdio reset_pwd_gpio=28
Where "28" should be replaced by the GPIO id of the pin connected to the
CHIP_PWD_L pin on the wifi chip.

v2:

Changes due to review comments
* Fix __init and __exit on gpio init/cleanup functions
* Remove unnecessary #ifdef defines on GPIO as gpio.h already takes care of it
* Utilize already available ARCH_NR_GPIOS
* Remove msleep on exit as the problem it resolves is taken care of a different
  patch.

This applies against kvalo/ath.git master branch

Steve deRosier (2):
  ath6kl_sdio: Add reset gpio module parameter for CHIP_PWD_L pin
  ath6kl_sdio: Add power gpio reset feature into sdio driver for suspend

 drivers/net/wireless/ath/ath6kl/sdio.c | 113 ++++++++++++++++++++++++++++++++-
 1 file changed, 110 insertions(+), 3 deletions(-)

-- 
1.9.1

