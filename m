Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AF337F337
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 15:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787671668; cv=none; b=d4S6WjhDOxf2v6AntXaQtIbzHmxjW+ca/0+hjClmJlxVvF/Uijkm9EmawfEDE84bwiTR3ANbqQb0Eha9a4utK41DGcE9Isfr0r34OrQxj7WWIfe69Z8NMfjGQ6I+KzJ5O30Wv1lj9jDX6wU0W30YXP5ri0c2f241uabhHY9aIcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787671668; c=relaxed/simple;
	bh=SXqX58AD1IukL3i2fEHebm65DFRDLbbsBwDnz8ykwZ0=;
	h=Content-Type:Message-ID:Date:MIME-Version:To:Cc:Subject:From; b=CwpQAlVRCQq46smRY8psHS5Id9MMu7yVdgUNPLHdSn6p5Wtx1ttgtKAxNNc6K/xIAt7q2L4LATCWnzIBqexEAg/eZjlbymy1IMfyj75lMD1JgC5kITw4F1eWkt29TCv2ESTnemUWYXS5WDPIo6svTXJF/B4EFl8ifHPMbGRHuqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WjodZchr; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WjodZchr"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6a082b3671fso7994769a12.3
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 08:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787671665; x=1788276465; darn=vger.kernel.org;
        h=from:content-language:subject:cc:to:user-agent:mime-version:date
         :message-id:content-type:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ncUmp8OLjHplK1jZ4/mtE0BKYoXfIRS6ZddEdtX5cY8=;
        b=WjodZchrPBTZy8WXWpDKfozfxg1PtH9h6BrnYJTsoNZdabZgI11vM00IpUrpvTnYeA
         Ns50VcLPCjGGL4JCSlomcwrvLOPjLWuzWxWMcCBfCiJwkPEyTd8ZEDzSG8EvrIQfvrfW
         F2mGGqDHo4NXOzXj8Kh6UtEsOyXPiiZN0DOswrizJnowlEBjc+UY3jxC3P1PZ3I12fQQ
         897x/4sF/U1xyvbvpnm8dox2A8dUdGQyMl7hVlm8M9P9zGkFJZ9PIZR6Th2XJCAxhxvp
         oWGGv6f8fk0/i14nFZyqpIhmM9MMbHaMyre4BxhaM1rwSo7WyTzlW723e3Vc2bgkva3J
         6GOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671665; x=1788276465;
        h=from:content-language:subject:cc:to:user-agent:mime-version:date
         :message-id:content-type:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ncUmp8OLjHplK1jZ4/mtE0BKYoXfIRS6ZddEdtX5cY8=;
        b=q/UwPncke+ONe9ACM6xDT/7BFPcqT0dmBz8MwdfyxXK8ZUIvKL8glGZhdvsOY5oyEK
         hLRDeVr42TwXmU8BACkCyajrLhoY2gcSEgM7g6M3F8KO5n1NcddFgqYCxG8uGEnl0NDq
         u8ZxmQrK+jXJ0Jlk5186JmOA/D+EttJM1yYi7ElM59hjnCZ2hBGOkT3ZI+WMYl6sEfHI
         n003QBHDJkVjnR67q4w1SlXyI7LDjjZkz4mtgXeIFJLEvvZzHHOF6G5quIeyRGaTY76B
         /X8km/S//4vuslD9pUJLyF2QW3Ov34VesX5rxFe6d8MvOP07chafJtSA3EJAE5WLARcc
         774w==
X-Gm-Message-State: AFuF++kFGV/E+rUJ7QY8sWvhiDTZs42cSIpx7F5KuSmmMWM4DTR3OO3v
	MU1NXb9r1jSyU8imOQQlRrGADGRxXaRwu1hiQ8+cosdlDY+jM32V2Pu1MNM0g18u
