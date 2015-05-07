Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:50885 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbbEGRAz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 13:00:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, dhowells@redhat.com,
	ming.lei@canonical.com, seth.forshee@canonical.com, kyle@kernel.org
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	keescook@chromium.org, casey@schaufler-ca.com, tiwai@suse.de,
	mjg59@srcf.ucam.org, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org, jlee@suse.com,
	linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH v1 02/12] kernel: generalize module signing as system data signing
In-Reply-To: <1430873070-7290-3-git-send-email-mcgrof@do-not-panic.com>
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com> <1430873070-7290-3-git-send-email-mcgrof@do-not-panic.com>
Date: Thu, 07 May 2015 10:37:50 +0930
Message-ID: <87vbg58aah.fsf@rustcorp.com.au> (sfid-20150507_190135_090846_21B8B434)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@do-not-panic.com> writes:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>
> This generalizes the module signing code as helpers, we do
> this as we'll later re-use this same code for firmware and
> other system data signing.

Acked-by: Rusty Russell <rusty@rustcorp.com.au> (module parts)

Thanks,
Rusty.

> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Ming Lei <ming.lei@canonical.com>
> Cc: Seth Forshee <seth.forshee@canonical.com>
> Cc: Kyle McMartin <kyle@kernel.org>
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> ---
>  init/Kconfig                                     | 22 ++++---
>  kernel/Makefile                                  |  2 +-
>  kernel/module.c                                  |  4 +-
>  kernel/{module-internal.h => sysdata-internal.h} |  4 +-
>  kernel/{module_signing.c => sysdata_signing.c}   | 76 ++++++++++++------------
>  kernel/system_keyring.c                          |  2 +-
>  6 files changed, 57 insertions(+), 53 deletions(-)
>  rename kernel/{module-internal.h => sysdata-internal.h} (79%)
>  rename kernel/{module_signing.c => sysdata_signing.c} (76%)
>
> diff --git a/init/Kconfig b/init/Kconfig
> index f5dbc6d..862d5ad7 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1769,6 +1769,18 @@ config BASE_SMALL
>  	default 0 if BASE_FULL
>  	default 1 if !BASE_FULL
>  
> +config SYSDATA_SIG
> +	def_bool y
> +	select SYSTEM_TRUSTED_KEYRING
> +	select KEYS
> +	select CRYPTO
> +	select ASYMMETRIC_KEY_TYPE
> +	select ASYMMETRIC_PUBLIC_KEY_SUBTYPE
> +	select PUBLIC_KEY_ALGO_RSA
> +	select ASN1
> +	select OID_REGISTRY
> +	select X509_CERTIFICATE_PARSER
> +
>  menuconfig MODULES
>  	bool "Enable loadable module support"
>  	option modules
> @@ -1842,15 +1854,7 @@ config MODULE_SRCVERSION_ALL
>  config MODULE_SIG
>  	bool "Module signature verification"
>  	depends on MODULES
> -	select SYSTEM_TRUSTED_KEYRING
> -	select KEYS
> -	select CRYPTO
> -	select ASYMMETRIC_KEY_TYPE
> -	select ASYMMETRIC_PUBLIC_KEY_SUBTYPE
> -	select PUBLIC_KEY_ALGO_RSA
> -	select ASN1
> -	select OID_REGISTRY
> -	select X509_CERTIFICATE_PARSER
> +	select SYSDATA_SIG
>  	help
>  	  Check modules for valid signatures upon load: the signature
>  	  is simply appended to the module. For more information see
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 1408b33..e24c9d6 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -45,7 +45,7 @@ endif
>  obj-$(CONFIG_UID16) += uid16.o
>  obj-$(CONFIG_SYSTEM_TRUSTED_KEYRING) += system_keyring.o system_certificates.o
>  obj-$(CONFIG_MODULES) += module.o
> -obj-$(CONFIG_MODULE_SIG) += module_signing.o
> +obj-$(CONFIG_SYSDATA_SIG) += sysdata_signing.o
>  obj-$(CONFIG_KALLSYMS) += kallsyms.o
>  obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
>  obj-$(CONFIG_KEXEC) += kexec.o
> diff --git a/kernel/module.c b/kernel/module.c
> index 23b2b65..eb61c10 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -60,7 +60,7 @@
>  #include <linux/pfn.h>
>  #include <linux/bsearch.h>
>  #include <uapi/linux/module.h>
> -#include "module-internal.h"
> +#include "sysdata-internal.h"
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/module.h>
> @@ -2404,7 +2404,7 @@ static int module_sig_check(struct load_info *info)
>  	    memcmp(mod + info->len - markerlen, MODULE_SIG_STRING, markerlen) == 0) {
>  		/* We truncate the module to discard the signature */
>  		info->len -= markerlen;
> -		err = mod_verify_sig(mod, &info->len);
> +		err = sysdata_verify_sig(mod, &info->len);
>  	}
>  
>  	if (!err) {
> diff --git a/kernel/module-internal.h b/kernel/sysdata-internal.h
> similarity index 79%
> rename from kernel/module-internal.h
> rename to kernel/sysdata-internal.h
> index 915e123..0aa573e 100644
> --- a/kernel/module-internal.h
> +++ b/kernel/sysdata-internal.h
> @@ -1,4 +1,4 @@
> -/* Module internals
> +/* System Data internals
>   *
>   * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
>   * Written by David Howells (dhowells@redhat.com)
> @@ -9,4 +9,4 @@
>   * 2 of the Licence, or (at your option) any later version.
>   */
>  
> -extern int mod_verify_sig(const void *mod, unsigned long *_modlen);
> +extern int sysdata_verify_sig(const void *data, unsigned long *_len);
> diff --git a/kernel/module_signing.c b/kernel/sysdata_signing.c
> similarity index 76%
> rename from kernel/module_signing.c
> rename to kernel/sysdata_signing.c
> index be5b8fa..8ba09aa 100644
> --- a/kernel/module_signing.c
> +++ b/kernel/sysdata_signing.c
> @@ -1,4 +1,4 @@
> -/* Module signature checker
> +/* System Data signature checker
>   *
>   * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
>   * Written by David Howells (dhowells@redhat.com)
> @@ -15,10 +15,10 @@
>  #include <crypto/hash.h>
>  #include <keys/asymmetric-type.h>
>  #include <keys/system_keyring.h>
> -#include "module-internal.h"
> +#include "sysdata-internal.h"
>  
>  /*
> - * Module signature information block.
> + * System Data signature information block.
>   *
>   * The constituents of the signature section are, in order:
>   *
> @@ -27,7 +27,7 @@
>   *	- Signature data
>   *	- Information block
>   */
> -struct module_signature {
> +struct sysdata_signature {
>  	u8	algo;		/* Public-key crypto algorithm [enum pkey_algo] */
>  	u8	hash;		/* Digest algorithm [enum hash_algo] */
>  	u8	id_type;	/* Key identifier type [enum pkey_id_type] */
> @@ -38,11 +38,11 @@ struct module_signature {
>  };
>  
>  /*
> - * Digest the module contents.
> + * Digest the system data contents.
>   */
> -static struct public_key_signature *mod_make_digest(enum hash_algo hash,
> -						    const void *mod,
> -						    unsigned long modlen)
> +static struct public_key_signature *data_make_digest(enum hash_algo hash,
> +						    const void *data,
> +						    unsigned long len)
>  {
>  	struct public_key_signature *pks;
>  	struct crypto_shash *tfm;
> @@ -51,7 +51,7 @@ static struct public_key_signature *mod_make_digest(enum hash_algo hash,
>  	int ret;
>  
>  	pr_devel("==>%s()\n", __func__);
> -	
> +
>  	/* Allocate the hashing algorithm we're going to need and find out how
>  	 * big the hash operational data will be.
>  	 */
> @@ -82,7 +82,7 @@ static struct public_key_signature *mod_make_digest(enum hash_algo hash,
>  	if (ret < 0)
>  		goto error;
>  
> -	ret = crypto_shash_finup(desc, mod, modlen, pks->digest);
> +	ret = crypto_shash_finup(desc, data, len, pks->digest);
>  	if (ret < 0)
>  		goto error;
>  
> @@ -105,8 +105,8 @@ error_no_pks:
>   *
>   * RSA signatures only have one MPI, so currently we only read one.
>   */
> -static int mod_extract_mpi_array(struct public_key_signature *pks,
> -				 const void *data, size_t len)
> +static int data_extract_mpi_array(struct public_key_signature *pks,
> +				  const void *data, size_t len)
>  {
>  	size_t nbytes;
>  	MPI mpi;
> @@ -161,7 +161,7 @@ static struct key *request_asymmetric_key(const char *signer, size_t signer_len,
>  	key = keyring_search(make_key_ref(system_trusted_keyring, 1),
>  			     &key_type_asymmetric, id);
>  	if (IS_ERR(key))
> -		pr_warn("Request for unknown module key '%s' err %ld\n",
> +		pr_warn("Request for unknown system data key '%s' err %ld\n",
>  			id, PTR_ERR(key));
>  	kfree(id);
>  
> @@ -182,58 +182,58 @@ static struct key *request_asymmetric_key(const char *signer, size_t signer_len,
>  }
>  
>  /*
> - * Verify the signature on a module.
> + * Verify the signature on system data.
>   */
> -int mod_verify_sig(const void *mod, unsigned long *_modlen)
> +int sysdata_verify_sig(const void *data, unsigned long *_len)
>  {
>  	struct public_key_signature *pks;
> -	struct module_signature ms;
> +	struct sysdata_signature ds;
>  	struct key *key;
>  	const void *sig;
> -	size_t modlen = *_modlen, sig_len;
> +	size_t len = *_len, sig_len;
>  	int ret;
>  
> -	pr_devel("==>%s(,%zu)\n", __func__, modlen);
> +	pr_devel("==>%s(,%zu)\n", __func__, len);
>  
> -	if (modlen <= sizeof(ms))
> +	if (len <= sizeof(ds))
>  		return -EBADMSG;
>  
> -	memcpy(&ms, mod + (modlen - sizeof(ms)), sizeof(ms));
> -	modlen -= sizeof(ms);
> +	memcpy(&ds, data + (len - sizeof(ds)), sizeof(ds));
> +	len -= sizeof(ds);
>  
> -	sig_len = be32_to_cpu(ms.sig_len);
> -	if (sig_len >= modlen)
> +	sig_len = be32_to_cpu(ds.sig_len);
> +	if (sig_len >= len)
>  		return -EBADMSG;
> -	modlen -= sig_len;
> -	if ((size_t)ms.signer_len + ms.key_id_len >= modlen)
> +	len -= sig_len;
> +	if ((size_t)ds.signer_len + ds.key_id_len >= len)
>  		return -EBADMSG;
> -	modlen -= (size_t)ms.signer_len + ms.key_id_len;
> +	len -= (size_t)ds.signer_len + ds.key_id_len;
>  
> -	*_modlen = modlen;
> -	sig = mod + modlen;
> +	*_len = len;
> +	sig = data + len;
>  
>  	/* For the moment, only support RSA and X.509 identifiers */
> -	if (ms.algo != PKEY_ALGO_RSA ||
> -	    ms.id_type != PKEY_ID_X509)
> +	if (ds.algo != PKEY_ALGO_RSA ||
> +	    ds.id_type != PKEY_ID_X509)
>  		return -ENOPKG;
>  
> -	if (ms.hash >= PKEY_HASH__LAST ||
> -	    !hash_algo_name[ms.hash])
> +	if (ds.hash >= PKEY_HASH__LAST ||
> +	    !hash_algo_name[ds.hash])
>  		return -ENOPKG;
>  
> -	key = request_asymmetric_key(sig, ms.signer_len,
> -				     sig + ms.signer_len, ms.key_id_len);
> +	key = request_asymmetric_key(sig, ds.signer_len,
> +				     sig + ds.signer_len, ds.key_id_len);
>  	if (IS_ERR(key))
>  		return PTR_ERR(key);
>  
> -	pks = mod_make_digest(ms.hash, mod, modlen);
> +	pks = data_make_digest(ds.hash, data, len);
>  	if (IS_ERR(pks)) {
>  		ret = PTR_ERR(pks);
>  		goto error_put_key;
>  	}
>  
> -	ret = mod_extract_mpi_array(pks, sig + ms.signer_len + ms.key_id_len,
> -				    sig_len);
> +	ret = data_extract_mpi_array(pks, sig + ds.signer_len + ds.key_id_len,
> +				     sig_len);
>  	if (ret < 0)
>  		goto error_free_pks;
>  
> @@ -246,5 +246,5 @@ error_free_pks:
>  error_put_key:
>  	key_put(key);
>  	pr_devel("<==%s() = %d\n", __func__, ret);
> -	return ret;	
> +	return ret;
>  }
> diff --git a/kernel/system_keyring.c b/kernel/system_keyring.c
> index 875f64e..1eb0c86 100644
> --- a/kernel/system_keyring.c
> +++ b/kernel/system_keyring.c
> @@ -16,7 +16,7 @@
>  #include <linux/err.h>
>  #include <keys/asymmetric-type.h>
>  #include <keys/system_keyring.h>
> -#include "module-internal.h"
> +#include "sysdata-internal.h"
>  
>  struct key *system_trusted_keyring;
>  EXPORT_SYMBOL_GPL(system_trusted_keyring);
> -- 
> 2.3.2.209.gd67f9d5.dirty
