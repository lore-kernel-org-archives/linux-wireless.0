Received: from mta1.migadu.com (out-47.mta1.migadu.com [95.215.58.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81E8480960
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 07:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791875455; cv=none; b=Voc/LC2XEHdGp+6oXvMt2JAbHAnqw+k05K/C7HBHkRJj9s5LiGWXbDv1u7pA4uYsJbFRgBADVnCvmBHot7dkPiPgYyICKE6hX7Ec4VHeD+KAv3CcwdE/wC52C0xkHJtIZdJUthcke0QsspczMmOZPJuf7lDdDG+62gjTZlm8yao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791875455; c=relaxed/simple;
	bh=5IyuLLYFiQtpNiYbK6mgmhqjjgM5EmoJ5pKSJ2p2wnU=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=kZcgurtxaz/w0L/c/+YJq2sWh4Cvup2zJWGE2UKPmJqpnCfqa3kYEWoZz7Ar+75AWR6z0OBff1r/cNlFnFQakKRtIP2U4UvBOLxR1aVioevrCy9pzEQxzZ4r4a748Xri56J1XcuFnq0qk/bAvKOmHbr753v5nzUBUvQbkvLNr94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bSj+3VF3; arc=none smtp.client-ip=95.215.58.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bSj+3VF3"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5IyuLLYFiQtpNiYbK6mgmhqjjgM5EmoJ5pKSJ2p2wnU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791875450; v=1; x=1792480250;
 b=bSj+3VF3AVHF+Vl8ySzYyUzOsT4Y1KKeAy8X4ugy63R7BscaeH6T2/x1Ru3vQ4/gT9Za6mZJ
 BK3xUUc1LuxNVZuzJ5FxBlE6oYHZwAuxNxqrwi54e6HsQigB4f3QUiVTqnDnqYhDtWnlwrdRwqu
 oS6LsnWJSAIQd+ZBAwYKrOD4=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4aa0aab1cb48f3d2;
	Tue, 13 Oct 2026 07:10:50 +0000
X-Mizu-Trace-ID: 4aa0aab1cb48f3d2
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 13 Oct 2026 07:10:50 +0000
Message-Id: <DM3IU1PCLD5Y.15JIGZYM8WLI0@linux.dev>
From: "Luka Gejak" <luka.gejak@linux.dev>
To: "Alastair D'Silva" <alastair@d-silva.org>,
 <linux-wireless@vger.kernel.org>, "Ping-Ke Shih" <pkshih@realtek.com>,
 "Kalle Valo" <kvalo@kernel.org>
Cc: "Luka Gejak" <luka.gejak@linux.dev>, "Martin Blumenstingl"
 <martin.blumenstingl@googlemail.com>, "Jernej Skrabec"
 <jernej.skrabec@gmail.com>, "Ulf Hansson" <ulfh@kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH rtw-next v5 4/4] wifi: rtw88: sdio: Split
 rtw_sdio_rx_isr into 8051 and 3081 variants
X-Mailer: aerc 0.22.0
References: <20261011220755.1673367-1-alastair@d-silva.org>
 <20261011220755.1673367-5-alastair@d-silva.org>
In-Reply-To: <20261011220755.1673367-5-alastair@d-silva.org>

On Sun Oct 11, 2026 at 10:07 PM UTC, Alastair D'Silva wrote:
> Split rtw_sdio_rx_isr() into separate 8051 and 3081 variants to be
> clear. The two differences between the architectures are:
> - Register size: REG_SDIO_RX0_REQ_LEN is 16-bit on 8051, 32-bit on 3081.
> - HISR behavior: 8051 re-reads REG_SDIO_HISR on each iteration, while
>   3081 drains based on rx_len without re-reading HISR.
>
> This is a refactoring without any logic changes.
>
> Assisted-by: LLM
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> ---

Reviewed-by: Luka Gejak <luka.gejak@linux.dev>

Best regards,
Luka Gejak
