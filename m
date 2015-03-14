Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:39259 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750784AbbCNQHT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 12:07:19 -0400
From: Jeff Layton <jeff.layton@primarydata.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8188ee: fix build break due to missing rtl_hal_pwrseqcmdparsing definition
Date: Sat, 14 Mar 2015 12:07:17 -0400
Message-Id: <1426349237-7501-1-git-send-email-jeff.layton@primarydata.com> (sfid-20150314_170724_399896_2F4E68F9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been getting this error when building mainline kernels using
Fedora's config files:

    drivers/net/wireless/rtlwifi/rtl8188ee/hw.c: In function ‘_rtl88ee_init_mac’:
    drivers/net/wireless/rtlwifi/rtl8188ee/hw.c:853:2: error: implicit declaration of function ‘rtl_hal_pwrseqcmdparsing’ [-Werror=implicit-function-declaration]
      if (!rtl_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK,
      ^
    cc1: some warnings being treated as errors
    scripts/Makefile.build:258: recipe for target 'drivers/net/wireless/rtlwifi/rtl8188ee/hw.o' failed

I'm not sure if this is the correct fix, but it does seem to allow the
build to complete. I suspect that this was broken by commit 34ed780a6afc
(rtlwifi: Fix problems with building an allyesconfig). Most of the files
that removed the include of pwrseqcmd.h, added one for ../pwrseqcmd.h.
The rtl8188ee driver had it removed it but didn't add the include of the
file in the parent directory.

Signed-off-by: Jeff Layton <jeff.layton@primarydata.com>
---
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
index f2b9713c456e..e6fae1b5c211 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
@@ -30,6 +30,7 @@
 #include "../cam.h"
 #include "../ps.h"
 #include "../pci.h"
+#include "../pwrseqcmd.h"
 #include "reg.h"
 #include "def.h"
 #include "phy.h"
-- 
2.1.0

