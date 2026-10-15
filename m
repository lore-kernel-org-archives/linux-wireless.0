Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9008D12CDA5;
	Thu, 15 Oct 2026 23:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792105637; cv=none; b=tHbQjJ6XTGwlGJxAmdQmEnAffd/4tIdSM/iQYWgCusiOs9gZnHW+SM4VxnNMIiqsTpWKj+KcXn9UIO6U4J4ky5HjXcO+ygnej6DEjw8mZ3dZ0Z2i5lp/vCXbPtDkuCih5+eqn/6cbBcyGHltyCKPJGk7oGS19uYjGsQpso/U4Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792105637; c=relaxed/simple;
	bh=YRLOmm/3wM3wOaHgPhI6S2+fPcDhjA7YIDf0ljbL6yo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=HOnwBJxhl2sAeccmQ9ItMYGY+CdxoKsZT6wjsbIuuh0xorgxuX9YuLR1wl9j79t8pR1kupNhm3Gs4qXmr04zr8DXnjls0vPPPD60Y2le3PiQdaEfHDUKvlamPIOP3jPi9QJLQnmCWn5wzDV0afu5ojZHd59/0znwgIKKTURYtCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SkHPTNBF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SkHPTNBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB4F1F000C4;
	Thu, 15 Oct 2026 23:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792105636;
	bh=D4l1NUHjgo8T25PXCBA6/6ltQgVMkPc3iCqrBBCvMEw=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=SkHPTNBFFOJOqXqRrLFIaOuVEVY8YOImW0QU/aQ5y6Hu3XIMXg/gGMgjlu9YM+hOF
	 YoCKjHCg2MHVxKa8cVQjZyPGT8785f8iiM0VKkzvNfSoKKQp6Q8yrXb2AjJW+5s4O8
	 VjGATE4TPXWMOPQtPQ7ePL6eJ3y4JE7v0XyfpjEhUP7GrVixa2MwQQ2iDwhrHbc76Z
	 lRD8+ySt+rDHHcnYi4gQhLr2tMJgNmKSGz2cL9/GYoW2XOmHoNN+4BHii8e6r+j0+j
	 GWw9i6VrH21D7MneqrE5G9YG4T8QwID1UoA965Mo62Cklofypks2m+IBKNugQTy5Go
	 4Ka6hYHLL2veA==
Date: Thu, 15 Oct 2026 18:07:14 -0500
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
Subject: Re: [PATCH v3 1/8] PCI/ASPM: Always disable ASPM when driver
 requests it
Message-ID: <20261015230714.GA1802070@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260708-pci-aspm-fix-v3-1-6bd72451746e@kernel.org>

On Wed, Jul 08, 2026 at 04:30:15PM +0200, Manivannan Sadhasivam wrote:
> From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> 
> PCI core/ASPM service driver allows controlling ASPM state through
> pci_disable_link_state() API. It was decided earlier (see the Link
> below), to not allow ASPM changes when OS does not have control over it
> but only log a warning about the problem 'commit 2add0ec14c25 ("PCI/ASPM:
> Warn when driver asks to disable ASPM, but we can't do it")'.
> 
> A number of drivers have added workarounds to force ASPM off with own
> writes into the Link Control Register (some even with comments
> explaining why PCI core does not disable it under some circumstances).
> According to the comments, some drivers require ASPM to be off for
> reliable operation.
> 
> Having custom ASPM handling in drivers is problematic because the state
> kept in the ASPM service driver is not updated by the changes made
> outside the link state management API.
> 
> As the first step to address this issue, make pci_disable_link_state()
> to unconditionally disable ASPM so the motivation for drivers to come
> up with custom ASPM handling code is eliminated.
> 
> To fully take advantage of the ASPM handling core provides, the drivers
> that need to quirk ASPM have to be altered depend on PCIEASPM and the
> custom ASPM code is removed. This is to be done separately. As PCIEASPM
> is already behind EXPERT, it should be no problem to limit disabling it
> for configurations that do not require touching ASPM.
> 
> Make pci_disable_link_state() function comment to comply kerneldoc
> formatting while changing the description.
> 
> Link: https://lore.kernel.org/all/CANUX_P3F5YhbZX3WGU-j1AGpbXb_T9Bis2ErhvKkFMtDvzatVQ@mail.gmail.com/
> Link: https://lore.kernel.org/all/20230511131441.45704-1-ilpo.jarvinen@linux.intel.com/
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> [mani: commit message fixup]
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

