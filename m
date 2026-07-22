Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4953BE659
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 09:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784712071; cv=none; b=HQop7Dmldn3AdelHcfEwiAg1SfteVuOTId1HL+IrSJaoXrVqZXu39DxnJDritZkRFvXrHp5tDIETP9bO4IeXDmM8wURd+WY9TMbtNRATVnG3wUjTwA2FUfK3Nb6B4p/CrN8sJCDE+nMp99wNMaWznR0jpIrGVy4JsgxFc+7vS5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784712071; c=relaxed/simple;
	bh=32rOwesH+gwjrg9sBYG4YxAQXufT8hneixwX2YjRdDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XNCNpNxFpnp3PZWKaViEM8iOn93dO4QHTY/qoQT4XeaMxzAJJSkP5jRX1W14a0e9t1AYf6X/JDRQ8LJX5iPrLDskbegn9Uc2HiIqCU6At6VDEr084AwI02RKPHUj8aRBEla9w5UcB8Aqb0Mk4cZe2tRtFFfX5T3IDiXUakwZWiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RDBIRUjO; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RDBIRUjO"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5b2a8e4c77eso1140640e87.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 02:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784712068; x=1785316868; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TzPYGGCsB/JnvYbiM7iDCIZYRT+Lm8x4cI/RrcLbCt0=;
        b=RDBIRUjO+FMmOIG0vm4tX/IBUNBSoy+iV2kRUFXTaWwR1RZxhTaRFq/ZG6ntknm78Z
         vBAOXmyTfpoCiS1O8sQeicv9TAnos7JbeNMjgYpa1Qw6GHmXxSFRgpAyciPVm97axY7w
         mID9M11jP1W8xMTbSymWoJLf++qfskLh2BG7EwVOlTLIE9p2ogOci+Deso01cyDN7iJj
         bCrI5pJoU+5FD9gDCIWOUciqcO8NJ7+5gfBLJ0SLA2v7iWLkbGEyPLwYq+k44EMNuOEZ
         U2pCmdTbJgxUGdw/zD5TiKBZYpfUNRLaR8qqcfR6lOP0cevhMM6fD/zj7L4ciIfRgwPV
         bp4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784712068; x=1785316868;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TzPYGGCsB/JnvYbiM7iDCIZYRT+Lm8x4cI/RrcLbCt0=;
        b=ENeX4AVvwA2kaSWx12fGmqNOzYcRsPmpTlRyiUH5mdJ/rboQMl6B5ouUJ5BQwNmJaB
         t7rTLxBd6Se2kGi7FQFuriYe0R/CoiG/Ebswa33eY5CJhX6EkwPGttX9ehN5OrhIHEkR
         W+aotwrFkdIOo7KKM9rLoEdKXLVmQsk25akVvbkwDbmCg+V74qUzivC+kkgUKE0k3Oqj
         VUo/QxVPC3BxqEzo985nisxk6KUjA1vS7oznONOexLzkXUC/sC0lRcqd2/PoYXoOkMv+
         C/f6byit1248JCdVwCCW+2xK+VJicIGQVYmEtKHyV95ldoe9XJQlJoV9bqO+AEeiaY3r
         +fyg==
X-Forwarded-Encrypted: i=1; AHgh+RqSoStyfsYcfZxIjYPXMl+EF8wWdq6zdx/V1jHSdr3v7PuVbzo1udQM8/4PRh6gUujdaltVfI5ecxjfGbFbOQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+ObkO2Xkvt1sMgj9LOmP/KXjty06K7x0fu7wkzH1G/exMxa/V
	RoIIz+fAT/FPir6co1LWHWTR51YkDPiXN3OE5jWg9bsynYaANB3bUcAq
