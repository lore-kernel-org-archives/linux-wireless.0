Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5123D3306
	for <linux-wireless@vger.kernel.org>; Sun,  9 Aug 2026 19:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786302187; cv=pass; b=ijdiaPBzaMDW583s9mAR4iSxLZOpBrWimOjBhFu2K6KrDPNL5dvWogMUTQ3Fk/YIx3NRP3nn6tbQEbvmSWaU73oKd7HmpeFXh6k9KudURvtH1ag6QFtChUwEwWQnknl1IVI+fpv901BuAPZHvttSNtxQlcjaONxB/z2TQDO2VDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786302187; c=relaxed/simple;
	bh=Tr85TjNTkZIACaSW1Ih8wVQSmk78sJ0coTL+2akjckE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=nyt8SNpumHz3YMS7MHnASAm0kwtVvhbx763wsYngTz86CU/issA2W2G2eB9ps/DFNzKS4dD1rMBffZ6VLADikPD9MkaocKm66/oDcU0G45aO2VNMIPpExHsSZuN9BMo+cLZIiwzn0M6L2H0M7EMCuDbTQsYJWEE5AaFYdtmRZ2E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ifkJB/MF; arc=pass smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ifkJB/MF"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b0117d49dcso895304e87.3
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2026 12:02:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786302166; cv=none;
        d=google.com; s=arc-20260327;
        b=BRfNg9fWXHhWzJ3LC+qpWMF0tApn5gz8xwgMOkLKKguLqxG3wQordEmMtj1LwJHYC1
         +uajg5aneyPahLq5d18BTBE7YmehJ/9KFhZ8uCUDsCUvlzeQanqW4EyUgp03g8lRtKRe
         k7Pdqrjtdxal8zMxrLFKcGF1o0BntzqJdRdxHQRVAFqiGC1jHc7zs95eKN0ydY7FFV0r
         t7IBUrqkhxNjsyRMZdiqrUlVob+Ku97FeGRDJROzh79guyHwV3lLm1eC/uQxv3B2RdHk
         rJlpNzgtaCwZwIqgCHwhz0Lwuhcw2k/N7ZeRZFxKlZ3HCtLoBPvsqQDIq4/XEiBYAqaN
         Alqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=kK/baEY+iyHIx6N7/Yc/rss5G3sNOiQswNXX/D/jPWM=;
        fh=+EaFIm9Pg2EPlH8IlJMKIpk6lzHRZbOSPszEEIdQBKM=;
        b=l9Qq2KOvecmMkMXuIXT4rfXA3UoxAkmVBGMlzBJus4bGQFUdAdFM9/SJSZB9LUNZKM
         +ZXwYg/k1FcdU4YSk2xBzddH09oanY+n0fnfzJbKhlTLoZyqaTbNW9o0b6souonByapz
         T4wOvqHBY+oNe4lN2bJR7pp44Vj/Ksu4yonSP8zRXJDXGGAHJkWzoM9r6EiLRxXoMfpS
         EtGnHbwE1PDAKrG4YVPcFiYwJRujwpfHoEGsOjfHGpv8/FNUeGXb7m/FwSEWiQQXEMLV
         fke5PUyKe0bb0fFIBH/aUW3OoW2zcZ6UQuJ+Q8VzAW5tPsLEhcrilXwayc9EJzXtm7v/
         up4w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786302166; x=1786906966; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kK/baEY+iyHIx6N7/Yc/rss5G3sNOiQswNXX/D/jPWM=;
        b=ifkJB/MF9ySaiWjI6AmHmvpFg9IPJViPf8M9j2SCc2gY2zva1KKE8mXFmaGGdUb4SL
         XaSf8PuhD/Spq/SLvUNOdPsEF6L7SI2s1kDp6afloj5aBQibx2QWl6MggTVlZ9w1Jwh1
         xAiuuu1hEaSebOHxPUTNZTuPRZYLGfM18EPBhegPKE9mhu6n2KQWPy+0w71muN/8mpLf
         diDYUo2KSms/A1DvxtSBSgfpSEYE7Ab4MvMW2YRjtJd0NgXaa9rBdxedNk+Eruyx0dF7
         LyReltU6UbkzJIs8G5llX+awUN6CLS30eLnwCpmp01WuqDNXE48dL7rZ9W8gFyAGv+5g
         kzAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786302166; x=1786906966;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kK/baEY+iyHIx6N7/Yc/rss5G3sNOiQswNXX/D/jPWM=;
        b=hBpBSMBtgGQPRJ0TleprgkzOdSmt+5HuVug8vfhZRMc2ltlrQfxwMXB30cDevus7BN
         AKZlVPjGVV3F3Q1Y66123rW/ntoP3/qV2+dJc3pa0vMNlMXmKLpvrLScnst7dSCOATQ/
         hiWDO6t0nlB5DxBBvfBO3vf3Cn5gKSolg35vsOoW5bSBhKY8UMJ2c6SwUBFmZ5IqAvIE
         flemqEUBYBGexZFAzZDQ/HlqFN1gGw78YU2Qszogwu23LIB6IYFB6IGvf1BHcpoEWiL6
         DOMTTWaetH5aC2oMaFzsKZkI8plU+40VUF1jcE6vCh6xUjTpyx+VKuLV+YniLBtSKeF8
         b5mQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqs8FC7tLujN17J0xPZmAIf51RVCPYipnp1EWud1H0amJfE0Ddm9Ho1aUKRt/w4qTEWSHSQpVrSVQJljvBh6A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+nbHuByEWaTaNl0R8repusYg2P8uraIEdtJ/S6xmi8q2amYB1
	+Fw/dUCK2arsNA72R/hZN68dTfSWCK7mSxUQATZahIfi/2jS9FQ5XpwW1tcSA9CIWNk5qRTU8AC
	niLyWCPR6Yow0oU4LiPQVvsU4MB1K8N0=
