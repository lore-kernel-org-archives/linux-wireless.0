Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752133AbeB0XVO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 18:21:14 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: cantabile.desu@gmail.com
Cc: kubakici@wp.pl, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, linux-wireless@vger.kernel.org,
        keescook@chromium.org, shuah@kernel.org, mfuzzey@parkeon.com,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        pali.rohar@gmail.com, tiwai@suse.de, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        stephen.boyd@linaro.org, broonie@kernel.org,
        dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        bjorn.andersson@linaro.org, jewalt@lgsinnovations.com,
        oneukum@suse.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [RFT 6/7] firmware: add request_firmware_cache() to help with cache on reboot
Date: Tue, 27 Feb 2018 15:21:00 -0800
Message-Id: <20180227232101.20786-7-mcgrof@kernel.org> (sfid-20180228_002216_988349_86F06054)
In-Reply-To: <20180227232101.20786-1-mcgrof@kernel.org>
References: <20180227232101.20786-1-mcgrof@kernel.org>
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
 drivers/base/firmware_loader.c                     | 24 ++++++++++++++++++++++
 include/linux/firmware.h                           |  3 +++
 3 files changed, 41 insertions(+)

diff --git a/Documentation/driver-api/firmware/request_firmware.rst b/Documentation/driver-api/firmware/request_firmware.rst
index cc0aea880824..b554f4338859 100644
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
+this can be done with request_firmware_cache() insted of requesting for the
+firmare to be loaded.
+
+request_firmware_cache()
+-----------------------
+.. kernel-doc:: drivers/base/firmware_class.c
+   :functions: request_firmware_load
+
 request firmware API expected driver use
 ========================================
 
diff --git a/drivers/base/firmware_loader.c b/drivers/base/firmware_loader.c
index 99c540164074..c122f6431e0c 100644
--- a/drivers/base/firmware_loader.c
+++ b/drivers/base/firmware_loader.c
@@ -656,6 +656,30 @@ int request_firmware_direct(const struct firmware **firmware_p,
 }
 EXPORT_SYMBOL_GPL(request_firmware_direct);
 
+/**
+ * request_firmware_cache: - cache firmware for suspend so resume can use it
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
+int request_firmware_cache(struct device *device, const char *name)
+{
+	int ret;
+
+	mutex_lock(&fw_lock);
+	ret = fw_add_devm_name(device, name);
+	mutex_unlock(&fw_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(request_firmware_cache);
+
 /**
  * request_firmware_into_buf - load firmware into a previously allocated buffer
  * @firmware_p: pointer to firmware image
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index d4508080348d..166867910ebc 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -85,4 +85,7 @@ static inline int request_firmware_into_buf(const struct firmware **firmware_p,
 }
 
 #endif
+
+int request_firmware_cache(struct device *device, const char *name);
+
 #endif
-- 
2.16.2
