Received: from smtpweb147.aruba.it (smtpweb147.aruba.it [62.149.158.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC285A79B
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 06:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.158.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790834740; cv=none; b=CgKR75bVp8upTuqXrH1OlT7wUJd2lPAcxCZX0QpL/FLM4HzV+Kax5O6U+yLabOE34y/sVM3CFrP7wYToWewArOkhLX6nfQb2/eNmO1ZC3tPXhzeUxVm2xw2XmSZBWw3KdO0JoaYzgyKN1wWtc0kvBxLA2XJ3kYgKjVKjWVHSiBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790834740; c=relaxed/simple;
	bh=wWRU4eHK3PVax3ymH78GWBxhKixk/D0CiifSXcxtzt4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MX0a9UVfeLRmefpT8dkjZF+lW7jIxXIW0x/1IGA4bC/TDO8ZkFipKelDJtU0vEfnGdWWvOMsq43iUSi8JJ/84pYh5R5t/NbfaB2wzYMSUmJ4XIpjeAL7x2rhGd590QQoTALGz4JcBDl/otm0j9JkGsXI0YEXOL+HQU8d5HAvXKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=cfyOgne9; arc=none smtp.client-ip=62.149.158.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="cfyOgne9"
Received: from localhost ([79.19.61.120])
	by Aruba SMTP with ESMTPSA
	id C9sAxg0TsvPyqC9sAxZQAO; Thu, 01 Oct 2026 08:02:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1790834546; bh=wWRU4eHK3PVax3ymH78GWBxhKixk/D0CiifSXcxtzt4=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=cfyOgne9p0woRxuXIU8VkSSIXRqwjF7YJ64u96dwCV5GhAAVzGJ3FT3G2fRoLAy5i
	 Tag1oHxb4nZFRNZLkoWdMB8qBwX9N3x+EUhXFlIuhJDas4lABUG5If0zO0Edlh/vqk
	 ANQS8/RHpG5KR20nBOuWhQl7NMvw4ooX5iqAL15JTllLXtjYQWkFaxUs1+/tlqgLW1
	 bkAb0n/d1rH3q+0R90kdr0TPh0e7CmrycdKapq1zU0y00LT0lB/oQvZwEVVZFMavqK
	 3dS15hT0hHDwgGpDT+J2UJppohzA6sNvRc4LoaQ5TEK2suPzUaCzBz6C8MaX+c7YLa
	 2lVzdh1vmcNPw==
Date: Thu, 1 Oct 2026 08:02:25 +0200
From: Alessio Ferri <alessio.ferri@mythread.it>
To: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM4360 AC-PHY support for b43 =?utf-8?Q?=E2=80=94?=
 reverse-engineered, seeking guidance on a clean path upstream
Message-ID: <20261001080225.000011d9@mythread.it>
In-Reply-To: <e3-qmDjhrTX2hFaCfmyNZHcixISRArPiYm-26_-33mbTBdryG2n375GF-6ewiqoXzodKocGBPYO2l3kWmr2wlJ9X8GK9-F3lUqmhnDP_TXI=@proton.me>
References: <rOzY3WnW4q5L1osv7iagU81dLGldzZEsu3EqHxmH4d7Z4vxubBYvRNT0vsrbr8n-CUSEYyXxGFE3h9PHLHgePjm3_rMK_B_0m5loTpyxX-M=@proton.me>
	<hCBGuqVmDlV3Y7f2t6L8DtnoyBNbC8KghHXm0fZCHLDLrtfaoYw9e0UcCCsQHHK1X4TBz0DuvSL4zmAx_dVS3q54BZ0JZXtjXXNnuSAFtyo=@proton.me>
	<20260929100544.343ce6d2@DELL-MOBILE03.ad.smart.it>
	<d6tVX7HBAW4Qnebx5Enj79edWG_LVmnRT0bjhcfv9bb1h0cewrTEDHK-VVoSy0NZcMzv3FB8OVEyTFNgA7rs_zaplEfiLXdwcCqhYDeonMo=@proton.me>
	<20260929105859.364ea71b@DELL-MOBILE03.ad.smart.it>
	<oYmDL00YinKfSdWHxkjmqPRGHWmeA_0SCR6tpafsgCvGyqYAEKuCt0kg7w_C47be5hm7IwFsxRnulMhvPFJEXQNDaDPgZNzMIQ0vfRKnOLw=@proton.me>
	<20260929113109.2c561844@DELL-MOBILE03.ad.smart.it>
	<OG0AU4A6pMu865qvxpXQjF7NvEP6p2bwR_IZRaLxONsn_3Gdxm00PiOOaGuWbYy-AmxhLGRyz29ZPtUKzDwsKJk_UjTLAU1bctgCzdWlNlE=@proton.me>
	<20260929221321.000023a7@mythread.it>
	<e3-qmDjhrTX2hFaCfmyNZHcixISRArPiYm-26_-33mbTBdryG2n375GF-6ewiqoXzodKocGBPYO2l3kWmr2wlJ9X8GK9-F3lUqmhnDP_TXI=@proton.me>
X-Mailer: Claws Mail 3.21.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-CMAE-Envelope: MS4xfPSng8mybR4KRCqQYhZPZMnjWfHJSW8maGmmOhqWAEZ7MTqLoruKSM9mInKc4LdL3je/nXIaFMsdg/XD+eWyopcAOJfC+IJyP0jYFcqUgc0+YEQGEP2j
 PcXO2Gkqf1DaNvTQEd+l6y8z4hrIDSXr1zsgAfu6fSwgLuNoPDPRFu+k7f/1J/tX7dUMNK8oEDi3VI7yzf9FXYzXYPrcT3zEHCJCLTmlVA03be+vG4bAYZY+
 6xtG8tGUGTUm7LvJ5s/Toi0iV3PsLQ4z52XDSSBcso1pA+9xc/7WZCD2tRXCnHpK

Il giorno Thu, 01 Oct 2026 01:31:24 +0000
"andreas.wendleder" <andreas.wendleder@proton.me> ha scritto:

> Hi Alessio,
>=20
> Thanks again, and sorry for the delay. I've gone through your repo
> and am working with it. Attached are the SROM dump and the wl traces
> you asked for, then one concrete question.
>=20
> Attached (see README.txt inside for formats and conditions):
>  - the raw SROM words of this MacBookAir6,1 (BCM4360, core rev 42,
> radio 2069 rev=A04), a rev 11 image, plus the ChipCommon/PMU state with
> our port loaded;
>  - four wl 6.30.223.271 traces, from "unloaded" to BSS up on 2.4 GHz
> and on 5 GHz, plus one with traffic, and an ifdown/ifup;
>  - MAC register snapshots under wl and under our port.
>=20
> I have no OTP dump. Our port never reads it and I can't reload wl
> here without a reboot. If you can tell me the ChipCommon OTP read
> sequence for this chip, I'll dump it.

Thank you!

>=20
> State. Our port associates and passes traffic on 2.4 GHz (ch11), but
> only about 20-30% of fresh inits come up clean. In the other cases
> the PHY holds carrier sense (phydebug 0x5 =3D CRS|TXF) with a TX frame
> posted, MAC suspend failed follows, and the ucode sits in NAP (PSM PC
> 0x000f, the end of its scheduler loop). It wakes only about every
> 1-2.5 s. A clean init stays clean for a long time.
>=20
> Already tried from your repo, all with no effect on that rate: TX
> FIFO geometry (we already match 0019), object-address read-back
> (0020), MAC setup before PHY plus TSF fraction 0x6614b, the
> PSM_PHY_HDR/FGC pairing, PMU (PLL words already 0x0c31/0x100e,
> max_res_mask forced to 0x7ff), and the CRS threshold forced to 68 and
> 120. A post-init register snapshot of 50 inits shows no static PHY or
> radio difference between good and bad ones, so it looks like a
> runtime wake problem, not an init-state one.
>=20
> Question. In your bus captures, what does the stock driver do to keep
> or wake the ucode when it posts TX frames, beyond the single DMA
> pointer write? In our wl trace that write is the only MMIO at a TX
> post, and MACCTL goes 0x44020403 during suspend/enable windows and
> back to 0x40020403 between them. Do you see anything similar, or
> another register (IHR event mask at 0x40, an AWAKE/HWPS rule, a
> periodic wake) that we don't?

WL program the awake bit during every mac suspension to prevent the
ucode from entering sleep. B43 don't do it by default, you have to
patch it.

>=20
> Also, if you can share it, the MacBookAir6,1 bus capture of wl 6.30
> from your README would be very useful, since it's our exact hardware.

That is one of your early trace, in fact, i picked up when you wrote to
b43. If you want to see something new, you are better off with T5E
trace, it is the same 6.30 driver on different hardware

> Your PHY code is 5 GHz only so far. Is 2.4 GHz planned?

Yes, since you are giving me a complete 2.4Ghz trace, now i can look on
it. Most logic should be already there, but some fixes maybe be
needed.

>=20
> Thanks,
> Andreas

