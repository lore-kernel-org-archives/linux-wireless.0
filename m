Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.194
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793085932;
	b=RByHnnYkkw8RFwkYDlJwTv3lrs7hAQLPBXHiF2zl+e3zSdHMok9Z9yJxmtm9zPRfU9Fd
	 zxOZp+YfdjqzPEV3PX0njFPl+Bogu7whlAD/xEKGGGC57Ys8In/QPz/JmRorXtOiRZhh0
	 JR6xKeBzmbi3j2ihYO7vMfIn3NWT0RtMoMNhygj1lsJtohtYhYnZi/jbBxIDP3U+xxkIf
	 4Ypu2VotjNULIJVHJrci5jcLb7hV2KB7gEHSdQVjCRLlBBEIl0iyeSzg73MIXymPFC4D5
	 nKf6nRXqShlg8Yxg/PjInxXLIfK8YR7l6OcM44GVLiGDJcwK3Ooo+cuw1ZySv2FBrfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085932;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:
	 In-Reply-To:References;
	bh=CtKam3sSyIGLgg9QQ+MQwapz2ZSQkS/wL4dGVqGAiJM=;
	b=A/sqr4moqoYZhUNsjI7Z9DgM6E1aCZ1N4/b4pWTA1LuDkAp2CRGaqMjqz+aZLr3s2HCl
	 LkWv2HKX0h2w8SyyIvHNt5R2fp7nACZyWpoC/Xzgr5iKTn1JRmY8zMAsq0kNakTS4Mekj
	 sp8vF3ufMq8D6WjdvcRb5z4Sey46kNV/euhvb/RfrPAAShEBucH/ap1VkXkZhLVyWrzwJ
	 ADQ+JlqsE9SEIqwoShs4egn/QPHvixi7zbwKeI2K0/44QTvdb/2OwP1BSmr1WYn2plOUS
	 cdkcXtgsBule5W5CkEh/SE6MrOj0op92VlCEvTbljDdu8PHvHJujq4xMekscLe7HcBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=X9c+5Zyl;
	arc=none smtp.remote-ip=91.218.175.194
Received: from mta0.migadu.com (out-194.mta0.migadu.com [91.218.175.194])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA2C606A31A
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 07:25:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ACA2C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=X9c+5Zyl
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=/rny5X7TU9diJBxFZTUgnFMxD3SZtOisXApj/KuHmaE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793085929; v=1; x=1793690729;
 b=X9c+5Zylc5hyQLBiCnS8D90RuEQAteXAWA+3pdnfN320gtl9ZDkvBubWkAFV59AHAfyw75Mk
 sUG/VXSL07Ah3q5zE1RbquvnM7cgSYC5mK/r7bw5SGhUxtFYlCVrzh6UMBCt9MyUlYnsV5RBVfo
 dcsZr9iVtobF1YK3YSNvcncM=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7bf874dff0951ae0;
	Tue, 27 Oct 2026 07:25:17 +0000
X-Mizu-Trace-ID: 7bf874dff0951ae0
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Tue, 27 Oct 2026 07:25:16 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <fc98b0719bad6282083133041e80136a7215359f@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next 0/5] wifi: rtw88: pci: Support an older design,
 like RTL8821AE/RTL8812AE
To: "Ping-Ke Shih" <pkshih@realtek.com>, "Bitterblue Smith"
 <rtl8821cerfe2@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <4c0eae7568334475b3b9a57e50f5c912@realtek.com>
References: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
 <4c0eae7568334475b3b9a57e50f5c912@realtek.com>

Hi Ping-Ke,

October 27, 2026 at 2:52 AM, "Ping-Ke Shih" <pkshih@realtek.com> wrote:


>=20
>=20Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:
>=20
>=20>=20
>=20> This series extends rtw88_pci to support an older design, like
> >  RTL8821AE, RTL8812AE, RTL8723BE, etc.
> >=20
>=20The older design is own-bit ring, and the new is read/write index rin=
g
> with buffer descriptor. Can we use 'own-bit' instead of 'old' as the fi=
le
> name ?

