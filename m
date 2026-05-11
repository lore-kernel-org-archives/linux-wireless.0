Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272AD372680
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2026 11:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778498995; cv=none; b=F4nhsZhrUCz6l+Kf4THCMxcNcpzW7Up+DwpnYlOFUV/MCfACxfSUUQ8lHrAob6UfTNaIfuhrX6WTVqOiqnBWosppITkltcXb1G/hMIK5ooI9kP3pOYkEv8+PhPo+JWIrPmrYpSu5f5PCMSh3/aZUBWVOk4xAsrCqrFmfcCithz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778498995; c=relaxed/simple;
	bh=tdFL3cPC7dgZ1OdiKSsShuzcagDej0oltX3UD+D1qeU=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E5H/m9ZaFNKOCOH2oLQ1UQqOii4iSbHxGlv1Gtw3c8eb4zHixzs4CaaKNebByYTQKcPc6KW45KJBOxhRt5iFoJcIQ6vPwl/nkO83X0q9AIgd4K+ctw4tPNeCAe4DBox/gEy9ZwDYNfcUQzEyuKMM6pgYfWQhZW1TEORkDKxgMxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BNoY/Up3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BNoY/Up3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9058C4AF11
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2026 11:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778498994;
	bh=tdFL3cPC7dgZ1OdiKSsShuzcagDej0oltX3UD+D1qeU=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc:From;
	b=BNoY/Up3ZZK4KlFbFax3F2kAw3dOU2aIIblQC5p9XzrxxPp7amEIyAmyjsnuhhPK/
	 eJfdm+/qgfFTrdvXXrUYLCUeFinCda6+cPZlBge9jus0bumwq/9uhCOkNkfQ2CfS/g
	 mNZpqLZgHfTcNk2QuzIZvb06ofR6nYRUa/aes2/oztQdbQv+AgZ0tmW1349GeCI61x
	 dcR9Z8ayd79ftB9acJ6oGbCVEM0nJXwstKkgn30Ps1428UYuLzvOoU2jYoQRGv4PWz
	 LqHzh2SFlhHFmTszTalKz1N7r6aj8n25n431M9yJWdZl+B6lkAygJMi4plE6L4iVXA
	 5VTVpE9hiXXlQ==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5a62f43b76aso3574920e87.3
        for <linux-wireless@vger.kernel.org>; Mon, 11 May 2026 04:29:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9tOTYqj1/sT+dgUPahGqdZFSV6JUdwjuN7hhknAOIQ0gWErFayd78T0Vaih2jHMqd/H06ivO3NrTlryDkV/g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLltjRBJv83AIwUrjB/aAbggYVdH4cM6yggHXy9gsSv1dzeLee
	v2EPWhO9GWA3aZHCjuDisns3ZMP1suP16RBn9yB78Qj/qjixni5CcCF0F5p7MaSUGhsCoDBqA/Q
	aQSNsXP+1U5NAWyOxzcuLJ6oFUaWzknTTWokwoEcYew==
X-Received: by 2002:a05:6512:1543:10b0:5a8:886a:1164 with SMTP id
 2adb3069b0e04-5a8886a11ccmr6099795e87.28.1778498993519; Mon, 11 May 2026
 04:29:53 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 11 May 2026 04:29:52 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 11 May 2026 04:29:52 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260507-block-as-nvmem-v2-7-bf17edd5134e@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260507-block-as-nvmem-v2-0-bf17edd5134e@oss.qualcomm.com> <20260507-block-as-nvmem-v2-7-bf17edd5134e@oss.qualcomm.com>
Date: Mon, 11 May 2026 04:29:52 -0700
X-Gmail-Original-Message-ID: <CAMRc=Mfd-aZ4MYiREuj_+J1ffa3U5hq5akJm-Gmxt=M=U=ysoQ@mail.gmail.com>
X-Gm-Features: AVHnY4ILi1PcmSG850nlSHDG8-qtHUQDx3iBPHF4VU-jbJRdQWICOE-eFNii9gk
Message-ID: <CAMRc=Mfd-aZ4MYiREuj_+J1ffa3U5hq5akJm-Gmxt=M=U=ysoQ@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] Bluetooth: qca: Set NVMEM BD address quirks when
 address is invalid
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

On Thu, 7 May 2026 17:24:42 +0200, Loic Poulain
<loic.poulain@oss.qualcomm.com> said:
> When the controller BD address is invalid (zero or default),
> set the NVMEM quirks to allow retrieving the address from a
> 'local-bd-address' NVMEM cell. The BD address is often stored
> alongside the WiFi MAC address in big-endian format, so also
> set the big-endian quirk.
>
> Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
> ---
>  drivers/bluetooth/btqca.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
> index dda76365726f0bfe0e80e05fe04859fa4f0592e1..df33eacfd29fa680f393f90215150743e6001d5b 100644
> --- a/drivers/bluetooth/btqca.c
> +++ b/drivers/bluetooth/btqca.c
> @@ -721,8 +721,11 @@ static int qca_check_bdaddr(struct hci_dev *hdev, const struct qca_fw_config *co
>  	}
>
>  	bda = (struct hci_rp_read_bd_addr *)skb->data;
> -	if (!bacmp(&bda->bdaddr, &config->bdaddr))
> +	if (!bacmp(&bda->bdaddr, &config->bdaddr)) {
>  		hci_set_quirk(hdev, HCI_QUIRK_USE_BDADDR_PROPERTY);
> +		hci_set_quirk(hdev, HCI_QUIRK_USE_BDADDR_NVMEM);
> +		hci_set_quirk(hdev, HCI_QUIRK_BDADDR_NVMEM_BE);
> +	}
>
>  	kfree_skb(skb);
>
>
> --
> 2.34.1
>
>

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