X-Gm-Gg: AR+sD10fORqBdL7a1m+kGZIdr+3t/qbGQQabiyBbYUEp1xEm4flaQg41LLBaENt0CbD
	Ar7IR+Pv1VX88XrEWK78enfaKelNE16r2Z6ijFEPKiWg0fA4TiYPyFPHQXxPKmIhoiD86LIE0sU
	YZccyvm/u4wVHL+GxPZfErKRmfXvGLsvRD2xoR7rpHsqTGBMy+GfY8vSQBuUJExmkuU8dRGlhqC
	3gnBRfEE2uW5GvGjWzc55lutqqKXJT91lvh48IU3AWaiJuEnzxNkfdThh6zGW1D/KqGfdSUCY7P
	I/5+g8k+dphf7J2Q786/AaQZ3I27lxW35+gww00iWzre9aq/isWtcMyxWSlJCO3LCuwh3H3f5de
	725qmAVYjX+/BjGjtfMX8wqruOM/KxamPwwmZb8/qmkisChft+mH44vZsn11/9xgEi1NwttA25F
	YuHZc53uP0x7kyw/FUI2NeFhVTbbDo5D7UubkSXCGEY6TC3+VWxB5QXguHTx68vqHdRN27RMNNi
	KFIkg9QcuPB+e56qyo9hw==
X-Received: by 2002:a05:6402:27d0:b0:6a1:2efd:8687 with SMTP id 4fb4d7f45d1cf-6a42f20afd9mr37601811a12.14.1787671664422;
        Tue, 25 Aug 2026 08:27:44 -0700 (PDT)
Received: from [192.168.68.149] (c633C4BC1.dhcp.as2116.net. [193.75.60.99])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a5deafc5fbsm152225a12.29.2026.08.25.08.27.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 08:27:43 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------edbTR3mz2f0TFg10fj7Hzz2q"
Message-ID: <c0d9535c-ce42-4eea-bb5d-3ccb87b8a3ea@gmail.com>
Date: Tue, 25 Aug 2026 17:27:42 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Linux)
To: linux-wireless@vger.kernel.org
Cc: linux-mediatek@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
 Lorenzo Bianconi <lorenzo@kernel.org>
Subject: =?UTF-8?Q?=5BBUG=5D_mt76/mt7921e_=28MT7922=29=3A_bulk_TX_transfers_?=
 =?UTF-8?Q?stall_irrecoverably_until_driver_reload_=E2=80=94_multiple_apps?=
 =?UTF-8?Q?=2C_multiple_APs=2C_two_firmware_versions?=
Content-Language: en-US, nb-NO
From: Alan Omar <alanomar1992@gmail.com>

This is a multi-part message in MIME format.
--------------edbTR3mz2f0TFg10fj7Hzz2q
Content-Type: multipart/alternative;
 boundary="------------zhaUasRHVbWlc1FjJiKYv3sJ"

--------------zhaUasRHVbWlc1FjJiKYv3sJ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


Hi,

I''m reporting a severe reliability bug in mt7921e (MediaTek MT7922, AMD 
RZ616)
on kernel 7.0.0-30-generic (Ubuntu 26.04). I have not seen this exact 
failure
mode reported to this list; a similar report exists only in a distro tracker
(Red Hat Bugzilla #2459017, "Severe download speed degradation until 
reboot or
driver reload", status NEW since April 2026, apparently never forwarded 
here).

== HARDWARE / SOFTWARE ==
- WiFi: MediaTek MT7922 [14c3:7922], AzureWave subsystem [1a3b:5911], PCIe
- Driver: mt7921e (in-tree mt76), kernel 7.0.0-30-generic
- Firmware tested BOTH: build 20260224103233 AND build 20260724143402
(latest from linux-firmware as of Aug 2026) — bug identical on both
- APs tested: TP-Link Deco M4R (802.11ac, WPA2) and Pixel 8 Pro hotspot
- Control machine: same location, same APs, same peer device, same apps —
laptop with Intel WiFi (iwlwifi): ZERO issues ever

== SYMPTOM ==
Any sustained bulk transfer (KDE Connect file send ~100MB, adb wireless
install, plain TCP file share) stalls partway (typically 10–70%) and the
application eventually times out and fails. Happens on multiple apps, so it
is not app-specific. Interactivity (ICMP, small traffic, internet 
speedtests)
remains perfect throughout the stalls.

Critical detail: PHONE→LAPTOP direction works 100%. Only LAPTOP→PHONE
(bulk TX toward the AP) triggers it. On the Intel laptop both directions
work flawlessly on the identical network.

== EVIDENCE ==

