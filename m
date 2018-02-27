Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751982AbeB0XVK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 18:21:10 -0500
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
Subject: [RFT 3/7] firmware: make fw_add_devm_name() return 0 if cache present
Date: Tue, 27 Feb 2018 15:20:57 -0800
Message-Id: <20180227232101.20786-4-mcgrof@kernel.org> (sfid-20180228_002217_638510_954ACCFE)
In-Reply-To: <20180227232101.20786-1-mcgrof@kernel.org>
References: <20180227232101.20786-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently fw_add_devm_name() returns 1 if the firmware cache
was already set. This makes it complicated for us to check for
correctness. It is actually non-fatal if the firmware cache
is already setup, so just return 0, and simplify the checkers.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/base/firmware_loader.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/firmware_loader.c b/drivers/base/firmware_loader.c
index 48932581c70c..a385622bf3e1 100644
--- a/drivers/base/firmware_loader.c
+++ b/drivers/base/firmware_loader.c
@@ -403,7 +403,7 @@ static int fw_add_devm_name(struct device *dev, const char *name)
 
 	fwn = fw_find_devm_name(dev, name);
 	if (fwn)
-		return 1;
+		return 0;
 
 	fwn = devres_alloc(fw_name_devm_release, sizeof(struct fw_name_devm),
 			   GFP_KERNEL);
@@ -450,7 +450,7 @@ int assign_fw(struct firmware *fw, struct device *device,
 	if (device && (opt_flags & FW_OPT_UEVENT) &&
 	    !(opt_flags & FW_OPT_NOCACHE)) {
 		ret = fw_add_devm_name(device, fw_priv->fw_name);
-		if (ret && ret != 1) {
+		if (ret) {
 			mutex_unlock(&fw_lock);
 			return ret;
 		}
-- 
2.16.2
