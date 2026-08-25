Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBC948CD75
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 18:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787682443; cv=none; b=gFpQdfoHV/dRc/zQrWTZpT7KUo5Yq5EPZ6WSH2C/CFKSxj1VnSCE2FwgQ7lYXUi3eZD1QAt8apGIDH1ZvNGkgaVura5nmYvC7qfVIb9DMMzTxQl90MKpboXUk4uSyfDGcHrt/NgxdgmkKex0/lpKSvxIZAhE9JVDsVvhqBc2PGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787682443; c=relaxed/simple;
	bh=jyNY2JkAvWQwrHbS+NgO1le733UPx2Ae4Z9gCQskd7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X9AaA9prhuDGxWHa5PcvVBULVoh6C0BHWrlpRPKoX0qioNGHJfwFOr0lYnJp36qq43ba8EPpiHz5r6XP5H3+DueQZdwBvehDubnHE24Ln091c/RKd4eySb+xujmsl2CezWVrp3dCYFKS2+c+hCBxTMtJp16L8InAaqmVZfudmEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TTvMLACc; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TTvMLACc"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-39fa5e3a428so1100391fa.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 11:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787682437; x=1788287237; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cLhl7vMzATDfLTJ4Lrym/q2o4NDrnz3WBA6CQS/z/Wg=;
        b=TTvMLACc0Yk0tJDf9pI5MrU95b13apaaMnn25jVqWpon8vB8PBXvwQD+dgOsLVwqgm
         rM2Y73ElJCh6FtEsb+GZdyh50cE9+Jp4v2M0zwwaXZkCQ8FMIpKrLA2fHx8eT90mLSVC
         GbDg6dH3JLPiuXysxYpuNwRQir0ji7B8F1hfDEZuUsUHO1c5QPrP7eDW9nKeES9aKF/H
         lbBKzUgZsiC/CtPX4hGDPA8pM8gWpDq1/+ZdksyjouZxZyc8wHYYDWjnMC1QjvPJM4p7
         6tL4hHLzuMMuh9OhWJMs9WvdsaiGAHaHCfWu7TQ7ihpH3VWgBuRFFQ7+TuDKZa6t3Zpk
         NVEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787682437; x=1788287237;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cLhl7vMzATDfLTJ4Lrym/q2o4NDrnz3WBA6CQS/z/Wg=;
        b=Yi5gk+whBVQPk+iIA7W1LoNbRgwEizj0OUmX30IhJjMbZHvL5uFInX5F4j0IMGKRg2
         6FchBuVJ6mbHdDLG8upRKT+P5BhcF2kT5FSsGICMUfgEP03l96LVnMv8Dxp6KGDNjfbH
         lfs4QO/pZpwzkS4j/KHjeMycthbqa++hxdBW4nw9pIcHoreNm8dwZu+A1feQoGQazVd+
         nUS50ZA6bt6KKEJ2PUgU7uBcOaIxaHcaONZfjb7g55ZgHD2mClxOue3oKnGHGE82Bp3H
         UxaRVKtg+6C1T+c0kawaC6SwR/JMPE52u+Q1ZoRrl0bohjBd6b3LG1/VhFOv/XhSsbep
         uBKA==
X-Forwarded-Encrypted: i=1; AHgh+RoVwntB0BXEz9glmypl2Y8st/4uKbqyi5E+iMVDqT9VD5v+aGbM0wYpofZeiCkFp7VrjyjCeFbbr0Nn4zJDmQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mCHq/0OxI2xqPwJLmA4so+JEtGV3u3RQqB1PPosfsio5viNAc2
	Y9ogOTLKQd3Sp8VOJyNosHIc1OIFpZLOfqt7hIZfHjZNZ5O8Mp5gUQZp
X-Gm-Gg: AR+sD12yCDClATez1Q/yz+Ci6WbGfos8C3RV1PPO/UNr1yNgSHK1lJnAlzspSXB9jqP
	lMHB628HE7pm2katS3m9lxSjq9y6I9eR9OYt/2kOeGzA1R7pZapgjaHEn1qx6Tiuwuhlq/BBkKn
	kWKGmgxruP2Ww0Z/S7yuJcXvj/DhQRt3fZfjGaXGB+gVK2HG3nK0uzjC3Dw/Plz7Yd2q0y1/YvP
	KK0vkPCsVZtEMsXgMQFeX2p4Sma6pxK4TiiTzlM1uyYhp88APp0jIGdknr4632xaHzlH0sQCg8x
	gpSgrwzIg4x1gCM1sYE66T5hRE4A2TeU/cfOiVnsCITIYdUZuCgzxfkH7/6AyiSEIrhJjXwhuqK
	oaVoSLfIYPn7AOyREfPVMT0CJ7C8UIsnd3lVFqK+hI0akgNJORqTtNB9Ckq3GIDWub6sQep3bDf
	QClWrQCLb1MiTWLQ2aQ6NpQUqVAgOShV3nGvEDZZBYdRJ9lhBHMK3T4bGza6ksQ6yVs6J7I8sIH
	sk=
