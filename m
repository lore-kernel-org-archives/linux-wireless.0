Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.27
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792658782;
	b=1pXzZCjfaaUzLjhvghDny78ouc9mT8WZXv2Hsf0vaSiwTIl6CNW3npXcKKLRTZq1LudW
	 1Jtivd2a0/xjC2Yp3e4tRqMOw5QfPaZnQml8DegQHXMnBgU2ua5HaQXzGSPmdpKxTkMg9
	 0coYCpXtm7OiPU6dZGjOvKBat52gCYp4cGOp7THuSz1/GFzA55csbIqeV+bE0iZas/P1f
	 6CREiAMh1fZ+oYt2cKxSb6jJNNbRWMq3uSFO9ASo3uwNU8vJN7R8EICbTrT8i6gEEQOWa
	 eLOvYGXyUjBkII6dgm5UV7CA2euYXs/AHjfDpO1biT1BVp0XaYmnJHgxdO78kPcmZbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792658782;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=7UpZyCZRkDFVI3JJm3sHmXMHrFiDViDiRuCXKOCySmQ=;
	b=dLka9ot5y0+FVnEXpfmoBgx8eGwrPKo4Wth3AJGpX1kEC1d/cZ+7gC7eio1iNvXi/vIF
	 mxFduk9OX3RLO6etbCvJNAR3ICbju2Ks2ZJ7f4NgYRlbEwhRGq+avhaaxDLR35qTWMNTB
	 84kFXpwIPQNMpjaAgx2RK8o8IDHq3wvtiH8+teLW65hgtRWgN8CKa6lshxBcca9KUWZ85
	 AQSpiGDC7GBkMY7+09rH79Mjv7zlBbuRRAGxa3zquM51Rec/Fg2g4LIWTvaklHNs4kjee
	 rR7Jn7sdWv+68Shj+v7obWnsg1ESmTAkLDAmVQdaDYZVyeob0vLXfBcGzIui3ypABkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.ch;
	spf=pass smtp.mailfrom=protonmail.ch;
	dkim=pass header.d=protonmail.ch header.i=@protonmail.ch header.a=rsa-sha256 header.s=protonmail3 header.b=eexnfA+1;
	arc=none smtp.remote-ip=109.224.244.27
