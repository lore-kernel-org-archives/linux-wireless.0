Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:44136 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751458AbdJSSpX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Oct 2017 14:45:23 -0400
Received: by mail-io0-f194.google.com with SMTP id m16so10879294iod.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Oct 2017 11:45:22 -0700 (PDT)
Date: Thu, 19 Oct 2017 11:45:19 -0700
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        Grant Grundler <grundler@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] ath10k: fix build errors with !CONFIG_PM
Message-ID: <20171019184517.GA76422@google.com> (sfid-20171019_204536_226530_12788B69)
References: <20170919232416.108247-1-briannorris@chromium.org>
 <2809b2cf512d4c198d3cef3f5e468c3c@euamsexm01e.eu.qualcomm.com>
 <87vajbgqcz.fsf@kamboji.qca.qualcomm.com>
 <20171019171224.GA46096@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171019171224.GA46096@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Build errors have been reported with CONFIG_PM=n:

drivers/net/wireless/ath/ath10k/pci.c:3416:8: error: implicit
declaration of function 'ath10k_pci_suspend'
[-Werror=implicit-function-declaration]

drivers/net/wireless/ath/ath10k/pci.c:3428:8: error: implicit
declaration of function 'ath10k_pci_resume'
[-Werror=implicit-function-declaration]

These are caused by the combination of the following two commits:

6af1de2e4ec4 ("ath10k: mark PM functions as __maybe_unused")
96378bd2c6cd ("ath10k: fix core PCI suspend when WoWLAN is supported but
disabled")

Both build fine on their own.

But now that ath10k_pci_pm_{suspend,resume}() is compiled
unconditionally, we should also compile ath10k_pci_{suspend,resume}()
unconditionally.

And drop the #ifdef around ath10k_pci_hif_{suspend,resume}() too; they
are trivial (empty), so we're not saving much space by compiling them
out. And the alternatives would be to sprinkle more __maybe_unused, or
spread the #ifdef's further.

Build tested with the following combinations:
CONFIG_PM=y && CONFIG_PM_SLEEP=y
CONFIG_PM=y && CONFIG_PM_SLEEP=n
CONFIG_PM=n

Fixes: 96378bd2c6cd ("ath10k: fix core PCI suspend when WoWLAN is supported but disabled")
Fixes: 096ad2a15fd8 ("Merge branch 'ath-next'")
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/ath/ath10k/pci.c | 5 -----
 1 file changed, 5 deletions(-)

On Thu, Oct 19, 2017 at 10:12:25AM -0700, Brian Norris wrote:
> The solution would seem to be either to kill the #ifdefs around
> ath10k_pci_{suspend,resume}() and friends (and use __maybe_unused
> instead, to further extend Arnd's patch), or else revert Arnd's stuff
> and go with CONFIG_PM_SLEEP everywhere, which would resolve the original
> warning (promoted to error) that Arnd was resolving.
> 
> I can send out one of these if you'd like.

Here you go :)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index b18a9b690df4..d790ea20b95d 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2577,8 +2577,6 @@ void ath10k_pci_hif_power_down(struct ath10k *ar)
 	 */
 }
 
-#ifdef CONFIG_PM
-
 static int ath10k_pci_hif_suspend(struct ath10k *ar)
 {
 	/* Nothing to do; the important stuff is in the driver suspend. */
@@ -2627,7 +2625,6 @@ static int ath10k_pci_resume(struct ath10k *ar)
 
 	return ret;
 }
-#endif
 
 static bool ath10k_pci_validate_cal(void *data, size_t size)
 {
@@ -2782,10 +2779,8 @@ static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
 	.power_down		= ath10k_pci_hif_power_down,
 	.read32			= ath10k_pci_read32,
 	.write32		= ath10k_pci_write32,
-#ifdef CONFIG_PM
 	.suspend		= ath10k_pci_hif_suspend,
 	.resume			= ath10k_pci_hif_resume,
-#endif
 	.fetch_cal_eeprom	= ath10k_pci_hif_fetch_cal_eeprom,
 };
 
-- 
2.15.0.rc1.287.g2b38de12cc-goog
