Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54029 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750750AbeENT24 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 15:28:56 -0400
Date: Mon, 14 May 2018 19:28:53 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Harald Hoyer <harald@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jessica Yu <jeyu@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Peter Jones <pjones@redhat.com>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>,
        David Howells <dhowells@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-integrity@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andres Rodriguez <andresx7@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 3/6] firmware: differentiate between signed regulatory.db
 and other firmware
Message-ID: <20180514192853.GM27853@wotan.suse.de> (sfid-20180514_212913_593532_FB487206)
References: <20180509191508.GR27853@wotan.suse.de>
 <1525895838.3551.247.camel@linux.vnet.ibm.com>
 <20180509212212.GX27853@wotan.suse.de>
 <1525903617.3551.281.camel@linux.vnet.ibm.com>
 <20180509234814.GY27853@wotan.suse.de>
 <1525917658.3551.322.camel@linux.vnet.ibm.com>
 <20180510232639.GF27853@wotan.suse.de>
 <1526014826.3414.46.camel@linux.vnet.ibm.com>
 <20180511215250.GJ27853@wotan.suse.de>
 <1526302692.3898.145.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1526302692.3898.145.camel@linux.vnet.ibm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 14, 2018 at 08:58:12AM -0400, Mimi Zohar wrote:
> On Fri, 2018-05-11 at 21:52 +0000, Luis R. Rodriguez wrote:
> > diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
> > index eb34089e4299..d7cdf04a8681 100644
> > --- a/drivers/base/firmware_loader/main.c
> > +++ b/drivers/base/firmware_loader/main.c
> > @@ -318,6 +318,11 @@ fw_get_filesystem_firmware(struct device *device, struct fw_priv *fw_priv)
> >                         break;
> >                 }
> > 
> > +#ifdef CONFIG_CFG80211_REQUIRE_SIGNED_REGDB
> > +               if ((strcmp(fw_priv->fw_name, "regulatory.db") == 0) ||
> > +                   (strcmp(fw_priv->fw_name, "regulatory.db.p7s") == 0))
> > +                       id = READING_FIRMWARE_REGULATORY_DB;
> > +#endif
> >                 fw_priv->size = 0;
> >                 rc = kernel_read_file_from_path(path, &fw_priv->data, &size,
> >                                                 msize, id);
> > 
> > This is eye-soring, and in turn would mean adding yet more #ifdefs for any
> > code on the kernel which open codes other firmware signing efforts with
> > its own kconfig...
> 
> Agreed, adding ifdef's is ugly.  As previously discussed, this code
> will be removed.
> 
> To coordinate the signature verification, at build time either regdb
> or IMA-appraisal firmware will be enabled. 

But not both, right?

> At runtime, in the case
> that regdb is enabled and a custom policy requires IMA-appraisal
> firmware signature verification, then both signature verification
> methods will verify the signatures.  If either fails, then the
> signature verification will fail.

OK so you're saying that if CONFIG_IMA_APPRAISE_FIRMWARE is disabled you can
still end up with CONFIG_CFG80211_REQUIRE_SIGNED_REGDB as enabled *and* a
custom policy which requires IMA-appraisal for the certain firmware signature
verifications?

> > Then as for my concern on extending and adding new READING_* ID tags
> > for other future open-coded firmware calls, since:
> > 
> > a) You seem to be working on  a CONFIG_IMA_APPRAISE_FIRMWARE which would
> > enable similar functionality as firmware signing but in userspace.
> 
> There are a number of different builtin policies.  The "secure_boot"
> builtin policy enables file signature verification for firmware,
> kernel modules, kexec'ed image, and the IMA policy, but builtin
> policies are enabled on the boot command line.
> 
> There are two problems:
> - there's no way of configuring a builtin policy to verify firmware
> signatures.

I'm not too familiar with IMA however it sounds like you can extend the IMA
built-in policy on the boot command line. If so I'll note MODULE_FIRMWARE()
macro is typically used to annotate firmware description -- not all drivers use
this though for a few reasons, for instance once is that some names are
constructed dynamically at run time. Consider how some drivers rev firmware
with versions, and as they do this they want to keep certain features only for
certain firmware versions. Despite this lack of a direct 1-1 mapping for all
firmwares needed, I *believe* one current use case for this macro is to extract
required firmwares needed on early boot so they can be stashed into the
initramfs if you have these modules enabled on the initramfs. Dracut folks
can confirm but -- dracut *seems* broken then given the semantic gap I
mentioned above.

dracut-init.sh:    for _fw in $(modinfo -k $kernel -F firmware $1 2>/dev/null); do

