Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37954 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbbEFDeb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 23:34:31 -0400
Date: Wed, 6 May 2015 11:33:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: rusty@rustcorp.com.au, dhowells@redhat.com, ming.lei@canonical.com,
	seth.forshee@canonical.com, kyle@kernel.org,
	akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	keescook@chromium.org, casey@schaufler-ca.com, tiwai@suse.de,
	mjg59@srcf.ucam.org, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org, jlee@suse.com,
	linux-kernel@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Bruce Allan <bruce.w.allan@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	John Griffin <john.griffin@intel.com>
Subject: Re: [PATCH v1 03/12] crypto: qat - address recursive dependency when
 fw signing is enabled
Message-ID: <20150506033330.GA16470@gondor.apana.org.au> (sfid-20150506_053446_618586_894CD27B)
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
 <1430873070-7290-4-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1430873070-7290-4-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 05, 2015 at 05:44:21PM -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> We're going to add firmware module signing support, but when we do
> this we end up with the following recursive dependency. Fix this by
> just depending on FW_LOADER, which is typically always enabled
> anyway.
> 
> mcgrof@ergon ~/linux-next (git::master)$ make allnoconfig
> scripts/kconfig/conf  --allnoconfig Kconfig
> crypto/Kconfig:15:error: recursive dependency detected!
> crypto/Kconfig:15:      symbol CRYPTO is selected by SYSDATA_SIG
> init/Kconfig:1880:      symbol SYSDATA_SIG is selected by FIRMWARE_SIG
> drivers/base/Kconfig:88:        symbol FIRMWARE_SIG depends on FW_LOADER
> drivers/base/Kconfig:80:        symbol FW_LOADER is selected by CRYPTO_DEV_QAT
> drivers/crypto/qat/Kconfig:1:   symbol CRYPTO_DEV_QAT is selected by CRYPTO_DEV_QAT_DH895xCC
> drivers/crypto/qat/Kconfig:13:  symbol CRYPTO_DEV_QAT_DH895xCC depends on CRYPTO

This doesn't look like a real cycle to me so perhaps we can fix
kbuild to understand this?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
