Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36506397B09;
	Mon, 12 Oct 2026 22:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791845915; cv=none; b=lpfb+j0Qrrnp1a+vdrtX/hVDuuG8XubiWd1T7SqDSWHBEoI8TENZrj7XtP/xyN2DE/JdViu4bZ9EvtOcElunNF4OSiKKMzCaiVNRa4n3k/boNnMcQlhp7an3TriMOn+gCwdSP3avoJ1l1ydeziiZ9joT1kD96E/xxQfQXZltEV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791845915; c=relaxed/simple;
	bh=1pFW2F1sakNc+5gFQmjapFTc4p7aCdNmgWQW2ZNPHQA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=It+YLDYIKnU6GTRnMyiHDIBbsL4l9Q9O9rVITfYOKkD+KiFUepywA+8AwV63gfum1bGo7AGHEwvKEcWXAWtZHOdrB/+Jtxgh5QHzBMD3NNh1e76oagsJxGt4OQ6zFVl3plWPTotZ4F+qhcURlp0tOPOwhGTprQ02zxAEB0IbE0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CigmnEhe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CigmnEhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2331F0089B;
	Mon, 12 Oct 2026 22:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791845913;
	bh=CxQpSVjwHE8m246BbAC1GUOpkYCkl05hbIf6PKF/Olw=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=CigmnEhe1b0tyFu8sWUMZq+Z6TLpVRHvJB0F48tyVdkIwZC56YxtLvQuRdbuKI+Fc
	 yLq7ZYIrT+jQJ3iB0vkfUXHO51lYj6qLzTDlKuaJ8yEUxz55SfN3twgXocG7gif4YU
	 4rXoU6t0dZ5dBwCmsdtvKxqyUkd0ZA4x+hfqaegfr/T8bL23yJEAyIqPA2aGuj3ssL
	 OypqT1mOnNNf3SHiEUCFvHpKrmAKtZ+fuF3n/aSQdCSFVEf4qzWBSqL5kLRz7L4D0/
	 1QrsJ9uTC+tstoVA4i4kRqw+yqk4plzTZo9m2065bmvN2bIhwcAeK1LqLSMXmBPbKL
	 NyRoTL9KDcBLA==
Date: Mon, 12 Oct 2026 17:58:32 -0500
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
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: Re: [PATCH v3 2/8] PCI/ASPM: Add pci_force_enable_link_state() API
Message-ID: <20261012225832.GA1415301@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260708-pci-aspm-fix-v3-2-6bd72451746e@kernel.org>

On Wed, Jul 08, 2026 at 04:30:16PM +0200, Manivannan Sadhasivam wrote:
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> 
> pci_enable_link_state() and pci_enable_link_state_locked() APIs only enable
> the ASPM states that were not previously disabled via
> pci_disable_link_state*() API or blacklisted during init (e.g. the pre-1.1
> device blacklist, which is only meant to be overridden with
> 'pcie_aspm=force'). This is an intentional behavior as these APIs must not
> silently re-enable states that were deliberately disabled, since doing so
> could enable ASPM on a link where it is known to be unsafe.

I think this is saying that many uses of pci_disable_link_state() are
to avoid hardware errata, i.e., these are basically quirks, and we
should *never* enable those ASPM states.

> However, some drivers (e.g. the atheros WLAN drivers) save the currently
> enabled ASPM states, disable all ASPM states before firmware download, and
> then try to restore exactly the states that were enabled before. Restoring
> those states requires re-enabling states that were just disabled via
> pci_disable_link_state() API. But, this cannot be achieved using the
> existing APIs.

This sounds like it's also for hardware errata: if ASPM works
correctly, there's no need to disable it during firmware download.  I
think this is *only* the atheros drivers, isn't it?  I didn't see any
others.

> Hence, add pci_force_enable_link_state() API for such callers. Unlike
> pci_enable_link_state(), it re-enables the requested states even if they
> were previously disabled via pci_disable_link_state() or disabled during
> init. The caller is therefore responsible for only enabling states the
> device actually supports, typically the ones previously reported by
> pcie_aspm_enabled().

The problem is that pci_enable_link_state() cannot enable things that
were disabled by pci_disable_link_state().  They're not symmetric,
which violates the caller's expectation.

Instead of adding pci_force_enable_link_state(), I think we should add
a new interface for the *quirk* behavior that permanently disables
states.  Then pci_enable_link_state() and pci_disable_link_state()
could be made symmetric.

