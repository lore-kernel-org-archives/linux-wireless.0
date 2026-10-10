Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C8935200C
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 18:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791655589; cv=none; b=gHnfqBWFs8wC4jEo6VC9Z1xSTuH9HbE+J833rQoHv5OWp91ldpz2tcq1X51ryTP39jSI9eAyYNL4cs0MqkYeh7xgwhCWqY2U92D2yNv9GPd1d6xU8RmOu59D5fOSIRLAq/SDSXomEoHzR9weM2aF+Q9fTZa24BoAaSFdEK3DzMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791655589; c=relaxed/simple;
	bh=wMNhQ+eYspo2MxJfF9CeHWaZbuypHhZaD8KnLapNkL0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IxCISnKkTpQ11nv/a150+SiH2rWUX3cMgYVzOvyke63uWXA4h40EXWNeZU8eB8PDDxn6TzMXxEkCQpvInj7XsciwvcZQyAWkt4sF4O4DjU9o5BesSLksUSjRX95ZSKQ6M3sG8PMk87xO98wnxHE32d5n7d/rA923914g9YkBcqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VjNT5YaQ; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VjNT5YaQ"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49ff680331aso5924765e9.3
        for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 11:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791655586; x=1792260386; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T2jVrgH55k3k3p8kJOIrXqSnnuHRHhh/LASrNcRGybI=;
        b=VjNT5YaQiLXg2bbaIBTT9SgvV9leUI6f6KqvbPTvO5UTr4eKNSsRph8HuCReK07Yxz
         XCOoG89ceG6Px2we4RTdXu/wOP85kA9GC+cRM2idDmxXP6iafz3R9OVse4lEqqNdraly
         ZLNFl81fzfiaVDtfd4MAk+7qOEBCDW4v056ngHhoF+1pTbalOkwgXz9QDfvPdfaB9X0f
         FkyBvzdQssB6YzHadRJtqDv/pcWSUwLCvZFLo9qq2SgUBZcbvJeERO2MVupQaWDt5ztL
         IryR3Y1m9r5E9q04L3ho5KqfsPhps+ySxfEv6WDgMDilFFa758VHpiAcW8J2R751mxXE
         m/fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791655586; x=1792260386;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T2jVrgH55k3k3p8kJOIrXqSnnuHRHhh/LASrNcRGybI=;
        b=v2LyuUF65f+qouEmVXcPp6hxiwo/QO6LXb+5xt3190xYgN9Tf4lfOV+cFgNNgx8ylm
         /zYvX1KMKXk7ayB9FzvWIykeMyJyuMtrRxrhzYPFVCqTU3S61OklvadFZo9OKQPeJYUS
         Wfr4y6xJ8879SF7S9wtNJNQA8k6aYI1IPw/yrP9GYcMD8cxtWZ+LKFjHVRSIWOszQlt7
         foBYwlGaE6hBQ/ErU3yV4MwCsoZav6ZCL8+DHUESoOsTXJ+ojJ2uvtwIaF1mmg/eVrYm
         S4Jf7+R7/iqVuXV2CoUFVfoy6rnWi/Pwke8hCL6kUE67orL/E8G35tyzAWMqPELLCIP0
         +K4g==
X-Forwarded-Encrypted: i=1; AKwUvBzi6qxiYzaVDUbyYOKw/tPJEBnhhBamsqKXIYBdWrwV6IpJSEOzNBbmsQjTfhjdUatelNHf2wM2c8CkpJ04CQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIVrF/5t+jEIrah7dK4D0X2mblYrvqLQKzsMoQvmBl/v+vPKNs5
	Bs7lONFx59MCvenLK++gvRR68GC7QlUNmpM2HiI9TWvwl/6dCBM+q/b1
X-Gm-Gg: AYBFou26usKKGQzwXi1meahbxOLrPQI9cbSo8RWsSKs1qCOIXZhDyrC4uWaLMjF7cUc
	vZiieK5YHpmazDajj5vef1LG93jqXal9Fpl+eNDK4AtqAYy8QLHGqN6Qu820hS9xq18WfkpwXN8
	77jUG3tKzxNdfjArsBfI7IXm0h9G4YHQefR6vZzlvC2xRNHoyGhbSXHoH6Jn+Vc4Fi0Trc0/sew
	8X+xLvJAjGd963vXoGeFyd+rL8v65DKnq8gvzLEGgPoiHswXaQP7b0FGEHlcvgqrrfLFhsLaJz7
	SiqAeICNNipeI2oVJy3y8hm1+KqlLFx2GKYfyP40f1lLIB6reQ2bSfMtcALnzDHspZMTvxQOZ/Z
	zUDRfcb3jskh8RAFymE/VQnZvxknYA2AMJ0wpw9cSbV4K8eB87vpHuCizRZhg40a4+FNYrYJjwT
	RFBqRQICBIWH+aLikekton/2gugB3EGkkTV+wKwv1j6ejedE197+vh99i7SixVzoBCkB4gTov+g
	HgyCVCszO50PE48lc6DuKOGjDeEiacfNPkilD7BeBEG5UgvrOW8Jdg9YQVdBBUzybv8upIj/PuD
	Kw==
