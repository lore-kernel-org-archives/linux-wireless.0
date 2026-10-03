Received: from mail-106103.protonmail.ch (mail-106103.protonmail.ch [79.135.106.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8563A1696;
	Sat,  3 Oct 2026 04:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791003370; cv=none; b=atGVKI0XTfUhQigwg8P5uGiWkTCLn4Kam4gmyV1iGMw9xkg36djfUSuqkJ01/eUfwieaOxYNVckiAV69+lWLkVdpXkOGKxjRVM4hb3g9jPlAvkY6kzXbgLs+BU02POi+cGG7sJbou1U3aCOwCC1jFdGB758gJ4169ICzuoR2ak0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791003370; c=relaxed/simple;
	bh=niTaM0Ytht8ZXyLM0MwX4xCOD3K0NhKmQijvDp7U30k=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HXd9M1qT2RtbCoNz9izXhxextIqWWsopRVzBojd2/aMf+i0koovKPuEU4hd09pELrze7Fzuj0DiywdzZgdaqbua3ZpHUQjMA47hBUB006s1GiOAZh22y7ii8Tt6nKncfjBivFhT7gM6cpJug8x7XvcRvVfxiw78B8XMI8Qun1os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=oC1P9QLp; arc=none smtp.client-ip=79.135.106.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="oC1P9QLp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1791003357; x=1791262557;
	bh=niTaM0Ytht8ZXyLM0MwX4xCOD3K0NhKmQijvDp7U30k=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=oC1P9QLpD3Zd2SCU4d1B25i9piQKAaoKWQ/oxpO+Rg2RvxKPonfEs9V+XbWl01k6/
	 j7PQ+pActwi2ReECCamLXcYG2jv6gVN9PCXfGy+P7NLFi4xxqTjW2j0M2ncmEgA4NP
	 QJLRPP2tllXA6GbNRZ3V+9kYm+Ln/jUYD11cc40hAzE3xNT3+/9p/STZQ/KQtS0xFA
	 uR677LGFlGGrvF/iEfWmTlHci8/TueBVMUJUXnZ0QK18477XjDr/kCCaMwR1CgSZJm
	 LpPYXi9mN+XNHjW4gVtgDf3+5XlfOSJ4e4quQaRX6zV9sw+S+CYXTW1byyKMYtZ6iz
	 mYc1bPZciPW1A==
Date: Sat, 03 Oct 2026 04:55:53 +0000
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
From: untilscour <untilscour@protonmail.com>
Cc: Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, untilscour@protonmail.com
Subject: Re: [PATCH v5] wifi: mt76: mt7996: add thermal zone device registration
Message-ID: <9ZfPhagV0EDMq7if1ebyvRXfPIHZvPjlbWFuqTK1OuoqpcNj1AQCFwYy8vTQf8w8De3Vx3pFCydfiEOcAmx7ZqC9q5lrBqoepqoip8FyuaE=@protonmail.com>
In-Reply-To: <20261003-mt7996-thermal-zone-v5-1-d7cf8820d187@protonmail.com>
References: <20261003-mt7996-thermal-zone-v5-1-d7cf8820d187@protonmail.com>
Feedback-ID: 184418679:user:proton
X-Pm-Message-ID: 98bac8e5a6c23d3e373790a3d61e63916fe1e3dd
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

Please ignore this v5 patch - I misunderstood the thermal sysfs API.

Sorry for the noise.

However, the v4 patch [1],[2] still remains for consideration.

Best regards,
Ryan

[1]: https://patch.msgid.link/20260811-mt7996-thermal-zone-v4-1-9ca715a8ae1=
f@protonmail.com
[2]: https://patchwork.kernel.org/project/linux-wireless/patch/20260811-mt7=
996-thermal-zone-v4-1-9ca715a8ae1f@protonmail.com/