Received: from mail-24427.protonmail.ch (mail-24427.protonmail.ch [109.224.244.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C02C606A319
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 08:46:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C02C606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=protonmail.ch header.i=@protonmail.ch header.a=rsa-sha256 header.s=protonmail3 header.b=eexnfA+1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
	s=protonmail3; t=1792658779; x=1792917979;
	bh=7UpZyCZRkDFVI3JJm3sHmXMHrFiDViDiRuCXKOCySmQ=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=eexnfA+1Qp1F5DxiIEJEfdIHcYodmby0m+yZqRPZ8srk1Wl1LYAJY5OhDVwNmgcdj
	 n8iCH8wY0eK9KvccbeuBYDn6LPFhHTLrN5hFiar9F6rLqXkf5ZVAZTufmtBAhtIKUN
	 m3pxH+MuOiwWdFCzGtIVf/CzGZybVDRrkmcVHllt9V7B/xkVRbybakNaVODDxBipkc
	 MTpTWM8xniRXBDFLcoSVoYWlXZnrMj8M3cheFtRjYH4c/ajvPjhxlBalP3Cvi4/PIW
	 uAE15upQSzLkYLE3bsE9I6sAU907pkEJ0GCqVOW1EmNtdFoixUMOAyqfMPtgPMuwu5
	 UnNpYgILBHcHw==
Date: Thu, 22 Oct 2026 08:46:17 +0000
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Shalok Shalom <shalokshalom@protonmail.ch>
Subject: [Bug report] rtw89_8852ae: WoWLAN resume fails with "c2h reg timeout" and "failed to resume for wow -110" on s2idle
Message-ID: <zvVKbBQduN7iovmmy-oy6UZgR0AOBhnGgl9YuUrYtH48IGxvXoTr-iRZbEp-XyQgxq7LNuQxwRJ16cjQziq2sUKpe4b8UeSr6cNS46TBJQM=@protonmail.ch>
Feedback-ID: 1182871:user:proton
X-Pm-Message-ID: f8b96389b5b6695f4e4584114584d08cbc924683
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

I am reporting a reproducible failure in the `rtw89` driver for the Realtek=
 RTL8852AE (PCIe) when using Wake-on-WLAN (WoWLAN) with `s2idle` suspend. T=
his does not happen always, but frequently.=C2=A0
The system fails to resume from suspend when a magic packet is received, an=
d the kernel log shows a firmware communication timeout followed by a failu=
re to swap back to normal firmware.

The failure begins at `rtw89_fw_read_c2h_reg()` (the C2H timeout), which ca=
scades into the AOAC read failure and the firmware swap failure (`-110`). T=
he driver's recovery path has been hardened against a subsequent crash (CVE=
-2025-21730), but the initial timeout on the PCIe interface during `s2idle`=
 resume is not resolved by any patch I could identify in the current source=
 tree.


Hardware and Software Environment

-   Laptop: Lenovo Yoga 7 Carbon 14ACN6
   =20
-   Wi-Fi: Realtek RTL8852AE (PCIe)
   =20
-   Kernel: 7.2.11-zen1-1-zen (Zen branch) and=C2=A06.18.57-2 (LTS branch)
   =20
-   Firmware: rtw8852a_fw-1.bin, version 0.13.36.2
   =20
-   Sleep state: s2idle (S3 is not exposed by the firmware; confirmed via `=
cat /sys/power/mem_sleep`)
   =20
-   WoWLAN trigger: magic-packet only (`iw phy0 wowlan enable magic-packet`=
)
   =20
   =20
   =20

Steps to Reproduce

1.  Enable WoWLAN: `sudo iw phy0 wowlan enable magic-packet`
   =20
2.  Suspend: `systemctl suspend`
   =20
3.  Send a WoL magic packet to the laptop's Wi-Fi MAC address from another =
device on the same network. (Via OpenWOL from Android)
   =20
4.  Observe: the laptop does not wake.
   =20


Output of lspci -nnk

01:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8852A=
E 802.11ax PCIe Wireless Network Adapter [10ec:8852]
Subsystem: Lenovo Device [17aa:4852]
Kernel driver in use: rtw89_8852ae
Kernel modules: rtw89_8852ae

Actual Behavior

The system fails to resume from `s2idle`. The following `dmesg` sequence is=
 captured after a failed wake attempt:

[ 2359.543559] rtw89_8852ae 0000:01:00.0: c2h reg timeout[ 2359.543563] rtw=
89_8852ae 0000:01:00.0: wow: failed to get aoac rpt by reg
[ 2359.644802] rtw89_8852ae 0000:01:00.0: wow: failed to get aoac rpt by pk=
t
[ 2360.305270] rtw89_8852ae 0000:01:00.0: failed to check wow status disabl=
ed
[ 2360.305278] rtw89_8852ae 0000:01:00.0: wow: failed to check disable fw r=
eady
[ 2360.305280] rtw89_8852ae 0000:01:00.0: wow: failed to swap to normal fw
[ 2360.305282] rtw89_8852ae 0000:01:00.0: failed to disable wow
[ 2360.305285] rtw89_8852ae 0000:01:00.0: failed to resume for wow -110
[ 2361.916657] rtw89_8852ae 0000:01:00.0: rtw89_hw_scan_offload failed ret =
-110
[ 2361.921475] rtw89_8852ae 0000:01:00.0: failed to set wakeup event
[ 2361.921483] rtw89_8852ae 0000:01:00.0: failed to suspend for wow -1


Expected Behavior

The system should reliably resume from `s2idle` when a magic packet is rece=
ived.


Workaround Already Tested (Falsified)

The following have been tried and did not resolve the issue:

-   ASPM/PS module parameters: The following parameters were set and verifi=
ed as active (`Y`), but the failure persisted:
    `options rtw89_pci disable_clkreq=3Dy disable_aspm_l1=3Dy disable_aspm_=
l1ss=3Dy`
    `options rtw89_core disable_ps_mode=3Dy`
   =20
-   `` `disconnect` trigger: The failure occurs even when WoWLAN is configu=
red to wake on `magic-packet` only.  ``
   =20



Conclusion

The failure appears to be a race condition in the `rtw89` driver's firmware=
 communication layer during the WoWLAN resume path in `s2idle`.=C2=A0
A related patch for USB devices (`rtw89_fw_read_c2h_reg` timeout) exists, b=
ut it is explicitly scoped to USB transport (RTL8851BU) and does not apply =
to this PCIe device.


ShalokShalom
