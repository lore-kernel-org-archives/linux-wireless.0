Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46030 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750751AbeEKFAk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 01:00:40 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w4B4wlef030787
        for <linux-wireless@vger.kernel.org>; Fri, 11 May 2018 01:00:40 -0400
Received: from e06smtp11.uk.ibm.com (e06smtp11.uk.ibm.com [195.75.94.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2hw41vs409-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Fri, 11 May 2018 01:00:40 -0400
Received: from localhost
        by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-wireless@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Fri, 11 May 2018 06:00:37 +0100
Subject: Re: [PATCH 3/6] firmware: differentiate between signed
 regulatory.db and other firmware
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
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
        Andy Lutomirski <luto@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Date: Fri, 11 May 2018 01:00:26 -0400
In-Reply-To: <20180510232639.GF27853@wotan.suse.de>
References: <20180504000743.GR27853@wotan.suse.de>
         <1525393466.3539.133.camel@linux.vnet.ibm.com>
         <20180508173404.GG27853@wotan.suse.de>
         <1525865428.3551.175.camel@linux.vnet.ibm.com>
         <20180509191508.GR27853@wotan.suse.de>
         <1525895838.3551.247.camel@linux.vnet.ibm.com>
         <20180509212212.GX27853@wotan.suse.de>
         <1525903617.3551.281.camel@linux.vnet.ibm.com>
         <20180509234814.GY27853@wotan.suse.de>
         <1525917658.3551.322.camel@linux.vnet.ibm.com>
         <20180510232639.GF27853@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Message-Id: <1526014826.3414.46.camel@linux.vnet.ibm.com> (sfid-20180511_070107_400097_A23999B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-05-10 at 23:26 +0000, Luis R. Rodriguez wrote:
> On Wed, May 09, 2018 at 10:00:58PM -0400, Mimi Zohar wrote:
> > On Wed, 2018-05-09 at 23:48 +0000, Luis R. Rodriguez wrote:
> > > On Wed, May 09, 2018 at 06:06:57PM -0400, Mimi Zohar wrote:
> > 
> > > > > > Yes, writing regdb as a micro/mini LSM sounds reasonable.  The LSM
> > > > > > would differentiate between other firmware and the regulatory.db based
> > > > > > on the firmware's pathname.
> > > > > 
> > > > > If that is the only way then it would be silly to do the mini LSM as all
> > > > > calls would have to have the check. A special LSM hook for just the
> > > > > regulatory db also doesn't make much sense.
> > > > 
> > > > All calls to request_firmware() are already going through this LSM
> > > > hook.  I should have said, it would be based on both READING_FIRMWARE
> > > > and the firmware's pathname.
> > > 
> > > Yes, but it would still be a strcmp() computation added for all
> > > READING_FIRMWARE. In that sense, the current arrangement is only open coding the
> > > signature verification for the regulatory.db file.  One way to avoid this would
> > > be to add an LSM specific to the regulatory db
> > 
> > Casey already commented on this suggestion.
> 
> Sorry but I must have missed this, can you send me the email or URL where he did that?
> I never got a copy of that email I think.

My mistake.  I've posted similar patches for kexec_load and for the
firmware sysfs fallback, both call security_kernel_read_file().
Casey's comment was in regards to kexec_load[1], not for the sysfs
fallback mode.  Here's the link to the most recent version of the
kexec_load patches.[2]

[1] http://kernsec.org/pipermail/linux-security-module-archive/2018-May/006690.html
[2] http://kernsec.org/pipermail/linux-security-module-archive/2018-May/006854.html

Mimi
