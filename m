Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE1139BFFF;
	Thu, 30 Apr 2026 09:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777543176; cv=none; b=Y6/U6DPtKtRAs6FR8wMqa5k7JE2CUcgC0bJHJifk6as9dg8rzc3HXh0nrgcdCITAY69wq9vPFjACihw8tj9my0MFS9UpeYMKtS8EDmqiJJ5LNef0uKizCGlvtslGyHk75Rnix2e4n0ZL6TxcQ5qCvG9/6RfpwTgRIhgvbtA/yFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777543176; c=relaxed/simple;
	bh=r5OekOuIfqXKaIzcdDYrquzLVq5admxf1CUW3+qBysU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y+E1N2IFFa5stypSUh7WlDcZyAda4d49F/Lyr3NtaiBGta+0eHe/lSrg82IgZHJyrFhrbM7w5+JnMg471oyaK/qTDNQ+O54BjZDj9qdUL+Sj6rrdqhu99BZaYjQ4YERe0TMFtrigmiseLzMzOGIJ/V7KzYT3wybIG2aba65vw/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cVWSe6fk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cVWSe6fk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844D9C2BCB3;
	Thu, 30 Apr 2026 09:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777543176;
	bh=r5OekOuIfqXKaIzcdDYrquzLVq5admxf1CUW3+qBysU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cVWSe6fkTBOARjXulhsALwZx0VxGML7gFmK9AkttqSJxT8GozkeUV3NLeGt4ntj0j
	 VIIYIb8TGgxN06TV9G8Pnasoc8D3Z0mxmfc2O08Zn7e7zA85vy58dQ6ddiBn0FtyP8
	 hYfs4q+oVeZCdmYKcmn2iyTtRmCTNf8qVZevNHNNvqvFWZX4LndhykI+pILkN1y1eY
	 R+spRbUuXD04AppQrxySrBSdYd/Wm7S69RAdJ0W+ZoWWxaTtCS6azjPgfwW6Tte/J+
	 C3S6uyKU3BPuEaVjGJuqHQ7+VQSKd3qOS17kBwu/kG+h9V1kLMNuiLLl8WbPzWjsW5
	 RWfpE98i9berA==
Date: Thu, 30 Apr 2026 11:59:33 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Ulf Hansson <ulfh@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Berg <johannes@sipsolutions.net>, 
	Jeff Johnson <jjohnson@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
	Marcel Holtmann <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	Balakrishna Godavarthi <quic_bgodavar@quicinc.com>, Rocky Liao <quic_rjliao@quicinc.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-mmc@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-block@vger.kernel.org, linux-wireless@vger.kernel.org, 
	ath10k@lists.infradead.org, linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org, 
	daniel@makrotopia.org
Subject: Re: [PATCH 1/9] dt-bindings: mmc: Document support for nvmem-layout
Message-ID: <20260430-bird-of-sheer-ampleness-744e7f@quoll>
References: <20260428-block-as-nvmem-v1-0-6ad23e75190a@oss.qualcomm.com>
 <20260428-block-as-nvmem-v1-1-6ad23e75190a@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260428-block-as-nvmem-v1-1-6ad23e75190a@oss.qualcomm.com>

On Tue, Apr 28, 2026 at 04:23:06PM +0200, Loic Poulain wrote:

> +                    compatible = "fixed-layout";
> +
> +                    #address-cells = <1>;
> +                    #size-cells = <1>;
> +
> +                    mac-addr@4400 {
> +                        reg = <0x4400 0x6>;

This looks incomplete. Why isn't this mac-base type of entry? And how do
you address it from NVMEM consumer?

> +                    };
> +
> +                    bd-addr@5400 {
> +                        reg = <0x5400 0x6>;
> +                    };
> +                };
> +            };
>          };
>      };
>  
> 
> -- 
> 2.34.1
> 
