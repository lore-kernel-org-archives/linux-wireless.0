Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4122D4CB23;
	Wed, 15 May 2024 07:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715759076; cv=none; b=uhOqbkFu3Xoi5IhsV/7NWXNZ3w9Ev26eBGRGhgKzDtQlW7dUfVLUipbW7/vmCMhR9TWCRVwrbJZP6Rix7PN5i7uVtzhj9OmItcKJQwo9VmQnDGm4YRFqxlqx4dV/Oj2I8TDOo/yu6KeNg7TPwgNHIdkczSVCrxM61zVW/Tp8dFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715759076; c=relaxed/simple;
	bh=bvTKlTmj4iTQSjVMzLXaiH2Pp4nfPaIIc8afPGUhn9g=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=MqhM2lK+69Frg6rDY/fDJ35M6RpFidoMtXphLXqxR3OC5YKm7KVGNf9Orx71ulRig80ZdG295m+X2ESa97Ng6I/VrY4J52DTjh1ovpbECMj0cqhdEC1ZDYWC6a1fRxr5/TvbWO3mFcZrXmmOw4SJ7roSyIbT5qUyXr2nX8SryZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sOe8MBb0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sOe8MBb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F155C116B1;
	Wed, 15 May 2024 07:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715759075;
	bh=bvTKlTmj4iTQSjVMzLXaiH2Pp4nfPaIIc8afPGUhn9g=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=sOe8MBb0GMi8B6RNArHYHnn2wmfj8iW153/Op1yqauk4dwL3qiShXk37OjJymaY2B
	 WmrRoXZup873BV0nAf7ZQ/H7SDXcuzuKT0Z3AshBZi3VRcxGRMQyG225K1gySZ8/QA
	 VTcs2IYcK6Wu+mFudlUkszb852+Ws3TcaZxeQg+d02OVf9cI6H/6gaxiVdL1S01iTC
	 qfT9+OiXmn6MJWgLekN4pSs/QoyO593MpHoINMWfTx6KbMUfbLAN5Y+xtWDrFm5buq
	 IYd7O33mYQHVb2pfhi0/uTIgqRRlvgz6PmN4LcYSbyPQptHEr8plLSmk/c6P8QuxF8
	 Gm8GpBFV3DP8A==
From: Kalle Valo <kvalo@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>,
  linux-kernel@vger.kernel.org,  linux-wireless@vger.kernel.org,  "Linux
 regression tracking (Thorsten Leemhuis)" <regressions@leemhuis.info>,
  linux-mediatek@lists.infradead.org,
  linux-arm-kernel@lists.infradead.org,  Felix Fietkau <nbd@nbd.name>,
  Lorenzo Bianconi <lorenzo@kernel.org>,  Ryder Lee
 <ryder.lee@mediatek.com>,  Shayne Chen <shayne.chen@mediatek.com>,  Sean
 Wang <sean.wang@mediatek.com>,  Matthias Brugger <matthias.bgg@gmail.com>,
  AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
  Peter Chiu <chui-hao.chiu@mediatek.com>,  StanleyYP Wang
 <StanleyYP.Wang@mediatek.com>,  Linux regressions mailing list
 <regressions@lists.linux.dev>
Subject: Re: [REGRESSION] MT7915E doesn't work any more with v6.9
References: <6061263.lOV4Wx5bFT@natalenko.name>
	<2341660.ElGaqSPkdT@natalenko.name>
	<60fe8df750a74331b8a54a76d55d5e8349ac46b4.camel@sipsolutions.net>
Date: Wed, 15 May 2024 10:44:30 +0300
In-Reply-To: <60fe8df750a74331b8a54a76d55d5e8349ac46b4.camel@sipsolutions.net>
	(Johannes Berg's message of "Wed, 15 May 2024 08:23:35 +0200")
Message-ID: <87zfsrcye9.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2024-05-15 at 00:51 +0200, Oleksandr Natalenko wrote:
>> Also /cc Johannes because of this commit:
>>=20
>> 6092077ad09ce wifi: mac80211: introduce 'channel request'
>>=20
>> On st=C5=99eda 15. kv=C4=9Btna 2024 0:43:40, SEL=C4=8C Oleksandr Natalen=
ko wrote:
>> > Hello Felix, Lorenzo et al.
>> >=20
>> > With v6.9 kernel the following card:
>> >=20
>> > 01:00.0 Unclassified device [0002]: MEDIATEK Corp. MT7915E 802.11ax PC=
I Express Wireless Network Adapter [14c3:7915]
>> >=20
>> > doesn't work any more. Upon mt7915e module insertion the following spl=
at happens:
>> >=20
>
> 6.9 didn't get commit 2f7cf3b61d85 ("wifi: mt76: mt7915: add missing
> chanctx ops")? Huh?

Ah, it will be only in v6.10-rc1. Oleksandr, can you try this commit:

https://git.kernel.org/linus/2f7cf3b61d85

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
