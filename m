Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45300383C89;
	Wed, 12 Aug 2026 07:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786518780; cv=none; b=kk9qJSYqh/2aEwJeYMrWheKDAyfmv6LcLG/geAKXmxEbWfEQHd9BT+Hs8pZIAjhQS3mEuwRRHeh28ESuyfzvuMl4h8Yj+s4sU7DEhqR4zSc52XtA1l7kIHFZDs3ZiR6klEoaABapPn1de1DIpJ1uuD2eAdl87YVP0MeaJOYwL7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786518780; c=relaxed/simple;
	bh=VQi1EaVbL2hU+QwBiJ2KSgSfI7guwvcoSatUvfhLGcM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BDY87NnyhwUW9ZtgQevQTNaUOW713TuXdagohmyWQ7AsvuBRtFykpHClMTS4dKph4FxC5eSW0wpW/8R1sYCcmh6jb1VETcvZN9wAEUVhXOyuKoVORJzZDXyPEPQ2jaS916pUfdcwSaIZ1HdMLJ7VEz8sxwePhFDdta+9bZBO7Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=green-communications.fr; spf=pass smtp.mailfrom=green-communications.fr; arc=none smtp.client-ip=212.227.126.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=green-communications.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=green-communications.fr
Received: from client.hidden.invalid by mrelayeu.kundenserver.de (mreue012
 [213.165.67.103]) with ESMTPSA (Nemesis) id 1N8VkX-1wywpw14an-00ygG3; Wed, 12
 Aug 2026 09:12:45 +0200
Message-ID: <b308aff2-422b-4ac1-84d8-f066aa17f5fe@green-communications.fr>
Date: Wed, 12 Aug 2026 09:12:43 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless] Revert "wifi: mt76: Disable napi when removing
 device"
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
 Thorsten Leemhuis <regressions@leemhuis.info>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
 Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>,
 Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>,
 Bert Karwatzki <spasswolf@web.de>, Devin Wittmayer
 <lucid_duck@justthetip.ca>, Eric Biggers <ebiggers@kernel.org>,
 linux-kernel@vger.kernel.org,
 Linux kernel regressions list <regressions@lists.linux.dev>
References: <20260804120004.523934-1-mikhail.v.gavrilov@gmail.com>
 <18b018d0-7f7d-4975-b0b3-5e3c9f413698@leemhuis.info>
 <CABXGCsMhfR-fOwUgKuQrojM8jEpdco_m9aYA9ph_EOrCfaPxeA@mail.gmail.com>
Content-Language: en-US
From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
In-Reply-To: <CABXGCsMhfR-fOwUgKuQrojM8jEpdco_m9aYA9ph_EOrCfaPxeA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:GaVZyzekj9x/vvbT5ncKOHyvA5oAzdQoFRYVQ+98FU5LYyxKUip
 pYy/ZyFYLrbnCvN/Jncfh/DCFgOtAry6y8nOQbCdFQROx6tbhBIcmxlM50PrwiV6GL0H2RR
 FOD12Y/NY8aYA4mBHNGt33++1JbrlI2J6TsVTUcDaELDcp2mPL1xT0ZxuTqNvhsOcCaD2A6
 BlF3PapvUZjbpEcwxQQRQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Yxyf3+e41JQ=;7BJuyb7Tr4Evc14ulnbvjk7FWOF
 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

Le 12/08/2026 à 00:30, Mikhail Gavrilov a écrit :
> Felix, could you also mark my withdrawn first attempt as superseded?  It
> is still at "new" too, and it must not be applied - it replaces the hang
> with a use-after-free:
> 
>    https://patchwork.kernel.org/project/linux-wireless/ 
> patch/20260728002048.19351-1-mikhail.v.gavrilov@gmail.com/

Depending on the patchwork configuration, you might be able to change 
the status of your own patch if you register an account. I'm not sure if 
patchwork.kernel.org allows it, through.
