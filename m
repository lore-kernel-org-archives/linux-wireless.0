Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8255A233943
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533334; cv=pass; b=SO6isDuRt5T3iTcEKJW+r0dPbwj3BKL+Y+8FSZNfi5/mFffADsM0rE0VcbjpyfZ5oO2oIFXJiV+ghIo2WlDgoq5ymIc4WwzbG+aynJiX8zpQI3pHbS+iPWqRzC2l7jFS8c6hZsZON+4m9vMVPyQIE04PSgITrP4TPwSqe35hotU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533334; c=relaxed/simple;
	bh=r/glO/+R1W2C1IEAEjYNldOmEWyL88F7YkoDXpznb98=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=TK2SeVQ53fhDh+u+BoI1Cn+keRgKVHUi17PJdylCZ261vlmq8E6DukJaRNaFKie/Q+n7rKO3zwyMDFK5+OnM9EBm05SH6h243Eb2seaHtpoD7iruVzN4Ef85WYnu7PnLzWkhguroCEKoeWdgUB8mfbjGP6yOC2GAhCNvA8tRRiw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=deSv8yeN; arc=pass smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="deSv8yeN"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5c664b8c3f3so999325e0c.0
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 07:48:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788533331; cv=none;
        d=google.com; s=arc-20260327;
        b=XpqHvwNF9DS6J8ZvWRd8NKgFUAk3EwBoXonz7fnSI9f8R6SS0zBulPg+DSOQOSrqjH
         XnTgmPqzDwn0eMXnXIaRN/IejT2UKYtzGfqF9YRWrGXO8DygQj7FmpXh1hmO9SXSyqHY
         7CZf/GhOaMV81y3zPdif145NMon93UQsSPqUvNBT3Pw5wPxURGQJWVw9bBUybfpudgyu
         kxgYxWPTdjYDAMy4o31XnMBWaTOVPMvKTUv+5gsz32TDgL4k1I3kaGq7XQ17MJY1bVdy
         Ev5PoXTwCYkaWx3ghjsE6i4c2VMkza1B3nNw9U324IR1eveyjs2bdEclv1Z08BfZtpOl
         4pwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=xRp2qbhNnZYCvPGXtygRN4eS4CVHs8lGhjeRa05MEnU=;
        fh=Ez3Dem7vj09by54oGA/z8QZtD0i4mlvhzcPmvVdjAVI=;
        b=Ha6eTJLhBQgjO59E50tUdX6KaY0ikoZ3yHKXNNfIAu0V+y4wOKfWS8k9/eoWj+FDbe
         kbMveSef2R0ByucTE7Km6HGiQwYr68M6j0kvDs3QAbh2xXXvT7GqRV1+yDsvQctqy/ca
         P2JOp6vAjMcay7lsmKc6XP542zsBD8Uf637MW6NJApcaTKH1joH+epF60dCUes0dDuUB
         ydbpxthIGd5DJQJaL9V0RSv7zKtRxwhndqTKT3/LdSwcA+js0yR3Ca4F9R5wjg2HZ6kq
         u7Faak1618Xk4YkuDkG73gNeY/2iaDmjYuecEylVBYQeM/88d9XVWPt7k542Gby9yS5o
         te6w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788533331; x=1789138131; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xRp2qbhNnZYCvPGXtygRN4eS4CVHs8lGhjeRa05MEnU=;
        b=deSv8yeNCIqm0PPPp7MdzHa0kj3J3jMvyn7tVvA0P+2SyolOmSmte0v1yXITRSVu31
         UTkp12aNtBgEWrj9BVPxIt7AXozyc+4DX3+gWgHtH1yI/rPSlbB/xfnDwgB209ijKzH7
         bBbR81CQ+vzOuH5qUAeW0rA44EJ/SXgvu1WKXHQdsgdshHz+xG2yqSPpf1OOg0tk3yuL
         G0v2dWio0q75+3TGWebEHuvoFnHBk3fjDijzAokf3ecLNDSdePagfqA6xgNiTqBHwVFX
         0KALINvBbKHbTDjzbSRgDVwflpYaRNj6OKzDmvohN3hwQcyTMr4F4hBGfDW5uV5hys4K
         7BYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788533331; x=1789138131;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xRp2qbhNnZYCvPGXtygRN4eS4CVHs8lGhjeRa05MEnU=;
        b=nVqY/FemoYIRLKYdK5dXnNaR5aKV0uyw8v5wB3QCtBJiKsWnwfTiWF+V8U6arrCx90
         SYzOeCu3763h3HaQ7bOn48QRTI0DqRhXSlqAt2WqsvW3vWaFnGEkWiGOk6RYvbNjRp71
         IEFGDWHDDJzCft6yHyeyvDUo55uzPv/0au1xM1poMHaey44X/tA37PKr21fb68JMdzOf
         wP+LL0es+DZV2Srg9fJnIRJznU28FszdeJln9v5VCgToMP5OU2G6STSydmisbY4/Ss35
         WfMt4xkaCK4IQMpNfabjLjZs/RI5DDsU1tTLh1zesDndpk5PE/k1EnbRSlnePbXJpzeG
         iRQg==
X-Gm-Message-State: AFuF++kIJrZOGdVNmEHeRc+1WL/SJtHXO3MwkmgvFL2mClvaV/L0BnOh
	Hs2uj5qRW8BAS6Ef0TWgT3kRIPuKi2adWq57l6xvBRScKLiCoVHnbu9VKs6pw1h7uauHUpgXFkl
	tBVtGIbEvEbGbU+1b3o4EVqQzEHCJLcUUzCc=
X-Gm-Gg: AYBFou2u+ipixm7Pd8m5C2rIGE2cqXuo66lPsIwV9p26FsZda+QZ/sP0HEXoywTOCWB
	8/gKVCv+zNAKvfc2VL4OKroCUppWA32n3rlA3RdQXF28HXZc5o1+RtotsQcotc7qSblk/d3Ud0l
	7Leq4dRTFRQea6xXO8KRbEVM4S1mFfLt8gfIxcEfAzmafz13tSh5qvYtExooE/QF/SiH4wFqs1G
	vqqXeS4vYleDGTaP7aSVjd5HMeZv4OjCVEiRik+wVOihhQtve463T9A2ReQKtquGYjaGMV5HrvX
	+0Qa9LGAeeOCjffNAZOqasD8IT+TcXOBEVG28trO5lYPwjpmrCHoAy0g7K4YZlA1Pkl7/rT5/w=
	=
