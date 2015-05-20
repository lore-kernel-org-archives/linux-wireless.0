Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:34479 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbbETAXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 20:23:20 -0400
MIME-Version: 1.0
In-Reply-To: <1432078625.4510.207.camel@linux.vnet.ibm.com>
References: <20150519200232.GM23057@wotan.suse.de> <1432072117.4510.180.camel@linux.vnet.ibm.com>
 <20150519221902.GQ23057@wotan.suse.de> <1432078625.4510.207.camel@linux.vnet.ibm.com>
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Tue, 19 May 2015 17:22:59 -0700
Message-ID: <CAB=NE6WZ8YW=C7a=MWgMS4T6Nmgs1NcKKsUY6XPtPC9B4JZu=Q@mail.gmail.com> (sfid-20150520_022325_475631_CC412269)
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Casey Schaufler <casey@schaufler-ca.com>
Cc: Andy Lutomirski <luto@kernel.org>,
	linux-security-module <linux-security-module@vger.kernel.org>,
	James Morris <james.l.morris@oracle.com>, serge@hallyn.com,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Howells <dhowells@redhat.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>,
	Konstantin Ryabitsev <mricon@kernel.org>,
	Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2015 at 4:37 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Wed, 2015-05-20 at 00:19 +0200, Luis R. Rodriguez wrote:
>> On Tue, May 19, 2015 at 05:48:37PM -0400, Mimi Zohar wrote:
>> > On Tue, 2015-05-19 at 22:02 +0200, Luis R. Rodriguez wrote:
>> > > David Howells has posted v4 of his series of supporting PKCS#7 for module
>> > > signing. I'm in my v3 series now on RFCs for firmware PKCS#7 support, and after
>> > > some review and patch shuffling I think this is ready for patch form.  My own
>> > > series however depend on quite a bit of other pending changes, one series which
>> > > will go through Rusty's tree, another series of fixes on firmware_class which
>> > > should go through Greg's tree. I'll wait until all this and David's own patches
>> > > get merged before posting firmware PKCS#7 support. Before all this though in
>> > > preparation for fw signing one thing we should start to talk about more broadly
>> > > however is how linux-firmware binary file signing would work in practice and
>> > > what we need, and make sure folks are OK with all this.
>> >
>> > Commit 13752fe "security: introduce kernel_fw_from_file hook" introduced
>> > a new security hook.  (IMA is on this hook as well.)  Have you
>> > considered using this hook?
>>
>> Yes, the same hook is used here.
>>
>> > Are there other places that this hook would need to be called?
>>
>> Nope, it'd be called. Folks who do not want to use key signing stuff can use
>> their own preferred LSM hook just as module signing has the kernel module
>> signing infrastructure but also module LSM hooks. It'd be similar here for
>> firmware.
>
> When the kernel module signing signature verification was upstreamed,
> Rusty was not aware of IMA-appraisal -
> https://lkml.org/lkml/2013/1/22/20

Rusty also just told David that PKCS#7 support changes do not need his
Acked-by and do not need to go through his tree as they do not touch
module.[ch]:

https://lkml.org/lkml/2015/5/15/865

So -- your quote does not mean that  module signature code moving to
PKCS#7 will not go in to the kernel. If you'd like to chime in on that
topic I suggest you express your concerns there on that ongoing
thread.

> In this case, not only is there a
> security hook, but the IMA hook exists as well.  To appraise firmware,
> add a line to the IMA policy containing "appraise func=FIRMWARE_CHECK".
> Similarly, to add a measurement to the measurement list, add a line to
> the IMA policy containing "measure func=FIRMWAE_CHECK".

I have a series of reasons find IMA unsuitable for the current goals at hand:

  1) IMA is a pretty big kitchen sink, we want this to work well for
even embedded systems, or architectures that do not have or require
TPMs
  2) The appraisal is also done for to account for a specific state of
affairs, you appraise to the user of the integrity of the system at a
specific point in time, firmware signing can provide integrity /
authorship vetting of files directly from the authors. In the case of
regulatory.bin that was the whole point of it, and firmware signing as
is being provided is intended to generalize that but by sharing code
in-kernel with module signing infrastructure

I am in hopes some others might be able to chime in more on point 2) here.

Don't get me wrong IMA is nice, but its a big chunky requirement to
have, more than what module signing provides and what it requires
today to replace subsystem file signing requirements.

Now, LSM hooks -- that's more aligned with something we can start IMHO
reasonably arguing we should shift module signing code to be punted
into. But I've heard stories of LSM having issues with some virtual
environments, and LSM stacking is also pretty new, and IMHO that'd be
one way to compartmentalize all this module signing code. IMHO that
*should happen* but can only be taken seriously once LSM stacking is
merged in and baked. Its not, but I'm excited for it.

>> Now that we have LSM hooks stacked on the way perhaps this is more in line with
>> what Andy has envisioned for alternatives for module signature verification.
>> But then again since an LSM hook already exists for both modules and firmware
>> perhaps this is sufficient for what Andy envisions? That is if folks do not want
>> this signing thing just disable it and add use your preferred LSM module of choice?
>>
>> Now granted -- if we envision this module signing infrastructure as an LSM hook
>> in and of itself perhaps we should LSM'ify it. Its not right now.
>>
>> > > I think we need one change here, we'd need to ensure that such key could only
>> > > be used for vetting firmware files, not modules loaded.  The firmware_class
>> > > could for instance still use all the keys in system_trusted_keyring, which
>> > > would include the UEFI key db, but it does not seems reasonable to expect keys
>> > > used for fw signing to also go into system_trusted_keyring to also be used for
>> > > module signing.
>> >
>> > I agree totally!  For this reason, IMA defined a separate trusted
>> > keyring to be used for verifying file signatures.
>>
>> OK I'll add that to my TODO list here.
>
> You'll probably want to create a new trusted firmware keyring.

Sure

>  By trusted, only signed keys by a key on the system_keyring can be added to
> the.ima keyring.

If we go with IMA, I however do not think this would be appropriate
and overkill at this point in time.

> Using the "ca_keys" boot command line option a specific key on the system keyring can be specified.

Likewise.

 Luis
