Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ED63E2ABC
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 18:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785090092; cv=none; b=KpXKieQySIFXTHoF76c1D0PKL6w7NfQoSJk+ekPGCVvbKBu8Oq3Fw2O5zi4MfczqOyDqRXs3J85B8w/7MO8X93bJu9OyQIWa7a7jFsXagjmxtLXMQx7B9WZZqGKz8MSPse1drjhWACqEQi1Xc7nbiSXQVsq2m6fg4WwB9yRbKr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785090092; c=relaxed/simple;
	bh=Jpe9nMj8D/r5dEewuZKM12VFxKoRQ5AdR/UYBCopHj0=;
	h=MIME-Version:From:To:Cc:Subject:Message-ID:Date:Content-Type; b=GHiuqtHR8QbzFIxW0jIMXz3VHajFWtm+1KW3McGsXquw2dUr6eWtmepwg7pifeo7gomDLknwZEw6gP5rlQ8ObyFNuuZFTzKcrH3Q6Jcn5ewki0BdV6hr5wYPU6Q3qGyLhm2Omz0La7u3ZgJO3egOF44OzARf5a70imlubFihMAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=recursiveintell.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=recursiveintell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-9696369925aso593265241.0
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 11:21:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785090089; x=1785694889;
        h=content-transfer-encoding:content-type:date:message-id:subject:cc
         :to:from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ONmVHlBZvOI0iD4ajPdXD82wwgbRBXTGldDTbVh27Yk=;
        b=L035COMlte1IUq7WxUY8EdHgOFHOZ1M8Z0Ks0JRfpKhisa08Mc83ewY8CAGQEPgNPR
         Ae8R+eQDKARpVPg5kyBgKa8K3ntNsMn6fVVONexIR+e/dA7k3mk5GTAr4ocLWsukN6/u
         PHgj10BoQ8UqZK1SFCDld0si6+cK3Q5VC4I6BZHiaoUsExZHIAWlmjiIItMHC+O4yKvc
         aZNYSuz8HcbD3rLneqgPxvck2i5deuX3PikL4JzMtFP0GD/lbdJq9b3NAmdFohQYbQUw
         Ck4b5OVuOedv1VQaeQNUlAscqh6Kzyd3Bd/wlraMW0STp4I4oNdooRVucaPbAgUYZFMS
         nIcg==
X-Gm-Message-State: AOJu0YzGsHVw+K3ebXoLa9VH9fpxQxkKyoQHC2wLOIbVmiPTLJ9MQMgE
	YnQZBlJNhouLJd74w66NYJGVgnXF37R7JgJQMEr1FAIKNOvRXFBHEvyANc+lkxgc
X-Gm-Gg: AR+sD13CaY7xgmi4qCDkA6oBsdHwbxIMV74VB8sncFdm+jBFXfBBaUcPbLw3TLSgGuB
	vhNMSZWIKFTiw66wa8orH1x2lpD5jJHJLuha24pcZHyWAL3x2O+3xuPSskIcNhlg9ORPUCrUdSr
	1eTliXoqTllTP363L7mqvyvZoK5RFSi6BYCYE7G70hPQPCPJBtbHg9vR4Zj0mbE210GhcGQ7TPq
	pP0oKqvflbXbykmQSGfq0kaOMkPStF80bVikJv7+N8VqdmrX9U8ImbnBAHLdAJWTXnCHQ0RD6GJ
	fgs8+l9IP3oGjx4DvdPmse+t7F0AYjemfYzaqHhtFIWMByvVTS++EfuLa26IWZTBGC+j+3TVjIx
	Ikm+jQCA2cWdmf28PzMuryPzl4Khim/o6JlmgO/upHupstgHzDc6NrouDurjzyfYvcIBZSsCgGA
	Fjxm5n
