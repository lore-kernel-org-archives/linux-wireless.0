Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793060116;
	b=473UIaWn5Kfm4qA3AcEOcj8P4NE1fZ/8Tpbzssmfz5Q1mWDnC4wwdWS1Z6oGMCb4pMmE
	 4Q7rFoBiSZCGAURdAg2jf4+J+YyeTgXwKvw4I1wUnAsFKQ5+XGjQ9I+pJq793BN5H3gw3
	 GTqNqqC9gQstYsQoagVkZEZf5TIuPx2f76sYVpm32eSk1OdnfgeZTDuvKoZuKAkDBReB5
	 sFxfSmV4YjwG8kSdd6LrO//ehksD69LrM+oIkNw0murDm7SWpzxsMdReuMVxZSVNX5NXz
	 Et6Pn8yJ1BcYVUApLqBZtB874xrDiHM2y9J5fAomkuHSbowm436ei1zX1ru5D/0jzUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793060116;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=H/yoQOUKBrL56T5gjNQcc+KduxA/BxAhW7oXXt9IhIc=;
	b=znr0o0+xI/4nycKKJZ/uLSzBw5+iYF5/+EIT0rzXOI+txfrMBrmNJMr28mwJ8F6AP9pY
	 H5f8J9quAiK1mWVv7iLWtjk71HnFSwZICMeRZAn0FTUiyXX/+Joch/hnRc7aPn5T3nsWL
	 UUoqrhkNfYcWvEEQBRiF8O84WIGcDmU2OnuCCuVzm2H5IbZIBpqdoTwNMFPNfsiISxrMt
	 YFTa/nCYFIrvdeeeJt534zNQuU7HtT3DdXmGnswpWArLcGm5extaxKsf7G0x485FXqkuh
	 UL+YYDPlxL6aBTPwUrE07osoLVaKg7kEuNdpQNaqcS8hP+Z9V0B8KG4w6bPsoGfaH5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IPpmdMgW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E28606A31B;
	Tue, 27 Oct 2026 00:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IPpmdMgW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FD51F01825;
	Tue, 27 Oct 2026 00:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793060115;
	bh=H/yoQOUKBrL56T5gjNQcc+KduxA/BxAhW7oXXt9IhIc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=IPpmdMgWBt1jeGhOyJrZLKls4yjD6kVph15b6Y6qHdKQ11b9aAxvx+Ar9n9oHuPU7
	 ik6RmqL6C4t2DwUiKDgqqEqkJgnVb8rO3Nq3+KI0tsryhcW+xNAsi+nuLeh+JfcgP5
	 msQ/Qwq9PY09mcCwCJu6qz1yqHlS6k9pUdU5ouCHpMArXpcK8312x3yaWTqAcrItXs
	 Fh/5fH2zakApSy+yx7UtQ7DAfMxO5uQ9rCWnj5d2Scab6XDypcEDgWaadPOOLYnHXo
	 0vxZcJ9sVOBJOU+5sYCx4hLwt3DAbqwljp0Q2XE5gnkSrGeQ0s+HX3UumLBTdkHG7H
	 bpVu/SD4ErvZA==
Date: Mon, 26 Oct 2026 17:15:14 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Manivannan Sadhasivam via B4 Relay
 <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Cc: manivannan.sadhasivam@oss.qualcomm.com, Manivannan Sadhasivam
 <mani@kernel.org>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
 linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
 ath11k@lists.infradead.org, ath12k@lists.infradead.org, Bjorn Andersson
 <andersson@kernel.org>, Chris Lew <christopher.lew@oss.qualcomm.com>,
 Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>, Raj Kumar Bhagat
 <raj.bhagat@oss.qualcomm.com>, Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
 Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Subject: Re: [PATCH v4 0/4] net: qrtr: Add support for using identical MHI
 endpoint devices
Message-ID: <20261026171514.35136bec@kernel.org>
In-Reply-To: <20261022-qrtr-multi-ep-v4-0-c6fdb75fcd3e@oss.qualcomm.com>
References: <20261022-qrtr-multi-ep-v4-0-c6fdb75fcd3e@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 22 Oct 2026 19:43:06 +0200 Manivannan Sadhasivam via B4 Relay
wrote:
> Merge Strategy
> ==============
> 
> Since both QRTR and ath drivers are falling under the networking tree, the whole
> series can be merged through netdev tree.

Makes sense, could you repost these after the merge window (~1 week)
and tag as "PATCH net-next" then? Our CI is thrown by the wifi patches
in the same series and did not ingest the series.
-- 
pw-bot: defer
