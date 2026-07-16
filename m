Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1FC3D647C
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 22:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784240674; cv=none; b=fIczallWyFrI4tqRhsRkE6zI7rHsCKefleFvgUqIHAEfpLyZC3qdlNpBpXTtOqnrifBfbT8eKYhtvYjeLMsxN5/sC6p29f4gBDXMw1P+WdsKQJuyJd6o0iz0YGEW+nuAA5OfUG12dRXkceXmZomb5aYYjgudkxy8m43G+watwRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784240674; c=relaxed/simple;
	bh=tY5kO68rCs5HDRAHbRnGR5V/lZbXU+QUuaEDKnD915Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q4Zamnm9B96CVqvmasi0xK8p2iPl8Lv2Bg/9Fb5iXRFdzSRIslQ4mz2nGHMuGyrJ2imrpbYNjHzwLnUzu6ii+iZJHNMlNUij2n35plpu1MV3bCO2e+g5VWILmPyLiEDgEpi/gV6Di3EzxbIU4mnWdCrUuxw2G+9ijieZDX3jIVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iE2sVe85; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iE2sVe85"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cc6dd436c6so47563435ad.2
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 15:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784240672; x=1784845472; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9PybPTeqqbJDW21nWTn74STz945nRwE+oCCkAETAhAs=;
        b=iE2sVe85QIWzuA7Bqz+2/1r6wdl36yZF/HPmv7gSAZLllO1TDW7Z5uRaYU0SLItRiJ
         icNnpOe78FCF3raiT6cY/wNy/bppJJuOVBZlomI/jCGT7qiKw9+HKZEzAITSHOY3bTzr
         G7LLCXa277HwHFogcTDYa1jw2qW01Ou7i1lQ5FY4z7Vf6hV/8sU0eyH/M6fsilNxhH3+
         dhNqcyqUxEoeQrYwKRp4U6khy3DiVuh29/5ZTM1mNN5tOw1YbG/Nj4kzfX1K8wQH9ogM
         RRnDchl/x/i5f9ftaPQ+xZzzRn5LJjHBNMRnKID4RYwGYXIKn86fTP6zMazRu4ri81Hp
         /I6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784240672; x=1784845472;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9PybPTeqqbJDW21nWTn74STz945nRwE+oCCkAETAhAs=;
        b=qco+Ei96B0PqEDvne/zLeiQnMW4kZkzRX1lPNb3UJBF9d8EZDuoYAX1IArwAIiEFHm
         BD30r7Hhqz8+6g28UZTTy6Kdd7hBTJE7DqSCm9viyG+RudcDAlNzWShWos6q/QAz6c5N
         E98kgucPf+VsNHCyUhr/kj6AJgxmKYNMIjl5vBX3g7dA2NL0MEeECpGbwmxV0aBLQeDQ
         59mrkPrp6lDARXCS2R/dmcK0VsnSB43qLXA2fo0zgLSO2jc/Zmcq8+61tlc70xkMNn+5
         g8C27PXcDWNbjdJ8D3HfgPn3oVBq/VwM6WV8USjc8dv1VEDXQSd0Uy+qEjFo+FOhoWbK
         X9Sw==
X-Forwarded-Encrypted: i=1; AHgh+Ro/utWrxxCIDUTwa2/l8e1N4GG7CyqC5x1eKnh2HTAzNUoNuTYBEeQbdfuyTz3cC4ZO5zpolLaAD3vc7jYnAA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzRBt0f2C4D19BGfnzT+EQUSLNGWcdl1qupxXcdRQhjyiETu0Lw
	HEQFmlAp2RBpzkwFlXQWp51sHFJLeBDt9cM4dPRQ/rFeRNF8/uIqGKIN
X-Gm-Gg: AfdE7cloaYc6exkbOBFBsyZo5HffM3OsEQmneTSawlUXvPp9Z7sqZV85JpnZtPNwhxx
	0nwFRMU5zRA/w4WZQpUvpeA3JL81on5y6q8Uf9e0KbDaXSi6lCFWMKTgcAujBPQ/SCsWvToorCe
	RNVl3dQY4ZiKZYufHRi1zarj4oauPq+CGdk9lb8r6kKdiIjqPDqbIFEFKyCRGDlqp5TsxROntHE
	9dpAS1JZCgRES6smYFUsQAggBMRvavFWPwGpDN3GFDo20na3K3AChgNZ4sYZbnh4zG9I3+zwiRT
	Kp9W/922KrPCO8UAr96wIgQHGulM5eCr2ZbsnzqogMuTzk/Pt8neXPXRaZ7+aOut/X7TC0Ep/jp
	PoFlvUIvtd7Iq7UThMLEsMdRXPzhfregoKBGVdvTJJOKHLbkbfFJKog==
X-Received: by 2002:a17:903:3c46:b0:2ca:17a8:cfce with SMTP id d9443c01a7336-2cf2ec27781mr13004505ad.29.1784240672371;
        Thu, 16 Jul 2026 15:24:32 -0700 (PDT)
Received: from localhost ([2001:da8:7001:11::cb])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13cd4341a37sm12337420c88.12.2026.07.16.15.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 15:24:31 -0700 (PDT)
Date: Fri, 17 Jul 2026 06:23:42 +0800
From: Inochi Amaoto <inochiama@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>, 
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yixun Lan <dlan@kernel.org>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>, 
	Inochi Amaoto <inochiama@gmail.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, "spacemit@lists.linux.dev" <spacemit@lists.linux.dev>, 
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] wifi: rtw89: pci: enable 36-bit DMA on spacemit K3
Message-ID: <allZOmTRIvot39Gj@inochi.infowork>
References: <20260715-rtw89-spacemit-k3-v1-0-e577bc63706b@oss.tenstorrent.com>
 <20260715-rtw89-spacemit-k3-v1-2-e577bc63706b@oss.tenstorrent.com>
 <e7a43955e41c4dbdb864e89edc3d9fe6@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7a43955e41c4dbdb864e89edc3d9fe6@realtek.com>

On Thu, Jul 16, 2026 at 09:22:17AM +0000, Ping-Ke Shih wrote:
> Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com> wrote:
> > The Spacemit K3 Pico ITX Board has a RTL8852BE pcie card behind a PCIe
> > root port, but the SoC doesn't have any 32 DMA addreseses which the
> > rtw89 seems to use by default. Enable 36 bit DMA ability that the driver
> > has when this particular root port is detected so that the driver can
> > probe on this SoC.
> > 
> > Signed-off-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
> 
> This patch looks good to me:
> 
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> 
> But I wonder how this patchset goes via which tree. I'm happy to merge
> them into rtw tree and then wireless-next tree if people can ack
> patch 1/2.
> 
> 

These IDs are from my patchset.
https://lore.kernel.org/spacemit/20260709040027.958400-1-inochiama@gmail.com/

I think Anirudh can move this ID and add them to the pci_ids.h
directly, And I can adjust my patch to depend on this. It still
needs some improvement to be merged.

Regards,
Inochi


