Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01653E49CC;
	Thu, 23 Jul 2026 22:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784844111; cv=none; b=dlhrP9ddO9yXUEX4CtaeFBTSnNwj+BUyiEC8ftdx4iSYzAw2S9woeNM/UYkSDQCSawndRcfwilAjR7rK9O2kRf3HpbCZS/Nv1gG7WaEoKIxlWuuB/cHI2BpjIoWAAGdI2BqYPjrKvuvvlLdoRw0zZDph1umC9x6UuT2fxjofczI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784844111; c=relaxed/simple;
	bh=Ap+PKXa1rjxNyMD62UgZFXIzLqfyrb6ywhI4s6UIhRc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=mQ2tZ7q4mFbv8YjiE0DKEnjOW5EWiquHZW/pxzcnwaVfcJt6YQ3BBs39r55mTngOb4OR+arrOcoP376Wjn+49tLIMJYsobEXzH/X8RgfH8F+cCniQigLoi2qJQcftnCDiiuFos7u+1fUfMy6Mvtx9sLw4GgaqJQx/Y4L5Yf/Jzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MjSCNQcV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MjSCNQcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776E01F000E9;
	Thu, 23 Jul 2026 22:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784844101;
	bh=OW/+87f6scqS9+baO5oS3wrBMXJyQ9fPEVbIi5XahiE=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=MjSCNQcVKVQv+ToMyLY8eAAyNOGdd5VUcZhTZEBbmzpXEiCMKNHyapzKUeB7ue6NA
	 org747FcrPp40vt7dWhc/j5vWPqZCR053IQzlYSKYJ5XkJvvahiW1zNE++zdFLAxf0
	 AaYuUGttAQzLVKNq7tsg4HyVnKqKZIa+3hTft3p6NYpcSWT/4SPnpE/rzyBlFYJHOe
	 eo00KRTion3zzkR5b3mggyKVtjlVWd1AMg4zpPNxrj7pB/L8asp/3SReYNPRyTdvfx
	 Vxnoj6/VA+iGK+IQKjNbTKt5vOz2z2pV9Ley4Zen/zaNFoYdgtnPtguCkZcKc+Q43J
	 ZSgdG7WZP1LHw==
Date: Thu, 23 Jul 2026 17:01:40 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Yixun Lan <dlan@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Rob Herring <robh@kernel.org>, Inochi Amaoto <inochiama@gmail.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"spacemit@lists.linux.dev" <spacemit@lists.linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] PCI: Move Spacemit vendor and device IDs to
 linux/pci_ids.h
Message-ID: <20260723220140.GA865834@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <073fbf4b41804285b2df6fbb4efce0ed@realtek.com>

On Thu, Jul 23, 2026 at 01:19:47AM +0000, Ping-Ke Shih wrote:
> Hi PCI maintainers,
> 
> Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com> wrote:
> > Move the vendor and device ID for the existing Spacemit K1 PCIe Root
> > Complex to include/linux/pci_ids.h. Also add K3's Root Complex device ID
> > to this header. This is done so that these values can be referenced in
> > the rtw89 driver to enable 36-bit DMA ability in it for WiFi to function
> > on the K3 Pico ITX board.
> > 
> > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> > Signed-off-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
> > ---
> >  drivers/pci/controller/dwc/pcie-spacemit-k1.c | 3 ---
> >  include/linux/pci_ids.h                       | 4 ++++
> >  2 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/pci/controller/dwc/pcie-spacemit-k1.c
> > b/drivers/pci/controller/dwc/pcie-spacemit-k1.c
> > index be20a520255b6..f89c6d46c7684 100644
> > --- a/drivers/pci/controller/dwc/pcie-spacemit-k1.c
> > +++ b/drivers/pci/controller/dwc/pcie-spacemit-k1.c
> > @@ -21,9 +21,6 @@
> > 
> >  #include "pcie-designware.h"
> > 
> > -#define PCI_VENDOR_ID_SPACEMIT         0x201f
> > -#define PCI_DEVICE_ID_SPACEMIT_K1      0x0001
> > -
> >  /* Offsets and field definitions for link management registers */
> >  #define K1_PHY_AHB_IRQ_EN                      0x0000
> >  #define PCIE_INTERRUPT_EN              BIT(0)
> > diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> > index 1c9d40e09107d..d6f26cacc8e35 100644
> > --- a/include/linux/pci_ids.h
> > +++ b/include/linux/pci_ids.h
> > @@ -2640,6 +2640,10 @@
> >  #define PCI_VENDOR_ID_SUNIX            0x1fd4
> >  #define PCI_DEVICE_ID_SUNIX_1999       0x1999
> > 
> > +#define PCI_VENDOR_ID_SPACEMIT         0x201f
> > +#define PCI_DEVICE_ID_SPACEMIT_K1      0x0001
> > +#define PCI_DEVICE_ID_SPACEMIT_K3      0x0002
> > +
> >  #define PCI_VENDOR_ID_HINT             0x3388
> >  #define PCI_DEVICE_ID_HINT_VXPROII_IDE 0x8013
> 
> As patch 2/2 obviously goes to wireless-next tree, can I take this 
> dependency patch to my tree? 

Yes, that's what my Acked-by at
https://lore.kernel.org/all/20260716164336.GA40813@bhelgaas means.
