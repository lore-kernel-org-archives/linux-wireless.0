Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C643471434
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 20:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665327; cv=none; b=IHmCXlUaOMBMFZdyEpwfvRGa8BdHJuo2MVsuiuII8oq471OheC4aFTCxzX3Rr3D2e/C1a6CHj2DDAnjf6+U49yvm3P/1co2dKp1TmEen0F7qkFn/Y/HLdm15VJvNeGaa/iMFJYukyzWNbotCszYVjteMtNnC5bzpZ79qs5v3xrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665327; c=relaxed/simple;
	bh=8N0ardGHDYbJCcGaX3xW1f5fMzokeG11GJ2kjqZSrSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QKcoStp9uXrWS9tOu37hNwZGQENkKAby8Eaj3rrqWpKRPqmuCpf0NnTUXCyp9ooZKq8HoydWtmUeVqhe1R7ofWz8A5FXnNBoT83ezOrijexi7fEht4VGe2IiXRW6iG8+7dw1sFoPtj6DTDKIGd3SxmVe/3oDph6Z9efBZOga5JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mLuT6uHJ; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mLuT6uHJ"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5b2a22c52c1so2097122e87.3
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 13:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784665324; x=1785270124; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pOPCrZROWsDyG1I/C6+7cS4PhF0GrOUguiAaKjDuy/g=;
        b=mLuT6uHJOQxw91/GIAIKYeUIptYVEdbNyoFygwuHVM6cR7S8ke0rCmurZ/jkbYFiQ4
         8+e+ctwmpUkW5nZ58BehFtiKMaRTTgkEHqd2I2ucUDaONdOON7HwvZLnXIY973NcBQid
         z7GC/rtkuIfoRtsjar/PJFtTvS7ybRMWvRafPdAzufVrrWrm1/5t/6rfELayhyLaQtyQ
         cu3VyrYQJNsMzYNOKaLA91QHpWJFzP5YrN3npp8xWLB2t7qFK6l+vG1qkGzAOHzE7G9+
         WRi34IFy0j+QqYyxCKNS4EDE0iTY3ccDTN5q24WaKHo748SgtfryNI6RGBIPjffI3nE1
         0mJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784665324; x=1785270124;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pOPCrZROWsDyG1I/C6+7cS4PhF0GrOUguiAaKjDuy/g=;
        b=HPKeD2Kc1OMFSRGxOygTKxgUtCfc65LBbaE9R58nUbJtFHMwF/ZsaaAbkAR8/0JLcc
         /i8ZGHCzFDP2LdI3Dp8EgcrIuVKQgtSf/yFPFAsiom+rEr+f5ln5yEx6gsV7dHW4XRwl
         mVb6RzUpwEoILeNJpjTq6K97Ih7ktSRkK6u4/Y7Kc1hDPu1EJedM9ELp8RMcFinVHYOU
         wIS4D3NXnQhFa9lqdP63Cs6XyPKFF01MKQZNOMzrKoZz9a3n5Ac4S5Q79O5otHCXQLLz
         AWYHwZrEmo3naBnLF4OOkPI+IktdmGU6GOCJ71RRZd9wj+WCzyYn1S/2ASCIO/WWLxDh
         507Q==
X-Gm-Message-State: AOJu0YzVMy71U7KgKm/ltFfLfE0au3TzdZ1j3vAAiUWU69M39UPQAi8N
	k0RtomM0EYDuQzuvdDNnox9fBaLM15Ry2ugc2l7QFpzCAI+YDDGkorRq
X-Gm-Gg: AR+sD11fYRa0u204lY+DuG5lrUWNc3tg92gKr26pgxbsSjN4tiUyAV3PQzU/shSuNP6
	ayWfygXAw+MWoKnNPQKSCTQ3tTy25TEH26xyVnhh0UzzQ7n6KqUDNk8M7Yr90Ps7WVllv3Gdzx1
	K2jYw63xoa0jxwPLMlNNpBaYub9XwKJqUX/8kQqQgNXrnwXPVCLrj8opP44022JTgHzrhVG72/H
	HgZnmvQv62rrklg4shShZz6YRL4vtZiguQBDBE2yWCSp4tpi48YJyqNnG9vrTasIyZYZr1fWjIi
	AvPl6jEmrjzs3crWZ3KOisvi7wxSbXQblAsGyeg3gkwBr57Vuex6LrnMjj7aWgijrVcalXjb05O
	WVnw69ZjhZatykHRE4plKQUf7hwuJF8oOUtt/M0hK9+GW+OxjrODb7uieldwn0xKwHq2OGF8nU8
	ONDbK/4WFJ42imFuo4
X-Received: by 2002:a05:6512:3d03:b0:5b0:1852:936b with SMTP id 2adb3069b0e04-5b28fabeb58mr4630637e87.59.1784665324038;
        Tue, 21 Jul 2026 13:22:04 -0700 (PDT)
Received: from localhost (soda.int.kasm.eu. [2001:678:a5c:1202:7b92:9ac1:b9ef:5287])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2a9d30758sm99909e87.45.2026.07.21.13.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 13:22:03 -0700 (PDT)
Date: Tue, 21 Jul 2026 22:22:02 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
	"open list:ARM/Mediatek SoC support" <linux-kernel@vger.kernel.org>, 
	"moderated list:ARM/Mediatek SoC support" <linux-arm-kernel@lists.infradead.org>, 
	"moderated list:ARM/Mediatek SoC support" <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCHv2 wireless] wifi: mt76: fix MAC address for non OF pcie
 cards
Message-ID: <al_SAwiLmgT6D_tS@soda.int.kasm.eu>
References: <20260706232857.807044-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706232857.807044-1-rosenp@gmail.com>

Hi,

On 2026-07-06 16:28:57 -0700, Rosen Penev wrote:
> If seems the check for err is wrong as the proper macaddr gets written
> to from the EEPROM itself. Meaning checking err from of_get_mac_address is
> wrong as the proper macaddr has been written by this point.
> 
> Reported-by: Klara Modin <klarasmodin@gmail.com>
> Closes: https://lore.kernel.org/all/ajRmlyx_AEGybykL@soda.int.kasm.eu/
> Reported-by: Tobias Klausmann <klausman@schwarzvogel.de>
> Closes:
> https://lore.kernel.org/linux-wireless/30a90714-02d8-45f2-a7f1-4cfe0627d50b@skade.local/
> Fixes: 31ee1582717e ("wifi: mt76: fix of_get_mac_address error handling")
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> Tested-by: Tobias Klausmann <klausman@schwarzvogel.de>
> Tested-by: Klara Modin <klarasmodin@gmail.com>
> ---
>  v2: add extra tags and target wireless
>  drivers/net/wireless/mediatek/mt76/eeprom.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/eeprom.c b/drivers/net/wireless/mediatek/mt76/eeprom.c
> index b99d7452800f..afdb73661866 100644
> --- a/drivers/net/wireless/mediatek/mt76/eeprom.c
> +++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
> @@ -181,7 +181,7 @@ mt76_eeprom_override(struct mt76_phy *phy)
>  	if (err == -EPROBE_DEFER)
>  		return err;
>  
> -	if (err) {
> +	if (!is_valid_ether_addr(phy->macaddr)) {
>  		eth_random_addr(phy->macaddr);
>  		dev_info(dev->dev,
>  			 "Invalid MAC address, using random address %pM\n",
> -- 
> 2.55.0
> 

Ping. No one seems to have picked this up yet, but I suppose it is
holiday season.

Regards,
Klara Modin
