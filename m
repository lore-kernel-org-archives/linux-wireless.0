Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:43402 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbYAOT53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jan 2008 14:57:29 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [ipw3945-devel] [PATCH 2/5] iwlwifi: iwl3945 synchronize interruptand tasklet for down iwlwifi
Date: Tue, 15 Jan 2008 11:21:12 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003683D89@orsmsx416.amr.corp.intel.com> (sfid-20080115_195734_480159_43EA732D)
In-Reply-To: <478B2E92.5090901@gmail.com>
References: <11998765481610-git-send-email-joonwpark81@gmail.com>	 <D936D925018D154694D8A362EEB08920035CCD70@orsmsx416.amr.corp.intel.com>	 <b25c3fa70801101724he91d934y9db6636c68a32486@mail.gmail.com>	 <D936D925018D154694D8A362EEB0892003602E2D@orsmsx416.amr.corp.intel.com> <b25c3fa70801101838o7a71cc60h1c8b8a71624aeff9@mail.gmail.com> <478B1EBF.8030701@gmail.com> <478B2E92.5090901@gmail.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Joonwoo Park" <joonwpark81@gmail.com>,
	"Zhu, Yi" <yi.zhu@intel.com>
Cc: <linux-wireless@vger.kernel.org>,
	<ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, January 14, 2008 1:43 AM, Joonwoo Park  wrote:

> -static inline void iwl_disable_interrupts(struct iwl_priv *priv)
> +static inline void __iwl_disable_interrupts(struct iwl_priv *priv) {
> 	clear_bit(STATUS_INT_ENABLED, &priv->status);

Could the call to iwl_disable_interrupts in iwl_pci_probe be changed to
__iwl_disable_interrupts? The isr is only activated when the interface
is brought up so we do not need to do the extra steps (eg.
synchronize_irq()) during device probe.

Reinette
