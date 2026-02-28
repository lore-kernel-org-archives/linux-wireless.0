Received: from mail-43102.protonmail.ch (mail-43102.protonmail.ch [185.70.43.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EF63612FA
	for <linux-wireless@vger.kernel.org>; Sat, 28 Feb 2026 09:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772270963; cv=none; b=J/qhJNzBdOZBbvsxA75eU6nK2a6VCoz29h/pKRyic1L03aMJD/DIBQUVzrNmyyJl4yHQhH/34tankRUsHe+CeW3T5QYMEg/hE6DbST6WuGb5uXycBsDLA8onxqhTxgcuMksXx9cys6qN5TvY1nFEOXlyRRls7HK0Rv8EXZt5ryA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772270963; c=relaxed/simple;
	bh=JM2EblrnxJYP5reY+GuDEKWO9LfefnfwlWnqhThMQ+g=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=ExAsU9cORGFGzoPwwpd9jowP1gXkkcayyVYx6FapNQAffgfXnxcsWxIUt6coQMbcHjjI8fthpvOW3d5IOA+8spjtNaiHDXXi5ZW/FW/xajepHowL3cTQdxTMvz/u7Sy23hU6L8L+cPzAMk4WWxAVd+1WOIwCVNrK8rmgtgQ8iVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=SguCshUG; arc=none smtp.client-ip=185.70.43.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="SguCshUG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1772270953; x=1772530153;
	bh=Qu3v2Wq551pUqB6RYw9XTNk2B7Bh1F+K9AubcUP1xFU=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=SguCshUGOes0tuCefcbi3DzjWMFLfwHT687kAO1HS+ZtPucrKQJqTxm5Y0vFj16Nk
	 ijn3m3HfSl2XD2oLXFOF1b4ji/tVMPxbs2/qswwulzo0AV4W0qGI3SoFqM9wA5zGbh
	 eU7im6cJ20y+sRSmCvdcpsn7zZGetW/++zMSj7UWpefVP+lTSjxUsMQZYInWPwqOb/
	 8Ux3MAB4VAtgH5SsBL0Cme22kf17+s8QDX85D54TFFAozKz3SByupiXmuEcj2rW6qF
	 t9YT7YWdrdJtkKQjAa903dVsUjb5ntlhnd/otT3Cw2Nx/z29+ySCu+nOMgGB1ec2yZ
	 TOSlWH8L7DyTg==
Date: Sat, 28 Feb 2026 09:29:12 +0000
To: "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
From: =?utf-8?Q?Ren=C3=A9_M=C3=A9rou?= <eldeinformatica@pm.me>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: CMA allocation fails with default 128M on X1E80100 (Lenovo 21N1CT01WW) for ath12k
Message-ID: <7pJkV7xouk-7S77gIvCwPj5EAAVe0JWdkD5Dc4Q7Y77_gPr5m7jMA2om7AyEN6RKBmEyFbIDJceHFstXFuzPJWPNhqafLXOu2O0uCDZEFcY=@pm.me>
Feedback-ID: 106394371:user:proton
X-Pm-Message-ID: 6eef8a5b0d30d4d98262c7f16fd8899c074401cc
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,
I'm experiencing CMA allocation failures with the ath12k WiFi driver on my =
new Lenovo 21N1CT01WW (Snapdragon X1E80100).

Error in dmesg
  cma: __cma_alloc: reserved: alloc failed, req-size: 257 pages, ret: -16
  cma: =3D> 1042 free of 32768 total pages

System details
=C2=A0 =C2=A0 Kernel: 6.17.0-8-qcom-x1e (Ubuntu)
=C2=A0 =C2=A0 Default CMA size: 128M (set by the distribution for this hard=
ware)
=C2=A0 =C2=A0 WiFi chip: ath12k_pci (Qualcomm WCN685x)

What I found
=C2=A0 =C2=A0 With the default 128M CMA, the allocation of 257 pages (~1MB)=
 fails
=C2=A0 =C2=A0 After increasing CMA to 256M (by adding cma=3D256M to the ker=
nel command line), the error disappears and WiFi works correctly

My questions
=C2=A0 =C2=A0 Is 128M expected to be sufficient for ath12k on this platform=
?
=C2=A0 =C2=A0 Could the driver be optimized to need less contiguous memory?
=C2=A0 =C2=A0 Should the default CMA size be increased to 256M for X1E80100=
 devices?

Happy to provide more logs or test patches if needed.

Thanks,
Jean-Ren=C3=A9 M=C3=A9rou




