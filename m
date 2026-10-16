Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F4D30CD89;
	Fri, 16 Oct 2026 05:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792130298; cv=none; b=BrxYCjEabTb7r5NdvbB63E+81p5d3kCwg76ZB2XUVOFi0AKAGZo/zmFf2gzd3d8rHi2NiS5cSWODHpY5BNUDTY1CVscS4m030jgHp0DhJ+W02JwnRN8UFmQoX3j1jZlu+VOAV9wDxIL8nsSqdpmgsJfIz/dUpvPFU0gzRWLev+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792130298; c=relaxed/simple;
	bh=YDyeUhrKiQc1VEvMMWXGM1UV84XwKH+qVJZNnbq3XA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vA6uNX6uquidqhG+kkOCf9PCkXuj7h8Pz2Q5fJL0QknU5Ifxs0keUEQxIgEAziGK+/Y8cjVpx4GyX3m0Jku0+wN2v80Nd9Z6P8hXxCYUrQXPLK5zDnDiHtdFEuFMkmzgmbqLaOQVC0D43Et74JNXWxslJ5fzySZ4uJXeZIYAKCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PG9WM6mD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PG9WM6mD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B151F000C4;
	Fri, 16 Oct 2026 05:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792130296;
	bh=tVbSNI4vH0q4W6ilT5tPWpXP7+YaXbgkLCULideNzNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PG9WM6mDDiYMBp730f28wrS1Ar/R8wT31iRXH2/9TKEjpXs21rFLZmtBE0aXtuoCE
	 KdsH4eBCb3pzsQ44ybJPsGV+KxolHJq6KaOFJ+u+iPaEMzRHDp95dHx+9P7Pes0kns
	 xzrNaBQ+yYebEEUM92grALuCdhxF4Yq8hhZP5Gvv+yXVjFucEEkBZ6FVe5DeM0p6oE
	 Js9kWW/zwxNcB+7nGnEVXi0eqSwGC2nAXi+Ckn3GAudjI56rf7110z9pEudJTHglht
	 TWIhmbbQJc0lmb5Nh7PeKBC19KxfcFdSaO73SaxL/rE44Ql/a1IiTVklmhcp+g0TW/
	 83e/OIDQR/kvg==
Date: Fri, 16 Oct 2026 11:28:03 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Rob Herring <robh@kernel.org>, Nirmal Patel <nirmal.patel@linux.intel.com>, 
	Jonathan Derrick <jonathan.derrick@linux.dev>, Jeff Johnson <jjohnson@kernel.org>, linux-pci@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-wireless@vger.kernel.org, 
	ath12k@lists.infradead.org, ath11k@lists.infradead.org, ath10k@lists.infradead.org, 
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>, Qiang Yu <qiang.yu@oss.qualcomm.com>, 
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>, Emmanuel Grumbach <egrumbach@gmail.com>, 
	Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH v3 0/8] PCI/ASPM: Add pci_force_enable_link_state() API
 and convert Atheros drivers
Message-ID: <atG61oicHbsLKiib@debian>
References: <20260708-pci-aspm-fix-v3-0-6bd72451746e@kernel.org>
 <20261014205117.GA1665327@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261014205117.GA1665327@bhelgaas>

