Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C0B345734;
	Wed,  1 Jul 2026 07:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782889518; cv=none; b=SJD6lzvSntvSVhICkd5JKhCNgDJD9A+gwb6coYYHGiNcjcPnkb3tJUG2rilAR3dZMN7ue1tcpxIBT83ne1JWMjb7MWG2f6qKbXJD/tuOKtNficwLxPEamXto46kDiESR2eStidOB90BrZIy1+d/dizhlB1cU10PgH2fVrtf08VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782889518; c=relaxed/simple;
	bh=9ww35R6l447d+RHkaoNW0Hm1lPO5lZ8OZndrydqnn6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YqTAINwBphFXzuloNnNx4MMwsmFxGvps/4TbhJ/vLQfDx2d4SFsKRB1ComHUqZSLqXxX58+d5wC27XCITNOcgp5BmQ0JgJyLv/+L2BiHI0Pv2zBo5EZA01rDKd6r5YwuS9r/yPP30uf3XCUknfV3mhrzrrMu7GHP84942WQqJKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DVVj6YqE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DVVj6YqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0C11F00A3D;
	Wed,  1 Jul 2026 07:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782889517;
	bh=mia8sxKq83EdbDucERboNXKa1jY/lp3YbI5KEzP21q0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DVVj6YqEllZle4eLdF5SZgzJoKA8cAAV8lrQxpPrzMwXlJdu9RWxnnNvXoXLJQI+l
	 GVWmPVFpBBP33BiFrWkJYWWGycb2B9COkuGSfcUxl2reIF6EFqcnuTICdkFEGN7vJx
	 UiXp+Dk1a7xKLt88rQ+eaAS4VaNysLgWn/2ErzO49Ns/j/SYt/NMBhKLs09iC8+Qq3
	 D5emPGL3UKrC1+IiYKlmarUklxkoD92+oiZ5VjCmbZaA4qiSoA5JLCLCp9eDuo8ZU6
	 mgQNgXNrAX84MEZ5E6BsRfO3NXc5iRMXzP0FvTKejLmoTR+Sl3vQNBhmzG5IQ52CPT
	 QzASCVo+6LsZA==
Date: Wed, 1 Jul 2026 09:05:13 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Andrew LaMarche <andrewjlamarche@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, 
	Jeff Johnson <jjohnson@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, ath12k@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Ernest Van Hoecke <ernestvanhoecke@gmail.com>
Subject: Re: [PATCH v2 2/2] dt-bindings: wireless: ath12k: drop
 qcom,ath12k-calibration-variant
Message-ID: <20260701-objective-gay-aardwolf-fcffef@quoll>
References: <20260630133001.1426824-1-andrewjlamarche@gmail.com>
 <20260630133001.1426824-2-andrewjlamarche@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260630133001.1426824-2-andrewjlamarche@gmail.com>

On Tue, Jun 30, 2026 at 01:30:01PM +0000, Andrew LaMarche wrote:
> The ath12k-wsi binding documentation describes using the
> generation-specific qcom,ath12k-calibration-variant binding as well as
> the generation-agnostic qcom,calibration-variant binding to load
> board-specific calibration data from the device tree. However, the
> driver never implemented either of these.
> 
> Given that no devices currently supported use
> qcom,ath12k-calibration-variant and the previous patch implements
> qcom,calibration-variant, drop the generation-specific version from the
> binding to prevent future confusion.
> 
> Signed-off-by: Andrew LaMarche <andrewjlamarche@gmail.com>
> ---
>  .../devicetree/bindings/net/wireless/qcom,ath12k-wsi.yaml  | 7 -------
>  1 file changed, 7 deletions(-)

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