X-Received: by 2002:a05:6102:509f:b0:785:e444:15e4 with SMTP id
 ada2fe7eead31-78a4a87d391mr2435641137.6.1788533331311; Fri, 04 Sep 2026
 07:48:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: ilya ivanov <chusovles@gmail.com>
Date: Fri, 4 Sep 2026 16:48:39 +0200
X-Gm-Features: AcwNN1VqwCiA5I_vGhzV6DiNwxiEWhG20Ns7f_ocCVgp5EH5yMjAJZEuZP-IEy4
Message-ID: <CAPw3oQRL3K_ET6WziAeWQdXykqnW0QMC1ZLq+FL1W-WL1MPreA@mail.gmail.com>
Subject: [BUG] mt7921e: Bluetooth coexistence causes periodic Wi-Fi TX stalls;
 5 GHz recovers only after Bluetooth reset
To: linux-wireless@vger.kernel.org
Cc: linux-bluetooth@vger.kernel.org, Felix Fietkau <nbd@nbd.name>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>
Content-Type: multipart/mixed; boundary="000000000000e20554065aa95d1f"

--000000000000e20554065aa95d1f
Content-Type: multipart/alternative; boundary="000000000000e20554065aa95d1d"

--000000000000e20554065aa95d1d
Content-Type: text/plain; charset="UTF-8"

Hello,

I am seeing a reproducible Wi-Fi/Bluetooth coexistence problem with a
MediaTek MT7921/MT7961 combo adapter on Fedora 44.

Hardware
========

Wi-Fi:
  MediaTek MT7921 PCIe
  PCI ID: 14c3:7961
  driver: mt7921e

Bluetooth:
  Foxconn / Hon Hai MediaTek Bluetooth Adapter
  USB ID: 0489:e0cd
  drivers: btusb + btmtk
  HCI public address: 38:D5:7A:AF:C3:08

Software
========

Distribution: Fedora 44
Kernel: 7.1.12-200.fc44.x86_64
linux-firmware: 20260810-1.fc44

Wi-Fi firmware currently loaded:
  HW/SW Version: 0x8a108a10
  Build Time: 20260224110909a
  WM Firmware Build Time: 20260224110949

Bluetooth controller:
  HCI 5.3
  MediaTek
  firmware build generation observed: 20260224

Symptom
=======

When Bluetooth is active, Wi-Fi uplink traffic develops highly regular
latency stalls. ICMP requests appear to be queued and released in batches.

A typical ping at 50 ms intervals looks like:

  ~100 ms
  ~50 ms
  ~1-2 ms
  ~1-2 ms
  ~100 ms
  ~50 ms
  ...

There is normally no packet loss.

Typical bad result:

  rtt min/avg/max/mdev = 1.2/32-55/110-300/...

With Bluetooth disabled, the same Wi-Fi link is stable:

  rtt min/avg/max/mdev = ~1.3/~1.8/~5-9/...

Localization
============

The delay was localized to the station transmit path.

A simultaneous tcpdump on the Fedora host and packet capture/sniffer on
the access point showed:

  * ICMP requests are generated/captured locally at regular intervals.
  * The AP receives those requests only after the large delay.
  * The AP replies immediately once the request arrives.

Therefore the delay occurs before the Wi-Fi frame reaches the AP.

The issue was reproduced against two different access points and on both
2.4 GHz and 5 GHz.

Bluetooth A/B
=============

The Bluetooth state controls the problem very clearly.

Bluetooth rfkill blocked:
  stable Wi-Fi, approximately 1-2 ms

Bluetooth active:
  periodic Wi-Fi TX stalls

BlueZ is not required to trigger the problem.

I stopped/masked bluetooth.service and manually brought hci0 UP:

  bluetooth.service: inactive
  hci0: UP RUNNING

Wi-Fi immediately became bad again:

  rtt min/avg/max/mdev = 1.190/54.967/302.338/63.335 ms

When hci0 is DOWN, Wi-Fi becomes stable.

Other tests already performed
=============================

The following did NOT solve the problem:

  * Wi-Fi power saving disabled
  * mt7921e disable_aspm=1
  * kernels 7.1.9, 7.1.10 and 7.1.12
  * older linux-firmware 20260309
  * Bluetooth USB runtime autosuspend disabled
  * Bluetooth discovery disabled
  * discoverable/pairable disabled
  * BlueZ stopped
  * WPA2-only
  * disabling 802.11r/FT
  * fixed BSSID
  * 20 MHz / fixed channel / non-AX testing
  * different AP
  * both 2.4 GHz and 5 GHz

Bluetooth scanning does not appear to be the root cause.

A btmon trace after Bluetooth initialization showed BlueZ enabling
passive LE extended scanning, but in one known-good 5 GHz state that scan
was enabled while Wi-Fi latency remained around 1.7 ms.

Band-dependent behavior
=======================

There is an especially reproducible state transition:

1. Associate Wi-Fi to 5 GHz.
2. rfkill block Bluetooth.
3. rfkill unblock Bluetooth.
4. Wi-Fi becomes stable while Bluetooth remains powered.

Example:

  Wi-Fi frequency: 5220 MHz
  Bluetooth: Powered: yes

  immediately after Bluetooth reset:
    rtt min/avg/max/mdev = 1.331/1.809/5.916/0.522 ms

  after another 30 seconds:
    rtt min/avg/max/mdev = 1.290/1.706/5.071/0.457 ms

If I then switch Wi-Fi from this good 5 GHz state to 2.4 GHz without
touching Bluetooth, the stalls return immediately:

  Wi-Fi frequency: 2472 MHz
  rtt min/avg/max/mdev = 1.246/35.229/115.608/39.027 ms

Resetting Bluetooth while already associated on 2.4 GHz does NOT fix it:

  rtt min/avg/max/mdev = 1.245/32.091/114.506/37.392 ms

An additional observation is that switching from a bad state to 5 GHz
does not always clear the stalls by itself. Resetting Bluetooth after the
5 GHz association does.

