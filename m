Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3FB46E01F;
	Tue,  1 Sep 2026 07:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788249036; cv=none; b=H3iznkLOH6006n6L9Mt/1uQQNbkc1HN62V6N7u8HoIw3hvoFG7p/IgJlLepitAV9++P+P8YNktjgWHtO0kGDB43ahtT4+Jidljx1jDxpOacTXyVRWXcueCqXa17b85QOaAUMr4dRViI5zt3K7JvOFG3GRdXf1fdxJkYlDmrSolI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788249036; c=relaxed/simple;
	bh=kqWV7eewRd1Mp6Q79yDxU92tWRnsRsSA9cz0QMHLvck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rAWj9UVYsv8RU9t3ZvRl+7eYlMDEBonz7WlALT76LT3sTYfzHCSp8nmS5GuK3iUDvpXf5qogErMn9IbSheH0p8aYFZmK2LaT7TyZ6U2sdwszS/qX+ubDad2MAazoJXKx49RCv1+b/nbUW5zqqUb2rcBWrbAmh/mOO89aHr2sxew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lmzf1UMb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lmzf1UMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978FB1F00A3E;
	Tue,  1 Sep 2026 07:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788249035;
	bh=x1XZqBPHN0ntygf3/sUmkFR/mSTqD3HugbTSHCQc+5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Lmzf1UMbiB39d1gc12cr4PVgNp41UnVkAi4mZKGEy4OqkYosoNwTR2BRsXte2Is3I
	 d2vSAXjExa6n5mANF3a/0flakPB2Y7973LmP3bCiZoYlST3a9Nq82NXz/gVae0/Rmm
	 nZKxEuItT/UTr8/EO/1MX3qgiIBGWeXwZzoorELlCZIsT4s3IHHfHxY9Y/lCtBgWT/
	 6xaf6manuipM75QWrRlmpNwxurmMi0hppVKkB0oz3/MbOaxPD2TI1xOkVmooPyQuma
	 sjXfT3BdbvTQQc5c41DRETIZJ7PXxlI/YotQQzOi+xT6sxCHLnVe0wuxamvW3Z9VKx
	 4PeY2RWDLmcRw==
Date: Tue, 1 Sep 2026 09:50:15 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, 
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>, Jingoo Han <jingoohan1@gmail.com>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Rob Herring <robh@kernel.org>, 
	Jeff Johnson <jjohnson@kernel.org>, Bartosz Golaszewski <brgl@bgdev.pl>, 
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, mhi@lists.linux.dev, linux-wireless@vger.kernel.org, 
	ath11k@lists.infradead.org, qiang.yu@oss.qualcomm.com
Subject: Re: [PATCH v5 3/6] PCI: Add pci_lnkctl2_bus_speed() to convert
 lnkctl2speed to pci_bus_speed
Message-ID: <lcljoi3djqgtxuqqtvb43n6z6ns3kzmjwcceqhvovmiqe4eqhs@chgulo7facny>
References: <20260819-bwscale-v5-0-6dea79786b37@oss.qualcomm.com>
 <20260819-bwscale-v5-3-6dea79786b37@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260819-bwscale-v5-3-6dea79786b37@oss.qualcomm.com>

On Wed, Aug 19, 2026 at 06:55:54PM +0530, Krishna Chaitanya Chundru wrote:
> Add a exported function to convert lnkctl2speed to enum pci_bus_speed,
> so that other kernel drivers can use it.
> 
> Signed-off-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
> ---
>  drivers/pci/pci.c   | 15 +++++++++++++++
>  include/linux/pci.h |  1 +
>  2 files changed, 16 insertions(+)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 77b17b13ee61..cda7d210ddbf 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -5939,6 +5939,21 @@ int pcie_link_speed_mbps(struct pci_dev *pdev)
>  }
>  EXPORT_SYMBOL(pcie_link_speed_mbps);
>  
> +/**
> + * pci_lnkctl2_bus_speed - convert Link Control 2 Target Link Speed to pci_bus_speed
> + * @speed: Target Link Speed (TLS) value from Link Control 2 register (0-4 for Gen1-Gen5)

Use GT/S instead of Gen.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
