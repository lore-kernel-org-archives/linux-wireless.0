Received: from mta0.migadu.com (out-213.mta0.migadu.com [91.218.175.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070E037DABD
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 09:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791277505; cv=none; b=HMiBTe53vvZwE+1iB8PMhSQBjlY5Mui7cjCv0tgPDkksmI/Ccc58Q7OQ2O+2ELA6q3UXJRX4RXJO9cRSj3w02ER9M3djEZWdRE1pskogX87lebiszHSPQLb9Vq2DF2uxq29ZmmdRe0BDXPFAuS2qjwBq/pvhW7zWAvIZiKctlxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791277505; c=relaxed/simple;
	bh=pSKJ8t+N5gHFjx4NjV1mBfzDMvP7QspArwWL52ezD5g=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=J0AtGOknAzGF071kshir7gUKy/haDxTNdCs0kwKjDVhjngdOH0+KcOSdJuPyaBoBXxbPOmsdyeJwChNx9AeTK2svtfj7iqTQdUfSgRBuZDjAFvEW2Th/xAn63I/n370D3tulfvnUe7LYh+VmsqRTUTNsy1lpAg4ELiYzuECKyFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OUIPxQg1; arc=none smtp.client-ip=91.218.175.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OUIPxQg1"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pSKJ8t+N5gHFjx4NjV1mBfzDMvP7QspArwWL52ezD5g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791277501; v=1; x=1791882301;
 b=OUIPxQg1mzzrcphQ3Ao2I9g1GJwvyu8bdKWRmmWsdxuZaP7J7fQofVL8FQs3BgHsu6ZcH68z
 xHPsoA8q/A/wterfe7dtmKp/NmaQCuWkcCFxAm872n80anzlEmSBq/u1w1ng69QFDEKoht6W+Bz
 dTbt1J+oiJwIWZVNDW9ACq1g=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cf1a0565370f02ca;
	Tue, 06 Oct 2026 09:05:01 +0000
X-Mizu-Trace-ID: cf1a0565370f02ca
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 06 Oct 2026 09:05:01 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <39e05b490d5c6f90ea122e1c9a83ce8bad94e735@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v7 4/6] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael   
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 luka.gejak@linux.dev
In-Reply-To: <9f11a1ee89aa22a2ce23238b5ac968463f6e79a2@linux.dev>
References: <20261002073845.31486-1-luka.gejak@linux.dev>
 <20261002073845.31486-5-luka.gejak@linux.dev>
 <aa7d919d98304ee095990735f39095ac@realtek.com>
 <DLWXWMOGZGX9.UANQJR9PZYWG@linux.dev>
 <359ea3a6857d4aba9c83876a10f7f9e8@realtek.com>
 <a1d007fffc35466a2d63a3fe6839286f3488d7be@linux.dev>
 <f23d5ed909c746ad851bd1038966d271@realtek.com>
 <9f11a1ee89aa22a2ce23238b5ac968463f6e79a2@linux.dev>

October 6, 2026 at 09:07, "Luka Gejak" <luka.gejak@linux.dev mailto:luka.=
gejak@linux.dev?to=3D%22Luka%20Gejak%22%20%3Cluka.gejak%40linux.dev%3E > =
wrote:


>=20
>=20October 6, 2026 at 07:29, "Ping-Ke Shih" <pkshih@realtek.com mailto:p=
kshih@realtek.com?to=3D%22Ping-Ke%20Shih%22%20%3Cpkshih%40realtek.com%3E =
> wrote:
>=20
>=20>=20
>=20> Luka Gejak <luka.gejak@linux.dev> wrote:
> >=20=20
>=20>=20=20
>=20>  >
> >  > However, including rtw8703b.h from another chip driver is
> >  > already established, rtw8723cs.c includes it to reuse rtw8703b_hw_=
spec.
> >  >
> >  As I know, 8723CS and 8723B are mutual alias, no?
> >=20=20
>=20>  As far as I know, they are not. They are different chips.
> >=20=20
>=20>  fix typo.
> >=20=20
>=20>  8723CS and 8703B are mutual alias, no?
> >=20
>=20Possibly, but either way I will move, so it shared.

Followup: the things I am moving will be exact copy paste, unedited or
anything so take that into consideration when reviewing that patch.

Best regards,
Luka Gejak
