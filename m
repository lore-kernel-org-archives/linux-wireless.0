Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bsmtp4.bon.at ([195.3.86.186]:28806 "EHLO bsmtp.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753964Ab1JCJs2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 05:48:28 -0400
Date: Mon, 3 Oct 2011 10:48:23 +0200
From: Clemens Buchacher <drizzd@aon.at>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath9k: irq storm after suspend/resume
Message-ID: <20111003084823.GA1521@ecki.lan> (sfid-20111003_114831_526325_6D45D27E)
References: <CAD2nsn1roVNB5+H1CYHVnerLN3pjGB5KmEX1mJZ4yJhHqFGOVA@mail.gmail.com>
 <20110830064137.GA4719@ecki>
 <CAD2nsn2Reu+T=g6HwdQT5cdkD0C-06y7GJ_B2q-UzpRnshxAWw@mail.gmail.com>
 <14be9f3b-4c91-481d-9e52-f3119659fd59@email.android.com>
 <CAD2nsn1+WVaLR_TR37Z6YRCFnQH1hJkSOri=nxc8Ff3pa9N8dw@mail.gmail.com>
 <20110927214245.GA1416@ecki>
 <CAD2nsn3ZwUJsFRLyjKenO6Pm3+jr9gfmAMRDQPStEcC1hN_mkw@mail.gmail.com>
 <CAJ-Vmok8FvrYtT2QwXY0NowLSogfkZYNbGLFbVR8Uzv507FrdA@mail.gmail.com>
 <CAD2nsn0Z2J4r4tN_fLjx5bbvz2bg6NVcQ8vppJbbNcgOF8pFew@mail.gmail.com>
 <CAJ-VmokcM4KmzV7Rn9PA68iEiTJiPw=ffYgNFLDAHShxD0HNAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ-VmokcM4KmzV7Rn9PA68iEiTJiPw=ffYgNFLDAHShxD0HNAg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(re-added linux-wireless)

On Fri, Sep 30, 2011 at 01:46:06PM +0800, Adrian Chadd wrote:
> 
> if (sc->sc_flags & SC_OP_INVALID) {
> printk(KERN_ERR "AR_INTR_SYNC_CAUSE: 0x%08x, AR_INTR_ASYNC_CAUSE: 0x%08x\n",
>     REG_READ(ah, AR_INTR_SYNC_CAUSE), REG_READ(ah, AR_INTR_ASYNC_CAUSE));
> printk(KERN_ERR "AR_IMR: 0x%08x, AR_ISR: 0x%08x\n",
>     REG_READ(ah, AR_IMR),
>     REG_READ(ah, AR_ISR));
>     return IRQ_NONE;
> }

I only output the first 99 and then every 2^n'th interrupt. The log
gets truncated otherwise. If I load the module first, then
suspend/resume, I get this until "nobody cared".

for 1, 2, ..., 99, 128, 256:
AR_INTR_SYNC_CAUSE: 0x00000000, AR_INTR_ASYNC_CAUSE: 0x00000000
AR_IMR: 0xdeadbeef, AR_ISR: 0xdeadbeef

for 512:
AR_INTR_SYNC_CAUSE: 0x00000000, AR_INTR_ASYNC_CAUSE: 0x00000000
AR_IMR: 0x00000000, AR_ISR: 0x00000208

for 1024:
AR_INTR_SYNC_CAUSE: 0x00000000, AR_INTR_ASYNC_CAUSE: 0x00000000
AR_IMR: 0x81800964, AR_ISR: 0x00000008

for 2048:
AR_INTR_SYNC_CAUSE: 0x00000000, AR_INTR_ASYNC_CAUSE: 0x00000000
AR_IMR: 0xdeadbeef, AR_ISR: 0xdeadbeef

for 2^12, 2^13, ..., 2^16
AR_INTR_SYNC_CAUSE: 0x00020000, AR_INTR_ASYNC_CAUSE: 0x00000000
AR_IMR: 0xdeadbeef, AR_ISR: 0xdeadbeef

The last ones indeed correspond to AR_INTR_SYNC_MAC_SLEEP_ACCESS
that you mentioned. Note that this output is interleaved with
device initialization. So I don't know if that causes the register
contents to become valid, or if it changes the contents.

If I suspend/resume first, then load the module, then wait for 500
ms after request_irq I get only zeroes, repeated 109 times:

for 1, 2, ..., 99, 2^7, 2^8, ..., 2^16:
AR_IMR: 0x00000000, AR_ISR: 0x00000000
AR_INTR_SYNC_CAUSE: 0x00000000, AR_INTR_ASYNC_CAUSE: 0x00000000

Clemens
---

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index edaa784..634256b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -16,6 +16,7 @@
 
 #include <linux/nl80211.h>
 #include <linux/delay.h>
+#include <linux/log2.h>
 #include "ath9k.h"
 #include "btcoex.h"
 
@@ -765,8 +766,19 @@ irqreturn_t ath_isr(int irq, void *dev)
 	 * touch anything. Note this can happen early
 	 * on if the IRQ is shared.
 	 */
-	if (sc->sc_flags & SC_OP_INVALID)
+	if (sc->sc_flags & SC_OP_INVALID) {
+		static int count = 0;
+		if (count < INT_MAX)
+			count++;
+		if (count < 100 || is_power_of_2(count)) {
+			printk(KERN_ERR "AR_INTR_SYNC_CAUSE: 0x%08x, AR_INTR_ASYNC_CAUSE: 0x%08x\n",
+					REG_READ(ah, AR_INTR_SYNC_CAUSE), REG_READ(ah, AR_INTR_ASYNC_CAUSE));
+			printk(KERN_ERR "AR_IMR: 0x%08x, AR_ISR: 0x%08x\n",
+					REG_READ(ah, AR_IMR),
+					REG_READ(ah, AR_ISR));
+		}
 		return IRQ_NONE;
+	}
 
 
 	/* shared irq, not for us */
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index d67d6ee..76006a9 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -246,20 +246,24 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Will be cleared in ath9k_start() */
 	sc->sc_flags |= SC_OP_INVALID;
 
+	ret = ath9k_init_device(id->device, sc, &ath_pci_bus_ops);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to initialize device\n");
+		goto err_init;
+	}
+
+	printk(KERN_INFO "ath9k: requesting irq\n");
 	ret = request_irq(pdev->irq, ath_isr, IRQF_SHARED, "ath9k", sc);
 	if (ret) {
 		dev_err(&pdev->dev, "request_irq failed\n");
 		goto err_irq;
 	}
+	printk(KERN_INFO "wait 500 ms\n");
+	msleep(500);
+	printk(KERN_INFO "done waiting\n");
 
 	sc->irq = pdev->irq;
 
-	ret = ath9k_init_device(id->device, sc, &ath_pci_bus_ops);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to initialize device\n");
-		goto err_init;
-	}
-
 	ath9k_hw_name(sc->sc_ah, hw_name, sizeof(hw_name));
 	wiphy_info(hw->wiphy, "%s mem=0x%lx, irq=%d\n",
 		   hw_name, (unsigned long)mem, pdev->irq);
