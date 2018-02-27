Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752133AbeB0XVJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 18:21:09 -0500
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
Subject: [RFT 2/7] firmware: fix checking for return values for fw_add_devm_name()
Date: Tue, 27 Feb 2018 15:20:56 -0800
Message-Id: <20180227232101.20786-3-mcgrof@kernel.org> (sfid-20180228_002330_834432_5E530817)
In-Reply-To: <20180227232101.20786-1-mcgrof@kernel.org>
References: <20180227232101.20786-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
 drivers/base/firmware_loader.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/base/firmware_loader.c b/drivers/base/firmware_loader.c
index 21dd31ef08ae..48932581c70c 100644
--- a/drivers/base/firmware_loader.c
+++ b/drivers/base/firmware_loader.c
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
+		if (ret && ret != 1) {
+			mutex_unlock(&fw_lock);
+			return ret;
+		}
+	}
 
 	/*
 	 * After caching firmware image is started, let it piggyback
-- 
2.16.2
