Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36732 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbbEFAxP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 20:53:15 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: rusty@rustcorp.com.au, dhowells@redhat.com, ming.lei@canonical.com,
	seth.forshee@canonical.com, kyle@kernel.org
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	keescook@chromium.org, casey@schaufler-ca.com, tiwai@suse.de,
	mjg59@srcf.ucam.org, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org, jlee@suse.com,
	linux-kernel@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Bruce Allan <bruce.w.allan@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	John Griffin <john.griffin@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v1 03/12] crypto: qat - address recursive dependency when fw signing is enabled
Date: Tue,  5 May 2015 17:44:21 -0700
Message-Id: <1430873070-7290-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20150506_025348_940103_D577363E)
In-Reply-To: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

We're going to add firmware module signing support, but when we do
this we end up with the following recursive dependency. Fix this by
just depending on FW_LOADER, which is typically always enabled
anyway.

mcgrof@ergon ~/linux-next (git::master)$ make allnoconfig
scripts/kconfig/conf  --allnoconfig Kconfig
crypto/Kconfig:15:error: recursive dependency detected!
crypto/Kconfig:15:      symbol CRYPTO is selected by SYSDATA_SIG
init/Kconfig:1880:      symbol SYSDATA_SIG is selected by FIRMWARE_SIG
drivers/base/Kconfig:88:        symbol FIRMWARE_SIG depends on FW_LOADER
drivers/base/Kconfig:80:        symbol FW_LOADER is selected by CRYPTO_DEV_QAT
drivers/crypto/qat/Kconfig:1:   symbol CRYPTO_DEV_QAT is selected by CRYPTO_DEV_QAT_DH895xCC
drivers/crypto/qat/Kconfig:13:  symbol CRYPTO_DEV_QAT_DH895xCC depends on CRYPTO

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

