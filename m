Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752293AbeEJUJJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 16:09:09 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, keescook@chromium.org,
        josh@joshtriplett.org, maco@android.com, andy.gross@linaro.org,
        david.brown@linaro.org, bjorn.andersson@linaro.org, teg@jklm.no,
        wagi@monom.org, hdegoede@redhat.com, andresx7@gmail.com,
        zohar@linux.vnet.ibm.com, kubakici@wp.pl, shuah@kernel.org,
        mfuzzey@parkeon.com, dhowells@redhat.com, pali.rohar@gmail.com,
        tiwai@suse.de, kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        jewalt@lgsinnovations.com, oneukum@suse.com,
        cantabile.desu@gmail.com, khc@pm.waw.pl, arve@android.com,
        tkjos@android.com, corbet@lwn.net, mchehab+samsung@kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        "Luis R . Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v7 10/14] ath10k: use firmware_request_nowarn() to load firmware
Date: Thu, 10 May 2018 13:08:46 -0700
Message-Id: <20180510200850.5958-11-mcgrof@kernel.org> (sfid-20180510_221103_773224_969E5C2A)
In-Reply-To: <20180510200850.5958-1-mcgrof@kernel.org>
References: <20180510200850.5958-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andres Rodriguez <andresx7@gmail.com>

This reduces the unnecessary spew when trying to load optional firmware:
"Direct firmware load for ... failed with error -2"

Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 4cf54a7ef09a..ad4f6e3c0737 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -694,7 +694,7 @@ static const struct firmware *ath10k_fetch_fw_file(struct ath10k *ar,
 		dir = ".";
 
 	snprintf(filename, sizeof(filename), "%s/%s", dir, file);
-	ret = request_firmware(&fw, filename, ar->dev);
+	ret = firmware_request_nowarn(&fw, filename, ar->dev);
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot fw request '%s': %d\n",
 		   filename, ret);
 
-- 
2.17.0
