Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753761AbeCUWeg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 18:34:36 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, cantabile.desu@gmail.com,
        kubakici@wp.pl, linux-wireless@vger.kernel.org,
        keescook@chromium.org, shuah@kernel.org, mfuzzey@parkeon.com,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        pali.rohar@gmail.com, tiwai@suse.de, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        bjorn.andersson@linaro.org, jewalt@lgsinnovations.com,
        oneukum@suse.com, ast@fb.com, andresx7@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v4 2/3] firmware: add firmware_request_cache() to help with cache on reboot
Date: Wed, 21 Mar 2018 15:34:29 -0700
Message-Id: <20180321223430.21388-3-mcgrof@kernel.org> (sfid-20180321_233534_305325_0AB90D3A)
In-Reply-To: <20180321223430.21388-1-mcgrof@kernel.org>
References: <20180321223430.21388-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some devices have an optimization in place to enable the firmware to
be retaineed during a system reboot, so after reboot the device can skip
requesting and loading the firmware. This can save up to 1s in load
time. The mt7601u 802.11 device happens to be such a device.

When these devices retain the firmware on a reboot and then suspend
they can miss looking for the firmware on resume. To help with this we
need a way to cache the firmware when such an optimization has taken
place.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 .../driver-api/firmware/request_firmware.rst       | 14 +++++++++++++
 drivers/base/firmware_loader/main.c                | 24 ++++++++++++++++++++++
 include/linux/firmware.h                           |  3 +++
 3 files changed, 41 insertions(+)

diff --git a/Documentation/driver-api/firmware/request_firmware.rst b/Documentation/driver-api/firmware/request_firmware.rst
index cc0aea880824..cf4516dfbf96 100644
--- a/Documentation/driver-api/firmware/request_firmware.rst
+++ b/Documentation/driver-api/firmware/request_firmware.rst
@@ -44,6 +44,20 @@ request_firmware_nowait
 .. kernel-doc:: drivers/base/firmware_class.c
    :functions: request_firmware_nowait
 
+Special optimizations on reboot
+===============================
+
+Some devices have an optimization in place to enable the firmware to be
+retained during system reboot. When such optimizations are used the driver
+author must ensure the firmware is still available on resume from suspend,
+this can be done with firmware_request_cache() insted of requesting for the
+firmare to be loaded.
+
+firmware_request_cache()
+-----------------------
+.. kernel-doc:: drivers/base/firmware_class.c
+   :functions: firmware_request_cache
+
 request firmware API expected driver use
 ========================================
 
diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index 2913bb0e5e7b..eb34089e4299 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -656,6 +656,30 @@ int request_firmware_direct(const struct firmware **firmware_p,
 }
 EXPORT_SYMBOL_GPL(request_firmware_direct);
 
+/**
+ * firmware_request_cache: - cache firmware for suspend so resume can use it
+ * @name: name of firmware file
+ * @device: device for which firmware should be cached for
+ *
+ * There are some devices with an optimization that enables the device to not
+ * require loading firmware on system reboot. This optimization may still
+ * require the firmware present on resume from suspend. This routine can be
+ * used to ensure the firmware is present on resume from suspend in these
+ * situations. This helper is not compatible with drivers which use
+ * request_firmware_into_buf() or request_firmware_nowait() with no uevent set.
+ **/
+int firmware_request_cache(struct device *device, const char *name)
+{
+	int ret;
+
+	mutex_lock(&fw_lock);
+	ret = fw_add_devm_name(device, name);
+	mutex_unlock(&fw_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(firmware_request_cache);
+
 /**
  * request_firmware_into_buf - load firmware into a previously allocated buffer
  * @firmware_p: pointer to firmware image
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index d4508080348d..41050417cafb 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -85,4 +85,7 @@ static inline int request_firmware_into_buf(const struct firmware **firmware_p,
 }
 
 #endif
+
+int firmware_request_cache(struct device *device, const char *name);
+
 #endif
-- 
2.16.2
