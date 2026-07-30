Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F873C1D49;
	Thu, 30 Jul 2026 07:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397095; cv=none; b=qLqWtIhCvjLBJf76bqn56/1IEsyR76nwp9TSp8fCxQDw7KhzmeM79ILFBfAmKSN42195wWwIR83vraqPbYTi9ALDfNES94fNX2SUcqAAnD1tBEGtwkHHBtQSB+1l1FFsTWPzRnNtJGcKebRylGobXmMhai4SsdfIQjhW1uellZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397095; c=relaxed/simple;
	bh=rRnZ0ceRPi+zXWGSS85s7l6A8rfkuAb4ghrCfWIEfvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AwMZAz76wcU6uizV64FXqMT5XDlc3oQ1aD91hPVCdg+tJtDLT4S25TdzCpxfzakEXdsDjHPbB50ks5zzb3dzkNHUdIlwrkQ/N3vsH6ILpsIlmbtljG0D6tJgak8swAawQ4pXpm4sjzNI36OgVEA/rQtx9qdM8x8Phc8Q8YupsWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O9GIgKWC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O9GIgKWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065051F000E9;
	Thu, 30 Jul 2026 07:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785397084;
	bh=IFDCzAc/atiNlFPApCj0Q/njGBRbp8TZ6+I8T1KQosU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O9GIgKWCg4erTrfE/I09ys0ZzkfvSBJPSJb/wCngONIhyqDEN78FbIBUbTmw89Kaf
	 mIqwJExFTwxEtCnzRac9cEQGZVWHB7m0lcWpu2DeJJqvjBzsb+Xf0bXRABYa6vUl8r
	 BJjUyYYQsTCrvgk755eKp1eWJn5DQOKMloXigYMw=
Date: Thu, 30 Jul 2026 09:36:37 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Yi Cong <cong.yi@linux.dev>
Cc: linux-staging@lists.linux.dev, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yi Cong <yicong@kylinos.cn>
Subject: Re: [PATCH 0/4] staging: rtl8723bs: fix several memory-safety bugs
Message-ID: <2026073019-ambition-muskiness-2f9b@gregkh>
References: <20260729022509.2863634-1-cong.yi@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729022509.2863634-1-cong.yi@linux.dev>

On Wed, Jul 29, 2026 at 10:25:05AM +0800, Yi Cong wrote:
> From: Yi Cong <yicong@kylinos.cn>
> 
> This small series fixes four memory-safety / resource-management bugs in
> the rtl8723bs SDIO staging driver.
> 
> All four are tagged:
> 
>   Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
> 
>   1/4 - kfree() used on a vzalloc() allocation (HalData) in the probe
>         error path.
>   2/4 - double free / UAF when register_netdev() fails: the error label
>         frees objects that the caller also frees.
>   3/4 - NULL deref in c2h_wk_callback() when the re-read allocation under
>         memory pressure fails.
>   4/4 - NULL deref on a bcmc station lookup in the 802.11 defrag path,
>         reachable from a fragment with an unknown transmitter address.
> 
> Yi Cong (4):
>   staging: rtl8723bs: free HalData with vfree, not kfree
>   staging: rtl8723bs: fix double free when register_netdev() fails
>   staging: rtl8723bs: fix NULL deref in c2h_wk_callback() on alloc
>     failure
>   staging: rtl8723bs: fix NULL deref on bcmc station lookup in defrag
>     path
> 
>  drivers/staging/rtl8723bs/core/rtw_cmd.c     |  6 ++++++
>  drivers/staging/rtl8723bs/core/rtw_recv.c    |  5 ++++-
>  drivers/staging/rtl8723bs/os_dep/os_intfs.c  | 10 ++++++----
>  drivers/staging/rtl8723bs/os_dep/sdio_intf.c |  2 +-
>  4 files changed, 17 insertions(+), 6 deletions(-)

Did you forget to document the tool you used to find and fix these
issues?

thanks,

greg k-h
