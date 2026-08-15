Received: from mail-24424.protonmail.ch (mail-24424.protonmail.ch [109.224.244.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404D013777E
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 19:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786823191; cv=none; b=pYG4CBELWi7OyGN7Pzq4Fn2wvHMXOoa4yO+flMTzCaDDA6C3AvHwFru14GOMRC0Pr/m52WjXCjM7Oj7ReWKIuZWSDzUJdD4KS+WSWgQ9LwcW/BK0KV7VoURdjquOUEiN5dD3gvDNtF2Vrg+d8PT+94/TjCvp3aaQEnen5A0x3k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786823191; c=relaxed/simple;
	bh=wh9ALErat6AXGDNVV3rhKnUZ+pmnFJVZLzmEtAC1bXY=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=AKD5uMwLQivuCKMTfFSyjTkHdw3uIFa489KVpdM3dBjybfoC0P8sZ4Gij0xdXGRuJhCUzPJtKU5zuNOYRfq/mB7AxecsQw24q80LxL1aZtuvhmIAxlT7NPP2T/6nWWfk3WhgGuZmfLucFTdr/XJqGcu71HA+Z9yDA5/i16sX95A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=MPJDkRAk; arc=none smtp.client-ip=109.224.244.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="MPJDkRAk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1786823178; x=1787082378;
	bh=wh9ALErat6AXGDNVV3rhKnUZ+pmnFJVZLzmEtAC1bXY=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=MPJDkRAkBwo0UOaXg3jzBYtQY4UUHwyEH/kD38e10dhj6dZKGjvMcNin03h5Th01P
	 3lkRLRs+D2VCDdVP45mLikaUWdWIyjYhyjS8SiBCkXLBAA0GP1DPV72fg0Z2ZUl+jG
	 GsnuD111mhlZKoFyp71b8ii2wENHvfV3YIZMHLhcMbrgbhlSRIiBJHqpn/iqRdAgYg
	 igDczF2ABjv0AJxhsrCoyNgyGsLg3MSLypDZ8pbQxcrde47ADt3nexK/oGz8X5vpgY
	 y7mupCeWT6duO7ZAEN8Q9PpOFKiYkUvewKHLyrTJuwOuPTlJne5AVqQbXTdd6Tn/P6
	 WMZWf/zACUW0Q==
Date: Sat, 15 Aug 2026 19:46:12 +0000
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Louis <tux823@proton.me>
Cc: "pkshih@realtek.com" <pkshih@realtek.com>
Subject: [BUG] wifi: rtw89: firmware regression on RTL8922AE (0.35.80.3 vs 0.35.42.1)
Message-ID: <-lvXDCNoYldP3-AEO0uA-s2_Ebvv7FA2sfz4o8Y-4GF7epAf9Qe8v7dBFApXrVhpR942H-CWduTWtKM31PAiEd44d-c2A4aVc3Z5uRmv7dE=@proton.me>
Feedback-ID: 215313278:user:proton
X-Pm-Message-ID: 5bfefc6c0f6d20ccf716d65fadd03a92518b048c
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hardware: Realtek RTL8922AE (rtw89_8922ae driver)
Also tested on: RTL8922AE-VS (same PCI ID: 10ec:8922)
Systems: Lenovo Yoga 7 14AKP10 (Type 83JR) [laptop, PCIe],
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0desktop (RTL8922AE via M.2-to-PCIe adapte=
r, replacing a
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0QCNFA765/ath11k card)
Kernels tested: CachyOS default, CachyOS zen, Arch (vanilla),
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mainline LTS =
=E2=80=94 regression reproduces identically
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 on all of them, rul=
ing out kernel version as a
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 variable.

=3D=3D=3D ISSUE 1: Firmware regression, reproduced across two
=C2=A0 =C2=A0 linux-firmware releases =3D=3D=3D

Known-good firmware:
=C2=A0 Firmware version 0.35.42.1 (cc364c30), cmd version 1, type 1
=C2=A0 Firmware version 0.35.42.1 (cc364c30), cmd version 1, type 3

Known-bad firmware:
=C2=A0 Firmware version 0.35.80.3 (8ef4f0cf), cmd version 1, type 1
=C2=A0 Firmware version 0.35.80.3 (8ef4f0cf), cmd version 1, type 3

Symptoms on the bad firmware (0.35.80.3):
=C2=A0 - Intermittent disconnects on both 5GHz and 6GHz, under load or afte=
r 3-5 minutes
=C2=A0 =C2=A0 (observed most reliably during sustained transfer / speedtest=
)
=C2=A0 - Recurring log line preceding drops:
=C2=A0 =C2=A0 =C2=A0 "rtw89_8922ae 0000:03:00.0: sec cam entry is empty"
=C2=A0 - Followed by reassociation failures:
=C2=A0 =C2=A0 =C2=A0 "wlan0: deauthenticated from <MAC> while associating
=C2=A0 =C2=A0 =C2=A0 =C2=A0(Reason: 9=3DSTA_REQ_ASSOC_WITHOUT_AUTH)"
=C2=A0 - Ruled out as the cause before landing on firmware:
=C2=A0 =C2=A0 =C2=A0 DFS channel-vacate events, router DCS (dynamic channel
=C2=A0 =C2=A0 =C2=A0 selection), PCIe ASPM L1, GTK/group-rekey interval,
=C2=A0 =C2=A0 =C2=A0 kernel choice (4 different kernels tested)

Reproduction:
=C2=A0 1. Install current linux-firmware (rtw8922a_fw-4.bin loads,
=C2=A0 =C2=A0 =C2=A0version 0.35.80.3)
=C2=A0 2. Sustained transfer / speedtest on 5GHz or 6GHz, wide channel
=C2=A0 =C2=A0 =C2=A0(160MHz+) =E2=80=94 disconnect + "sec cam entry is empt=
y" +
=C2=A0 =C2=A0 =C2=A0reason-9 reassoc failure within minutes
=C2=A0 3. Move/delete the -3.bin and -4.bin firmware files so the
=C2=A0 =C2=A0 =C2=A0driver falls back to an earlier bundled version
=C2=A0 =C2=A0 =C2=A0(0.35.42.1 (cc364c30) loads) =E2=80=94 stable indefinit=
ely under
=C2=A0 =C2=A0 =C2=A0the same load/test conditions

This was independently reproduced a second time after a
subsequent linux-firmware update reintroduced the same -3/-4
files =E2=80=94 same fix (remove them, fall back to 0.35.42.1) resolved
it identically both times. Confirms this isn't a one-off but a
persistent regression carried across releases.

Happy to test candidate fixes or provide a fuller dmesg/pcap
capture around a live drop if useful =E2=80=94 I have the reproduction
steps down to a few minutes reliably.

=3D=3D=3D ISSUE 2 (informational, not a bug report): MLO/MLSR real-world
=C2=A0 =C2=A0 test data =3D=3D=3D

Tested the MLO patchset (MLSR =E2=80=94 link-switching) with an AP
broadcasting one SSID across 5GHz and 6GHz simultaneously.
AP-side confirms the client associated on both bands at once.
`iw dev wlan0 station dump` shows only a single active tx/rx
bitrate pair at a time (consistent with MLSR link-switching
rather than MLMR aggregation, as expected given the current
patchset).

Real-world throughput/quality comparison from the same physical
location (one interior wall between client and AP), same
firmware (0.35.42.1):

=C2=A0 5GHz, 240MHz (160+80 non-contiguous), separate SSID:
=C2=A0 =C2=A0 RSSI: -34 to -57 dBm
=C2=A0 =C2=A0 MCS: steady EHT-MCS 8-11 (2 streams), occasionally EHT-MCS 13
=C2=A0 =C2=A0 iperf3 -P4: 728 Mbit/s aggregate, 81 retransmits/30s

=C2=A0 6GHz, 160MHz, separate SSID:
=C2=A0 =C2=A0 RSSI: -65 dBm (AP has no AFC =E2=80=94 confirmed with vendor,=
 LPI-only,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 23dBm ceiling on 6GHz)
=C2=A0 =C2=A0 MCS: oscillating EHT-MCS 5-7 (2 streams)
=C2=A0 =C2=A0 iperf3 -P4: 889 Mbit/s aggregate, 800 retransmits/30s
=C2=A0 =C2=A0 (~8x more retransmits per Mbit/s than the 5GHz link)

Sharing in case it's useful data for prioritizing MLSR vs. MLMR
work, or for anyone else's testing/comparison =E2=80=94 not filing this
half as a bug, more as real-world confirmation that link quality
(not just raw throughput) matters for whichever link MLSR
switching logic favors.

System info:
=C2=A0 $ lspci -nn | grep -i realtek
=C2=A0=C2=A007:00.0 Network controller [0280]: Realtek Semiconductor Co., L=
td. RTL8922AE 802.11be PCIe Wireless Network Adapter [10ec:8922] (rev 01)

=C2=A0 $ uname -a
7.1.8-1-cachyos #1 SMP PREEMPT_DYNAMIC Mon, 10 Aug 2026 19:39:40 +0000 x86_=
64 GNU/Linux
=C2=A0 $ dmesg | grep -i "rtw89.*Firmware version"
=C2=A0=C2=A0[ =C2=A0 =C2=A07.404909] rtw89_8922ae 0000:07:00.0: Firmware ve=
rsion 0.35.42.1 (cc364c30), cmd version 1, type 1
[ =C2=A0 =C2=A07.404912] rtw89_8922ae 0000:07:00.0: Firmware version 0.35.4=
2.1 (cc364c30), cmd version 1, type 3
[ =C2=A0 =C2=A07.427821] rtw89_8922ae 0000:07:00.0: Firmware version 0.1.0.=
0 (86ec27bf), cmd version 0, types
