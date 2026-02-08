Received: from mail-43166.protonmail.ch (mail-43166.protonmail.ch [185.70.43.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3E1346E7A
	for <linux-wireless@vger.kernel.org>; Sun,  8 Feb 2026 21:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770585545; cv=none; b=RctZaq8MA3hF/tbV6T1Wq2Vc/MD7WFl3/R/0MbCUH1T+qmc9nLy9mEk8NdUMEo9nUNK4l3//Q/1QySv+t+UQbFR5KPW2Utd6EkCbKm9kvPApmIWq3r0J/S7C0j48vSwTCTp8VI6osKnolTp4CbGdR/p76dZHgkBLPWE4PSMHpA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770585545; c=relaxed/simple;
	bh=U1vYQHlJdB/c6u0AH61fQFsT+hOcs+y1xFyMO8dJ3SA=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=mquSgTLkYP63T7ogAlLTmAPCeObmj+2hHpxGJ7gGrtP3bvLYY20KWt4RFK9VVNUnCGrDMN7BXglMngEQUK2vhHD2ZKxBMOELLLBcVdCucMNLpGlJbmIsMcR4SDCoEdzT+2miZoxKu9/PVobhdyVNmiPk0qAa6pEPfTcjGkmzwAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=KrAUxEDr; arc=none smtp.client-ip=185.70.43.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="KrAUxEDr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1770585536; x=1770844736;
	bh=U1vYQHlJdB/c6u0AH61fQFsT+hOcs+y1xFyMO8dJ3SA=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=KrAUxEDr+ziGuhro1zbLbDorVnEcqi/lSWqTPHp021lTRHVVez25W9Vdc525OVAUo
	 pCyKo0VbJr7RgiHo6mvccFYhoO8NrlMykYmID08LxBbQeeXvEOFpetzv4lpQEC+t36
	 2famOdnqAPmD8m/sGae3+Gkz+pHPnfK1sRg6+AlWxxYVSmqI35lbZIhtRwG1bBRp/I
	 TrAcdjzQxHYP6QWJ1xHXrF0j9yFEOBWaU3nCbNRHlq/Mtcvr7gqmL7/t8mog1rSriz
	 l4cdROMkd/HgoLmWFW16nRo7nmwVfUYlTo0OKChuAnI6HsOJqJFjakt1jbUeP1ZtO4
	 tZqwl/Z0wk55Q==
Date: Sun, 08 Feb 2026 21:18:52 +0000
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Maxim Schoening <maxim.schoening@protonmail.com>
Subject: miriam.rachel.korenblit@intel.com
Message-ID: <wLZVXoPkLGec1OnYaA-mWI-GD0IzTZFMVJBP-E1d6q2xsBKubMhd67js94mBMze_5NuuYNQ3eeezFU-lddpFXqD4-cRhIOuCVXdWY4L-Fao=@protonmail.com>
Feedback-ID: 28367373:user:proton
X-Pm-Message-ID: 744b97e563255f042f1de6673cce1a5fd1964d23
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

The iwlwifi-bz-b0-hr-b0 firmware has not been updated past version 98 (core=
98-161, October 2025), but the 6.18 kernel's iwlwifi driver has raised ucod=
e_api_min above 98 for this device class, resulting in complete Wi-Fi failu=
re.

On 6.17.9, the driver falls back to 98 successfully:

iwlwifi 0000:00:14.3: Direct firmware load for iwlwifi-bz-b0-hr-b0-100.ucod=
e failed with error -2
iwlwifi 0000:00:14.3: Direct firmware load for iwlwifi-bz-b0-hr-b0-99.ucode=
 failed with error -2
iwlwifi 0000:00:14.3: loaded firmware version 98.d661c37c.0 bz-b0-hr-b0-98.=
ucode op_mode iwlmvm

On 6.18.7, the fallback no longer works and Wi-Fi is completely broken.

Neither iwlwifi-bz-b0-hr-b0-99.ucode nor -100.ucode exist in mainline linux=
-firmware or the iwlwifi for-upstream branch. Other Bz variants have been a=
ctively updated during this period:

bz-b0-gf-a0: updated to 100 bz-b0-fm-c0: updated to c102 bz-b0-hr-b0: stuck=
 at 98 since October 2025

The most recent for-upstream commit (9a9285ce, 2026-01-15, "iwlwifi: add Bz=
/Sc FW for core102-56 release") adds firmware for Bz/Fm and gl but not Bz/H=
r.

This looks like a coordination gap: ucode_api_min was bumped without matchi=
ng firmware being released for all affected sub-variants.


Affected hardware:
[17.350374] iwlwifi 0000:00:14.3: Detected Intel(R) Wi-Fi 6 AX203
Device:
Xiaomi Redmi Book Pro 2025 PCI ID: 8086:7740 PCI path: 0000:00:14.3 Variant=
: bz-b0-hr-b0 (Blazer CNVi + Harrison Peak radio)
Working: 6.17.9-76061709-generic
Broken: 6.18.7-76061807-generic

This is the same device class previously affected by LP #2102029, which was=
 resolved when bz-b0-hr-b0-96.ucode was added in the core93-123 release.

Could the Bz/Hr firmware be brought up to match the other Bz variants, or a=
lternatively, could the ucode_api_min for bz-b0-hr-b0 be reverted to 98 unt=
il the firmware is available?

Thanks a lot!

Best,
Maxim
