Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9096A4302E1;
	Thu, 16 Jul 2026 16:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784220227; cv=none; b=EWCgNrwpcSe0D1PtDG7W2esGiZLRzB0erEw9GAKFVgDV/m7WmOr2F+vxx5m7Z+JysrPP3NIUOZOFs9n/RGZhOcy4hMUTBIcmfE0V19ZK2E6zVOnZDyjM9J+Xn0P9klyLOtxEK2XRVz5NRR52PKoh3jlzlnnXgJvi5u2tIPm3UVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784220227; c=relaxed/simple;
	bh=SnP8QQIUdNZrOqvASHOtouNYTYwfv/BR4v1iwdm4dEA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=lvKUPrM6d0/jr5B0h2UN2Sn6GqLStx/wEDLSYiUYe7GtcZXUAFj3NM7BpikHwxl2b05mzWo+SNqiB7ahxSp8IK4N5MN350sd17a4dEJJdmTKnwP7ubJwbitZ1ZI0ncFoQkcEv4V8T6BuaYj9sanfeLPJj5qy1ftERw3jq/GNbf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kGu44Drr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGu44Drr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CF91F000E9;
	Thu, 16 Jul 2026 16:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784220217;
	bh=uqfDMBky8ltos50nXdtqbBp/S+h2mdqQ130ynwz+gXE=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=kGu44DrrjOKxlgbOcTiOuR1I/XNU2QiBR684H1vljQJXdas5Tzoj8WFgGq18y8Mlb
	 FTAtzUdlbr/OsvG55DWfX3M0V/K678nWbV4pH4Xcu0NY10xioGPGfxM3yFVRXieYbd
	 9Jtb68tARNAkX2cHgedXpUU9r44uDsW48K6q38H6hhxDbxfjbL+iqTar6vahWDD/hA
	 URrFDmx/r7ROje1vVzSFPhRpYQoYQYCKFAjzmbQmO4bplQzKYnuFT96LwM9a0N6Y1n
	 UcmE0g19yVWfd0PcPbKERL1iST9NijbSaMtQuf5KkQy6h5/ZRBn164en3PGbxv0oiX
	 A87mCkzrLrSbg==
Date: Thu, 16 Jul 2026 11:43:36 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yixun Lan <dlan@kernel.org>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Rob Herring <robh@kernel.org>, Inochi Amaoto <inochiama@gmail.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] PCI: Move Spacemit vendor and device ID to
 linux/pci_Ids.h
Message-ID: <20260716164336.GA40813@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715-rtw89-spacemit-k3-v1-1-e577bc63706b@oss.tenstorrent.com>

On Wed, Jul 15, 2026 at 10:21:54PM -0500, Anirudh Srinivasan wrote:
> Move the vendor and device IDs for Spacemit PCIe Root Complexes to
> include/linux/pci_ids.h so that they can be referenced elsewhere.
> 
> Signed-off-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

To help motivate this patch, it would be nice to say specifically
where PCI_VENDOR_ID_SPACEMIT will be used.

In subject line, s/pci_Ids.h/pci_ids.h/

> ---
>  drivers/pci/controller/dwc/pcie-spacemit-k1.c | 4 ----
>  include/linux/pci_ids.h                       | 4 ++++
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/controller/dwc/pcie-spacemit-k1.c b/drivers/pci/controller/dwc/pcie-spacemit-k1.c
> index 680acc93f5395..7b0bc1802954a 100644
> --- a/drivers/pci/controller/dwc/pcie-spacemit-k1.c
> +++ b/drivers/pci/controller/dwc/pcie-spacemit-k1.c
> @@ -21,10 +21,6 @@
>  
>  #include "pcie-designware.h"
>  
> -#define PCI_VENDOR_ID_SPACEMIT		0x201f
> -#define PCI_DEVICE_ID_SPACEMIT_K1	0x0001
> -#define PCI_DEVICE_ID_SPACEMIT_K3	0x0002
> -
>  /* Offsets and field definitions for link management registers */
>  #define K1_PHY_AHB_IRQ_EN			0x0000
>  #define PCIE_INTERRUPT_EN		BIT(0)
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 1c9d40e09107d..d6f26cacc8e35 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2640,6 +2640,10 @@
>  #define PCI_VENDOR_ID_SUNIX		0x1fd4
>  #define PCI_DEVICE_ID_SUNIX_1999	0x1999
>  
> +#define PCI_VENDOR_ID_SPACEMIT		0x201f
> +#define PCI_DEVICE_ID_SPACEMIT_K1	0x0001
> +#define PCI_DEVICE_ID_SPACEMIT_K3	0x0002
> +
>  #define PCI_VENDOR_ID_HINT             0x3388
>  #define PCI_DEVICE_ID_HINT_VXPROII_IDE 0x8013
>  
> 
> -- 
> 2.43.0
> 
