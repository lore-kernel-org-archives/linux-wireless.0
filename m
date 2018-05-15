Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39028 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751626AbeEOMoI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 08:44:08 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w4FCdf1i008364
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2018 08:44:07 -0400
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2hyy6fswng-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2018 08:44:06 -0400
Received: from localhost
        by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-wireless@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Tue, 15 May 2018 13:44:04 +0100
Subject: Re: [PATCH 3/6] firmware: differentiate between signed
 regulatory.db and other firmware
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@kernel.org>, mcgrof@kernel.org
Cc: Harald Hoyer <harald@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Casey Schaufler <casey@schaufler-ca.com>, ast@kernel.org,
        David Miller <davem@davemloft.net>, jeyu@kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Peter Jones <pjones@redhat.com>, takahiro.akashi@linaro.org,
        David Howells <dhowells@redhat.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        johannes.berg@intel.com, linux-integrity@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Greg KH <gregkh@linuxfoundation.org>, andresx7@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        luto@kernel.org, Justin Forbes <jforbes@redhat.com>,
        Laura Abbott <labbott@redhat.com>
Date: Tue, 15 May 2018 08:43:39 -0400
In-Reply-To: <CA+5PVA7QU0k91zvoBTAFzG+unkh-=-s9Lhk3hn3eTJhHo4ovCQ@mail.gmail.com>
References: <20180509212212.GX27853@wotan.suse.de>
         <1525903617.3551.281.camel@linux.vnet.ibm.com>
         <20180509234814.GY27853@wotan.suse.de>
         <1525917658.3551.322.camel@linux.vnet.ibm.com>
         <20180510232639.GF27853@wotan.suse.de>
         <1526014826.3414.46.camel@linux.vnet.ibm.com>
         <20180511215250.GJ27853@wotan.suse.de>
         <1526302692.3898.145.camel@linux.vnet.ibm.com>
         <20180514192853.GM27853@wotan.suse.de>
         <1526349751.3937.78.camel@linux.vnet.ibm.com>
         <20180515032656.GR27853@wotan.suse.de>
         <CA+5PVA7QU0k91zvoBTAFzG+unkh-=-s9Lhk3hn3eTJhHo4ovCQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Message-Id: <1526388219.3937.137.camel@linux.vnet.ibm.com> (sfid-20180515_144413_208161_9BE7375C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-05-15 at 08:32 -0400, Josh Boyer wrote:

> One aspect that was always a concern to some is whether the firmware files
> were modified directly to have the signature attached to them.  That may
> run afoul of the "no modification" license that most blobs are shipped
> under.  Does IMA have the signatures for the files stored in xattrs or in
> some other detached manner?

They're stored as xattrs.  RPM has support for including file
signatures in the RPM header.

Mimi