I was a little confused about the provenance of this patch.  It
*looks* like it should have been posted somewhere by Ilpo and
something tweaked by Mani when applying, but none of the links above
are a posting of this patch.  I dug around and found
https://lore.kernel.org/linux-pci/20230918131103.24119-4-ilpo.jarvinen@linux.intel.com/,
and this patch looks like basically the aspm.c part of it, so I assume
that should probably be the https://patch.msgid.link/?

To fix the provenance and the "Drivers can controlling" typo mentioned
by Ilpo, I replaced this with just the aspm.c changes from
https://lore.kernel.org/linux-pci/20230918131103.24119-4-ilpo.jarvinen@linux.intel.com/
and added the CONFIG_PCIEASPM dependency to the commit log.  The code
change is the same.

> ---
>  drivers/pci/pcie/aspm.c | 33 ++++++++++++++++++++-------------
>  1 file changed, 20 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> index 172783e7f519..1c15a14718e8 100644
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
> @@ -1449,16 +1449,23 @@ static int __pci_disable_link_state(struct pci_dev *pdev, int state, bool locked
>  		return -EINVAL;
>  	/*
>  	 * A driver requested that ASPM be disabled on this device, but
> -	 * if we don't have permission to manage ASPM (e.g., on ACPI
> +	 * if we might not have permission to manage ASPM (e.g., on ACPI
>  	 * systems we have to observe the FADT ACPI_FADT_NO_ASPM bit and
> -	 * the _OSC method), we can't honor that request.  Windows has
> -	 * a similar mechanism using "PciASPMOptOut", which is also
> -	 * ignored in this situation.
> +	 * the _OSC method), previously we chose to not honor disable
> +	 * request in that case. Windows has a similar mechanism using
> +	 * "PciASPMOptOut", which is also ignored in this situation.
> +	 *
> +	 * Not honoring the requests to disable ASPM, however, led to
> +	 * drivers forcing ASPM off on their own. As such changes of ASPM
> +	 * state are not tracked by this service driver, the state kept here
> +	 * became out of sync.
> +	 *
> +	 * Therefore, honor ASPM disable requests even when OS does not have
> +	 * ASPM control. Plain disable for ASPM is assumed to be slightly
> +	 * safer than fully managing it.
>  	 */
> -	if (aspm_disabled) {
> -		pci_warn(pdev, "can't disable ASPM; OS doesn't have ASPM control\n");
> -		return -EPERM;
> -	}
> +	if (aspm_disabled)
> +		pci_warn(pdev, "OS doesn't have ASPM control, disabling ASPM anyway\n");
>  
>  	if (!locked)
>  		down_read(&pci_bus_sem);
> @@ -1485,13 +1492,13 @@ int pci_disable_link_state_locked(struct pci_dev *pdev, int state)
>  EXPORT_SYMBOL(pci_disable_link_state_locked);
>  
>  /**
> - * pci_disable_link_state - Disable device's link state, so the link will
> - * never enter specific states.  Note that if the BIOS didn't grant ASPM
> - * control to the OS, this does nothing because we can't touch the LNKCTL
> - * register. Returns 0 or a negative errno.
> - *
> + * pci_disable_link_state - Disable device's link state
>   * @pdev: PCI device
>   * @state: ASPM link state to disable
> + *
> + * Disable device's link state so the link will never enter specific states.
> + *
> + * Return: 0 or a negative errno
>   */
>  int pci_disable_link_state(struct pci_dev *pdev, int state)
>  {
> 
> -- 
> 2.43.0
> 
> 
