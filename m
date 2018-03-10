Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933073AbeCJOPa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 09:15:30 -0500
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
Subject: [PATCH v3 14/20] rename: _request_firmware_load() fw_load_sysfs_fallback()
Date: Sat, 10 Mar 2018 06:14:55 -0800
Message-Id: <20180310141501.2214-15-mcgrof@kernel.org> (sfid-20180310_151823_456398_4E6AE6B7)
In-Reply-To: <20180310141501.2214-1-mcgrof@kernel.org>
References: <20180310141501.2214-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reflects much clearer what is being done.
While at it, kdoc'ify it.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 Documentation/driver-api/firmware/fallback-mechanisms.rst |  2 +-
 drivers/base/firmware_loader/fallback.c                   | 13 ++++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/Documentation/driver-api/firmware/fallback-mechanisms.rst b/Documentation/driver-api/firmware/fallback-mechanisms.rst
index 4055ac76b288..f353783ae0be 100644
--- a/Documentation/driver-api/firmware/fallback-mechanisms.rst
+++ b/Documentation/driver-api/firmware/fallback-mechanisms.rst
@@ -112,7 +112,7 @@ Since a device is created for the sysfs interface to help load firmware as a
 fallback mechanism userspace can be informed of the addition of the device by
 relying on kobject uevents. The addition of the device into the device
 hierarchy means the fallback mechanism for firmware loading has been initiated.
-For details of implementation refer to _request_firmware_load(), in particular
+For details of implementation refer to fw_load_sysfs_fallback(), in particular
 on the use of dev_set_uevent_suppress() and kobject_uevent().
 
 The kernel's kobject uevent mechanism is implemented in lib/kobject_uevent.c,
diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
index d6838e7ec00c..0a8ec7fec585 100644
--- a/drivers/base/firmware_loader/fallback.c
+++ b/drivers/base/firmware_loader/fallback.c
@@ -535,8 +535,15 @@ fw_create_instance(struct firmware *firmware, const char *fw_name,
 	return fw_sysfs;
 }
 
-/* load a firmware via user helper */
-static int _request_firmware_load(struct fw_sysfs *fw_sysfs,
+/**
+ * fw_load_sysfs_fallback - load a firmware via the syfs fallback mechanism
+ * @fw_sysfs: firmware syfs information for the firmware to load
+ * @opt_flags: flags of options, FW_OPT_*
+ * @timeout: timeout to wait for the load
+ *
+ * In charge of constructing a sysfs fallback interface for firmware loading.
+ **/
+static int fw_load_sysfs_fallback(struct fw_sysfs *fw_sysfs,
 				  unsigned int opt_flags, long timeout)
 {
 	int retval = 0;
@@ -621,7 +628,7 @@ static int fw_load_from_user_helper(struct firmware *firmware,
 	}
 
 	fw_sysfs->fw_priv = firmware->priv;
-	ret = _request_firmware_load(fw_sysfs, opt_flags, timeout);
+	ret = fw_load_sysfs_fallback(fw_sysfs, opt_flags, timeout);
 
 	if (!ret)
 		ret = assign_fw(firmware, device, opt_flags);
-- 
2.16.2
