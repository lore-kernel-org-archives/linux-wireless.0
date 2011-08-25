Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59780 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab1HYNBJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 09:01:09 -0400
Received: by fxh19 with SMTP id 19so1724529fxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 06:01:08 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Kalle Valo <kvalo@adurom.com>
Subject: Re: car9170: undefined reference to `__udivdi3'
Date: Thu, 25 Aug 2011 15:00:54 +0200
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
References: <87aaaxon58.fsf@purkki.adurom.net>
In-Reply-To: <87aaaxon58.fsf@purkki.adurom.net>
MIME-Version: 1.0
Message-Id: <201108251500.54814.lach1012@hs-karlsruhe.de> (sfid-20110825_150113_597867_ECA58DBD)
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, August 25, 2011 11:28:51 AM Kalle Valo wrote:
> carl9170 fails to compile on wireless-testing when I compile a 32 bit
> kernel:
> 
> drivers/built-in.o: In function `carl9170_collect_tally':
> /home/kvalo/ath6kl/ath6kl/drivers/net/wireless/ath/carl9170/cmd.c:191:
> undefined reference to `__udivdi3'
> /home/kvalo/ath6kl/ath6kl/drivers/net/wireless/ath/carl9170/cmd.c:192:
> undefined reference to `__udivdi3'
> /home/kvalo/ath6kl/ath6kl/drivers/net/wireless/ath/carl9170/cmd.c:193:
> undefined reference to `__udivdi3'
> 
> Reverting this patch fixes the issue:
> 
> commit acf1771221f2877ab5d36487930cd6a2ecaa73e6
> Author: Christian Lamparter <chunkeey@googlemail.com>
> Date:   Mon Aug 15 19:50:48 2011 +0200
> 
>     carl9170: improve site survey
> 
Please try the attached patch:
---
[PATCH v1] carl9170: Use do_div for 64-bit division to fix 32-bit kernels

Use the do_div macro for 64-bit division. Otherwise, the module will
reference __udivdi3 under 32-bit kernels, which is not allowed in
kernel space.

drivers/built-in.o: In function `carl9170_collect_tally':
cmd.c:191: undefined reference to `__udivdi3'
cmd.c:192: undefined reference to `__udivdi3'
cmd.c:193: undefined reference to `__udivdi3'

Reported-by: Kalle Valo <kvalo@adurom.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/carl9170/cmd.c b/drivers/net/wireless/ath/carl9170/cmd.c
index 9970bf8..195dc65 100644
--- a/drivers/net/wireless/ath/carl9170/cmd.c
+++ b/drivers/net/wireless/ath/carl9170/cmd.c
@@ -36,6 +36,7 @@
  *    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <asm/div64.h>
 #include "carl9170.h"
 #include "cmd.h"
 
@@ -187,10 +188,12 @@ int carl9170_collect_tally(struct ar9170 *ar)
 
 		if (ar->channel) {
 			info = &ar->survey[ar->channel->hw_value];
-
-			info->channel_time = ar->tally.active / 1000;
-			info->channel_time_busy = ar->tally.cca / 1000;
-			info->channel_time_tx = ar->tally.tx_time / 1000;
+			info->channel_time = ar->tally.active;
+			info->channel_time_busy = ar->tally.cca;
+			info->channel_time_tx = ar->tally.tx_time;
+			do_div(info->channel_time, 1000);
+			do_div(info->channel_time_busy, 1000);
+			do_div(info->channel_time_tx, 1000);
 		}
 	}
 	return 0;
