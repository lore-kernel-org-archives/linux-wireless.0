Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5BC3BB687
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 09:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791278762; cv=none; b=oX6WCHEnwBquiBOQ9cpTJ4tYYTB57rzt8XEC+klhqxxuQHpENZ+sVnWfLBUcs1Vsm7d1LA+QVH7+jnOEMQONk5V1RnqRto1Gx1lmqM4eT5wD/uGa6mqGWogO77vtVVt/lA2gzcGjN2BWyiHb0TvXvaqCMLD9QZu9wew9o5ItED8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791278762; c=relaxed/simple;
	bh=rvoCfkt6JKTfM4pyiK2zycW6kUL/pZtYO23p1+2prC0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JBqGeOPCOCZbiy571ua82HvTGjZdfLOXslOsFX67VsrYv9MKtv4oXEv+JMx0rrCECN5sBBQ6BKEgmP8YoM0z0XDycZN7hbJR41nW+bfJ5fEfnJteOm28MVhMP331bLjc7Zn6XKFoVtXbntmNeOg7j3dIjRtJMeW4QpSQXyhpYAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=cbFBOFwE; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="cbFBOFwE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=F3rilO8Ga7DTvA+Nv87c5I1cpSI7cgFoLmBkXO3Wgkw=; b=cbFBOFwEiQsV0cgOIIuKoQ1PBP
	ZaQ/jBmflQ2/aG187W+a3RZX7M69ExPYG9xLm47Dy2yppAWogm6CLfn5bJ8GEkxSwnIvvonX08EEf
	xs55vV6JFEqPSi8+MqVImN8Do8/4UbwlaxCtnWoLilddUbZMwKpcKSerCEBZm9um/dJ4=;
Received: from p54a434bb.dip0.t-ipconnect.de ([84.164.52.187] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xE1Qq-00GqWr-11;
	Tue, 06 Oct 2026 11:25:56 +0200
Message-ID: <8dec78e7-1f4a-4d68-a592-15ad0f1fdac0@nbd.name>
Date: Tue, 6 Oct 2026 11:25:55 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/23] wifi: mt76: mt7925: add NMI/NDI MAC address setter
 helpers
To: Sean Wang <sean.wang@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
 yu-ching.liu@mediatek.com, jenhao.yang@mediatek.com, posh.sun@mediatek.com,
 Chengwei Yu <chengwei.yu@mediatek.com>, Sean Wang <sean.wang@mediatek.com>
References: <20260927210306.737669-1-sean.wang@kernel.org>
 <20260927210306.737669-3-sean.wang@kernel.org>
Content-Language: en-US
From: Felix Fietkau <nbd@nbd.name>
Autocrypt: addr=nbd@nbd.name; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCeMncXpbbWNT2AtoAYICrKyX5R3iMAoMhw
 cL98efvrjdstUfTCP2pfetyN
In-Reply-To: <20260927210306.737669-3-sean.wang@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27.09.26 23:02, Sean Wang wrote:
> From: Chengwei Yu <chengwei.yu@mediatek.com>
> 
> Add mt7925_nan_set_nmi_address() and mt7925_nan_set_ndi_address() for
> runtime MAC address changes: NMI goes through the MCU (firmware owns
> the hardware address), NDI updates vif->addr directly.
> 
> Co-developed-by: Sean Wang <sean.wang@mediatek.com>
> Signed-off-by: Sean Wang <sean.wang@mediatek.com>
> Signed-off-by: Chengwei Yu <chengwei.yu@mediatek.com>
> ---
>   .../net/wireless/mediatek/mt76/mt7925/nan.c   | 48 +++++++++++++++++++
>   .../net/wireless/mediatek/mt76/mt7925/nan.h   |  8 ++++
>   2 files changed, 56 insertions(+)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
> index 8a59f7b1aee2..abbd3f7b081c 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
> @@ -697,6 +697,54 @@ void mt7925_nan_mcu_event(struct mt792x_dev *dev, struct sk_buff *skb)
>   	}
>   }
>   
> +int mt7925_nan_set_nmi_address(struct ieee80211_vif *vif,
> +			       struct mt792x_dev *dev,
> +			       const u8 *mac_address)
> +{
> +	struct mt76_dev *mdev = &dev->mt76;
> +	struct {
> +		u8 rsv[4];
> +		struct mt7925_nan_nmi_addr_tlv nmi_addr_tlv;
> +	} nmi_cmd = {
> +		.nmi_addr_tlv = {
> +			.tag = cpu_to_le16(NAN_UNI_CMD_CHANGE_NMI_ADDRESS),
> +			.len = cpu_to_le16(sizeof(struct mt7925_nan_nmi_addr_tlv)),
> +		},
> +	};
> +
> +	if (!dev || !vif || !mac_address)
> +		return -EINVAL;
> +
> +	if (is_zero_ether_addr(mac_address) ||
> +	    is_multicast_ether_addr(mac_address))
> +		return -EINVAL;
> +
> +	memcpy(nmi_cmd.nmi_addr_tlv.nmi_addr, mac_address, ETH_ALEN);
> +
> +	return mt76_mcu_send_msg(mdev, MCU_UNI_CMD(NAN), &nmi_cmd,
> +				 sizeof(nmi_cmd), true);
> +}
> +
> +int mt7925_nan_set_ndi_address(struct ieee80211_vif *vif,
> +			       struct mt792x_dev *dev,
> +			       const u8 *mac_address)
> +{
> +	if (!dev || !vif || !mac_address)
> +		return -EINVAL;
> +
> +	if (is_zero_ether_addr(mac_address) ||
> +	    is_multicast_ether_addr(mac_address))
> +		return -EINVAL;
> +
> +	/*
> +	 * The NDI address is not managed by firmware; it is the vif's own
> +	 * hardware address, so updating it locally is sufficient.
> +	 */
> +	memcpy(vif->addr, mac_address, ETH_ALEN);
What about bss_conf->addr and the netdev addr. Do those need to be updated?

- Felix
