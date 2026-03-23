Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649053DBD59;
	Mon, 23 Mar 2026 19:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774294651; cv=none; b=RblQWd9zpUzAhWzs4THcLZKm1TjTSB5GuBAJcmSGPhciLht3LWQiypzIe0SjmfZBugBLcKSQwrzSu6nsVWp3f3p+bZEdGypk1d8y04Z83w07eB2sQa94+aDz4oi1YnayFAypo+gabGruq01/VwO9PS+ZqhnaBY/dqh/OcHLiyJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774294651; c=relaxed/simple;
	bh=YNOY/10bL1EV7q2Imm4uWe0CYApalti2dt5cIVqYu88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RJNdNussuP8b1duWatQtLvC0mtBHfg1nkT9uTv22gHk1h9q++AQI/FzV+Pse7IGAZfv5Av1Pfa0ISIX1tqrNvnQS/Z+nyt2MqgMvHWiMhR92jTgGnFlFnVEYPEZ1jXwhyYE9ksdFpUqEJJNzW2nVaOXvdkhgHdW/W6EoNTRYlmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wf3lvA+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wf3lvA+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6F8C4CEF7;
	Mon, 23 Mar 2026 19:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774294651;
	bh=YNOY/10bL1EV7q2Imm4uWe0CYApalti2dt5cIVqYu88=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wf3lvA+GH/GQJEW785Yo559nDoXleT8uPH40hxJfta5Zz2n/wmJIYAPsSBHWs/par
	 SNch8HOXTjI3xocXCxzZSyg4lUavveInbw5bpnX89woONwx5Jnf5SnjCkKb8EIVxTC
	 /IYKO2SYn11ENt2U4n7aSemuvRok2VgCekr2hMFYb0k2z35fOtrp96Q/ziP+wS23k+
	 U79sYg+3OTnESUCQ95yTcLRiKERECazxOoZqXJCbelhVBDq4DnthtOy28EP8omsGLc
	 rcwzYGmbU6GqaNp3xmuCIKDuxl+38SyZ/Vkl6dumETkOzvyKagwtqH8ZBYLOAG+vdb
	 v03QCoJU3zQcQ==
Date: Mon, 23 Mar 2026 19:37:25 +0000
From: Conor Dooley <conor@kernel.org>
To: Ronald Claveau <linux-kernel-dev@aliel.fr>
Cc: Neil Armstrong <neil.armstrong@linaro.org>,
	Kevin Hilman <khilman@baylibre.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	van Spriel <arend@broadcom.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 8/9] dt-bindings: net: wireless: brcm: Add compatible
 for bcm43752
Message-ID: <20260323-hardhat-bladder-0c83339de3bd@spud>
References: <20260323-add-emmc-t7-vim4-v3-0-5159d90a984c@aliel.fr>
 <20260323-add-emmc-t7-vim4-v3-8-5159d90a984c@aliel.fr>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8LJrZXED2O+23fWg"
Content-Disposition: inline
In-Reply-To: <20260323-add-emmc-t7-vim4-v3-8-5159d90a984c@aliel.fr>


--8LJrZXED2O+23fWg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 23, 2026 at 10:55:33AM +0100, Ronald Claveau wrote:
> Add bcm43752 compatible with its bcm4329 compatible fallback.
>=20
> Signed-off-by: Ronald Claveau <linux-kernel-dev@aliel.fr>

Acked-by: Conor Dooley <conor.dooley@microchip.com>

--8LJrZXED2O+23fWg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCacGWdQAKCRB4tDGHoIJi
0mLYAQDKVk2X94u3DdOJf1xVZS1DjAAOaqRhxQmCavFb8iljzgD/a7q4+h0ExxYk
1S35bjSvl2V4D0hADEYDx1qRaOas3QQ=
=yoc+
-----END PGP SIGNATURE-----

--8LJrZXED2O+23fWg--
