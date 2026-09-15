Received: from mail-43167.protonmail.ch (mail-43167.protonmail.ch [185.70.43.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459AF38AC75
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 04:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789447813; cv=none; b=MOz+z4FHQMc2grMw2yCUc1T1bFp//Lu9TXN959B28c/tijxxiq8OpOpWEVMgTt1FTRflXj6zwwFBXIg+a/jG4qt42ZhMefLvuM9xyaeQH/QVpgac8ceffS9p0T9DGMVRGYlNvbGh1Yq24H9KhvIcdZ31qvyydl2k5VFsb2SuTyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789447813; c=relaxed/simple;
	bh=Gzf73VAvO2gGkA/4r31XEy85w3LQV+p2MTMC/YJpovE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t6xcvPhem2ciY5VPtcvr21KSPQJlLqilVCac9jrgOIXQcPj3t8Me9RsZhi8GKCCqb+7nVdS3x+r1yj2CDdBzRjwVt9fTGg/gkpw8k1avR26XCgZmkYW/uUGepttAAK4lpA04eq1f8nTXBIQwBLa2UDpc0onyY1vk84VPSPr3Xac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=I1XbBXkH; arc=none smtp.client-ip=185.70.43.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="I1XbBXkH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1789447799; x=1789706999;
	bh=t5dLkLn092NgNDh9jnhiAOnOH8y78k0lD163OQYcbxw=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=I1XbBXkHjWfNnQnLp7n4ZLIEx9YM3sNIhP4gnMybKDS8vKBYF7qPnFaQZ5FXoArTs
	 DjQk3gnG2/3kCDv9+N0a31LiPJp+n23zOUUgYTqK9yf+lQJdGua9yf3iX/xyqe1/i2
	 6iYtM2bC8WI/57WsJszKjhImNgMJkZMJkoRC1dxughiQtYZeubonIOwaQ6F03jvi2K
	 uGZfm/zdwEp6n/+8hNhtJTdkqlJKePyUgkKIw8RmJzw+7sDnHsNWl22fcP0zVqqvSg
	 agRkrpFj/ps3qr5ZKSoTyMJZDDY+lxvJc8B3QiF4vGrryQB/wzfOaAlsc9io5TZbuS
	 8Wnzel7QV6TAA==
Date: Tue, 15 Sep 2026 04:49:56 +0000
To: Ping-Ke Shih <pkshih@realtek.com>
From: Louis <tux823@proton.me>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RE: [BUG] wifi: rtw89: firmware regression on RTL8922AE (0.35.80.3 vs 0.35.42.1)
Message-ID: <8dT8ASp8Lp0slC8-7z8T7nbiiGTOeXZazk6vCzEDi8n-zqUBkJn5ZwiS_WWjszVv8x_8igpxu4i5nyoE55TM-Q0kRiyLJmoPcG3dfTc_7mI=@proton.me>
In-Reply-To: <ntBTj6lgVjdRJmGOURjJKQbOBMl1yMi0Y3ZU2AXxTCaxnZY4TYJZMum-rn1bdrb0811MDltbz-4kGGegu6vD6EQIT-uTW7FEAeEbGGICEPw=@proton.me>
References: <-lvXDCNoYldP3-AEO0uA-s2_Ebvv7FA2sfz4o8Y-4GF7epAf9Qe8v7dBFApXrVhpR942H-CWduTWtKM31PAiEd44d-c2A4aVc3Z5uRmv7dE=@proton.me> <e18a5267e0454874a510a9669924e190@realtek.com> <ntBTj6lgVjdRJmGOURjJKQbOBMl1yMi0Y3ZU2AXxTCaxnZY4TYJZMum-rn1bdrb0811MDltbz-4kGGegu6vD6EQIT-uTW7FEAeEbGGICEPw=@proton.me>
Feedback-ID: 215313278:user:proton
X-Pm-Message-ID: d6ff566709441aa9550e2b6bdcf06e5323ef4309
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Following up with a bit more isolation testing on the AP side.

Checked the AP logs directly for the disconnect events =E2=80=94 they show =
"disconnected by STA timeout/reconnect" rather than an AP-initiated deauth =
with a reason code, and the timeout fires at exactly 3 minutes, which seems=
 to match the AP's stock/default inactivity timer (unmodified). This sugges=
ts the AP isn't dropping the client for a policy reason, but rather declari=
ng it gone after it stops hearing from it =E2=80=94 which may indicate the =
client goes unresponsive first, with the AP's log entry landing however lon=
g after based on its own timer rather than right when the actual fault occu=
rs.

Also retested with 80MHz channels on both 5GHz and 6GHz (in addition to the=
 160MHz testing already mentioned) and got the same failure at what seems l=
ike the same reliability, so channel width doesn't appear to be a factor ei=
ther.

Between the ath11k client not reproducing under the same AP/config across a=
ll those variations (BT on/off, 24h rekey, power save off, 80/160MHz) and t=
he AP-side timeout behavior above, this continues to point toward something=
 firmware-side on the Realtek chipset rather than an AP or driver/kernel is=
sue =E2=80=94 though happy to run further tests if useful.

On Monday, August 24th, 2026 at 10:32 PM, Louis <tux823@proton.me> wrote:

>=20
> > Can you enlarge the rekey period of AP to see if anything change?
>=20
> Will extend rekey interval on the AP (currently default, will bump to 24h=
 or disable if the AP allows) and retest on 0.35.80.3.
>=20
> > sudo iw wlan0 set power_save off
>=20
> Was running NetworkManager wifi.powersave=3D2 during testing but hadn't c=
onfirmed at the driver level. Will run this directly, verify with `iw wlan0=
 get power_save`, and retest.
>=20
> > Did you enable Bluetooth at the same time?
>=20
> Yes, BT was on in both setups where this showed up. Will disable and rete=
st on 0.35.80.3.
>=20
> > Also, can you share full kernel log?
>=20
> Only had the two grepped lines so far. Will grab a full dmesg -T / journa=
lctl -k -b across a live drop and send that.
>=20
> > Could you also do the same test with another AP (like hotspot of your p=
hone)?
>=20
> Will test against a phone hotspot too. My AP is a Zyxel Wi-Fi 7 model=
=E2=80=94 given the rekey/BT/powersave questions, my guess is this ends up =
being an interaction with one of those rather than a blanket regression, so=
 different AP behavior should help narrow it down.
>=20
> Will run rekey/BT-off/power_save-off/hotspot as separate variables where =
I can and report back with the full log.
>=20
> > What is the MLO patchset you mentioned?
>=20
> Wasn't referring to a specific patch I applied =E2=80=94 just going off `=
iw dev wlan0 info` showing MLD/link info when connected to an AP broadcasti=
ng one SSID on 5/6GHz at once. Assumed that meant in-tree MLO (saw it refer=
enced as MLSR in LWN's coverage). Matches what I saw =E2=80=94 dual associa=
tion at the AP, single active link in station dump =E2=80=94 so sounds like=
 link-switching logic is still WIP. Good to know, will treat it as unstable=
 for now. Can keep sending link-quality data from my setup if that's useful=
 for that work.
>=20
> Will follow up once I've run the above.
>=20
>=20
>=20
> -------- Original Message --------
> On Monday, 08/24/26 at 21:58 Ping-Ke Shih <pkshih@realtek.com> wrote:
> Louis <tux823@proton.me> wrote:
> > Hardware: Realtek RTL8922AE (rtw89_8922ae driver)
> > Also tested on: RTL8922AE-VS (same PCI ID: 10ec:8922)
> > Systems: Lenovo Yoga 7 14AKP10 (Type 83JR) [laptop, PCIe],
> >          desktop (RTL8922AE via M.2-to-PCIe adapter, replacing a
> >          QCNFA765/ath11k card)
> > Kernels tested: CachyOS default, CachyOS zen, Arch (vanilla),
> >                 mainline LTS =E2=80=94 regression reproduces identicall=
y
> >                 on all of them, ruling out kernel version as a
> >                 variable.
> >
> > =3D=3D=3D ISSUE 1: Firmware regression, reproduced across two
> >     linux-firmware releases =3D=3D=3D
> >
> > Known-good firmware:
> >   Firmware version 0.35.42.1 (cc364c30), cmd version 1, type 1
> >   Firmware version 0.35.42.1 (cc364c30), cmd version 1, type 3
> >
> > Known-bad firmware:
> >   Firmware version 0.35.80.3 (8ef4f0cf), cmd version 1, type 1
> >   Firmware version 0.35.80.3 (8ef4f0cf), cmd version 1, type 3
> >
> > Symptoms on the bad firmware (0.35.80.3):
> >   - Intermittent disconnects on both 5GHz and 6GHz, under load or after=
 3-5 minutes
> >     (observed most reliably during sustained transfer / speedtest)
> >   - Recurring log line preceding drops:
> >       "rtw89_8922ae 0000:03:00.0: sec cam entry is empty"
>=20
> This says it can't find a corresponding security key entry, so
> I guess it happen after re-key. Can you enlarge the rekey
> period of AP to see if anything change?
>=20
> Since the firmware changes power save timing between the two
> firmware, so another try is to disable power save by:
>    sudo iw wlan0 set power_save off
>=20
> Did you enable Bluetooth at the same time? If so, please try
> to disable it because firmware also changed some BT-coexistence
> mechanism.
>=20
> Also, can you share full kernel log?
>=20
> >   - Followed by reassociation failures:
> >       "wlan0: deauthenticated from <MAC> while associating
> >        (Reason: 9=3DSTA_REQ_ASSOC_WITHOUT_AUTH)"
> >   - Ruled out as the cause before landing on firmware:
> >       DFS channel-vacate events, router DCS (dynamic channel
> >       selection), PCIe ASPM L1, GTK/group-rekey interval,
> >       kernel choice (4 different kernels tested)
> >
> > Reproduction:
> >   1. Install current linux-firmware (rtw8922a_fw-4.bin loads,
> >      version 0.35.80.3)
> >   2. Sustained transfer / speedtest on 5GHz or 6GHz, wide channel
> >      (160MHz+) =E2=80=94 disconnect + "sec cam entry is empty" +
> >      reason-9 reassoc failure within minutes
> >   3. Move/delete the -3.bin and -4.bin firmware files so the
> >      driver falls back to an earlier bundled version
> >      (0.35.42.1 (cc364c30) loads) =E2=80=94 stable indefinitely under
> >      the same load/test conditions
>=20
> By the way, I setup my environment (I use the latest driver) to run iperf=
3
> with firmware 0.35.80.3 on 5GHz band for 999 seconds TX/RX respectively.
> No disconnection.
> Could you also do the same test with another AP (like hotspot of your pho=
ne)?
>=20
> >
> > This was independently reproduced a second time after a
> > subsequent linux-firmware update reintroduced the same -3/-4
> > files =E2=80=94 same fix (remove them, fall back to 0.35.42.1) resolved
> > it identically both times. Confirms this isn't a one-off but a
> > persistent regression carried across releases.
> >
> > Happy to test candidate fixes or provide a fuller dmesg/pcap
> > capture around a live drop if useful =E2=80=94 I have the reproduction
> > steps down to a few minutes reliably.
> >
> > =3D=3D=3D ISSUE 2 (informational, not a bug report): MLO/MLSR real-worl=
d
> >     test data =3D=3D=3D
> >
> > Tested the MLO patchset (MLSR =E2=80=94 link-switching) with an AP
> > broadcasting one SSID across 5GHz and 6GHz simultaneously.
>=20
> What is the MLO patchset you mentioned?
>=20
> > AP-side confirms the client associated on both bands at once.
> > `iw dev wlan0 station dump` shows only a single active tx/rx
> > bitrate pair at a time (consistent with MLSR link-switching
> > rather than MLMR aggregation, as expected given the current
> > patchset).
> >
> > Real-world throughput/quality comparison from the same physical
> > location (one interior wall between client and AP), same
> > firmware (0.35.42.1):
> >
> >   5GHz, 240MHz (160+80 non-contiguous), separate SSID:
> >     RSSI: -34 to -57 dBm
> >     MCS: steady EHT-MCS 8-11 (2 streams), occasionally EHT-MCS 13
> >     iperf3 -P4: 728 Mbit/s aggregate, 81 retransmits/30s
> >
> >   6GHz, 160MHz, separate SSID:
> >     RSSI: -65 dBm (AP has no AFC =E2=80=94 confirmed with vendor, LPI-o=
nly,
> >           23dBm ceiling on 6GHz)
> >     MCS: oscillating EHT-MCS 5-7 (2 streams)
> >     iperf3 -P4: 889 Mbit/s aggregate, 800 retransmits/30s
> >     (~8x more retransmits per Mbit/s than the 5GHz link)
> >
> > Sharing in case it's useful data for prioritizing MLSR vs. MLMR
> > work, or for anyone else's testing/comparison =E2=80=94 not filing this
> > half as a bug, more as real-world confirmation that link quality
> > (not just raw throughput) matters for whichever link MLSR
> > switching logic favors.
>=20
> Currently, rtw89 has MLO capability (as you saw by iw) but we are
> still cooking the rules to switch link though.
>=20
> Ping-Ke
>=20
> 
