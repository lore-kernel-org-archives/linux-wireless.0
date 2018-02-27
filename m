Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752115AbeB0XVI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 18:21:08 -0500
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
Subject: [RFT 1/7] rename: _request_firmware_load() fw_load_sysfs_fallback()
Date: Tue, 27 Feb 2018 15:20:55 -0800
Message-Id: <20180227232101.20786-2-mcgrof@kernel.org> (sfid-20180228_002614_023381_6B55D033)
In-Reply-To: <20180227232101.20786-1-mcgrof@kernel.org>
References: <20180227232101.20786-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reflects much clearer what is being done.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 Documentation/driver-api/firmware/fallback-mechanisms.rst | 2 +-
 drivers/base/firmware_fallback.c                          | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

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
diff --git a/drivers/base/firmware_fallback.c b/drivers/base/firmware_fallback.c
index 13fa5ff2b46c..ce7ccfe82c69 100644
--- a/drivers/base/firmware_fallback.c
+++ b/drivers/base/firmware_fallback.c
@@ -536,7 +536,7 @@ fw_create_instance(struct firmware *firmware, const char *fw_name,
 }
 
 /* load a firmware via user helper */
-static int _request_firmware_load(struct fw_sysfs *fw_sysfs,
+static int fw_load_sysfs_fallback(struct fw_sysfs *fw_sysfs,
 				  unsigned int opt_flags, long timeout)
 {
 	int retval = 0;
@@ -621,7 +621,7 @@ static int fw_load_from_user_helper(struct firmware *firmware,
 	}
 
 	fw_sysfs->fw_priv = firmware->priv;
-	ret = _request_firmware_load(fw_sysfs, opt_flags, timeout);
+	ret = fw_load_sysfs_fallback(fw_sysfs, opt_flags, timeout);
 
 	if (!ret)
 		ret = assign_fw(firmware, device, opt_flags);
-- 
2.16.2