> This API is implemented by adding a 'force' parameter to the shared
> __pci_enable_link_state() helper. When 'force' is true, the requested
> states are cleared from 'link->aspm_disable' before enabling.
> 
> Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> ---
>  drivers/pci/pcie/aspm.c | 37 ++++++++++++++++++++++++++++++++++---
>  include/linux/pci.h     |  3 +++
>  2 files changed, 37 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> index 1c15a14718e8..c04fb71de91c 100644
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
> @@ -1506,7 +1506,8 @@ int pci_disable_link_state(struct pci_dev *pdev, int state)
>  }
>  EXPORT_SYMBOL(pci_disable_link_state);
>  
> -static int __pci_enable_link_state(struct pci_dev *pdev, int state, bool locked)
> +static int __pci_enable_link_state(struct pci_dev *pdev, int state, bool locked,
> +				   bool force)
>  {
>  	struct pcie_link_state *link = pcie_aspm_get_link(pdev);
>  
> @@ -1527,6 +1528,10 @@ static int __pci_enable_link_state(struct pci_dev *pdev, int state, bool locked)
>  		down_read(&pci_bus_sem);
>  	mutex_lock(&aspm_lock);
>  	link->aspm_default = pci_calc_aspm_enable_mask(state);
> +
> +	/* Force enable states that were previously disabled */
> +	if (force)
> +		link->aspm_disable &= ~link->aspm_default;
>  	pcie_config_aspm_link(link, policy_to_aspm_state(link));
>  
>  	link->clkpm_default = (state & PCIE_LINK_STATE_CLKPM) ? 1 : 0;
> @@ -1553,7 +1558,7 @@ static int __pci_enable_link_state(struct pci_dev *pdev, int state, bool locked)
>   */
>  int pci_enable_link_state(struct pci_dev *pdev, int state)
>  {
> -	return __pci_enable_link_state(pdev, state, false);
> +	return __pci_enable_link_state(pdev, state, false, false);
>  }
>  EXPORT_SYMBOL(pci_enable_link_state);
>  
> @@ -1576,10 +1581,36 @@ int pci_enable_link_state_locked(struct pci_dev *pdev, int state)
>  {
>  	lockdep_assert_held_read(&pci_bus_sem);
>  
> -	return __pci_enable_link_state(pdev, state, true);
> +	return __pci_enable_link_state(pdev, state, true, false);
>  }
>  EXPORT_SYMBOL(pci_enable_link_state_locked);
>  
> +/**
> + * pci_force_enable_link_state - Force enable device link state
> + * @pdev: PCI device
> + * @state: Mask of ASPM link states to enable
> + *
> + * Enable device link state, so the link will enter the specified states.
> + * Unlike pci_enable_link_state(), this also re-enables states previously
> + * disabled by pci_disable_link_state() and overrides the ASPM states disabled
> + * during init (e.g., the pre-1.1 device blacklist). The caller is therefore
> + * responsible for only enabling states the device supports, typically the ones
> + * previously reported by pcie_aspm_enabled().
> + *
> + * Note that if the BIOS didn't grant ASPM control to the OS, this does nothing
> + * because we can't touch the LNKCTL register.
> + *
> + * Note: Ensure devices are in D0 before enabling PCI-PM L1 PM Substates, per
> + * PCIe r6.0, sec 5.5.4.
> + *
> + * Return: 0 on success, a negative errno otherwise.
> + */
> +int pci_force_enable_link_state(struct pci_dev *pdev, int state)
> +{
> +	return __pci_enable_link_state(pdev, state, false, true);
> +}
> +EXPORT_SYMBOL(pci_force_enable_link_state);
> +
>  void pcie_aspm_remove_cap(struct pci_dev *pdev, u32 lnkcap)
>  {
>  	if (lnkcap & PCI_EXP_LNKCAP_ASPM_L0S)
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index ebb5b9d76360..be6719626c8f 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1918,6 +1918,7 @@ int pci_disable_link_state(struct pci_dev *pdev, int state);
>  int pci_disable_link_state_locked(struct pci_dev *pdev, int state);
>  int pci_enable_link_state(struct pci_dev *pdev, int state);
>  int pci_enable_link_state_locked(struct pci_dev *pdev, int state);
> +int pci_force_enable_link_state(struct pci_dev *pdev, int state);
>  void pcie_no_aspm(void);
>  bool pcie_aspm_support_enabled(void);
>  bool pcie_aspm_enabled(struct pci_dev *pdev);
> @@ -1930,6 +1931,8 @@ static inline int pci_enable_link_state(struct pci_dev *pdev, int state)
>  { return 0; }
>  static inline int pci_enable_link_state_locked(struct pci_dev *pdev, int state)
>  { return 0; }
> +static inline int pci_force_enable_link_state(struct pci_dev *pdev, int state)
> +{ return 0; }
>  static inline void pcie_no_aspm(void) { }
>  static inline bool pcie_aspm_support_enabled(void) { return false; }
>  static inline bool pcie_aspm_enabled(struct pci_dev *pdev) { return false; }
> 
> -- 
> 2.43.0
> 
> 
