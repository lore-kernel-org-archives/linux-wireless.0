Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:39969 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935232AbeEIQmw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 12:42:52 -0400
Received: by mail-oi0-f65.google.com with SMTP id c203-v6so32077831oib.7
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2018 09:42:51 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>
Subject: [PATCH] ssb: Fix regression caused by disabling PCI cores on non-MIPS architecture
Date: Wed,  9 May 2018 11:42:20 -0500
Message-Id: <20180509164220.22653-1-Larry.Finger@lwfinger.net> (sfid-20180509_184256_107809_D643788E)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some MPIS-based SoCs use chips driven by b43 for wireless capability.
When ssb is configured as a module, build errors happen on these
platforms as described in the commit 882164a4a928 ("ssb: Prevent build
of PCI host features in module"). Unfortunately that change leads to
the removal of code needed for correct operation on platforms that use
PCI cores on the chip bus. The fix allows ssb to be build as a module
for all architectures other than MIPS. This approach is ad-hoc, but it
is the same as done in commit a9e6d44ddecc ("ssb: Do not disable PCI
host on non-Mips").

This problem was reported and discussed in
https://bugzilla.redhat.com/show_bug.cgi?id=1572349.

Fixes: commit 882164a4a928 ("ssb: Prevent build of PCI host features in module")
Tested-by: Matt Redfearn <matt.redfearn@mips.com>
Tested-by: Bruno Wolff III <bruno@wolff.to>
Cc: Michael Büsch <m@bues.ch>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Kalle,

This patch fixes the regression in 4.17 that was discussed on the
wireless mailing list. I'm not really happy about the ad-hoc rejection
of ssb as a module only on MIPS; however, that seems to be a unique
implementation of this hardware.

Larry

Michael,

Although I think your version of the patch is superior, this is the one that
Matt tested, thus I'm submitting this version.

Larry

---
 drivers/ssb/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index 9371651d8017..3743533c8057 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -117,7 +117,7 @@ config SSB_SERIAL
 
 config SSB_DRIVER_PCICORE_POSSIBLE
 	bool
-	depends on SSB_PCIHOST && SSB = y
+	depends on SSB_PCIHOST && (SSB = y || !MIPS)
 	default y
 
 config SSB_DRIVER_PCICORE
-- 
2.16.3
