Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753984AbeCUWef (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 18:34:35 -0400
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
Subject: [PATCH v4 1/3] firmware: fix typo on pr_info_once() when ignore_sysfs_fallback is used
Date: Wed, 21 Mar 2018 15:34:28 -0700
Message-Id: <20180321223430.21388-2-mcgrof@kernel.org> (sfid-20180321_233533_582388_11539F10)
In-Reply-To: <20180321223430.21388-1-mcgrof@kernel.org>
References: <20180321223430.21388-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the sysctl knob is used ignore the fallback mechanism we pr_info_once()
to ensure its noted the knob was used. The print incorrectly states its a
debugfs knob, its a sysctl knob, so correct this typo.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/base/firmware_loader/fallback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
index d231bbcb95d7..31b5015b59fe 100644
--- a/drivers/base/firmware_loader/fallback.c
+++ b/drivers/base/firmware_loader/fallback.c
@@ -652,7 +652,7 @@ static bool fw_force_sysfs_fallback(unsigned int opt_flags)
 static bool fw_run_sysfs_fallback(unsigned int opt_flags)
 {
 	if (fw_fallback_config.ignore_sysfs_fallback) {
-		pr_info_once("Ignoring firmware sysfs fallback due to debugfs knob\n");
+		pr_info_once("Ignoring firmware sysfs fallback due to sysctl knob\n");
 		return false;
 	}
 
-- 
2.16.2
