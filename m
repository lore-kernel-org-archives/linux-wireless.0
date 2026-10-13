Received: from mta0.migadu.com (out-53.mta0.migadu.com [91.218.175.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0A63F4108
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 07:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791875425; cv=none; b=qQerPs78BITg8Ihx9NxW827joyD20Ak7F+WNh+EIwllD0/LyZ26t/vpgg7si2lHm75JJqEN4t65cIi33LqPIvTT4XAVPQxy6n6SOwTrISdhW2zKSzGRJVrb1IccOc0Bz9jUzxzUx4yem/q0MW6ueICP+O75QN225CVzPjguPvac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791875425; c=relaxed/simple;
	bh=yw7AoW/HGY0hyzkfaYvMgbzeBdxHTR8bh7HvAFdSAg4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=IcBvvcXnvGF6GmYdqTQRZGeq7juZ3EOqK4gsgctHFtgup0lbwpSL3N/oXGGRlbpyg2pXfsutqMJ5WhXPfPljD4ojf0zZ2l9BDE2g+tOy/eus59+sg3F5J5Eua6B5MtVmUARkqIoCGrVNWYdvr/nhVu3dSF7NbBn7XZ+30UVyqSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AVcID0Wb; arc=none smtp.client-ip=91.218.175.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AVcID0Wb"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yw7AoW/HGY0hyzkfaYvMgbzeBdxHTR8bh7HvAFdSAg4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791875422; v=1; x=1792480222;
 b=AVcID0WbfWcTMyJS4eW3182Q5A46Az07cjmejrNELV+C6ISvJzjpKhB+W0s3AmzRXYMGDNDR
 WPjzjDglxCuTNVFmXNsZnfuRCV+Aupu7QrdTcEAiBEEPN4uivNmYeg1NkWqgG/+ZoYskn5oNv5I
 PVrjRKPu7OCYGqo5ZxNLoUHE=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 34e6b5eb821ee27c;
	Tue, 13 Oct 2026 07:10:21 +0000
X-Mizu-Trace-ID: 34e6b5eb821ee27c
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 13 Oct 2026 07:10:20 +0000
Message-Id: <DM3ITO17G2GI.347CA6KFMKOVS@linux.dev>
Cc: "Luka Gejak" <luka.gejak@linux.dev>, "Martin Blumenstingl"
 <martin.blumenstingl@googlemail.com>, "Jernej Skrabec"
 <jernej.skrabec@gmail.com>, "Ulf Hansson" <ulfh@kernel.org>,
 <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH rtw-next v5 1/4] wifi: rtw88: sdio: Handle allocation
 and read errors in rtw_sdio_rxfifo_recv
From: "Luka Gejak" <luka.gejak@linux.dev>
To: "Alastair D'Silva" <alastair@d-silva.org>,
 <linux-wireless@vger.kernel.org>, "Ping-Ke Shih" <pkshih@realtek.com>,
 "Kalle Valo" <kvalo@kernel.org>
X-Mailer: aerc 0.22.0
References: <20261011220755.1673367-1-alastair@d-silva.org>
 <20261011220755.1673367-2-alastair@d-silva.org>
In-Reply-To: <20261011220755.1673367-2-alastair@d-silva.org>

On Sun Oct 11, 2026 at 10:07 PM UTC, Alastair D'Silva wrote:
> When dev_alloc_skb() or rtw_sdio_read_port() fails, rtw_sdio_rxfifo_recv(=
)
> returns without reading data. Because it returned void, the caller still
> counted rx_len against the loop budget while leaving data stranded in the
> FIFO.
>
> Return an error code from rtw_sdio_rxfifo_recv() on failure and break out
> of the receive loop in the caller immediately.
>
> Fixes: 65371a3f14e7 ("wifi: rtw88: sdio: Add HCI implementation for SDIO =
based chipsets")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> ---

Reviewed-by: Luka Gejak <luka.gejak@linux.dev>

Best regards,
Luka Gejak
