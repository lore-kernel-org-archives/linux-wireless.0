Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AD23750BD
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2026 11:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778499006; cv=none; b=pEhpNH4uk509er3BQmNJozh4gd1N9nHIoHIQyU2cEgG5Xa1AbJaabf0QHoKEaWPW6GMUp8vsLIDIaDBM3+CT4zABigRxdW9Pn3bytfIJBiazRphT5PC1MnUVETluf4R26sMPsBE4jNfY8BfYr1qeeMAhu/v68UorF3mzNA+JcLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778499006; c=relaxed/simple;
	bh=IqeusD7M1GeDYISR0gEebUtKpnVGG12mdh36BE5ONCI=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GTTXtaGuVhPo5tox22S7oSOAfYG4lOGWv+xJ/zPfkF0uJ7dtZM01wZCnzgKFenUUeCaOOQiWBXgjlafSFhAigV+ulH4SeH+HBIT2Ip5BB1iB5EC5b3kVwzNGP9SSQDTrQNR8DyVD1lp2LH8wNR8902NqgwBI0tsqKvYsKOUt9So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UQCdmNsA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UQCdmNsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0464DC2BCFD
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2026 11:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778499006;
	bh=IqeusD7M1GeDYISR0gEebUtKpnVGG12mdh36BE5ONCI=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc:From;
	b=UQCdmNsA2HNRZi618Ti6Qgj7Eu2mu+CjUBP6v8fQlfk0MiE639MxL8eWXPHwelqmg
	 9s8fwULbVpjE1SEqsNZ+1yE4RTDr+DPLjtlChVqZoRyMcRrjgnHr0K95KzeidjVFwo
	 w/faNuiTciWBxTuAz3FiBcOsfbXOa9oYRzb5QLzhlV8ek504pFwt6ksLN6OJCC/N2J
	 CAq+9d9Zv2jkQFfX5RXz5/NCue3ECTlzZLKbdQ2PqxWLhsk5fKPSz+SBFR918eIGyN
	 CjsRmLQ+Kwaipq2MHQ7oPADPMBGKHgSAhkHEimGMc+1kpphIuC4IkzsVT5zFB+2voP
	 kjP61TSkHblcA==
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3938cc204a7so33466801fa.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 May 2026 04:30:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/rdpZNYmog+pXSXAlx6OQBRzMaVPYpcQXkDfMiqnIZuIb8lmRJTP8ohisrvDBwQlY4w6vpGNK4tB6eu4R3hQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxBBfKtBPCgKYBLOiMN0VqVKh7KH3yqvo3pa15wNZoXUf3JlGTq
	mwF7SBHXoGjBPKZrg6kdDhlQey5XnbTBB+KiV8ni7SsW5GTyYes8B4V+MMEE3K1s75xIJA8Vho1
	+G+WlVBitbERSf9fjqaSPtGJl2sB1jGQ+GqMPbWKC0Q==
X-Received: by 2002:a05:651c:897:b0:394:5b8:485a with SMTP id
 38308e7fff4ca-39405b84da4mr33981821fa.14.1778499004642; Mon, 11 May 2026
 04:30:04 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 11 May 2026 04:30:02 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 11 May 2026 04:30:02 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260507-block-as-nvmem-v2-8-bf17edd5134e@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260507-block-as-nvmem-v2-0-bf17edd5134e@oss.qualcomm.com> <20260507-block-as-nvmem-v2-8-bf17edd5134e@oss.qualcomm.com>
Date: Mon, 11 May 2026 04:30:02 -0700
X-Gmail-Original-Message-ID: <CAMRc=MfM7cTRA7fMG_ej2v1e=6aQDMz3t9TxvwXeJ0mR1VY2dw@mail.gmail.com>
X-Gm-Features: AVHnY4J57m614VXHB1gG4Q2Qt_nwp6rzOp-nMalUaxmsHemzFoQ6bUJPlO5KxfQ
Message-ID: <CAMRc=MfM7cTRA7fMG_ej2v1e=6aQDMz3t9TxvwXeJ0mR1VY2dw@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] arm64: dts: qcom: arduino-imola: Describe NVMEM
 layout for WiFi/BT addresses
To: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: linux-mmc@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-wireless@vger.kernel.org, 
	ath10k@lists.infradead.org, linux-bluetooth@vger.kernel.org, 
	netdev@vger.kernel.org, daniel@makrotopia.org, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, Ulf Hansson <ulfh@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Berg <johannes@sipsolutions.net>, 
	Jeff Johnson <jjohnson@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
	Marcel Holtmann <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	Balakrishna Godavarthi <quic_bgodavar@quicinc.com>, Rocky Liao <quic_rjliao@quicinc.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Srinivas Kandagatla <srini@kernel.org>, Andrew Lunn <andrew@lunn.ch>, 
	Heiner Kallweit <hkallweit1@gmail.com>, Russell King <linux@armlinux.org.uk>, 
	Saravana Kannan <saravanak@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 7 May 2026 17:24:43 +0200, Loic Poulain
<loic.poulain@oss.qualcomm.com> said:
> On Arduino Uno-Q, the eMMC boot1 partition is factory provisioned
> with device-specific information such as the WiFi MAC address
> and the Bluetooth BD address. This partition can serve as an
> alternative to additional non-volatile memory, such as a
> dedicated EEPROM.
>
> The eMMC boot partitions are typically good candidates, as they
> are relatively small, read-only by default (and can be enforced
> as hardware read-only), and are not affected by board reflashing
> procedures, which generally target the eMMC user or GP partitions.
>
> Describe the corresponding nvmem-layout for the WiFi and Bluetooth
> addresses, and point the WiFi and Bluetooth nodes to the appropriate
> NVMEM cells to retrieve them.
>
> Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> ---

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
