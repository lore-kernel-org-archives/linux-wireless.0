Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933128AbeCJOPc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 09:15:32 -0500
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
Subject: [PATCH v3 15/20] firmware: fix checking for return values for fw_add_devm_name()
Date: Sat, 10 Mar 2018 06:14:56 -0800
Message-Id: <20180310141501.2214-16-mcgrof@kernel.org> (sfid-20180310_151750_455753_EA1F04F6)
In-Reply-To: <20180310141501.2214-1-mcgrof@kernel.org>
References: <20180310141501.2214-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently fw_add_devm_name() returns 1 if the firmware cache
was already set. This makes it complicated for us to check for
correctness. It is actually non-fatal if the firmware cache
is already setup, so just return 0, and simplify the checkers.

fw_add_devm_name() adds device's name onto the devres for the
device so that prior to suspend we cache the firmware onto memory,
so that on resume the firmware is reliably available. We never
were checking for success for this call though, meaning in some
really rare cases we my have never setup the firmware cache for
a device, which could in turn make resume fail.

This is all theoretical, no known issues have been reported.
This small issue has been present way since the addition of the
devres firmware cache names on v3.7.

Fixes: f531f05ae9437 ("firmware loader: store firmware name into devres list")
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/base/firmware_loader/main.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index c8966c84bd44..f5046887e362 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -403,7 +403,7 @@ static int fw_add_devm_name(struct device *dev, const char *name)
 
 	fwn = fw_find_devm_name(dev, name);
 	if (fwn)
-		return 1;
+		return 0;
 
 	fwn = devres_alloc(fw_name_devm_release, sizeof(struct fw_name_devm),
 			   GFP_KERNEL);
@@ -431,6 +431,7 @@ int assign_fw(struct firmware *fw, struct device *device,
 	      unsigned int opt_flags)
 {
 	struct fw_priv *fw_priv = fw->priv;
+	int ret;
 
 	mutex_lock(&fw_lock);
 	if (!fw_priv->size || fw_state_is_aborted(fw_priv)) {
@@ -447,8 +448,13 @@ int assign_fw(struct firmware *fw, struct device *device,
 	 */
 	/* don't cache firmware handled without uevent */
 	if (device && (opt_flags & FW_OPT_UEVENT) &&
-	    !(opt_flags & FW_OPT_NOCACHE))
-		fw_add_devm_name(device, fw_priv->fw_name);
+	    !(opt_flags & FW_OPT_NOCACHE)) {
+		ret = fw_add_devm_name(device, fw_priv->fw_name);
+		if (ret) {
+			mutex_unlock(&fw_lock);
+			return ret;
+		}
+	}
 
 	/*
 	 * After caching firmware image is started, let it piggyback
-- 
2.16.2
