Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793735105;
	b=0R+iFWtpXp8Zm3xooMnertJM8h3nYWm3TSMgQq8cQiS5GBXy+fztYYsW/SJ+2vz66lPe
	 EcRmANEvsAe7fHsR68WjaR1uMxMF9o9DA1I14VoZScdJIlbeCeodjN5nlHnar0Qqnci6I
	 vg9QiIu6xuS3TOYoR6wqYqgFVYfx1lrbu0GDq2qZ/BGDGkFQahib9EoPz3iOYAmWujNAN
	 149z7/XNQhkMTtRBljMNvV1S8r76ZOWMgIheFHl5nKNYtiOKaxVQxwexyFsNgvNdqJfrl
	 C5x9wyS+mj0T5HbVu/FGKinWo5LpWeYDxYu1GWZS1erjv8tqZsdAzD5qvdxYgrHb1Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735105;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=2NxF2EJvNe9HutfjzaiaV0fUg6tWLxFHd70JA4aRkJs=;
	b=sOVwkGZXLaO6PRdz8hdS8GiwX7i7p+Lxyqtvjw+owwsjvydGI+LT7GuTWX7SpMDB3c3Z
	 J3t57RhpWx3uF6vziZJYM6MmfQ1966AjUHsMGqAOLlS50RCKc+P6ZczmaODhjYPpk847d
	 PLIEjiVXleR4kSmflzSPCd6l3gXLB2ty3JGY6yR3nSkyov/AEJycLwcHcGJdkesSuildW
	 sNjEk2uK7EVoIfzOBlGVGpCjMNUiZQb0hNMB4Xk1a3Gl9riVXiS+vxrEUJKKayFvAN1dB
	 UB26sF3RXlnHCoX0fR0Lw73Ad0L5CCO4tKlVIDfPosdVUVEoUWdiUoRZvjiHLwsrrJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yAGEsWXk;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C8D606A31B
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 19:45:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45C8D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yAGEsWXk
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48af4d4e61fso2819972f8f.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 11:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793735103; x=1794339903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2NxF2EJvNe9HutfjzaiaV0fUg6tWLxFHd70JA4aRkJs=;
        b=yAGEsWXks5Od7KjmN5J1BHpqOYr4HbyRKK7nH8X7fgDI1bJSdl+owJIolG39h94fh5
         Y27TXUdAW90JECMxDSTGt3c/Yyde0RAqKOzbj0bIw4DYcAq7TGGoVGUyTWt74uf1JjQJ
         GmhcguSoe/XZi90zPNc5ETio1qC5qHGTUKZCMlg+k2cyc08qFWwf5bgOZDLerukNzEb6
         sE6ynlLNfEX2azuvrZSo0JlWMDoujJTGpryChcAztRJu1F9066e8QrIl0WhOE7hmxHO6
         9KROBkoxI/kGseOgviSt1Xv3brOv7ObViFPzcLlGuzY3bJKFX4B59H1duiCtyQKjBxcM
         w77g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793735104; x=1794339904;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2NxF2EJvNe9HutfjzaiaV0fUg6tWLxFHd70JA4aRkJs=;
        b=Yy/r0VvTGNTVq6bVX/1kP782+4+EdxNDY0F3UrwkP5eL5sYAG7rXOV0nHtTV2Q8xJy
         dePw+ERTZaqOQAUiHFoMV9XRaS/NWtMJ/36exshDq9poJi9JjFopzhRL92bAXWfvkfSV
         Cj7NxUQq40/rBsvri64c2VMF/qbwzL7RSWqo38oNfLUOP5OlCCuiHrCaalR1WEpqn3la
         OXpABFpVsAMy+uVJFAZfWgp1Go9Drp9ZLF5ciqWj+RB4jjj05yXef1dqVQV5UxPq7Dya
         QLBa0OqoE2e0W8yv6Y56eJiXjLI1+66wJjMnow9OsNSv8zsp03B43ET7pGACdXMdRlpH
         uz6g==
X-Gm-Message-State: APuU4Z+sqi2EQEygByVdRTsUyvrMMicpqKSoVCkCpLJLUubeG4/khJ6+
	tSFSaUDwTzwRI53nyeHlJlyAizxM2+BCzo9I04vKB4/QU3ymWtktwAdPpV+Onl05
