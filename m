Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536Ab1G2NS4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 09:18:56 -0400
Date: Fri, 29 Jul 2011 15:20:04 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	Adrian Chadd <adrian@freebsd.org>, linux-pci@vger.kernel.org,
	Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	e1000-devel@lists.sourceforge.net
Subject: Re: [RFC/RFT v2 00/12] ath9k: ASPM fixes
Message-ID: <20110729132004.GB2280@redhat.com> (sfid-20110729_151906_315010_A4F3E6FD)
References: <1311768899-4559-1-git-send-email-sgruszka@redhat.com>
 <20110727091150.4e517f30@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110727091150.4e517f30@jbarnes-desktop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 27, 2011 at 09:11:50AM -0700, Jesse Barnes wrote:
> On Wed, 27 Jul 2011 14:14:47 +0200
> Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> 
> > This patch series try to fix ath9k ASPM. Some of patches are cleanup
> > only or do merging common code (with e1000e driver).
> > 
> > With CONFIG_PCIEASPM it's possible to change ASPM settings on runtime
> > via /sys/module/pcie_aspm/parameters/policy . However most drivers
> > I looked at assume this setting is constant. I add a callback to pci
> > driver to inform about the change, and allow driver to do needed hw
> > related changes. Currently only ath9k implement the callback, but
> > I think it will be useful for other drivers (i.e. iwlwifi, rtlwifi)
> > that do some own ASPM handling.
> > 
> > These patches needs wide testing as they may work on some systems
> > and not work on others, that can depend on PCIe bridges.
> 
> These look fine, I remember seeing a place where e1000e could use this
> just recently and it looks like you took care of it.

Yep, accually some pci changes I did was based on e1000e code.

> We may be able to sneak this in to 3.1 to make things easier on the
> dependent drivers, but it'll have to wait until I send my pull request
> for the first batch of PCI changes (probably today).

This could go 3.2, except first patch (ath9k specific) which directly
address system lockups. I'm going to a bit rework and post 1st patch
today. Rest patches from the series I'll repost next week.

Thanks
Stanislaw
