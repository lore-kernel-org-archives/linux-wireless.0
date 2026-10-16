Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17EF3F9F5B;
	Fri, 16 Oct 2026 10:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792145864; cv=none; b=NDQWex3FYmy3eVXflPo8fNK6knvoOtSjkgdPlVdQD2gzp5wKLGpjYj/UBp0YctUM5D++vJkr1BerY7TCKaSLmvhAhN1KMtN+CkAkOifzetAwDVS8oaCYucxxn2TgZkCVxsSELk+OcEaxkrFv2i6w38bkZ2KuXV5UD7eCFwvxFSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792145864; c=relaxed/simple;
	bh=ps4odQHHb7l/wiRUo9dzB8hrI0RD41hOHQAtb2vg9yU=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=CyF6oGBi80lDtRlYlPB60zVozfKtNW9tEbpntC1KJMPAaer1SZtbH5BWuBB1CU9N98C7zXjsHM+FjWH9vd510aQgp5BhtDxTjVU/TGx8XkclRoGJtLVDnzfwfipazTGNAMrmpafonIMHbyBkA/y42F3xdDL0wpIUTzGxXc+4MNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S85C1yLc; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S85C1yLc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792145863; x=1823681863;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=ps4odQHHb7l/wiRUo9dzB8hrI0RD41hOHQAtb2vg9yU=;
  b=S85C1yLcceF9b2gthZGV3q5EGN55+JfjOLm7gLHVdJ1V0/g8YzHIpz/d
   oEAkySNppkaYxNDZF/YMyDTSCLeCmt5GNfR7QeJ7nxuM4DcLNvdX9JLM0
   pUuiKh9702e+t4bDdwD1tmA91EK4D91KvkW7BnyhnSwllhuA4iPw0nZiA
   Mtzyl6vPKY5IFs60RxD9GF43euC3lXBnALXjmGx/m2gUE+4lVN0gsQ3BN
   2FwrW4j/P+Ijc5tf4auSK3njUn/8Mr6qL8P5DKNJOg+lIljFq/4yk6gvG
   BHfolLnGxrhJ9oylcmvDif4yyQAnOJsfP0U03PIYktPM35v2vOaNDdrEq
   w==;
X-CSE-ConnectionGUID: s2RMltnvQ7OjOrUBwdCFig==
X-CSE-MsgGUID: Yd7wZkfETBiL6kF5J6XyBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11936"; a="947796"
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="947796"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2026 03:17:42 -0700
X-CSE-ConnectionGUID: HJbJ4n/iS9mI5RPiq2hT8g==
X-CSE-MsgGUID: L52WigXOQAKc7nd3wTm9HQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="1892016"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.34])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2026 03:17:35 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Fri, 16 Oct 2026 13:17:29 +0300 (EEST)
To: Manivannan Sadhasivam <mani@kernel.org>
cc: Bjorn Helgaas <helgaas@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
    Lorenzo Pieralisi <lpieralisi@kernel.org>, 
    =?ISO-8859-2?Q?Krzysztof_Wilczy=F1ski?= <kwilczynski@kernel.org>, 
    Rob Herring <robh@kernel.org>, Nirmal Patel <nirmal.patel@linux.intel.com>, 
    Jonathan Derrick <jonathan.derrick@linux.dev>, 
    Jeff Johnson <jjohnson@kernel.org>, linux-pci@vger.kernel.org, 
    LKML <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org, 
    linux-wireless@vger.kernel.org, ath12k@lists.infradead.org, 
    ath11k@lists.infradead.org, ath10k@lists.infradead.org, 
    Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>, 
    Qiang Yu <qiang.yu@oss.qualcomm.com>, 
    Emmanuel Grumbach <egrumbach@gmail.com>, 
    Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH v3 0/8] PCI/ASPM: Add pci_force_enable_link_state() API
 and convert Atheros drivers
In-Reply-To: <atG61oicHbsLKiib@debian>
Message-ID: <8ceaf259-ae07-efa1-911f-4cc86a2710c2@linux.intel.com>
References: <20260708-pci-aspm-fix-v3-0-6bd72451746e@kernel.org> <20261014205117.GA1665327@bhelgaas> <atG61oicHbsLKiib@debian>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-1775956960-1792142584=:1180"
Content-ID: <0d2502b4-10fe-3dd3-f6d5-e547a5ecd889@linux.intel.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1775956960-1792142584=:1180
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <391745ff-eb7c-bf57-36a4-00b885c75592@linux.intel.com>

On Fri, 16 Oct 2026, Manivannan Sadhasivam wrote:

