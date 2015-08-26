Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbbHZX00 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 19:26:26 -0400
Date: Thu, 27 Aug 2015 01:26:22 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Kees Cook <keescook@chromium.org>,
	"Roberts, William C" <william.c.roberts@intel.com>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	"james.l.morris@oracle.com" <james.l.morris@oracle.com>,
	"serge@hallyn.com" <serge@hallyn.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@parisplace.org>, selinux@tycho.nsa.gov,
	Stephen Smalley <sds@tycho.nsa.gov>,
	"Schaufler, Casey" <casey.schaufler@intel.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Peter Jones <pjones@redhat.com>, Takashi Iwai <tiwai@suse.de>,
	dwmw2@infradead.org, Ming Lei <ming.lei@canonical.com>,
	Joey Lee <jlee@suse.de>,
	=?utf-8?Q?Vojt=C4=9Bch_Pavl=C3=ADk?= <vojtech@suse.com>,
	Kyle McMartin <kyle@kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Linux Firmware Signing
Message-ID: <20150826232622.GC8051@wotan.suse.de> (sfid-20150827_012701_426826_FA4028D6)
References: <20150824210234.GI8051@wotan.suse.de>
 <476DC76E7D1DF2438D32BFADF679FC5601057D32@ORSMSX103.amr.corp.intel.com>
 <20150824225713.GJ8051@wotan.suse.de>
 <CAGXu5jLDHCgygaVNHpuvszN6SXNKAjRW83q3-D2ZfRpO4uAmdw@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC5601058E78@ORSMSX103.amr.corp.intel.com>
 <CAGXu5jJuwPfnQhu9u4-90UkmjWTBF_GLpJ7J1VaaT2D0d_-Mhg@mail.gmail.com>
 <1440462367.2737.4.camel@linux.vnet.ibm.com>
 <CALCETrXWBBdOKz-fSdM7YVu_sWQbA3YsHPeZAkRmtj+eawqZGQ@mail.gmail.com>
 <1440464705.2737.36.camel@linux.vnet.ibm.com>
 <14540.1440599584@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <14540.1440599584@warthog.procyon.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 26, 2015 at 03:33:04PM +0100, David Howells wrote:
> Luis R. Rodriguez <mcgrof@suse.com> wrote:
> 
> > But note, we also have kexec_file_load() syscall and an arch specific
> > signature verification feature, arch_kexec_kernel_verify_sig().
> > Sad trombone, no LSM hook and only x86 supports this :(
> 
> It's arch-specific because kexec on x86 has to deal with UEFI, PE and
> Microsoft standards.  As far as I'm aware, there is no kernel image signing on
> other arches - though rumours abound that this may not remain so.  However,
> also as far as I'm aware, only the PE file format defines an in-built signing
> method; ELF does not.

Should it? :) Thanks for the details BTW !

> > > > >> 2) instead of having signature checking happening in distinct places
> > > > >> in kernel module execution path and firmware execution paths, move all
> > > > >> signature checking into a separate minor LSM, which can stack with
> > > > >> whatever other LSM is running. For example, if SELinux wanted to do
> > > > >> its own signature checking, it could.
> >
> > To clarify -- this idea sems from the fact that we can now stack
> > LSMs. That's a *brand spanking new* feature and that opens the door for new
> > optimizations that we could not have done before!
> 
> The LSM stack is just an interface by which things like module loading could
> access things that do signatures rather than doing them directly.
> 
> The tricky bit is working out where to make the split.  Take module loading as
> an example.  We start off with one blob that is the ELF module plus a
> signature.  Should the module loader split off the signature or should it
> leave that to the LSM?  If the latter, do we need to iterate through all
> interested LSMs repeatedly, allowing them to strip their recognised
> signatures, until none of them show further interest?  How do we handle the
> possibility of at some time in the future being given two separate pieces by a
> new interface?

Agreed! Its why I noted, this is super long term. Even though it is IMHO
thinking in the right path forward, its quite a bit of steps ahead of where we
are and we first need to bake firmware / system data / SE Linux policy file
signing before we even start looking at further code sharing or optimizations.
Without proper context some folks might think this needs to happen right away,
*it can't*, we need to do quite a bit more work first.