This makes the problem look like an incorrect or stale coexistence state
rather than ordinary 2.4 GHz RF interference alone.

Reproducer
==========

I have attached a shell script which performs:

  5 GHz association
  -> Bluetooth reset
  -> ping
  -> switch to 2.4 GHz without touching Bluetooth
  -> ping
  -> Bluetooth reset on 2.4 GHz
  -> ping
  -> switch back to 5 GHz
  -> ping
  -> Bluetooth reset on 5 GHz
  -> ping

It also records kernel, PCI/USB, firmware, module, rfkill and link
information in one log.

I can also provide the complete btmon trace and simultaneous host/AP
packet captures if useful.

Please let me know if there are any mt76/mt7921 or btmtk debug options,
firmware traces, or test patches that would help isolate the coexistence
state transition.

Regards,
Ilya

--000000000000e20554065aa95d1d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<br><br>I am seeing a reproducible Wi-Fi/Bluetooth c=
oexistence problem with a<br>MediaTek MT7921/MT7961 combo adapter on Fedora=
 44.<br><br>Hardware<br>=3D=3D=3D=3D=3D=3D=3D=3D<br><br>Wi-Fi:<br>=C2=A0 Me=
diaTek MT7921 PCIe<br>=C2=A0 PCI ID: 14c3:7961<br>=C2=A0 driver: mt7921e<br=
><br>Bluetooth:<br>=C2=A0 Foxconn / Hon Hai MediaTek Bluetooth Adapter<br>=
=C2=A0 USB ID: 0489:e0cd<br>=C2=A0 drivers: btusb + btmtk<br>=C2=A0 HCI pub=
lic address: 38:D5:7A:AF:C3:08<br><br>Software<br>=3D=3D=3D=3D=3D=3D=3D=3D<=
br><br>Distribution: Fedora 44<br>Kernel: 7.1.12-200.fc44.x86_64<br>linux-f=
irmware: 20260810-1.fc44<br><br>Wi-Fi firmware currently loaded:<br>=C2=A0 =
HW/SW Version: 0x8a108a10<br>=C2=A0 Build Time: 20260224110909a<br>=C2=A0 W=
M Firmware Build Time: 20260224110949<br><br>Bluetooth controller:<br>=C2=
=A0 HCI 5.3<br>=C2=A0 MediaTek<br>=C2=A0 firmware build generation observed=
: 20260224<br><br>Symptom<br>=3D=3D=3D=3D=3D=3D=3D<br><br>When Bluetooth is=
 active, Wi-Fi uplink traffic develops highly regular<br>latency stalls. IC=
MP requests appear to be queued and released in batches.<br><br>A typical p=
ing at 50 ms intervals looks like:<br><br>=C2=A0 ~100 ms<br>=C2=A0 ~50 ms<b=
r>=C2=A0 ~1-2 ms<br>=C2=A0 ~1-2 ms<br>=C2=A0 ~100 ms<br>=C2=A0 ~50 ms<br>=
=C2=A0 ...<br><br>There is normally no packet loss.<br><br>Typical bad resu=
lt:<br><br>=C2=A0 rtt min/avg/max/mdev =3D 1.2/32-55/110-300/...<br><br>Wit=
h Bluetooth disabled, the same Wi-Fi link is stable:<br><br>=C2=A0 rtt min/=
avg/max/mdev =3D ~1.3/~1.8/~5-9/...<br><br>Localization<br>=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D<br><br>The delay was localized to the station transmi=
t path.<br><br>A simultaneous tcpdump on the Fedora host and packet capture=
/sniffer on<br>the access point showed:<br><br>=C2=A0 * ICMP requests are g=
enerated/captured locally at regular intervals.<br>=C2=A0 * The AP receives=
 those requests only after the large delay.<br>=C2=A0 * The AP replies imme=
diately once the request arrives.<br><br>Therefore the delay occurs before =
the Wi-Fi frame reaches the AP.<br><br>The issue was reproduced against two=
 different access points and on both<br>2.4 GHz and 5 GHz.<br><br>Bluetooth=
 A/B<br>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br><br>The Bluetooth state =
controls the problem very clearly.<br><br>Bluetooth rfkill blocked:<br>=C2=
=A0 stable Wi-Fi, approximately 1-2 ms<br><br>Bluetooth active:<br>=C2=A0 p=
eriodic Wi-Fi TX stalls<br><br>BlueZ is not required to trigger the problem=
.<br><br>I stopped/masked bluetooth.service and manually brought hci0 UP:<b=
r><br>=C2=A0 bluetooth.service: inactive<br>=C2=A0 hci0: UP RUNNING<br><br>=
Wi-Fi immediately became bad again:<br><br>=C2=A0 rtt min/avg/max/mdev =3D =
1.190/54.967/302.338/63.335 ms<br><br>When hci0 is DOWN, Wi-Fi becomes stab=
le.<br><br>Other tests already performed<br>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br><br>The follow=
ing did NOT solve the problem:<br><br>=C2=A0 * Wi-Fi power saving disabled<=
br>=C2=A0 * mt7921e disable_aspm=3D1<br>=C2=A0 * kernels 7.1.9, 7.1.10 and =
7.1.12<br>=C2=A0 * older linux-firmware 20260309<br>=C2=A0 * Bluetooth USB =
runtime autosuspend disabled<br>=C2=A0 * Bluetooth discovery disabled<br>=
=C2=A0 * discoverable/pairable disabled<br>=C2=A0 * BlueZ stopped<br>=C2=A0=
 * WPA2-only<br>=C2=A0 * disabling 802.11r/FT<br>=C2=A0 * fixed BSSID<br>=
=C2=A0 * 20 MHz / fixed channel / non-AX testing<br>=C2=A0 * different AP<b=
r>=C2=A0 * both 2.4 GHz and 5 GHz<br><br>Bluetooth scanning does not appear=
 to be the root cause.<br><br>A btmon trace after Bluetooth initialization =
