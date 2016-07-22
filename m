Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbcGVWTb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2016 18:19:31 -0400
Date: Sat, 23 Jul 2016 00:19:29 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>,
	Arend van Spriel <arend@broadcom.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ming Lei <ming.lei@canonical.com>,
	"Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [RFC] ath10k: silence firmware file probing warnings
Message-ID: <20160722221929.GN5537@wotan.suse.de> (sfid-20160723_001935_327356_0DC5B7AE)
References: <1468933237-5226-1-git-send-email-michal.kazior@tieto.com>
 <20160721070938.GA2658@redhat.com>
 <CANUX_P3ADxi+RHkH=d8Ypcqy9WVKSu4JYH7K3HtTNCuWg3wCeQ@mail.gmail.com>
 <20160721080541.GB2658@redhat.com>
 <5790A28F.8030102@redhat.com>
 <20160721115122.GA31869@redhat.com>
 <a264e995-fc46-7fcd-69f9-80992385b6b1@broadcom.com>
 <20160722102559.GA2662@redhat.com>
 <84a2cfbe-3d58-a5ec-e028-166dce4c9304@broadcom.com>
 <579216D8.2010401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <579216D8.2010401@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 22, 2016 at 08:51:36AM -0400, Prarit Bhargava wrote:
> On 07/22/2016 08:21 AM, Arend Van Spriel wrote:
> >> Another option to solve to problem would be stop requesting not
> >> available publicly firmware. However, I assume some drivers would
> >> like to preserve that option.
> > 
> > Actually, this is not the case with brcmfmac. We do need a firmware
> > file, ie. brcm/brcmfmac4356-pcie.bin, and also request for a nvram file,
> > ie. brcm/brcmfmac4356-pcie.txt. The latter is optional and the device
> > works fine without it.
> > 
> > What is still unclear to me is when request_firmware_direct() would fail
> > and in what circumstances the udev helper is a valid callback. Can you
> > explain such a scenario. Another question I have is what the reasons are
> > behind the 60 seconds timeout.
> 
> request_firmware_direct() will fail when the specified FW file is not present.
> This is different from request_firmware() which implements a usermode helper to
> potentially download firmware, or unpack a firmware image.
> 
> Re: 60 second timeout ... The 60 second timeout with request_firmware() is
> completely arbitrary.  There is no way for udev to signal back to the kernel
> that userspace helper has not completed its actions, so the kernel has a 60 dead
> man timer-ish delay.

Lets call it what it was: the 60 second timeout thing was simply a mistake.
Its no longer 60 seconds anyway, and in fact its accepted a dreaded issue.
What *we* should be doing is thinking about proper long term architecture now.
Async probe was one solution to some issues, a new flexible firmware API
that avoids the usermode helper 100% is another.

Distros stuck with the fallback option should review their strategies,
either disabling the fallback option, upgrade systemd, or use alternative
solutions (opensuse has a good one).

> >>>> However I wonder if changing that will not broke the case when
> >>>> driver is build-in in the kernel and f/w is not yet available when
> >>>> driver start to initialize. Or maybe nowadays this is not the case
> >>>> any longer, i.e. the MODULE_FIRMWARE macros assure proper f/w 
> >>>> images are build-in in the kernel or copied to initramfs?
> >>>
> >>> That is a nice idea, but I have not seen any change in that area. Could
> >>> have missed it.
> >>
> >> I believe this is how the things are already done, IOW switching to
> >> request_firmware_direct() in the driver should be no harm.
> > 
> > Ok. What are the consequences when:
> > - driver is built-in.
> > - driver+firmware present on initramfs.
> > - driver on initramfs, firmware only present on rootfs.
> > - driver+firmware only on rootfs.
> > 
> > I assume the third one would be considered a configuration issue.
> 
> I think your question here can be answered by reading drivers/base/Kconfig:88,
> and reading about those 4 config options.

No, this documentation is terrible, I've posted some patches to help with this
mess.

> I could paraphrase it butI think the
> Kconfig notes are better than I could explain it.  Note that this is how things
> currently work with request_firmware_nowait().  IIRC request_firmware_nowait()
> is just an asynchronous version of request_firmware().

... its a mess.

  Luis
