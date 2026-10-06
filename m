Received: from mta1.migadu.com (out-19.mta1.migadu.com [95.215.58.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD33A3E40FC
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 10:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791283303; cv=none; b=X77hXF6O4foGUNoT3XS1IUNMpOITCl1WnRzXc9I85G5diNYr0n0AoNEL23BEM2NRijte/h90MmUkKFk+hJBCbrhnx6rdXf04Ruu5PeDbhsySFdAMN3fWOem66Wt2PBi2K5p6JeuB5UV8iTh7JLGagcaYc1quuSqB+GHj4pzB3pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791283303; c=relaxed/simple;
	bh=fsfTs8nDZUVkosUul8dmIuVO+vAfRQVDJxF6129cDkk=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=K6ZeuZMGXmrjizkAMyJyRDGBrkIInVSjbdnaZCmXR+b2LfrKBPamYBncj6USwce5ZIbUs6gHCShcvPhv6BTTHZXQOoUO38RL8HFNw1uMGOuF5KD6ksPO2xLokPx79Z96Yfefaq9qyUGQmDJ4vhVlg84mkv3Yolh3RX7TOegtVck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R3a1NtSp; arc=none smtp.client-ip=95.215.58.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R3a1NtSp"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=fsfTs8nDZUVkosUul8dmIuVO+vAfRQVDJxF6129cDkk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791283298; v=1; x=1791888098;
 b=R3a1NtSpTg0f9V3CmVrqmppUMfARTVXzt10/+I2LwG6nleiasW9bDBUqAOHKqkTJ8Y7YmhM4
 jih0YAarGlJCUigHL+0ob0zhg6q/EAGtFYnn7krj5I0poIyLcyZLqULR5VWhdNvQEZ3ayB+Atb0
 +jSmIoTGIDx//B63+8Df+xfU=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id bc48b6761b916392;
	Tue, 06 Oct 2026 10:41:38 +0000
X-Mizu-Trace-ID: bc48b6761b916392
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 06 Oct 2026 10:41:36 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <3abafff88a4607572817675c246ba50ca277b976@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v7 4/6] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael   
  Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 luka.gejak@linux.dev
In-Reply-To: <39e05b490d5c6f90ea122e1c9a83ce8bad94e735@linux.dev>
References: <20261002073845.31486-1-luka.gejak@linux.dev>
 <20261002073845.31486-5-luka.gejak@linux.dev>
 <aa7d919d98304ee095990735f39095ac@realtek.com>
 <DLWXWMOGZGX9.UANQJR9PZYWG@linux.dev>
 <359ea3a6857d4aba9c83876a10f7f9e8@realtek.com>
 <a1d007fffc35466a2d63a3fe6839286f3488d7be@linux.dev>
 <f23d5ed909c746ad851bd1038966d271@realtek.com>
 <9f11a1ee89aa22a2ce23238b5ac968463f6e79a2@linux.dev>
 <39e05b490d5c6f90ea122e1c9a83ce8bad94e735@linux.dev>

October 6, 2026 at 11:05, "Luka Gejak" <luka.gejak@linux.dev mailto:luka.=
gejak@linux.dev?to=3D%22Luka%20Gejak%22%20%3Cluka.gejak%40linux.dev%3E > =
wrote:


>=20
>=20October 6, 2026 at 09:07, "Luka Gejak" <luka.gejak@linux.dev mailto:l=
uka.gejak@linux.dev?to=3D%22Luka%20Gejak%22%20%3Cluka.gejak%40linux.dev%3=
E > wrote:
>=20
>=20>=20
>=20> October 6, 2026 at 07:29, "Ping-Ke Shih" <pkshih@realtek.com mailto=
:pkshih@realtek.com?to=3D%22Ping-Ke%20Shih%22%20%3Cpkshih%40realtek.com%3=
E > wrote:
> >=20=20
>=20>=20=20
>=20>  Luka Gejak <luka.gejak@linux.dev> wrote:
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
> >=20=20
>=20>  Possibly, but either way I will move, so it shared.
> >=20
>=20Followup: the things I am moving will be exact copy paste, unedited o=
r
> anything so take that into consideration when reviewing that patch.

Or would you rather me fix those style issues? Your choice as I will have=
 both versions ready.

Best regards,
Luka Gejak
