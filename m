Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299D824A05D;
	Fri, 24 Jul 2026 02:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784859886; cv=none; b=DCupE5txJHver2m8G7I2ajcAg65l9fl3RK0QOz+Jt0/DOT3gBP7mkfiyTH3v8Q8kcRdtgafnU5GOiydeBRNRAZc5F5aIa+bDAE8rN3Yzkilhh3AsWqebuZ+iIUqtXmCITWi0fhp4nckau/9doG1gpPKnTur4hlqFf5gFD4xviDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784859886; c=relaxed/simple;
	bh=lsy8uY8uOmXJUwdtH59sTFn235H6O3pKzwIl7V6tKc0=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=jeCe8aHWKm+fqt6/I7qoDMyEFmnJyeulNjzNOm1Q+N+3zkTOIcpOCRUQf0nZeH3jNr96PddIpQackbYPyB3X0BxHltc9b0qzPMTPJu4AU1uPungIeY7dctXsky6ui+fooP4Wk2GK+JUZLvw5AnFUWnAsIJp14BCpXjanB0TQgdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ZjyF9+GG; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ZjyF9+GG"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66O2NhNeA920495, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784859823; bh=NxucgfmUZTTQksm+oT0kkIAMiRNz/Lw+gJQy4Q1nerQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=ZjyF9+GG3k2dFJttsAYKW2+RcQKhh0TaSCg/z7srQHpWLaia3zLsaHeYPlHO9TJVp
	 Gq2p6AikuHRGA6G/uBELsEcAh88XBWbNy28OoVXDYC47psBYN+Nq8DkR7w/6InF5yA
	 ogC+ZVcV7Dd5cw7NCHAOWW2jZWbTT3l2me8brdLzVCrZLe4ix0ttLIxt/bN3JcNqIB
	 bZ4xG6aBiIs853U/QE0W2J6TfJgP8M2LZ9Wf14Xl27olkNT8ZshgkCcAL/98eMXob3
	 CdIRDLC57mYNotlcLVjdS/Ui7Zrrbq1eGtYBi/d9GfiuHajNRwuEpVGuqSihBrnVzj
	 +6qNFBuPZYIxQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66O2NhNeA920495
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 24 Jul 2026 10:23:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 10:23:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 10:23:41 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 10:23:36 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>, Bjorn Helgaas
	<bhelgaas@google.com>, Yixun Lan <dlan@kernel.org>, Ping-Ke Shih
	<pkshih@realtek.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>,
	=?utf-8?q?Krzysztof_Wilczy?= =?utf-8?q?=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
	Inochi Amaoto <inochiama@gmail.com>, Aurelien Jarno <aurelien@aurel32.net>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-riscv@lists.infradead.org>, <spacemit@lists.linux.dev>,
	<linux-wireless@vger.kernel.org>, Anirudh Srinivasan
	<asrinivasan@oss.tenstorrent.com>
Subject: Re: [PATCH v2 1/2] PCI: Move Spacemit vendor and device IDs to linux/pci_ids.h
In-Reply-To: <20260716-rtw89-spacemit-k3-v2-1-392b577ebf75@oss.tenstorrent.com>
References: <20260716-rtw89-spacemit-k3-v2-0-392b577ebf75@oss.tenstorrent.com> <20260716-rtw89-spacemit-k3-v2-1-392b577ebf75@oss.tenstorrent.com>
Message-ID: <9659279d-224e-4029-bdc0-d7bfa627c016@RTKEXHMBS06.realtek.com.tw>
Date: Fri, 24 Jul 2026 10:23:36 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com> wrote:

> Move the vendor and device ID for the existing Spacemit K1 PCIe Root
> Complex to include/linux/pci_ids.h. Also add K3's Root Complex device ID
> to this header. This is done so that these values can be referenced in
> the rtw89 driver to enable 36-bit DMA ability in it for WiFi to function
> on the K3 Pico ITX board.
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>

2 patch(es) applied to rtw-next branch of rtw.git, thanks.

888b1934642b PCI: Move Spacemit vendor and device IDs to linux/pci_ids.h
27a5046cc56e wifi: rtw89: pci: enable 36-bit DMA on spacemit K3

---
https://github.com/pkshih/rtw.git

