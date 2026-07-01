Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2347837754C;
	Wed,  1 Jul 2026 16:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782923500; cv=none; b=tDiQq3fSO7vUrqWU9JMtcTHaJGm7pk5eUI6Vf5hortblynpXCoufjYrXQTc1w3PPHVnYnRJxXKtuKlePAUqO5cEzh08EGjVPDYn6P7tPxgGV++PzXpyUq9RyQPtMIPo2qVSWM7v49HMZDKXrlCSsjQ2kt1H3lJnm0PrW3ACaR5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782923500; c=relaxed/simple;
	bh=baAqVdzOpKAOKFi/sIJGRPY78tXPIQcLc/tgXscx/9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MDUlfnelMkMyb+U82yRC1RxNwgBqAinOyOu+WIYzNUZQx3CK2gamV2PCrPyCm9RS2b7Z6c71P8znrjzGsNb7NFrTdLPf267OIN/+kgpEI0HLvbbTOshlh27oCrkFP6dj5fY2Lqe13S6A3t/vQsVfNSm0mcB0gZvHyWVf7Or/aWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=jnTiTMoL; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="jnTiTMoL"
Received: from francesco-nb (2-224-25-112.ip168.fastwebnet.it [2.224.25.112])
	by mail11.truemail.it (Postfix) with ESMTPA id 893E0228E1;
	Wed,  1 Jul 2026 18:24:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1782923051;
	bh=j9BoCiRz+jTMzZ774GPA0gBs0cqXHfYMScxVG2VZtj8=; h=From:To:Subject;
	b=jnTiTMoL2sl59fl3xrOn7icJksQ1c1zAouKZ6ZN1of6J9D+7GiPp4teflbxHaMEQr
	 rMesX1MgeXn8rGclp21gk+OXT0xQE0ZTxSuFKYp5fBa1elg63QcS9skrryY7iGJNqB
	 F+VLwuUevm3RXeRI9/VGBcHWbyedu0qfQQ9Sx5J4U7Yld6SydBWwV3WoRjZEtx4lZb
	 CrAB6jB72BBRv1PxJ9GnYIQsm3pM+ZXeCz82ey1/7ArYu5oKTodRdQYIaZe/xaiJud
	 tVOhbYJ8JkyUtmNVR+VgsWRb7T8NiLxaedru0BzkmvJmWoJiVP4b/GnhrYCEXX9FT2
	 d7odGKWJv/lHg==
Date: Wed, 1 Jul 2026 18:24:05 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Jeff Chen <jeff.chen_1@nxp.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Jakub Kicinski <kuba@kernel.org>, b43-dev@lists.infradead.org,
	libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] mwifiex: debugfs: use kzalloc() to allocate
 formatting buffers
Message-ID: <20260701162405.GA38581@francesco-nb>
References: <20260701-b4-drivers-wireless-v1-0-60264cdf2efe@kernel.org>
 <20260701-b4-drivers-wireless-v1-3-60264cdf2efe@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701-b4-drivers-wireless-v1-3-60264cdf2efe@kernel.org>

+Jeff

Jeff: this is relevant also for nxpwifi.

On Wed, Jul 01, 2026 at 04:59:12PM +0300, Mike Rapoport (Microsoft) wrote:
> mwifiex debugfs functions allocate buffers for formatting debug output
> text using get_zeroed_page().
> 
> These buffers can be allocated with kmalloc() as there's nothing special
> about them to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Performance difference between kmalloc() and __get_free_pages() is not
> measurable as both allocators take an object/page from a per-CPU list for
> fast path allocations.
> 
> For the slow path the performance is anyway determined by the amount of
> reclaim involved rather than by what allocator is used.
> 
> Replace use of get_zeroed_page() with kzalloc() and free_page() with
> kfree().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>

