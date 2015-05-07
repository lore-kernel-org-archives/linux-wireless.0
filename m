Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:59943 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750725AbbEGImZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 04:42:25 -0400
Message-ID: <1430988137.8171.58.camel@x220> (sfid-20150507_104247_592223_FFD6EBB8)
Subject: Re: [PATCH v1 03/12] crypto: qat - address recursive dependency
 when fw signing is enabled
From: Paul Bolle <pebolle@tiscali.nl>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	rusty@rustcorp.com.au, dhowells@redhat.com, ming.lei@canonical.com,
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
Date: Thu, 07 May 2015 10:42:17 +0200
In-Reply-To: <20150506033330.GA16470@gondor.apana.org.au>
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
	 <1430873070-7290-4-git-send-email-mcgrof@do-not-panic.com>
	 <20150506033330.GA16470@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-05-06 at 11:33 +0800, Herbert Xu wrote:
> On Tue, May 05, 2015 at 05:44:21PM -0700, Luis R. Rodriguez wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > We're going to add firmware module signing support, but when we do
> > this we end up with the following recursive dependency. Fix this by
> > just depending on FW_LOADER, which is typically always enabled
> > anyway.
> > 
> > mcgrof@ergon ~/linux-next (git::master)$ make allnoconfig
> > scripts/kconfig/conf  --allnoconfig Kconfig
> > crypto/Kconfig:15:error: recursive dependency detected!
> > crypto/Kconfig:15:      symbol CRYPTO is selected by SYSDATA_SIG
> > init/Kconfig:1880:      symbol SYSDATA_SIG is selected by FIRMWARE_SIG
> > drivers/base/Kconfig:88:        symbol FIRMWARE_SIG depends on FW_LOADER
> > drivers/base/Kconfig:80:        symbol FW_LOADER is selected by CRYPTO_DEV_QAT
> > drivers/crypto/qat/Kconfig:1:   symbol CRYPTO_DEV_QAT is selected by CRYPTO_DEV_QAT_DH895xCC
> > drivers/crypto/qat/Kconfig:13:  symbol CRYPTO_DEV_QAT_DH895xCC depends on CRYPTO
> 
> This doesn't look like a real cycle to me so perhaps we can fix
> kbuild to understand this?

(Dependency circles involving selects still hurt my brain.)

Perhaps Luis should have another look at 02/12. See that patch adds this
Kconfig entry to init/Kconfig:
    config SYSDATA_SIG
	def_bool y
	select SYSTEM_TRUSTED_KEYRING
	select KEYS
	select CRYPTO
	select ASYMMETRIC_KEY_TYPE
	select ASYMMETRIC_PUBLIC_KEY_SUBTYPE
	select PUBLIC_KEY_ALGO_RSA
	select ASN1
	select OID_REGISTRY
	select X509_CERTIFICATE_PARSER

As far as I can see this is not enclosed in anything that adds any
dependencies. So that basically means that SYSDATA_SIG will always be
set, for all architectures (because I think all arches source
init/Kconfig). That should make it a pretty pointless symbol (except for
the fact that it does trigger all those selects).

The same patch also adds
	select SYSDATA_SIG

to the entry for MODULE_SIG. But to me that looks like a nop, because
SYSDATA_SIG will be set anyhow. So, but this is just I guess, the
problem might go away if
	def_bool y

is changed to just
	bool

(Note that I haven't actually tested anything here, and it wouldn't be
the first time my reasoning about Kconfig patches is completely off.)

And, whatever the value of my analysis, adding a Kconfig problem in
02/12 just to fix it in 03/12 is a bit silly. I think the patches should
be squashed if the problem can't be solved any other way.


Paul Bolle

