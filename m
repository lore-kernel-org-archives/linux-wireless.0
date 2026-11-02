Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652391;
	b=AEEyOgScko1dclbuj3eazLL28SzHw4HcZvZ7kn37qm03QL1aIOV8e53AGaT4tQ24ifuK
	 N1ljpvqGnldgqx55afR7R49mDR1zIaKlCs10uwLAN3l19utNu0UKT54jqFCWjZR8Q9Bto
	 0thCPISqx79Pj0PnP+slrw+b1oVT7qJkYNchJxEcI31rMYir/KqWR7YDimtY7M0liVim0
	 DlPRhXyrSao/hskrHI3Tp/wswVAbWCojaZ6Qt47WIHHHnUPazaj9UbFQjbfpBaARXZ9Gh
	 68a0s1RdH+/C3acR0hz1z4S+ozmCYkGpS1PgrNFcq4zQUWsOAGCI5NsnmoP/TeOy3kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652391;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=rIkyhrFM98T/vHO6RdFHgX5SpA5k8kK+utueYBru5u4=;
	b=c6DZ2o2QU0EpiZubJCtUBkb2cjfWNvdEZ5w91RUJqXhgJeOEE2BfZZ9c6HspJUz13AMi
	 5WcIj/YxXCu4Z/cXJozCkpAVqtr7doXJRoihVI+svIGdnfRc8DAogWgsFVHZNBVy07ogm
	 g9GrKU7NpfLh951o7x4TlMP6uzi+qF0rtExdNJGweHdL5Djd+0cIMzgSlUWTRiDLCfblJ
	 RxjPfHw23bMk0Rll+qXZaIxNO5aE0YvtsUFlLLJV5a+2uqtfN3Y+PWOqwlSbzxJ6s2aPI
	 pBSnkprhX1KwlpYZJm4iDEpDd1dwrJfFdvV/2W2G896DAa6GBuhvVISpRN9hegX5N4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=jannau.net;
	spf=pass smtp.mailfrom=jannau.net;
	dkim=pass header.d=jannau.net header.i=@jannau.net header.a=rsa-sha256 header.s=fm1 header.b=dEl4irC7;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b="hb/5GuHx";
	arc=none smtp.remote-ip=103.168.172.155
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54ADB606A330
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:46:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54ADB606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jannau.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jannau.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=jannau.net header.i=@jannau.net header.a=rsa-sha256 header.s=fm1 header.b=dEl4irC7;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=hb/5GuHx
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 66F381400229
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 15:46:29 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Mon, 02 Nov 2026 15:46:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jannau.net; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1793652389; x=1793738789; bh=rIkyhrFM98
	T/vHO6RdFHgX5SpA5k8kK+utueYBru5u4=; b=dEl4irC7E3FvWjeE0C3xyQtmm7
	P97SKDgblnSCufI4yAIrH2SNZ5xaaIo6YCW+E+AJEbuzzc7bRRUiIGpmUkhNuQUX
	lZtFyR9+qp/DbXkHR1NGndJOzqjuuqqTAkteUdlCOhMbLcJrbc+IWa7namxUd0dN
	yRr+PLHRqmF5mSvYBnXwc8UNvduBVJ+hc41Bo576y/mQNagAFUc17txOtwmSJJ/3
	ZbWg0AZdn8vHynHHx1zgr424czQVPHRmFsErftVuIL2gyYZro2/Z19Fdy6e1Ux++
	f1k+Q+MzfQ2MkjTHJBle/Hxu4RBJT3qzZ3U5ih+y2xGtBdnuclQxQhtiOu/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793652389; x=1793738789; bh=rIkyhrFM98T/vHO6RdFHgX5SpA5k8kK+utu
	eYBru5u4=; b=hb/5GuHx9arLWK/83a2O9c+5JIGOXLS+L9Zy66hbfAscUYqwOoc
	VsYmG6DcF9HURay0Sf2hvm+jMKVEuvWAZUxYXo/RMdNjdBIm6d9f2VBzAA/oCUvw
	SejtLGAK5+QR6C5sCcdRGnBqAZYDkql+XH/yiNBaqyFwfE4P01OYxWZoImi8UrYq
	3or/ChFto1BBMGv8886tXleFNf43WbdWikhPnQra09z3klG2LCWXCj6N5SoLamOH
	Gyx+X4lcNbb8X100yEeNOfGJ6dzIpAc6W7ucXj5T4dZCdLVNiAumdFhWzkCV8kyu
	2tS0YPgDrqOeZwEwtX5g83eeSCvaImz0RxQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=jannau.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793652389; d=jannau.net;
	mf=PGpAamFubmF1Lm5ldD4=;
	rt=PGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:jL0TRQrqWbkH9yODmHVnPI5q89N7Ln/RzOE/nuDDmgtN4+d
	Aai69wQP0w0O9D3bQgGh3Q5ZLITwLXe4cC5L1wXq9lYN1QDnX3EZILNcEDBS/qLV
	wi5iL79kma9/fDDn7Xrl7wyrHQ8RXFCb5qTJby6pmkX4tgDs9PNOFS5upSY+GVu/
	Ke9xiqH6Uvban9P5CRjR+jJeAU/EIYrdg9tSuh0S80KppPJeW0HFlcA3xTd93eTn
	ZA82e/pHFXVAzMeyWb9cegTsebTZcd0ddbSWjt8aZUnLbuBvzHI03DNohtCMwyhh
	n9MmRvnUbrtUyqmMCRT0SsIe/RFLH0RL7L3DVUg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:5qtDy5+gC/134ujdEXJCgDet/gYQRgVF9N+5lkrmpMs=:Gn10J397k5HpCEWL0ZNgmvyOP2E7JV/sxhKi87f4cII=;
