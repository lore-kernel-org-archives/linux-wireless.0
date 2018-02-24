Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:44377 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751131AbeBXO7R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Feb 2018 09:59:17 -0500
Date: Sat, 24 Feb 2018 22:58:43 +0800
From: kbuild test robot <lkp@intel.com>
To: s.gottschall@dd-wrt.com
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org,
        kvalo@codeaurora.org, ath10k@lists.infradead.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>
Subject: [RFC PATCH] ath10k: ath10k_register_gpio_chip() can be static
Message-ID: <20180224145843.GA55309@roam> (sfid-20180224_155921_073561_BE7612C5)
References: <20180222111534.31047-1-s.gottschall@dd-wrt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180222111534.31047-1-s.gottschall@dd-wrt.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Fixes: 35b91f175b35 ("ath10k: add LED and GPIO controlling support for various chipsets")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/gpio.c b/drivers/net/wireless/ath/ath10k/gpio.c
index a760319..e9ce44b 100644
--- a/drivers/net/wireless/ath/ath10k/gpio.c
+++ b/drivers/net/wireless/ath/ath10k/gpio.c
@@ -81,7 +81,7 @@ static void ath10k_gpio_pin_set(struct gpio_chip *chip, unsigned offset,
 }
 
 /* register GPIO chip */
-int ath10k_register_gpio_chip(struct ath10k *ar)
+static int ath10k_register_gpio_chip(struct ath10k *ar)
 {
  
 	struct ath10k_gpiocontrol *gpio = ar->gpio;
