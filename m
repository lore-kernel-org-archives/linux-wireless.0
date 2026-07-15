Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D481D3AEF4C;
	Wed, 15 Jul 2026 16:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784132064; cv=none; b=f/IqwNeGhln3PmrgnCmeIw3SwROxgFhZj8YXeaYD898O23/dUWdEUq/1WI4o98A7ILmJiHi+r8QuDjeeX7TvoYroAiU/TAxlLhdzgc1mY0SufMLbgZ7yiwFKGvbKPCsqS5e19IhTY6LW3eNuA4vpu2t2MGgc7dwew+aOaWcgYdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784132064; c=relaxed/simple;
	bh=JtHOXern9zG+y+CNj3GqAJq7wJecWtmiI2DXiJ2W8cA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tbxD1GwpcS2aYM6f45Bc0vAR7/XB+KX34mtHJNWA3mIuQvlmvFpGVdFdTtiWCC2IY8NfgnhP4L5Tc+hNXmoGQkWmJVw1oUcoC4D23Bvg0Exv5mbWKWyiqmE9MdjQTOVs7xDyAuNGaU9q0AgByZe6mnVzrvnLGYb9E+HrKqdRMro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=suA4BVgS; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="suA4BVgS"
Received: from francesco-nb (xcpe-178-82-120-96.dyn.res.sunrise.net [178.82.120.96])
	by mail11.truemail.it (Postfix) with ESMTPA id 125FC1F8BF;
	Wed, 15 Jul 2026 18:14:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1784132049;
	bh=/GNvk2djrYsPxam634602fuyvgzMBSALXNiJWT565uc=; h=From:To:Subject;
	b=suA4BVgSQcJc49v/VAQFV3qtI8h7hoezmjRrcE2lC2p2HhPGwcdzDc4Vspu4RgSS3
	 c+g9VmLjOMY8gQ52No8HfriQT2rDTRdRMRRjOPEJ5t9iXcMTbXC6kVY1yLCRaSrzOP
	 7uz9Ul4r41+v177E3N2MaIwxA1Ln/fJ52JjmV1kjy1vTZW5upYPeaZt/bdOO7tw5Ij
	 R7g6/YtrVSrS3yCSMNOt/nm4QBeB+8k0EIEph4r3ozisJdavYe7Lct/OmIBCUxaz4B
	 sXmjU3VyKRc7sM3s6NXr5lkmGzKkstOMi6LIZ+Y2BSt1TPCkZVTqvARBlmI6/kEqhk
	 KwLb2yHy4DfQg==
Date: Wed, 15 Jul 2026 18:14:07 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Georgi Valkov <gvalkov@gmail.com>
Cc: briannorris@chromium.org, francesco@dolcini.it, johannes.berg@intel.com,
	bhelgaas@google.com, error27@gmail.com, s.kerkmann@pengutronix.de,
	kees@kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: mwifiex: replace one-element arrays with flexible
 array members
Message-ID: <20260715161407.GH56330@francesco-nb>
References: <20260712222334.7134-1-gvalkov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712222334.7134-1-gvalkov@gmail.com>

On Mon, Jul 13, 2026 at 01:23:34AM +0300, Georgi Valkov wrote:
> Replace deprecated one-element arrays with flexible array members.
> CONFIG_FORTIFY_SOURCE reports the following warning when
> one-element arrays are used as variable-length buffers:
> 
> sta_cmd.c:1033 mwifiex_sta_prepare_cmd
> memcpy: detected field-spanning write (size 84) of single field
> "domain->triplet" at .../marvell/mwifiex/sta_cmd.c:1033 (size 3)
> 
> Convert affected structs to use flexible array members.
> - Preserve existing wire layouts.
> - Replace affected uses of sizeof(member) with sizeof(type).
> - Replace unions containing one-element arrays with
>   u8 flexible arrays, and document the stored parameter-set type.
> 
> Tested-on: WRT3200ACM, OpenWrt
> Signed-off-by: Georgi Valkov <gvalkov@gmail.com>

Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>

