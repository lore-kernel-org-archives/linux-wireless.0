Received: from mail-oo2-f43.google.com (mail-oo2-f43.google.com [74.125.231.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3016B1A3A80
	for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 00:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789776864; cv=pass; b=lZeCmAs1aPJ3NpzSh9fSWUh88MVQew0f0Gf+nhiahc6djiyOEKpG3dTMvj9oz/8t3C+4cNcNnki8y1XY2xwmJelDa2mlubBpz4mhdC/dEgAZq2ix7pIT4hH9A7rf/Fk9naupzZMUA5jdgQ3WDudO8S6iN+cxXG/51FsT0US21Ns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789776864; c=relaxed/simple;
	bh=hKIeW8QLaoTNO5NGrpbb/2PVt3mYoAZg7b8qYCmy/l0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=P8J6zABYwmf/9OdV9ZlNu38QHq/rJwCjjR39ixlGKm7+cXvS6TB+Nw0h1yItIx3J0BWDOxzCGaQAVVzbEEDUoRbrmD/LbucdFiup2J8Ne7zO+1HVNxYB6zkKQT1rgYElRSC3yH/aKGIjkL1d2dQjPWyzUKkXHASJ4QTF+Pan1bY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gq2SP1Q6; arc=pass smtp.client-ip=74.125.231.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gq2SP1Q6"
Received: by mail-oo2-f43.google.com with SMTP id 006d021491bc7-6b1ae6c9b81so177681eaf.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 17:14:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789776861; cv=none;
        d=google.com; s=arc-20260327;
        b=SyGPfDgMPWy9ZKAlLeZq0EilWkeUWTd0kHIKz31x4m0qBl/FotkJvEqkB+BlaXsOQX
         Y0HLel/DqmeDdNQXyg1APCJVNvnI00LN0DWknVcR9q/s+LmsLo78xSZOL+tJE4kUS++T
         KP0W9oxdqoMmKQdFa0ZxBjTNxChr4vIZwsWCgUcnQCoW4x6KxgBEsxJbda3JH77a11Cu
         kxctjPaoH228q2tk7iiB/ITZykiPsJkwhWT3oHdusYjFLdu4uifq87aK5J2Zpo4Xf09L
         FsNa2d8OrMQhr63R1jnXnHaJTwCYBJzyP3ycX3lqMaJEmPGdAj7+8BZuaGKD6QslNc5U
         qAbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=F7yCcOb3zGW0wm52DDSHOVW0iD2YeayJ4a5hsdIEwKA=;
        fh=HrJVViaRWekoTRhH0mZW5cuqUOEThMkvVbeaE0lVcK8=;
        b=RVjfFwdn0qKKn5fRxSK85a/DMEBZQirFluxFosw5xCGUFCpycZuqZk9dx9PAm9LFtr
         zge8j/ccu9T34poAYxtQZ21f01DGI6Po9mmTbBnfbs5YXSqYUw7lJSnl149OI9QZYd5r
         spY79iTGNmDe35do4QXQjLNTxNow8cwCgXuzcr2Edwm1p+oZNSteiEbYSSWQQXPMBYn6
         krD9ftdk1VQ4MofE9rM1UTC0jMVDZ6LT1f0vtUn21Q5GU10LQVMMqpgj6s/JQs+GN04f
         pqc7gmvcsMDttwKIJL9DKiMR2Ue3pxKbRQfy4Cpmp/wWt8trFDRSggjQO6HhTckbU6jm
         AmBQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789776861; x=1790381661; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=F7yCcOb3zGW0wm52DDSHOVW0iD2YeayJ4a5hsdIEwKA=;
        b=Gq2SP1Q6ZRHDEPWaWrNQI/gLmm1e0xpldp2SL5/OGIRARkzNQc9ZyCgaJ4HqK5dCbf
         yZH1yWjcQ4r8qtSqGSuCx1Xc3+dDOkrqjydwcFMwtI8AiFAoVh4giI4r2gLmw+HT5G4k
         /C6sjI/xQgBCZ9m/MHHs1u3NMJ8gAxZ/mXQ9SBdPvNS4Ue9ot5ezDguIVmSILybQeP5b
         C6S/hk//VvYk0zvOAHWF3c598V4RvS1nXL57jbgZhZ0T0+z7G6x18sy7RWQjBnU4U/i8
         FEo6eW9nO6ZIa+8y5VXmzhVds0/v2Do2k8VdGfLrZFaVIP3IAPMPCypl8tiqJVUKV0vf
         NKlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789776861; x=1790381661;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=F7yCcOb3zGW0wm52DDSHOVW0iD2YeayJ4a5hsdIEwKA=;
        b=LmPo9zbfappsEB8/0gwRjAZG8DaUaRwkgHb4qRZC4oRWUFhZFbvz8FarBjkRpb2dFV
         HyuR7zmbObGwIoSd7xydkwHXy5qU313UiVkNvO5hV2VmNjkoNk0pm/guq5nWmelmMMwk
         2fqbbfTcKHUwVH5s/8mI6v8Nz2Cva0CRJqNgMncgzxc2KMHvwn4UiqTeT4p0vzNFodh5
         +IjJx1GPhADRzIY32LNH08Y0mAXMzpdAzwfisX30soHldXRvLRKM6icyuxRxfYEnBENB
         UNDp05htW62lvLFVhq0DZ4gIjYQHyDuSE9451cGFbLbJJ+NKJ7nGnTK1s8bibN4f81yt
         XEeA==
X-Forwarded-Encrypted: i=1; AKwUvBwSzgczTVMP6vQJGPD4cPyLFvIx99cBDIZdyBeFbnnHA3rzddOogm5x7+Y4b8uu1wGV+b/Ler77XF9HnzgVCQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lW1Y7WAOo2aV9gH8YStQyL2/oi7Ar6MLmPTzG6zTQ5FG+ymmci
	eZdi9eJdSfxazwbNzHlEbr/s9yPEE9NMlJPgFr1gHF7SoFd4dCpi1TMaDWkvMxo2hrAj5j64mV9
	VBTY8FDg2NDtV34ZvubBKhuPJIy9PUZE=
X-Gm-Gg: AYBFou1albrfZdVwFMharG0nimfNrSjmzbM1aayPRnoXrVAR4hMhT0uhGG5yAOdKjmv
	JSsLCvTUi0VhA1XbAkPif1Vy11uDfPnN6W5GFLyGOOE5z/odW4CbLP22S9OEJO9xK/rPZB98IpJ
	YfHgMtcyk9O4dKnDJWKhxyC3QYt8QxDUOTScO5isMn9c0L7EafMIsADblMvzzDj4FOKLcWW+Azd
	kpnTJrhEkwOBWWnzzo06Rahh/8Wgj5peQ9C45eDstGN37bJhOuIMGT+6s9H+pRQu4vfZnCXBK+/
	Mc+FqnAgMbQhAhHxo9ayO35I4PTmH50tNiozep6GmbhA1zSse1qToVADmIbIG9HTpLssqKGwMVC
	sfs/nELs1LGw=
X-Received: by 2002:a05:6820:4c0e:b0:6bd:b927:672f with SMTP id
 006d021491bc7-6ca90d95792mr3392259eaf.9.1789776861475; Fri, 18 Sep 2026
 17:14:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Dale Whinham <daleyo@gmail.com>
Date: Sat, 19 Sep 2026 01:13:45 +0100
X-Gm-Features: AcwNN1ViQ_B0Zd0gt7Bx9VZopK9doBcppxekD88aARRC7XnDy5E2g43kBAgubvc
Message-ID: <CAFcmK8h2nv5VPFErt-E93G6cKb-Ju33hfc=pSrTABK7nu_4kRg@mail.gmail.com>
Subject: WCN7850 on Surface Pro 11: no board-2.bin entry, firmware reports no
 board ID
To: ath12k@lists.infradead.org
Cc: Jeff Johnson <jjohnson@kernel.org>, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, 
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

The WCN7850 in the Microsoft Surface Pro 11 (X1E80100) finds no entry in
ath12k/WCN7850/hw2.0/board-2.bin and falls through to the board.bin
API-1 path. I am looking for some advice on what the correct fix is.

The device reports:

  chip_id 0x2 chip_family 0x4 board_id 0xff soc_id 0x40170200
  PCI 17cb:1107, subsystem 17cb:1107

A debug print in ath12k_qmi_request_target_cap() shows board_info is
absent from the capability response:

  cap_resp board_info_valid 0 chip_info_valid 1 soc_info_valid 1

chip_info and soc_info are present, so the response itself is fine. The
0xff is ATH12K_BOARD_ID_DEFAULT, substituted by the driver.

The names ath12k then looks up are:

  bus=pci,vendor=17cb,device=1107,subsystem-vendor=17cb,subsystem-device=1107,qmi-chip-id=2,qmi-board-id=255
  bus=pci,qmi-chip-id=2,qmi-board-id=255

Neither exists in board-2.bin (linux-firmware-atheros 20260810-2).
The only subsystem-device=1107 entries there are qmi-board-id=44 and
qmi-board-id=82.

Using a different entry from the same board-2.bin as board.bin does work
(i.e. extract using ath12k-bdencoder and rename). I have been running
the subsystem-device=3378, qmi-board-id=255 entry, which associates and
passes traffic normally. That may be another board's data rather than a fix,
but it does suggest the firmware accepts entries from this
linux-firmware release, and that what is missing is an entry under a
name this device derives.

I also checked what Windows provides:

  - Windows loads bdwlan.elf on this machine, via the catch-all
    PCI\VEN_17CB&DEV_1107 section of qcwlanhmt8380.inf. The same file
    appears in that driver for several other 8380 devices, so it is not
    Surface-specific.

  - That file fails against the upstream firmware with -110 ("qmi failed
    to load bdf file"). It works if the Windows firmware and PHY ucode
    are used with it, so the data is valid for the part but looks tied
    to the firmware version:

    Windows:  WLAN.HMT.1.1.c5-00310-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1
    upstream: WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

What is the right way to give this device board data? Happy to provide
further info or test patches.

Thanks,
Dale
