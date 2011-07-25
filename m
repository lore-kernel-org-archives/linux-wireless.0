Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab1GYOAl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 10:00:41 -0400
Date: Mon, 25 Jul 2011 16:01:52 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Adrian Chadd <adrian@freebsd.org>
Subject: Re: [RFC/RFT 6/6] ath9k: always initialize hw registers related to
 PCIe PM
Message-ID: <20110725140152.GD2608@redhat.com> (sfid-20110725_160044_404240_11B7FE0E)
References: <1311341512-2882-1-git-send-email-sgruszka@redhat.com>
 <1311341512-2882-7-git-send-email-sgruszka@redhat.com>
 <20110723051129.GC828@vmraj-lnx.users.atheros.com>
 <20110725092929.GB2608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110725092929.GB2608@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 25, 2011 at 11:29:30AM +0200, Stanislaw Gruszka wrote:
> On Sat, Jul 23, 2011 at 10:41:30AM +0530, Rajkumar Manoharan wrote:
> > > +	/* initalize PCIe PM registers if device introduce itself as PCIe */
> > > +	if (ah->is_pciexpress)
> > > +		ath9k_hw_ops(ah)->config_pci_powersave(ah, false);
> > > +
> > Use ath9k_hw_configpcipowersave wrapper instead.
> I changed wrapper to check ah->aspm_enabled, so if I would use it here
> it will not setup registers. I think I should comment that. 
> 
> > And ensure that there is no
> > sideeffect by changing SERDES config from __ath9k_hw_init to pci_probe.
> Hmm, not sure if I understand what I have to do :-(
> 
> We have something like that:
> 
> ath_pci_probe
>   ath9k_init_device
>     ath9k_init_softc
>       ath9k_hw_init
> 	__ath9k_hw_init
>             ath9k_hw_configpcipowersave();
> 
> I changed it this way:
> 
> ath_pci_probe
>   ath9k_init_device
>     ath9k_init_softc
>       ath9k_hw_init
> 	__ath9k_hw_init
> 
>       ath9k_init_queues
>       ath9k_init_btcoex
>    some other inits
>      
>   ath9k_hw_configpcipowersave();
> 
> Can this cause some side effects?

Actually this movement is not necessary, in the way things I did
currently. Is enough to replace ath9k_hw_configpcipowersave() by
ath9k_hw_ops(ah)->config_pci_powersave() in __ath9k_hw_init().
In such case SERDES and PCIe PM registers will be always initialized.

However movement would be needed if we want to initialize registers,
only when ASPM is enabled, hence we first need to discovery that,
and then eventually call ath9k_hw_configpcipowersave().

Which option is correct: always initialize SERDES and PCIe PM registers
or do it only if ASPM is enabled?

Stanislaw
