Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9900318C2C;
	Fri, 24 Jul 2026 00:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784851596; cv=none; b=W8zIXlCx1YOFQTrbSj65Symdpi1w7mVvJUBNd5DRo6qvsjbgbidJn5REm2T/+9bOJJOlPw4bVO8U/LbFuGig9wHf+xxzU/hY/OKGwnZHgmQAPfGtKpJ6uX784W9TWzYrN1zlw71itNy3cIrquw1Nc99JP7qMWb/rpMsD10C0HUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784851596; c=relaxed/simple;
	bh=mMlynwVW8+z0LYCmqE4H8N6/c8djAx8rwAn+H5O6IYE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gQPspPaVJTdUQ/bcZ0BhfblX4etY0eWkDAXEQFzM2fRhMMofmBXm7lAkj4tRdHtXq4LkHUFFwXCDtwU8meM/yxtK+QGi7ie+B7qSFnC78iFZw2tMvpeKUIvf73QoC+Ll35gQIpQg5KsF4OCSfcJnQDVNDLm5vixxPCsnB4YQfc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=cjk4Mu1N; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="cjk4Mu1N"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66O05crZ6816527, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784851538; bh=2KI8AfOPOXl0f250iINHG39YRU3B5MnXfsv7pT1KX/g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=cjk4Mu1NmfnwTJBZcnMDXzJMHkenqntKCcNrpFKczgluAvUizFrKtjpifNaf3wNVj
	 q+CSk56M5MCweQQ732WkNMGNXlKVFPnFos1Aq0PJJ8KqAYPi/9H5TjUCefRL3aVW9Q
	 19lk8mWGBmVzXnAzIGoASQS7AVBof6gpYA3Pisi3uKfpoRiSlELSobP8yYdkSzNQKa
	 fOZx04Woq3UTNGHpmIxKTIcNeq6sEE3BGL55iv5ghvtIQ3tuHe2eRib+905fqx/NEu
	 vdu7B0SX9Wnx0Z39esj0Tkz1ok5P+lirO98xxOnduiLSy1BUz3atMYg9MgQ70/91XH
	 Fb+21GvWMnWTg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66O05crZ6816527
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 24 Jul 2026 08:05:38 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 08:05:38 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 08:05:38 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Fri, 24 Jul 2026 08:05:38 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bjorn Helgaas <helgaas@kernel.org>
CC: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>, Bjorn Helgaas
	<bhelgaas@google.com>, Yixun Lan <dlan@kernel.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, =?iso-8859-2?Q?Krzysztof_Wilczy=F1ski?=
	<kwilczynski@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, "Rob
 Herring" <robh@kernel.org>, Inochi Amaoto <inochiama@gmail.com>, "Aurelien
 Jarno" <aurelien@aurel32.net>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "spacemit@lists.linux.dev"
	<spacemit@lists.linux.dev>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] PCI: Move Spacemit vendor and device IDs to
 linux/pci_ids.h
Thread-Topic: [PATCH v2 1/2] PCI: Move Spacemit vendor and device IDs to
 linux/pci_ids.h
Thread-Index: AQHdFXehTbmbDPtnB0KyE0vFNWAFDLZ6Vr7ggADV5ACAAKiGMA==
Date: Fri, 24 Jul 2026 00:05:37 +0000
Message-ID: <e437ff6da5ea494e83edcfd2605632cb@realtek.com>
References: <073fbf4b41804285b2df6fbb4efce0ed@realtek.com>
 <20260723220140.GA865834@bhelgaas>
In-Reply-To: <20260723220140.GA865834@bhelgaas>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Bjorn Helgaas <helgaas@kernel.org> wrote:
> On Thu, Jul 23, 2026 at 01:19:47AM +0000, Ping-Ke Shih wrote:
> > Hi PCI maintainers,
> >
> > Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com> wrote:
> > > Move the vendor and device ID for the existing Spacemit K1 PCIe Root
> > > Complex to include/linux/pci_ids.h. Also add K3's Root Complex device=
 ID
> > > to this header. This is done so that these values can be referenced i=
n
> > > the rtw89 driver to enable 36-bit DMA ability in it for WiFi to funct=
ion
> > > on the K3 Pico ITX board.
> > >
> > > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> > > Signed-off-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
> > > ---
> > >  drivers/pci/controller/dwc/pcie-spacemit-k1.c | 3 ---
> > >  include/linux/pci_ids.h                       | 4 ++++
> > >  2 files changed, 4 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/pci/controller/dwc/pcie-spacemit-k1.c
> > > b/drivers/pci/controller/dwc/pcie-spacemit-k1.c
> > > index be20a520255b6..f89c6d46c7684 100644
> > > --- a/drivers/pci/controller/dwc/pcie-spacemit-k1.c
> > > +++ b/drivers/pci/controller/dwc/pcie-spacemit-k1.c
> > > @@ -21,9 +21,6 @@
> > >
> > >  #include "pcie-designware.h"
> > >
> > > -#define PCI_VENDOR_ID_SPACEMIT         0x201f
> > > -#define PCI_DEVICE_ID_SPACEMIT_K1      0x0001
> > > -
> > >  /* Offsets and field definitions for link management registers */
> > >  #define K1_PHY_AHB_IRQ_EN                      0x0000
> > >  #define PCIE_INTERRUPT_EN              BIT(0)
> > > diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> > > index 1c9d40e09107d..d6f26cacc8e35 100644
> > > --- a/include/linux/pci_ids.h
> > > +++ b/include/linux/pci_ids.h
> > > @@ -2640,6 +2640,10 @@
> > >  #define PCI_VENDOR_ID_SUNIX            0x1fd4
> > >  #define PCI_DEVICE_ID_SUNIX_1999       0x1999
> > >
> > > +#define PCI_VENDOR_ID_SPACEMIT         0x201f
> > > +#define PCI_DEVICE_ID_SPACEMIT_K1      0x0001
> > > +#define PCI_DEVICE_ID_SPACEMIT_K3      0x0002
> > > +
> > >  #define PCI_VENDOR_ID_HINT             0x3388
> > >  #define PCI_DEVICE_ID_HINT_VXPROII_IDE 0x8013
> >
> > As patch 2/2 obviously goes to wireless-next tree, can I take this
> > dependency patch to my tree?
>=20
> Yes, that's what my Acked-by at
> https://lore.kernel.org/all/20260716164336.GA40813@bhelgaas means.

Thanks for the confirmation. :)


