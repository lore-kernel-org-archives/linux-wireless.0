Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F082A1C9EA4;
	Fri,  6 Sep 2024 15:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725635311; cv=none; b=J4/aPtutmiAQadzg8H7W//DeZQzDRh0xfMdH2v28XXhcnxzrbBJLB3YJKcsqxdIr9je247BmtcAgI4KjkU54a23HDIktyHoc2u8CY2ZnPUVvGS/QHojVa3Tn0iucqow92SQZWu6As4wsxYmQ3F8/9YbabEz0xH+wWiLr21rxTmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725635311; c=relaxed/simple;
	bh=1VePcOu7hc3B4DA2AG32cM0YPUv3ebdngR0E6P1HxVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g1vaf0YO3WvbRZqiPHlJNDvpWjn2FG7iqYPkz/dvEQt9tLGcv9IFIcKem4PE9Q3AFLqrMjL7wSSS2EbEuisFR9v0lbyFQo/GjJ17rUQlG2VRB1LzUxaSibh56GQJliSRKsSs+7xiZXatnTV7kHvfiVlf3yEMlmUaDAS18+4XviM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=jC9HcaGt; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="jC9HcaGt"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id A99A61F9DF;
	Fri,  6 Sep 2024 17:08:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1725635307;
	bh=ZmhXPPUu0HqOZzPAydE7JyFRNTecactfU3qfikysiXw=; h=From:To:Subject;
	b=jC9HcaGtKyzbq5BcqabNWjXTxV4WaxyvVSVhcPH5WBRbAYzspZmc5uBu8URnMSsGj
	 i6S+pQIUCXX+ipTcsBg/g2UOi1xQMNfqnsZpq5YzUCdg70HmDbvsE/OvqeRGjv9To7
	 ktity8nDBNnw3qpLrw4IMk8vvNMomvOKWt5lwZkbzTKvm71XnB1I1g4Nc776/C4sgs
	 yKcfEj+UrrXu+LrRwTKmaGmnzeflQTAZPG+LPVJ4EeaFBlL3vSkpeTGGjA8vADGdUz
	 RVJMmZehhghEW58S6MOFnzw38NGz8XFIpGrnZGG+bGgO6TfgqrqYNDuZ1AMe312lfR
	 I5mE3Ct/OyA5A==
Date: Fri, 6 Sep 2024 17:08:26 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/12] wifi: mwifiex: make region_code_mapping_t const
Message-ID: <20240906150826.GE45399@francesco-nb>
References: <20240826-mwifiex-cleanup-1-v1-0-56e6f8e056ec@pengutronix.de>
 <20240826-mwifiex-cleanup-1-v1-6-56e6f8e056ec@pengutronix.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826-mwifiex-cleanup-1-v1-6-56e6f8e056ec@pengutronix.de>

On Mon, Aug 26, 2024 at 01:01:27PM +0200, Sascha Hauer wrote:
> region_code_mapping_t is not modified and shouldn't be. Mark it const.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>

