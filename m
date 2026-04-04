Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE56A2D3A60;
	Sat,  4 Apr 2026 10:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775300263; cv=none; b=A+ixJ/ovlymVaweIjW1VOZrtIWkgBqNIPmOMnRC50Mer0j5zBgo+inMiP7rrofY9+av+vcNsPy3AdzYQnQLZcXqULt3CsYVw1x65nCgDk29dsRUC94SoUFJZBFfxjmWm/rYqSgcCjUUiPe2l8zfexLejc+OFXviYRk6vznYapv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775300263; c=relaxed/simple;
	bh=hbrkyKzyYh2RUSekpQ2Vk/cdjhZ/Anu7DtnZZOV6zrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RAkccVmpWsmt9PFlOpFYkqAFHXzFu+b40ZQgWTBqKDwkWLB350v6BfLaYDocgWKZBv96aLTD+z10lrc2Jlv2/loUgKkFSvzXypVBQM/2ijKXS66yPfaKVJgwPetpfcz/ZxvCJ6KyAdVJjre+/l3WvPCdG1TcZC3Lejrs8nKK0sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gPcy+9Lc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gPcy+9Lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A9AC19421;
	Sat,  4 Apr 2026 10:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775300263;
	bh=hbrkyKzyYh2RUSekpQ2Vk/cdjhZ/Anu7DtnZZOV6zrc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gPcy+9Lc3ZxOGyiROZnJsx0Qj9fT7tDtdhPAFXny6/OP9RNQrouARYmiKFmbp4IGg
	 LapD6ojiXaKj/cW6v1aQ1/okwZT8fEwwSMXzbISvER5R5ws6Rz/H0hvmgCBXXKYv0S
	 qkxP/UIq2hqBjy6KZXLzoevfMl19QGvcRcsOnLfIGjJPK/OM+CfvzqoA1PTZ2G38sP
	 g+2VoUlljpELj1RAt62FVWtXdTVW6+mAJzWWCYZ+LyXXKQ1fWJwnxn6Ks8X84e6Cpe
	 XBiXb9wirS0awPsBsy3cBoXOdeovYDmWDiZStwBYanQ9DWbVQUXaHIjRzii7swuvd6
	 LSJ5dIqDP4KCw==
Date: Sat, 4 Apr 2026 12:57:41 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Luca Weiss <luca.weiss@fairphone.com>
Cc: Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Alexander Koskovich <AKoskovich@pm.me>, Liam Girdwood <lgirdwood@gmail.com>, 
	Mark Brown <broonie@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
	Marcel Holtmann <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	Balakrishna Godavarthi <quic_bgodavar@quicinc.com>, Rocky Liao <quic_rjliao@quicinc.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Jeff Johnson <jjohnson@kernel.org>, 
	~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org
Subject: Re: [PATCH v2 1/7] regulator: dt-bindings: qcom,qca6390-pmu:
 Document WCN6755 PMU
Message-ID: <20260404-lynx-of-extreme-chaos-1aa3f5@quoll>
References: <20260403-milos-fp6-bt-wifi-v2-0-393322b27c5f@fairphone.com>
 <20260403-milos-fp6-bt-wifi-v2-1-393322b27c5f@fairphone.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260403-milos-fp6-bt-wifi-v2-1-393322b27c5f@fairphone.com>

On Fri, Apr 03, 2026 at 03:52:47PM +0200, Luca Weiss wrote:
> Document the WCN6755 PMU using a fallback to WCN6750 since the two chips
> seem to be completely pin and software compatible. In fact the original
> downstream kernel just pretends the WCN6755 is a WCN6750.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>  .../devicetree/bindings/regulator/qcom,qca6390-pmu.yaml  | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

