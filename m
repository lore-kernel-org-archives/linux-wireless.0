Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 8bytes.org ([81.169.241.247]:58942 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbaILQRz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 12:17:55 -0400
Date: Fri, 12 Sep 2014 18:17:52 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jason Newton <nevion@gmail.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	iommu <iommu@lists.linux-foundation.org>,
	linux-wireless@vger.kernel.org
Subject: Re: ath9k and AMD IOMMU alias breakage on 3.16?
Message-ID: <20140912161752.GV28786@8bytes.org> (sfid-20140912_181802_393136_666B1C00)
References: <CAGou9MhCmRajqfh91rxbBUr9PBvJxo7U=g9p4Onp0pJk4BwBnA@mail.gmail.com>
 <1409976104.2982.56.camel@ul30vt.home>
 <CAGou9Mg+5GhUUECM4qurF6UzhLMARgeCtbL020U9y0Vs7aFGoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGou9Mg+5GhUUECM4qurF6UzhLMARgeCtbL020U9y0Vs7aFGoA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jason,

On Fri, Sep 05, 2014 at 10:28:01PM -0700, Jason Newton wrote:
> [    0.021820] AMD-Vi: device: 00:00.2 cap: 0040 seg: 0 flags: b8 info 0000
> [    0.021827] AMD-Vi:        mmio-addr: 00000000feb80000
> [    0.021844] AMD-Vi:   DEV_SELECT_RANGE_START	 devid: 00:01.0 flags: 00
> [    0.021848] AMD-Vi:   DEV_RANGE_END		 devid: ff:1f.6
> [    0.022730] AMD-Vi:   DEV_ALIAS_RANGE		 devid: 02:00.0 flags: 00 devid_to: 00:14.4
> [    0.022735] AMD-Vi:   DEV_RANGE_END		 devid: 02:1f.7
> [    0.022745] AMD-Vi:   DEV_SPECIAL(HPET[0])		devid: 00:14.0
> [    0.022749] AMD-Vi:   DEV_SPECIAL(IOAPIC[5])		devid: 00:14.0
> [    0.022753] AMD-Vi:   DEV_SPECIAL(IOAPIC[6])		devid: 00:00.0

It is just a test, as I don't know how the hardware is actually wired in
your system, but can you try to boot with 'ivrs_ioapic[6]=00:00.1' on
the kernel command line and report if it makes any difference?

Thanks,

	Joerg

