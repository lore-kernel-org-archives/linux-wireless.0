Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:35520 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbbKQFek (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 00:34:40 -0500
Received: by qgec40 with SMTP id c40so65477820qge.2
        for <linux-wireless@vger.kernel.org>; Mon, 16 Nov 2015 21:34:39 -0800 (PST)
From: Steve deRosier <derosier@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org,
	Steve deRosier <steve.derosier@lairdtech.com>
Subject: [PATCH 0/2] ath6kl_sdio: add control of CHIP_PWD_L via GPIO
Date: Mon, 16 Nov 2015 21:32:51 -0800
Message-Id: <1447738373-15804-1-git-send-email-steve.derosier@lairdtech.com> (sfid-20151117_063443_946096_7D570402)
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


Steve deRosier (2):
  ath6kl_sdio: Add reset gpio module parameter for CHIP_PWD_L pin
  ath6kl_sdio: Add power gpio reset feature into sdio driver for suspend

 drivers/net/wireless/ath/ath6kl/sdio.c | 125 ++++++++++++++++++++++++++++++++-
 1 file changed, 124 insertions(+), 1 deletion(-)

-- 
1.9.1

