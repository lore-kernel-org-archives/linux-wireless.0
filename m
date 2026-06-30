Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BFE40E8E1;
	Tue, 30 Jun 2026 14:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782830442; cv=none; b=recVc5TNmnq7iFz9Hghoy7i+zRKtxbqKlvXF+sCIJRZnpo42g5IMHjKzziT8vOan/539OBBxFbWCENfk6h6Oh3JFE2D6lFqhGHARMamSapBjUMLRSBCiCDWLy79+nJOJ7x2rCj0q+QxLreOSGm8UzF7olHxUCFATyJySk4ZZMdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782830442; c=relaxed/simple;
	bh=k2Gx1TGx8N/jRMuMnS7S+0n8kwKWGU8OEzpkiR0pcTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ko7PLMmzboTCEv81XpigQZgqBD8z2vcBIrmNgBCsjP3PmxCdgvyLQco7/mn8jCmAGkV5wNYMOL9EFItdaCd8PyLDZ0K9W+ipyI12y/0LwXrHgdiA8B9qdVa1XqSwTecxCa0yJtUTYbn3feoIpkuRVR5xOajYdsYo6Hm8k9ewHzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UaRdoyQZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UaRdoyQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097601F000E9;
	Tue, 30 Jun 2026 14:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782830441;
	bh=dvgyW8X4QaOk9VN18ZFlTY30npYMh5LShKDCXGOsMxM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UaRdoyQZ1fTRKLAcvtRM8pCPos/hNLQhMFDTOXBDrPIVVOLNJRA7cU6ka14RHMRFR
	 qWpfgLvKeAkf3XDjCuN2u6VoExWRrn+k9PHdw1xwsfaFYRW6apiRDH/bzW3S/vPXox
	 NDxnR8QhAiI/zPphXPkt1KolvI83eq3Oxp7pH6P8fycRjVpGLO0mOiNQvzLLw+uZ8w
	 WRnUBYhp2jcwsX+8wxOOiEB4mT754vZ1T4aD/zr4L6UdrtAvPeJdD/EC+QwUvwBkRC
	 yr2g0tFvuReybfsvjS3lYxCtUKPjJPqHyXPEmCx9cYMHhnzg+aQfCesR1JnXw5Gekk
	 GQ0tpKu3Pqrmg==
Date: Tue, 30 Jun 2026 17:40:34 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Brian Norris <briannorris@chromium.org>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Manish Chopra <manishc@marvell.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Sudarsana Kalluru <skalluru@marvell.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	b43-dev@lists.infradead.org, intel-wired-lan@lists.osuosl.org,
	libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-net-drivers@amd.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/8] drivers/net: replace __get_free_pages()
 with kmalloc()
Message-ID: <akPVYpzxwP8CIQxu@kernel.org>
References: <20260630-b4-drivers-net-v1-0-672162a91f37@kernel.org>
 <20260630072344.159b5d99@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630072344.159b5d99@kernel.org>

On Tue, Jun 30, 2026 at 07:23:44AM -0700, Jakub Kicinski wrote:
> On Tue, 30 Jun 2026 13:59:19 +0300 Mike Rapoport (Microsoft) wrote:
> >  drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c    |  6 +--
> >  drivers/net/ethernet/intel/ice/ice_gnss.c         |  5 +-
> >  drivers/net/ethernet/sfc/mcdi.c                   |  7 +--
> >  drivers/net/ethernet/sfc/siena/mcdi.c             |  7 +--
> >  drivers/net/wireless/broadcom/b43/debugfs.c       | 12 ++---
> >  drivers/net/wireless/broadcom/b43legacy/debugfs.c | 11 ++--
> >  drivers/net/wireless/marvell/libertas/debugfs.c   | 39 ++++++--------
> >  drivers/net/wireless/marvell/mwifiex/debugfs.c    | 62 ++++++++++-------------
> >  drivers/net/wireless/ti/wlcore/main.c             | 14 +++--
> 
> You gotta split this, wireless and ethernet go via separate trees.

Sure.

> BTW cocci also suggests folding in a memset, IDK if it's worth it.

Same churn, less lines :)
 
> drivers/net/wireless/broadcom/b43legacy/debugfs.c:217:8-15: WARNING: kzalloc should be used for buf, instead of kmalloc/memset
> -- 
> pw-bot: cr

-- 
Sincerely yours,
Mike.
