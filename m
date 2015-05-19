Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51301 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbbESWTE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 18:19:04 -0400
Date: Wed, 20 May 2015 00:19:02 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Andy Lutomirski <luto@kernel.org>
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
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
Message-ID: <20150519221902.GQ23057@wotan.suse.de> (sfid-20150520_001923_689857_ACE2D692)
References: <20150519200232.GM23057@wotan.suse.de>
 <1432072117.4510.180.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1432072117.4510.180.camel@linux.vnet.ibm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2015 at 05:48:37PM -0400, Mimi Zohar wrote:
> On Tue, 2015-05-19 at 22:02 +0200, Luis R. Rodriguez wrote:
> > David Howells has posted v4 of his series of supporting PKCS#7 for module
> > signing. I'm in my v3 series now on RFCs for firmware PKCS#7 support, and after
> > some review and patch shuffling I think this is ready for patch form.  My own
> > series however depend on quite a bit of other pending changes, one series which
> > will go through Rusty's tree, another series of fixes on firmware_class which
> > should go through Greg's tree. I'll wait until all this and David's own patches
> > get merged before posting firmware PKCS#7 support. Before all this though in
> > preparation for fw signing one thing we should start to talk about more broadly
> > however is how linux-firmware binary file signing would work in practice and
> > what we need, and make sure folks are OK with all this.
> 
> Commit 13752fe "security: introduce kernel_fw_from_file hook" introduced
> a new security hook.  (IMA is on this hook as well.)  Have you
> considered using this hook?

Yes, the same hook is used here.

> Are there other places that this hook would need to be called?

Nope, it'd be called. Folks who do not want to use key signing stuff can use
their own preferred LSM hook just as module signing has the kernel module
signing infrastructure but also module LSM hooks. It'd be similar here for
firmware.

Now that we have LSM hooks stacked on the way perhaps this is more in line with
what Andy has envisioned for alternatives for module signature verification.
But then again since an LSM hook already exists for both modules and firmware
perhaps this is sufficient for what Andy envisions? That is if folks do not want
this signing thing just disable it and add use your preferred LSM module of choice?

Now granted -- if we envision this module signing infrastructure as an LSM hook
in and of itself perhaps we should LSM'ify it. Its not right now.

> > I think we need one change here, we'd need to ensure that such key could only
> > be used for vetting firmware files, not modules loaded.  The firmware_class
> > could for instance still use all the keys in system_trusted_keyring, which
> > would include the UEFI key db, but it does not seems reasonable to expect keys
> > used for fw signing to also go into system_trusted_keyring to also be used for
> > module signing.
> 
> I agree totally!  For this reason, IMA defined a separate trusted
> keyring to be used for verifying file signatures.

OK I'll add that to my TODO list here.

  Luis
