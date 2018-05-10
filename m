Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47694 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756118AbeEJCBK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 22:01:10 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w4A1xDL5020793
        for <linux-wireless@vger.kernel.org>; Wed, 9 May 2018 22:01:10 -0400
Received: from e06smtp14.uk.ibm.com (e06smtp14.uk.ibm.com [195.75.94.110])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2hvc3q1ufm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2018 22:01:10 -0400
Received: from localhost
        by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-wireless@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Thu, 10 May 2018 03:01:07 +0100
Subject: Re: [PATCH 3/6] firmware: differentiate between signed
 regulatory.db and other firmware
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Peter Jones <pjones@redhat.com>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>,
        David Howells <dhowells@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
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
        Andy Lutomirski <luto@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Date: Wed, 09 May 2018 22:00:58 -0400
In-Reply-To: <20180509234814.GY27853@wotan.suse.de>
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
         <20180509234814.GY27853@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Message-Id: <1525917658.3551.322.camel@linux.vnet.ibm.com> (sfid-20180510_040127_733320_502E6441)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-05-09 at 23:48 +0000, Luis R. Rodriguez wrote:
> On Wed, May 09, 2018 at 06:06:57PM -0400, Mimi Zohar wrote:
> > On Wed, 2018-05-09 at 21:22 +0000, Luis R. Rodriguez wrote:
> > > 
> > > OK, its still not clear to what it will do. If it does not touch the firmware
> > > loader code, and it just sets and configures IMA to do file signature checking
> > > on its own, then yes I think both mechanisms would be doing the similar work.
> > > 
> > > Wouldn't IMA do file signature checks then for all files? Or it would just
> > > enable this for whatever files userspace wishes to cover?
> > 
> > Enabling CONFIG_IMA_APPRAISE_FIRMWARE would enforce firmware
> > signatures on all directly loaded firmware and fail any method of
> > loading firmware that the signature couldn't be verified.
> 
> Ah, so a generic firmware signing mechanism via IMA. Sounds very sensible to me.
> Specially in light of the fact that its what we recommend folks to consider
> if they need to address firmware signing for devices which do not have the
> ability to do hardware firmware signing verification on their own.
> 
> > > One of the things with READING_FIRMWARE_REGULATORY_DB is to also use and trust
> > > the wireless-regdgb maintainer's key for this file, could IMA be configured to
> > > do that?
> > 
> > IMA has its own trusted keyring.  So either the maintainer's key would
> > need to be added to the IMA keyring,
> 
> I see so we'd need this documented somehow.
> 
> > or IMA-appraisal would need to use the regdb keyring.
> 
> Can you describe this a bit more, for those not too familiar with IMA, in terms
> of what would be involved in the kernel? Or is this all userspace configuration
> stuff?

I think it's a bit premature to be discussing how IMA could add the
builtin regulatory key to its keyring or use the regdb keyring, as
IMA-appraisal doesn't (yet) support detached signatures.

The other option would be to include the regulatory.db signature in
the package.  For rpm, the file signature is included in the RPM
header.  Multiple attempts have been made to have Debian packages
include file signatures.  This is the most recent attempt - https://li
sts.debian.org/debian-dpkg/2018/05/msg00005.html

> > > > Yes, writing regdb as a micro/mini LSM sounds reasonable.  The LSM
> > > > would differentiate between other firmware and the regulatory.db based
> > > > on the firmware's pathname.
> > > 
> > > If that is the only way then it would be silly to do the mini LSM as all
> > > calls would have to have the check. A special LSM hook for just the
> > > regulatory db also doesn't make much sense.
> > 
> > All calls to request_firmware() are already going through this LSM
> > hook.  I should have said, it would be based on both READING_FIRMWARE
> > and the firmware's pathname.
> 
> Yes, but it would still be a strcmp() computation added for all
> READING_FIRMWARE. In that sense, the current arrangement is only open coding the
> signature verification for the regulatory.db file.  One way to avoid this would
> be to add an LSM specific to the regulatory db

Casey already commented on this suggestion.

Mimi

> and have the
> security_check_regulatory_db() do what it needs per LSM, but that would mean
> setting a precedent for open possibly open coded future firmware verification
> call. Its not too crazy to consider if an end goal may be avoid further open
> coded firmware signature verification hacks.
> 
> > > > Making regdb an LSM would have the same issues as currently - deciding
> > > > if regdb, IMA-appraisal, or both verify the regdb's signature.
> > > 
> > > Its unclear to me why they can't co-exist yet and not have to touch
> > > the firmware_loader code at all.
> > 
> > With the changes discussed above, they will co-exist.  Other than the
> > Kconfig changes, I don't think it will touch the firmware_loader code.
> 
> Great.
> 
>   Luis
> 
