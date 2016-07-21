Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbcGUIGE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2016 04:06:04 -0400
Date: Thu, 21 Jul 2016 10:05:42 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>, prarit@redhat.com
Subject: Re: [RFC] ath10k: silence firmware file probing warnings
Message-ID: <20160721080541.GB2658@redhat.com> (sfid-20160721_100610_788813_88801DE9)
References: <1468933237-5226-1-git-send-email-michal.kazior@tieto.com>
 <20160721070938.GA2658@redhat.com>
 <CANUX_P3ADxi+RHkH=d8Ypcqy9WVKSu4JYH7K3HtTNCuWg3wCeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P3ADxi+RHkH=d8Ypcqy9WVKSu4JYH7K3HtTNCuWg3wCeQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 21, 2016 at 10:36:42AM +0300, Emmanuel Grumbach wrote:
> On Thu, Jul 21, 2016 at 10:09 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > On Tue, Jul 19, 2016 at 03:00:37PM +0200, Michal Kazior wrote:
> >> Firmware files are versioned to prevent older
> >> driver instances to load unsupported firmware
> >> blobs. This is reflected with a fallback logic
> >> which attempts to load several firmware files.
> >>
> >> This however produced a lot of unnecessary
> >> warnings sometimes confusing users and leading
> >> them to rename firmware files making things even
> >> more confusing.
> >
> > This happens on kernels configured with
> > CONFIG_FW_LOADER_USER_HELPER_FALLBACK and cause not only ugly warnings,
> > but also 60 seconds delay before loading next firmware version.
> > For some reason RHEL kernel needs above config option, so this
> > patch is very welcome from my perspective.
> >
> 
> Sorry for my ignorance but how does the firmware loading work if not
> with udev's help?

I'm not sure exactly, but I think kernel VFS layer is capable to copy
file data directly from mounted filesystem without user space helper.

> As you can imagine, iwlwifi is suffering from the
> same problem and I would be interested in applying the same change,
> but I'd love to understand a bit more :)

Yes, iwlwifi (and some other drivers) suffer from this. However this
happen when the newest firmware version is not installed on the system
and CONFIG_FW_LOADER_USER_HELPER_FALLBACK is enabled. What I suppose
it's not common.

I started to see this currently, because that option was enabled on 
RHEL kernel. BTW: I think Prarit iwlwifi thermal_zone problem was
happened because of that, i.e. thermal device was not functional
because f/w wasn't loaded due to big delay.

I'm not sure if replacing to request_firmware_direct() is a good
fix though. For example I can see this problem also on brcmfmac, which
use request_firmware_nowait(). I think I would rather prefer special
helper for firmware drivers that needs user helper and have
request_firmware() be direct as default.

Stanislaw