If I read this correctly this just complains if the firmware file is
missing if the module is installed on initramfs and the firmware file
is not present. If so we have a current semantic gap and modules with
dynamic names are not handled. And its unclear which modules would be
affected. This is a not a big issue for dracut though since not all drivers
strive to be included on initramfs, unless their storage I suppose -- not
sure how common these storage drivers are for initramfs with dynamic firmware
names which do *not* use MODULE_FIRMWARE().

While the idea of MODULE_FIRMWARE() may need to be given some love or adjusted
to incorporate globs / regexps to fix this existing gap, or we come up with
something more reliable, if fixed, it in theory could end up being re-used to
enable you to extract and build policies for firmware signing at build time...

> - CONFIG_IMA_APPRAISE is not fine enough grained.
> 
> The CONFIG_IMA_APPRAISE_FIRMWARE will be a Kconfig option.  Similar
> Kconfig options will require kernel modules, kexec'ed image, and the
> IMA policy to be signed.

Sure, it is still unclear to me if CONFIG_IMA_APPRAISE_FIRMWARE will be
doing firmware verification in userspace or in the kernel.

> With this, option "d", below, will be possible.

nit: To be clear I was not stating options, I was stating premises to
justify my recommendations.

> > b) CONFIG_CFG80211_REQUIRE_SIGNED_REGDB was added to replace needing
> > CRDA, with an in-kernel interface. CRDA just did a signature check on
> > the regulatory.bin prior to tossing regulatory data over the kernel.
> > 
> > c) We've taken a position to *not* implement generic firmware singing
> > upstream in light of the fact that UEFI has pushed hw manufacturers
> > to implement FW singing in hardware, and for devices outside of these
> > we're happy to suggest IMA use.
> 
> There are a number of reasons that the kernel should be verifying
> firmware signatures (eg. requiring a specific version of the firmware,
> that was locally signed).

Oh I agree, Linux enterprise distributions also have a strong reason to
have this, so that for instance we only trust and run vendor-approved
signed firmware. Otherwise the driver should reject the firmware. Every
now and then enterprise distros may run into cases were certain customers
may run oddball firmwares, and its unclear if we expect proper functionality
with that firmware. Having some form of firmware signing would help with
this pipeline, but this is currently dealt with at the packaging, and
noting other than logs ensures the driver is using an intended firmware.
But these needs *IMHO* have not been enough to push to generalize a kernel
firmware signing facility.

If CONFIG_IMA_APPRAISE_FIRMWARE is going to provide this functionality somehow
I'm happy to hear it.

> > d) It may be possible to have CONFIG_CFG80211_REQUIRE_SIGNED_REGDB
> > depend on !CONFIG_IMA_APPRAISE_FIRMWARE this way we'd take a policy
> > that CONFIG_IMA_APPRAISE_FIRMWARE replaces in-kernel open coded
> > firmware singing facilities
> > 
> > Then I think it makes sense to adapt a policy of being *very careful* allowing
> > future open coded firmware signing efforts such as
> > CONFIG_CFG80211_REQUIRE_SIGNED_REGDB, and recommend folks to do work for things
> > like this through IMA with CONFIG_IMA_APPRAISE_FIRMWARE. This would limit our
> > needs to extend READING_* ID tags for new open coded firmwares.
> > 
> > Then as for the eye-sore you added for CONFIG_CFG80211_REQUIRE_SIGNED_REGDB,
> > in light of all this, I accept we have no other way to deal with it but with
> > #ifdefs.. however it could be dealt with, as helpers where if
> > CONFIG_CFG80211_REQUIRE_SIGNED_REGDB is not set we just set the id to
> > READING_FIRMWARE, ie, just keep the #ifdefs out of the actual code we read.
> 
> Assuming you agree with either REGDB or IMA-appraisal firmware being
> configured at build, but allowing a custom policy to require firmware
> signature verification based on IMA-appraisal at runtime, so that both
> REGDB and IMA-appraisal firmware signature verification methods are
> required, then the REGDB ifdef's can be removed.

Yes, this sounds fine.

But I'm also saying we can *live* with them if they are wrapped in #ifdefs with
functions sot hat when something is not required they are a no-op. Ideally if
we could avoid this it would be great and it seems you're saying its possible.
Keeping the #ifdefs with function wrappers would make sense as a trade-off if we
really are going to make toss firmware under CONFIG_IMA_APPRAISE_FIRMWARE and
want to review carefully the addition of new open coded firmware solutions (as
the regulatory.db work).

  Luis
