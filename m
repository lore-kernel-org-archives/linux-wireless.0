Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:34699 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbbEMScl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2015 14:32:41 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: ming.lei@canonical.com, rusty@rustcorp.com.au
Cc: torvalds@linux-foundation.org, dhowells@redhat.com,
	seth.forshee@canonical.com, linux-kernel@vger.kernel.org,
	pebolle@tiscali.nl, linux-wireless@vger.kernel.org,
	gregkh@linuxfoundation.org, jlee@suse.com, tiwai@suse.de,
	casey@schaufler-ca.com, keescook@chromium.org, mjg59@srcf.ucam.org,
	akpm@linux-foundation.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
	Kyle McMartin <kyle@kernel.org>,
	Bruce Allan <bruce.w.allan@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	John Griffin <john.griffin@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [RFC v2 3/6] crypto: qat - address recursive dependency when fw signing is enabled
Date: Wed, 13 May 2015 11:23:53 -0700
Message-Id: <1431541436-17007-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20150513_203347_824029_CA6854B3)
In-Reply-To: <1431541436-17007-1-git-send-email-mcgrof@do-not-panic.com>
References: <1431541436-17007-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

We're going to add firmware module signing support, but when we do
this we end up with the following recursive dependency. Fix this by
just depending on FW_LOADER, which is typically always enabled
anyway. We do this as a compromise for now as FW_LOADER is only
selectable when EXPERT is enabled and the recursive dependency issue
below is actually real and valid, its proper fix however requires
a bit of work.

This technically means this change is likely welcomed for other
parts of the kernel but this is really only needed for now here.

mcgrof@ergon ~/linux-next (git::master)$ make allnoconfig
scripts/kconfig/conf  --allnoconfig Kconfig
crypto/Kconfig:15:error: recursive dependency detected!
crypto/Kconfig:15:      symbol CRYPTO is selected by SYSDATA_SIG
init/Kconfig:1880:      symbol SYSDATA_SIG is selected by FIRMWARE_SIG
drivers/base/Kconfig:88:        symbol FIRMWARE_SIG depends on FW_LOADER
drivers/base/Kconfig:80:        symbol FW_LOADER is selected by CRYPTO_DEV_QAT
drivers/crypto/qat/Kconfig:1:   symbol CRYPTO_DEV_QAT is selected by CRYPTO_DEV_QAT_DH895xCC
drivers/crypto/qat/Kconfig:13:  symbol CRYPTO_DEV_QAT_DH895xCC depends on CRYPTO

Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Kyle McMartin <kyle@kernel.org>
Cc: Bruce Allan <bruce.w.allan@intel.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: John Griffin <john.griffin@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/crypto/qat/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/Kconfig b/drivers/crypto/qat/Kconfig
index 49bede2..9bea338 100644
--- a/drivers/crypto/qat/Kconfig
+++ b/drivers/crypto/qat/Kconfig
@@ -8,7 +8,7 @@ config CRYPTO_DEV_QAT
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
-	select FW_LOADER
+	depends on FW_LOADER
 
 config CRYPTO_DEV_QAT_DH895xCC
 	tristate "Support for Intel(R) DH895xCC"
-- 
2.3.2.209.gd67f9d5.dirty

