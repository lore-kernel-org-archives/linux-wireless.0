Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1868B358360
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 02:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788487760; cv=pass; b=hbZpS612aIfYtgwK+lQ/UPIancw4yYf0Vfjulum0ZD/J6lKRR4zpOWjyyn0Fb/yzjfCI0nnlbQNWZYa43b5ERce2svoNWVfqf5CUoAwRaDzuv/YY2xrMoAr/O2lkeFnaTtreQ/vE40n0rlnZuE7/rqkf876P8dfFv53Xk6PYJgU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788487760; c=relaxed/simple;
	bh=F2Tl3Oq99eaTRWPWi9BlMv2aQ5wHxHe68M6ng1bSypA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=gUdBpoeumOwn5zzXpfjKt1nzGcZGgntlOxspFxfmOogQTktuDmJ8I9SqG4ZwxG2lAY0buOcrA3O5jTtmLpNoFxyv9xaD401ZW4bCDFtwsJ01Y0r9h20ueN1YYow5qQ0PcY845gss4ihB/fSLRnog3qcXeiEDK6YS69NOeoG5SZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=getscale.com.br; spf=none smtp.mailfrom=getscale.com.br; dkim=pass (2048-bit key) header.d=getscale-com-br.20251104.gappssmtp.com header.i=@getscale-com-br.20251104.gappssmtp.com header.b=ZOms6dTG; arc=pass smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=getscale.com.br
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=getscale.com.br
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=getscale-com-br.20251104.gappssmtp.com header.i=@getscale-com-br.20251104.gappssmtp.com header.b="ZOms6dTG"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-865bdc6ed72so9405497b3.2
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 19:09:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788487758; cv=none;
        d=google.com; s=arc-20260327;
        b=EPL8GvyVasdicZVZJ40huXLIVDlkjP+BEl6vPIqgk4D283soZd/mvv2WhfCmljr9cU
         Ge1OR9PEf+MUTCjG1TGfsDNRBw95+1jIrZd/Sho8UVWFfFjfwJ8AZRby+q/US2+2A6s8
         d7v9X2wbo56xJFj9UISCVsozDTVw8R/DSqnJvZJ5DJ8FAnu5kOqRjDtLUd479KjWAoRS
         KBkObM90G96M5Hqoati5kSJBp0I9QRmIoyVfRE0OFdqHm+QYFKUXcg7FAKGSbW8Zhuux
         1OBrFEPWkV3RPYhGeUHpysoJWoUMTdXZEeaeTce3qjEdKx3XmsNxvQpToYiSro+fyyUw
         KSoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Dug14hvQsvzMeLs0uApV/U5oLHS6a0LrtuhVRzKP7is=;
        fh=ZuJGCLgWhhZQBRvL4BMXaUkaKw+HFfqJjezqqFCKESo=;
        b=UWAeiOJH8W3wpLgOpHLqCBVEYWRNOgT8Ro0Za4PDgi1mQxL8KBzyI5iEyqQrC5sB8d
         BgntLUx6H+dvk4SBMqKl3VET6CRI2d6NZXz2D5qDMpr3d7jr6LiyNbI3xNaSsrKpQTIg
         Traxsbw7IC8qxcPwsaeobaTowJu1DpfAk9Ki+JzIJ9mDxJ7ukBuXiFaTSe996YVpRaIp
         f5GanLDwRYfZkx2A06cIL7ofaA+JEIsE0UaxSOtmCkLbNzirSMeg1/dlxD6+OaLVYyM1
         pSUARI+pra0/cDdaeEQsmiEBiWCWs2+4IQQi4HVohU3Tb4qYruy1YcWYCKyYottAwiMH
         Jhfw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=getscale-com-br.20251104.gappssmtp.com; s=20251104; t=1788487758; x=1789092558; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Dug14hvQsvzMeLs0uApV/U5oLHS6a0LrtuhVRzKP7is=;
        b=ZOms6dTGl28s17r9kqIW5fTNHISTp7BPm7n4Tak0yVLShWY4pHweaM+m8c7BBsdoX0
         WAv4Yh0/CZcThXdeXFjOQvlx47zMD7LrS9DxarG6f9bEOhmpxqeuTGLroB3vIBWZ+Jz1
         JoRS/NDlCfhKZ1v3dG42R6P6j+KwGIC3KT3fLQro4WDcps2iTEghtnEGhxnQ7I7cws1P
         o3QWxLbZr+YAI0Q/p4HZjGsn6UzQruA6IK/DTJeTPTVlsHYQEmVWqYLgS05U/YcuXbu0
         ucBnsih0Za2rK3wh2z6FjI3YUkPd0bcVr3DG6T6t8VZ7xhhsDltKpd6L3O4LZiYYgMI2
         B1AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788487758; x=1789092558;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Dug14hvQsvzMeLs0uApV/U5oLHS6a0LrtuhVRzKP7is=;
        b=Hghqn5mkT/beg3/CasRIEFpsHCXo/PdXjoH+tUh7wA6XYf7s+csa896halbPy9JLTm
         UnVmoHI/ySpnysqhBin3BFvQw5cheWhUMa4NZvdnVV+rn5uPVghcADStHdH4QubormZD
         NxZngeQIWnRalP37YaEW3Y3S9E+NUY9wFzDRIncub4bPxC18/RNhvQrUYn8+zDSZP9VZ
         2O/sug6EUepuogZ8UaTqEr62R0wMpHlRDxP7uQNVnVJeuHhhKtaKyVYVcC8jpbg7F9M9
         MJ+7uCKz/w5K5o6jc0nb9Ija+Ywtc4xxia+xw5NUR5SsgDoLkcT7E0AeOjEE3wC81k8+
         B1XA==