X-Gm-Gg: AR+sD12o58pYdxWVaKcG3hW9GuwymmY30HdK5ZbIvwjAB+tfEY0UvAePbCyNY95glJx
	7C62euYpNIUKKcB2TeOmrrDsdKHY4U8cXTMuMNRbbUXPdzCm9/xiQ/SZkYgGXC/dqp2dC5RdHB2
	6vaK9QqKDxLqgbGSVtxHXarwZNmxMgr5iDw6L4sBEBocMNGxlTjDMb5nlhgeZkGn4D54t6/v6tW
	DnM8B7H4BKyXWKMGIPWDUQgMszd9Z7ByWPciZpW5HL7TQ6YdukY6QIZOx/LBAwfELzQs5AFCyuO
	AvWDoOjvX6g+q4sPJYhEDvlU1HLKbSP8a4Kt/LeXjcJtCv/RFSFu4T38lB90I8Tf38uNuP6mC6Y
	m1JNVLg6gp5DWKxnYlOUXMPH6x1Q+3SWghO3DgqEymQujvo5hfGywwaGAZqNaUKEAEFsZy2qiRP
	WtByERGGC6ltIciuyE
X-Received: by 2002:a05:6512:708:b0:5b0:1b0f:7a60 with SMTP id 2adb3069b0e04-5b28f9ba3e3mr2907126e87.32.1784712067687;
        Wed, 22 Jul 2026 02:21:07 -0700 (PDT)
Received: from localhost (soda.int.kasm.eu. [2001:678:a5c:1202:7b92:9ac1:b9ef:5287])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2a9d303dfsm380919e87.47.2026.07.22.02.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 02:21:07 -0700 (PDT)
Date: Wed, 22 Jul 2026 11:21:06 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Felix Fietkau <nbd@nbd.name>
Cc: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
	"open list:ARM/Mediatek SoC support" <linux-kernel@vger.kernel.org>, 
	"moderated list:ARM/Mediatek SoC support" <linux-arm-kernel@lists.infradead.org>, 
	"moderated list:ARM/Mediatek SoC support" <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCHv2 wireless] wifi: mt76: fix MAC address for non OF pcie
 cards
Message-ID: <amCLcgSap5ShOiUT@soda.int.kasm.eu>
References: <20260706232857.807044-1-rosenp@gmail.com>
 <al_SAwiLmgT6D_tS@soda.int.kasm.eu>
 <a0c1178f-86e5-4193-9d9c-767abbdee076@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0c1178f-86e5-4193-9d9c-767abbdee076@nbd.name>

On 2026-07-22 08:40:56 +0200, Felix Fietkau wrote:
> Hi,
> 
> On 21.07.26 22:22, Klara Modin wrote:
> > On 2026-07-06 16:28:57 -0700, Rosen Penev wrote:
> > > If seems the check for err is wrong as the proper macaddr gets written
> > > to from the EEPROM itself. Meaning checking err from of_get_mac_address is
> > > wrong as the proper macaddr has been written by this point.
> > > 
> > > Reported-by: Klara Modin <klarasmodin@gmail.com>
> > > Closes: https://lore.kernel.org/all/ajRmlyx_AEGybykL@soda.int.kasm.eu/
> > > Reported-by: Tobias Klausmann <klausman@schwarzvogel.de>
> > > Closes:
> > > https://lore.kernel.org/linux-wireless/30a90714-02d8-45f2-a7f1-4cfe0627d50b@skade.local/
> > > Fixes: 31ee1582717e ("wifi: mt76: fix of_get_mac_address error handling")
> > > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> > > Tested-by: Tobias Klausmann <klausman@schwarzvogel.de>
> > > Tested-by: Klara Modin <klarasmodin@gmail.com>
> > > ---
> > >  v2: add extra tags and target wireless
> > >  drivers/net/wireless/mediatek/mt76/eeprom.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/wireless/mediatek/mt76/eeprom.c b/drivers/net/wireless/mediatek/mt76/eeprom.c
> > > index b99d7452800f..afdb73661866 100644
> > > --- a/drivers/net/wireless/mediatek/mt76/eeprom.c
> > > +++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
> > > @@ -181,7 +181,7 @@ mt76_eeprom_override(struct mt76_phy *phy)
> > >  	if (err == -EPROBE_DEFER)
> > >  		return err;
> > > -	if (err) {
> > > +	if (!is_valid_ether_addr(phy->macaddr)) {
> > >  		eth_random_addr(phy->macaddr);
> > >  		dev_info(dev->dev,
> > >  			 "Invalid MAC address, using random address %pM\n",
> > > -- 
> > > 2.55.0
> > > 
> > 
> > Ping. No one seems to have picked this up yet, but I suppose it is
> > holiday season.
> It's in the mt76-fixes pull request that I just sent.
> 
> - Felix

Thanks!
