Received: from mail-24425.protonmail.ch (mail-24425.protonmail.ch [109.224.244.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D6F49A3C3
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 12:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856389; cv=none; b=dXFaOksiv+eII9YpV1l/vAmdU7Q9Gma4tcJVi9xbFcFOqtERwH9nBEWjGn29ZowrKCEk6AXWY+wv4Qqv4znYR2I7LHkyao2TZqY/uSGoiSjVzJL4yS7sq4dlMkx/JIiLUirh7lpXPhOSi719zQoHygJkNBDYlNtBrWBnvqxULho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856389; c=relaxed/simple;
	bh=yCNvhw0ESgJSzLHMeRdALP7byAYkz+hVEMOqeWIptR8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XbWFOrue/bz8dGc8HbPnc5SHbDmLB47JXxY0Jnbj4HlBaI5JmSmY5RRVEsSSqPoPMzdG1LdGGm25kPzUSzud/Ifphfnvv1LsLiIwV5O3yyzN8rcedL+91fBLZB+CTIvwD8eXDVfz1OGFILrbzIGMQ3VfN+YfsUhb5zfxolOkW4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=WreAFIcl; arc=none smtp.client-ip=109.224.244.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="WreAFIcl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=pkwlngjezrc55cpgk2kl6o2nye.protonmail2; t=1790856369;
	x=1791115569; bh=yCNvhw0ESgJSzLHMeRdALP7byAYkz+hVEMOqeWIptR8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=WreAFIcl+KJXRYeohDn0Nh1PVT8Oxqi5sXz4X5uIEVz8lMsJ4W823KFavDCbwuPqd
	 BrM5CXUcgQM7ciiW+KMJmCQdbUETo4jxxiJSfRzXpsW1P4XMKZfoZ4/90o6kcPNvIf
	 rig11QZZIRWRBAMprKf2lPH+V150zMw/S3lDq7rVv13awIVjnhAQ+WO2OLAffOebQF
	 ziiLwNK8jdDefs67y7sJt4jiGuicFRbEPOuFry0ewxwDK3KhCQiPxhH1GUZfg5llms
	 Rp/9Q7DNzCdY/73xKMRzMn74Kj/Ulja6xpVcHGwtAS4S2gwOX3gBTPuHTJdTMqDjg5
	 zsiePUSxIyPMw==
Date: Thu, 01 Oct 2026 12:06:05 +0000
To: Alessio Ferri <alessio.ferri@mythread.it>
From: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>, "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: =?utf-8?Q?AW:_Re:_BCM4360_AC-PHY_support_for_b43_=E2=80=94_reverse-engineered,_seeking_guidance_on_a_clean_path_upstream?=
Message-ID: <BGzX01_Xw0eP0rtUaqPn6IyCeg06zqkSQ8qKQoE38fN4Pzu_QmUjvB-pw5RuEdVn3hXqB3UAMap8WSTwRa8i6Zfg8XUmkhUEBavoBwppNmM=@proton.me>
In-Reply-To: <20261001080225.000011d9@mythread.it>
References: <rOzY3WnW4q5L1osv7iagU81dLGldzZEsu3EqHxmH4d7Z4vxubBYvRNT0vsrbr8n-CUSEYyXxGFE3h9PHLHgePjm3_rMK_B_0m5loTpyxX-M=@proton.me> <d6tVX7HBAW4Qnebx5Enj79edWG_LVmnRT0bjhcfv9bb1h0cewrTEDHK-VVoSy0NZcMzv3FB8OVEyTFNgA7rs_zaplEfiLXdwcCqhYDeonMo=@proton.me> <20260929105859.364ea71b@DELL-MOBILE03.ad.smart.it> <oYmDL00YinKfSdWHxkjmqPRGHWmeA_0SCR6tpafsgCvGyqYAEKuCt0kg7w_C47be5hm7IwFsxRnulMhvPFJEXQNDaDPgZNzMIQ0vfRKnOLw=@proton.me> <20260929113109.2c561844@DELL-MOBILE03.ad.smart.it> <OG0AU4A6pMu865qvxpXQjF7NvEP6p2bwR_IZRaLxONsn_3Gdxm00PiOOaGuWbYy-AmxhLGRyz29ZPtUKzDwsKJk_UjTLAU1bctgCzdWlNlE=@proton.me> <20260929221321.000023a7@mythread.it> <e3-qmDjhrTX2hFaCfmyNZHcixISRArPiYm-26_-33mbTBdryG2n375GF-6ewiqoXzodKocGBPYO2l3kWmr2wlJ9X8GK9-F3lUqmhnDP_TXI=@proton.me> <20261001080225.000011d9@mythread.it>
Feedback-ID: 189422222:user:proton
X-Pm-Message-ID: 21d4d098aa2330498780e262331bf02ad6f12de0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Alessio,

Thanks for the 2.4 GHz trace work. Short status, then the questions.

Status: b43 now runs as the daily connection on my MacBookAir6,1 (BCM4360, =
core rev 42, radio 2069 rev 4). The 2.4 GHz station works with legacy rates=
 and a TX status fix. Upload is about 18 Mbit/s and download about 10.

The open problem: only about 21% of fresh inits can transmit. The state is =
fixed at init. In a bad init the PHY holds CRS|TXF and every TX ends in a P=
HY transmission error, so auth frames are never ACKed. A reload wrapper ret=
ries until an init connects, which takes 2-5 tries. I've ruled out temperat=
ure, DMA, ASPM, PLL lock, clocks, TX core mask, TX power control, the CRS t=
hreshold and the MAC setup order.

I've updated the clean-room spec (=C2=A710 covers this) and can send it if =
it's useful.

Questions:

Do you have a bus-level trace (wl-mmio-trap) of a 2.4 GHz cold init and fir=
st transmit on a BCM4360 (agcombo or TG789vac), including the calibration p=
hase? I'd diff it against mine at register level.
Can your harness score our driver's register-write sequence against your ca=
ptures? That would show where we diverge without hardware tests.
Does stock wl ever give you a "bad init" on any of your boards (the PHY can=
not transmit until the next reset)? That would tell us whether the cause is=
 in our init or in the chip.

If your 2.4 GHz support lands, I'll test it on this laptop right away.

Thanks,
Andreas
