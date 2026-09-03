Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF6C41A926;
	Thu,  3 Sep 2026 10:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788431363; cv=none; b=iKqqjIks2Z3mzFyXrO5O5qMcc7OTM89FeC2AFNmeI1rnmiMccfIoj13cUf5YUQevOXSvlFQUCJZcci+OVtYSGufLre+5Kaf+pHkaCUm45mPDEKbeqrcbVPoctA7UsRmcLaY7ofvNJFNlafijCrYofC8NInoSDZVGRNG+HD/ycNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788431363; c=relaxed/simple;
	bh=uUES7jT5eZabTBh/o4EKa/vSwCX45bquAhYcylBnCvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BwSIc7YOOIP5/hHL10a1PibEK+bfmWdn26qJe4iLRas9TFTCW06IdbSLHVXX5mMD9yN2F2f0n4GiBjeTPZwCzO74EBcMKQy/+k4CdHuje5OPKmV80RRWhDuPyqxSuDK5lSNyyRu/if67wPtapMRti/2sBEw+2hON7t5vr1ggsrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MPm0Qkfu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MPm0Qkfu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E421F00A3F;
	Thu,  3 Sep 2026 10:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788431349;
	bh=7+L2p6qhIKE+7ceVwH3zzKlNP0/TD+mCPjdQVeeYPKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MPm0Qkfuy6odc1QH6yI2w5BIrTVetrwi8eGNB+J/DQr6JkkWstPfGOxrplEVjhZLU
	 +8V0W/mekASXE4BKNWcMNargESaqw3hBiDlk7q+C+6FhDzhGO4/aR/E7dHkZCKNGiS
	 Fo3B55RqvqevkSKmLjM60Fy8J4XomcfF7pWZByQriXvWUotIogYVOZ5zVt7y2OA+OK
	 AhnlMKgNCoD0xhs/OrkVbSRgK1awavcQRtXTZhnnHucVcpRA9PoswSaIqlO3Cuo3ct
	 Ey/oHgW+xOj7BEcOeiFTvWxmX9V0B0QNPacqy0JAQvpWLvt3stDksNZIyd0U6mLAsf
	 nk85yyV/BOfFQ==
Date: Thu, 3 Sep 2026 12:29:06 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-devel@silabs.com, 
	Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Lukas Stockmann <lukas.stockmann@siemens.com>, Gerard Salvatella <gerard.salvatella@siemens.com>
Subject: Re: [PATCH wireless-next v2 2/2] dt-bindings: net: wireless: wfx:
 discourage OOB IRQ with SDIO
Message-ID: <20260903-roaring-ibis-of-leadership-99a4ad@quoll>
References: <20260901083548.113131-1-jerome.pouiller@silabs.com>
 <20260901083548.113131-3-jerome.pouiller@silabs.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260901083548.113131-3-jerome.pouiller@silabs.com>

On Tue, Sep 01, 2026 at 10:33:20AM +0200, J=C3=A9r=C3=B4me Pouiller wrote:
> The WFxxx device provides an SDIO interface. In addition to the usual
> in-band SDIO IRQ, the device also supports an out-of-band IRQ line.
>=20
> However, using the OOB IRQ with SDIO requires to poll the control
> register during the device initialization. This polling is unreliable:
> if an IRQ is raised while the host reads the control register, the
> device is lost and only a reset allows to recover it.
>=20
> There is no way to fix this in software. So, warn the user that this
> setup should be reserved to debug.
>=20
> Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
> ---
>  Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml | 3 +++
>  1 file changed, 3 insertions(+)

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