X-Gm-Gg: AYBFou3tEi5tFqBJ5MeikH2Ktf74WLDJFeH9Zwl4ytHfqJ95yC9rxrqGw94jopaLfqe
	QtJyTWQFXKfjlOY7xklPdXcSPBg76OqbKlAXQYUrOtB/UjunQJo+wd+Q8ehl8G7Rqwmjqluzenz
	qXKBUDNSl+E9l49uDFU4OHmTMy/zKi69mFPmLmmrixnS7baTBIs74rPvmcj/yhiBbFI3JAewbb2
	Tpav0RfOwbxczu2FoTe3uaP4xrxyf2q6s2EfzMBPsVWV55pA4Zn86Ie/F5IN9U+6dFBXNf1frZq
	m5GbdT3g4XFBB2K9xBPxXZGDy1tq1EZXtfSDMvw++mwjBzo9qP3FFsCx5ybdkb2h7TU5WjzsypY
	cGhocDOn+V5CUaee8xT1M4GyVFDaodguE7y1ejK6LK+qR0EU7ylx8/iF2TSsuLCKs5VDdlM9GWe
	3gdsRImJHqaXaY/9xk64N/NbLe7b+MKPEakkSvs/T/8eM26m3wXNY+LSaydusEXUDXo+RtptR8R
	b2NMVB8vT+cvRiD7pAxcpFGlagvUkQ4HDJBQ3EucGzWbUifuMLn9aUHYYxRgIWY3Ocb5LyUK9o6
	PgATh8YKnhHFMyYwmz+LLsR+ypOd/aWuGlyG8XOkoFfs4aLATVgSTPehD6A3wg==
X-Received: by 2002:a5d:5d06:0:b0:48e:5fd8:5822 with SMTP id ffacd0b85a97d-48e6e2f66c1mr31809933f8f.18.1793735103321;
        Tue, 03 Nov 2026 11:45:03 -0800 (PST)
