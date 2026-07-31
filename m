Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C651B33B96B;
	Fri, 31 Jul 2026 05:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785476089; cv=none; b=BM7hHVrT5HMJp+VvR9pQmc3BGMNhir4IZb9xp8h5POZCqrs/SYLtJUd9JLttVlxCjH9XUU10KeWC9l9PhGSAlskSn8Ql45yesKqX/AVSUhux0pHXY2W/XYbujX2Y8ywdSRGAqiLpdSdH2SKDFHII9NuUIKj/rn0A9fU5ZfnLkYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785476089; c=relaxed/simple;
	bh=XTNraHYMygssnhQ91rxtme9TYs0hFFn4RZ7P2Gst86A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wfxm8d6F8SPvnp+qVED133lUudFalJluNiHz9aLWosNAFuy1hceB0xk8O9MLdLWf3OAs9cZbexcK4B2o5556FspGkmZCxeSFmqAsEb0cpU4d/ijeyg0kbwnma3xpJme+SylbcD1/LNkIcTG/Iq4PypjMQQcae41EfctQS9Qi4qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nk4IYXiy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nk4IYXiy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CC81F000E9;
	Fri, 31 Jul 2026 05:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785476088;
	bh=X+kGKFP4B0Q+9BVZYTfIdRIGmMHCgn6SIs9Evw3RV1Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nk4IYXiykYXlE48Hp6ym9KzOxQfc0H9nG51s5RXUokPSWdGVru9LBZQgCg7v1YtUI
	 YlXO9czxwUtxyiuGMB2gH2sbAQC/5218+Y98+BWXpobH0ido5dLVYsaVxBkbA4F09t
	 jkF/rco8kwIiuUKNyFDlAJuESVS/DC/aUqVLO43ezkAjL2sM3+RCc8/79RXwxeESjc
	 BRWMyd1zELS9gEofbu/wRNjxov1L3fYXA36DL8KqTLc5kd62CjXutD+wHzvLJz+j40
	 9Ncd5j7bS9kLoEunkHDadrHufpCRy2qsICffHGkEEem2J4uPiYVm1Hbeis5LymT36D
	 /kef17IVEHeKg==
Date: Fri, 31 Jul 2026 07:34:39 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Rob Herring <robh@kernel.org>, Nirmal Patel <nirmal.patel@linux.intel.com>, 
	Jonathan Derrick <jonathan.derrick@linux.dev>, Jeff Johnson <jjohnson@kernel.org>, linux-pci@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-wireless@vger.kernel.org, 
	ath12k@lists.infradead.org, ath11k@lists.infradead.org, ath10k@lists.infradead.org, 
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>, Qiang Yu <qiang.yu@oss.qualcomm.com>, 
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>, Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: Re: [PATCH v3 6/8] wifi: ath12k: Use
 pci_{enable/disable}_link_state() APIs to enable/disable ASPM states
Message-ID: <lmmrcv2dpuitbqmuargtsbk647z66gs6aqanzis226py2hjhys@d5h5p6ltmg4e>
References: <20260708-pci-aspm-fix-v3-6-6bd72451746e@kernel.org>
 <20260710202546.GA989860@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260710202546.GA989860@bhelgaas>

On Fri, Jul 10, 2026 at 03:25:46PM -0500, Bjorn Helgaas wrote:
> On Wed, Jul 08, 2026 at 04:30:20PM +0200, Manivannan Sadhasivam wrote:
> > From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> > 
> > It is not recommended to enable/disable the ASPM states on the back of the
> > PCI core directly using the LNKCTL register. It will break the PCI core's
> > knowledge about the device ASPM states. So use the APIs exposed by the PCI
> > core to enable/disable ASPM states.
> > 
> > Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3
> > 
> > Reported-by: Qiang Yu <qiang.yu@oss.qualcomm.com>
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath12k/Kconfig |  2 +-
> >  drivers/net/wireless/ath/ath12k/pci.c   | 19 +++----------------
> >  drivers/net/wireless/ath/ath12k/pci.h   |  4 +++-
> >  3 files changed, 7 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath12k/Kconfig b/drivers/net/wireless/ath/ath12k/Kconfig
> > index 4a2b240f967a..7852ede3eaea 100644
> > --- a/drivers/net/wireless/ath/ath12k/Kconfig
> > +++ b/drivers/net/wireless/ath/ath12k/Kconfig
> > @@ -1,7 +1,7 @@
> >  # SPDX-License-Identifier: BSD-3-Clause-Clear
> >  config ATH12K
> >  	tristate "Qualcomm Wi-Fi 7 support (ath12k)"
> > -	depends on MAC80211 && HAS_DMA && PCI
> > +	depends on MAC80211 && HAS_DMA && PCI && PCIEASPM
> 
> As Sashiko pointed out [1], I think adding the PCIEASPM dependency is
> an issue.  The PCI core should provide stubs or whatever is necessary
> to make ath12k work even if PCIEASPM isn't selected.
> 
> I'm guessing this hardware depends on the ability to disable ASPM even
> without PCIEASPM so we probably would need more than just empty stubs.
> We do build aspm.c unconditionally now and we provide LTR and L1SS
> save/restore regardless of PCIEASPM.  Maybe we need something similar
> here.
> 

This was discussed in v2 and Ath maintainer Jeff was in agreement with the
dependency:
https://lore.kernel.org/linux-pci/705a4fe5-658e-25ac-9e4d-6b8089abca46@linux.intel.com

- Mani

-- 
மணிவண்ணன் சதாசிவம்
