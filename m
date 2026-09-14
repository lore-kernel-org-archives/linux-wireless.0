Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [185.244.194.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D7833D6F0;
	Mon, 14 Sep 2026 04:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.244.194.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789360563; cv=none; b=Lw9b4BwpT8vXqh2D8SncjR+XlE3oTj7vGipGcjiW63SkNdPwAevlqLJvn1sWA513Pmdg+UuRI8Q8ujIMmuCJ3JZ6m77pD//ZfcE8qI+mYsZAR8yNYvRbHfibVtShyVaJaFGQmI/256W9YoqBAyXUTCE44OqgsGDkCY1G7/K/CrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789360563; c=relaxed/simple;
	bh=l/3VpX+XI0mzcW52NigVjmYMhh6INWYXFx0JGEuAyv8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DsxXDY+4LhdIkfc5ZH22RR8v3a6wuHquS6diWuIqj1JUD5GRekKcQCnkKjXFYo0Ajk6ygnHK8j2P87M/TDTQT2fS/VeP2T7a1Wz0srAc72GULz9JsyJUhRbfrVvhLsrdhaoW0blOXsgHm/mH3sBwRLjesq3UDUAzc/tcNnjktKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=WRhGlbO9; arc=none smtp.client-ip=185.244.194.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="WRhGlbO9"
Received: from relay01-mors.netcup.net (localhost [127.0.0.1])
	by relay01-mors.netcup.net (Postfix) with ESMTPS id 4hjslz4GJDz9KSt;
	Mon, 14 Sep 2026 06:35:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1789360559;
	bh=l/3VpX+XI0mzcW52NigVjmYMhh6INWYXFx0JGEuAyv8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WRhGlbO9qY9QfRs4S606PpeWRg0XE7+ZPlCpSm1AU2rrDD5Lfo5WXz+VzPr3RpSY8
	 G65jTa5AkmCnWvKBcxnLMDOnuIZ1sNmb2EIyJS5BehmfpL11Ug4cOFP6FtxsT2fq0X
	 QpU4+vu48tLXRSb6hTeHRDG+xGOAPXgnpUoHY6XpjyhQ33qc6kJMf/uwf58dT0i3mz
	 VyoAu1Nu9YvNLucsFZhFN9JTbaTp6K7yv38nFzpNdqWwRqEG4mDQcqIOX7MynLTsFH
	 2WvSpKOTuM9mi2YhW5yr8WOuTHI71/tEarn9mvNKHyu6ZCKBDkIEW+bKADBTaNqXz9
	 24qwmHiqI4wIw==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by relay01-mors.netcup.net (Postfix) with ESMTPS id 4hjslz3Y6bz7wsn;
	Mon, 14 Sep 2026 06:35:59 +0200 (CEST)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4hjslx4hd8z8svW;
	Mon, 14 Sep 2026 06:35:57 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 805E05F9D2;
	Mon, 14 Sep 2026 06:35:56 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <2fd03569-f1c4-4c02-97ed-c74f4cd7f809@leemhuis.info>
Date: Mon, 14 Sep 2026 06:35:56 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless] wifi: mt76: mt792x: fix NULL dereference in ACPI
 SAR init during probe
To: Devin Wittmayer <lucid_duck@justthetip.ca>, Felix Fietkau <nbd@nbd.name>,
 Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Klara Modin <klarasmodin@gmail.com>,
 Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>, JB Tsai <jb.tsai@mediatek.com>,
 Sean Wang <sean.wang@mediatek.com>, Ryder Lee <ryder.lee@mediatek.com>,
 Shayne Chen <shayne.chen@mediatek.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 regressions@lists.linux.dev
References: <20260825181712.28548-1-lucid_duck@justthetip.ca>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: <20260825181712.28548-1-lucid_duck@justthetip.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <178936055709.725840.16914483602007956628@mxe9fb.netcup.net>
X-NC-CID: DBseGpMhWIEgVtQ5BXljnzJ0Jmciv99+44qwUxKmBeXs+d6quD4=

On 8/25/26 20:17, Devin Wittmayer wrote:
> Some laptops carry a MediaTek power table in their firmware, and the
> driver reads it to set a transmit limit for each frequency range. It
> only fills in the ranges themselves when it registers the device.
> 
> The startup step that does this existed already, but it never programmed
> anything. These two commits made it run a regulatory update instead,
> which sets the limits on the way through, long before registration. So on
> a machine that has the table the driver reads through an empty pointer
> and the interface never appears:

For the record: Linus pulled this directly from the list into mainline
yesterday after I pointed to this patch in a small regression report. I
did that, as I had seen multiple people reporting a regression who
confirmed that this patch fixed things for them.

Bypassing subsystems like this has obvious downsides and risks; hence,
if that got something on the wrong track, please speak up -- or ideally
send patches to set things straight again in mainline.

https://git.kernel.org/torvalds/c/7825de3f75d184612d77655669a04ea0da252c17
/ 7825de3f75d184 ("wifi: mt76: mt792x: fix NULL dereference in ACPI SAR
init during probe") [v7.3-rc3]

Ciao, Thorsten

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

