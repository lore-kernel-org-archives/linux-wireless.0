Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:50363 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbbESVst (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 17:48:49 -0400
Received: from /spool/local
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-wireless@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Wed, 20 May 2015 03:18:47 +0530
Message-ID: <1432072117.4510.180.camel@linux.vnet.ibm.com> (sfid-20150519_234907_113132_84CCA78C)
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: linux-security-module@vger.kernel.org, james.l.morris@oracle.com,
	serge@hallyn.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	mricon@kernel.org, Kees Cook <keescook@chromium.org>
Date: Tue, 19 May 2015 17:48:37 -0400
In-Reply-To: <20150519200232.GM23057@wotan.suse.de>
References: <20150519200232.GM23057@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-05-19 at 22:02 +0200, Luis R. Rodriguez wrote:
> David Howells has posted v4 of his series of supporting PKCS#7 for module
> signing. I'm in my v3 series now on RFCs for firmware PKCS#7 support, and after
> some review and patch shuffling I think this is ready for patch form.  My own
> series however depend on quite a bit of other pending changes, one series which
> will go through Rusty's tree, another series of fixes on firmware_class which
> should go through Greg's tree. I'll wait until all this and David's own patches
> get merged before posting firmware PKCS#7 support. Before all this though in
> preparation for fw signing one thing we should start to talk about more broadly
> however is how linux-firmware binary file signing would work in practice and
> what we need, and make sure folks are OK with all this.

Commit 13752fe "security: introduce kernel_fw_from_file hook" introduced
a new security hook.  (IMA is on this hook as well.)  Have you
considered using this hook?
Are there other places that this hook would need to be called?

> I think we need one change here, we'd need to ensure that such key could only
> be used for vetting firmware files, not modules loaded.  The firmware_class
> could for instance still use all the keys in system_trusted_keyring, which
> would include the UEFI key db, but it does not seems reasonable to expect keys
> used for fw signing to also go into system_trusted_keyring to also be used for
> module signing.

I agree totally!  For this reason, IMA defined a separate trusted
keyring to be used for verifying file signatures.

Mimi

> Other than this last nitpick, any other concerns or recommendations ?
> 
> [0] https://wireless.wiki.kernel.org/en/developers/regulatory/crda
> 
>   Luis


