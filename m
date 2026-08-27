Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC7C3E49EA
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 17:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787850658; cv=none; b=pWaqSzvayhARN2+eiQY5p0U5c0lIcX+NL2imR1uwSI+TlTvtoRQb5QYpx6jAhFM8/DJyAnlHquKUYBMqg0IIZ3YTE5vqK/Bzj8Jo+aI15QflvNzaRNkA6y/UuptrU9wkPGHXwmSXIbzujb9qPPAtE5I332XSBA9OEY95ir9q0Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787850658; c=relaxed/simple;
	bh=niFL7bm0kSzXdARTm82C9hFNncC2h+OAKvYNwbF/UIA=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=KxmYnAYwjEN67t2kIDjRWbSWUl1ANW/k04ONE2gu8MoeEPoLjsY6IubtlAvj5Qo52BCrq6HtVAIov6OCrtiXeGJCTPjh9VpzbRVgK2eQqNzKPmQINNTSf1/aGIJQXhLjIhRh4+ytu8vgHVRZ/uLFG8EV9QlUoonNjOxfV5dZOMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S5lKEa6I; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S5lKEa6I"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5b00d083818so1161381e87.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 10:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787850653; x=1788455453; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id
         :references:in-reply-to:user-agent:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=SGL5LGzLQwg1/37HG8XcUTKvJQ5Nvx/6mBTpYN8+4GI=;
        b=S5lKEa6IxTxPsFewD+FW3OVIsVorki7kDHKiDA86NFLm9jYru7VJqcSxyzchPaDBft
         plCtALFzAMPSRM/nqZkFaVh/ALma0tKrsCS+8DSIiqnmoqX8UuEf5zNMxbVvXN5H+jOr
         ZxlUYVKE5z15Ts8zwUu50rRv5G6Y0uJvA7llervM1icm06gTKsrBnniCokfyp3xq3DFl
         ce8p4nP6ngFHHPVUe3yOlfXj9zroThNThqH56MchCeGKwLP3g/5H4IotEqnoPhsydhwf
         Ke9BlLiy49AItznIM6v6B1+90/dYN2W5ziTvhzzZnZk6TBSY7zDGSS7/DRVlppJ3tnRH
         Dhqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787850653; x=1788455453;
        h=content-transfer-encoding:content-type:mime-version:message-id
         :references:in-reply-to:user-agent:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SGL5LGzLQwg1/37HG8XcUTKvJQ5Nvx/6mBTpYN8+4GI=;
        b=ZSm+wHreeTlqNegFffhJ3yh14UiJL0nBzOMXZAJ/W2x9jolVGcdpI5ue1shmQXMpTm
         4VhT6EeXt9TRlaQnriHzgr9QVG6RKzNvl029djbeEjhgIRcRyvtpMNUDor7pJge4jmzB
         EzLxgFZwE3UasDQmvy3AcbpRHqYLgyOlmxIDGu1VNrCYWVLkGejbDLaZ2fb+Wx2EyoSC
         G3V7mfwUjBi1WXlXghdERDwYZdP4oGbuWM17EGjNgC7Ekzj62BGDYj2KAvj3Qws519+f
         Bz7vze2thuhWWTZ6vLT2Hk/G9FtCC94+n4UAg+VjmpO1Ufkr2F75bs01+UDClaO1hU1s
         EUAw==
X-Forwarded-Encrypted: i=1; AHgh+RqdedqMND66mC486Q4nvQWaaQyBI6lA754W2G6ggoJKYt1dqwvyEaUqhwyUiLoG34gXFeE1HtDEzPAO/GpRrA==@vger.kernel.org
X-Gm-Message-State: AFuF++kb/DAWRVhKYR3vZbPCSRRrt1leuxxua5nU1MprMB4yWRhV2H6Z
	zf+yk34vh0l57dCQSf4BLPhX1Oa8yjp4L89lU6uraICRm9tVBD8gVzX2HYImVIZA
X-Gm-Gg: AR+sD12ojShXahjL88/U5OZtu4roq/t3d/gFhg0WbsjobM5eGjcdCsGvGrvrkGhJy8P
	vYyiEbBG3uzRlz9IsBSntqygdf82ac0G+bmjmjq802wnxoLFLzo9FE6DkXtqIG4P1MU5uEBP1ZI
	GvIgdOcpe49CXCxNFE/POIuPr/0V7zdG4hrveMzoF/pcC4MqnqA4BjPvtTkoMqEGUiSfKNasaL8
	BpXs0hkutWIvp4U6GPX1xlhcH4HqKgOOPgVKOkR9kgCYJpLLa62huB7OHIpHmso4LmtOcCqpbjl
	JP3EKX5cjEjYpiS35wyXjqnY1Cb4D2rsusWxXTXaeSD5EB8cFAsJA6JMAKWzvPreAMooNhAkfTF
	7Zem36yROENykDptKJGgWWk/M3sYH8rIg0sKsneP1TcUV2cYNcfUtOoma/i3p+cSCYktsghqzE0
	HVSKafcG8eAWyVqM8/GEsunjn8fYgT6bD2moP5JmaS8iAfY5QniKex5TZMma1Yo1aTC1PCHZyD2
	euISA==
X-Received: by 2002:a05:6512:b9c:b0:5b4:5a42:ab3d with SMTP id 2adb3069b0e04-5b5e63cbb4bmr163347e87.8.1787850652633;
        Thu, 27 Aug 2026 10:10:52 -0700 (PDT)