1) TX retry explosion + rate collapse during stalls (iw station dump):
- tx retries: 208,941 → 247,117 within minutes of transfer attempts
- tx bitrate collapses 866.7 MBit/s (VHT-MCS 9, 80MHz, NSS2)
→ 121.5 MBit/s (VHT-MCS 6, 40MHz, NSS1) mid-stall
- signal: -51 to -58 dBm (excellent, so not RF)

2) Beacon-loss storms correlated with stalls (wpa_supplicant):
- 3,934 CTRL-EVENT-BEACON-LOSS events in one afternoon, including
25+ seconds of continuous beacon loss (12:15:35–12:15:59)
- card stops hearing the AP entirely while gateway ICMP stays 4–8ms
in adjacent windows

3) Socket-level capture during a stall (ss -tnie, 2s sampling):
- transfer socket frozen: receive queue stuck at exactly 2,122,768
bytes for 70+ seconds; kernel buffers full, application wedged
- during the same window: ping to peer 5–9ms, ping to gateway 3–5ms,
zero beacon loss, healthy tx rate — network provably clean while
the transfer is dead

4) Recovery: ONLY a driver reload recovers the link
(modprobe -r mt7921e && modprobe mt7921e). After reload, transfers
work again — sometimes for minutes, sometimes hours — then degrade
again under bulk TX. This is 100% reproducible.

== RULED OUT ==
- PCIe ASPM L1 (disable_aspm=Y applied; latency spikes fixed, stalls remain)
- NM/wpa_supplicant power save (power_save off; stalls remain)
- Chip deep-sleep + runtime-pm (debugfs flags toggled; no effect on stalls)
- TX pacing/burstiness (tc tbf 30mbit + tcp_limit_output_bytes=128KB; 
stalls)
- RTS/CTS (rts 512; stalls)
- AP firmware (TP-Link Deco updated 1.5.0→1.6.1; stalls)
- WiFi firmware (two builds tested as above; stalls on both)
- Peer device power management (fails with peer screen on, app foreground)
- Roaming (BSSID pinned; stalls)

The trigger is specifically SUSTAINED BULK TX from the MT7922. RX-heavy
loads (internet downloads at full speed) do NOT trigger it. This smells
like a TX path / aggregation state issue in the driver or firmware
(A-MPDU/B-A session state?) that progressively wedges the MAC until reset.

Kernel log during one storm:
[134991.282223] mt7921e 0000:63:00.0: disabling ASPM L1
(no firmware crash lines, no page_pool errors, no other warnings)

Happy to provide full logs (iw dumps, ss captures, journalctl excerpts,
ping timelines) on request, or to test patches on this hardware.