X-Gm-Message-State: AFuF++lCPpXVUTSpPa6HE9V4gN8yEt7QnxZZDR5eS5xCIyn4luC5ErNy
	4E/SgHEImVMRydLtjQhMsxXGJcfq2DbtSMKsvD+6OlnOq4ACf5I4D4clVJI18HWYdgqdcmbC6h7
	a7RT/aUBdqwPvDV6TtU3CYJeiQzcS2yQnQpUPU6hcQwNG6lbl1+NH
X-Gm-Gg: AYBFou0VT0sLXmVS0DhKlxYqzeQUTH3vqkPeyryFdWeG0RpvtOk6+3sIshqemzWXmys
	R69g5L+50403BSXyOnn8rH0cLcUaTFGHMaRXk76Ga8DeWl1p2hOSz1LjD0V5HXQDJIF/iNXkt1t
	L7B7LVPVQ55AXI1P7w4tQGhtGBnv2Y6NKBAw5TjtcFM9gVuYFhQcwxpqR8JQEj+cDgMrk7wrN0k
	IdEwyGgaRjp8ZuS2WXYgkVqi96nk1xxgbZ0ubID541uWBCHaOg7ZAyjy5RRFIFDJd0flQYRR22U
	MwuNnseSneme4pF0bQppmDZnZdBV3DwlSntlADUPhgZn6iOw3/rH+86Fe8tWzOmrQ6fthIAoK4q
	6zuh1GzyPCmS4dqcagNmxLcRPF4a2sFjOn5ybFP+8eEWiJhQI8PD+4o6eFIj5Q4MeReu99kHNFy
	+GG2Uf3NukcKewlG0/5mY+uoE9unUG6zlgored43DriYFzh01lz3MCrjqfuhRK52kRtMFQQ0/ER
	Ql+MyBs0mSvmbN98s+xKdeu/hBYoPkBtNF1Zd+1ABmWug==
X-Received: by 2002:a05:690c:e3c1:b0:858:1661:a43e with SMTP id
 00721157ae682-8711b9aaa64mr18533427b3.0.1788487757996; Thu, 03 Sep 2026
 19:09:17 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 3 Sep 2026 22:09:16 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 3 Sep 2026 22:07:35 -0400
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Mario Stanski Jr <mario@getscale.com.br>
Date: Thu, 3 Sep 2026 22:09:16 -0400
X-Gm-Features: AcwNN1XDaXtQz_DOP5De7wVOsTznIju6-tptNtJhslsZFFcD0SUEyHJNS-iMzqE
Message-ID: <CAJe=AAkCeK=-pVve0Ffw_k0UBp4_AiO5BwQ1d2yG-pVe8B0U4Q@mail.gmail.com>
Subject: [REGRESSION] mt7925e: firmware 20260813113118 causes severe low-RSSI
 5 GHz loss
To: linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	regressions@lists.linux.dev, jb.tsai@mediatek.com, jwboyer@kernel.org, 
	nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com, 
	shayne.chen@mediatek.com, sean.wang@mediatek.com
Content-Type: text/plain; charset="UTF-8"

Hi,

I am reporting a severe low-RSSI 5 GHz regression in the MT7925 Wi-Fi
firmware added by linux-firmware commit 3c11e660d3a8 (MR !1191).