> > One patch not merged upstream or in linux-next is:
> > 
> > "PKCS#7: Add an optional authenticated attribute to hold firmware name"
> > 
> > https://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/commit/?h=fwsign-pkcs7&id=f5e057ee8ab3596dc39f582882104fa5d6ea9250
> > 
> > This extends sign-file support to insert a PKCS#7 authenticated attribute from
> > where it can be extracted by the kernel. We need to consider if we still need
> > this, I believe Andy suggested this. We may need a similar name attribute for
> > SELinux policy files, we may then also need to extend sign-file support for
> > SELinux policy files as well. Unless of course, SELinux wants to start loading
> > policy files from a /lib/firmware path, but I doubt this. Anyway this name
> > policy requirement is something we need to discuss _now_ for both firmware /
> > system data and I guess now SELinux policy files.
> 
> Indeed.  One thing I have done in my patches is to introduce categorisation of
> what a key is permitted to do and what a signed object is.  I've then
> implemented a policy that controls what keys may be used to verify which
> objects.
> 
> For example, if a key has CA information, it is only allowed to verify other
> keys and isn't permitted to verify modules, firmware, etc..
> 
> However, what categories should be available?  So far, I have:
> 
> 	enum key_being_used_for {
> 		VERIFYING_MODULE_SIGNATURE,
> 		VERIFYING_FIRMWARE_SIGNATURE,
> 		VERIFYING_KEXEC_PE_SIGNATURE,
> 		VERIFYING_KEY_SIGNATURE,
> 		VERIFYING_KEY_SELF_SIGNATURE,
> 		VERIFYING_UNSPECIFIED_SIGNATURE,
> 	};
>
> However, given what Luis is talking about, the 'firmware' category might need
> splitting up - but into what pieces?

Right so this stems from two things:

1) Since we're going to re-use firmware APIs for system data files, we want to
   extend support for other users but also enable them to replace their own
   userspace application, my own goal is to replace CRDA for regulatory.bin
   fetching. One use case then is to enable Kconfig options for these users to let
   them have distro options to require or not signing of their own system data
   files. Since CRDA was optional, so would requiring signature on the target
   file, and this should be available even if a distribution did not require
   firmware signing.

2) I'm told some drivers may want the ability to have their own Kconfig option
   and *really* want firmware signing capabilities ASAP, with their public key
   embedded as part of the build, letting some distros ignore it, but obviously
   with a desire to enable some others to enable this option right away and
   recommend it.

My original approach to firmware signing [0] was to have *one* kconfig option to
let distros either opt-in all firmware signing or disable it. That raised the
question of who would sign all those /lib/firmware files and the obvious choice
was to hope Kyle would as he maintains linux-firmware. Kyle expressed he's
willing to do us that favor but because of 2) it would seem we also want to
have the option to let driver developers customize their crytpo requirements,
that includes the key. That would mean adding more arguments to the request,
and if we want to do that that's best done through the newer API which lets us
tuck that in through a descriptor, rather than extending the series of
arguments we have already and affecting all callers in kernel for the existing
firmware API. So contrary to my original approach [0] of adding system data
APIs later which enables an extensible firmware API *later* and then allowing
customizing crypto preferences / requirements only for 802.11 it seems we
may want that from the start for drivers. This is why I'm now working on
first adding the extensible firmware API, the system data stuff, first,
without any crypto stuff. And later slowly add in the signing stuff.

Since people really interested in firmware signing come from camp 2) above it
would seem we want to *encourage* suppliers of firmware to sign firmware for us
so we know its coming from them, and only as a last resort should we rely on
Kyle's key (no offense Kyle). In fact in retrospect a key with such broad
ability to sign a lot of firmware for the kernel seems like a bad idea now. As
I envision this now then, based on these observations, then each driver would
then just fill in the descriptor with their custom signing requirements. We
want to be explicit about this criteria and want folks who get / upload
firmware to *really* think about this. We can still default to Kyle's key but I
think that should be also an explicit action.

Since keys become very specific then we wouldn't want Intel signing Broadcom's
keys for instance, hell we probably would not want Intel's wireless team with
power to sign Intel's Ethernet driver firmware as well, for instance. Likewise
for 802.11 regulatory data we do not want that key to sign any other data for
the kernel.  Keep this in mind for now, I'll elaborate on that later.

[0] http://lkml.kernel.org/r/1431996325-8840-3-git-send-email-mcgrof@do-not-panic.com

Now let's review the SELinux stuff before we jump back into firmware / system
data stuff again as there is a joint criteria to consider for all of these.
For other people's refrence the enum you quote above was added through your
patch pending on linux-next:

"PKCS#7: Appropriately restrict authenticated attributes and content type"

Based on what Roberts seems to want to do for SELinux policy files it would
seems we may also need VERIFYING_SELINUX_POLICY. SELinux policy loading is
unique in the at it uses its own fs and uses a load trigger node (sel_load_ops)
to kick off  security_load_policy(data, count), so its not exactly a
yet-another-API to read arbitrary files from the file system. Its policy files
are also very distribution specific. Because of all this its not really
suitable for /lib/firmware/ or sharing code even futher. It seems its a prime
candidate already to make use of the system_verify_data() APIs you added David,
provided the items below are taken care of as well.

Other than the enum usage David has a pending patch which is not on linux-next
which interested folks in using system_verify_data() should look at:

"X.509: Restrict the usage of a key based on information in X.509 certificate"
https://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/commit/?h=fwsign-pkcs7&id=1448377a369993f864915743cfb34772e7302137

This extends the OID registry with:

        1.3.6.1.4.1.2312.16     Kernel OIDs
        1.3.6.1.4.1.2312.16.1   - X.509 extendedKeyUsage restriction set
        1.3.6.1.4.1.2312.16.1.1   - Firmware signing only
        1.3.6.1.4.1.2312.16.1.2   - Module signing only
        1.3.6.1.4.1.2312.16.1.3   - Kexecable image signing only

I think we'll need now also these:

        1.3.6.1.4.1.2312.16.1.4   - 802.11 regulatory data
        1.3.6.1.4.1.2312.16.1.5   - SELinux policy signing only

The state of affairs in terms of people intersted in firmware signing wanting
to be more specific about their key usage (item 2 above) seems to imply that we
may want to think carefully before assuming a general board firmware key
should be used (let's say Kyle's) and trusted. That would limit the use of a
broad OID 1.3.6.1.4.1.2312.16.1.1. In fact since the desire of interested folks
seem to be to want to make the keys very specific perhaps we should consider a
way to grow the OID registry dynamically at run time. We don't have support for
that yet.

Users of that then would be:

  * SELinux policy folks
  * 802.11 regulatory
  * Driver vendors who want to customize their firmware signing specification

Would doing this be OK? That would enable the OID registry to grow dynamically
by the driver having to place their requirements only in their driver, instead
of having to extend the registry manually on a specific kernel.

> [Note that the above also allows for non-verification usages.  Keys can be
>  marked with what they're allowed to do out of signing, verifying, encrypting
>  and decrypting and this can be qualified further.]

Thanks that's useful information.

> Also, do I actually need to label signatures with the name that will be passed
> to request_firmware()?  Or is it better to do it just by requiring each driver
> that wants a piece of firmware to hold a key or a reference to a key or a hash
> for the particular piece of firmware that it wants?  Having a name in the
> signature at least makes for more readable error messages, but...

I'll chime in, but I'd like other people's feeback as well, in
particular Andy and Roberts. As it stands, you had this patch which was
not yet posted, in it you have a named attributes for firmware:

"PKCS#7: Add an optional authenticated attribute to hold firmware name"
https://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/commit/?h=fwsign-pkcs7&id=1448377a369993f864915743cfb34772e730213good

        1.3.6.1.4.1.2312.16     Linux kernel
        1.3.6.1.4.1.2312.16.2   - PKCS#7/CMS SignerInfo attribute types
        1.3.6.1.4.1.2312.16.2.1   - firmwareName

I take it you are referring to this? If we follow this model we'd then need
something like:

        1.3.6.1.4.1.2312.16.2.2   - seLinuxPolicyName

That should mean each OID that has different file names would need to be
explicit about and have a similar entry on the registry. I find that pretty
redundant and would like to avoid that if possible.

If the driver specifies the trusted key through its desciptor, as you suggest,
I do agree we could do away with this. The change here would be that each
driver that wants firmware signing should opt-in carefully with the key that it
does trust. Most active vendors would swiftly want to only trust their own key.

With this model then we would have these options:

  * SYSTEM_DATA_SIG enabled

Enables system data signing, drivers need to be explicit about wanting
this as well. By default Kyle's key is trusted if the API is used, this
does require an explicit change to the new API though. Support for signing
is available but by default its permissive. A kernel parameter exists so
that upon bootup its in enforced mode. Drivers can still override
this and *require* the signature always, but if they want that they need to be
explicit about it on their driver call. They can do this through their own
Kconfig option or just always have it, up to them.

  * SYSTEM_DATA_SIG_FORCE enabled

Requires all uses of the API to have a trusted key before passing data back.

  * No Kconfig option for SYSTEM_DATA_SIG set

Uses of desc->signature_required will fail to compile, folks will need to
wrap this descriptor's setting with either SYSTEM_DATA_SIG or their own
Kconfig option which selects SYSTEM_DATA_SIG.

SELinux could copy this model, they could end up with for instance:

  * SECURITY_SELINUX_POLICY_SIGNED enabled

Enables signature on the policy file. A kernel parameter could kick the
signature to be required.

  * SECURITY_SELINUX_POLICY_SIGNED_FORCE enabled

The policy files require a signature.

Does this seem fine? If so then ideally we'd want the dynamic OID registry but
I don't think that's a requirement, for now we could add users as time goes by.
Other than that, I think we'd need to define the allowed crypto options that can
be passed to system_verify_data() ? Uptimately this is also what we want to
enable drivers to fill in through a static descriptor.

  Luis
