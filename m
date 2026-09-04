Received: from sphereful.davidgow.net (sphereful.davidgow.net [203.29.242.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D4A2749C1;
	Fri,  4 Sep 2026 07:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.29.242.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788507057; cv=none; b=R8qfMPvtqw1qeFcSThOEQzB+D5kR6kADqOoCYyDLW2yhKG+kPhhehHhNdDPoaYMQ8v+Ua18+rV/MjbqY2h5wLo2PR7gTj7EqR4b/jPahWB3IvGvBW1szBXndOEYf+LWVC5C3vVBa5tXTo3ujT09rPXxLM0TU8c++7+4lkYdgBy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788507057; c=relaxed/simple;
	bh=63RTdAchA4e5/HG54Wog5dnkc1w5rE+eIUmtjEyIBvI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U/1nie/7T/8hIIkIz10OEBCLmkbLq0zv0M6boCsI9x63sOdH0rWT3hY+lkKVxF/T1ibXU5qZ4pOZRcR+Q5/s+r9j9dh5LAgYk8THO2xjxhq9BT6F8e2K1wcm6tybc+Tct9UW7RU/50MkhEsTi+AWpnaD7MMlraMQAFMyi8m1JrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net; spf=pass smtp.mailfrom=davidgow.net; arc=none smtp.client-ip=203.29.242.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=davidgow.net
Received: by sphereful.davidgow.net (Postfix, from userid 119)
	id 844CF20013A; Fri,  4 Sep 2026 15:30:43 +0800 (AWST)
X-Spam-Level: 
Received: from [IPV6:2001:8003:8802:7000::41b] (unknown [IPv6:2001:8003:8802:7000::41b])
	by sphereful.davidgow.net (Postfix) with ESMTPSA id 6205E2000F9;
	Fri,  4 Sep 2026 15:30:40 +0800 (AWST)
Message-ID: <bcf1ee9b-97e5-43f9-81eb-67ac6a0a98dc@davidgow.net>
Date: Fri, 4 Sep 2026 15:30:37 +0800
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
Content-Language: en-US
From: David Gow <david@davidgow.net>
In-Reply-To: <20260825181712.28548-1-lucid_duck@justthetip.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 26/08/2026 à 02:17, Devin Wittmayer a écrit :
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
>    BUG: kernel NULL pointer dereference, address: 0000000000000004
>    RIP: 0010:mt792x_init_acpi_sar_power
>    Call Trace:
>     mt7921_set_tx_sar_pwr
>     mt7921_mcu_regd_update
>     mt7921_regd_update
>     mt7921_run_firmware
>     mt7921e_mcu_init
>     mt7921_init_work
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

I can also confirm that this fixes the same NULL pointer dereference in 
7.3-rc1 here, also on a Framework 13 (Ryzen 7040):

BUG: kernel NULL pointer dereference, address: 0000000000000004
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 0 P4D 0
Oops: Oops: 0000 [#1] SMP NOPTI
CPU: 10 UID: 0 PID: 149 Comm: kworker/10:1 Tainted: G            E 
7.3.0-rc1-sulix+ #15 PREEMPT(full)  b7f05cce278af6607ac2dcae2fd785935bbe0dc6
Hardware name: Framework Laptop 13 (AMD Ryzen 7040Series)/FRANMDCP07, 
BIOS 03.05 03/29/2024
Workqueue: events mt7921_init_work [mt7921_common]
RIP: 0010:mt792x_init_acpi_sar_power+0x40/0x1ed [mt792x_lib]
(...)


Tested-by: David Gow <david@davidgow.net>

Thanks,
-- David


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
>   drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
> index 946dd7956e4a..b468051fbe68 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
> @@ -323,7 +323,8 @@ int mt792x_init_acpi_sar_power(struct mt792x_phy *phy, bool set_default)
>   	const struct cfg80211_sar_capa *capa = phy->mt76->hw->wiphy->sar_capa;
>   	int i;
>   
> -	if (!phy->acpisar || !((struct mt792x_acpi_sar *)phy->acpisar)->dyn)
> +	if (!capa || !phy->acpisar ||
> +	    !((struct mt792x_acpi_sar *)phy->acpisar)->dyn)
>   		return 0;
>   
>   	/* When ACPI SAR enabled in HW, we should apply rules for .frp