X-ME-Sender: <xms:pfboamHfEo-EZXq2j3tTdktenK2LErO5dL3DKHi3BwrH-lNhDFCrfw>
    <xme:pfboaml63A9VuyOdytu1CITv7hd_BmmEDM-qWijw280EDttU0JtwBIOUdsWtMGLNu
    e7zwugBrTaE7cblC8uT2lI31BWMnryWV0xIspocqYhZ3_aaFvoPeacF>
X-ME-Received: <xmr:pfboai9pBdhEG_OIqx-cDuypCSFrKX2hNzo856S1Vkgxx46ti-YmFYW16MZg-_hAaVRR0QaLIcInMxY_pQje_ZNM0NMvdn3RGXY>
X-ME-Proxy-Cause: dmFkZTGf099nM2Uoe/+0Y+gh+ygQ0na0IsUtMAqk+PMxwzP2m8G9Q/hXN7oNPOeSqczmlP
    GpkzUsJ06wZ8msVagoBN4R+93hsBSsBlJ1Mzsf42vFsKBRDuNEvQ/xrdRAqox3ElghD2xK
    7E75Bgl/us+1sE3ayKnEWsGXBzJxOfXOLmcvkaqgfW7oOMKIZFEoJAsTcyIm27pC8tWWRg
    vMw4lrmP9zxfk/yl0kVbQIOjqSqcjImNQKY2rPt/hBfr36bijDlsMpbo+Stu3NNd/S4gjY
    uCKCg4lwJoIn45T0q6O9Xzvwq4TaNxaYnU+dkVnb3jF0Ptrpkj/ADHdCV79kFomBcL0xEI
    3VK698brKMUkVzsMMpY7zaTUPx9Ehx2ZTdba2+qawwem/ILOdovw+qTHSJnD6c6nI5zBr6
    Wb3y9K1X5dQyX5v2k9pLWssqDsHud3lCX5bfKPfjcKXw9gxJn+rJSRpJqf4r9eAG9/3lxF
    8xv1wH1ng3nFJh/TMN+KHo11r3XXHHU4hlH0ntmPhWU8HekGodQFW5Fj+OXm3jEovUvqmD
    01wpIf+qr659w2oiKf99rBNIxchbUZw1TF26Mk17DVxsP6NVeNfzk9uMLn/adtUc6hPnnA
    y0FOYVqutYCh8BKc2Lct6LVjixtvhUkR6Fcz8VS4NmZwDQICL66/wRn48u3g
