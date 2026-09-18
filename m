Received: from sonic303-21.consmr.mail.ir2.yahoo.com (sonic303-21.consmr.mail.ir2.yahoo.com [77.238.178.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB5E3E3DAB
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 20:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.238.178.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789762816; cv=none; b=EyfuLuGFK9j0fILQnAubYrvnjb5joqSEKK7e6OnjifrSfh06ys3lerZuM76K+iRk4XvyPKQvzZl9UntdrGhId9qPID0fPKKFuInI6CYWXkjueWEAAS+7vHWsCdwkgRWTlyv0I0g2ExHK4VN91wf/nrf7vyYDoAy/fw7sclaI1w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789762816; c=relaxed/simple;
	bh=9zLzXqLe7E4bQHxVxE625koFa1sfbRJre/oj4VMm7fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnZXOiO6J0jFiYVq3UkhJltVzxIB/CfJZu+noD2gta65NOnt5mgUUiHhlAevGsY2xWZWJ1t2zchgAM1PDW45Dy6/ngyPSSLqQmQo4ct6dOgzGSbPyYttaZPM8PjhIT2L10MqRIbnidSp2VzqjfRyKCDUaYZI9vGEnPlPUmdVQxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aol.com; spf=pass smtp.mailfrom=aol.com; dkim=pass (2048-bit key) header.d=aol.com header.i=@aol.com header.b=rk/0a+ni; arc=none smtp.client-ip=77.238.178.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aol.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aol.com header.i=@aol.com header.b="rk/0a+ni"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1789762813; bh=VbCdxVLCOm2ffnIKL3NPvwyly2iEJgUa72FBQk35xB0=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=rk/0a+niF2W2G4TZHy7lGck+92F04iCLu2HZKCQ/Z4ncOCfTMtaPkI6qW8Fv86wwtO3VmbgALi5ykLkrUe9PgV+PjA18I52BBfv7zJamRiMBRyfnjDKwXnaucaac9EUk0Dd0MEHoTHOVKuQ7YPtH+/8rJnSWrWmxp1DvormVn9RN1PXpCouX3Z6HrT1FPfigne8FBpdWihlhOwyCiuUSLCMt3tBJLF15COYcY17N4xbuO6Lo3v4TAG6abOscPKR/XMic0FsKlBfYQu2takBOBCYzKH/OIXEKEsJBUzFsFGetf9uoKTWskeHrsm0KOtJFT7b8220Di7dnu7wca3xQow==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1789762813; bh=FoXlx91mHey0b/j9GBjI39KwwRTZNvM2atIl6oz5NEP=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=iXiX+emYcVa/88PKj3fySjEclcP/Rm9b4Fu6yDTvq/PXjdx9YJP6WhlT5r6mpbuSQx1zexm8Fj8tpJoL3pLPahwjy6hxiodRv1iXyBba3ovVxQC1zOKqRZZ+4hCqEhtsy1ymv/TITzotvZOqw9EecXpqIHIBFlzHo7OeGXsChxr2543TsEvblZJIsxhRaS+/UJGK5NZQ6KeuXxptqWOxycNV6aLr5N4oz7os5YcNQPc3NaF9C2bvDDJui8Cb1xdhEqUkCL4RpPB0ZyxrKXExW0a7jHzrA3iSpqGmnUQCL9a811Sc/zfgVM9tjW3wzuy4bcA6O7aeJ45Q1oPp6fxq/w==
X-YMail-OSG: 3Nyc2EwVM1lOq3DSkmAZg7WopzTFo4MkaJQjDztBc99zewcNY0stlNOrXn03LPc
 YP1yPGRLr_KR8ld02iqNm3YH2cYCYj7FfoxU1ONcrsdtzpJjSmAnysdllRgWLuXQqHowHtCA9gEQ
 kbnMpWgw8FFOIg2ZPjnkQ1Hv4I2HKhT8CzkVHGwh6nJ4ephtQfVk4Jo3Bd.gDLPNUG9GKzVxOlNH
 Aykshkh_vSfVZav6VafXWm3mFSsg.1a9s_QEt6.TnGtuNz.n_sfpMXh5VdMuH9NIo.o581KLOnvj
 KjHr110SveQNEZKOP.LdkGtsm_UGVivWGawPbFvqns1JUhmSVwIkFy6gseVwuNO95QCd_1dTRzOI
 e2.bkDmlX5P5msIlXuF7WIxhK_jTmxgYFdPeJeTS2bgVehFC7N6d4TDrpIm94xnRxcQQv.fzznSi
 1AeAwgRhZGzN28yYUTjgwpyaFalL0mlir.CGZpwxu_iIwvHNFpz8DamXwoh1Ac3iS6O7uMmsC77k
 s3EbQQ_OgyN1CzeUZ9Z8XdHvbHtN49N75clHjbNqvtljU0Rg0jaHzf09qZouX0z1UiNBiGC4gRc3
 grFLDpXGYwYxyGi50VfqJbwA1RWD1lT1XUbSOfCMohR8XB49MvEz0zO_0GoEQy6G9w0JMbTjRUS7
 5OqCykkiAwAwn8Ee7c9kDK8Nq3fsuG6TZd5Xe_gb.id9b6O2kM.s1QLe3HGxZR3PH0ln4c6XcPrw
 wC85K_y_gGlJsdXabbt5zkHmry4Vg7vgDa_Hz52AKbJATVdJkT8K0t0aN4LggEYdqWaK_qX3fwbF
 d0eJw.lcRkciW0vOuxVVvCalT6RLZjSSN2hRjD9ja4E8oq49GIM23VMlVfbZcDx.nt8FPzNx3Fsb
 3TanDec7bj2bMBxo_B1Sx3_sZhnOPQHQnu3IxyEFCh3eoCLLrAtARzZlNHK29fWCIhgBsowJ6Wa6
 Rj.mJUmxsTZeqCX2e4_4bhzW1hdNqpxLIFpJhx7nSQGIibMt710Fv_vV694mIe9Knm8PoUW3AWxk
 5H12EqDKAkcI9xoNlD2dc_.QaMdaK3O3NULip6Qjn7zjS5n9n8e2qN7mH415n4FFQOc5.v2XLiq5
 1ow4ptnqjXq1G3syMmCDU87bDlcatPERl7p4cHmUsCjE92zI0_TWBW3nMP8QDqmEFx4GguWZOrx.
 gf_j_ijq5xJYXgqy4eGVF26qfpn6J1wAAYKvHofxuELjbs17WShhuOUfpAL2dtUVY8xgvA9hvsQH
 iqPzHnCLq0oiud7m2G9FLCMg3cmwTWWLQ8mAIlQGjO1N7gvUaUtWQVN7_ZP_LlYqLLmnsMLSgN0B
 WVHQoWuT4_GXAWN3pvz0hLYE9Y6vFPaUJBmfZonMAOYSU2WoTEiHKrBu1HJGzzdgSEsvR_hffuf2
 lw3VTtnG_7DU1HElnWiEmZr09XFAti.hDnMaOt7FWXrp83ub4C45aY8ceBDLndB5iHnVGxbH.xdt
 xTyBup7rt4McvqYmMlXzsfNQJ.UQae.18ApATPu_xHAwK8DEFgI1U4LCvORxTUQDlW0GUuFoEhOM
 YecGEzW4VuP_xkygCMdIgoRSvQxbmKIb7z.Cmj.y5XzKMgriKQV2ioorpCMZ0roxTdJAoBt0mrAq
 tx2wwIo63bnaZBroSDBmBUYpGpX0AWgVMAKTvsTfj8njtdUzP0V84n1zGWFtuSedmxYUqcp01N.W
 I7hliLMKfyW1bRglcUjBA7BqQN.N0uoN9dLF4zrTKRBSJ6BYY.r34vgZeNlF.izM_IQfp_cW9SWE
 RJVezSsfmdh3uzkaUFE0g9mGZQzgKiKznQVZgi_Vwl9fUJU1kXkSTyLDqs72.GbDCRwl.gl1oeh1
 Q9BeYghAQD6gRKxscEoHyDDBTTjNBe0KzhRxJd2vfalWBKquBp1qBIMKfemgzEfDRjPalk6nyS1k
 zyBUmNkqeJ9Cxl03Qi_l2fDF23iBACIYbln.rh0foABC0vBsoiC75YUmWZ.XORd3D4Q1uHTHizRI
 GfKbConTrJo2qnKEHCqciYFP2VHa1x9iJhsJlB30vEgJx.JNGioduxvmhUcpU7gRwL5YbAqzx4Rj
 kKQkao_loy8LFfVIj3Zei1UAdSE.IZgFYk0B9sV0j6hK.IWNSgioXcUsCn4moLNlBdv6wX3Cc9O_
 fMKkJ9DJ9fIvVRbxqHTsNRRr5Fg8jVBGmuIyaWCw4hoaG2_epgH7IJw--
X-Sonic-MF: <eexto@aol.com>
X-Sonic-ID: d4c822d0-0ed1-4e8f-b1c1-a8a217a340d8
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.ir2.yahoo.com with HTTP; Fri, 18 Sep 2026 20:20:13 +0000
Received: by hermes--production-ir2-cddf86dcf-wfzrf (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 4e7a9ad05bf10293509a62a8c86d7d92;
          Fri, 18 Sep 2026 19:59:29 +0000 (UTC)
From: Paolo Lazzaroni <eexto@aol.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	Paolo Lazzaroni <eexto@aol.com>
Subject: Re: [PATCH] wifi: rtw88: 8821c: Add HP single-antenna quirk
Date: Fri, 18 Sep 2026 21:59:27 +0200
Message-ID: <20260918195927.30118-1-eexto@aol.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <3b3788a7c4f240899e630938a6c7b472@realtek.com>
References: <3b3788a7c4f240899e630938a6c7b472@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, Sep 13, 2026 at 02:15 UTC, Ping-Ke Shih <pkshih@realtek.com> wrote:
> Should use your full real name.
> 
> You sent the same patch by different mail address. I'll drop previous one.

Both patch submissions were identical, but please ignore the submission from
p17232763@gmail.com. I will use this address (eexto@aol.com) with my full
legal name (Paolo Lazzaroni) for all future submissions and v2.

> I don't see rtw88 has ' rfe_option_full' ?

Apologies, the previous patch was based on an out-of-tree backport tree.
I have checked out rtw-next where rfe_option_full does not exist, and will
only set efuse->rfe_option in v2.

> If this is the only one platform which needs this kind of quirk. Add an entry
> to rtw_pci_quirks[].

Regarding rtw_pci_quirks[]:

The reason I matched the PCI subsystem ID (10ec:c821 [103c:831a]) rather
than DMI in rtw_pci_quirks[] is that HP assigns this specific subsystem
ID across a family of laptop platforms (e.g. HP 15-da, 15-db, and related
chassis) to denote the single physical antenna connected to Aux/S1.
This is documented in the OEM Windows driver INF (netrtwlane.inf):
  "PCI\VEN_10EC&DEV_C821&SUBSYS_831A103C ;;single ant(connect to right one S1)"

If we use DMI matching in rtw_pci_quirks[], it would only match this specific
laptop SKU ("HP Laptop 15-da0xxx" / "4XW76EA#ABZ"), leaving other HP models
sharing this identical 103c:831a single-antenna card with severe signal loss.

However, I understand that inspecting PCI structures inside rtw8821c_read_efuse()
violates bus abstraction for rtw8821c.c.

Would you prefer:
Option A: Keep the PCI subsystem match, but handle it cleanly in rtw_pci_probe()
          (e.g., setting a flag or rfe_option override in rtwdev before chip setup)?
Option B: Add a DMI entry to rtw_pci_quirks[] matching this platform?
