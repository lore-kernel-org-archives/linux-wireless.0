Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9405C3B6C1C;
	Wed, 16 Sep 2026 06:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789541159; cv=none; b=IDQGEr1VJk2RfrCY9ikhr24jZ0ybXB8QLoSaMGNGXhFX3QwB/amsAFjdXWaMX8bWHM+J9+pB1wT5b7qIZoOhj/OOagDwlLdS9sJKmyhVtaSq9vP8r3GSCkdSZKmAt5Z+oCfs8b9HT/3yzlb9VUG762aoVwSdmcWY6tCVn9pqSZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789541159; c=relaxed/simple;
	bh=BzW1oySvud/ZXuyh8JK/hcMCRQXT2M+0osiULR2aS6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AIDme61v4IOq5LQpZcvt0Tq+JY8xCnEMwsg3JeTQFl8xelJaWtSggf3bkK6L89yax72obUyHB2kwwJMi9lYoSwtLNAVC56xVUa7IUOctkV/58VOTOiue/z49qUxTIQMS8IAtZQ5r426vi1GAN/4GvTaxIkODnNCzpqBtNZzqhIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ACAVyIFh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ACAVyIFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BE01F000FF;
	Wed, 16 Sep 2026 06:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789541157;
	bh=taOEqL4siH3lxxx1UH5RkTc6W3vPtQoc/t7GJVuIGJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ACAVyIFhrftw/R6xa50icqAmL7UozbxRjlWRNvte13eswSGg7vgO0zg4mULqhyL2c
	 iHCohyHxSHLyx5BlFuNe9obKCSnmsSGkSBUe89qjqvD9DFYidFmCKBv/eSv+ymQY8H
	 mYdjt2/FWhqv8ofu4DF7EvbDkBSENNeoJfdkFMcoKM3W3nX46eQ8+lRPR41FAfmS6i
	 88iNrayH1la8aNgoWASgJBIV3E9T42k2tE/SWZJRkb9HS+8JNdgLVfYu+tOWj1pPg4
	 RCeXpfdsNs2YvvFUIbtO1AR0DJopyl0HLhV24eckCwHuX6KfLcY0QQ8k0q9HX8tucX
	 /2rLyzN9JYGNw==
Date: Wed, 16 Sep 2026 08:45:46 +0200
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
Subject: Re: [PATCH v7 01/15] net: qrtr: ns: validate msglen before ctrl_pkt
 use
Message-ID: <uo3sk7ygezaysxs3xgizspx6usbtin63rrpoc42l2jp4yxrii4@2jcof2iillbd>
References: <20260915054207.2513877-1-juha-matti.tilli@iki.fi>
 <20260915054207.2513877-2-juha-matti.tilli@iki.fi>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260915054207.2513877-2-juha-matti.tilli@iki.fi>

On Tue, Sep 15, 2026 at 08:41:53AM +0300, Juha-Matti Tilli wrote:
> From: Denis Kenzior <denkenz@gmail.com>
> 
> The qrtr_ctrl_pkt structure is currently accessed without checking
> if the received payload is large enough to hold the structure's fields.
> Add a check to ensure the payload length is sufficient.
> 
> Signed-off-by: Denis Kenzior <denkenz@gmail.com>
> Reviewed-by: Marcel Holtmann <marcel@holtmann.org>
> Reviewed-by: Andy Gross <agross@kernel.org>
> Signed-off-by: Mihai Moldovan <ionic@ionic.de>
> Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
> Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

- Mani

-- 
மணிவண்ணன் சதாசிவம்
