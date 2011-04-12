Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756854Ab1DLKlo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 06:41:44 -0400
Date: Tue, 12 Apr 2011 12:41:39 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH 10/16] iwlagn: remove un-needed configuration
Message-ID: <20110412104139.GC2804@redhat.com>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
 <1302276636-12802-11-git-send-email-wey-yi.w.guy@intel.com>
 <20110412103905.GB2804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110412103905.GB2804@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 12, 2011 at 12:39:05PM +0200, Stanislaw Gruszka wrote:
> On Fri, Apr 08, 2011 at 08:30:30AM -0700, Wey-Yi Guy wrote:
> > +	lctl = iwl_pcie_link_ctl(priv);
> > +	if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) ==
> > +				PCI_CFG_LINK_CTRL_VAL_L1_EN) {
> > +		/* L1-ASPM enabled; disable(!) L0S  */
> > +		iwl_set_bit(priv, CSR_GIO_REG,
> > +				CSR_GIO_REG_VAL_L0S_ENABLED);
> > +		IWL_DEBUG_POWER(priv, "L1 Enabled; Disabling L0S\n");
> > +	} else {
> > +		/* L1-ASPM disabled; enable(!) L0S */
We claim to enable L0S,
> > +		iwl_clear_bit(priv, CSR_GIO_REG,
> > +				CSR_GIO_REG_VAL_L0S_ENABLED);
but we clear CSR_GIO_REG_VAL_L0S_ENABLED bit, hmm ...