On an MT7925/RZ717 PCIe adapter [14c3:0717], WM build
20260813113118 remains associated at about -70 dBm, but traffic suffers
23-29% packet loss, 1.2-1.8 s average RTT to the gateway, and HTTPS
timeouts. Replacing only the two Wi-Fi blobs with the previous pair and
reloading the same in-tree mt7925e driver loads WM build 20260605184805.
On the same AP/BSSID, machine position, kernel, profile and RSSI, gateway
loss becomes 0% and average RTT becomes 4.237 ms.

Firmware-only A/B results:

                         20260813113118       20260605184805
Gateway packet loss      23-29%               0/20 (0%)
Gateway average RTT      1.2-1.8 s            4.237 ms
Internet packet loss     about 29%            0/10 (0%)
Internet average RTT     about 3.7 s          15.109 ms
Three 1 MB HTTPS probes  2 connect timeouts;  3/3 complete,
                         1 partial timeout    4.18-5.25 MB/s

The partial newer-firmware probe received 293689/1000000 bytes in 8 s
(36702 B/s). After pinning the previous blobs, a longer confirmation at
-70 to -72 dBm returned 50/50 gateway replies (4.236 ms average), 20/20
Internet replies (15.548 ms average), and three further complete 1 MB
downloads at 3.91-4.60 MB/s. A separate acceptance run at -74 dBm also
had 0% gateway loss.

Environment:

  Device:          MediaTek MT7925 / AMD RZ717 Wi-Fi 7 PCIe
  PCI ID:          14c3:0717
  ASIC / HW-SW:    79250000 / 0x8a108a10
  Driver:          in-tree mt7925e
  Kernel:          7.3.0-rc1, x86_64, PREEMPT_DYNAMIC
  Distribution:    Arch-derived (CachyOS)
  NetworkManager:  1.58.1
  wpa_supplicant:  2.12
  Link:            WPA2-PSK, 5805 MHz/channel 161, VHT40, non-MLO
  Regulatory:      BR
  Power saving:    off in both runs
  Module params:   defaults; no experimental ASPM/CLC parameters

Firmware identities and uncompressed SHA-256:

  Regressed WM/Patch: 20260813113118 / 20260813113015a
  WIFI_RAM_CODE_MT7925_1_1.bin:
    23ff53b4bb639b30481e2e06bb1688569ad1ba971b897936db539882abfbd120
  WIFI_MT7925_PATCH_MCU_1_1_hdr.bin:
    8eb46014d2a6b4124472eee7476d995008a6f40b1daffef87eb42f30d98699e1

  Good WM/Patch: 20260605184805 / 20260605184651a
  WIFI_RAM_CODE_MT7925_1_1.bin:
    7e4ed27d1e9fe21cdefda35a22da32137b2473fada350617fb603489af19346a
  WIFI_MT7925_PATCH_MCU_1_1_hdr.bin:
    089dd0252a7eb95feed55950ad0fd9e6f751a07b4cf22273de722b73fa50d49e

The regressed firmware stays associated and no driver timeout/reset/AER
accompanied the failure. RSSI was effectively unchanged across the A/B.
Bluetooth firmware was not reloaded during the test.

The workaround is to pin the two Wi-Fi blobs from linux-firmware commit
bd1c66cfef5fb9cba15f1838a3fd222fb88a832b, then reboot or safely reload
mt7925e. No kernel parameters are required on this system.

References:

  Regression commit / MR:
  https://gitlab.com/kernel-firmware/linux-firmware/-/commit/3c11e660d3a8f8b35e12809b4b721a722b597148
  https://gitlab.com/kernel-firmware/linux-firmware/-/merge_requests/1191

  Previous known-good commit:
  https://gitlab.com/kernel-firmware/linux-firmware/-/commit/bd1c66cfef5fb9cba15f1838a3fd222fb88a832b

  Original submission thread (Message-ID
  <20260818010915.445782-1-jb.tsai@mediatek.com>):
  https://lists.openwall.net/linux-kernel/2026/08/18/60

  Full sanitized report and reproduction commands:
  https://github.com/openwrt/mt76/issues/1128

  Related low-signal report:
  https://bugzilla.kernel.org/show_bug.cgi?id=219429

Could you please confirm whether 20260813113118 is known to regress
low-signal 5 GHz transport, and whether the blobs should be reverted
while a fixed build is prepared? I can provide the recovery-safe A/B
script, full sanitized output, mt76 debugfs state or traces, and can test
a replacement firmware with the same procedure.

Regards,
MJr
