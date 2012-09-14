Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48007 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab2INLdg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 07:33:36 -0400
Message-ID: <5053160B.8060908@openwrt.org> (sfid-20120914_133339_975682_8F9A8600)
Date: Fri, 14 Sep 2012 13:33:31 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sven Eckelmann <sven@narfation.org>
CC: ath9k-devel@lists.ath9k.org, adrian.chadd@gmail.com,
	linux-wireless@vger.kernel.org, shafi.wireless@gmail.com,
	lindner_marek@yahoo.de, Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [RFC] ath9k: Work around complete stuck of hw
References: <50521E02.4030809@openwrt.org> <1347616045-29336-1-git-send-email-sven@narfation.org>
In-Reply-To: <1347616045-29336-1-git-send-email-sven@narfation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-09-14 11:47 AM, Sven Eckelmann wrote:
> AR9330 and most likely other chips like AR9285 seem to get stuck completely
> after they worked a long period of time in special environments. It is
> currently unknown which parameters causes this problem.
> 
> Symptom of these stuck is the exposure of 0xdeadbeef through different hardware
> registers. An interface down/up change seems to help the hardware to recover
> from the problem.
> 
> A workaround is to periodically test register AR_CFG for 0xdeadbeef and force
> an reset when 0xdeadbeef would be unexpected.
> 
> Signed-off-by: Sven Eckelmann <sven@narfation.org>
> Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> ---
> This check is currently tested. This takes quite a long time and maybe someone
> with more knowledge of atheros devices can check whether this one is completely
> and utterly wrong.
> 
> The type RESET_TYPE_FATAL_INT was chosen in this test to allow us to see
> whether this condition was already true by reading from
> /sys/kernel/debug/ieee80211/phy0/ath9k/reset
Your debug patch should not be silent when it resets the hw. We need 
to make sure that this bug gets fixed properly. If my patch below does
not fix it, then at least add a WARN_ON to ensure that we don't just
hide the bug and move on.

Somebody on the openwrt-devel list pointed out that there is some code 
missing in the ar933x wmac reset function. Please try this patch (apply 
it to your kernel tree):
---
--- a/arch/mips/ath79/dev-wmac.c
+++ b/arch/mips/ath79/dev-wmac.c
@@ -67,10 +67,27 @@ static void __init ar913x_wmac_setup(voi
 
 static int ar933x_wmac_reset(void)
 {
+	int retries = 20;
+
 	ath79_device_reset_set(AR933X_RESET_WMAC);
 	ath79_device_reset_clear(AR933X_RESET_WMAC);
 
-	return 0;
+	while (1) {
+		u32 bootstrap;
+
+		bootstrap = ath79_reset_rr(AR933X_RESET_REG_BOOTSTRAP);
+		if ((bootstrap & AR933X_BOOTSTRAP_EEPBUSY) == 0)
+			return 0;
+
+		if (retries-- == 0)
+			break;
+
+		udelay(10000);
+		retries++;
+	}
+
+	pr_err("ar93xx: WMAC reset timed out");
+	return -ETIMEDOUT;
 }
 
 static int ar933x_r1_get_wmac_revision(void)


