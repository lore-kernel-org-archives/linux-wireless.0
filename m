Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:39615 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751913AbeEGPog (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 11:44:36 -0400
To: Matt Redfearn <matt.redfearn@mips.com>,
        =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Regression caused by commit 882164a4a928
Message-ID: <7bbc067a-c412-3d2e-174a-abc31b46e246@lwfinger.net> (sfid-20180507_174451_834894_21A31274)
Date: Mon, 7 May 2018 10:44:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matt,

Although commit 882164a4a928 ("ssb: Prevent build of PCI host features in 
module") appeared to be harmless, it leads to complete failure of drivers b43. 
and b43legacy, and likely affects b44 as well. The problem is that 
CONFIG_SSB_PCIHOST is undefined, which prevents the compilation of the code that 
controls the PCI cores of the device. See 
https://bugzilla.redhat.com/show_bug.cgi?id=1572349 for details.

As the underlying errors ("pcibios_enable_device" undefined, and 
"register_pci_controller" undefined) do not appear on the architectures that I 
have tested (x86_64, x86, and ppc), I suspect something in the arch-specific 
code for your setup (MIPS?). As I have no idea on how to fix that problem, would 
the following patch work for you?

diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index 9371651d8017..3743533c8057 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -117,7 +117,7 @@ config SSB_SERIAL

  config SSB_DRIVER_PCICORE_POSSIBLE
         bool
-       depends on SSB_PCIHOST && SSB = y
+       depends on SSB_PCIHOST && (SSB = y || !MIPS)
         default y

  config SSB_DRIVER_PCICORE

Thanks,

Larry
