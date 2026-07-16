Received: from smtp-8faa.mail.infomaniak.ch (smtp-8faa.mail.infomaniak.ch [83.166.143.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D442742FCD5
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 14:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212479; cv=none; b=VD/8K/+uz/XlVvYj3mYgv4KK5aOi9HCMJ/sDLu7+jCGcleh1qssXG9VVsl5W4ziTTxXxdvnXtwgh1YeC2kg8xBo/cB4Kd496B24gnpDsN73yADrizX14YkscKJooEE2iY/HB57L1f2xDsGfYBoDaY1Bo4zMRKtayk+rf3xIDy2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212479; c=relaxed/simple;
	bh=Nvwg54ZOJUFTG3gbR1/BhFqumLdSqUck8mX2LSlbm+0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=BHL9hWt7xecRIfo1j5M9FusP4g5IbS1j7wqaFNlqWHkgnHr+UWW3dDimrcx7+H6jElrDDSZL+vpJOCgtu+DS+pVyXcrFTcy09yKzOAarR5WfZaLozRv578OjKzWTtT5n7lYv20VTkZTN0o8TwE2T74XXZ2+4UbuPjadXCqftCSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ik.me; spf=pass smtp.mailfrom=ik.me; dkim=pass (1024-bit key) header.d=ik.me header.i=@ik.me header.b=FqoYNSuF; arc=none smtp.client-ip=83.166.143.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ik.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ik.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ik.me header.i=@ik.me header.b="FqoYNSuF"
Received: from smtp-3-0000.mail.infomaniak.ch (smtp-3-0000.mail.infomaniak.ch [10.4.36.107])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4h1FtB5yDyz56d
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 16:34:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ik.me; s=20200325;
	t=1784212466; bh=LJQGTGj4TyGvSThf+Evt5GCqmLTgXpeAW1fKYhMYCpk=;
	h=Date:To:From:Subject:From;
	b=FqoYNSuFcR3u+Xl3c+VlQwHMfI4lg4jm+3w4XsAQDSTRG1uSo52sAJbA3ZCQ7T51M
	 SVYfKD5l97KV10iksZwh5ffu5IodRpHDeUlOMfZfpDS17Wfomn70+fVZo1XUeAnvVb
	 F0Fn4JuYOJ2PDPHpOIcwl07UnGZmRBQlsdTzaF2k=
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4h1FtB0lL1z2Zr
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 16:34:25 +0200 (CEST)
Message-ID: <3a31da03-039c-4ac5-bcc4-f2715a718fb7@ik.me>
Date: Thu, 16 Jul 2026 16:34:25 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: es-MX, de-DE, en-US, es-ES
To: linux-wireless@vger.kernel.org
From: Pochimilco <pochimilco@ik.me>
Subject: Bugreport - rtw89: RTL8852AE dead-link stall | linux-zen 7.1.3
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Feedback-ID: :f7146c1849a4b08:ham:2ddedc9c7a59fe1
X-Infomaniak-Routing: alpha

Bugreport  (information collected with the help of AI - i'm not an 
expert but a more less experienced linux user ;) )

I hope it helps...  thanks, Pochimilco
-----------------------------------------------------------------

Title: rtw89: RTL8852AE dead-link stall ("connected but no traffic") 
under linux-zen 7.1.3, absent under linux-lts 6.18
Product: Networking
Component: Wireless
Kernel: 7.1.3-zen1-3-zen (Arch/Garuda)
Driver: rtw89 (in-kernel), module rtw89_8852ae
Hardware: ThinkPad L13 Gen 2a (21AB000PCK), Realtek RTL8852AE
Severity: high (intermittent connectivity loss, ~2-10 min, self-recovering)
Summary:
With the Zen kernel the RTL8852AE enters a "dead link" state: iw link 
shows the device stays associated (Connected, signal ~-49 dBm, RX bytes 
keep increasing), but all traffic to the gateway stops. ping to the 
gateway fails for 2–10 minutes, then recovers on its own. Switching to 
the LTS kernel (6.18.38-3-lts) with identical firmware and same AP 
eliminates the issue completely (0 stalls over multiple hours).
Environment:
     • Kernel affected: 7.1.3-zen1-3-zen
     • Kernel unaffected: 6.18.38-3-lts
     • Firmware: linux-firmware-realtek 20260622-1 (identical in both → 
not a firmware regression)
     • Driver: in-kernel rtw89 (modules: rtw89_8852ae, rtw89_8852a, 
rtw89_pci, rtw89_core)
     • Distro: Garuda Linux (Arch-based), NetworkManager + wpa_supplicant
     • AP: Bushaldestellenzombieparadies, BSSID 50:e6:36:b6:69:a4, 5 
GHz, channel 52 (5260 MHz, 80 MHz, DFS), SAE/FT-SAE, 802.11w=2
Reproduction:
1. Boot linux-zen 7.1.3.
2. Connect to 5 GHz DFS channel 52.
3. Under normal traffic the gateway ping dies after a few minutes; 
device stays associated.
4. Recovers after 2–10 min without user action.
5. Boot linux-lts 6.18.38 instead → no stalls over several hours of the 
same workload.
Mitigation attempts that did NOT help:
All four rtw89 module params set via /etc/modprobe.d/rtw89.conf and 
verified Y in /sys/module/.../parameters/:

options rtw89_core disable_ps_mode=y
options rtw89_pci disable_aspm_l1=y
options rtw89_pci disable_aspm_l1ss=y
options rtw89_pci disable_clkreq=y
Stalls persisted with all four active. Firmware downgrade (to 
20260519-1) also did not help.
Evidence (monitor log excerpt, Zen kernel):

2026-07-16 12:41:34 | channel 52 (5260 MHz), width: 80 MHz, center1: 
5290 MHz | gw-ping: OK
2026-07-16 12:41:49 | >>> STALL: Connected to 50:e6:36:b6:69:a4 (on wlp6s0)
   SSID: Bushaldestellenzombieparadies  freq: 5260.0  signal: -49 dBm
   rx bitrate: 6.0 MBit/s   tx bitrate: 1200.9 MBit/s 80MHz HE-MCS 11 ...
   ... (RX bytes climb 13.4M -> 14.0M across the stall) ...
2026-07-16 12:44:18 | >>> STALL: ... signal: -49 dBm ... gw-ping: FAIL
2026-07-16 12:46:36 | channel 52 (5260 MHz), width: 80 MHz, center1: 
5290 MHz | gw-ping: OK
Key observations during stall:
     • iw link always reports Connected, no deauth, beacon interval 
stable (100 TU).
     • RX byte counter keeps increasing → chip still receives, but TX to 
gateway is blocked.
     • Signal strong (-48 to -50 dBm), so not an RF/coverage issue.
     • Channel never changes (stays 52/5260 MHz) → not a DFS channel switch.

LTS comparison:
After rebooting into linux-lts 6.18.38-3-lts at 12:46, the same monitor 
reported gw-ping: OK continuously with zero >>> STALL entries for the 
rest of the session.
Expected: Stable connectivity on Zen kernel as on LTS.
Actual: Intermittent dead-link stalls requiring no action but causing 
2–10 min outages.
Additional info requested by maintainers (please attach):
     • dmesg from a Zen boot showing the stall window
     • sudo ethtool -i wlp6s0 (or iw dev wlp6s0 info)
     • cat /sys/kernel/debug/ieee80211/phy0/rtw89/... if available