Received: from ehlo.thunderbird.net ([217.196.163.190])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b5e68db0cdsm8519e87.44.2026.08.27.10.10.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2026 10:10:52 -0700 (PDT)
Date: Thu, 27 Aug 2026 20:10:50 +0300
From: Bohdan <boulderobscura@gmail.com>
To: Mark <markmunene827@gmail.com>, linux-wireless@vger.kernel.org
CC: netdev@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BBUG=5D_iwlwifi=3A_Comet_Lake_PCH_CNVi_AX201_=28?=
 =?US-ASCII?Q?8086=3A06f0=29_fails_with_error_-110_on_warm_reboot?=
User-Agent: Thunderbird for Android
In-Reply-To: <CAMSTZOnSYZjqj4AyBpLg2hQfRs6JYZA5H26MwQ+G2WMGgNzBkg@mail.gmail.com>
References: <CAMSTZOnSYZjqj4AyBpLg2hQfRs6JYZA5H26MwQ+G2WMGgNzBkg@mail.gmail.com>
Message-ID: <025FFEEC-E57A-4C74-BF1E-D273253F4D9A@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 27 August 2026 19:26:58 EEST, Mark <markmunene827@gmail=2Ecom> wrote:
>Hardware: Dell Precision 7550 (Comet Lake-H)
>Wi-Fi: Intel Wi-Fi 6 AX201 / CNVi
>PCI ID: 8086:06f0
>Subsystem: 8086:0074
>
>OS/Kernel:
>
>Linux Mint 22=2Ex
>Ubuntu 24=2E04
>Ubuntu 20=2E04 LTS (clean installation)
>Kernel 7=2E0=2E0-28-generic
>Kernel 6=2E14=2Ex
>
>Firmware:
>
>Stock firmware
>iwlwifi-QuZ-a0-hr-b0-77=2Eucode
>iwlwifi-Qu-b0-hr-b0-77=2Eucode
>Summary
>
>The AX201 initializes normally after a complete cold boot, but fails to
>re-initialize after a warm reboot, resume from sleep, or iwlwifi module
>reload=2E
>
>The failure consistently occurs during the early PCIe/CNVi initialization=
,
>around CSR_RESET and Host Monitor polling, before the driver reaches the
>firmware loading stage=2E
>
>The resulting error is:
>
>iwlwifi 0000:00:14=2E3: probe with driver iwlwifi failed with error -110
>Kernel log
>[  609=2E416668] iwlwifi 0000:00:14=2E3: Host monitor block 0x0 vector 0x=
6
>[  609=2E416670] iwlwifi 0000:00:14=2E3:     value [iter 0]: 0x00000003
>=2E=2E=2E
>[  609=2E416695] iwlwifi 0000:00:14=2E3: Host monitor block 0x22 vector 0=
x0
>[  609=2E416714] iwlwifi 0000:00:14=2E3:     value [iter 0]: 0x00000003
>[  609=2E422051] iwlwifi 0000:00:14=2E3: probe with driver iwlwifi failed=
 with
>error -110
>
>Steps to reproduce
>
>   1=2E Perform a complete cold boot=2E
>   2=2E Confirm that the AX201 initializes and Wi-Fi works normally=2E
>   3=2E Remove and reload the driver:
>   4=2E sudo modprobe -r iwlwifi
>   5=2E sudo modprobe iwlwifi
>   6=2E The driver fails to probe and returns -110=2E
>   7=2E The same behavior occurs after a warm reboot and after resume fro=
m
>   sleep=2E
>
>
>What has been tested;
>
>   - Upstream firmware revision 77 - no change=2E
>   - Both Qu-b0 and QuZ-a0 revision 77 firmware files tested=2E
>   - pcie_aspm=3Doff - no change=2E
>   - iwlwifi=2Epower_save=3D0 - no change=2E
>   - Intel AMT / Manageability disabled in BIOS=2E
>   - POST Fastboot set to Thorough=2E
>   - Clean Ubuntu 20=2E04 LTS installation - same warm-reboot/module-relo=
ad
>   failure=2E
>   - Linux Mint and Fedora - same behavior=2E
>
>
>A complete cold power-on consistently allows the initial probe to succeed=
,
>while reinitialization without removing power results in the -110 timeout=
=2E
>
>Firmware loading
>The firmware revision does not appear to affect the failure=2E
>The timeout occurs during the initial bus/reset handling and Host Monitor
>polling, before the driver reaches the point where it requests the
>microcode=2E Because of this, changing the firmware version or location d=
oes
>not change the observed behavior=2E
>
>Additional information
>
>The system is a dedicated Linux installation with no Windows dual-boot or
>Fast Startup involved=2E
>Full dmesg, lshw, and Intel SSU output are attached=2E
>The behavior appears consistent with a failure to properly reset or
>reinitialize the CNVi device after a warm reset/power-state transition=2E=
 I'm
>not sure whether this points specifically to D3cold handling or reset
>sequencing, so I've included the logs and hardware information for furthe=
r
>investigation=2E
>Please let me know if any additional register dumps, PCI
>configuration-space data, or specific kernel debugging output would be
>useful=2E
>
>Thanks,
>Mark

Heya Mark,

Can you try the mainline kernel? I'd try on NixOS and Arch, but I don't ha=
ve access to your hardware=2E

Fedora has a COPR repo, more here: https://fedoraproject=2Eorg/wiki/Kernel=
_Vanilla_Repositories

Bohdan

P=2ES=2E resending because the mailing lists rejected an HTML-formatted me=
ssage AND I forgot about "Reply All"
