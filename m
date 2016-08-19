Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36019 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754959AbcHSQon (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 12:44:43 -0400
Received: by mail-wm0-f50.google.com with SMTP id q128so41478367wma.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Aug 2016 09:44:42 -0700 (PDT)
From: Jakub Kicinski <jakub.kicinski@netronome.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCHv7 2/4] mt7601u: remove redefinition of GENMASK
Date: Fri, 19 Aug 2016 17:44:07 +0100
Message-Id: <1471625049-12643-3-git-send-email-jakub.kicinski@netronome.com> (sfid-20160819_184448_278305_C5E2625E)
In-Reply-To: <1471625049-12643-1-git-send-email-jakub.kicinski@netronome.com>
References: <1471625049-12643-1-git-send-email-jakub.kicinski@netronome.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove redefinition of GENMASK which should not be there
in the upstream version of the code.

Reviewed-by: Dinan Gunawardena <dinan.gunawardena@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/wireless/mediatek/mt7601u/regs.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/regs.h b/drivers/net/wireless/mediatek/mt7601u/regs.h
index afd8978e83fa..27a429d90cec 100644
--- a/drivers/net/wireless/mediatek/mt7601u/regs.h
+++ b/drivers/net/wireless/mediatek/mt7601u/regs.h
@@ -17,10 +17,6 @@
 
 #include <linux/bitops.h>
 
-#ifndef GENMASK
-#define GENMASK(h, l)       (((U32_C(1) << ((h) - (l) + 1)) - 1) << (l))
-#endif
-
 #define MT_ASIC_VERSION			0x0000
 
 #define MT76XX_REV_E3		0x22
-- 
1.9.1
