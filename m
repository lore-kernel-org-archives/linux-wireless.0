Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752163AbeB0XVN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 18:21:13 -0500
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
Subject: [RFT 5/7] firmware: ensure the firmware cache is not used on incompatible calls
Date: Tue, 27 Feb 2018 15:20:59 -0800
Message-Id: <20180227232101.20786-6-mcgrof@kernel.org> (sfid-20180228_002311_792516_F4D5CEE5)
In-Reply-To: <20180227232101.20786-1-mcgrof@kernel.org>
References: <20180227232101.20786-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

request_firmware_into_buf() explicitly disables the firmware cache,
meanwhile the firmware cache cannot be used when request_firmware_nowait()
is used without the uevent. Enforce a sanity check for this to avoid future
issues undocumented behaviours should misuses of the firmware cache
happen later.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/base/firmware_loader.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/base/firmware_loader.c b/drivers/base/firmware_loader.c
index 5f3d44d0bfe0..99c540164074 100644
--- a/drivers/base/firmware_loader.c
+++ b/drivers/base/firmware_loader.c
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
@@ -769,6 +777,9 @@ request_firmware_nowait(
 	fw_work->opt_flags = FW_OPT_NOWAIT |
 		(uevent ? FW_OPT_UEVENT : FW_OPT_USERHELPER);
 
+	if (!uevent && fw_cache_is_setup(device, name))
+		return -EOPNOTSUPP;
+
 	if (!try_module_get(module)) {
 		kfree_const(fw_work->name);
 		kfree(fw_work);
-- 
2.16.2