X-Received: by 2002:a05:600c:6215:b0:49f:ff32:8044 with SMTP id 5b1f17b1804b1-4a18e47a88fmr86024185e9.7.1791655585959;
        Sat, 10 Oct 2026 11:06:25 -0700 (PDT)
Received: from shift.daheim (p200300d5ff07190050f496fffe46beef.dip0.t-ipconnect.de. [2003:d5:ff07:1900:50f4:96ff:fe46:beef])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a190c49d5csm187867575e9.3.2026.10.10.11.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 11:06:25 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
	by shift.daheim with esmtp (Exim 4.100.1)
	(envelope-from <chunkeey@gmail.com>)
	id 1xFbSi-00000000WC6-0NL4;
	Sat, 10 Oct 2026 20:06:24 +0200
Message-ID: <f130759a-1987-4d12-a4dd-4bc652c66670@gmail.com>
Date: Sat, 10 Oct 2026 20:06:24 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] p54: validate firmware record lengths
To: Heyang Tan <thy15333007817@163.com>, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20261010033724.1924-1-thy15333007817@163.com>
Content-Language: de-DE
From: Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20261010033724.1924-1-thy15333007817@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi!

On 10/10/26 5:37 AM, Heyang Tan wrote:
> The p54 firmware parser accesses component ID and component version
> records without checking that their lengths cover the fields being read.
> A malformed record can therefore make the parser read past the record.
> 
> Validate the component ID and component version record lengths before
> accessing their data. The descriptor record is also checked against the
> shortest descriptor length found in the supported firmware images.
> 
> Reject descriptor values that underflow the RX offset or produce an empty
> RX range before updating the driver state.
> 
> Assisted-by: LLM Codex
> Tested-by: Christian Lamparter <chunkeey@gmail.com>
> Signed-off-by: Heyang Tan <thy15333007817@163.com>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Cc: stable@vger.kernel.org

Yes, I think this looks good.

Thank you and Cheers,
Christian

> ---
> Changes in v3:
> - Simplify the component ID length check to its one-word format.
> - Use a local bootrec_comp_ver pointer for version record access.
> - Express the 24-byte version minimum as six 32-bit words.
> 
>   drivers/net/wireless/intersil/p54/fwio.c | 45 ++++++++++++++++++++----
>   1 file changed, 39 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/intersil/p54/fwio.c b/drivers/net/wireless/intersil/p54/fwio.c
> index a3d9053f043c..b19d054441b8 100644
> --- a/drivers/net/wireless/intersil/p54/fwio.c
> +++ b/drivers/net/wireless/intersil/p54/fwio.c
> @@ -52,6 +52,12 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
>   		u32 code = le32_to_cpu(bootrec->code);
>   		switch (code) {
>   		case BR_CODE_COMPONENT_ID:
> +			if (len != 1) {
> +				wiphy_err(priv->hw->wiphy,
> +					  "firmware component ID has invalid length\n");
> +				return -EINVAL;
> +			}
> +
>   			priv->fw_interface = be32_to_cpup((__be32 *)
>   					     bootrec->data);
>   			switch (priv->fw_interface) {
> @@ -71,17 +77,44 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
>   				return -ENODEV;
>   			}
>   			break;
> -		case BR_CODE_COMPONENT_VERSION:
> +		case BR_CODE_COMPONENT_VERSION: {
> +			struct bootrec_comp_ver *desc =
> +				(struct bootrec_comp_ver *)bootrec->data;
> +
> +			if (len < 6) {
> +				wiphy_err(priv->hw->wiphy,
> +					  "firmware component version is too short\n");
> +				return -EINVAL;
> +			}
> +
>   			/* 24 bytes should be enough for all firmwares */
> -			if (strnlen((unsigned char *) bootrec->data, 24) < 24)
> -				fw_version = (unsigned char *) bootrec->data;
> +			if (strnlen(desc->fw_version, sizeof(desc->fw_version)) <
> +			    sizeof(desc->fw_version))
> +				fw_version = (unsigned char *)desc->fw_version;
>   			break;
> +		}
>   		case BR_CODE_DESCR: {
>   			struct bootrec_desc *desc =
>   				(struct bootrec_desc *)bootrec->data;
> -			priv->rx_start = le32_to_cpu(desc->rx_start);
> -			/* FIXME add sanity checking */
> -			priv->rx_end = le32_to_cpu(desc->rx_end) - 0x3500;
> +			u32 rx_start, rx_end;
> +
> +			/* 0xa is the shortest descriptor in supported firmware. */
> +			if (len < 0xa) {
> +				wiphy_err(priv->hw->wiphy,
> +					  "firmware descriptor is too short\n");
> +				return -EINVAL;
> +			}
> +
> +			rx_start = le32_to_cpu(desc->rx_start);
> +			rx_end = le32_to_cpu(desc->rx_end);
> +			if (rx_end < 0x3500 || rx_end - 0x3500 <= rx_start) {
> +				wiphy_err(priv->hw->wiphy,
> +					  "firmware descriptor has invalid RX range\n");
> +				return -EINVAL;
> +			}
> +
> +			priv->rx_start = rx_start;
> +			priv->rx_end = rx_end - 0x3500;
>   			priv->headroom = desc->headroom;
>   			priv->tailroom = desc->tailroom;
>   			priv->privacy_caps = desc->privacy_caps;