> On Wed, Oct 14, 2026 at 03:51:17PM -0500, Bjorn Helgaas wrote:
> > [+cc Emmanuel, Matthew]
> >=20
> > On Wed, Jul 08, 2026 at 04:30:14PM +0200, Manivannan Sadhasivam wrote:
> > > Hi,
> > >=20
> > > This series converts the atheros WLAN drivers (ath10k/ath11k/ath12k) =
to
> > > use the PCI core ASPM APIs for enabling/disabling ASPM instead of wri=
ting
> > > to the LNKCTL register directly. Touching LNKCTL behind the PCI core'=
s
> > > back leaves the ASPM service driver's view of the link state out of s=
ync
> > > with the hardware, which is not nice.
> > >=20
> > > The catch is that these drivers save the currently enabled ASPM state=
s,
> > > disable ASPM before firmware download, and restore the saved states
> > > afterwards. pci_enable_link_state() cannot restore states that were
> > > disabled via pci_disable_link_state() or blacklisted during init (lik=
e
> > > the pre-1.1 device blacklist, which is only meant to be overridden wi=
th
> > > pcie_aspm=3Dforce), and that is intentional. So the save/restore sequ=
ence
> > > cannot be expressed with the existing APIs.
> > >=20
> > > In v2 I tried to fix this by making pci_enable_link_state*() symmetri=
c
> > > with the disable APIs, but as pointed out during review, that also en=
ds
> > > up overriding the init-time blacklist for every caller (including VMD=
),
> > > which is not something we want. So instead, this version adds a separ=
ate
> > > pci_force_enable_link_state() API (patch 2) that re-enables the reque=
sted
> > > states unconditionally. The caller is responsible for only asking for
> > > states the device actually supports, and the ath drivers do this by
> > > restoring exactly what pcie_aspm_enabled() reported earlier.
> > >=20
> > > The first five patches touch the PCI core: patch 1 (from Ilpo) makes
> > > pci_disable_link_state() disable ASPM unconditionally, patch 2 adds t=
he
> > > new API, patch 3 moves the D0 transition needed before enabling PCI-P=
M
> > > L1 PM Substates (PCIe r6.0, sec 5.5.4) into the shared helper and dro=
ps
> > > it from the vmd and pcie-qcom callers, patch 4 cleans up the kernel-d=
oc,
> > > and patch 5 makes pcie_aspm_enabled() return the enabled state mask s=
o it
> > > can be used for save/restore. The last three patches convert the ath
> > > drivers.
> > >=20
> > > Testing
> > > =3D=3D=3D=3D=3D=3D=3D
> > >=20
> > > I've tested this series on a Lenovo Thinkpad T14s with WCN7850 (so th=
at's
> > > just the ath12k driver). Rest of the drivers are compile tested only.
> > >=20
> > > Merging Strategy
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >=20
> > > Even though there is no build dependency between the PCI core and ath=
eros
> > > patches, there is a functional dependency. So I'd recommend creating =
an
> > > immutable branch with the PCI patches and merging that branch into bo=
th
> > > the PCI and linux-wireless trees, and finally merging the atheros pat=
ches
> > > into the linux-wireless tree.
> > >=20
> > > If the immutable branch seems like a hassle, then the PCI core patche=
s
> > > could get merged first and the atheros patches can wait for the next
> > > cycle.
> > >=20
> > > - Mani
> > >=20
> > > Changes in v3:
> > > * Dropped the change that made pci_enable_link_state*() symmetric wit=
h the
> > >   disable APIs. Instead added a new pci_force_enable_link_state() API=
 used
> > >   only by the ath drivers, so the init-time blacklist stays overridab=
le
> > >   only via pcie_aspm=3Dforce and existing callers like VMD are left
> > >   untouched.
> > > * Fixed the locked path to use pci_set_power_state_locked() for the D=
0
> > >   transition. The previous version called the non-locked variant, whi=
ch
> > >   re-acquires pci_bus_sem.
> > > * ath drivers now disable PCIE_LINK_STATE_ASPM_ALL instead of
> > >   PCIE_LINK_STATE_ALL so that CLKPM is preserved and can be restored
> > >   (pcie_aspm_enabled() doesn't report CLKPM).
> > > * Reworked the kernel-doc patch to cover both the enable and disable =
APIs
> > >   and reference the new API.
> > > * Rebased on top of v7.2-rc1.
> > >=20
> > > Changes in v2:
> > > * Reworked the pcie_aspm_enabled() API to return the enabled states
> > >   instead of bool and used it to save/restore the ASPM states in ath
> > >   drivers.
> > > * Added a patch from Ilpo to disable ASPM even if BIOS didn't grant
> > >   permission.
> > > * Added the CONFIG_PCIEASPM dependency to ath{10/11/12}k drivers.
> > > * Rebased on top of v6.17-rc1.
> > >=20
> > > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualc=
omm.com>
> > > ---
> > > Ilpo J=E4rvinen (1):
> > >       PCI/ASPM: Always disable ASPM when driver requests it
> >=20
> > I put this first patch on pci/aspm for v7.4 because there seems to be
> > a consensus that it's better to have the ASPM core disable things even
> > if it doesn't technically have control of ASPM, because the
> > alternative is that drivers just do it themselves, also ignoring ASPM
> > ownership concerns.  Having the drivers do it just means the PCI core
> > ASPM support doesn't know what's happening.
> >=20
> > I think we should defer the rest of these because I think there's a
> > little room to make the enable/disable/force-enable dance more
> > intuitive for the drivers.  As far as I know, the rest of the series
> > is definite cleanups but doesn't fix any actual functional issues.
> >=20
>=20
> I wouldn't just categorize the rest of the patches as mere cleanups. They=
 are
> indeed fixing an obvious race between PCI core and the driver doing ASPM =
dance
> at the same time.

Agreed.

> But for sure, even after these patches, one can trigger the
> same race between sysfs 'config' and the driver/PCI core, but that's more=
 of an
> user trying to perform an action to trigger a race vs race happening with=
in the
> kernel without user intervention (which is too bad).

Which is why I suggested moving to a counter based approach so we could=20
arbitrarily overlap any number of disable/enable pairs for a state in=20
arbitrary order, no matter what's the source.

> I'd really like to see a way forward for these patches, even with a new A=
PI and
> not let them fall through the cracks.

Me too. The needs have simply outgrown the old API (which was never good=20
anyway due to its asymmetry caveat).

--=20
 i.
--8323328-1775956960-1792142584=:1180--
