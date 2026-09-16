Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7883BE636;
	Wed, 16 Sep 2026 07:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789542117; cv=none; b=YFizbQGIWhO7NgMlIxLsrgmE90YmXcoBhSf2rWvB31Hbumd/j3oR8s+/mCq5Cav+36wR3JX5vM9j8x1g98j5G7Kbf6Ut6Z+HAwTHgTtWbep4HkGlt2/fRqeL2o02pBzS9wUH1AP0huqI1ddaDvl7uVzveG7Cj7U/yeS2PGNX9n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789542117; c=relaxed/simple;
	bh=Kwb8KX87R9r4L4tQow9CcPKZwEpqNnFjy0YoemwMEmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Of8Qzrut/tjsW+dLGokMgBUmK9uK18ws24llte07mh7DQlMC13PN1QW79f8+jlR0pLQ2cCTZTme+UK0KLUjmCCOqMbkeebyFyFaPsoQPpK3NHqFti0+ZtuYWITFcsv9hXb9S3DdaYRhcrYkrexvV7HCufI7/XtVUKrA67XdxfgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ETpOXFml; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ETpOXFml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32E71F000FF;
	Wed, 16 Sep 2026 07:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789542115;
	bh=AtbMstdSsxsrcHglRSS47mfL0CBM0tMluc7NdE73fNc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ETpOXFmlT7btJY32ZMUu7DeLGxPK5xXTD5xrjD1rZVtlKZg3CbM7mmlHSNcnE18Zi
	 sFBKwBstQiLxCJszrz03+2scS1iQkH9mOaoEI86AqddGQ0T/Ompn2S+aezzWd6rcvi
	 D16R6u/JeCB+NQBKou/G2qC/0T3zjGD4FY6as8IdXQeHtMazhMKMlkTzl1ifnZc7Ib
	 j+d+rp99wMYb+Eu0jeQ6PcKgWBLG/4hxnTjpFT2vNWbjOwO2DEaSSHaA43HCfpoYch
	 xI+ycYCOPz9joePsLbjn4O0FExSlfbxxerRlvTJlw0auZBtYJfWQpRMqWfM1Y8bh3W
	 a0CwFWYeANchQ==
Date: Wed, 16 Sep 2026 09:01:44 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
Cc: linux-arm-msm@vger.kernel.org, Jeff Hugo <jeff.hugo@oss.qualcomm.com>, 
	Jeff Johnson <jjohnson@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, Mihai Moldovan <ionic@ionic.de>, 
	Denis Kenzior <denkenz@gmail.com>, Marcel Holtmann <marcel@holtmann.org>, 
	Andy Gross <agross@kernel.org>, linux-kernel@vger.kernel.org, mhi@lists.linux.dev, 
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, ath12k@lists.infradead.org, 
	netdev@vger.kernel.org
Subject: Re: [PATCH v7 03/15] net: qrtr: fit node ID + port number
 combination into unsigned long
Message-ID: <bjfwy4usrfbrabmcp4xsr65nqwdpuryvmrb6tzp6k2ckmdx27h@kvf7idvsugsm>
References: <20260915054207.2513877-1-juha-matti.tilli@iki.fi>
 <20260915054207.2513877-4-juha-matti.tilli@iki.fi>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260915054207.2513877-4-juha-matti.tilli@iki.fi>

On Tue, Sep 15, 2026 at 08:41:55AM +0300, Juha-Matti Tilli wrote:
> From: Mihai Moldovan <ionic@ionic.de>
> 
> The flow control implementation uses a radix tree to store node ID and
> port number combinations and the key length is hardcoded to unsigned
> long.
> 
> The original implementation shifted the node ID up by 32 bits and added
> the port number to the lower 32 bits of the unsigned long value to
> create a key.
> 
> Unfortunately, since both node IDs and port numbers are defined as u32,
> this will overflow on platforms where sizeof(unsigned long) < 8 (which
> are most 32 bit platforms) and essentially just drop the node ID part.
> 
> To fix this, build the key in a generic way, using half of the unsigned
> long space for the node ID and the other half for the port number.
> 
> This will be transparent to platforms where sizeof(unsigned long) >= 8
> and fix overflow issues otherwise.
> 
> The caveat, of course, is that, for platforms where
> sizeof(unsigned long) < 8, the supported amount of node IDs and port
> numbers will be severely limited - to half of sizeof(unsigned long),
> which typically will be 16 bits. Needless to say, we have to check if
> both values fit into this limit.
> 
> This limitation is probably not going to be an issue in real-world
> scenarios, but if it turns out to be one after all, we could switch from
> a radix tree implementation to an XArray implementation.
> 

Documentation/core-api/xarray.rst says:

"If your index can be larger than ``ULONG_MAX`` then the XArray is not the data
type for you."

So the fix is to not make XArray work, but switch over to some other storage
mechanism instead of XArray, like hashtable.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
