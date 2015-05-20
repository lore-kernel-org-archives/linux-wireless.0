Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:46625 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbbETBIC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 21:08:02 -0400
Received: from /spool/local
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-wireless@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Wed, 20 May 2015 11:07:59 +1000
Message-ID: <1432084019.4510.242.camel@linux.vnet.ibm.com> (sfid-20150520_030823_568981_B8524547)
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Andy Lutomirski <luto@kernel.org>,
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
Date: Tue, 19 May 2015 21:06:59 -0400
In-Reply-To: <CAB=NE6WZ8YW=C7a=MWgMS4T6Nmgs1NcKKsUY6XPtPC9B4JZu=Q@mail.gmail.com>
References: <20150519200232.GM23057@wotan.suse.de>
	 <1432072117.4510.180.camel@linux.vnet.ibm.com>
	 <20150519221902.GQ23057@wotan.suse.de>
	 <1432078625.4510.207.camel@linux.vnet.ibm.com>
	 <CAB=NE6WZ8YW=C7a=MWgMS4T6Nmgs1NcKKsUY6XPtPC9B4JZu=Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-05-19 at 17:22 -0700, Luis R. Rodriguez wrote:
> On Tue, May 19, 2015 at 4:37 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Wed, 2015-05-20 at 00:19 +0200, Luis R. Rodriguez wrote:
> >> On Tue, May 19, 2015 at 05:48:37PM -0400, Mimi Zohar wrote:
> >> > On Tue, 2015-05-19 at 22:02 +0200, Luis R. Rodriguez wrote:

> > In this case, not only is there a
> > security hook, but the IMA hook exists as well.  To appraise firmware,
> > add a line to the IMA policy containing "appraise func=FIRMWARE_CHECK".
> > Similarly, to add a measurement to the measurement list, add a line to
> > the IMA policy containing "measure func=FIRMWAE_CHECK".
> 
> I have a series of reasons find IMA unsuitable for the current goals at hand:
> 
>   1) IMA is a pretty big kitchen sink, we want this to work well for
> even embedded systems, or architectures that do not have or require
> TPMs

There are different aspects to IMA.  One aspect is collecting file
measurements and extending the TPM with those measurements.  The other
aspect is appraising file integrity.  For that aspect, IMA-appraisal
does not use a TPM.

>   2) The appraisal is also done for to account for a specific state of
> affairs, you appraise to the user of the integrity of the system at a
> specific point in time,

True, IMA can be used to attest to the integrity of a system.

>  firmware signing can provide integrity /
> authorship vetting of files directly from the authors. 

It can also be used to appraise the integrity of a file, be it an
executable, a kernel module, configuration file or firmware in a
consistent manor, based on a file hash or signature.

> In the case of
> regulatory.bin that was the whole point of it, and firmware signing as
> is being provided is intended to generalize that but by sharing code
> in-kernel with module signing infrastructure

The underlying code used to verify the file signatures is the same.
The difference being where/how the file signatures are stored and which
keys to trust.   

> I am in hopes some others might be able to chime in more on point 2) here.
> 
> Don't get me wrong IMA is nice, but its a big chunky requirement to
> have, more than what module signing provides and what it requires
> today to replace subsystem file signing requirements.

> Now, LSM hooks -- that's more aligned with something we can start IMHO
> reasonably arguing we should shift module signing code to be punted
> into. But I've heard stories of LSM having issues with some virtual
> environments, and LSM stacking is also pretty new, and IMHO that'd be
> one way to compartmentalize all this module signing code. IMHO that
> *should happen* but can only be taken seriously once LSM stacking is
> merged in and baked. Its not, but I'm excited for it.

Have you even looked at IMA-appraisal?

> >> Now that we have LSM hooks stacked on the way perhaps this is more in line with
> >> what Andy has envisioned for alternatives for module signature verification.
> >> But then again since an LSM hook already exists for both modules and firmware
> >> perhaps this is sufficient for what Andy envisions? That is if folks do not want
> >> this signing thing just disable it and add use your preferred LSM module of choice?
> >>
> >> Now granted -- if we envision this module signing infrastructure as an LSM hook
> >> in and of itself perhaps we should LSM'ify it. Its not right now.
> >>
> >> > > I think we need one change here, we'd need to ensure that such key could only
> >> > > be used for vetting firmware files, not modules loaded.  The firmware_class
> >> > > could for instance still use all the keys in system_trusted_keyring, which
> >> > > would include the UEFI key db, but it does not seems reasonable to expect keys
> >> > > used for fw signing to also go into system_trusted_keyring to also be used for
> >> > > module signing.
> >> >
> >> > I agree totally!  For this reason, IMA defined a separate trusted
> >> > keyring to be used for verifying file signatures.
> >>
> >> OK I'll add that to my TODO list here.
> >
> > You'll probably want to create a new trusted firmware keyring.
> 
> Sure
> 
> >  By trusted, only signed keys by a key on the system_keyring can be added to
> > the.ima keyring.
> 
> If we go with IMA, I however do not think this would be appropriate
> and overkill at this point in time.

> > Using the "ca_keys" boot command line option a specific key on the system keyring can be specified.
> 
> Likewise.

Then on what basis will keys be added to the firmware keyring?

Mimi

