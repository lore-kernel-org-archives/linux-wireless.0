Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490DE1D5178;
	Sat, 14 Mar 2026 00:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773446900; cv=none; b=i1fY4SR+DNoL3Bjs9aQxWSQ+YYIhBeH7YAGlm7HfaExHqqd/GXDs10O3SZ3Bn6vylvQw7gYmD3YSQQPpE3mibkLoZs6ISsWyuf2bsBmdAtsHfe6hZuHs6kmTX8o8DPJ4dG99f0FfCOa3DPG+hRRYhK+6mRNQWlsS0GBQulOlq60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773446900; c=relaxed/simple;
	bh=7gNCDydkgxUZvseLqPsVtxB6EjOzf+D38jXxxHFS1RI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s1kGu9jmi7k2nr1XvrhJ+QgbdH7V9yFYiYCkDQmSXWOn0SGuiZz6qHW91XF7+2bcu/bzUSqstFtqOlOBgENsFadq5V8ndUkBh+Dtk5Qf9FGNnMPe6CSeqiyl9C08Py2lE+PZZrS9cV6+byHHk4PZADIrBuhuUmjMTwDUsOyeNOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dvSTOH67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dvSTOH67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E686C19421;
	Sat, 14 Mar 2026 00:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773446899;
	bh=7gNCDydkgxUZvseLqPsVtxB6EjOzf+D38jXxxHFS1RI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dvSTOH67VHiMLz2VR34KszR3m2sZfJb/89XLPZOiVu6ezSidZMe1YYywy7Tsq470i
	 DgvP3Ktwbgdyiiks+MeQJWchthxll7aFbehD//QQP1UbB1pHYjELIiHiJlAcqnEmiv
	 pkJ/8rn25WN+/qLGjie4Km3GY+By7D9LetSXDAaGve/vjib5QWvzWPRr8y30CRt0/R
	 rQQ0EVzjJG4jB/t/tftsxgoTEEF+mM83fRWWs2dzu/fXETiK5z7xBSiptBBUvZQLjR
	 0qap7XMOxQjnH3Y2S8tjZGyXaLEf0YdeYrfKQGA3CYRhcBg13zBGJT3rT9sS5vSr5y
	 FlHJKrVui89Yg==
Date: Fri, 13 Mar 2026 19:08:18 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: briannorris@chromium.org, conor+dt@kernel.org,
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	johannes@sipsolutions.net, krzk+dt@kernel.org, kvalo@kernel.org,
	linux-kernel@vger.kernel.org, Frank.Li@nxp.com
Subject: Re: [PATCH] dt-bindings: net: wireless: marvell,sd8787: Relax length
 constraints
Message-ID: <177344689795.3706356.13043407533958417879.robh@kernel.org>
References: <20260311194531.70441-1-festevam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311194531.70441-1-festevam@gmail.com>


On Wed, 11 Mar 2026 16:45:31 -0300, Fabio Estevam wrote:
> Commit 31ed9d9d71ec ("ARM: dts: rockchip: Limit WiFi TX power on
> rk3288-veyron-jerry") added calibration data for the rk3288-veyron-jerry
> platform. The commit message explicitly notes that "the length can vary
> between hw versions", as documented in the original text binding.
> 
> The current YAML schema enforces fixed maximum lengths for calibration
> data arrays, which causes dtbs_check warnings for rk3288-veyron-jerry.dts.
> 
> Relax the constraints for the two properties that have
> variable-length data in this platform by adding minItems based on the
> actual data used in the downstream kernel:
> 
> - marvell,caldata-txpwrlimit-2g: 508 bytes (from rk3288-veyron-jerry.dts)
> - marvell,caldata-txpwrlimit-5g-sub2: 744 bytes (from
> rk3288-veyron-jerry.dts)
> 
> The original maxItems values are preserved as upper bounds to maintain
> validation for other platforms while accommodating this specific
> hardware variant.
> 
> Fixes: 25f855413885 ("dt-bindings: net: wireless: convert marvel-8xxx.txt to yaml format")
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
>  .../devicetree/bindings/net/wireless/marvell,sd8787.yaml        | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring (Arm) <robh@kernel.org>

