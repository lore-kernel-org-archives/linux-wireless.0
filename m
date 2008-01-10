Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40168 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611AbYAJTKh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 14:10:37 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [ipw3945-devel] [PATCH 2/5] iwlwifi: iwl3945 synchronize interruptand tasklet for down iwlwifi
Date: Thu, 10 Jan 2008 11:10:35 -0800
Message-ID: <D936D925018D154694D8A362EEB08920035CCD70@orsmsx416.amr.corp.intel.com> (sfid-20080110_191055_189481_40A80FFB)
In-Reply-To: <11998765481610-git-send-email-joonwpark81@gmail.com>
References: <11998765481610-git-send-email-joonwpark81@gmail.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Joonwoo Park" <joonwpark81@gmail.com>,
	"Zhu, Yi" <yi.zhu@intel.com>, <netdev@vger.kernel.org>
Cc: <linux-wireless@vger.kernel.org>,
	"lkml" <linux-kernel@vger.kernel.org>,
	<ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Joonwoo Park  wrote:

> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -6262,6 +6262,10 @@ static void __iwl_down(struct iwl_priv *priv)
> 	/* tell the device to stop sending interrupts */
> 	iwl_disable_interrupts(priv);
> 
> +	/* synchronize irq and tasklet */
> +	synchronize_irq(priv->pci_dev->irq);
> +	tasklet_kill(&priv->irq_tasklet);
> +

Could synchronize_irq() be moved into iwl_disable_interrupts() ? I am
also wondering if we cannot call tasklet_kill() before
iwl_disable_interrupts() ... thus preventing it from being scheduled
when we are going down. 

Reinette
