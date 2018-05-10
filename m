Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752318AbeEJUJK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 16:09:10 -0400
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
Subject: [PATCH v7 11/14] ath10k: re-enable the firmware fallback mechanism for testmode
Date: Thu, 10 May 2018 13:08:47 -0700
Message-Id: <20180510200850.5958-12-mcgrof@kernel.org> (sfid-20180510_221032_337053_9BE2F398)
In-Reply-To: <20180510200850.5958-1-mcgrof@kernel.org>
References: <20180510200850.5958-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andres Rodriguez <andresx7@gmail.com>

The ath10k testmode uses request_firmware_direct() in order to avoid
producing firmware load warnings. Disabling the fallback mechanism was a
side effect of disabling warnings.

We now have a new API that allows us to avoid warnings while keeping the
fallback mechanism enabled. So use that instead.

Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/net/wireless/ath/ath10k/testmode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
index 568810b41657..c24ee616833c 100644
--- a/drivers/net/wireless/ath/ath10k/testmode.c
+++ b/drivers/net/wireless/ath/ath10k/testmode.c
@@ -157,7 +157,7 @@ static int ath10k_tm_fetch_utf_firmware_api_1(struct ath10k *ar,
 		 ar->hw_params.fw.dir, ATH10K_FW_UTF_FILE);
 
 	/* load utf firmware image */
-	ret = request_firmware_direct(&fw_file->firmware, filename, ar->dev);
+	ret = firmware_request_nowarn(&fw_file->firmware, filename, ar->dev);
 	ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "testmode fw request '%s': %d\n",
 		   filename, ret);
 
-- 
2.17.0
