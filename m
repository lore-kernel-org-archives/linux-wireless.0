Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756893Ab1DLKjO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 06:39:14 -0400
Date: Tue, 12 Apr 2011 12:39:05 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH 10/16] iwlagn: remove un-needed configuration
Message-ID: <20110412103905.GB2804@redhat.com>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
 <1302276636-12802-11-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1302276636-12802-11-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 08, 2011 at 08:30:30AM -0700, Wey-Yi Guy wrote:
> +	lctl = iwl_pcie_link_ctl(priv);
> +	if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) ==
> +				PCI_CFG_LINK_CTRL_VAL_L1_EN) {
> +		/* L1-ASPM enabled; disable(!) L0S  */
> +		iwl_set_bit(priv, CSR_GIO_REG,
> +				CSR_GIO_REG_VAL_L0S_ENABLED);
> +		IWL_DEBUG_POWER(priv, "L1 Enabled; Disabling L0S\n");
> +	} else {
> +		/* L1-ASPM disabled; enable(!) L0S */
> +		iwl_clear_bit(priv, CSR_GIO_REG,
> +				CSR_GIO_REG_VAL_L0S_ENABLED);
> +		IWL_DEBUG_POWER(priv, "L1 Disabled; Enabling L0S\n");
>  	}

In

commit 1a7123cdd9f49cf1c908fb2c16d26f279c88d8c9
Author: John W. Linville <linville@tuxdriver.com>
Date:   Thu Aug 5 14:39:31 2010 -0400

    iwlwifi: disable aspm by default

we claim to disable ASPM (including L0S), but here we
enable L0S anyway. Perhaps this is the reason why we
still get reports about device disappear:
https://bugzilla.redhat.com/show_bug.cgi?id=642966

We also have code from:

commit e7cad69cdab4d6f0caadbcdd58b54214243ba98a
Author: Grumbach, Emmanuel <emmanuel.grumbach@intel.com>
Date:   Thu Nov 18 03:47:38 2010 -0800

    iwlagn: Enable PCI L1 ACTIVE state after uCode has been loaded

that seems to enable L1 ASPM as well.

I think these bits should be removed from iwlagn driver, or better
root cause of device disappear from bus should be identified and fixed
(not sure if this is iwlagn driver/firmware problem or bios or
pci driver problem, however) to allow to use ASPM.

Stanislaw
