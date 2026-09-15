Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163753B0592;
	Tue, 15 Sep 2026 22:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789512429; cv=none; b=cXFBDuUsUZ3UDuwtoiM1CIZCdySZSDGzHAtMlFggjs0qayYlRNKbfBGxOJ3H1ddhMuQt7LkpbUG4FQ2vf++T3JQxKDmmFE2ERJxmEMHR/RZmN78tvvW+/MSaEazvn7udWaa+nFqLHubJfR8ooS9G0Ck6bx7t8bT9Wr4Oen1wA00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789512429; c=relaxed/simple;
	bh=YHSVUGtkRDC6pZNJXi4o+weci1RVRC8ikw3ZJdZcWiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CfK+rl9M8AF5sNJuShEbg/L6ley75LQozqOlFbJKK0yM/Xe9mWMViVadLxACErD8IczTSZQpW1jlP9VU9k760d9VnIIne3W7N2VZTpGnCkXpNs5bzHJebbXsqURNPpdPn5DnffiUnZw+ojleqPdC1zXYwf/tdkNvrZujeGJ6mhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BKJJf0Rh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BKJJf0Rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F761F000FF;
	Tue, 15 Sep 2026 22:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789512427;
	bh=YHSVUGtkRDC6pZNJXi4o+weci1RVRC8ikw3ZJdZcWiQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BKJJf0RhK//lvEjrun0GWME0ibF1neJ2mui5lieiwG1zkmw7WXO4sgBgQ5JisD5cI
	 OvXz1eOXkM9BnyDCayfBWpsuzg6pGfFed/dRuTb8secR2idwtTbvMpntx6P7P7rGeM
	 tCjXoKtciRbAcWQBgx4NFrELcIcOsx+esA02myEi2QbI1RAezWfTw4oB86ZtPyuU6O
	 jqNRK88DMCEp7EX2cN2k+r7qsRnL1L94MgxixuFp0eHVRt2XCvwKdOauZ4Tx3gzCMN
	 Hkk2jY7EH7ND6ztQZw+hgI7QZcWnzawzwthSr8YQjL1nWEeXjDL1+8advWU24pGOva
	 IKPlE/w4gkgCg==
Date: Tue, 15 Sep 2026 15:47:05 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
Cc: Manivannan Sadhasivam <mani@kernel.org>, linux-arm-msm@vger.kernel.org,
 Jeff Hugo <jeff.hugo@oss.qualcomm.com>, Jeff Johnson <jjohnson@kernel.org>,
 Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio
 <konradybcio@kernel.org>, Eric Dumazet <edumazet@google.com>, Kuniyuki
 Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, Willem de
 Bruijn <willemb@google.com>, "David S. Miller" <davem@davemloft.net>, Simon
 Horman <horms@kernel.org>, Mihai Moldovan <ionic@ionic.de>, Denis Kenzior
 <denkenz@gmail.com>, Marcel Holtmann <marcel@holtmann.org>, Andy Gross
 <agross@kernel.org>, linux-kernel@vger.kernel.org, mhi@lists.linux.dev,
 linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
 ath12k@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH v7 00/15] QRTR Multi-endpoint support
Message-ID: <20260915154705.67cfb94f@kernel.org>
In-Reply-To: <20260915054207.2513877-1-juha-matti.tilli@iki.fi>
References: <20260915054207.2513877-1-juha-matti.tilli@iki.fi>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 15 Sep 2026 08:41:52 +0300 Juha-Matti Tilli wrote:
> Subject: [PATCH v7 00/15] QRTR Multi-endpoint support

qrtr usually goes via core networking tree.
Please make sure you base your patches on net-next/main