showed BlueZ enabling<br>passive LE extended scanning, but in one known-goo=
d 5 GHz state that scan<br>was enabled while Wi-Fi latency remained around =
1.7 ms.<br><br>Band-dependent behavior<br>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br><br>There is an especially reproduc=
ible state transition:<br><br>1. Associate Wi-Fi to 5 GHz.<br>2. rfkill blo=
ck Bluetooth.<br>3. rfkill unblock Bluetooth.<br>4. Wi-Fi becomes stable wh=
ile Bluetooth remains powered.<br><br>Example:<br><br>=C2=A0 Wi-Fi frequenc=
y: 5220 MHz<br>=C2=A0 Bluetooth: Powered: yes<br><br>=C2=A0 immediately aft=
er Bluetooth reset:<br>=C2=A0 =C2=A0 rtt min/avg/max/mdev =3D 1.331/1.809/5=
.916/0.522 ms<br><br>=C2=A0 after another 30 seconds:<br>=C2=A0 =C2=A0 rtt =
min/avg/max/mdev =3D 1.290/1.706/5.071/0.457 ms<br><br>If I then switch Wi-=
Fi from this good 5 GHz state to 2.4 GHz without<br>touching Bluetooth, the=
 stalls return immediately:<br><br>=C2=A0 Wi-Fi frequency: 2472 MHz<br>=C2=
=A0 rtt min/avg/max/mdev =3D 1.246/35.229/115.608/39.027 ms<br><br>Resettin=
g Bluetooth while already associated on 2.4 GHz does NOT fix it:<br><br>=C2=
=A0 rtt min/avg/max/mdev =3D 1.245/32.091/114.506/37.392 ms<br><br>An addit=
ional observation is that switching from a bad state to 5 GHz<br>does not a=
lways clear the stalls by itself. Resetting Bluetooth after the<br>5 GHz as=
sociation does.<br><br>This makes the problem look like an incorrect or sta=
le coexistence state<br>rather than ordinary 2.4 GHz RF interference alone.=
<br><br>Reproducer<br>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br><br>I have attached=
 a shell script which performs:<br><br>=C2=A0 5 GHz association<br>=C2=A0 -=
&gt; Bluetooth reset<br>=C2=A0 -&gt; ping<br>=C2=A0 -&gt; switch to 2.4 GHz=
 without touching Bluetooth<br>=C2=A0 -&gt; ping<br>=C2=A0 -&gt; Bluetooth =
reset on 2.4 GHz<br>=C2=A0 -&gt; ping<br>=C2=A0 -&gt; switch back to 5 GHz<=
br>=C2=A0 -&gt; ping<br>=C2=A0 -&gt; Bluetooth reset on 5 GHz<br>=C2=A0 -&g=
t; ping<br><br>It also records kernel, PCI/USB, firmware, module, rfkill an=
d link<br>information in one log.<br><br>I can also provide the complete bt=
mon trace and simultaneous host/AP<br>packet captures if useful.<br><br>Ple=
ase let me know if there are any mt76/mt7921 or btmtk debug options,<br>fir=
mware traces, or test patches that would help isolate the coexistence<br>st=
ate transition.<br><br>Regards,<br>Ilya</div>

--000000000000e20554065aa95d1d--
--000000000000e20554065aa95d1f
Content-Type: text/plain; charset="US-ASCII"; name="mt7921-coex-bug-report.txt"
Content-Disposition: attachment; filename="mt7921-coex-bug-report.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_mtn2i9qu1>
X-Attachment-Id: f_mtn2i9qu1

