Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F4B1C84AB
	for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2026 09:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787996376; cv=none; b=tJc9E0R6sod5Ve/4g23HX70Z5TmTD5I6JgEaS1UxUvxhBh3IKZHddsgOeOhSThaYFhuvQPMxgCiXiTv02TfLLiu15MXu66W5FW+qod4MYIXBlM0YhSlAhGI7xKQMqe77RJ0M+7MyZtv322sWvgs3xmzzJKRneZIY3GOtRkh0yvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787996376; c=relaxed/simple;
	bh=kQH8utjEcMuMrgMJOI0fiTjjeIf/7vys7+no0w6kqg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=biMQgL/9l7YpiJP4rnKRpp+MPHqYTbCErLgbHHtg2Vc4uiSZmXIHUDcSTEJrHNV8CDrq5za99Nwnjfhr8IjJhsiJtFerOLe5Dhug6zmxL3AjMkepH8GPzzk86xVzGx0NdOW+celM4ClrF9Zl/7xIWSGoPXQJizhAfmXyfeLRjSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mu2Qt7+a; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mu2Qt7+a"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2d5862bc921so4336205ad.1
        for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2026 02:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787996374; x=1788601174; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QwISUhSllAbTBUsml1VPg6731YykdVgMhKzGhwZ5KiQ=;
        b=mu2Qt7+aAdbwrfTdvj+zIcPwvdnxkntmauvhsd5hyjRmtKIsYC+1RI39dFoxCTChsi
         5CUeW4KheNoBoiB+YrtX284vbdeIxNA35zr4Ymx4l/bfQ+u/BvScC/dScUb4hOa3vaky
         FGVghA5v6B+2K32U8McN+QNQ0Uaz25tLLRUXT42PgrLZqxjRKSNhXva8/N41qVRAqASB
         3rRNZPeNKa+fuEi6BfufkL3LuIIhIUZz8yJQ/oXWEEtHY5SZ12atwxgIuaVH06GNGR/u
         PKnS376LT1JFRDKJr4rD01QW3uig0QYOt4A9+9SwwGiZH4n9t13K1SnNiZqWhUpMEyHL
         8Q7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787996374; x=1788601174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QwISUhSllAbTBUsml1VPg6731YykdVgMhKzGhwZ5KiQ=;
        b=Frmdh9DcwKPgjLWfrIGyQC/zAQmP4T/jvtQ3XdNiV4r1mJ5yC7uEB5lZ8+MNq9pR4O
         Bxal8A1j0AfiXXakgNvKwjS6KgHP6H1xihDqksqY8RZC4xxGZ7HybjLcdbzj6s7Glitc
         UfobPKBA72VsgzakuqVQYfty7F1ygLxVoXKh5DDrOOoNUvSHGhuFFzypPiOQrGflpbRi
         d8OmZ3zNkR4GgdQH/5Ycv0wn7EFUwTvUWqFoPMYqoF0+ZQvRNN5Sf3+fmn4DYz2+xKtW
         OCKJ7pyH76bkcx2aIso36AoNT97DkwkEelerTG7Kx882uh5/yDJGso4bI52sM9Vrk121
         aXWg==
X-Forwarded-Encrypted: i=1; AHgh+Rro3ndmY5beLz3PrtfKyEtmJvIPtygymKvfgiLqs/7+MyEtfrx+DtZ35DOlE4bgaVOHmExKc4EWnvjHsQtKEQ==@vger.kernel.org
X-Gm-Message-State: AFuF++nquBC+h2XqMtPBRDDRpkXMomIiCdlVO0CtWGDJsJfLPp4wYqXY
	Z3Esla7HJ9uD76TZGL7MLhJ0g/+oKt1AoOjh1BJEDTs23OG3YUFv/sip
X-Gm-Gg: AR+sD1131z3WE0mBoLRxW+kaCHMw9fjETN8LmkpsZztN1PzNe01OQ06Ky6tQWy1SKeo
	9tbk3/m7TE1rNn28cgLgWO/k56Rb3BpqnWP/recaIO4DEjUemdF2qAEqQK/DrxlnZl4n2144+BF
	cUdBGcdoRlbo/H4pWHxbIOd14dWlUKy1+EhufDYlL5pQ2L1/6cU2L2jnA+KcKSWVMRsJZHZvbcZ
	kgI3HYs2xtCwpM3r4XEuFRt8eZ+V0cyFi09yHxZvpTya13HqTAYAiPeDY68IkhJ+efDYc6SyaKm
	1FBdOL8gTRZZATh+l0ZMgjuVni+SI82PH7C8DUlNiF4WQWVCl/0Gxe5noEnL7MrN+doMy08pymO
	+poZ8PLqmYnubHNRFVnjDQRpg85ecb6bkTUO4GZ1xgY0BklS+CI2ovZxb/VNi2gYIE6CgvzICG2
	J6IdBHM908QFRplpg+3HlS2C4dI9Fg4ch0oGBZ0mmASsjjtoh8CALzstDAANhh+NtSXPga6sdzg
	MsPRlxfi54L17AhBYQjJWUYZN12MklPmA==