On Wed, Oct 14, 2026 at 03:51:17PM -0500, Bjorn Helgaas wrote:
> [+cc Emmanuel, Matthew]
> 
> On Wed, Jul 08, 2026 at 04:30:14PM +0200, Manivannan Sadhasivam wrote:
> > Hi,
> > 
> > This series converts the atheros WLAN drivers (ath10k/ath11k/ath12k) to
> > use the PCI core ASPM APIs for enabling/disabling ASPM instead of writing
> > to the LNKCTL register directly. Touching LNKCTL behind the PCI core's
> > back leaves the ASPM service driver's view of the link state out of sync
> > with the hardware, which is not nice.
> > 
> > The catch is that these drivers save the currently enabled ASPM states,
> > disable ASPM before firmware download, and restore the saved states
> > afterwards. pci_enable_link_state() cannot restore states that were
> > disabled via pci_disable_link_state() or blacklisted during init (like
> > the pre-1.1 device blacklist, which is only meant to be overridden with
> > pcie_aspm=force), and that is intentional. So the save/restore sequence
> > cannot be expressed with the existing APIs.
> > 
> > In v2 I tried to fix this by making pci_enable_link_state*() symmetric
> > with the disable APIs, but as pointed out during review, that also ends
> > up overriding the init-time blacklist for every caller (including VMD),
> > which is not something we want. So instead, this version adds a separate
> > pci_force_enable_link_state() API (patch 2) that re-enables the requested
> > states unconditionally. The caller is responsible for only asking for
> > states the device actually supports, and the ath drivers do this by
> > restoring exactly what pcie_aspm_enabled() reported earlier.
> > 
> > The first five patches touch the PCI core: patch 1 (from Ilpo) makes
> > pci_disable_link_state() disable ASPM unconditionally, patch 2 adds the
> > new API, patch 3 moves the D0 transition needed before enabling PCI-PM
> > L1 PM Substates (PCIe r6.0, sec 5.5.4) into the shared helper and drops
> > it from the vmd and pcie-qcom callers, patch 4 cleans up the kernel-doc,
> > and patch 5 makes pcie_aspm_enabled() return the enabled state mask so it
> > can be used for save/restore. The last three patches convert the ath
> > drivers.
> > 
> > Testing
> > =======
> > 
> > I've tested this series on a Lenovo Thinkpad T14s with WCN7850 (so that's
> > just the ath12k driver). Rest of the drivers are compile tested only.
> > 
> > Merging Strategy
> > ================
> > 
> > Even though there is no build dependency between the PCI core and atheros
> > patches, there is a functional dependency. So I'd recommend creating an
> > immutable branch with the PCI patches and merging that branch into both
> > the PCI and linux-wireless trees, and finally merging the atheros patches
> > into the linux-wireless tree.
> > 
> > If the immutable branch seems like a hassle, then the PCI core patches
> > could get merged first and the atheros patches can wait for the next
> > cycle.
> > 
> > - Mani
> > 
> > Changes in v3:
> > * Dropped the change that made pci_enable_link_state*() symmetric with the
> >   disable APIs. Instead added a new pci_force_enable_link_state() API used
> >   only by the ath drivers, so the init-time blacklist stays overridable
> >   only via pcie_aspm=force and existing callers like VMD are left
> >   untouched.
> > * Fixed the locked path to use pci_set_power_state_locked() for the D0
> >   transition. The previous version called the non-locked variant, which
> >   re-acquires pci_bus_sem.
> > * ath drivers now disable PCIE_LINK_STATE_ASPM_ALL instead of
> >   PCIE_LINK_STATE_ALL so that CLKPM is preserved and can be restored
> >   (pcie_aspm_enabled() doesn't report CLKPM).
> > * Reworked the kernel-doc patch to cover both the enable and disable APIs
> >   and reference the new API.
> > * Rebased on top of v7.2-rc1.
> > 
> > Changes in v2:
> > * Reworked the pcie_aspm_enabled() API to return the enabled states
> >   instead of bool and used it to save/restore the ASPM states in ath
> >   drivers.
> > * Added a patch from Ilpo to disable ASPM even if BIOS didn't grant
> >   permission.
> > * Added the CONFIG_PCIEASPM dependency to ath{10/11/12}k drivers.
> > * Rebased on top of v6.17-rc1.
> > 
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> > ---
> > Ilpo Järvinen (1):
> >       PCI/ASPM: Always disable ASPM when driver requests it
> 
> I put this first patch on pci/aspm for v7.4 because there seems to be
> a consensus that it's better to have the ASPM core disable things even
> if it doesn't technically have control of ASPM, because the
> alternative is that drivers just do it themselves, also ignoring ASPM
> ownership concerns.  Having the drivers do it just means the PCI core
> ASPM support doesn't know what's happening.
> 
> I think we should defer the rest of these because I think there's a
> little room to make the enable/disable/force-enable dance more
> intuitive for the drivers.  As far as I know, the rest of the series
> is definite cleanups but doesn't fix any actual functional issues.
> 

I wouldn't just categorize the rest of the patches as mere cleanups. They are
indeed fixing an obvious race between PCI core and the driver doing ASPM dance
at the same time. But for sure, even after these patches, one can trigger the
same race between sysfs 'config' and the driver/PCI core, but that's more of an
user trying to perform an action to trigger a race vs race happening within the
kernel without user intervention (which is too bad).

I'd really like to see a way forward for these patches, even with a new API and
not let them fall through the cracks.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