U3ViamVjdDogW0JVR10gbXQ3OTIxZTogQmx1ZXRvb3RoIGNvZXhpc3RlbmNlIGNhdXNlcyBwZXJp
b2RpYyBXaS1GaSBUWCBzdGFsbHM7IDUgR0h6IHJlY292ZXJzIG9ubHkgYWZ0ZXIgQmx1ZXRvb3Ro
IHJlc2V0CgpUbzogbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnCkNjOiBsaW51eC1ibHVl
dG9vdGhAdmdlci5rZXJuZWwub3JnLAogICAgRmVsaXggRmlldGthdSA8bmJkQG5iZC5uYW1lPiwK
ICAgIExvcmVuem8gQmlhbmNvbmkgPGxvcmVuem9Aa2VybmVsLm9yZz4sCiAgICBSeWRlciBMZWUg
PHJ5ZGVyLmxlZUBtZWRpYXRlay5jb20+LAogICAgU2hheW5lIENoZW4gPHNoYXluZS5jaGVuQG1l
ZGlhdGVrLmNvbT4sCiAgICBTZWFuIFdhbmcgPHNlYW4ud2FuZ0BtZWRpYXRlay5jb20+CgpIZWxs
bywKCkkgYW0gc2VlaW5nIGEgcmVwcm9kdWNpYmxlIFdpLUZpL0JsdWV0b290aCBjb2V4aXN0ZW5j
ZSBwcm9ibGVtIHdpdGggYQpNZWRpYVRlayBNVDc5MjEvTVQ3OTYxIGNvbWJvIGFkYXB0ZXIgb24g
RmVkb3JhIDQ0LgoKSGFyZHdhcmUKPT09PT09PT0KCldpLUZpOgogIE1lZGlhVGVrIE1UNzkyMSBQ
Q0llCiAgUENJIElEOiAxNGMzOjc5NjEKICBkcml2ZXI6IG10NzkyMWUKCkJsdWV0b290aDoKICBG
b3hjb25uIC8gSG9uIEhhaSBNZWRpYVRlayBCbHVldG9vdGggQWRhcHRlcgogIFVTQiBJRDogMDQ4
OTplMGNkCiAgZHJpdmVyczogYnR1c2IgKyBidG10awogIEhDSSBwdWJsaWMgYWRkcmVzczogMzg6
RDU6N0E6QUY6QzM6MDgKClNvZnR3YXJlCj09PT09PT09CgpEaXN0cmlidXRpb246IEZlZG9yYSA0
NApLZXJuZWw6IDcuMS4xMi0yMDAuZmM0NC54ODZfNjQKbGludXgtZmlybXdhcmU6IDIwMjYwODEw
LTEuZmM0NAoKV2ktRmkgZmlybXdhcmUgY3VycmVudGx5IGxvYWRlZDoKICBIVy9TVyBWZXJzaW9u
OiAweDhhMTA4YTEwCiAgQnVpbGQgVGltZTogMjAyNjAyMjQxMTA5MDlhCiAgV00gRmlybXdhcmUg
QnVpbGQgVGltZTogMjAyNjAyMjQxMTA5NDkKCkJsdWV0b290aCBmaXJtd2FyZToKICBIQ0kgNS4z
CiAgTWVkaWFUZWsKICBidWlsZCBnZW5lcmF0aW9uIG9ic2VydmVkOiAyMDI2MDIyNAoKU3ltcHRv
bQo9PT09PT09CgpXaGVuIEJsdWV0b290aCBpcyBhY3RpdmUsIFdpLUZpIHVwbGluayB0cmFmZmlj
IGRldmVsb3BzIGhpZ2hseSByZWd1bGFyCmxhdGVuY3kgc3RhbGxzLiBJQ01QIHJlcXVlc3RzIGFy
ZSBxdWV1ZWQgYW5kIHJlbGVhc2VkIGluIGJhdGNoZXMuCgpBIHR5cGljYWwgcGluZyBhdCA1MCBt
cyBpbnRlcnZhbHMgbG9va3MgbGlrZToKCiAgfjEwMCBtcwogIH41MCBtcwogIH4xLTIgbXMKICB+
MS0yIG1zCiAgfjEwMCBtcwogIH41MCBtcwogIC4uLgoKVGhlcmUgaXMgbm9ybWFsbHkgbm8gcGFj
a2V0IGxvc3MuCgpUeXBpY2FsIGJhZCByZXN1bHQ6CgogIHJ0dCBtaW4vYXZnL21heC9tZGV2ID0g
MS4yLzMyLTU1LzExMC0zMDAvLi4uCgpXaXRoIEJsdWV0b290aCBkaXNhYmxlZCwgdGhlIHNhbWUg
bGluayBpcyBzdGFibGU6CgogIHJ0dCBtaW4vYXZnL21heC9tZGV2ID0gfjEuMy9+MS44L341LTkv
Li4uCgpMb2NhbGl6YXRpb24KPT09PT09PT09PT09CgpUaGUgZGVsYXkgd2FzIGxvY2FsaXplZCB0
byB0aGUgc3RhdGlvbiB0cmFuc21pdCBwYXRoLgoKQSBzaW11bHRhbmVvdXMgdGNwZHVtcCBvbiB0
aGUgRmVkb3JhIGhvc3QgYW5kIHBhY2tldCBjYXB0dXJlL3NuaWZmZXIgb24KdGhlIEFQIHNob3dl
ZDoKCiAgKiBJQ01QIHJlcXVlc3RzIGFyZSBnZW5lcmF0ZWQvY2FwdHVyZWQgbG9jYWxseSBhdCBy
ZWd1bGFyIGludGVydmFscy4KICAqIFRoZSBBUCByZWNlaXZlcyB0aG9zZSByZXF1ZXN0cyBvbmx5
IGFmdGVyIHRoZSBsYXJnZSBkZWxheS4KICAqIFRoZSBBUCByZXBsaWVzIGltbWVkaWF0ZWx5IG9u
Y2UgdGhlIHJlcXVlc3QgYXJyaXZlcy4KClRoZXJlZm9yZSB0aGUgZGVsYXkgb2NjdXJzIGJlZm9y
ZSB0aGUgV2ktRmkgZnJhbWUgcmVhY2hlcyB0aGUgQVAuCgpUaGUgaXNzdWUgd2FzIHJlcHJvZHVj
ZWQgYWdhaW5zdCB0d28gZGlmZmVyZW50IGFjY2VzcyBwb2ludHMgYW5kIG9uIGJvdGgKMi40IEdI
eiBhbmQgNSBHSHosIHNvIGl0IGlzIG5vdCBzcGVjaWZpYyB0byBvbmUgQVAuCgpCbHVldG9vdGgg
QS9CCj09PT09PT09PT09PT0KClRoZSBCbHVldG9vdGggc3RhdGUgY29udHJvbHMgdGhlIHByb2Js
ZW0gZGV0ZXJtaW5pc3RpY2FsbHkuCgpCbHVldG9vdGggcmZraWxsIGJsb2NrZWQ6CiAgc3RhYmxl
IFdpLUZpLCBhcHByb3hpbWF0ZWx5IDEtMiBtcwoKQmx1ZXRvb3RoIGFjdGl2ZToKICBwZXJpb2Rp
YyBXaS1GaSBUWCBzdGFsbHMKCkJsdWVaIGlzIG5vdCByZXF1aXJlZCB0byB0cmlnZ2VyIHRoZSBw
cm9ibGVtLgoKSSBzdG9wcGVkL21hc2tlZCBibHVldG9vdGguc2VydmljZSBhbmQgbWFudWFsbHkg
YnJvdWdodCBoY2kwIFVQOgoKICBibHVldG9vdGguc2VydmljZTogaW5hY3RpdmUKICBoY2kwOiBV
UCBSVU5OSU5HCgpXaS1GaSBpbW1lZGlhdGVseSBiZWNhbWUgYmFkIGFnYWluOgoKICBydHQgbWlu
L2F2Zy9tYXgvbWRldiA9IDEuMTkwLzU0Ljk2Ny8zMDIuMzM4LzYzLjMzNSBtcwoKV2hlbiBoY2kw
IGlzIERPV04sIFdpLUZpIGJlY29tZXMgc3RhYmxlLgoKT3RoZXIgdGVzdHMgYWxyZWFkeSBwZXJm
b3JtZWQKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KClRoZSBmb2xsb3dpbmcgZGlkIE5P
VCBzb2x2ZSB0aGUgcHJvYmxlbToKCiAgKiBXaS1GaSBwb3dlciBzYXZpbmcgZGlzYWJsZWQKICAq
IG10NzkyMWUgZGlzYWJsZV9hc3BtPTEKICAqIGtlcm5lbHMgNy4xLjksIDcuMS4xMCBhbmQgNy4x
LjEyCiAgKiBvbGRlciBsaW51eC1maXJtd2FyZSAyMDI2MDMwOSAoZmlybXdhcmUgYnVpbGQgMjAy
NTEyMjMpCiAgKiBCbHVldG9vdGggVVNCIHJ1bnRpbWUgYXV0b3N1c3BlbmQgZGlzYWJsZWQKICAq
IEJsdWV0b290aCBkaXNjb3ZlcnkgZGlzYWJsZWQKICAqIGRpc2NvdmVyYWJsZS9wYWlyYWJsZSBk
aXNhYmxlZAogICogQmx1ZVogc3RvcHBlZAogICogV1BBMi1vbmx5CiAgKiBkaXNhYmxpbmcgODAy
LjExci9GVAogICogZml4ZWQgQlNTSUQKICAqIDIwIE1IeiAvIGZpeGVkIGNoYW5uZWwgLyBub24t
QVggdGVzdGluZwogICogZGlmZmVyZW50IEFQCiAgKiAyLjQgR0h6IGFuZCA1IEdIegoKQmx1ZXRv
b3RoIHNjYW5uaW5nIGRvZXMgbm90IGFwcGVhciB0byBiZSB0aGUgcm9vdCBjYXVzZS4KCkEgYnRt
b24gdHJhY2UgYWZ0ZXIgQmx1ZXRvb3RoIGluaXRpYWxpemF0aW9uIHNob3dlZCBCbHVlWiBlbmFi
bGluZwpwYXNzaXZlIExFIGV4dGVuZGVkIHNjYW5uaW5nLCBidXQgaW4gb25lIGtub3duLWdvb2Qg
NSBHSHogc3RhdGUgdGhlIHNjYW4Kd2FzIGVuYWJsZWQgd2hpbGUgV2ktRmkgbGF0ZW5jeSByZW1h
aW5lZCB+MS43IG1zLgoKQmFuZC1kZXBlbmRlbnQgc3RhdGUgYmVoYXZpb3IKPT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0KClRoZXJlIGlzIGFuIGVzcGVjaWFsbHkgcmVwcm9kdWNpYmxlIHN0
YXRlIHRyYW5zaXRpb246CgoxLiBBc3NvY2lhdGUgV2ktRmkgdG8gNSBHSHouCjIuIHJma2lsbCBi
bG9jayBCbHVldG9vdGguCjMuIHJma2lsbCB1bmJsb2NrIEJsdWV0b290aC4KNC4gV2ktRmkgYmVj
b21lcyBzdGFibGUgd2hpbGUgQmx1ZXRvb3RoIHJlbWFpbnMgcG93ZXJlZC4KCkV4YW1wbGU6Cgog
IFdpLUZpIGZyZXF1ZW5jeTogNTIyMCBNSHoKICBCbHVldG9vdGg6IFBvd2VyZWQ6IHllcwoKICBp
bW1lZGlhdGVseSBhZnRlciBCVCByZXNldDoKICAgIHJ0dCBtaW4vYXZnL21heC9tZGV2ID0gMS4z
MzEvMS44MDkvNS45MTYvMC41MjIgbXMKCiAgYWZ0ZXIgYW5vdGhlciAzMCBzZWNvbmRzOgogICAg
cnR0IG1pbi9hdmcvbWF4L21kZXYgPSAxLjI5MC8xLjcwNi81LjA3MS8wLjQ1NyBtcwoKSWYgSSB0
aGVuIHN3aXRjaCBXaS1GaSBmcm9tIHRoaXMgZ29vZCA1IEdIeiBzdGF0ZSB0byAyLjQgR0h6IHdp
dGhvdXQKdG91Y2hpbmcgQmx1ZXRvb3RoLCB0aGUgc3RhbGxzIHJldHVybiBpbW1lZGlhdGVseToK
CiAgV2ktRmkgZnJlcXVlbmN5OiAyNDcyIE1IegogIHJ0dCBtaW4vYXZnL21heC9tZGV2ID0gMS4y
NDYvMzUuMjI5LzExNS42MDgvMzkuMDI3IG1zCgpSZXNldHRpbmcgQmx1ZXRvb3RoIHdoaWxlIGFs
cmVhZHkgYXNzb2NpYXRlZCBvbiAyLjQgR0h6IGRvZXMgTk9UIGZpeCBpdDoKCiAgcnR0IG1pbi9h
dmcvbWF4L21kZXYgPSAxLjI0NS8zMi4wOTEvMTE0LjUwNi8zNy4zOTIgbXMKCkFuIGltcG9ydGFu
dCBhZGRpdGlvbmFsIG9ic2VydmF0aW9uIGlzIHRoYXQgc3dpdGNoaW5nIGZyb20gYSBiYWQgc3Rh
dGUKdG8gNSBHSHogZG9lcyBub3QgYWx3YXlzIGNsZWFyIHRoZSBzdGFsbHMgYnkgaXRzZWxmLiBS
ZXNldHRpbmcgQmx1ZXRvb3RoCmFmdGVyIHRoZSA1IEdIeiBhc3NvY2lhdGlvbiBkb2VzLgoKVGhp
cyBtYWtlcyB0aGUgcHJvYmxlbSBsb29rIGxpa2UgYW4gaW5jb3JyZWN0L3N0YWxlIGNvZXhpc3Rl
bmNlIHN0YXRlCnJhdGhlciB0aGFuIG9yZGluYXJ5IDIuNCBHSHogUkYgaW50ZXJmZXJlbmNlIGFs
b25lLgoKUmVwcm9kdWNlcgo9PT09PT09PT09CgpJIGhhdmUgYXR0YWNoZWQgYSBzaGVsbCBzY3Jp
cHQgd2hpY2ggcGVyZm9ybXM6CgogIDUgR0h6IGFzc29jaWF0aW9uCiAgLT4gQmx1ZXRvb3RoIHJl
c2V0CiAgLT4gcGluZwogIC0+IHN3aXRjaCB0byAyLjQgR0h6IHdpdGhvdXQgdG91Y2hpbmcgQmx1
ZXRvb3RoCiAgLT4gcGluZwogIC0+IEJsdWV0b290aCByZXNldCBvbiAyLjQgR0h6CiAgLT4gcGlu
ZwogIC0+IHN3aXRjaCBiYWNrIHRvIDUgR0h6CiAgLT4gcGluZwogIC0+IEJsdWV0b290aCByZXNl
dCBvbiA1IEdIegogIC0+IHBpbmcKCkl0IGFsc28gcmVjb3JkcyBrZXJuZWwsIFBDSS9VU0IsIGZp
cm13YXJlLCBtb2R1bGUsIHJma2lsbCBhbmQgbGluawppbmZvcm1hdGlvbiBpbiBvbmUgbG9nLgoK
SSBjYW4gcHJvdmlkZSB0aGUgY29tcGxldGUgYnRtb24gdHJhY2UgYW5kIHNpbXVsdGFuZW91cyBo
b3N0L0FQIHBhY2tldApjYXB0dXJlcyBpZiB1c2VmdWwuCgpQbGVhc2UgbGV0IG1lIGtub3cgaWYg
dGhlcmUgYXJlIGFueSBtdDc2L210NzkyMSBvciBidG10ayBkZWJ1ZyBvcHRpb25zLApmaXJtd2Fy
ZSB0cmFjZXMsIG9yIHRlc3QgcGF0Y2hlcyB0aGF0IHdvdWxkIGhlbHAgaXNvbGF0ZSB0aGUgY29l
eGlzdGVuY2UKc3RhdGUgdHJhbnNpdGlvbi4KClJlZ2FyZHMsCklseWEK
--000000000000e20554065aa95d1f
Content-Type: application/x-shellscript; name="mt7921-coex-repro.sh"
Content-Disposition: attachment; filename="mt7921-coex-repro.sh"
Content-Transfer-Encoding: base64
Content-ID: <f_mtn2hdit0>
X-Attachment-Id: f_mtn2hdit0

