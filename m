Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:33993 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbbH0CfU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 22:35:20 -0400
Received: by obbfr1 with SMTP id fr1so7695752obb.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2015 19:35:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150826232622.GC8051@wotan.suse.de>
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
	<20150826232622.GC8051@wotan.suse.de>
Date: Wed, 26 Aug 2015 22:35:19 -0400
Message-ID: <CAHC9VhR9z2WVp+Q1hBkr5jduAH-J1DW12-k7U1eaQGgrP4c1Yw@mail.gmail.com> (sfid-20150827_043525_470077_045B9DB6)
Subject: Re: Linux Firmware Signing
From: Paul Moore <paul@paul-moore.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Kees Cook <keescook@chromium.org>,
	"Roberts, William C" <william.c.roberts@intel.com>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	"james.l.morris@oracle.com" <james.l.morris@oracle.com>,
	"serge@hallyn.com" <serge@hallyn.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Eric Paris <eparis@parisplace.org>, selinux@tycho.nsa.gov,
	Stephen Smalley <sds@tycho.nsa.gov>,
	"Schaufler, Casey" <casey.schaufler@intel.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Peter Jones <pjones@redhat.com>, Takashi Iwai <tiwai@suse.de>,
	dwmw2@infradead.org, Ming Lei <ming.lei@canonical.com>,
	Joey Lee <jlee@suse.de>,
	=?UTF-8?B?Vm9qdMSbY2ggUGF2bMOtaw==?= <vojtech@suse.com>,
	Kyle McMartin <kyle@kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 26, 2015 at 7:26 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Wed, Aug 26, 2015 at 03:33:04PM +0100, David Howells wrote:
> Now let's review the SELinux stuff before we jump back into firmware / system
> data stuff again as there is a joint criteria to consider for all of these.
> For other people's refrence the enum you quote above was added through your
> patch pending on linux-next:
>
> "PKCS#7: Appropriately restrict authenticated attributes and content type"
>
> Based on what Roberts seems to want to do for SELinux policy files it would
> seems we may also need VERIFYING_SELINUX_POLICY. SELinux policy loading is
> unique in the at it uses its own fs and uses a load trigger node (sel_load_ops)
> to kick off  security_load_policy(data, count), so its not exactly a
> yet-another-API to read arbitrary files from the file system. Its policy files
> are also very distribution specific. Because of all this its not really
> suitable for /lib/firmware/ or sharing code even futher. It seems its a prime
> candidate already to make use of the system_verify_data() APIs you added David,
> provided the items below are taken care of as well.

One thing to keep in mind is that not only are SELinux policy files
distribution specific, they are machine specific as administrators
can, and do, customize the policy for their usage.  I really like the
idea of providing signed SELinux policies to the kernel but I question
how practical it will be for normal users/admins.

Some of the Machine Owner Key (MOK) work would likely be necessary for
signed SELinux policies to be even remotely practical.

>> Also, do I actually need to label signatures with the name that will be passed
>> to request_firmware()?  Or is it better to do it just by requiring each driver
>> that wants a piece of firmware to hold a key or a reference to a key or a hash
>> for the particular piece of firmware that it wants?  Having a name in the
>> signature at least makes for more readable error messages, but...
>
> I'll chime in, but I'd like other people's feeback as well, in
> particular Andy and Roberts. As it stands, you had this patch which was
> not yet posted, in it you have a named attributes for firmware:
>
> "PKCS#7: Add an optional authenticated attribute to hold firmware name"
> https://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/commit/?h=fwsign-pkcs7&id=1448377a369993f864915743cfb34772e730213good
>
>         1.3.6.1.4.1.2312.16     Linux kernel
>         1.3.6.1.4.1.2312.16.2   - PKCS#7/CMS SignerInfo attribute types
>         1.3.6.1.4.1.2312.16.2.1   - firmwareName
>
> I take it you are referring to this? If we follow this model we'd then need
> something like:
>
>         1.3.6.1.4.1.2312.16.2.2   - seLinuxPolicyName

Assuming I'm understanding the firmwareName attribute idea correctly,
we don't need to worry about that from a SELinux policy point of view.
As others have already stated, the kernel just reads a binary blob
that is pushed into it by userspace using securityfs.

> If the driver specifies the trusted key through its desciptor, as you suggest,
> I do agree we could do away with this. The change here would be that each
> driver that wants firmware signing should opt-in carefully with the key that it
> does trust. Most active vendors would swiftly want to only trust their own key.

See my earlier comments about SELinux policy customization.

> With this model then we would have these options:
>
>   * SYSTEM_DATA_SIG enabled
>
> Enables system data signing, drivers need to be explicit about wanting
> this as well. By default Kyle's key is trusted if the API is used, this
> does require an explicit change to the new API though. Support for signing
> is available but by default its permissive. A kernel parameter exists so
> that upon bootup its in enforced mode. Drivers can still override
> this and *require* the signature always, but if they want that they need to be
> explicit about it on their driver call. They can do this through their own
> Kconfig option or just always have it, up to them.
>
>   * SYSTEM_DATA_SIG_FORCE enabled
>
> Requires all uses of the API to have a trusted key before passing data back.
>
>   * No Kconfig option for SYSTEM_DATA_SIG set
>
> Uses of desc->signature_required will fail to compile, folks will need to
> wrap this descriptor's setting with either SYSTEM_DATA_SIG or their own
> Kconfig option which selects SYSTEM_DATA_SIG.
>
> SELinux could copy this model, they could end up with for instance:
>
>   * SECURITY_SELINUX_POLICY_SIGNED enabled
>
> Enables signature on the policy file. A kernel parameter could kick the
> signature to be required.
>
>   * SECURITY_SELINUX_POLICY_SIGNED_FORCE enabled
>
> The policy files require a signature.
>
> Does this seem fine? If so then ideally we'd want the dynamic OID registry but
> I don't think that's a requirement, for now we could add users as time goes by.
> Other than that, I think we'd need to define the allowed crypto options that can
> be passed to system_verify_data() ? Uptimately this is also what we want to
> enable drivers to fill in through a static descriptor.
>
>   Luis

-- 
paul moore
www.paul-moore.com
