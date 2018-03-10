Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933181AbeCJOPf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 09:15:35 -0500
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
Subject: [PATCH v3 18/20] firmware: ensure the firmware cache is not used on incompatible calls
Date: Sat, 10 Mar 2018 06:14:59 -0800
Message-Id: <20180310141501.2214-19-mcgrof@kernel.org> (sfid-20180310_151638_251755_70AA8DC2)
In-Reply-To: <20180310141501.2214-1-mcgrof@kernel.org>
References: <20180310141501.2214-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

request_firmware_into_buf() explicitly disables the firmware cache,
meanwhile the firmware cache cannot be used when request_firmware_nowait()
is used without the uevent. Enforce a sanity check for this to avoid future
issues undocumented behaviours should misuses of the firmware cache
happen later.

One of the reasons we want to enforce this is the firmware cache is
used for helping with suspend/resume, and if incompatible calls use it
they can stall suspend.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/base/firmware_loader/main.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index b569d8a09392..2913bb0e5e7b 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -431,6 +431,11 @@ static int fw_add_devm_name(struct device *dev, const char *name)
 	return 0;
 }
 #else
+static bool fw_cache_is_setup(struct device *dev, const char *name)
+{
+	return false;
+}
+
 static int fw_add_devm_name(struct device *dev, const char *name)
 {
 	return 0;
@@ -672,6 +677,9 @@ request_firmware_into_buf(const struct firmware **firmware_p, const char *name,
 {
 	int ret;
 
+	if (fw_cache_is_setup(device, name))
+		return -EOPNOTSUPP;
+
 	__module_get(THIS_MODULE);
 	ret = _request_firmware(firmware_p, name, device, buf, size,
 				FW_OPT_UEVENT | FW_OPT_NOCACHE);
@@ -769,6 +777,12 @@ request_firmware_nowait(
 	fw_work->opt_flags = FW_OPT_NOWAIT |
 		(uevent ? FW_OPT_UEVENT : FW_OPT_USERHELPER);
 
+	if (!uevent && fw_cache_is_setup(device, name)) {
+		kfree_const(fw_work->name);
+		kfree(fw_work);
+		return -EOPNOTSUPP;
+	}
+
 	if (!try_module_get(module)) {
 		kfree_const(fw_work->name);
 		kfree(fw_work);
-- 
2.16.2
