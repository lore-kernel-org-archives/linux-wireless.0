Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49398 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965244AbeEIXsR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 19:48:17 -0400
Date: Wed, 9 May 2018 23:48:14 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Peter Jones <pjones@redhat.com>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>,
        David Howells <dhowells@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
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
Message-ID: <20180509234814.GY27853@wotan.suse.de> (sfid-20180510_014835_359409_3F18890A)
References: <1525182503-13849-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1525182503-13849-4-git-send-email-zohar@linux.vnet.ibm.com>
 <20180504000743.GR27853@wotan.suse.de>
 <1525393466.3539.133.camel@linux.vnet.ibm.com>
 <20180508173404.GG27853@wotan.suse.de>
 <1525865428.3551.175.camel@linux.vnet.ibm.com>
 <20180509191508.GR27853@wotan.suse.de>
 <1525895838.3551.247.camel@linux.vnet.ibm.com>
 <20180509212212.GX27853@wotan.suse.de>
 <1525903617.3551.281.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1525903617.3551.281.camel@linux.vnet.ibm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 09, 2018 at 06:06:57PM -0400, Mimi Zohar wrote:
> On Wed, 2018-05-09 at 21:22 +0000, Luis R. Rodriguez wrote:
> > 
> > OK, its still not clear to what it will do. If it does not touch the firmware
> > loader code, and it just sets and configures IMA to do file signature checking
> > on its own, then yes I think both mechanisms would be doing the similar work.
> > 
> > Wouldn't IMA do file signature checks then for all files? Or it would just
> > enable this for whatever files userspace wishes to cover?
> 
> Enabling CONFIG_IMA_APPRAISE_FIRMWARE would enforce firmware
> signatures on all directly loaded firmware and fail any method of
> loading firmware that the signature couldn't be verified.

Ah, so a generic firmware signing mechanism via IMA. Sounds very sensible to me.
Specially in light of the fact that its what we recommend folks to consider
if they need to address firmware signing for devices which do not have the
ability to do hardware firmware signing verification on their own.

> > One of the things with READING_FIRMWARE_REGULATORY_DB is to also use and trust
> > the wireless-regdgb maintainer's key for this file, could IMA be configured to
> > do that?
> 
> IMA has its own trusted keyring.  So either the maintainer's key would
> need to be added to the IMA keyring,

I see so we'd need this documented somehow.

> or IMA-appraisal would need to use the regdb keyring.

Can you describe this a bit more, for those not too familiar with IMA, in terms
of what would be involved in the kernel? Or is this all userspace configuration
stuff?

> > Because that would be one difference here. The whole point of adding
> > CONFIG_CFG80211_REQUIRE_SIGNED_REGDB was to replace CRDA which is a userspace
> > component which checks the signature of regulatory.db before reading it and
> > passing data to the kernel from it.
> > 
> > Now, however silly it may be to have CONFIG_IMA_APPRAISE_FIRMWARE *and*
> > CONFIG_CFG80211_REQUIRE_SIGNED_REGDB, is your intent in this new patch set
> > you are mentioning, to still enable both to co-exist?
> 
> At build, either CONFIG_CFG80211_REQUIRE_SIGNED_REGDB or
> CONFIG_IMA_APPRAISE_FIRMWARE, where IMA is appraising all firwmare,
> would be enabled, not both.

OK.

> > > Yes, writing regdb as a micro/mini LSM sounds reasonable.  The LSM
> > > would differentiate between other firmware and the regulatory.db based
> > > on the firmware's pathname.
> > 
> > If that is the only way then it would be silly to do the mini LSM as all
> > calls would have to have the check. A special LSM hook for just the
> > regulatory db also doesn't make much sense.
> 
> All calls to request_firmware() are already going through this LSM
> hook.  I should have said, it would be based on both READING_FIRMWARE
> and the firmware's pathname.

Yes, but it would still be a strcmp() computation added for all
READING_FIRMWARE. In that sense, the current arrangement is only open coding the
signature verification for the regulatory.db file.  One way to avoid this would
be to add an LSM specific to the regulatory db and have the
security_check_regulatory_db() do what it needs per LSM, but that would mean
setting a precedent for open possibly open coded future firmware verification
call. Its not too crazy to consider if an end goal may be avoid further open
coded firmware signature verification hacks.

> > > Making regdb an LSM would have the same issues as currently - deciding
> > > if regdb, IMA-appraisal, or both verify the regdb's signature.
> > 
> > Its unclear to me why they can't co-exist yet and not have to touch
> > the firmware_loader code at all.
> 
> With the changes discussed above, they will co-exist.  Other than the
> Kconfig changes, I don't think it will touch the firmware_loader code.

Great.

  Luis
