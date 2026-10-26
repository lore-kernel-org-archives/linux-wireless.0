Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793011911;
	b=V7AVDQPeQQKssYJ7adEcN8GWUWDfL0Yi+X040sB6aGsoeKbmSog0NBBeKH0zzycVI36d
	 joO2cHOuCRI34/PWQDdA39yB2wDGFV2TCGTsWsnfPR/EftCnKlTm9UKwV7Sho8+T/0IGo
	 kNRUkHSt8ZZ3nS2+MGpUu4sQ87D6RC5olZD2E1zILHtTMvzfoUr285yC0ECWVdxRV5f0H
	 LIlZfQQLoi4V3e2g8mkcwPaw42ylEsd6jegBIb+R6/7cxyMLhO4K1ndBhrnpGe3pdwrPq
	 abPT+K4rxlsOtMt7EwKmQZ/ie+V/gaqeJv4scSu0yrr12vq651jgQHqww1wEkura5pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793011911;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=EBf3Sy+5DcnC0QRUJ+VDMuCVNHbnBlvEfTw0fhN6JSU=;
	b=eWoNv+JyICy0USKU8cXHbGasNSE74ljylGKzsnPerlvEMh52llzlpcYrSoSZDpw1vf7P
	 YsmwkSnYoxLtggBgW/N4EjBLZo3PuZwJlp35Tizw34tcP2SpQGvq5EKQvaOFMnh/IIo75
	 8rWSSZ48k6JRaN6ofkPsuS7AGRs1prE1e1+aWE81PQXlk7d/J/5z8kgFq5IY/EBNmDv8h
	 ffRdE38zqPKy+aU5G3NfHtHdLiybUGUZlJk9QtLSnAcushgoSvpnsE6albd/GPJ7v3ayA
	 2Jl5g/OOPlLhu2TarCYtyGr7aKIrKVy4qPFA0JAUEfLgocWahM0A/ps8zhqhsGMchPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XzVAHkr4;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194F0606A320
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 10:51:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 194F0606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XzVAHkr4
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48441a2ba1bso1739390f8f.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 03:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793011909; x=1793616709; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EBf3Sy+5DcnC0QRUJ+VDMuCVNHbnBlvEfTw0fhN6JSU=;
        b=XzVAHkr4KWhp4SR2WwzWQxCcMQaShtXQTlQewihtNNAK1hZbhAGGWkFVNIWtDj5tBg
         /gD5ANjWnHbwfvhif89hJqLigAQUenx1D+8TiKsF1DHrhMImwKFR6pYxmgg6erew40sf
         aI/3V8zvt2t1A5d5wSFIBBoz8mzW+ZGPW8iUitC+gOiNnGDHSYsesinfxorfPqqzsURJ
         OsAm2v3Iib9vHikarRa3/4A09l9F81lyojFEgbR7Ym83DdBlp+HCylhTV6PUEdzCSPWP
         mhR7EbbrdhAWzLqKssx3G8ny9998zK4hW8qpOIR9ljdEPGITQhnR7z4rK1YfPLG9dHMV
         alyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793011909; x=1793616709;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EBf3Sy+5DcnC0QRUJ+VDMuCVNHbnBlvEfTw0fhN6JSU=;
        b=FDP3kjFdHR6qXTRxVF5VyamyEVgA+4i4NmOhtkvCcT6o+Y7SbIPeyK5RIghMiSo+sy
         jLaHk5YDZKcpSUyM2W7o7RXbBIE85vciY56OgWXz1mFdpaNcOaBmcIzGjpPFc1BQmGk6
         54e5h6Quke0PTuTgQ1b1Bt6E4JvP47rSYims2SO0eDGOTJkAiLPqaZpGYrwc6uDzUGyW
         OSZ3ieo1pxYEj+4ig2Nezym543QlPwp8LjQkfBN0AVVETmeExCMZtgpc4PF5cOSGDppy
         BWy8llS6E/fKTIVRS4D0RTPVsXNgY8c3pQDiNkoAdnDhXtdHC73cAnS+2H9hUdZrWZx1
         BXig==
X-Forwarded-Encrypted: i=1; AKwUvBwJ1gBJ+hEKkHvDPUsI7GJ5j+JAjAbHBagZCdqM9mTyWTnhwGbZETWLJjjAKxbu3sV3JyUMQt1ungWipc9Zww==@vger.kernel.org
X-Gm-Message-State: AFq9FYLyEi13b/qiO+RH4AkYNr5s3RpZAo/99PVHGqxk+mKq+/AtV5+5
	YRJyDky4+A55Mn3BxzTI6u/ShKpmmd/Gd2QS33J24AubJjpIGp07kkUY
