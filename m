Received: from mta1.migadu.com (out-58.mta1.migadu.com [95.215.58.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8052288D5
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 19:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787859146; cv=none; b=ru0b118gZjIFBaHGe3/FzIHFQXCQSkmesS/Lh/F30cXI2VPY8yW4RzuHsnnUA8Q9OuKNilx12AYJY8lrDOv8fvXZpFMkkubSoTEl5vDiiMX1UDp8jUnfCkAnwOyHSfpsBjKBjCpJuFM+29JVbg6osU8uNByCj7WlyRtAIObWZ1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787859146; c=relaxed/simple;
	bh=Dxb0QZdyGHiqp2xjGNxhfkA9d4hWZawABxo1RHuBiVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s50Mgg0iJXmnIQ3ySI/f+UzDNJ8ZX5D9dw3JIEGxiiHYbyI+gNVjfC+87jzD3IfZvwLCnILvBhqtLNczwVlL1F9pLCfdW1zOE0kQXfusQw2OPSwMwX/gFwG21plWDkIAc54AOphVFDWnJHfk0xAkuC5blU+qtEb4jFo63Kg3isc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=BqMr0QNO; arc=none smtp.client-ip=95.215.58.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="BqMr0QNO"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Dxb0QZdyGHiqp2xjGNxhfkA9d4hWZawABxo1RHuBiVU=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787859139; v=1; x=1788463939;
 b=BqMr0QNO2deM6IHmL0saVMCyFosklG1xubtArdegeVL1ViTnEj1CSYam3HlTEgIEfqdRMMid
 quw6D3Piv7pkxfnlCYt7UvVgJVpMbcHhqboWglrfwDkrhueN0J+Bo4x39+uVT1NPB9wpEL2MjqB
 /2KkbgjEf5158Fah//cvY5sWlOX8pqcoDR570cFZCSI90bMxkH2lITg/VQ8dLkbuibxzH7a3djW
 txbuDFybpiqslkj9jEKt18erkWQ7NY14sMbv2ECEZYvOX8qL5e8PhJSJ9vp6VTA+UbJpM+4vSmr
 x96j2wHE9jsQYfg8dmMI8uEVYmibn7AUZ8BneSEqxVhwA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4c9131677e2def36;
	Thu, 27 Aug 2026 19:32:09 +0000
X-Mizu-Trace-ID: 4c9131677e2def36
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Huy Nguyen Dinh Quang <huynguyendinhquang@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	nbd@nbd.name,
	lorenzo@kernel.org
Subject: Re: [PATCH RFC] wifi: mt76: mt792x: treat ACPI MTGS 0xff as no geo limit
Date: Thu, 27 Aug 2026 12:32:02 -0700
Message-ID: <20260827193202.12033-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827134820.2607530-1-huynguyendinhquang@gmail.com>
References: <20260827134820.2607530-1-huynguyendinhquang@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for measuring both bands.

There is another one of these from July with the same symptom and a
different cause. ASUS ROG laptop, geo table in the v2 shape but the
version byte says v1, so it gets read a byte early and the 5 GHz slot
comes out 0x00 rather than 0xff. I sent a fix for that one on the 11th:

  https://lore.kernel.org/linux-wireless/20260811232839.515463-1-lucid_duck@justthetip.ca/

Both are probably real. Your MTGS and MTCL bytes would settle which one
you have, and MTCL is the one that decides it, since every table gets
read with whatever version that one declares. If yours look like the
ASUS tables then the 0xff is wreckage from the misparse and the patch
above already covers you. Building it would answer the same question.

Two things on yours. Skipping the offset when the power byte is filler
wants a sentence saying why. And I would test the raw field rather than
the value after it has been through the signed conversion.

Devin

On Thu, Aug 27, 2026 at 8:48 PM Huy Nguyen Dinh Quang <huynguyendinhquang@gmail.com> wrote:

> Some OEM ACPI MTGS tables fill unused geo power/offset slots with
> 0xff. Windows treats that as "no cap". Linux assigned the u8 value
> to s8 and min()'d it, clamping every rate to about -1 dBm
> (txpower_sku tmac = 3).
>
> Skip geo capping when pwr is 0xff, and do not apply offset when it
> is 0xff.
>
> Tested on ASUS Vivobook S 14 M5406WA (MT7922, mt7921e):
> - 5 GHz: tmac 3 -> 25, TX ~40 Mbps -> 200-350 Mbps (80 MHz)
> - 2.4 GHz: tmac 30 after the change (channel 6, 20 MHz)
>
> Fixes: f965333e491e ("mt76: mt7921: introduce ACPI SAR support")
> Signed-off-by: Huy Nguyen Dinh Quang <huynguyendinhquang@gmail.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
> index 946dd79..fa539cd 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
> @@ -280,7 +280,15 @@ mt792x_asar_get_geo_pwr(struct mt792x_phy *phy,
>  		return dyn_power;
>
>  	geo_power = (band_pwr + idx)->pwr;
> -	dyn_power += (band_pwr + idx)->offset;
> +	/*
> +	 * ASUS (and some other OEM) ACPI MTGS tables fill unused geo
> +	 * slots with 0xFF. Windows treats that as "no cap". Linux took
> +	 * it as s8 -1 dBm and min()'d every rate down to ~3 dBm tmac.
> +	 */
> +	if ((u8)geo_power == 0xff)
> +		return dyn_power;
> +	if ((band_pwr + idx)->offset != 0xff)
> +		dyn_power += (band_pwr + idx)->offset;
>
>  	return min(geo_power, dyn_power);
>  }
> --
> 2.55.0
