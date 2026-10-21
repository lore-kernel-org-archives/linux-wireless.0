Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792557753;
	b=hVGnKutXFEq3lHRSS+trnxoLLHJ2YB2O14PBedLwD/TqHuRXP+tgwffzM7zHZWrzeUU/
	 Cr+JRZDrIqcQhIQronxxsITF6RoB7rom3t85wVRAsLEmqMtkKWY7JralxgeCzMTxYRvgD
	 wxtixO/37phiWIB56iJHz+O67Cq9Pnjxr93jf9HjZKc0Kyf4TIZzba25IK8p8LbzoMld8
	 GJOgMEX9UeguuRVOE5aZtDELsWU7PHDWdRH8tAp3ZkdsE9c07AZ9xIMSfOqwT/Pn5GBA1
	 QhGooGGr7sDkFHE95ztbFkawA+OIKLVQsp3xTtkTgL7c2pDMVNCWLeW4SxbZ88llxTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792557753;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=b15LLKcMrBTMjEpIJH0qJnPWrvqt6xZIuwbk59/oKns=;
	b=fzUv6NicW1pktBkRx5qNwDp5ibe7hVTxG0+/xtBqI5AGlODsCr3h1BbDGb4CaJ0shXyv
	 nN/OlLXn4n6ik1kcCPJRXJokqzh0aI/Dey/hfS2HTHQD/K+K9wpfPPPM0MZ5c0i66SHru
	 mbRH/24BTZD5HATZjYiJpY21UUPA2BYGEH/SjVWaAK6ucvVG/6LEd/uLbg76sIh+Y3tPJ
	 JJ/83BxYDbSkIucdjD/ytoU4OEzGLAmc0y7Oh3jj1R7v0helZXai63LPNB4tanDPqsnL7
	 carSo2EXpCkMUk2OQcLFbL8OGghGeDZZcV2uLXQHGJUYhVPV7YPPfTuDxFJv7Qcvqjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=D3MzugF7;
	arc=none smtp.remote-ip=95.215.58.48
Received: from mta1.migadu.com (out-48.mta1.migadu.com [95.215.58.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F09606A319
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 04:42:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4F09606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=D3MzugF7
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=skqgOqds6tI0v3GoPGO8t218zedgC6W98onzy0AdT3c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792557750; v=1; x=1793162550;
 b=D3MzugF7rI0TA6Hv7TZi41OwpEhe+fL/X6pws9hrHQK5lgDBdx7kmveGP8o4SugRCHOiNIpQ
 Cx+LInKuwVAwvBVecred8ogFPbFCzeqJlHjTe/tP2Shx/GtAM3oyW3yEizRU9t9nAQpTU0FPtDy
 9cB89ePUJSNcUqutUkQ6AjXk=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0b2e9c19a36ad296;
	Wed, 21 Oct 2026 04:42:30 +0000
X-Mizu-Trace-ID: 0b2e9c19a36ad296
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Wed, 21 Oct 2026 04:42:26 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <90b2130ba51c61014706e96ad74d2ca1a0fb9e4c@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v2 3/3] wifi: rtw88: 8723b: Read the chip
 variant from efuse
To: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 linux-wireless@vger.kernel.org
Cc: "Ping-Ke Shih" <pkshih@realtek.com>
In-Reply-To: <a551ce83-278b-4844-98c5-95e0ada3596a@gmail.com>
References: <8e47daa4-538d-4e0a-84f9-fd4e91613ff8@gmail.com>
 <a551ce83-278b-4844-98c5-95e0ada3596a@gmail.com>

October 20, 2026 at 10:53 PM, "Bitterblue Smith" <rtl8821cerfe2@gmail.com=
> wrote:


>=20
>=20The RTL8703AS appears to be a variant of RTL8723BS which doesn't supp=
ort
> 40 MHz channel width, so read the chip variant from efuse and disable
> support for 40 MHz.
>=20
>=20Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> ---
> v2:
>  - Split into a separate patch.
>  - Get the byte from the efuse physical map stored in RAM instead of
>  reading it again from the chip.
>  - Use macros for the address, mask, and chip variants.
> ---

Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Tested-by: Luka Gejak <luka.gejak@linux.dev>

Best regards,
Luka Gejak