IyEvdXNyL2Jpbi9lbnYgYmFzaApzZXQgLXUKCklGQUNFPSIke0lGQUNFOi13bG8xfSIKQ09OPSIk
e0NPTjotYnR9IgpHVz0iJHtHVzotMTkyLjE2OC44OC4xfSIKQlNTSURfNT0iJHtCU1NJRF81Oi1E
NDowMTpDMzozRTowMzoyOH0iCkJTU0lEXzI0PSIke0JTU0lEXzI0Oi1ENDowMTpDMzozRTowMzoy
OX0iCk9VVD0iJHtPVVQ6LS90bXAvbXQ3OTIxLWNvZXgtcmVwcm8udHh0fSIKCmNsZWFudXAoKSB7
CiAgICAjIExlYXZlIHRoZSBzeXN0ZW0gb24gNSBHSHosIHdoaWNoIGlzIHRoZSBrbm93bi1nb29k
IHByYWN0aWNhbCBzZXR1cC4KICAgIG5tY2xpIGNvbm5lY3Rpb24gbW9kaWZ5ICIkQ09OIiA4MDIt
MTEtd2lyZWxlc3MuYnNzaWQgIiRCU1NJRF81IiA+L2Rldi9udWxsIDI+JjEgfHwgdHJ1ZQogICAg
bm1jbGkgY29ubmVjdGlvbiB1cCAiJENPTiIgPi9kZXYvbnVsbCAyPiYxIHx8IHRydWUKfQp0cmFw
IGNsZWFudXAgRVhJVAoKewogICAgZWNobyAiPT09IE1UNzkyMSBXaS1GaS9CbHVldG9vdGggY29l
eGlzdGVuY2UgcmVwcm9kdWN0aW9uID09PSIKICAgIGRhdGUgLUlzCiAgICBlY2hvCgogICAgZWNo
byAiPT09IHN5c3RlbSA9PT0iCiAgICB1bmFtZSAtYQogICAgY2F0IC9ldGMvZmVkb3JhLXJlbGVh
c2UgMj4vZGV2L251bGwgfHwgdHJ1ZQogICAgZWNobwoKICAgIGVjaG8gIj09PSBQQ0kgV2ktRmkg
PT09IgogICAgbHNwY2kgLW5uayB8IGdyZXAgLUE0IC1pIC1FICduZXR3b3JrfDE0YzM6Nzk2MScg
fHwgdHJ1ZQogICAgZWNobwoKICAgIGVjaG8gIj09PSBVU0IgQmx1ZXRvb3RoID09PSIKICAgIGxz
dXNiIHwgZ3JlcCAtaSAtRSAnMDQ4OTplMGNkfG1lZGlhdGVrfGJsdWV0b290aCcgfHwgdHJ1ZQog
ICAgZWNobwoKICAgIGVjaG8gIj09PSBtb2R1bGVzID09PSIKICAgIGxzbW9kIHwgZ3JlcCAtRSAn
XihtdDc5MjFlfG10NzkyMV9jb21tb258bXQ3OTJ4X2xpYnxtdDc2fGJ0dXNifGJ0bXRrfGJsdWV0
b290aCknIHx8IHRydWUKICAgIGVjaG8KCiAgICBlY2hvICI9PT0gZmlybXdhcmUgLyBkcml2ZXIg
bG9nID09PSIKICAgIGpvdXJuYWxjdGwgLWsgLWIgLS1uby1wYWdlciB8IGdyZXAgLWkgLUUgJ210
NzkyMXxtdDc5MjFlfGJ0bXRrfGJ0dXNifEJsdWV0b290aDogaGNpMHxmaXJtd2FyZScgfCB0YWls
IC1uIDEyMCB8fCB0cnVlCiAgICBlY2hvCgogICAgZWNobyAiPT09IHJma2lsbCA9PT0iCiAgICBy
ZmtpbGwKICAgIGVjaG8KCiAgICBlY2hvICI9PT0gU1RFUCAxOiBmb3JjZSA1IEdIeiA9PT0iCiAg
ICBzdWRvIG5tY2xpIGNvbm5lY3Rpb24gbW9kaWZ5ICIkQ09OIiA4MDItMTEtd2lyZWxlc3MuYnNz
aWQgIiRCU1NJRF81IgogICAgc3VkbyBubWNsaSBjb25uZWN0aW9uIGRvd24gIiRDT04iID4vZGV2
L251bGwgMj4mMSB8fCB0cnVlCiAgICBzdWRvIG5tY2xpIGNvbm5lY3Rpb24gdXAgIiRDT04iCiAg
ICBzbGVlcCA0CiAgICBpdyBkZXYgIiRJRkFDRSIgbGluawogICAgZWNobwoKICAgIGVjaG8gIj09
PSBTVEVQIDI6IHJlc2V0IEJsdWV0b290aCB3aGlsZSBXaS1GaSBpcyBvbiA1IEdIeiA9PT0iCiAg
ICBzdWRvIHJma2lsbCBibG9jayBibHVldG9vdGgKICAgIHNsZWVwIDIKICAgIHN1ZG8gcmZraWxs
IHVuYmxvY2sgYmx1ZXRvb3RoCiAgICBzbGVlcCA1CiAgICBibHVldG9vdGhjdGwgc2hvdyAyPi9k
ZXYvbnVsbCB8IGdyZXAgLUUgJ1Bvd2VyZWR8RGlzY292ZXJpbmcnIHx8IHRydWUKICAgIGhjaWNv
bmZpZyBoY2kwIDI+L2Rldi9udWxsIHx8IHRydWUKICAgIGVjaG8KCiAgICBlY2hvICI9PT0gU1RF
UCAzOiA1IEdIeiBhZnRlciBCVCByZXNldCAoZXhwZWN0ZWQgR09PRCkgPT09IgogICAgcGluZyAt
aSAwLjA1IC1jIDEwMCAiJEdXIgogICAgZWNobwoKICAgIGVjaG8gIj09PSBTVEVQIDQ6IHN3aXRj
aCBXaS1GaSB0byAyLjQgR0h6LCBsZWF2ZSBCbHVldG9vdGggdW50b3VjaGVkID09PSIKICAgIHN1
ZG8gbm1jbGkgY29ubmVjdGlvbiBtb2RpZnkgIiRDT04iIDgwMi0xMS13aXJlbGVzcy5ic3NpZCAi
JEJTU0lEXzI0IgogICAgc3VkbyBubWNsaSBjb25uZWN0aW9uIGRvd24gIiRDT04iID4vZGV2L251
bGwgMj4mMSB8fCB0cnVlCiAgICBzdWRvIG5tY2xpIGNvbm5lY3Rpb24gdXAgIiRDT04iCiAgICBz
bGVlcCA0CiAgICBpdyBkZXYgIiRJRkFDRSIgbGluawogICAgZWNobwoKICAgIGVjaG8gIj09PSBT
VEVQIDU6IDIuNCBHSHogd2l0aCBCVCBvbiAoZXhwZWN0ZWQgQkFEKSA9PT0iCiAgICBwaW5nIC1p
IDAuMDUgLWMgMTAwICIkR1ciCiAgICBlY2hvCgogICAgZWNobyAiPT09IFNURVAgNjogcmVzZXQg
Qmx1ZXRvb3RoIHdoaWxlIFdpLUZpIGlzIGFscmVhZHkgb24gMi40IEdIeiA9PT0iCiAgICBzdWRv
IHJma2lsbCBibG9jayBibHVldG9vdGgKICAgIHNsZWVwIDIKICAgIHN1ZG8gcmZraWxsIHVuYmxv
Y2sgYmx1ZXRvb3RoCiAgICBzbGVlcCA1CiAgICBibHVldG9vdGhjdGwgc2hvdyAyPi9kZXYvbnVs
bCB8IGdyZXAgLUUgJ1Bvd2VyZWR8RGlzY292ZXJpbmcnIHx8IHRydWUKICAgIGVjaG8KCiAgICBl
Y2hvICI9PT0gU1RFUCA3OiAyLjQgR0h6IGFmdGVyIEJUIHJlc2V0IChleHBlY3RlZCBTVElMTCBC
QUQpID09PSIKICAgIHBpbmcgLWkgMC4wNSAtYyAxMDAgIiRHVyIKICAgIGVjaG8KCiAgICBlY2hv
ICI9PT0gU1RFUCA4OiBzd2l0Y2ggYmFjayB0byA1IEdIeiBXSVRIT1VUIHJlc2V0dGluZyBCbHVl
dG9vdGggPT09IgogICAgc3VkbyBubWNsaSBjb25uZWN0aW9uIG1vZGlmeSAiJENPTiIgODAyLTEx
LXdpcmVsZXNzLmJzc2lkICIkQlNTSURfNSIKICAgIHN1ZG8gbm1jbGkgY29ubmVjdGlvbiBkb3du
ICIkQ09OIiA+L2Rldi9udWxsIDI+JjEgfHwgdHJ1ZQogICAgc3VkbyBubWNsaSBjb25uZWN0aW9u
IHVwICIkQ09OIgogICAgc2xlZXAgNAogICAgaXcgZGV2ICIkSUZBQ0UiIGxpbmsKICAgIGVjaG8K
CiAgICBlY2hvICI9PT0gU1RFUCA5OiA1IEdIeiBiZWZvcmUgc2Vjb25kIEJUIHJlc2V0ID09PSIK
ICAgIHBpbmcgLWkgMC4wNSAtYyAxMDAgIiRHVyIKICAgIGVjaG8KCiAgICBlY2hvICI9PT0gU1RF
UCAxMDogcmVzZXQgQmx1ZXRvb3RoIG9uIDUgR0h6IGFnYWluID09PSIKICAgIHN1ZG8gcmZraWxs
IGJsb2NrIGJsdWV0b290aAogICAgc2xlZXAgMgogICAgc3VkbyByZmtpbGwgdW5ibG9jayBibHVl
dG9vdGgKICAgIHNsZWVwIDUKICAgIGVjaG8KCiAgICBlY2hvICI9PT0gU1RFUCAxMTogNSBHSHog
YWZ0ZXIgc2Vjb25kIEJUIHJlc2V0IChleHBlY3RlZCBHT09EKSA9PT0iCiAgICBwaW5nIC1pIDAu
MDUgLWMgMTAwICIkR1ciCiAgICBlY2hvCgogICAgZWNobyAiPT09IGZpbmFsIHN0YXRlID09PSIK
ICAgIGl3IGRldiAiJElGQUNFIiBsaW5rCiAgICByZmtpbGwKfSAyPiYxIHwgdGVlICIkT1VUIgoK
aWYgY29tbWFuZCAtdiB3bC1jb3B5ID4vZGV2L251bGwgMj4mMTsgdGhlbgogICAgd2wtY29weSA8
ICIkT1VUIgogICAgZWNobyAiRnVsbCBsb2cgY29waWVkIHRvIGNsaXBib2FyZDogJE9VVCIKZWxz
ZQogICAgZWNobyAid2wtY29weSBub3QgaW5zdGFsbGVkOyBmdWxsIGxvZyBzYXZlZCB0bzogJE9V
VCIKZmkK
--000000000000e20554065aa95d1f--