X-Gm-Gg: AYBFou2UCfPB6iqv39/mQHwvh3LAk1STvek1dP/7gmZpxZSw+rP0Y0UvMTEmJNF3gzL
	IDxymXhxh4Q51PSq3yKxlX4hnwwtwdVCI7S6Oie8XETVJLBq/aQyiuL98W63ziRyNW3idpXcRVV
	Fj9CGZ2//atz+Otb5uKlHgnqLW0Y6eSkiIvBkV6t/PZKJSUtBlg8k8nlTd4T4nE0yMyDh2u7ttl
	BUcCbd0+/CCsN00eIR+10P0d136ciR6vXFc4GEGs+CogWWBkZxr7qvQ5NzoNP0BEomjSPM4fQRO
	V/ZDRQKvX7mK1hjL3vyHkW4j1fy/ubYHyjDc5A8GqNrG+PjEuAMZ06RCSlnIPDVexEgqSLv4c4L
	N7V/DVGwiv58qX23bYreImg2ZRJln/tK9fKsafqcnbeJocwI5kZqERzLDeVqKCWYwjOLsjoN0a9
	kNphDsLuEzpHC8416x6YklFAZHEYd78XJClMz+21wkKvWHRZRaxl3DgE4tmUNagWUzl9DbxZtyc
	h8gMOC9b975tHJfDQLu//suWBmEHgd9R++IZdyd04eWvWo/61XX4lzijaA2ghekIn93k5/hhA9U
	AdiDn7xHuXBzuNAycrK8It9iEPH7UAei5lMIPWIk74dDF6ZuPLV/CfM=
X-Received: by 2002:a05:6000:2999:20b0:488:8ab9:f74c with SMTP id ffacd0b85a97d-48e3eb2b9a3mr8914050f8f.3.1793011909237;
        Mon, 26 Oct 2026 03:51:49 -0700 (PDT)
Received: from ernest.hoecke-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch. [83.173.201.248])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd3c32sm16077045f8f.47.2026.10.26.03.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 03:51:48 -0700 (PDT)
Date: Mon, 26 Oct 2026 11:51:47 +0100
From: Ernest Van Hoecke <ernestvanhoecke@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, 
	Andrew LaMarche <andrewjlamarche@gmail.com>, linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
	ath12k@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Ernest Van Hoecke <ernest.vanhoecke@toradex.com>
Subject: Re: [PATCH v2] dt-bindings: wireless: ath12k: allow calibration
 variant for WCN7850
Message-ID: <xrszqxg7ketpbjtafssgyjdgygwuhqx7p2ln3phrabcinrqn7c@vor67puwvmyd>
References: <20260907-ath12k-calibration-variant-v2-1-1a9d6c47dade@toradex.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907-ath12k-calibration-variant-v2-1-1a9d6c47dade@toradex.com>

On Mon, Sep 07, 2026 at 04:17:20PM +0200, Ernest Van Hoecke wrote:
> From: Ernest Van Hoecke <ernest.vanhoecke@toradex.com>
> 
> qcom,calibration-variant is the generic Qualcomm Wi-Fi DT property for
> selecting board-specific calibration data when the device identity alone
> is ambiguous.
> 
> Commit 06cca100ad08 ("wifi: ath12k: support calibration-variant from
> device tree") implemented support for this property in the ath12k
> driver.
> 
> WCN7850 can be used in systems where the PCI device ID and machine
> compatible are identical across product variants, or across regions with
> different regulations. For regulatory changes, the hardware description
> does not change, but the vendor-provided calibration data can differ. In
> that case neither the PCI identity nor the machine compatible can
> identify the required data, so DT needs an explicit calibration variant.
> 
> The ath10k, ath11k and ath12k WSI bindings already allow this generic
> property for the same class of board-data selection. Allow it for
> WCN7850 PCIe devices as well.
> 
> Signed-off-by: Ernest Van Hoecke <ernest.vanhoecke@toradex.com>
> ---
> Changes in v2:
> - Rebased
> - Updated commit message
> - Link to v1: https://lore.kernel.org/r/20260701-ath12k-calibration-variant-v1-1-d3eddaabf026@toradex.com
> ---
>  Documentation/devicetree/bindings/net/wireless/qcom,ath12k.yaml | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath12k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath12k.yaml
> index dc68dd59988f..cf3e1fd99c12 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath12k.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath12k.yaml
> @@ -54,6 +54,12 @@ properties:
>    vddpcie1p8-supply:
>      description: VDD_PCIE_1P8 supply regulator handle
>  
> +  qcom,calibration-variant:
> +    $ref: /schemas/types.yaml#/definitions/string
> +    description:
> +      String to uniquely identify variant of the calibration data for designs
> +      with colliding bus and device ids
> +
>  required:
>    - compatible
>    - reg
> 
> ---
> base-commit: 1d8e73163ef933624341075f576e2f36ef9133f7
> change-id: 20260701-ath12k-calibration-variant-b7850f7ffd7c
> 
> Best regards,
> -- 
> Ernest Van Hoecke <ernest.vanhoecke@toradex.com>
> 

Hi,

Just a friendly ping on this since this since 06cca100ad08 ("wifi:
ath12k: support calibration-variant from device tree") has been in the
tree for a while now.

Kind regards,
Ernest