Regards,
--------------zhaUasRHVbWlc1FjJiKYv3sJ
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <br>
    Hi,<br>
    <br>
    I''m reporting a severe reliability bug in mt7921e (MediaTek MT7922,
    AMD RZ616)<br>
    on kernel 7.0.0-30-generic (Ubuntu 26.04). I have not seen this
    exact failure<br>
    mode reported to this list; a similar report exists only in a distro
    tracker<br>
    (Red Hat Bugzilla #2459017, "Severe download speed degradation until
    reboot or<br>
    driver reload", status NEW since April 2026, apparently never
    forwarded here).<br>
    <br>
    == HARDWARE / SOFTWARE ==<br>
    - WiFi: MediaTek MT7922 [14c3:7922], AzureWave subsystem
    [1a3b:5911], PCIe<br>
    - Driver: mt7921e (in-tree mt76), kernel 7.0.0-30-generic<br>
    - Firmware tested BOTH: build 20260224103233 AND build
    20260724143402<br>
    (latest from linux-firmware as of Aug 2026) — bug identical on both<br>
    - APs tested: TP-Link Deco M4R (802.11ac, WPA2) and Pixel 8 Pro
    hotspot<br>
    - Control machine: same location, same APs, same peer device, same
    apps —<br>
    laptop with Intel WiFi (iwlwifi): ZERO issues ever<br>
    <br>
    == SYMPTOM ==<br>
    Any sustained bulk transfer (KDE Connect file send ~100MB, adb
    wireless<br>
    install, plain TCP file share) stalls partway (typically 10–70%) and
    the<br>
    application eventually times out and fails. Happens on multiple
    apps, so it<br>
    is not app-specific. Interactivity (ICMP, small traffic, internet
    speedtests)<br>
    remains perfect throughout the stalls.<br>
    <br>
    Critical detail: PHONE→LAPTOP direction works 100%. Only
    LAPTOP→PHONE<br>
    (bulk TX toward the AP) triggers it. On the Intel laptop both
    directions<br>
    work flawlessly on the identical network.<br>
    <br>
    == EVIDENCE ==<br>
    <br>
    1) TX retry explosion + rate collapse during stalls (iw station
    dump):<br>
    - tx retries: 208,941 → 247,117 within minutes of transfer attempts<br>
    - tx bitrate collapses 866.7 MBit/s (VHT-MCS 9, 80MHz, NSS2)<br>
    → 121.5 MBit/s (VHT-MCS 6, 40MHz, NSS1) mid-stall<br>
    - signal: -51 to -58 dBm (excellent, so not RF)<br>
    <br>
    2) Beacon-loss storms correlated with stalls (wpa_supplicant):<br>
    - 3,934 CTRL-EVENT-BEACON-LOSS events in one afternoon, including<br>
    25+ seconds of continuous beacon loss (12:15:35–12:15:59)<br>
    - card stops hearing the AP entirely while gateway ICMP stays 4–8ms<br>
    in adjacent windows<br>
    <br>
    3) Socket-level capture during a stall (ss -tnie, 2s sampling):<br>
    - transfer socket frozen: receive queue stuck at exactly 2,122,768<br>
    bytes for 70+ seconds; kernel buffers full, application wedged<br>
    - during the same window: ping to peer 5–9ms, ping to gateway 3–5ms,<br>
    zero beacon loss, healthy tx rate — network provably clean while<br>
    the transfer is dead<br>
    <br>
    4) Recovery: ONLY a driver reload recovers the link<br>
    (modprobe -r mt7921e &amp;&amp; modprobe mt7921e). After reload,
    transfers<br>
    work again — sometimes for minutes, sometimes hours — then degrade<br>
    again under bulk TX. This is 100% reproducible.<br>
    <br>
    == RULED OUT ==<br>
    - PCIe ASPM L1 (disable_aspm=Y applied; latency spikes fixed, stalls
    remain)<br>
    - NM/wpa_supplicant power save (power_save off; stalls remain)<br>
    - Chip deep-sleep + runtime-pm (debugfs flags toggled; no effect on
    stalls)<br>
    - TX pacing/burstiness (tc tbf 30mbit +
    tcp_limit_output_bytes=128KB; stalls)<br>
    - RTS/CTS (rts 512; stalls)<br>
    - AP firmware (TP-Link Deco updated 1.5.0→1.6.1; stalls)<br>
    - WiFi firmware (two builds tested as above; stalls on both)<br>
    - Peer device power management (fails with peer screen on, app
    foreground)<br>
    - Roaming (BSSID pinned; stalls)<br>
    <br>
    The trigger is specifically SUSTAINED BULK TX from the MT7922.
    RX-heavy<br>
    loads (internet downloads at full speed) do NOT trigger it. This
    smells<br>
    like a TX path / aggregation state issue in the driver or firmware<br>
    (A-MPDU/B-A session state?) that progressively wedges the MAC until
    reset.<br>
    <br>
    Kernel log during one storm:<br>
    [134991.282223] mt7921e 0000:63:00.0: disabling ASPM L1<br>
    (no firmware crash lines, no page_pool errors, no other warnings)<br>
    <br>
    Happy to provide full logs (iw dumps, ss captures, journalctl
    excerpts,<br>
    ping timelines) on request, or to test patches on this hardware.<br>
    <br>
    Regards,<br>
    <your name=""></your>
  </body>
</html>

--------------zhaUasRHVbWlc1FjJiKYv3sJ--
--------------edbTR3mz2f0TFg10fj7Hzz2q
Content-Type: application/gzip; name="mt76-bug-evidence.tar.gz"
Content-Disposition: attachment; filename="mt76-bug-evidence.tar.gz"
Content-Transfer-Encoding: base64

