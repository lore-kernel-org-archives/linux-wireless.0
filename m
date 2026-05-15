Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C2E3D6CB6;
	Fri, 15 May 2026 17:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778865332; cv=none; b=t6k++tY3/xcwkBY3nLi/bFMZRt0WYJSzme/oldPfhf68eG9cS/hkFNTS/Sd2b/38rINNEMVAd5REO10ef2KSWXkgrwaAysVjoSRpEUEgI3NUA8Lw3xRznujS2a1vkrNrl+DOlX6/1wLyBe2rk14x/gP9Z+zobazoNG0dIq5mTRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778865332; c=relaxed/simple;
	bh=CM0V58KaXrnIJ5af5IeXhXV5TxPexciNijWYCIpMZVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nvMtiS20Ogvflro8c5uHxh6viK/TH/B9bTzoiP+p1TampRCTQ2zSwxgQKtd9tdKeIzwOaxKs8yuD8BLTvhiDGeZGKkVWtd2SJpwNu10Z4OG4TN6okhxM3MiDM6sKDTYG7IgZUZ2Nd0d9nikbTmES9c9/mycq1Xmok9XTbDCVbY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q7q2vEiL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q7q2vEiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044C5C2BCB0;
	Fri, 15 May 2026 17:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778865331;
	bh=CM0V58KaXrnIJ5af5IeXhXV5TxPexciNijWYCIpMZVo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q7q2vEiLcsoinAIDcaqiGXy669Q1Chd5+DjsQETBbQ26jeIXt+j/xEhO2yCHTQXr/
	 DFbiVWc953rtO08nmbzJO1pmary5BoDFg0PGJT8AZlzMbNOISJJ4ZpwoVaVqqpp8Y3
	 uK2gJRFK2eLUneqdO6e43WJJQ5TqE8/yIP3phL1smyoKAu7LXvogyAzh2wC3drnIsX
	 z43i+azb2vv8rjlP8M9Zc2qSf/1obrIGDVn2gmE1lSvc3GncaGkJ9KXy68IFxkmGv5
	 DfWY+5U770xxi4mCCEz5DQeuq1On0z2F7F25hjdYst+p6bqNWV350fDG2rIr41orls
	 6cNfP9kZSp8kA==
Date: Fri, 15 May 2026 18:15:27 +0100
From: Simon Horman <horms@kernel.org>
To: Shitalkumar Gandhi <shital.gandhi45@gmail.com>
Cc: ajay.kathat@microchip.com, claudiu.beznea@tuxon.dev, kvalo@kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>
Subject: Re: [PATCH v2 v2] wifi: wilc1000: fix dma_buffer leak on bus acquire
 failure
Message-ID: <20260515171527.GH227382@horms.kernel.org>
References: <20260510112520.977360-1-shitalkumar.gandhi@cambiumnetworks.com>
 <20260511042732.998311-1-shitalkumar.gandhi@cambiumnetworks.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511042732.998311-1-shitalkumar.gandhi@cambiumnetworks.com>

On Mon, May 11, 2026 at 09:57:32AM +0530, Shitalkumar Gandhi wrote:
> wilc_wlan_firmware_download() allocates dma_buffer with kmalloc() at
> the top of the function and uses a 'fail:' label to free it via
> kfree(dma_buffer) on error.
> 
> All later error paths correctly use 'goto fail' to route through this
> cleanup. However, the early failure path after the first acquire_bus()
> call uses a bare 'return ret;', which leaks dma_buffer whenever the bus
> acquire fails.
> 
> Replace the early return with goto fail so the existing cleanup path
> runs.
> 
> Found via a custom Coccinelle semantic patch hunting for kmalloc'd
> locals leaked on early-return error paths in driver firmware-download
> code.
> 
> Fixes: 1241c5650ff7 ("wifi: wilc1000: Fill in missing error handling")
> Signed-off-by: Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>
> ---
> Changes since v1:
>   - Corrected From: and Signed-off-by: to author's real identity
>     (Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>).
>     v1 was sent with incorrect author attribution due to a local
>     git config mistake. No code changes.

Reviewed-by: Simon Horman <horms@kernel.org>

