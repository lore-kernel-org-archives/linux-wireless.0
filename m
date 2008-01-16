Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.191]:60601 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbYAPEPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jan 2008 23:15:16 -0500
Received: by rv-out-0910.google.com with SMTP id k20so90719rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2008 20:15:13 -0800 (PST)
Message-ID: <b25c3fa70801152015x482aa4cfle9ed3504f40fd18e@mail.gmail.com> (sfid-20080116_041522_847018_9BD66572)
Date: Wed, 16 Jan 2008 13:15:13 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>
Subject: Re: [ipw3945-devel] [PATCH 2/5] iwlwifi: iwl3945 synchronize interruptand tasklet for down iwlwifi
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <D936D925018D154694D8A362EEB0892003683D89@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11998765481610-git-send-email-joonwpark81@gmail.com>
	 <D936D925018D154694D8A362EEB08920035CCD70@orsmsx416.amr.corp.intel.com>
	 <b25c3fa70801101724he91d934y9db6636c68a32486@mail.gmail.com>
	 <D936D925018D154694D8A362EEB0892003602E2D@orsmsx416.amr.corp.intel.com>
	 <b25c3fa70801101838o7a71cc60h1c8b8a71624aeff9@mail.gmail.com>
	 <478B1EBF.8030701@gmail.com> <478B2E92.5090901@gmail.com>
	 <D936D925018D154694D8A362EEB0892003683D89@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/1/16, Chatre, Reinette <reinette.chatre@intel.com>:
> On Monday, January 14, 2008 1:43 AM, Joonwoo Park  wrote:
>
> > -static inline void iwl_disable_interrupts(struct iwl_priv *priv)
> > +static inline void __iwl_disable_interrupts(struct iwl_priv *priv) {
> >       clear_bit(STATUS_INT_ENABLED, &priv->status);
>
> Could the call to iwl_disable_interrupts in iwl_pci_probe be changed to
> __iwl_disable_interrupts? The isr is only activated when the interface
> is brought up so we do not need to do the extra steps (eg.
> synchronize_irq()) during device probe.
>

Hi Reinette,
Thank you for your advice, it seems recent base code's commit inserted
iwl_disable_interrupts() into iwl_pci_probe.
As like you said, for base code __iwl_disable_interrupts() should
better than iwl_disable_interrupts for iwl_pci_probe.

Zhu,
Do you want version of patch for base code?
Can you ACK for this patch?

Thanks,
Joonwoo