H4sIALmzjWoAA+2ca2/byBlG87X5FfzYomtlhjPvXIhu291FihbYS9EEux+CwGAkriPElgSR
zqW/vjMax2Q2cRbr9UkRiIQNaSTxITl6Dy9nJD3r2uV2c3K+7fuTfftqMbwe7t31pJRyzlbp
VntR09s0aaO98pWW2hpjtNOqUrVWyt6r1J2vyQemy35o92lVdvv1Ztn1/fn67Pnw5v3X/drz
h415u1Hp9jOZhu3Qnlfdy24z9E1ltdX328uzRVVLpXVjXVPH6tl5+zz/n3Qvt9q269gPu+rV
rj3tL3e78/Wy3QxPtAv2aVO9Ot/F2Kum+ubxf749efjjw+8fn3z98Ktvfvj+5NsfHj36RbZR
YLYGs2sw24DZAmY7MNuD2QHMBtmxYH1bsL4tWN/WgtkgOxasQQvWoID7bwHrW8AaFLAGBaxB
AfffAu6/Batv3yisvlM2Vt8pG9t/p2yMnZSN1XfKxuo7ZWP1nbKxY0PKBtnRYH1rsL41WN8a
OzakbJAdDda3Butbg/Vdg8eGGmSnBuu7Buu7Buu7Bo8NNcgO52Y86GY86GY86GY86GY86GY8
6GY86GY86GY86GY86GY86GY86GY86GY86GZSNljfnPfxoPfxoPfxoPfxoPfxoPfxoPfxoPfx
oPfxoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJ
oPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJ
oPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPcJoPeJoPeJoPeJ
oPeJoPeJoPeJoPeJoPeJoPeJoPeJoPeJoPeJoPeJoPeJoPeJoPeJoPeJoPeJoPeJoPeJoPeJ
oPeJoPeJoPeJoPeJoPeJoPeJoPeJoPdJ2WB9c94ngt4ngt4ngt4ngt4nNhZkh3NKEXRKEXRK
EXRKEXRKKRvkkvNVEfRVEfRVEfRVEfRVKRvkknNhEXRhEXRhEXRhEXRhKRvkEvNsojjPlrMp
LnM2xWXOprjM2RSXOZviMmdTXOZsisucTXGZs0EuNcgl5gdzNsgl5gdzNsgl5gdzNsgl5h5z
Nsgl5h5TNuYeczbIZQ1yiXnNnA1yiXnNnA3WN+YeUzbmHnM2WN+Ye8zZYA1i7jFng8cGzD3m
bJAdzA/mbLC+MT+Ys8H9N+YHczZY35jDy9lkfYPHBszh5WywvjHPlrPB+sY8W84G2cE8W84G
2eE8mwY9mwY9mwY9mwY9mwZdmAZdmAZdmAZdmAZdmAZ9lQZ9lQZ9lQZ9lQZ9lQZ9lQZ9lb5j
p7RYLMb8Op38UOdth2zovK1kM2yWbIbNks2wWbIZNks2w2bJZtgs2QybJZs5rpVsjEtDnROW
bIxLQ50TlmyMS0ONvZZsjEtDnW+WbIxLQ51vlmyQS2jstWSDXELnsiUb5BI6ly3ZIJfQuWzJ
BrmExl5LNsglNPZaskEuobHXkg1yCY29lmyQS+g7JSUb5BIaMy7ZIJfQmHHJBrmExoxLNsgl
NB5dskEuofHokg1yCY1Hl2yQS2isu2SDXEJj3SUb5BIa6y7ZIJfQOHrJBrmExtFLNsgl52MN
6GMN6GMN6GMN6GMN6GMN6GMN6GMN6GMN6GMt6GMt6GMt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt
6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt
6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt
6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6Ewt6EwFdKYCOlMBP8MqoI8V
0McK6GMF9LEC+lgBfayAPlZAHyugjxXQxwroYwX0sQL6WAF9rIA+VkAfK6CPFdDHCuhjBfSx
AvpYAX2sgD5WQB8roI8V0McK6GMF9LEC+lgBfayAPlZAHyugjxXQxwroYwX0sQL6WAF9rIA+
VkAfK6CPFdDHCuhjBfSxAvpYAX2sgD5WQB8roI8V0McK6GMF9LEC+lgBfayAPlZAHyugj3Wg
j3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wg
j3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wg
j3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wgj3Wg
j3Wgj3Wgj3Wgj3Wgj3V37GPv3XZaXXT92cnF4GOtu8Xwerh10s2TUso5W6Vb7dMuY3J7mGqf
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

--------------edbTR3mz2f0TFg10fj7Hzz2q--
