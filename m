Received: from smtpdh18-1.aruba.it (smtpdh18-1.aruba.it [62.149.155.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4527E56261A
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 20:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790712998; cv=none; b=NyZ+wzWAFxrJusNJxCT9jkpj5YZu35qQrjb7JA0pSQeqQ30G6yEzmavPLpLGkMNpCUgDPyIv/lABQI5zGN00lsW1zbMaMeSq696yWJYIAba2QDmYNb0YzRF6dI7bV88i22+8Yc1X/UHV/GYbvQx/2QL6c69nrs/0oXTDX0zTQDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790712998; c=relaxed/simple;
	bh=/qrgO6k+8ZErwEGk1+4A8p5yGj0VnNeeV0nEjm0TzKc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GlwM83E75P+TTag7Ti0HhlzEsL50GvGb2RaSjr2D8NaSHkeKOVGTuGrmmZrSQdUmxL2RI3LrdiSSEzQAqCY5OWOCqr6xcElqk59lfWPaVg2Car/a5OxQRn2waIJS1FybY5nR/TlZm3FR+lFZ63PEwK5SjqgxQNnOIFtzzhZtKs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=BAGGDXQS; arc=none smtp.client-ip=62.149.155.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="BAGGDXQS"
Received: from localhost ([79.19.61.120])
	by Aruba SMTP with ESMTPSA
	id BeCXxQzwGYPtrBeCaxG1ea; Tue, 29 Sep 2026 22:13:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1790712804; bh=/qrgO6k+8ZErwEGk1+4A8p5yGj0VnNeeV0nEjm0TzKc=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=BAGGDXQS0OU5GO05T5nrHDbquOict97NrDdk3NAtVk1H4KoFHnT5Pfji4PiYK8unI
	 G3SYGfjqkHirtGddSxtezJQuUOJ9fkUFnjuH+no+Uq/4JG86MIwVnaVKAHzZ1FDDg3
	 /gKeVADROG7U2RECw7myIX7Re3qlTTAWzJpoHLrdO+BJdEL6lqR5aNNB4lTPK7iWKh
	 r6K15Mk4jM7lPyI4Axq6Y6VSZXj7LQeixpDzrWlyHAHXxHpMABrEZ0NqlEKJqP+/NH
	 8A46+SxhnPt3qt8PdIkQY0rpXGCFswMAQ2Bv1Px0bxSgowryydDsMPnvpe9EggC/it
	 JBktmMf3Pv/Qw==
Date: Tue, 29 Sep 2026 22:13:21 +0200
From: Alessio Ferri <alessio.ferri@mythread.it>
To: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM4360 AC-PHY support for b43 =?utf-8?Q?=E2=80=94?=
 reverse-engineered, seeking guidance on a clean path upstream
Message-ID: <20260929221321.000023a7@mythread.it>
In-Reply-To: <OG0AU4A6pMu865qvxpXQjF7NvEP6p2bwR_IZRaLxONsn_3Gdxm00PiOOaGuWbYy-AmxhLGRyz29ZPtUKzDwsKJk_UjTLAU1bctgCzdWlNlE=@proton.me>
References: <rOzY3WnW4q5L1osv7iagU81dLGldzZEsu3EqHxmH4d7Z4vxubBYvRNT0vsrbr8n-CUSEYyXxGFE3h9PHLHgePjm3_rMK_B_0m5loTpyxX-M=@proton.me>
	<20260929081403.6076a6da@barney>
	<20260929093405.79d9f4ec@DELL-MOBILE03.ad.smart.it>
	<hCBGuqVmDlV3Y7f2t6L8DtnoyBNbC8KghHXm0fZCHLDLrtfaoYw9e0UcCCsQHHK1X4TBz0DuvSL4zmAx_dVS3q54BZ0JZXtjXXNnuSAFtyo=@proton.me>
	<20260929100544.343ce6d2@DELL-MOBILE03.ad.smart.it>
	<d6tVX7HBAW4Qnebx5Enj79edWG_LVmnRT0bjhcfv9bb1h0cewrTEDHK-VVoSy0NZcMzv3FB8OVEyTFNgA7rs_zaplEfiLXdwcCqhYDeonMo=@proton.me>
	<20260929105859.364ea71b@DELL-MOBILE03.ad.smart.it>
	<oYmDL00YinKfSdWHxkjmqPRGHWmeA_0SCR6tpafsgCvGyqYAEKuCt0kg7w_C47be5hm7IwFsxRnulMhvPFJEXQNDaDPgZNzMIQ0vfRKnOLw=@proton.me>
	<20260929113109.2c561844@DELL-MOBILE03.ad.smart.it>
	<OG0AU4A6pMu865qvxpXQjF7NvEP6p2bwR_IZRaLxONsn_3Gdxm00PiOOaGuWbYy-AmxhLGRyz29ZPtUKzDwsKJk_UjTLAU1bctgCzdWlNlE=@proton.me>
X-Mailer: Claws Mail 3.21.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-CMAE-Envelope: MS4xfPrvVn96Oxxw/iowOCKtpz4nOtvxaE8GW60fcCjb3UIsdvufJARl6Epxk7oiDt8LuHgB9fj/3/UCRjJorcXoxr41wHoStlAf6lxQL3yPxw4eW/SwGfku
 blS6OBHPMZ2UP2liOmHvsAvzZsX/YZ5zQppYRNbMMM94/z9o6fGCjtyDtLQYkxY/tIFMu8PeU2vKZI1wBQ0NcfB+qUHkiKQUBFLwtFgWfQL79wRq1suUDTVO
 icaI0QS8e2MYtP8a0MsYR/lU0HwLjyjHN3ekahs03dNe8ETjjev4WIrxi35xl5yk

Il giorno Tue, 29 Sep 2026 14:45:41 +0000
"andreas.wendleder" <andreas.wendleder@proton.me> ha scritto:

> > If you are using an older ucode, probably my driver don't work on
> > your device because it interact with newer ucode, can you look for
> > mac behaviour diff from yours? Maybe we can merge the handling with
> > some ifs, repo here: https://github.com/aleferri/b43-ac-wip =20
>=20
>  I'm on ucode42.fw (D11 core rev 42), firmware 832.127 (2014-09-19);
> my driver checks SHM UCODEREV against =E2=89=A40x128. I don't have a capt=
ured
> rev number to compare against yours off-hand =E2=80=94 what ucode rev/date
> does your driver target? I've mapped a decent chunk of the real MAC
> event loop (dispatcher + wait points) and the watchdog tick (SHM
> 0x158, ~1.024s) by decompiling wl, so a diff is doable if I know what
> to diff against. Game for merging with #ifdefs if the divergence is
> small.


i have firmware 938.1502, October 2017, as the "target", but i ran a
similarity scan between 938.1502 ucode and 938.10005 and there are no
changes except for the version. The 938.1201 likewise is also very
similar, as far as the similarity tool is concerned. While they are all
very different from the 784.2 from my D Link dsl 3580L router.
So at this point there are 3 version of ucode for AC:
- 784.2 is the original one, dated 2012
- 832.127 is the broadcom sta for linux one
- 938.1xxx is the most recent one

You seems to have decoded fairly well the rx/tx path, i have instead
understood quite a lot of the phy/radio level, you could try to
incorporate my work for the phy and test if you it can improve your own
results. I will take your decoding of the mac handling to test 784.2
and 938.1xxx ucodes.=20

If you send me your raw bits of srom and opt with a full trace from wl
unloaded to wl loaded, bss up and running, i can tell you if there are
still blindspots in my phy code or if you should be good to go.
