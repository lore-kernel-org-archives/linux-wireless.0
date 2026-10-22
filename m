Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792690898;
	b=B1XEgh/JTOVKzKp+sLAG+9GAcWz5CKwmmi4DiXVk3ZJGUNy7wnyTp9jyvkvh6iPjbb11
	 CQPiH1BhPa1YRFZlyuEKCNKAbi+Axt2bAtp7Z/iaj3JOuAhNR2NaeWEjTxh50Pw1JqRj4
	 1vRijzStWnS8yOJGutWHQm/i5NayM5hLipXdLzIrLKywMR7qcdIUu5Cil7CJOqLs7rYIt
	 +25iYz0CdSiAQ8AFbXW1rsOeU7bs0d1a97WL/E86COIde3FyiZaF2i6OsuEvxF0XjAU0v
	 EjF6yXe2a2O3M98sLC5jbffE1pE5/Hso5N8wUrIIzjdnSGC/Z3fKD+84DzklkZ/SwsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792690898;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=WA0HjoZPG69qc7BzEqvg42tb2jNqkhyITb+oHaatNjM=;
	b=lMs/O14Siddj+9p+kaDDQHgpf150xOTo6tpnopjv7CqnhTYIQjw8f95Ue56eRf7BdGMk
	 aRXVu11GiFMBgz90o84+/s7ON4LmpsIAUqRu8zYS6D3wdK97pMLoQXVGQXmmdvgfeHA9F
	 RyBHscJkY2QWjErpBqIKn9EGwVoReJ64O2zmSY1nUG2zl0yDfCxi1dmeUHnixCW1grP+5
	 VQAv1FVdZAQaRuLdHN7yUdiVuOpu/tJheDqLwbJY+6bF3xoPAbuUCVZH0a07UYEm/v1Ox
	 K1SrJ0CxXNuECJZ4COgGodOi81Ma0gwm7c0YpvpYi8+/QGjIhkwY62iYG9giW61uJbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LVx7YpVP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A3E606A31A;
	Thu, 22 Oct 2026 17:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LVx7YpVP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9321F01825;
	Thu, 22 Oct 2026 17:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792690897;
	bh=WA0HjoZPG69qc7BzEqvg42tb2jNqkhyITb+oHaatNjM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LVx7YpVPNro/10kqILXUywAKYh8MHO+20TyQ3UdL0wM2L4sfna/0xFVRMA4I1qpK3
	 mxQwiKOYqsgot7qOFjH4KjtE4SvIEWJoKUP//QrDGzEeb0yiV2uLbrhQe5v9lKli7R
	 hr81msoE/9v6vCjmYKxd4pP38v1BFHrrrsdBikTtZslX4gh4Xmohw7W7Bu13RToLKb
	 UyVETZftx0U3bz6IG+g2jh8Agq7Ael+DzhxQ9Q9y+OheOyMVxRKScbu6v/oYjL5ouQ
	 nuMnPJZaTF+Cx9wzauPXMk8bKH7fqX+JHGL4V8eGocSZN9N0HxvQIfwpzXG2RaBe0L
	 zHssg2E7d0RAA==
Date: Thu, 22 Oct 2026 19:41:25 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: netdev-bot+sashiko@kernel.org
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, jjohnson@kernel.org, 
	linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, ath12k@lists.infradead.org, 
	andersson@kernel.org, christopher.lew@oss.qualcomm.com, deepak.singh@oss.qualcomm.com, 
	raj.bhagat@oss.qualcomm.com, juha-matti.tilli@iki.fi, jeff.hugo@oss.qualcomm.com, 
	vasanthakumar.thiagarajan@oss.qualcomm.com
Subject: Re: [PATCH v3 1/4] net: qrtr: Allow the host QRTR to assign a unique
 node id
Message-ID: <lmv7gtw42x2n3hrjsxobzdv6ya47ftoo5pq4i4baj6qeumzlav@fkjcmw7e32gb>
References: <20260922-qrtr-multi-ep-v3-1-c00831e88957@oss.qualcomm.com>
 <179032218286.2160803.9910557055402731112@kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <179032218286.2160803.9910557055402731112@kernel.org>

On Fri, Sep 25, 2026 at 07:43:02AM +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 2 · Medium: 1 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] qrtr_endpoint_post() (net/qrtr/af_qrtr.c:570) replaces the
>   previously unconditional `qrtr_node_assign(node, cb->src_node)` with…
> - [High] net: qrtr: bypass of node ID rewrite for short DEL_CLIENT
>   packets
> - [Medium] The lazy initialization of node->ep_nid in
>   qrtr_endpoint_post() is an unlocked test-and-set: `if (node->ep_nid ==…
> - [Low] The new gate `if (node->nid == QRTR_EP_NID_AUTO || node->nid ==
>   cb->src_node)` at af_qrtr.c:570 reads node->nid with plain loads…
> 

These comments are addressed in v4.

pw-bot: cr

- Mani

-- 
மணிவண்ணன் சதாசிவம்