X-ME-Proxy: <xmx:pfboanna8wzaIV8ebKY_qzXqC-knuQoxidBmRQmg9q3G7yunYoNylw>
    <xmx:pfboagkE9SIh0sazd6KgHiEDC4mN-pFBp4unPM27i0VGmhQI--icdQ>
    <xmx:pfboarscQmZJN9G-ta6XpR2emjQFZRHwKW7fNgIQhCButsziRSkW0w>
    <xmx:pfboaqIkbp8Bc3ttYGfAYX58n479NGSxncc0hy9Cm29aD4p55-kDGA>
    <xmx:pfboaogzj7z_G_h1QuQGbdxgrZjixRsIF6HwyO8sXoz9H17_gtrM1eUX>
Feedback-ID: i47b949f6:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Nov 2026 15:46:28 -0500 (EST)
Date: Mon, 2 Nov 2026 21:46:27 +0100
From: Janne Grunau <j@jannau.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: michael.reeves077@gmail.com,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"Franky Lin (Zhenhui)" <frankyl@broadcom.com>,
	Mathy Vanhoef <vanhoefm@gmail.com>, Kalle Valo <kvalo@kernel.org>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com, asahi@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Daniel Berlin <dberlin@dberlin.org>, linux-kernel@vger.kernel.org,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-hardening@vger.kernel.org,
	Peter Robinson <pbrobinson@gmail.com>,
	Izabela Bakollari <ibakolla@redhat.com>
Subject: Re: [PATCH 00/13] wifi: brcmfmac: Add BCM4388 support
Message-ID: <20261102204627.GB770347@robin.jannau.net>
References: <20260925-brcm4388-submit-v1-0-b5cbc2cde2fb@gmail.com>
 <d78cbbd2-601a-4cf1-800f-3be57a2b7de2@broadcom.com>
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
In-Reply-To: <d78cbbd2-601a-4cf1-800f-3be57a2b7de2@broadcom.com>

On Sun, Nov 01, 2026 at 08:27:22PM +0100, Arend van Spriel wrote:
> + Peter, Izabela
> 
> On 25/09/2026 15:43, Michael Reeves via B4 Relay wrote:
> > The Broadcom BCM4388 chipset requires new PCIe initialization and
> > firmware interfaces. Add support for these interfaces to brcmfmac to
> > enable basic station operation.
> > 
> > This series adds:
> > - Signed firmware loading and mailbox transport
> > - Fixes for chip identification and firmware capability matching
> > - Versioned scan and join requests, and extended PMK payloads
> > - Updated event mask handling
> > 
> > These changes include work by Hector Martin and Daniel Berlin from Asahi
> > Linux, refactored where needed for upstream inclusion.
> > 
> > The series provides basic station support only. 6 GHz support is planned
> > for a follow-up patchset after this lands. The driver retains legacy
> > interfaces for older firmware.
> > 
> > Tested on an Apple M3 MacBook Air (J613):
> > - Device boot and network scanning
> > - 5 GHz WPA2-PSK association and DHCP
> > - Bidirectional TCP traffic
> 
> Finally got some time to get this series tested on my setup. The patches 
> generally look good. So far no regressions observed. It would be good if 
> some more people could test this series on their equipment. I will do 
> some more testing and wait some days.

Tested series on top of v7.3 + commit 7ed5dce55fa8 ("wifi: brcmfmac: map
msgbuf RX packet IDs bidirectional") in wireless/main with resolving the
conflict by dropping the conflicting hunk of this series.

Tested on Mac mini (M1, BCM4378) and Macbook Pro 14-inch (M1 Max,
BCM4387) without regressions (except for the resolved RX msgbuf
mapping).

Tested-by: Janne Grunau <j@jannau.net>

thanks,

Janne
