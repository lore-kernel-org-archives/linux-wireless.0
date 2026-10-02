Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48CD30D402;
	Fri,  2 Oct 2026 22:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790981746; cv=none; b=tBhp+uvufkvmjEs6bZvIG33hlMnHyRnuULu8kJGXm8qqiX1C+pIUvRlRchGJrXsh+bS322jWt83sU/ufImR0oN0gO1ofDMbf3+h1RoUX07ToGxQXUjW01u/kUfUB0sFP9LlA9xszogLRLJc+J9FxS7F2BoWmiwchQGhizcaIbCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790981746; c=relaxed/simple;
	bh=WbrsyDuRwNJTwRcqSweZTFhGhy6Jwp0TcI1mJDP0/xQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=jvT6amAbeg2L8x+Y7kgA09uOCTHzcT7H+gSSGi0IDWhToarM2G7xiLF3OhBTW183fUSxTYSDLDiZ00CVOr1faAeoaXTc329ryvoqtAmFwhqjfuQ9Hm7aiK0olwdEu8l6cQzc86rhJg3PW53exfKsXzVdaLyKbAk5Qixp7rNtEcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R7mgiFXK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R7mgiFXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3799E1F000FF;
	Fri,  2 Oct 2026 22:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790981745;
	bh=XOjEC8uyWbqD359x8ka20z4mQO4Yg0kZahphsxZmvs0=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=R7mgiFXKy++R6GgEPFPaHrS51wx6MPgzAu9gjhXmJ4d/e1U+MjoTrh0NpZE1EkFyj
	 imZ0ybz654P4TN9chsmB/dCfngz7OhRtayg6AXwa7ttfz5qedYZa1CUk4Yx076Kz5y
	 hmKgjatvC26TgqA06C4agSG/nst5p1BE/oYd1f6irNeKim+f5JMUtT+OcB9Fws/z1m
	 zx2CsEfThX2ApsWeQk3OBIPOLBXvTjfNIfzSuMhQS0Xdwtk0AYpvKfCS/jztMJxQZ7
	 ynXIU/igwz9woyKegxKuXY1W9WhzDa17uDQyCMgX5p4sYag9fJ357B92ynt6AiOzkV
	 7abl2rK/wmwaA==
Date: Fri, 2 Oct 2026 17:55:43 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Nirmal Patel <nirmal.patel@linux.intel.com>,
	Jonathan Derrick <jonathan.derrick@linux.dev>,
	Jeff Johnson <jjohnson@kernel.org>, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
	ath11k@lists.infradead.org, ath10k@lists.infradead.org,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Qiang Yu <qiang.yu@oss.qualcomm.com>,
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH v3 3/8] PCI/ASPM: Transition the device to D0 (if
 required) when enabling ASPM link states
Message-ID: <20261002225543.GA374513@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708-pci-aspm-fix-v3-3-6bd72451746e@kernel.org>