X-Received: by 2002:a05:6102:3711:b0:739:8c52:f2b with SMTP id ada2fe7eead31-7503fb97f37mr2910608137.18.1785090088901;
        Sun, 26 Jul 2026 11:21:28 -0700 (PDT)
Received: from nobara-pc ([75.138.15.254])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-75033d6a692sm3933201137.1.2026.07.26.11.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 11:21:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Josh Stevenson" <josh@recursiveintell.com>
To: <linux-wireless@vger.kernel.org>
Cc: <pkshih@realtek.com>, <kvalo@kernel.org>, 
	<linux-kernel@vger.kernel.org>
Subject: [BUG] rtw89_8852bte: Recurring firmware crashes (LBC watchdog / SER)
	 on RTL8852BE-VT despite ASPM and PS disabled
Message-ID: <18c5e9fa2f7b7f5e.f55361b117e95aa2.460cfd9fd11f5e9a@nobara-pc>
Date: Sun, 26 Jul 2026 18:21:28 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I'm experiencing recurring firmware crashes on a Realtek RTL8852BE-VT
Wi-Fi adapter. The crashes happen every 30 minutes to several hours
during normal use, with 990 crash events logged in the current boot
(2 days 11 hours uptime). The firmware auto-recovers via SER (System
Error Recovery) each time, but connectivity drops briefly.

This is a known issue reported by multiple users (e.g., Arch Linux
forum post [1]), but I have not found an existing upstream bug report
with full diagnostic data.

[1] https://bbs.archlinux.org/viewtopic.php?id=3D290480

## Hardware

- Laptop: HP Laptop 15-fc0xxx (baseboard 8DC7)
- Wi-Fi: Realtek RTL8852BE-VT PCIe 802.11ax
  PCI ID: 10ec:b520 (subsystem 10ec:b520)
  Module: rtw89_8852bte (depends on rtw89_pci, rtw89_8852b)
- CPU: AMD Ryzen 7 7730U
- OS: Nobara 43 (based on Fedora 44)
- Kernel: 7.1.3-200.nobara.fc44.x86_64
- Firmware package: linux-firmware-20260622-1.fc44
- Firmware files: rtw8852b_fw.bin, rtw8852b_fw-1.bin, rtw8852b_fw-2.bin
  (dated 2026-06-22)

## Already-tried mitigations (no effect)

The following module parameters are set in /etc/modprobe.d/ and
confirmed active, but crashes persist:

  options rtw89_pci disable_clkreq=3Dy disable_aspm_l1=3Dy disable_aspm_l1ss=
=3Dy
  options rtw89_core disable_ps_mode=3Dy

NetworkManager Wi-Fi powersave is set to disable (value 2).
iw dev shows "Power save: off".

## Crash pattern

Crashes occur in bursts of 3 SER events:
  1. R_AX_LBC_WATCHDOG=3D0x00000081
  2. SER catches error: 0x1000 (L2 reset)
  3. SER catches error: 0x1001 (L1 reset)
  4. SER catches error: 0x1002 (firmware reset)

Each burst takes ~30ms. The firmware then auto-recovers and
NetworkManager reconnects within a few seconds.

Total crash events across 15 boots: 13,395+
Peak boot: 3,060 crashes in one session.

## Complete crash log (one representative event)

Jul 24 01:20:26 nobara-pc kernel: rtw89_8852bte 0000:01:00.0: R_AX_LBC_WATCH=
DOG=3D0x00000081
Jul 24 01:20:26 nobara-pc kernel: rtw89_8852bte 0000:01:00.0: <---
Jul 24 01:20:26 nobara-pc kernel: rtw89_8852bte 0000:01:00.0: SER catches er=
ror: 0x1000
Jul 24 01:20:26 nobara-pc kernel: rtw89_8852bte 0000:01:00.0: FW status =3D =
0xa1001100
Jul 24 01:20:26 nobara-pc kernel: rtw89_8852bte 0000:01:00.0: FW BADADDR =3D=
 0x0
