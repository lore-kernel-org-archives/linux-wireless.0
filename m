Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A3761FCE;
	Sat,  5 Sep 2026 05:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.21.23.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788587349; cv=none; b=WJs5StxZ5GsxcviMqilF14DtJgyyGaU3rbd7qoftK2UqMD37CDFWlGQ5hvosp0dWpkFWrvfAPyzvWQQxuFYGuIfG8E+4xdRT/oawwbSe3VsSXgCEWcS7RepeplcGBBJpaHI+OJKl3o1Z19hfo3GbcSbZJDKf0HTe6uapR0gWrdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788587349; c=relaxed/simple;
	bh=dLgyqMjJrt6QoHcIhrs2GwJlrjB833hjrC0NvbX6Bb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p1EuHa7xPdsR3xuGSpUMIj3cdCypXxtcXZeixwTkAQhxpaTzCPLF0IjZmaNYtM/uZZwdpIRg1UvaGhXK4wrhcnd9l7MkXYdN/9ncc1bdZPZDVdAXLqd0YQgAjj9aLJOkkBit2CRazqTKrNqoRQ68Ht0wq+RPUiGhBkl1FUZvLVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org; spf=pass smtp.mailfrom=disroot.org; dkim=pass (2048-bit key) header.d=disroot.org header.i=@disroot.org header.b=RX8dqXbP; arc=none smtp.client-ip=178.21.23.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=disroot.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=disroot.org header.i=@disroot.org header.b="RX8dqXbP"
Received: from mail01.layka.lan (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id 2F891883C9;
	Sat, 05 Sep 2026 07:49:04 +0200 (CEST)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id HN4AlLPN_2I6; Sat,  5 Sep 2026 07:49:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1788587343; bh=dLgyqMjJrt6QoHcIhrs2GwJlrjB833hjrC0NvbX6Bb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RX8dqXbPZXUzXy91NZ7MRhX0CkfXZ18pgqtfmXqOY8DWqMe8wmLa8B0eSdi53aZJU
	 MZmWm0CLbT4m8QTVBs4lRs6MaLjkYWDGdj8TYLF0NolXfal7Y3x7+1SCvRDVSsj9ZF
	 gxGwQ9ohJNsZV7PKXKXbp0tSblmwNKa1uYF6kSbHt4x2xWM0Wq2PyZiMSyee8oWoGO
	 BsiistNCCfOFLs2868tyLvUpjJEDpE1OcisdSCEqMv4g4/BSRUNRfwMuNNmOyfnOxm
	 7cgKj6W8y33VSr1ITIC5kc0o3hVC4j9sg539Hbgo7YDLNcRwkq2RokqGY/0wWLybVQ
	 jDE1UlUVBo4Sg==
From: Marco Scardovi <scardracs@disroot.org>
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Ryder Lee <ryder.lee@mediatek.com>, Deren Wu <deren.wu@mediatek.com>,
 Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
 Klara Modin <klarasmodin@gmail.com>, David Gow <david@davidgow.net>,
 linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject:
 Re: [PATCH] wifi: mt76: mt792x: fix NULL pointer dereference in
 mt792x_init_acpi_sar_power
Date: Sat, 05 Sep 2026 07:48:50 +0200
Message-ID: <oWkA8ZPAS2aI62u9I6EKqQ@disroot.org>
In-Reply-To: <20260904234838.19342-1-lucid_duck@justthetip.ca>
References:
 <20260904161826.5638-1-scardracs@disroot.org>
 <20260904234838.19342-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

In data sabato 5 settembre 2026 01:48:38 Ora legale dell=E2=80=99Europa cen=
trale,=20
Devin Wittmayer ha scritto:
> On Fri, 4 Sep 2026 18:18:26 +0200, Marco Scardovi wrote:
> > Fixes: f965333e491e ("mt76: mt7921: introduce ACPI SAR support")
>=20
> There is a patch for this from 25 August:
>=20
> =20
> https://lore.kernel.org/linux-wireless/20260825181712.28548-1-lucid_duck@=
ju
> stthetip.ca/
>=20
> Klara Modin reported it, David Gow confirmed the fix on a Framework 13.
>=20
Hi Devin,

sorry, I didn't notice that a thread was already opened so I supposed no
one reported it at all.
> One note on the Fixes tag. The crash needs a regulatory update to run
> before registration, and that only started with these:
>=20
>   9b80bd9cab40  2026-06-09  mt7921 regulatory wiphy self manager
>   e9f3f1cc133f  2026-06-09  mt7925 regulatory wiphy self manager
>=20
> Before those it just set flags, so the 2022 commit would reach stable
> kernels that never had the bug.
>=20
You are right on that, I'll pay more attention next time
> Your trace enters through the regulatory notifier, mine through
> firmware init. I could not find mt7921_regd_notifier_work in mt76
> here, so if you have a second trigger I would like to see it.
>=20
The whole patch is as you see it but: I didn't add anything more.
Tbh I was working on a whole different sub but the OS refused to start
because of this one so I came up with the absolute minimum patch to
make it working
> Thanks for taking this one on.
>=20
> Devin
At this point you can count this patch as void. Thank you for your time,
Marco