X-Received: by 2002:a05:651c:54a:b0:3a1:4530:fb2 with SMTP id 38308e7fff4ca-3a1edab181bmr15138391fa.5.1787682436763;
        Tue, 25 Aug 2026 11:27:16 -0700 (PDT)
Received: from localhost (soda.int.kasm.eu. [2001:678:a5c:1202:7b92:9ac1:b9ef:5287])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a1fd13a484sm393461fa.38.2026.08.25.11.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 11:27:16 -0700 (PDT)
Date: Tue, 25 Aug 2026 20:27:15 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, 
	Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>, JB Tsai <jb.tsai@mediatek.com>, 
	Sean Wang <sean.wang@mediatek.com>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, linux-wireless@vger.kernel.org, 
	linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [PATCH wireless] wifi: mt76: mt792x: fix NULL dereference in
 ACPI SAR init during probe
Message-ID: <ao3dyqWJ3nf3rMMW@soda.int.kasm.eu>
References: <20260825181712.28548-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825181712.28548-1-lucid_duck@justthetip.ca>

On 2026-08-25 11:17:12 -0700, Devin Wittmayer wrote:
> Some laptops carry a MediaTek power table in their firmware, and the
> driver reads it to set a transmit limit for each frequency range. It
> only fills in the ranges themselves when it registers the device.
> 
> The startup step that does this existed already, but it never programmed
> anything. These two commits made it run a regulatory update instead,
> which sets the limits on the way through, long before registration. So on
> a machine that has the table the driver reads through an empty pointer
> and the interface never appears:
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000004
>   RIP: 0010:mt792x_init_acpi_sar_power
>   Call Trace:
>    mt7921_set_tx_sar_pwr
>    mt7921_mcu_regd_update
>    mt7921_regd_update
>    mt7921_run_firmware
>    mt7921e_mcu_init
>    mt7921_init_work
> 
> Skip it when the ranges are missing. They are applied again once the
> device is up, which is where they came from before.
> 
> Reported-by: Klara Modin <klarasmodin@gmail.com>
> Closes: https://lore.kernel.org/linux-wireless/aoyxqHYvSuaBeubf@soda.int.kasm.eu/
> Fixes: 9b80bd9cab40 ("wifi: mt76: mt7921: add regulatory wiphy self manager support")
> Fixes: e9f3f1cc133f ("wifi: mt76: mt7925: add regulatory wiphy self manager support")
> Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
> ---
> 
> Reproduced on both chips before sending, an MT7922 and an MT7925, and the
> fix clears both. Neither machine here ships a vendor power table, so I
> supplied one through an ACPI override in the initrd. It also wants recent
> firmware. The June builds do not turn on self-managed regulatory and
> nothing happens; the builds now in linux-firmware do, and then it dies
> exactly as reported with no interface at all. Patched, both come up and
> scan normally, and the injected limits still show through in the power
> table afterwards, so the skip does not lose them.
> 
> With that table still in place and the fix absent, backing out the mt7921
> commit on its own also boots clean, so the table is not what causes this.
> 

Thanks for the quick fix!

Regards,
Tested-by: Klara Modin <klarasmodin@gmail.com>

>  drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
> index 946dd7956e4a..b468051fbe68 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
> @@ -323,7 +323,8 @@ int mt792x_init_acpi_sar_power(struct mt792x_phy *phy, bool set_default)
>  	const struct cfg80211_sar_capa *capa = phy->mt76->hw->wiphy->sar_capa;
>  	int i;
>  
> -	if (!phy->acpisar || !((struct mt792x_acpi_sar *)phy->acpisar)->dyn)
> +	if (!capa || !phy->acpisar ||
> +	    !((struct mt792x_acpi_sar *)phy->acpisar)->dyn)
>  		return 0;
>  
>  	/* When ACPI SAR enabled in HW, we should apply rules for .frp
> -- 
> 2.55.0
> 
