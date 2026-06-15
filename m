Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BBD3D1ABA
	for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2026 08:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781513231; cv=none; b=Ij2AJ7m8jjbdxcMfnXRJ5IDvpgfyJ8IfS+oP7/o6hMbeIDtN1xWf41QDyXBPZEibiejZQl6zO+IuCtkfiXDntpyH2SFtBZAhk+8Shm5eJHdRa1v85pgL3aEyIoyo/azaChr+WH7WvNq38hmQq2Y/7EBIhiRcBnW/tt95gCNNeLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781513231; c=relaxed/simple;
	bh=36Eqe3P0lexDFT9WtRGkeP33r12T3Ldt/0fjyKtZHsA=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YzOynlic+ry1LC9KoF1Mn9HflB0bZ0vvWaVO3ca2/FCh3V6XNbBt6dJgauCJ8YkNtFtcbGSgDblO1ocEVUVTKHPkWpNHNukosLqsGDpj/LvwgVMhGmENqTTQwjtebMBAnU0NaNZ/AQZMquYR32NkZgTPY78kQn+5UtabxGBER8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ihkxr7IK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ihkxr7IK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10A21F0155A
	for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2026 08:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781513229;
	bh=36Eqe3P0lexDFT9WtRGkeP33r12T3Ldt/0fjyKtZHsA=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=Ihkxr7IK9UQqH9939NKfzpzZPtyXug9rksT7re6jcnEAjJ5KkJaT25gIZcDrDlryE
	 VXPdtnFAe9S1DUdHvYq42Vs2JIoPKGKlRi+y/GR4Bm4PWDQn8A7CQ6luRtmOnNFwNo
	 1wLlldKK/P9owFbjFGkwVFJKLDwjsmgJr/G+DouPALuVcN1YnCevUi4RuPex0AzcuL
	 eGzP8y/i2iID2lXwOm//y9IgLPAeL4JaWdKspPxYssTs83N+150FgJh/6ciYUtDlYK
	 8FPZmF7XqZ8AZteDJvJc11uWYhutkVlAAVTCkkBv4KNNhkWA9XJemsf0Er7lYpk77f
	 lhtzbwUDYaYSQ==
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-39657d28132so22710501fa.3
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2026 01:47:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+gJehNHKRkFdIgAQexzmoKvZ/T2YDL6qzFet8+b9vVvhjnrJifn9C/m5IhTgqdWG9nekYZLsvh8Ph+uPbXnQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzyVw7T0BH3mCdMr4hnf05xiSkCxX6U1VIdunX+7J4Q4IgpX6zS
	p55xGX7gNanBBZZCRAvQq684w5wUnJzdECip2WIZJi95Ac+mYNHekPhnpNnZFc++z3SdD+odKST
	qTiA4ug4AxLH3LLBlzOayiqF0zkDzrQsLZPp0Pzg+mg==
X-Received: by 2002:a05:651c:1594:b0:396:5f6f:6e40 with SMTP id
 38308e7fff4ca-39935760c65mr24339471fa.22.1781513227972; Mon, 15 Jun 2026
 01:47:07 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 15 Jun 2026 01:47:06 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 15 Jun 2026 01:47:06 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260612-block-as-nvmem-v5-1-95e0b30fff90@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260612-block-as-nvmem-v5-0-95e0b30fff90@oss.qualcomm.com> <20260612-block-as-nvmem-v5-1-95e0b30fff90@oss.qualcomm.com>
Date: Mon, 15 Jun 2026 01:47:06 -0700
X-Gmail-Original-Message-ID: <CAMRc=MeNhR=30Q=gvPt0XwXbjJHgwjdC8gJ4nstwu2iKBD0x5w@mail.gmail.com>
X-Gm-Features: AVVi8Cd1V_fZoItE_I9KGUw7uwZ51MCBbXABRmFn8vXyiXcSneoYaZc7Se-syqA
Message-ID: <CAMRc=MeNhR=30Q=gvPt0XwXbjJHgwjdC8gJ4nstwu2iKBD0x5w@mail.gmail.com>
Subject: Re: [PATCH v5 1/9] block: partitions: of: Skip child nodes without
 reg property
To: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: linux-mmc@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-wireless@vger.kernel.org, 
	ath10k@lists.infradead.org, linux-bluetooth@vger.kernel.org, 
	netdev@vger.kernel.org, daniel@makrotopia.org, Ulf Hansson <ulfh@kernel.org>, 
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

On Fri, 12 Jun 2026 15:20:53 +0200, Loic Poulain
<loic.poulain@oss.qualcomm.com> said:
> Child nodes of a fixed-partitions node are not necessarily partition
> entries, for example an nvmem-layout node has no reg property. The
> current code passes a NULL reg pointer and uninitialized len to the
> length check, which can result in a kernel panic or silent failure to
> register any partitions.
>
> Fix validate_of_partition() to return a skip indicator when no reg
> property is present. Guard add_of_partition() with a reg property
> check for the same reason.
>
> Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
> ---

I think this warrants a Cc: stable and backporting as well as a Fixes tag.

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