X-Gm-Gg: AR+sD10co+okBhXVdXun56NSm31SoCxIeOoOeTAb6USjA5LOP8xGla/BZlGMqVOlA+x
	B8kSuJGc7sS7TRwWUjOPB+S5HYN32FaEHUy19FPPtv9egypOJsHPI1IW+LbexNWDRNSXsskPgIu
	87ot7uXOv/3ONV6iGfuADziKycXYHn/P4y+a/sl2A2z7hPBgntG7lIRxBE+ieR5MKDP5iQ17iyb
	nBtF09iRdJWXmVegDQpcXj+psTRAqkB0CODpMI9JjhqPSXsoFgziGO0nYaI+xwQDX99tO20H0Cc
	U+C6g0P8lHTs3YdsxgFKsKV546VIbl2qjsz/AtrUDUy9QE4JgnCoYhmQnks6zYo69JUuZLAaGRu
	JO0DWksTMopFFwtA=
X-Received: by 2002:a05:6512:39ce:b0:5b3:e02:b398 with SMTP id
 2adb3069b0e04-5b30e02b54dmr1231733e87.44.1786302165841; Sun, 09 Aug 2026
 12:02:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jason Zeng <jasonzeng2009@gmail.com>
Date: Sun, 9 Aug 2026 12:02:34 -0700
X-Gm-Features: AUfX_mw0GrRobnvOBwc7j3_1MvOf25PTcnqEU1bZx91zZ2QtvD_WMJ9uPQSXbOk
Message-ID: <CAMe_HMpLsGEgW=1i6W6od_ADpEEDoMVgfNQ-4rWW==J=QNNPtQ@mail.gmail.com>
Subject: wifi: mt76: mt7925: false-positive hard rfkill on MSI Vector A16 HX (MS-15MM)
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>
Cc: Allan Wang <allan.wang@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, 
	Sean Wang <sean.wang@mediatek.com>, linux-wireless@vger.kernel.org, 
	linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Since v6.16, mt7925 Wi-Fi is unusable on the MSI Vector A16 HX A8WHG
laptop (board MS-15MM): the interface is reported as rfkill
"Hard blocked: yes" on every boot, and the block cannot be lifted from
software. Windows on the same machine works normally. I have traced
this to a false-positive hardware-rfkill report on this platform and
verified experimentally that the radio is actually functional.

Hardware
--------
- Laptop: MSI Vector A16 HX A8WHG (DMI: sys_vendor "Micro-Star
  International Co., Ltd.", product "Vector A16 HX A8WHG", board
  "MS-15MM"), BIOS E15MMAMS.104 (07/28/2025), EC 15MMIMS1.101
- WLAN: MEDIATEK MT7925 [14c3:7925], subsystem Foxconn [105b:e138]
- Kernel: 6.18.42 (also reproduced by other users on Arch/Fedora/Mint
  kernels >=3D 6.16; kernels of the 6.12 LTS era are NOT affected)
- Firmware: linux-firmware 20260622, WM firmware build 20260605184805,
  HW/SW version 0x8a108a10

Symptom
-------
- mt7925e probes fine, firmware loads fine.
- As soon as the interface is brought up, rfkill flips to
  "Hard blocked: yes" and the interface is taken down. The block
  persists for the rest of the session.
- NetworkManager logs "Wi-Fi now disabled by radio killswitch" ~1 s
  after activating the device.

