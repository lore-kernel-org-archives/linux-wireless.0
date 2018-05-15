Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752331AbeEOMdI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 08:33:08 -0400
MIME-Version: 1.0
References: <20180509212212.GX27853@wotan.suse.de> <1525903617.3551.281.camel@linux.vnet.ibm.com>
 <20180509234814.GY27853@wotan.suse.de> <1525917658.3551.322.camel@linux.vnet.ibm.com>
 <20180510232639.GF27853@wotan.suse.de> <1526014826.3414.46.camel@linux.vnet.ibm.com>
 <20180511215250.GJ27853@wotan.suse.de> <1526302692.3898.145.camel@linux.vnet.ibm.com>
 <20180514192853.GM27853@wotan.suse.de> <1526349751.3937.78.camel@linux.vnet.ibm.com>
 <20180515032656.GR27853@wotan.suse.de>
In-Reply-To: <20180515032656.GR27853@wotan.suse.de>
From: Josh Boyer <jwboyer@kernel.org>
Date: Tue, 15 May 2018 08:32:55 -0400
Message-ID: <CA+5PVA7QU0k91zvoBTAFzG+unkh-=-s9Lhk3hn3eTJhHo4ovCQ@mail.gmail.com> (sfid-20180515_143322_412837_6E48B111)
Subject: Re: [PATCH 3/6] firmware: differentiate between signed regulatory.db
 and other firmware
To: mcgrof@kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Harald Hoyer <harald@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 14, 2018 at 11:27 PM Luis R. Rodriguez <mcgrof@kernel.org>
wrote:

> On Mon, May 14, 2018 at 10:02:31PM -0400, Mimi Zohar wrote:
> > On Mon, 2018-05-14 at 19:28 +0000, Luis R. Rodriguez wrote:
> > > > - CONFIG_IMA_APPRAISE is not fine enough grained.
> > > >
> > > > The CONFIG_IMA_APPRAISE_FIRMWARE will be a Kconfig option.  Similar
> > > > Kconfig options will require kernel modules, kexec'ed image, and the
> > > > IMA policy to be signed.
> > >
> > > Sure, it is still unclear to me if CONFIG_IMA_APPRAISE_FIRMWARE will
be
> > > doing firmware verification in userspace or in the kernel.
> >
> > The kernel is verifying signatures.
> >
> > > > There are a number of reasons that the kernel should be verifying
> > > > firmware signatures (eg. requiring a specific version of the
firmware,
> > > > that was locally signed).
> > >
> > > Oh I agree, Linux enterprise distributions also have a strong reason
to
> > > have this, so that for instance we only trust and run vendor-approved
> > > signed firmware. Otherwise the driver should reject the firmware.
Every
> > > now and then enterprise distros may run into cases were certain
customers
> > > may run oddball firmwares, and its unclear if we expect proper
functionality
> > > with that firmware. Having some form of firmware signing would help
with
> > > this pipeline, but this is currently dealt with at the packaging, and
> > > noting other than logs ensures the driver is using an intended
firmware.
> > > But these needs *IMHO* have not been enough to push to generalize a
kernel
> > > firmware signing facility.
> >
> > In order for IMA-appraisal to verify firmware signatures, the
> > signatures need to be distributed with the firmware.  Perhaps this
> > will be enough of an incentive for distros to start including firmware
> > signatures in the packages.

> Best to poke the maintainers about that... We have been sending mixed
messages
> about firmware signing over years now. Josh, heads up the new one is we
can
> do firmware signing through IMA future CONFIG_IMA_APPRAISE_FIRMWARE. I'll
> bounce you a few emails related to this.

> > > If CONFIG_IMA_APPRAISE_FIRMWARE is going to provide this
functionality somehow
> > > I'm happy to hear it.
> >
> > The functionality has been there since commit 5a9196d ("ima: add
> > support for measuring and appraising firmware").  The
> > security_kernel_fw_from_file() hook was later replaced with the
> > generic security_kernel_read_file() hook.

> Groovy, its unclear from the code on that commit how this is done, so I
> suppose I need to study this a bit more. Josh, do you grok it?

I haven't looked to be honest.  I don't do much in the way of kernel
maintenance on the distro side any longer.  You already have David copied
and I've added Justin Forbes and Laura Abbott to cover Fedora.

One aspect that was always a concern to some is whether the firmware files
were modified directly to have the signature attached to them.  That may
run afoul of the "no modification" license that most blobs are shipped
under.  Does IMA have the signatures for the files stored in xattrs or in
some other detached manner?

josh
