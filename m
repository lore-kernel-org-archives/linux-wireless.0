Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752145AbeB0XVL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 18:21:11 -0500
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
Subject: [RFT 4/7] firmware: add helper to check to see if fw cache is setup
Date: Tue, 27 Feb 2018 15:20:58 -0800
Message-Id: <20180227232101.20786-5-mcgrof@kernel.org> (sfid-20180228_002355_418790_C8536345)
In-Reply-To: <20180227232101.20786-1-mcgrof@kernel.org>
References: <20180227232101.20786-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a helper to check if the firmware cache is already setup for a device.
This will be used later.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/base/firmware_loader.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/base/firmware_loader.c b/drivers/base/firmware_loader.c
index a385622bf3e1..5f3d44d0bfe0 100644
--- a/drivers/base/firmware_loader.c
+++ b/drivers/base/firmware_loader.c
@@ -396,13 +396,23 @@ static struct fw_name_devm *fw_find_devm_name(struct device *dev,
 	return fwn;
 }
 
-/* add firmware name into devres list */
-static int fw_add_devm_name(struct device *dev, const char *name)
+static bool fw_cache_is_setup(struct device *dev, const char *name)
 {
 	struct fw_name_devm *fwn;
 
 	fwn = fw_find_devm_name(dev, name);
 	if (fwn)
+		return true;
+
+	return false;
+}
+
+/* add firmware name into devres list */
+static int fw_add_devm_name(struct device *dev, const char *name)
+{
+	struct fw_name_devm *fwn;
+
+	if (fw_cache_is_setup(dev, name))
 		return 0;
 
 	fwn = devres_alloc(fw_name_devm_release, sizeof(struct fw_name_devm),
-- 
2.16.2
