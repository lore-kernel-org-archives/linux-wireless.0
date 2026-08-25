Received: from mail-106101.protonmail.ch (mail-106101.protonmail.ch [79.135.106.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390621A8F84
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 02:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787625145; cv=none; b=QpiADGfI/k/0USPOoWm9NTRYG7fTVGmlOe9giAew5sd0Bq8XmXyS2L5WTks7N3YfDnf2UND5Qhu19jYEtARlUH1C1RV1kbT5LoJmHnfUHALFdaeS639VOrAy+bfE0dmMO8fpq1EwKiAjKy31sA8+fhaqAFvi88zfWNMaELqPTic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787625145; c=relaxed/simple;
	bh=ZG6d6zY13yF0YyZ1KJ+Aiq1Fsxb+I1yqY+Jek7Lf2o8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b2EJkCUniz+W6RBcZAk8aHUkzzIoJidvDxbEXtxO5jX1cJWqeq21pJ2q8BdP7MKIfJKf64adCf5dBsSRL92tSfGJLP0/+EJ3N4r+uhqYtv9NeTRa3ZmyDqb0SBSf4KJai5E3sgGuszRpeGkUgkbbcnpmE4ZSowXi1MHGrqVFFs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=h2TwMZcP; arc=none smtp.client-ip=79.135.106.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="h2TwMZcP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=hzypwy7bbzhizneszu6kthz64u.protonmail; t=1787625131; x=1787884331;
	bh=v3N9Jqwe3IUpHeLYbBtokhi6IabSDW5d5gsud1jQ9EQ=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=h2TwMZcPr0qMEsc0d1KWxf9R8h3i94bDaFfF+LAZcblbIoPZFQRRlkDuM2O0CKnIi
	 wuz1CVtqlc4LxONY+yZCeVWUCLemC/QmZKI71wxnKYvJEfPQ2OVC0PhmxRqF1JZe7Q
	 jV8CQNBSmCU5CkRISC0iXlmz5gShQ5gZtS6h8xdgRMaR30ZnZIJLpHfTmX6TkmCe5r
	 iCkPRvUogggBA2oF7POqndvCZ8g72cZlaPwDdkaT27WPWBizYlMonEW6U3e2/mpa6q
	 dw8r4tFAihuuEMhKn0djdH48dkxaUo8iZqVo5q/TGjc7gktPJ7keP8FuYUk9+Qqr5s
	 etPU2O7nyDkvg==
Date: Tue, 25 Aug 2026 02:32:04 +0000
To: Ping-Ke Shih <pkshih@realtek.com>
From: Louis <tux823@proton.me>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RE: [BUG] wifi: rtw89: firmware regression on RTL8922AE (0.35.80.3 vs 0.35.42.1)
Message-ID: <ntBTj6lgVjdRJmGOURjJKQbOBMl1yMi0Y3ZU2AXxTCaxnZY4TYJZMum-rn1bdrb0811MDltbz-4kGGegu6vD6EQIT-uTW7FEAeEbGGICEPw=@proton.me>
In-Reply-To: <e18a5267e0454874a510a9669924e190@realtek.com>
References: <-lvXDCNoYldP3-AEO0uA-s2_Ebvv7FA2sfz4o8Y-4GF7epAf9Qe8v7dBFApXrVhpR942H-CWduTWtKM31PAiEd44d-c2A4aVc3Z5uRmv7dE=@proton.me> <e18a5267e0454874a510a9669924e190@realtek.com>
Feedback-ID: 215313278:user:proton
X-Pm-Message-ID: 20a61833cc833a5acd307bbe6b99721e3b4eeced
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> Can you enlarge the rekey period of AP to see if anything change?

Will extend rekey interval on the AP (currently default, will bump to 24h o=
r disable if the AP allows) and retest on 0.35.80.3.

> sudo iw wlan0 set power_save off

Was running NetworkManager wifi.powersave=3D2 during testing but hadn't con=
firmed at the driver level. Will run this directly, verify with `iw wlan0 g=
et power_save`, and retest.

> Did you enable Bluetooth at the same time?

Yes, BT was on in both setups where this showed up. Will disable and retest=
 on 0.35.80.3.

> Also, can you share full kernel log?

Only had the two grepped lines so far. Will grab a full dmesg -T / journalc=
tl -k -b across a live drop and send that.

> Could you also do the same test with another AP (like hotspot of your pho=
ne)?

Will test against a phone hotspot too. My AP is a Zyxel Wi-Fi 7 model=
=E2=80=94 given the rekey/BT/powersave questions, my guess is this ends up =
being an interaction with one of those rather than a blanket regression, so=
 different AP behavior should help narrow it down.

Will run rekey/BT-off/power_save-off/hotspot as separate variables where I =
can and report back with the full log.

> What is the MLO patchset you mentioned?

Wasn't referring to a specific patch I applied =E2=80=94 just going off `iw=
 dev wlan0 info` showing MLD/link info when connected to an AP broadcasting=
 one SSID on 5/6GHz at once. Assumed that meant in-tree MLO (saw it referen=
ced as MLSR in LWN's coverage). Matches what I saw =E2=80=94 dual associati=
on at the AP, single active link in station dump =E2=80=94 so sounds like l=
ink-switching logic is still WIP. Good to know, will treat it as unstable f=
or now. Can keep sending link-quality data from my setup if that's useful f=
or that work.

Will follow up once I've run the above.



-------- Original Message --------
On Monday, 08/24/26 at 21:58 Ping-Ke Shih <pkshih@realtek.com> wrote:
Louis <tux823@proton.me> wrote:
> Hardware: Realtek RTL8922AE (rtw89_8922ae driver)
> Also tested on: RTL8922AE-VS (same PCI ID: 10ec:8922)
> Systems: Lenovo Yoga 7 14AKP10 (Type 83JR) [laptop, PCIe],
>          desktop (RTL8922AE via M.2-to-PCIe adapter, replacing a
>          QCNFA765/ath11k card)
> Kernels tested: CachyOS default, CachyOS zen, Arch (vanilla),
>                 mainline LTS =E2=80=94 regression reproduces identically
>                 on all of them, ruling out kernel version as a
>                 variable.
>
> =3D=3D=3D ISSUE 1: Firmware regression, reproduced across two
>     linux-firmware releases =3D=3D=3D
>
> Known-good firmware:
>   Firmware version 0.35.42.1 (cc364c30), cmd version 1, type 1
>   Firmware version 0.35.42.1 (cc364c30), cmd version 1, type 3
>
> Known-bad firmware:
>   Firmware version 0.35.80.3 (8ef4f0cf), cmd version 1, type 1
>   Firmware version 0.35.80.3 (8ef4f0cf), cmd version 1, type 3
>
> Symptoms on the bad firmware (0.35.80.3):
>   - Intermittent disconnects on both 5GHz and 6GHz, under load or after 3=
-5 minutes
>     (observed most reliably during sustained transfer / speedtest)
>   - Recurring log line preceding drops:
>       "rtw89_8922ae 0000:03:00.0: sec cam entry is empty"

This says it can't find a corresponding security key entry, so
I guess it happen after re-key. Can you enlarge the rekey
period of AP to see if anything change?

Since the firmware changes power save timing between the two
firmware, so another try is to disable power save by:
   sudo iw wlan0 set power_save off

Did you enable Bluetooth at the same time? If so, please try
to disable it because firmware also changed some BT-coexistence
mechanism.

Also, can you share full kernel log?

>   - Followed by reassociation failures:
>       "wlan0: deauthenticated from <MAC> while associating
>        (Reason: 9=3DSTA_REQ_ASSOC_WITHOUT_AUTH)"
>   - Ruled out as the cause before landing on firmware:
>       DFS channel-vacate events, router DCS (dynamic channel
>       selection), PCIe ASPM L1, GTK/group-rekey interval,
>       kernel choice (4 different kernels tested)
>
> Reproduction:
>   1. Install current linux-firmware (rtw8922a_fw-4.bin loads,
>      version 0.35.80.3)
>   2. Sustained transfer / speedtest on 5GHz or 6GHz, wide channel
>      (160MHz+) =E2=80=94 disconnect + "sec cam entry is empty" +
>      reason-9 reassoc failure within minutes
>   3. Move/delete the -3.bin and -4.bin firmware files so the
>      driver falls back to an earlier bundled version
>      (0.35.42.1 (cc364c30) loads) =E2=80=94 stable indefinitely under
>      the same load/test conditions

By the way, I setup my environment (I use the latest driver) to run iperf3
with firmware 0.35.80.3 on 5GHz band for 999 seconds TX/RX respectively.
No disconnection.
Could you also do the same test with another AP (like hotspot of your phone=
)?

>
> This was independently reproduced a second time after a
> subsequent linux-firmware update reintroduced the same -3/-4
> files =E2=80=94 same fix (remove them, fall back to 0.35.42.1) resolved
> it identically both times. Confirms this isn't a one-off but a
> persistent regression carried across releases.
>
> Happy to test candidate fixes or provide a fuller dmesg/pcap
> capture around a live drop if useful =E2=80=94 I have the reproduction
> steps down to a few minutes reliably.
>
> =3D=3D=3D ISSUE 2 (informational, not a bug report): MLO/MLSR real-world
>     test data =3D=3D=3D
>
> Tested the MLO patchset (MLSR =E2=80=94 link-switching) with an AP
> broadcasting one SSID across 5GHz and 6GHz simultaneously.

What is the MLO patchset you mentioned?

> AP-side confirms the client associated on both bands at once.
> `iw dev wlan0 station dump` shows only a single active tx/rx
> bitrate pair at a time (consistent with MLSR link-switching
> rather than MLMR aggregation, as expected given the current
> patchset).
>
> Real-world throughput/quality comparison from the same physical
> location (one interior wall between client and AP), same
> firmware (0.35.42.1):
>
>   5GHz, 240MHz (160+80 non-contiguous), separate SSID:
>     RSSI: -34 to -57 dBm
>     MCS: steady EHT-MCS 8-11 (2 streams), occasionally EHT-MCS 13
>     iperf3 -P4: 728 Mbit/s aggregate, 81 retransmits/30s
>
>   6GHz, 160MHz, separate SSID:
>     RSSI: -65 dBm (AP has no AFC =E2=80=94 confirmed with vendor, LPI-onl=
y,
>           23dBm ceiling on 6GHz)
>     MCS: oscillating EHT-MCS 5-7 (2 streams)
>     iperf3 -P4: 889 Mbit/s aggregate, 800 retransmits/30s
>     (~8x more retransmits per Mbit/s than the 5GHz link)
>
> Sharing in case it's useful data for prioritizing MLSR vs. MLMR
> work, or for anyone else's testing/comparison =E2=80=94 not filing this
> half as a bug, more as real-world confirmation that link quality
> (not just raw throughput) matters for whichever link MLSR
> switching logic favors.

Currently, rtw89 has MLO capability (as you saw by iw) but we are
still cooking the rules to switch link though.

Ping-Ke


