Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9452E3E63A2
	for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 14:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787409554; cv=none; b=IjdonKdIfUxSqQMwmDq1M0hSXgP4aTvhrHv14302fDvls/j51UnX6Q4+HzGw+HGXdPFoN9fi4x4EPx8ZEr4c+j1+H1PSQBZGSbmngL7sLDY70rY06oDluSIgOyrhPlcrjNLzbObM/HbAEGEvSb/2M+w8tm+1xHeYpC0Y0HHiqPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787409554; c=relaxed/simple;
	bh=2IV+hTjg7UUEhd+R8k1TuLXLvfZWQMTB7HpI7/zeElk=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=PqLZptY2iKVDkxfywc40BXsHxJ0nahfJbwUbE3QKAYduIpp+S0NgU959JzYSXAnPwQdml19Xpur01WklU9A45M4t8PUkZtuz4RRQWBYVlkmX7hLSugM4CnxoelI2d1AWFuXwk0gktSPKD4BTo5mdbCTz0zTtkCiIOo7tx8JEbWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hallaine.com; spf=pass smtp.mailfrom=hallaine.com; dkim=pass (2048-bit key) header.d=hallaine.com header.i=@hallaine.com header.b=lm6wXcrP; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=BJM9PjsR; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hallaine.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hallaine.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hallaine.com header.i=@hallaine.com header.b="lm6wXcrP";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BJM9PjsR"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 2BD25EC018E
	for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 10:39:11 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Sat, 22 Aug 2026 10:39:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hallaine.com; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm1; t=1787409551; x=1787495951; bh=2IV+hTjg7U
	UEhd+R8k1TuLXLvfZWQMTB7HpI7/zeElk=; b=lm6wXcrPc642H0/2AQUch+1Q2/
	jg/DFQyqIivaTPJJuKw+ieDdg0MnBlfY7V2GyCwTuvMbVXW8z3WCXjgliAWIMrcf
	G26amTuR5oCRuBVc71XQH5dL8WtR6DmP+wZvPVw7lzJiJjW1jL2LVU+iQFQOV03F
	BDcBNEcEdbVdzXJg1byNwEGzXbCrL6iPF5d1afO1v9aBTQqB8YQI9Orv4M42VeDk
	5+6VLmLFo00y9e0AimUxtUpNKeyhj4eMDJqWAtUM9QDA/YLqlk+eb2Araok+QRrj
	vTQycMbj6Dq2HjoNIWXRJm/QZ03frfBGBg0YtJFTjvQEUDZLTr1GbUQB8YBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787409551; x=1787495951; bh=2IV+hTjg7UUEhd+R8k1TuLXLvfZWQMTB7Hp
	I7/zeElk=; b=BJM9PjsRO8gGRGWiNP260MZx/jNK6Q6Gdjmaw3s7Gb2XdWiVc+J
	2fkBhjUC4ww8/8AyIua5SmE1KY4EzkSz8OwoCGPMC4VRC82sO6KslXCtpP8nOZZq
	bqGdiieRKN02I5mEbcNVJsUerk938o6l0RTTS1jqK6jz25d2AWMU2DQtsxQVaAxz
	JiMTCaqA90txNnm38e4CqYwiiXJpJzqRJ0xkdbsUC3ll6DRLdeZwuKekMKAfpaON
	zNwyF6bcEEeODWTqUsF2uvhDfxH+c3Tbk/5kwz/gWsJJp4fRpzuXq6qduCgExlx3
	9sUiu5Zjp1wIjQqaCjGMnbtG05+FFyc1X8Q==
X-ME-Sender: <xms:j7SJaiMbQXUjEcGTcq2JdKopzM7bNABVTp3YMF0ju6KZAUyvDfVu0Q>
    <xme:j7SJan4U_m-JIhYsF2fDkEdFKdZSOJOxxVIU6_DeoRFncyFjhRvfacqBOvHUdimp5
    kfyQBtO7WdrGsahkxx0XquD0AxpuU8kWIqoXSNtqhLuRvzhmVyMj2o>
X-ME-Received: <xmr:j7SJau5Y4plQu-zCEZF6IQrY1omSu28ChliqkNLYPuLysYwnt7WROkIxrHJ8pEvenFBtgqG4dSZ3V-MHzK1bK2BlyWFX8qFTiSSCTasD>
X-ME-Proxy-Cause: dmFkZTG0ADQYGDjkbyKICs4tUeonBknnIBv5nAPR1KWpTU5j0J23ULR3Iv+DbOn4+lK/UE
    WJ25h7YnXUKbmd4d+qC2ql7kbb2acq/CKBkaNWMhgmFKSKgS39oR3Jd5hdICfmKZCpBzQ0
    9JiuPYWHWa5l2NS71a+s/2cndWW8WeUTY1EUmm9deY3/MwUrc0NkNp+u0MY/vqUAkSoI7f
    zEcmB4RLHEjldI5F1H9c9nYx89Ld5mW5UhKG0SUlvIk2VX01fuhQFHe1y07Hx6KYgDAu4o
    wECAbXd00HGSV8FlxeSxKEKdANqmAKcGlx1ljXRIQ/a4LYeAnGedSxciMX7hm4Y7DZqDIq
    MFRsp/3HdqykjD4rrLjE8fv/lYCXem4XMIphwzjdQc53Q6GUlnaju10zf7bht6RGHN6Mmz
    P30Zei1IMuUn7jbrucs2NEyIcTnYFO25DjimFs4eu5vqdGvUilVSf0oe1NSPWUSdCDuzC2
    Knadr5TAD48of6N/8lbLDZHkMBOw/zmocXv4e2Yb/YW1eX9nKbs7N8w2vYNmjwFJv2wD7D
    KJju+KetoWKDNmpoH2MJMZBQgmac6KxqKILfu9vpcpZv1z2GUMWO8WYXmAcPVUj1hX8x12
    Z8N2Zdb8EbAvOG8wIeHsSAkATESfYFnxAd773fwn/FpFjdLGvwpe44wpeV7w