Analysis
--------
Commit e54b870212c0 ("wifi: mt76: mt7925: add rfkill_poll for hardware
rfkill", first in v6.16) added:

  __mt7925_start():
      if (phy->chip_cap & MT792x_CHIP_CAP_WF_RF_PIN_CTRL_EVT_EN)
          wiphy_rfkill_start_polling(mphy->hw->wiphy);

  mt7925_rfkill_poll():
      ret =3D mt7925_mcu_wf_rf_pin_ctrl(phy);   /* MCU_UNI_CMD(RADIO_STATUS=
) */
      wiphy_rfkill_set_hw_state(hw->wiphy, ret =3D=3D 0);

On this platform the firmware advertises
MT792x_CHIP_CAP_WF_RF_PIN_CTRL_EVT_EN, and the RADIO_STATUS query
always returns 0 ("RF pin asserted"), so the wiphy is hard-blocked as
soon as polling starts. However, the pin state appears to be a board
wiring/EC defect on this MSI model, not a real kill switch: the radio
demonstrably works, and there is no airplane-mode state that can clear
it (toggling the airplane key, BIOS reset, EC reset, cold boot, and a
Windows full shutdown were all tried by various users without effect).

Experimental verification (on 6.18.42)
--------------------------------------
1. Fresh "modprobe mt7925e" with the interface left down:
   rfkill shows "Hard blocked: no".
2. "ip link set wlan0 up": rfkill flips to "Hard blocked: yes" the
   moment polling starts. Scans return nothing because mac80211
   immediately downs the interface.
3. With a one-line test patch disabling the poll registration in
   __mt7925_start() (rebuilt mt7925-common only, same kernel, same
   firmware): the interface comes up, "iw dev wlan0 scan" returns 19
   BSSs, and NetworkManager can connect normally. The radio is fully
   functional despite the firmware reporting the RF pin as asserted.

So on this platform the new hardware-rfkill support faithfully reports
a bogus pin state and disables a working radio. The Windows MediaTek
driver evidently ignores this pin on this machine, and kernels < 6.16
worked for the same reason.

Community reports of what appears to be the same issue (multiple users,
multiple distros, since around Dec 2025):
- https://discuss.cachyos.org/t/new-laptop-with-mt7925-wifi-adapter-being-h=
ard-blocked-rfkill/23872
- https://discuss.cachyos.org/t/getting-wifi-to-work-on-msi-vector-a16-hx-a=
8whg/27772
- https://forum-en.msi.com/index.php?threads/wifi-hard-blocked-on-msi-vecto=
r-a16-hx-a8whg-linux-ubuntu-24-04-acpi-bios-bug.418090/

(One user in the second thread reported to linux-mediatek earlier this
year; I'm adding the root-cause analysis above.)

Possible fixes
--------------
Would a DMI-based quirk (or a PCI subsystem-vendor/-device based one,
[105b:e138] on this board) that skips wiphy_rfkill_start_polling() on
affected platforms be acceptable? Alternatively the poll result could
be cross-checked before hard-blocking (e.g. ignore a pin that is
asserted from cold boot and never changes state), or a module parameter
could allow affected users to opt out.

I'm happy to test patches on this hardware and to provide any further
debugging output (full dmesg, MCU traces, ACPI tables =E2=80=94 note this
BIOS also has duplicate \_SB.PCI0.GPPA/WLAN power objects that ACPICA
rejects with AE_ALREADY_EXISTS at table load; that turned out to be
unrelated to the rfkill issue, but I can share the tables if useful).

Raw data
--------

lspci -nnk:

  05:00.0 Network controller [0280]: MEDIATEK Corp. MT7925 802.11be
          160MHz 2x2 PCIe Wireless Network Adapter [Filogic 360] [14c3:7925=
]
          Subsystem: Foxconn International, Inc. Device [105b:e138]
          Kernel driver in use: mt7925e

Driver probe (dmesg):

  mt7925e 0000:05:00.0: ASIC revision: 79250000
  mt7925e 0000:05:00.0: HW/SW Version: 0x8a108a10, Build Time: 202606051846=
51a
  mt7925e 0000:05:00.0: WM Firmware Version: ____000000, Build Time:
20260605184805

Typical boot (journal):

  NetworkManager: rfkill1: found Wi-Fi radio killswitch
    (at /sys/devices/pci0000:00/0000:00:03.2/0000:05:00.0/ieee80211/phy0/rf=
kill1)
    (driver mt7925e)
  NetworkManager: manager: rfkill: Wi-Fi now disabled by radio killswitch
  wpa_supplicant: rfkill: WLAN hard blocked

Experiment, unpatched 6.18.42 (phy index varies across module reloads):

  # modprobe -r mt7925e && modprobe mt7925e     # interface left down
  # rfkill list
  2: phy1: Wireless LAN
          Soft blocked: no
          Hard blocked: no
  # ip link set wlan0 up && iw dev wlan0 scan   # scan returns nothing
  # rfkill list
  2: phy1: Wireless LAN
          Soft blocked: no
          Hard blocked: yes

Experiment, same kernel/firmware with the test change below:

  # ip link set wlan0 up && iw dev wlan0 scan | grep -c '^BSS'
  19
  # rfkill list
  3: phy2: Wireless LAN
          Soft blocked: no
          Hard blocked: no                      # stays unblocked; NM
connects fine

Test change used for step 3 (diagnostic only, not proposed as the fix):

  --- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
  +++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
  @@ __mt7925_start()
  - if (phy->chip_cap & MT792x_CHIP_CAP_WF_RF_PIN_CTRL_EVT_EN)
  + if (0 && (phy->chip_cap & MT792x_CHIP_CAP_WF_RF_PIN_CTRL_EVT_EN))
    wiphy_rfkill_start_polling(mphy->hw->wiphy);

Thanks,
Jason Zeng
