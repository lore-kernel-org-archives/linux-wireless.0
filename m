Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932163AbeCJOPT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 09:15:19 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, cantabile.desu@gmail.com,
        kubakici@wp.pl, linux-wireless@vger.kernel.org,
        keescook@chromium.org, shuah@kernel.org, mfuzzey@parkeon.com,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        pali.rohar@gmail.com, tiwai@suse.de, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        bjorn.andersson@linaro.org, jewalt@lgsinnovations.com,
        oneukum@suse.com, ast@fb.com, andresx7@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v3 04/20] firmware: enable to split firmware_class into separate target files
Date: Sat, 10 Mar 2018 06:14:45 -0800
Message-Id: <20180310141501.2214-5-mcgrof@kernel.org> (sfid-20180310_152119_592230_8990E510)
In-Reply-To: <20180310141501.2214-1-mcgrof@kernel.org>
References: <20180310141501.2214-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware loader code has grown quite a bit over the years.
The practice of stuffing everything we need into one file makes
the code hard to follow.

In order to split the firmware loader code into different components
we must pick a module name and a first object target file. We must
keep the firmware_class name to remain compatible with scripts which
have been relying on the sysfs loader path for years, so the old module
name stays. We can however rename the C file without affecting the
module name.

The firmware_class used to represent the idea that the code was a simple
sysfs firmware loader, provided by the struct class firmware_class.
The sysfs firmware loader used to be the default, today its only the
fallback mechanism.

This only renames the target code then to make emphasis of what the code
does these days. With this change new features can also use a new object
files.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/base/Makefile                                | 1 +
 drivers/base/{firmware_class.c => firmware_loader.c} | 0
 2 files changed, 1 insertion(+)
 rename drivers/base/{firmware_class.c => firmware_loader.c} (100%)

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index e32a52490051..f261143fafbf 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
 obj-$(CONFIG_ISA_BUS_API)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
+firmware_class-objs := firmware_loader.o
 obj-$(CONFIG_NUMA)	+= node.o
 obj-$(CONFIG_MEMORY_HOTPLUG_SPARSE) += memory.o
 ifeq ($(CONFIG_SYSFS),y)
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_loader.c
similarity index 100%
rename from drivers/base/firmware_class.c
rename to drivers/base/firmware_loader.c
-- 
2.16.2
