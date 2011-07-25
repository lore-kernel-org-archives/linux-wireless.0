Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab1GYJPf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 05:15:35 -0400
Date: Mon, 25 Jul 2011 11:16:43 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Adrian Chadd <adrian@freebsd.org>
Subject: Re: [RFC/RFT 5/6] ath9k: do btcoex ASPM disabling at initialization
 time
Message-ID: <20110725091641.GA2608@redhat.com> (sfid-20110725_111559_000338_3935D098)
References: <1311341512-2882-1-git-send-email-sgruszka@redhat.com>
 <1311341512-2882-6-git-send-email-sgruszka@redhat.com>
 <20110723045100.GB828@vmraj-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110723045100.GB828@vmraj-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 23, 2011 at 10:21:01AM +0530, Rajkumar Manoharan wrote:
> On Fri, Jul 22, 2011 at 03:31:51PM +0200, Stanislaw Gruszka wrote:
> > +		pci_read_config_byte(parent, PCI_EXP_LNKCTL, &aspm);
> > +		aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
> > +		pci_write_config_byte(parent, PCI_EXP_LNKCTL, aspm);
> > +
> Why dont you use pci_disable_link_state instead?

Because pci_disable_link_state is noop for CONFIG_PCIEASPM disabled.
I have further patches (based on stuff in e1000e, not finished yet)
that integrate this into pci core and work on both cases, CONFIG_PCIEASPM
disabled and enabled.
