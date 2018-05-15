Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752357AbeEOCC6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 22:02:58 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w4F1sewo054040
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2018 22:02:57 -0400
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2hyjrky387-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2018 22:02:57 -0400
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-wireless@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Tue, 15 May 2018 03:02:54 +0100
Subject: Re: [PATCH 3/6] firmware: differentiate between signed
 regulatory.db and other firmware
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Harald Hoyer <harald@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
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
Date: Mon, 14 May 2018 22:02:31 -0400
In-Reply-To: <20180514192853.GM27853@wotan.suse.de>
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
         <20180514192853.GM27853@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Message-Id: <1526349751.3937.78.camel@linux.vnet.ibm.com> (sfid-20180515_040315_047124_F154028F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-05-14 at 19:28 +0000, Luis R. Rodriguez wrote:

[...] 

> > At runtime, in the case
> > that regdb is enabled and a custom policy requires IMA-appraisal
> > firmware signature verification, then both signature verification
> > methods will verify the signatures.  If either fails, then the
> > signature verification will fail.
> 
> OK so you're saying that if CONFIG_IMA_APPRAISE_FIRMWARE is disabled you can
> still end up with CONFIG_CFG80211_REQUIRE_SIGNED_REGDB as enabled *and* a
> custom policy which requires IMA-appraisal for the certain firmware signature
> verifications?

Right



> > There are two problems:
> > - there's no way of configuring a builtin policy to verify firmware
> > signatures.
> 
> I'm not too familiar with IMA however it sounds like you can extend the IMA
> built-in policy on the boot command line.

No, there are a couple of policies predefined in the kernel that can
be loaded by specifying them on the boot command line.  A custom
policy can be loaded later.  Only after specifying a policy on the
boot command line or loading a custom policy, does IMA do anything.


> > - CONFIG_IMA_APPRAISE is not fine enough grained.
> > 
> > The CONFIG_IMA_APPRAISE_FIRMWARE will be a Kconfig option.  Similar
> > Kconfig options will require kernel modules, kexec'ed image, and the
> > IMA policy to be signed.
> 
> Sure, it is still unclear to me if CONFIG_IMA_APPRAISE_FIRMWARE will be
> doing firmware verification in userspace or in the kernel.

The kernel is verifying signatures.



> > There are a number of reasons that the kernel should be verifying
> > firmware signatures (eg. requiring a specific version of the firmware,
> > that was locally signed).
> 
> Oh I agree, Linux enterprise distributions also have a strong reason to
> have this, so that for instance we only trust and run vendor-approved
> signed firmware. Otherwise the driver should reject the firmware. Every
> now and then enterprise distros may run into cases were certain customers
> may run oddball firmwares, and its unclear if we expect proper functionality
> with that firmware. Having some form of firmware signing would help with
> this pipeline, but this is currently dealt with at the packaging, and
> noting other than logs ensures the driver is using an intended firmware.
> But these needs *IMHO* have not been enough to push to generalize a kernel
> firmware signing facility.

In order for IMA-appraisal to verify firmware signatures, the
signatures need to be distributed with the firmware.  Perhaps this
will be enough of an incentive for distros to start including firmware
signatures in the packages.

> If CONFIG_IMA_APPRAISE_FIRMWARE is going to provide this functionality somehow
> I'm happy to hear it.

The functionality has been there since commit 5a9196d ("ima: add
support for measuring and appraising firmware").  The
security_kernel_fw_from_file() hook was later replaced with the
generic security_kernel_read_file() hook.

Mimi
