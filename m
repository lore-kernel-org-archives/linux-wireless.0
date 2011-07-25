Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab1GYJ3Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 05:29:25 -0400
Date: Mon, 25 Jul 2011 11:30:38 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Adrian Chadd <adrian@freebsd.org>
Subject: Re: [RFC/RFT 4/6] ath9k: use common PCIe ASPM definces instead of
 custom ones
Message-ID: <20110725093037.GC2608@redhat.com> (sfid-20110725_112928_900234_68F8825E)
References: <1311341512-2882-1-git-send-email-sgruszka@redhat.com>
 <1311341512-2882-5-git-send-email-sgruszka@redhat.com>
 <20110723044631.GA828@vmraj-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110723044631.GA828@vmraj-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 23, 2011 at 10:16:32AM +0530, Rajkumar Manoharan wrote:
> > +	pci_read_config_byte(pdev, PCI_EXP_LNKCTL, &aspm);
> > +	aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
> > +	pci_write_config_byte(pdev, PCI_EXP_LNKCTL, aspm);
> >  }
> >
> There seems to be where address diff b/w ATH_PCIE_CAP_LINK_CTRL &
> PCI_EXP_LNKCTL. It has to be like pcie_config_aspm_dev. Isn't it?

Good point. I'll correct and repost.

Thanks
Stanislaw