Received: from KYK-Workstation.. ([2a00:1d37:22b2:4600:f1fc:7ef0:5b92:7f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fc9b819d2sm337822f8f.4.2026.11.03.11.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 11:45:02 -0800 (PST)
From: Kadir Yavuz Kurt <k.yavuzkurt1@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org
Subject: [BUG] wifi: rtw89: 8922ae: no association until module reload
Date: Tue,  3 Nov 2026 22:44:54 +0300
Message-ID: <20261103194454.14002-1-k.yavuzkurt1@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ping-Ke,

I have an RTL8922AE (PCIe) that cannot associate with any AP after the
driver probes at boot. Scanning works and APs are listed, but the
interface never sends an authentication frame. Unloading and reloading
the driver fixes it every time, until the next reboot.

This is 100% reproducible here: 9 consecutive boots recorded in the
journal, 9 failures on the initial probe, 9 successes after a reload.

I was unable to pin down the root cause, so I am reporting the data I
have rather than guessing.


Hardware / software
===================

Board:      Gigabyte X870 AORUS ELITE WIFI7 ICE, BIOS F8
Adapter:    07:00.0 Network controller [0280]: Realtek Semiconductor
            RTL8922AE 802.11be PCIe Wireless Network Adapter
            [10ec:8922] (rev 01)
            Subsystem: [10ec:8922]
chip info:  CID: 71, CV: 2, AID: 6933, ACV: 1, RFE: 1
Firmware:   rtw89/rtw8922a_fw-4.bin, version 0.35.80.3 (8ef4f0cf)
            (linux-firmware 20240318.git3b128b60.0ubuntu3.1)
Distro:     Ubuntu 24.04.5 LTS
Kernels:    7.0.0-42-generic and 6.17.0-23-generic (Ubuntu HWE)
            Both affected, identically.
Userspace:  wpa_supplicant 2:2.10-21ubuntu0.4
            NetworkManager 1.46.0-1ubuntu2.8
AP:         WPA2-PSK (no WPA3/SAE, no PMF), 2.4 GHz ch 11 and 5 GHz
            ch 36, signal ~67-77


Symptom
=======

After boot, wlp7s0 comes up and scans normally. `iw dev wlp7s0 scan`
returns 60 BSSs including the target AP. But wpa_supplicant loops:

    supplicant interface state: disconnected -> scanning
    supplicant interface state: scanning -> disconnected

every ~10 s, and after 25 s NetworkManager gives up:

    Activation: (wifi) association took too long, failing activation
    state change: config -> failed (reason 'ssid-not-found')

The 'ssid-not-found' reason is misleading: the AP is present in scan
results throughout.

The decisive observation is in the kernel log. In the broken state
there is no

    wlp7s0: authenticate with xx:xx:xx:xx:xx:xx

line at all. mac80211 never starts authentication; it does not fail,
it never happens. Immediately after a module reload, the first attempt
goes through cleanly:

    wlp7s0: authenticate with 14:8c:4a:6a:c4:ff (local address=...)
    wlp7s0: authenticated
    wlp7s0: associate with 14:8c:4a:6a:c4:ff (try 1/3)
    wlp7s0: associated


Reproducer
==========

1. Boot the machine.
2. Try to connect to any WPA2 AP. It never associates.
3. Run:
     modprobe -r rtw89_8922ae rtw89_8922a rtw89_pci rtw89_core
     modprobe rtw89_8922ae
4. Connect again. Works immediately, every time.


What does and does not recover the device
=========================================

This is the most useful thing I found. Tested in the broken state,
in this order, in one boot:

  ip link set wlp7s0 down; ip link set wlp7s0 up    -> does NOT help
  rfkill block wifi; rfkill unblock wifi            -> does NOT help
  modprobe -r ... ; modprobe rtw89_8922ae           -> ALWAYS fixes it

So neither the mac80211 start/stop path nor an RF off/on cycle clears
the condition. Only re-running probe does. Whatever goes wrong appears
to be established during the initial probe and to persist across
everything short of a reload.


RF calibration is NOT the cause
===============================

I initially suspected RFK, because 'failed to wait RF IQK' and
'failed to wait RF TSSI' do show up in some boots. That turned out to
be a red herring.

With rtw89_core.debug_mask=0x6 (RFK | RFK_TRACK) I captured three
boots in which every calibration completed successfully and well
inside its budget:

    RF PRE_NTFY takes 0 ms to complete
    RF TXGAPK  takes 5 ms to complete
    RF IQK     takes 23 ms to complete      (budget 84 ms)
    RF TSSI    takes 9 ms to complete
    RF DPK     takes 14 ms to complete
    RF RX_DCK  takes 12 ms to complete

Zero 'failed to wait RF' lines in those three boots -- and the
interface still never associated. So RFK success is not sufficient and
the sporadic RFK timeouts are a separate, non-causal symptom.

'timed out to flush queues' also appears in some, but not all, of the
failing boots, so it does not correlate either.


Timing observation (hypothesis, not established)
================================================

The only systematic difference I can see between the failing probe and
the working one is when it runs relative to Bluetooth initialisation.
The RTL8922AE is a combo part; the BT function enumerates as USB
0bda:8922 and is driven by btusb/btrtl.

At boot (monotonic timestamps, failing probe):

    [ 3.018707] Bluetooth: hci0: RTL: rom_version status=0 version=1
    [ 3.018809] rtw89_8922ae 0000:07:00.0: loaded firmware
                                           rtw89/rtw8922a_fw-4.bin
    [ 3.018864] rtw89_8922ae 0000:07:00.0: enabling device (0000 -> 0003)
    [ 3.019712] Bluetooth: hci0: RTL: loading rtl_bt/rtl8922au_fw.bin
    [ 3.052054] rtw89_8922ae 0000:07:00.0: chip info CID: 71, CV: 2, ...
    [ 3.097814] rtw89_8922ae 0000:07:00.0 wlp7s0: renamed from wlan0
    [ 3.638714] Bluetooth: hci0: RTL: fw version 0x41c0c905

The entire rtw89 probe (3.018 - 3.098) runs inside the BT firmware
download (3.019 - 3.639), starting 1 ms after it.

The working reload, same boot:

    [53.643379] rtw89_8922ae 0000:07:00.0: loaded firmware
                                           rtw89/rtw8922a_fw-4.bin
    [53.675553] rtw89_8922ae 0000:07:00.0: chip info CID: 71, CV: 2, ...

i.e. 50 s after BT finished initialising.

I want to be clear that this is only a timing correlation. I have not
yet tested booting with btusb blacklisted, and I am not claiming the
two are causally related. It is simply the one difference I could find
that is present in every failing case and absent in every working one.


Already ruled out
=================

- ASPM / power save. /etc/modprobe.d/ with
    options rtw89_pci  disable_clkreq=y disable_aspm_l1=y
                       disable_aspm_l1ss=y
    options rtw89_core disable_ps_mode=y
  I verified these are actually in effect by reading
  /sys/module/rtw89_pci/parameters/ and
  /sys/module/rtw89_core/parameters/ (all Y). No change.
  pcie_aspm=off on the kernel command line: no change either.

- Kernel version. 6.17.0-23 and 7.0.0-42 behave identically.

- Firmware load. Clean, no errors, no crash, no SER.

- The AP and the environment. A phone associates with the same AP
  fine; the same machine also fails against a phone hotspot.

- Credentials / WPA3 / PMF. The network is WPA2-PSK with no SAE, and
  the failure is before authentication, so no key material is involved
  yet.

- Regulatory domain. Was country 00 initially; setting it to the
  correct country (TR, DFS-ETSI) made no difference to this problem.


I can provide further information if needed.

Thanks,

------------
K. Yavuz Kurt
k.yavuzkurt1@gmail.com
