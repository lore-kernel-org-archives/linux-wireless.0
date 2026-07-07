Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A221512CDBE;
	Tue,  7 Jul 2026 14:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783435567; cv=none; b=CWHoeF2GU7ixGxPwIWr6n49WO1okJDoLH+c6bsQIKoyG5FLLU2H4Z7wbvCcdr3NtewwhTeMeUchMwUcbgL1I1z6XpoEszqOP8Y+3TWltF5fxbs8FPrW2keqtmicDqBb4YJqLquFZ5pJ0jy5Gm7pDejLMqPFQJGSp+QuKt3vrPbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783435567; c=relaxed/simple;
	bh=LEyF9w8SPCzfdrRD+YDZIfJow2IM6iqVN/nTK27WsnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L1/y1gdg1PdebtRkELdRCifLJUBDKEqBLAahg0wXJ2d1cfVRwrStu83zCDPCRtMdCepw+LCQ5yb3/NuNwYaRIKb2M3i6iUNYylJE+PkAoNySQ6NdMGw3OL7jSGpBEH0HSvJdI/1m51VOKmykC4poi2NaY+y4gCJouibvxLCyh7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BpkPQxRV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BpkPQxRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2066F1F000E9;
	Tue,  7 Jul 2026 14:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783435566;
	bh=38uJr8hVPGVJpV7RT0QtVixAplTyJQKOmyP/3Wvejkk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BpkPQxRVjX7WXA/JEprOiZavYtpKUwCoXkGlay8OFTxOO3pBbm4Srga6ztyH+1G9J
	 lK186j+V1CMVof8L6JnsbKESfM9aIozW2Fx5vLrzsSg8fNxMP82rXmD1RvGKwxmWTR
	 toZSpjPZFfeMKf8ftXcFnxIWjZ59vBwOUbLfRcTdXK9hM4AdfUY23GHcs17g8mi4Km
	 sYOaH1qvo7ncsQHtpLwY+T5IIOGF8UlSyExgMxbNm0iIpp7tzTLzlWINFiO2aFZki5
	 mTuTothfBivZ9KvlFwlGUoGRccKPFG9tF5Q8RAWeV0x0tDP9G04KiXwRTm3QUUMy9E
	 m4/nOvrkforfQ==
Date: Tue, 7 Jul 2026 15:46:01 +0100
From: Simon Horman <horms@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Jakub Kicinski <kuba@kernel.org>, b43-dev@lists.infradead.org,
	libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] drivers/net: replace __get_free_pages() with
 kmalloc()
Message-ID: <20260707144601.GH1364329@horms.kernel.org>
References: <20260701-b4-drivers-wireless-v1-0-60264cdf2efe@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701-b4-drivers-wireless-v1-0-60264cdf2efe@kernel.org>

On Wed, Jul 01, 2026 at 04:59:09PM +0300, Mike Rapoport (Microsoft) wrote:
> This is a (small) part of larger work of replacing page allocator calls
> with kmalloc.
> 
> My initial intention a few month ago was to remove ugly casts [1], but then
> willy pointed out that Linus objected to something like this [2] and it
> looks like more than a decade old technical debt.
> 
> Largely, anything that doesn't need struct page (or a memdesc in the
> future) should just use kmalloc() or kvmalloc() to allocate memory.
> kmalloc() guarantees alignment, physical contiguity and working
> virt_to_phys() and beside nicer API that returns void * on alloc and
> doesn't require to know the allocation size on free, kmalloc() provides
> better debugging capabilities than page allocator.
> 
> Another thing is that touching these allocation sites gives the reviewers
> opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
> another size is appropriate.
> 
> For larger allocations that don't need physically contiguous memory
> kvmalloc() can be a better option that __get_free_pages() because under
> memory pressure it's is easier to allocate several order-0 pages than a
> physically contiguous chunk with the same number of pages.
> 
> And last, but not least, removing needless calls to page allocator should
> help with memdesc (aka project folio) conversion. There will be way less
> places to audit to see if the user was actually using struct page.
> 
> Also in git:
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/drivers-net-wireless
> 
> [1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
> [2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/
> 
> ---
> Changes in v2:
> - split out wireless drivers from a larger set 
> - use kzalloc() instead of kmalloc() + memset in b43legacy
> 
> v1: https://patch.msgid.link/20260630-b4-drivers-net-v1-0-672162a91f37@kernel.org

For the series:

Reviewed-by: Simon Horman <horms@kernel.org>