[+cc Rafael because I'm not a power management user]

On Wed, Jul 08, 2026 at 04:30:17PM +0200, Manivannan Sadhasivam wrote:
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> 
> Per PCIe spec r6.0, sec 5.5.4:
> 
> "If setting either or both of the enable bits for PCI-PM L1 PM Substates,
> both ports must be configured as described in this section while in D0."
> 
> Currently, the callers of pci_enable_link_state_locked() (vmd, pcie-qcom)
> transition the device to D0 themselves before enabling the link state. But
> this is easy to get wrong and has to be duplicated by every caller.
> 
> Move the D0 transition into the shared __pci_enable_link_state() helper so
> that all three APIs pci_enable_link_state(), pci_enable_link_state_locked()
> and pci_force_enable_link_state() perform it, and only when the PCI-PM L1
> PM Substates are getting enabled.
> 
> Now that the helper handles the transition, drop the redundant D0 transition
> from the vmd and pcie-qcom callers.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> ---
>  drivers/pci/controller/dwc/pcie-qcom.c |  5 -----
>  drivers/pci/controller/vmd.c           |  5 -----
>  drivers/pci/pcie/aspm.c                | 23 +++++++++++++++++------
>  3 files changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
> index d8eb52857f69..45f4caeb0814 100644
> --- a/drivers/pci/controller/dwc/pcie-qcom.c
> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
> @@ -1085,11 +1085,6 @@ static int qcom_pcie_post_init_2_7_0(struct qcom_pcie *pcie)
>  
>  static int qcom_pcie_enable_aspm(struct pci_dev *pdev, void *userdata)
>  {
> -	/*
> -	 * Downstream devices need to be in D0 state before enabling PCI PM
> -	 * substates.
> -	 */
> -	pci_set_power_state_locked(pdev, PCI_D0);
>  	pci_enable_link_state_locked(pdev, PCIE_LINK_STATE_ALL);
>  
>  	return 0;
> diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
> index d4ae250d4bc6..20597d2cf66e 100644
> --- a/drivers/pci/controller/vmd.c
> +++ b/drivers/pci/controller/vmd.c
> @@ -762,11 +762,6 @@ static int vmd_pm_enable_quirk(struct pci_dev *pdev, void *userdata)
>  	pci_info(pdev, "VMD: Default LTR value set by driver\n");
>  
>  out_state_change:
> -	/*
> -	 * Ensure devices are in D0 before enabling PCI-PM L1 PM Substates, per
> -	 * PCIe r6.0, sec 5.5.4.
> -	 */
> -	pci_set_power_state_locked(pdev, PCI_D0);
>  	pci_enable_link_state_locked(pdev, PCIE_LINK_STATE_ALL);
>  	return 0;
>  }
> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> index c04fb71de91c..6d6862fd2ebb 100644
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
> @@ -1524,6 +1524,17 @@ static int __pci_enable_link_state(struct pci_dev *pdev, int state, bool locked,
>  		return -EPERM;
>  	}
>  
> +	/*
> +	 * Ensure the device is in D0 before enabling PCI-PM L1 PM Substates, per
> +	 * PCIe r6.0, sec 5.5.4.
> +	 */
> +	if (state & PCIE_LINK_STATE_L1_SS_PCIPM) {
> +		if (locked)
> +			pci_set_power_state_locked(pdev, PCI_D0);
> +		else
> +			pci_set_power_state(pdev, PCI_D0);
> +	}

I think it's a great thing to get the power state management out of
the callers of pci_enable_link_state().

But shouldn't we really have done this with pm_runtime_get_sync() and
a corresponding pci_runtime_put()?  Setting the power state with
pci_set_power_state() feels like it's too low-level and possibly racy
for use like this.

>  	if (!locked)
>  		down_read(&pci_bus_sem);
>  	mutex_lock(&aspm_lock);
> @@ -1550,8 +1561,8 @@ static int __pci_enable_link_state(struct pci_dev *pdev, int state, bool locked,
>   * touch the LNKCTL register. Also note that this does not enable states
>   * disabled by pci_disable_link_state(). Return 0 or a negative errno.
>   *
> - * Note: Ensure devices are in D0 before enabling PCI-PM L1 PM Substates, per
> - * PCIe r6.0, sec 5.5.4.
> + * Note: The device will be transitioned to D0 state if the PCI-PM L1 Substates
> + * are getting enabled.
>   *
>   * @pdev: PCI device
>   * @state: Mask of ASPM link states to enable
> @@ -1569,8 +1580,8 @@ EXPORT_SYMBOL(pci_enable_link_state);
>   * can't touch the LNKCTL register. Also note that this does not enable states
>   * disabled by pci_disable_link_state(). Return 0 or a negative errno.
>   *
> - * Note: Ensure devices are in D0 before enabling PCI-PM L1 PM Substates, per
> - * PCIe r6.0, sec 5.5.4.
> + * Note: The device will be transitioned to D0 state if the PCI-PM L1 Substates
> + * are getting enabled.
>   *
>   * @pdev: PCI device
>   * @state: Mask of ASPM link states to enable
> @@ -1600,8 +1611,8 @@ EXPORT_SYMBOL(pci_enable_link_state_locked);
>   * Note that if the BIOS didn't grant ASPM control to the OS, this does nothing
>   * because we can't touch the LNKCTL register.
>   *
> - * Note: Ensure devices are in D0 before enabling PCI-PM L1 PM Substates, per
> - * PCIe r6.0, sec 5.5.4.
> + * Note: The device will be transitioned to D0 state if the PCI-PM L1 Substates
> + * are getting enabled.
>   *
>   * Return: 0 on success, a negative errno otherwise.
>   */
> 
> -- 
> 2.43.0
> 
> 