X-ME-Proxy: <xmx:j7SJan0yI6mgD8EzMaSNMgTBqiyt6YP21miBpMij8W9xKBTPX9Kenw>
    <xmx:j7SJaqXCuTVSujHa2ijX8FnmJ1fojgeApCLjO1KsW7dwfXLox967AQ>
    <xmx:j7SJai4LvwyhG1W5PW1U_5iZW5ebNuXq7UizElinjj_gxcV26YtZgg>
    <xmx:j7SJahIgylJf2KuwgEWk65CLnLQOD2md4LZqJfeJq4_czWgzLvYaJQ>
    <xmx:j7SJai8b7VrkuLdw0bBV4lq3m_PTAFQRfjcSjabCERKYbD8hPkYYYnsd>
Feedback-ID: ica3e4843:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 10:39:10 -0400 (EDT)
Message-ID: <e9a0c9af-6436-4143-9edc-36c30ea15434@hallaine.com>
Date: Sat, 22 Aug 2026 10:39:10 -0400
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-wireless@vger.kernel.org
From: Alexandre Hallaine <alexandre@hallaine.com>
Subject: Re: Wi-Fi speeds degrade from 600Mps to 30Mps while using WPA2
 security, but not on open network, shortly after ISP firmware upgrade.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Adding another data point to this thread. I'm on Videotron Helix
(Quebec, Canada) — same Technicolor CGM4331COM Rev 2.0 as the
Rogers XB7. This confirms the issue crosses ISPs using the same
Comcast xFi platform.

My client is an Intel AX210 (not yet tested in this thread),
iwlwifi driver, NixOS 26.05, kernel 6.18.44, NetworkManager +
wpa_supplicant. I also reproduced with multiple other WiFi cards,
not just Intel.

Gateway firmware: CGM4331COM_8.3p15s1_PROD_sey (newer than
BensonBear's 8.3p12s1 — bug persists).

Precise A/B measurements (same 5 GHz network, same BSSID, same
PHY — only variable is PMF):

   PMF negotiated (NM default):
     Download: 47-57 Mbps
     Latency under load: 300-1400 ms
     TX retry rate: ~35%
     PHY rate: 1200 MBit/s (HE-MCS 11, NSS 2, 80 MHz)

   PMF disabled (pmf=1):
     Download: 651 Mbps
     Latency under load: 55 ms
     TX retries: 0%
     PHY rate: identical

   iwd (no PMF by default):
     Download: 514 Mbps
     Latency: 34 ms
     TX retries: ~3.7%
     PHY rate: identical

   Minimal wpa_supplicant (no NetworkManager, bgscan=none):
     Download: 470 Mbps
     TX retries: 0%
     PHY rate: identical

Two findings I haven't seen mentioned yet:

1) I ran `iw event -t` during a download with PMF enabled.
    TX retries spiked to 15,000+ in 10 minutes, but iw event
    showed ZERO events — no scanning, no roaming, no channel
    switches, no disconnects. This rules out off-channel behavior
    as the cause. The retries are purely MAC-layer with no
    control-plane disruption.

2) Minimal wpa_supplicant without NetworkManager gets 470 Mbps
    with 0% retries. This proves wpa_supplicant itself is not the
    problem — NetworkManager's default PMF negotiation triggers
    the bug.

Regarding the kernel mechanism: Linux net/mac80211/agg-tx.c has
an explicit guard:

   "MFP STA not authorized - deny BA session request"

If PMF negotiation puts the station in an incorrect authorization
state (the mismatch Pablo described), mac80211 denies Block ACK
session establishment. Without BA sessions, A-MPDU aggregation
cannot operate. Without aggregation, each frame pays full overhead
(preamble + contention + SIFS/DIFS + individual ACK), which
mathematically produces ~24-48 Mbps at 1200 Mbps PHY rate —
matching the observed numbers exactly.

This aligns with Pablo's capture analysis: the STAs send ADDBA
requests that get no response, then DELBA with reason 0x25 —
no BA session is established, so performance is pre-11n.

For the AP side: the public RDK-B OneWifi repository has
documented PMF configuration defects:

   PR #1295 (July 2026): "WPA2personal should have mfp as optional"
   — fixes incorrect MFP configuration for WPA2-Personal

   PR #1340 (August 2026): fixes security-mode translation errors
   affecting WPA3, transition mode, and PMF handling

These confirm RDK-B has had real PMF configuration bugs. The
firmware on my gateway (8.3p15s1) may not include these fixes.

What did NOT fix it (with PMF enabled):
   - iw dev set power_save off
   - iwlwifi uapsd_disable=1 + iwlmvm power_scheme=1
   - BSSID lock
   - Disabling P2P
   - Forcing 5 GHz band

Only disabling PMF fixed it.

Workaround:
   nmcli connection modify "SSID" 802-11-wireless-security.pmf 1

I have full iw station dump output, NetworkManager logs, and
wpa_supplicant logs available. I can also run packet captures
of the AddBA/Block ACK exchange if it would help confirm whether
the AP or the client is dropping the action frames.

--
Alexandre Hallaine
NixOS 26.05, Intel AX210, kernel 6.18.44
Videotron Helix CGM4331COM Rev 2.0

