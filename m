Received: from mta1.migadu.com (out-223.mta1.migadu.com [95.215.58.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B4947D931
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 09:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791969131; cv=none; b=rGcQI5P9TmzeTfz1CyN2Y5Vl1suJKrU5dPd9sx4xaylQ4/3GLc/lpg8H0rJvdopeaYQdpxuTI4Dmdk+qMKTdVvrAqtF2vauJF43Xtr3gBxDIzoEt0cNP/YPpmJXrly8C9H+6ysbEJAsnwUW83B/vR0spZVIXAI7YxZr+6sFYRJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791969131; c=relaxed/simple;
	bh=JaeMel31Hgs5t5/stZHKIaH8DN8bA2pdb5S2hDi0WIs=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=K/TH4k7ePzdDznhfnHLCUH4pHHExqpGH2siQuaWuefZl2tapNjBfaDSrGAFyufT8Njh1/VcjwQlgZ7qShYNMfEDxZcnMbPj2mLoHYUXT022eXVSaOCkNTGrNYEN/bRxQux12AGeVeyGNzyr4uKYLL/qVOJB/y6cq7qKsG0xYUqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lXsi1Io4; arc=none smtp.client-ip=95.215.58.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lXsi1Io4"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=JaeMel31Hgs5t5/stZHKIaH8DN8bA2pdb5S2hDi0WIs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791969127; v=1; x=1792573927;
 b=lXsi1Io4CGungY003QS1sG9KEeBhmJjoqKCVOvTD02MLo039TKypWNyvd7ZbJSxOfi5pFcKN
 mH3b/LI9pdC8rU5hoekDVGgcrGayEGUCqFs51I1o1ar0XchGfObIX8AlQqxo4gsBk+athZxFCxj
 GrOYACp0ujQXgoCdMsWXjUPk=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 09e97bde1365531d;
	Wed, 14 Oct 2026 09:12:07 +0000
X-Mizu-Trace-ID: 09e97bde1365531d
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 14 Oct 2026 09:12:07 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <cb1a2225374da5768bb138191a7d36c68d574e69@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v6 0/4] wifi: rtw88: sdio: Fix unhandled RX
 request interrupt storm
To: "Alastair D'Silva" <alastair@d-silva.org>,
 linux-wireless@vger.kernel.org, "Ping-Ke Shih" <pkshih@realtek.com>,
 "Kalle Valo" <kvalo@kernel.org>
Cc: "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Jernej
 Skrabec" <jernej.skrabec@gmail.com>, "Ulf Hansson" <ulfh@kernel.org>,
 linux-kernel@vger.kernel.org, "Alastair D'Silva" <alastair@d-silva.org>
In-Reply-To: <20261014074426.2183095-1-alastair@d-silva.org>
References: <20261014074426.2183095-1-alastair@d-silva.org>

Hi Alastair,

October 14, 2026 at 9:44 AM, "Alastair D'Silva" <alastair@d-silva.org> wr=
ote:

> On 3081-based SDIO chips (observed on RTL8821CS; RTL8822CS is inferred =
to
> be affected as it shares the 3081 architecture), hardware does not
> automatically clear the REG_SDIO_HISR_RX_REQUEST status bit when the RX
> FIFO becomes empty. Masking this bit out in software before writing bac=
k
> to HISR prevented it from ever being acknowledged in hardware, trapping
> the CPU core in an infinite interrupt storm that locked up the system u=
pon
> receiving network traffic.

There are three 3081 parts with an SDIO front end, not two. 8822BS is
RTW_WCPU_3081 as well (rtw8822b.c:2527) and rtw8822bs.c is built as
rtw88_8822bs.o, so naming 8821CS and 8822CS only leaves it out. Patch 3
changes the interrupt path for all three at once and only the 8821CS was
probed, which is the one thing I would add to a series that Cc's stable.
If there is no run on 8822BS and 8822CS to hand, saying the same for both
would do, the way the cover already does for 8822CS.

Best regards,
Luka Gejak
