Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:48474 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbbESXiH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 19:38:07 -0400
Received: from /spool/local
	by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-wireless@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Wed, 20 May 2015 09:38:05 +1000
Message-ID: <1432078625.4510.207.camel@linux.vnet.ibm.com> (sfid-20150520_013823_552763_9E4CF1F6)
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Andy Lutomirski <luto@kernel.org>,
	linux-security-module@vger.kernel.org, james.l.morris@oracle.com,
	serge@hallyn.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	mricon@kernel.org, Kees Cook <keescook@chromium.org>
Date: Tue, 19 May 2015 19:37:05 -0400
In-Reply-To: <20150519221902.GQ23057@wotan.suse.de>
References: <20150519200232.GM23057@wotan.suse.de>
	 <1432072117.4510.180.camel@linux.vnet.ibm.com>
	 <20150519221902.GQ23057@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-05-20 at 00:19 +0200, Luis R. Rodriguez wrote:
> On Tue, May 19, 2015 at 05:48:37PM -0400, Mimi Zohar wrote:
> > On Tue, 2015-05-19 at 22:02 +0200, Luis R. Rodriguez wrote:
> > > David Howells has posted v4 of his series of supporting PKCS#7 for module
> > > signing. I'm in my v3 series now on RFCs for firmware PKCS#7 support, and after
> > > some review and patch shuffling I think this is ready for patch form.  My own
> > > series however depend on quite a bit of other pending changes, one series which
> > > will go through Rusty's tree, another series of fixes on firmware_class which
> > > should go through Greg's tree. I'll wait until all this and David's own patches
> > > get merged before posting firmware PKCS#7 support. Before all this though in
> > > preparation for fw signing one thing we should start to talk about more broadly
> > > however is how linux-firmware binary file signing would work in practice and
> > > what we need, and make sure folks are OK with all this.
> > 
> > Commit 13752fe "security: introduce kernel_fw_from_file hook" introduced
> > a new security hook.  (IMA is on this hook as well.)  Have you
> > considered using this hook?
> 
> Yes, the same hook is used here.
> 
> > Are there other places that this hook would need to be called?
> 
> Nope, it'd be called. Folks who do not want to use key signing stuff can use
> their own preferred LSM hook just as module signing has the kernel module
> signing infrastructure but also module LSM hooks. It'd be similar here for
> firmware.

When the kernel module signing signature verification was upstreamed,
Rusty was not aware of IMA-appraisal -
https://lkml.org/lkml/2013/1/22/20  In this case, not only is there a
security hook, but the IMA hook exists as well.  To appraise firmware,
add a line to the IMA policy containing "appraise func=FIRMWARE_CHECK".
Similarly, to add a measurement to the measurement list, add a line to
the IMA policy containing "measure func=FIRMWAE_CHECK". 

> Now that we have LSM hooks stacked on the way perhaps this is more in line with
> what Andy has envisioned for alternatives for module signature verification.
> But then again since an LSM hook already exists for both modules and firmware
> perhaps this is sufficient for what Andy envisions? That is if folks do not want
> this signing thing just disable it and add use your preferred LSM module of choice?
> 
> Now granted -- if we envision this module signing infrastructure as an LSM hook
> in and of itself perhaps we should LSM'ify it. Its not right now.
> 
> > > I think we need one change here, we'd need to ensure that such key could only
> > > be used for vetting firmware files, not modules loaded.  The firmware_class
> > > could for instance still use all the keys in system_trusted_keyring, which
> > > would include the UEFI key db, but it does not seems reasonable to expect keys
> > > used for fw signing to also go into system_trusted_keyring to also be used for
> > > module signing.
> > 
> > I agree totally!  For this reason, IMA defined a separate trusted
> > keyring to be used for verifying file signatures.
> 
> OK I'll add that to my TODO list here.

You'll probably want to create a new trusted firmware keyring.   By
trusted, only signed keys by a key on the system_keyring can be added to
the.ima keyring.  Using the "ca_keys" boot command line option a
specific key on the system keyring can be specified.

Mimi