X-Received: by 2002:a17:902:f542:b0:2cf:9e90:8be with SMTP id d9443c01a7336-2d74e0a47b0mr118524575ad.4.1787996374029;
        Sat, 29 Aug 2026 02:39:34 -0700 (PDT)
Received: from cachyos-aura ([2409:40f2:3104:d691:c7eb:3b03:2c8d:127f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-328713b0451sm16446310eec.16.2026.08.29.02.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 02:39:33 -0700 (PDT)
From: Navon John Lukose <navonjohnlukose@gmail.com>
To: nika@nikableh.moe,
	emmanuel.grumbach@intel.com
Cc: helgaas@kernel.org,
	miriam.rachel.korenblit@intel.com,
	markpearson@lenovo.com,
	linux-wireless@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Navon John Lukose <navonjohnlukose@gmail.com>,
	bhelgaas@google.com
Subject: Re: [PATCH] x86/PCI: Disable D3cold on Intel BE200 Wi-Fi on Lenovo IdeaPad Pro 5 14IAH10
Date: Sat, 29 Aug 2026 15:09:22 +0530
Message-ID: <20260829093922.37103-1-navonjohnlukose@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729125202.33719-1-nika@nikableh.moe>
References: <20260722021321.68902-1-nika@nikableh.moe> <20260729125202.33719-1-nika@nikableh.moe>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I hit this on a Lenovo Yoga Pro 7 14IAH10 (BIOS QGCN35WW), same BE200 and
the same SUBSYS_00F48086 as your lspci dump, with an identical signature.
I think I can explain why your AML trace looks clean and the link still
does not train, and why Emmanuel's firmware-reset hunk made no difference.

Short version: PERST# alone does not restart this card once the rail has
been removed, and the reset that does is already implemented in iwlwifi -
it is just armed too late to ever run.

On my machine:

_PR3 -> PXP._OFF genuinely removes the module's rail; PON() then restores
power, waits PEP0, enables the source clock and releases PERST#. I checked
the pins directly via the ACPI GPIO accessors: after resume the power
enable reads 1 and PERST# is deasserted. So the firmware does everything
your trace says it does, and the card still does not come back. What does
bring it back is a third, WLAN-specific reset line reached only through
_PRR -> <pwrres>._RST.

That _RST is gated:

  Method (_RST) {
      If (RSTY == One) { ...toggle the WLAN reset... }   /* product reset */
      Else             { DCTR |= 0x8000; }               /* just an FLR   */
  }

Disarmed, it degrades to an FLR, i.e. asking a device with no power to
reset itself over a bus it is not on. That is the fallback that has been
running all along.

RSTY is set over the vendor _DSM by iwl_trans_pcie_set_product_reset(),
which iwlwifi already calls with EN_PROD_RESET|EN_WIFI_FLR|EN_BT_OFF_ON
for discrete parts. But it is only called from iwl_trans_pcie_removal_wk(),
once the device is already being torn down, and the _DSM dispatch is gated
on the firmware reading the device's PCI ID back out of config space:

  Method (WIST) { Switch (ToInteger (VDID)) { Case (0x272B8086) {...} } }

With the rail off VDID reads 0xffffffff, WIST() returns 0, and the arming
fails:

  scheduling reset (mode=6)
  ACPI _DSM not available (-19), cannot do product reset

So it can never be armed at the moment it is needed. I confirmed this
directly: with the device dead, evaluating the set-mode _DSM returns
success but RSTY stays 0.

Arming at probe instead, while the device still answers, makes the whole
existing path work. I will post two small iwlwifi patches for this as a
separate series and link it here. With them my card dies in D3cold on
every s2idle exactly as before, and comes back on its own in about 5s,
repeatedly.

Control: with the reset skipped but everything else identical, the device
stays absent (2/2), and recovers immediately once a real reset is issued.
So the reset is doing the work, not the remove/rescan.

Emmanuel - to your question, this is not a firmware reset during
suspend/resume. It only fires when the device is provably not answering
config cycles, which today is the case where the driver instead spends
~2s on handshakes with absent hardware and produces a bogus
ADVANCED_SYSASSERT dump.

Nika - I could not decode LTSM 0x32B either. Worth noting your sibling
port 00:06.2 reads 0x33/0x40 with its link up, so 0x01 does look like a
state the port never occupies while trained - but that is just my
observation, not a decode.

Caveats, so nobody wastes time: tested on one machine and one BIOS, on the
discrete (!integrated) path only. I have no integrated/CNVi hardware. The
recovery costs ~4.3s of Sleep() inside the platform's _RST, which is
firmware and not something we can shorten. And this is recovery rather
than avoidance - it keeps D3cold and pays a per-resume cost, where the
quirk in this thread avoids the problem entirely. I have not measured what
the rail actually saves, so I am not claiming it is the better trade, only
that the hardware can recover.

Thanks,
Navon