I agree with this name proposition.

>=20
>=20>=20
>=20> After this, another ~20 small patches can enable support for RTL882=
1AE
> >  and RTL8812AE.
> >=20
>=20Will you plan to implement RTL8723BE (you listed it above) in rtw88?
>=20

As=20far as I know Bitterblue hasn't commited to implementing RTL8723BE
in rtw88. That development is being done by WillyHB on github. This
series is requirement for future implementation of RTL8723BE in rtw88.

> >=20
>=20> Then rtl8821ae can be deleted from rtlwifi.
> >=20
>=20Luka asked me to merge AP mode for RTL8723BS, because the AP mode of =
staging
> rtl8723bs can work well. If you decide to delete it from rtlwifi, pleas=
e
> make sure all features are implemented before deleting. However, I can'=
t
> say what the exactly all features are.=20
>=20
> [1] https://lore.kernel.org/linux-wireless/d6af5cebfa1a46e2bc2da6626347=
66d7@realtek.com/T/#maa2a3e897d5d488d0219399f9555d88b9ef6504f
>=20
>=20>=20
>=20> rtw88 is not without problems, but in my experience it's more relia=
ble
> >  with these two chips. In the 6-8 months I used this code, I observed
> >  these problems with rtw88:
> >=20=20
>=20>  * The top speed is a bit lower: ~220 Mbps instead of ~300 Mbps. In=
 the
> >  case of TX, the difference is due to the EDCA parameters. rtw88 uses
> >  the ones from mac80211 (rtw_conf_tx()), whereas rtlwifi uses its own
> >  "turbo" values when there are not too many non-BE packets
> >  (rtl8821ae_dm_check_edca_turbo()). Not sure why the RX speed is
> >  lower.
> >=20
>=20Maybe you can try to compare them by VO or VI packets?
>=20
>=20>=20
>=20> * RTL8821AE RX speed gets limited to 70-100 Mbps sometimes. If I wa=
tch
> >  a Youtube video with Bluetooth headphones for 10 minutes and then
> >  switch to another wifi adapter while the video is playing, leaving
> >  the RTL8821AE's wifi side idle, usually within 20 minutes it will
> >  start to raise IMR_RDU when it reaches the end of the RX ring and
> >  goes back to the beginning.
> >=20
>=20Does it still happen without Bluetooth? IIRC the rtw88 BT-coexistence=
=20
>=20mainly supports RTL8822BE and RTL8822CE. I believe the algorithm can
> share with other chips, but control registers or additional settings mi=
ght
> be missing.
>=20
>=20>=20
>=20> It uses RX descriptor number 511, then number 0, then it doesn't
> >  want to use number 1 for "a while". It raises IMR_RDU once or twice,
> >  and only then it moves on to number 1, 2...
> >=20=20
>=20>  Usually when it raises IMR_RDU there are 510 or 511 RX descriptors
> >  available (out of 512), so it has no excuse.
> >=20=20
>=20>  Once it has raised IMR_RDU the RX speed doesn't exceed 70-100 Mbps
> >  anymore.
> >=20
>=20If driver can receive packets on time, how does it raise ISR_RDU?=20
>=20Is RX interrupt triggered on time?
>=20
>=20>=20
>=20> Powering off and on again, which happens a lot when the wifi
> >  interface is idle, doesn't help.
> >=20=20
>=20>  The only thing that seems to help is reloading the driver, but eve=
n
> >  that may not always work.
> >=20
>=20I think reloading the driver and interface idle are very similar (alm=
ost
> the same). No idea why they have different results.=20

Maybe=20firmware reload?

>=20
>=20>=20
>=20> Switching to another wifi adapter while playing some video is the
> >  most reliable way to trigger the problem, but it can also happen
> >  randomly, it just takes many hours.
> >=20
>=20Thanks for your effort.=20
>=20
> Ping-Ke
>

Best regards,
Luka Gejak
