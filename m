Received: from hall.aurel32.net (hall.aurel32.net [195.154.119.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D370222590;
	Thu, 16 Jul 2026 21:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.154.119.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784237656; cv=none; b=AHjNR4uv9v85Z4NVeDbEWzqxg31vro8ihOXIa+SoCidJgjJHQhMfE4dL+RkBds220yR5GpG5qOWC3RQu3U0wdthoa9IQ017d7EoY1D8FnAnOPWpxN+hgkgmfI6t778w6eN82z/fQD6/De0gqgOGSyjLYKqRXkUWe8fFj0rHXOUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784237656; c=relaxed/simple;
	bh=LAk2iHu6QOoA9QS6Y2VvYmVIZSpjNqwyrc354PfzJpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=umNRCeB794fM2s+xfzp6WoCS5zncDuHU/f2/DHI6zC6JMeUeviVaypah/HYhGKDH6/fu0Jtddc2NyFDmEuMV4mio/Lyd9JoIKQ+ZIo4IvTv9mvgrak01PrzmxoVlEO8ilDnvjyJxKhJKgR/AC8s4Sd6Bk//nhT67afEw7gBKliU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aurel32.net; spf=pass smtp.mailfrom=aurel32.net; dkim=pass (2048-bit key) header.d=aurel32.net header.i=@aurel32.net header.b=SBxrP0q5; arc=none smtp.client-ip=195.154.119.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aurel32.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aurel32.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aurel32.net header.i=@aurel32.net header.b="SBxrP0q5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
	; s=202004.hall; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:From:Reply-To:
	Subject:Content-ID:Content-Description:X-Debbugs-Cc;
	bh=YfuBW0J2fn5ZiwXHo1KSEOKKeic0LKpEnanL6byFMyo=; b=SBxrP0q5LPnJRGpMhswU/BWGFv
	l0WRrSpbbmR/2jTVF+z9SV25CG+4dL/iKFSKq8h3sWEWUxpi33IPuFxOUMf5RDwhiOTDe2+arjYw0
	yN18tnx1MpTuUH+C7WOdcvatPv9VTUMYo2O1MMw5NryfRm8iTkb6hHR/ImDMaPzJ0CBHoWsPijxUC
	mmh6v8vhBMHIIJRa+F7roJzy4gVqo2h9XHrpBVboIxD3WeUlZGKeBeZE5ZkpX9GkpTST9YdFiWb3n
	4IOw6o1X27xzvlAJ36JVDWW2cPejT5Rzrrzy0k0EHXa48M3IpiPNE+v0qtizv4Ml4FOR4/YOuIdKH
	evEKcKpw==;
Received: from authenticated user
	by hall.aurel32.net with esmtpsa  (TLS1.3)  tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <aurelien@aurel32.net>)
	id 1wkTid-00000003GcB-3Ces;
	Thu, 16 Jul 2026 23:34:11 +0200
Date: Thu, 16 Jul 2026 23:34:11 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
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
Subject: Re: [PATCH 2/2] wifi: rtw89: pci: enable 36-bit DMA on spacemit K3
Message-ID: <allOU8-v6WviIJ_Y@aurel32.net>
Mail-Followup-To: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Yixun Lan <dlan@kernel.org>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Rob Herring <robh@kernel.org>, Inochi Amaoto <inochiama@gmail.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-wireless@vger.kernel.org
References: <20260715-rtw89-spacemit-k3-v1-0-e577bc63706b@oss.tenstorrent.com>
 <20260715-rtw89-spacemit-k3-v1-2-e577bc63706b@oss.tenstorrent.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715-rtw89-spacemit-k3-v1-2-e577bc63706b@oss.tenstorrent.com>
User-Agent: Mutt/2.2.13 (2024-03-09)

On 2026-07-15 22:21, Anirudh Srinivasan wrote:
> The Spacemit K3 Pico ITX Board has a RTL8852BE pcie card behind a PCIe
> root port, but the SoC doesn't have any 32 DMA addreseses which the
> rtw89 seems to use by default. Enable 36 bit DMA ability that the driver
> has when this particular root port is detected so that the driver can
> probe on this SoC.
> 
> Signed-off-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
> ---
>  drivers/net/wireless/realtek/rtw89/pci.c | 4 ++++
>  1 file changed, 4 insertions(+)

Tested-by: Aurelien Jarno <aurelien@aurel32.net>

Note that you probably want the following patch to get the controller to 
connect to a WiFi network:
https://lore.kernel.org/spacemit/20260716213314.3027969-5-aurelien@aurel32.net 

-- 
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                     http://aurel32.net