Jul 24 01:20:26 nobara-pc kernel: rtw89_8852bte 0000:01:00.0: FW EPC/RA =3D =
0x0
Jul 24 01:20:26 nobara-pc kernel: rtw89_8852bte 0000:01:00.0: FW MISC =3D 0x=
b8900635
Jul 24 01:20:26 nobara-pc kernel: rtw89_8852bte 0000:01:00.0: R_AX_HALT_C2H =
=3D 0x1001
Jul 24 01:20:26 nobara-pc kernel: rtw89_8852bte 0000:01:00.0: R_AX_SER_DBG_I=
NFO =3D 0x1000000
Jul 24 01:20:26 nobara-pc kernel: rtw89_8852bte 0000:01:00.0: [ERR]fw PC =3D=
 0xb898815b
Jul 24 01:20:26 nobara-pc kernel: rtw89_8852bte 0000:01:00.0: [ERR]fw PC =3D=
 0xb89880f3
Jul 24 01:20:26 nobara-pc kernel: rtw89_8852bte 0000:01:00.0: [ERR]fw PC =3D=
 0xb898815d
[... more fw PC entries ...]
Jul 24 01:20:26 nobara-pc kernel: rtw89_8852bte 0000:01:00.0: SER catches er=
ror: 0x1001
Jul 24 01:20:26 nobara-pc kernel: rtw89_8852bte 0000:01:00.0: FW status =3D =
0xa1008100
Jul 24 01:20:26 nobara-pc kernel: rtw89_8852bte 0000:01:00.0: FW BADADDR =3D=
 0x0
Jul 24 01:20:26 nobara-pc kernel: rtw89_8852bte 0000:01:00.0: FW EPC/RA =3D =
0x0
Jul 24 01:20:26 nobara-pc kernel: rtw89_8852bte 0000:01:00.0: FW MISC =3D 0x=
b8986657
Jul 24 01:20:26 nobara-pc kernel: rtw89_8852bte 0000:01:00.0: R_AX_HALT_C2H =
=3D 0x1002
Jul 24 01:20:26 nobara-pc kernel: rtw89_8852bte 0000:01:00.0: R_AX_SER_DBG_I=
NFO =3D 0xf1000000
Jul 24 01:20:26 nobara-pc kernel: rtw89_8852bte 0000:01:00.0: [ERR]fw PC =3D=
 0xb89a1ea3
[... more fw PC entries ...]
Jul 24 01:20:26 nobara-pc kernel: rtw89_8852bte 0000:01:00.0: SER catches er=
ror: 0x1002

## Observations

1. The crash trigger is R_AX_LBC_WATCHDOG=3D0x00000081 =E2=80=94 the LBC
   (LPS Boundary Check) watchdog fires, indicating the firmware
   stopped responding.

2. FW BADADDR varies: 0x0, 0x4444, 0xaaaa =E2=80=94 suggesting different
   crash sites in the firmware.

3. FW EPC/RA is always 0x0.

4. The fw PC values cluster around 0xb898_xxxx and 0xb89a_xxxx,
   suggesting the firmware is crashing in the same code regions.

5. Disabling ASPM, clkreq, and power save mode does NOT prevent
   the crashes. This suggests the root cause is in the firmware
   itself, not in the driver's power management integration.

6. Auto-recovery via SER works reliably =E2=80=94 the Wi-Fi reconnects
   every time. But the brief connectivity drops are disruptive.

## Questions

1. Is this a known firmware bug? Is there a newer firmware version
   available or in development?

2. Are there any driver-side workarounds to reduce LBC watchdog
   triggers (e.g., adjusting watchdog timeout, disabling LBC)?

3. Would a newer kernel version (e.g., mainline) have rtw89
   patches that address this?

4. Is there additional diagnostic data I can collect to help
   narrow down the root cause?

Thank you for your work on this driver.

Best regards,
Josh Stevenson
