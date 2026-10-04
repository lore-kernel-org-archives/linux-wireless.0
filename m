Received: from mail-ua2-f42.google.com (mail-ua2-f42.google.com [74.125.226.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0111C5499
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 10:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.226.234
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791111188; cv=pass; b=uk2IdwlvuzDn5HtW25ZKmyqRR7zfAU491bYC6Fyq7YFokZGxgzPEjUXh5atexk1LFx9R/oedlWqXw2oJpCnFafPPiH3c5FKE0b5BzGPUMYiW9K+mXscayuQQ2e0B171CookyUwq95+ca2Npcy6EHuHyyL/SUzicpTf+ratwxF2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791111188; c=relaxed/simple;
	bh=kKLXC6JwlZQwv8GpW3PB2s/yls7WhwHFtQmY4wQnok0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=lMZ3Dky8G/04wRQkI9+Sd6P4VdlkjTNpPFCgygY3/jxQyfmCJSUCxYwJge+cc+MYfIokB5hHUT95b9KQoEc99HWzQfWRvXWFvsdo2vwzHgrb/6MoSeKFW96GAHrUP3CC5TVbLVI6Fj9jOcraqsCgL96NEezuVvRAjgFzvm0T9uc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dF5A0Qnp; arc=pass smtp.client-ip=74.125.226.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dF5A0Qnp"
Received: by mail-ua2-f42.google.com with SMTP id a1e0cc1a2514c-988cac73538so128114241.2
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 03:53:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791111186; cv=none;
        d=google.com; s=arc-20260327;
        b=BuOlyOEeUkPAzb6EdVoofOgGVDbcPgAXDng1cge6pLASzBdxDxWaQC4qgpsLW102tG
         Q+2iEmotsYlG/jsZPN979m8ygGK+9JmwAZRVZIHsNkRTBvm9X+sLVnQNPygpJFxLrdsV
         EqFbLXj7qdnck1GHPriiOr3Beff7akudISgOaFOyBuxiAk3+XrcK8U+hKMtkUjfFeP4k
         7nQyffySKIZ+yxyNSWgLxjmOwhsXwxE5N0HKaASq7EZdNYcdw9Ez1ezQ+mIFi26Qx/tR
         Ob6sy0wYzQMHHMV1kt0LVlgoFeyWc1L793NnsziRD61upCMTuunQ5nfvsJn1cGhReeQE
         ud3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=sgh3kSFIAwcCr6a9zENgHuWiX8Wby+qrA1sDQT9AOxI=;
        fh=vFTMrE4wRUjEnK6v2aozb+q0utV7AsqqR30fNdq05ME=;
        b=W2RKflWobxMtma8nDSM86GqbvGQ+fLxlUnPiCGIJHsGvUydbTRWOxjDFBJe6MAWSGr
         Ifz4iFS+y44NxemR9UAad7ORf0wBwsESgMQq9i4Elm143wtDZ+rQXqcC69aNOSR+CdKJ
         X2+s6Y/CJ7AwixcR1BintlkzjstzNVuRJdZMU00wWHJ/JFni5yaULNQwFhz+TGhcsan5
         T4ygjbR2NurC/9mAffIDnXMPK6dtQUTr+2XBqzOmunAnKUQ84/Ofpj9J0dVBRiISn8sE
         pbru4CUozDcL8nVcGsyN5fNy2IBDP12OednA3LtBbHePDgIzNVvKrexzjaGfflMa3OXH
         blPQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791111186; x=1791715986; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sgh3kSFIAwcCr6a9zENgHuWiX8Wby+qrA1sDQT9AOxI=;
        b=dF5A0QnpbovLKXC+u6mdV+sME28KwhaauNEJXqGblH5z31rL0XXUBgShjo0Xcyff2G
         XkhrtGzM6PbHMG+tHK+tF3KAMzadXfXSIr+LVcFvWzJHhocuD/7DI3adH8h3Vp6pjsxZ
         bBRhd9nw7C2v6JbW3zYTNJvkUeUOoSmT5JVEr81fZeTm3FZu5bu2dzCTDf18WnUfs/mr
         4rUSf+dzzL0Ymqn8KNUS6pfbT8xqtOiu2Ad7DCmc0CtG7DEN/jKpl6q6JSi0P0fRnoE8
         ieZtR7kTjxoe9Bim3mxfon7LXMh/aKUqCspLhpt/FWzh4LFm68zTSvLd2WJzCCTBrnH8
         4C4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791111186; x=1791715986;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=sgh3kSFIAwcCr6a9zENgHuWiX8Wby+qrA1sDQT9AOxI=;
        b=HRO0zTnjcnSEat39jdME3SgUKBGdj9g5PG+NYoA93Mogk23Y3Jj8cGloJmCWwTryt0
         bt131YhIpVB5y2HwDFriEZSB4rxQY11Z8AWUqPEPlwQOQjRgVE9l5fmEK61dHa+9PHfT
         8t/IQ/2NAlQoHAoHL0dBcOTy+l/MFrcd7p+c+nCEVcOxa0S8VA+YuSMPIpkwt27h7m33
         lRg2zksPaq+lXrBZf40RblK2InwzfhQcf11ILqSsEchTVNUjhAV30w2w7dmjEkRhv6jI
         vLhQs75/W9PqHPLZvzKLpmQSmBluJnAKa58S42QO3BmVSjGpjnrxB0+y8ZXigsiDEA6o
         qdLw==
X-Gm-Message-State: AFq9FYKGDNXjz4EDs8fzbzssTdVRxJkTYs6+8dfQHmNRp6ygdBePeDan
	UrqfWVCwnqKku3bfDeKThvG/hIy7UeFs31vXmpaiYp0BzZQMTCI9J73A11vB4XPNq2+PIY3grMO
	soZMEQXxgvMNmVZDfJxxSXGOWLaC+t9Z2tLSocHLl4A==
X-Gm-Gg: AYBFou0wWwZ1FIsKhHZdo/T+hyhSI/XBPRNhNLYukGPg1/2JVuS4gqAXbfUfSaB8khv
	bsIZXCUZy3Bbsmr/Df8NGkRUprZqXMFKaT/q8qktNDbt1TnreFVoB454ayh9DtzLJzFjnojBW4o
	NRZAOpFPUNHsH25255GVfVe+LgIzLPGBVzlYHKhiwqjX8Gr/p/lEvPgzgK91bMIzAXuwqFh/yF4
	uyefvvQbH/64PSXJMxNLn/cS3QhEXINZaX4VxV3k2CSu7r5jxsZL8ExqN5CDnkw41/RiHRk9kyD
	oIad9+gMEIo85mIWqaqlv9y3IwZzFO8BwR4F3Ht7zwa2KHBjzAU0R91pb19PrDgDwAbDjfdpaw4
	/axE+OobnUprC/ZIpzkAn7Bfo
X-Received: by 2002:a05:6102:370d:b0:7be:37d8:1567 with SMTP id
 ada2fe7eead31-7c0f4a8862amr1644702137.10.1791111185624; Sun, 04 Oct 2026
 03:53:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Quentin Herique <quentinherique07@gmail.com>
Date: Sun, 4 Oct 2026 12:52:54 +0200
X-Gm-Features: AclHuK-wQI4cGkN9lmahz-tEr4zuCXUS4ULbCY0PMKpQ9BQGzUJAv2sczUNqMK4
Message-ID: <CAK8JKts+x7ioj2omw+hrQrKtRDbZ3yCYXavVpfjodOG6ro7t9w@mail.gmail.com>
Subject: [BUG] mt7925e/MT7927: panic in mt76_dma_add_buf when hw_scan runs
 after a failed WFSYS reset
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com, 
	shayne.chen@mediatek.com, sean.wang@mediatek.com, 
	linux-mediatek@lists.infradead.org
Content-Type: multipart/mixed; boundary="000000000000f91fbe065d019158"

--000000000000f91fbe065d019158
Content-Type: multipart/alternative; boundary="000000000000f91fbb065d019156"

--000000000000f91fbb065d019156
Content-Type: text/plain; charset="UTF-8"

Hi,

On an idle desktop with an MT7927, the chip stops answering on PCIe and
the WFSYS reset fails four times. The next scan request from
wpa_supplicant then reaches mt7925_hw_scan. That call writes into an
unmapped TX DMA descriptor ring in mt76_dma_add_buf, and the kernel
panics. This happened on two nights in a row. Wi-Fi was up but not
associated, because the machine uses a wired link.

Environment
-----------
- Kernel: 7.2.5 (distribution build: Omarchy linux-omarchy 7.2.5-3)
- Board: ASUS ProArt X870E-CREATOR WIFI, BIOS 2103 (03/09/2026)
- Wi-Fi: MT7927 PCIe, mt7925e
  ("MT7927 raw CHIPID=0x0000, forcing chip=0x7927"),
  HW/SW build 20260414133750a, WM firmware build 20260414134255
- Bluetooth function of the same chip: USB 13d3:3588
  (btusb/btmtk), firmware build 20250606201235
- Userspace: NetworkManager + wpa_supplicant (periodic background
  scans)
- Taint OE comes from the NVIDIA and xone out-of-tree modules.
  Neither is in the call path.

Sequence (the same on both nights)
----------------------------------
1. At boot, Bluetooth setup times out ("Failed to send wmt func ctrl
   (-110)"). USB resets of the Bluetooth function then fail ("device
   descriptor read/64, error -110", "device not accepting address,
   error -71").
2. Hours later, the Bluetooth function enumerates again on its own.
3. Shortly after that (46 s on 10-03, 3 s on 10-04), a scan fails with
   "Message 00020016 timeout" and "driver own failed", then four times
   "MT7927 WFSYS reset timeout (ROMCODE_INDEX=0xffff)".
4. The next scan oopses with a supervisor write to a not-present page
   at mt76_dma_add_buf+0x9c. The call path is:
     nl80211_trigger_scan
     -> mt7925_hw_scan
     -> mt7925_mcu_hw_scan
     -> mt76_mcu_skb_send_and_get_msg
     -> mt76_dma_tx_queue_skb_raw
     -> mt76_dma_add_buf
   The kernel then panics ("Fatal exception in interrupt",
   panic_on_oops=1).

The full oops was captured by efi_pstore on 2026-10-04. On 2026-10-03
pstore was not enabled yet. That journal stops right after the same
reset failures, and the next boot reports "Previous system reset reason
[0x00080800]: software wrote 0x6 to reset control register 0xCF9".

The late Bluetooth enumeration came just before the Wi-Fi failure both
times. That is only a correlation; the logs do not prove that one
causes the other.

Possibly related: "wifi: mt76: mt7925: check drv_pmctrl return in the
PCIe reset path" (Aug 2026, not in mainline as far as I can tell)
describes mt7925e_mac_reset() carrying on after "driver own failed".
That could leave the rings in the state that this hw_scan then trips
over.

Expected
--------
Once the WFSYS reset has failed, the driver should treat the device as
dead. Further MCU commands such as hw_scan should then fail with an
error, rather than being queued to a DMA ring that is no longer mapped.

Workaround in place: blacklist mt7925e. I can test patches on this
machine.

The full oops and the kernel log excerpts are attached
(mt7927-panic-logs.txt).

--------
Quick note: I am not an expert in any way in that domain, this is a bug I
found and claude made that troubleshooting and email. Regards.

--000000000000f91fbb065d019156
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<br><br>On an idle desktop with an MT7927, the chip sto=
ps answering on PCIe and<br>the WFSYS reset fails four times. The next scan=
 request from<br>wpa_supplicant then reaches mt7925_hw_scan. That call writ=
es into an<br>unmapped TX DMA descriptor ring in mt76_dma_add_buf, and the =
kernel<br>panics. This happened on two nights in a row. Wi-Fi was up but no=
t<br>associated, because the machine uses a wired link.<br><br>Environment<=
br>-----------<br>- Kernel: 7.2.5 (distribution build: Omarchy linux-omarch=
y 7.2.5-3)<br>- Board: ASUS ProArt X870E-CREATOR WIFI, BIOS 2103 (03/09/202=
6)<br>- Wi-Fi: MT7927 PCIe, mt7925e<br>=C2=A0 (&quot;MT7927 raw CHIPID=3D0x=
0000, forcing chip=3D0x7927&quot;),<br>=C2=A0 HW/SW build 20260414133750a, =
WM firmware build 20260414134255<br>- Bluetooth function of the same chip: =
USB 13d3:3588<br>=C2=A0 (btusb/btmtk), firmware build 20250606201235<br>- U=
serspace: NetworkManager + wpa_supplicant (periodic background<br>=C2=A0 sc=
ans)<br>- Taint OE comes from the NVIDIA and xone out-of-tree modules.<br>=
=C2=A0 Neither is in the call path.<br><br>Sequence (the same on both night=
s)<br>----------------------------------<br>1. At boot, Bluetooth setup tim=
es out (&quot;Failed to send wmt func ctrl<br>=C2=A0 =C2=A0(-110)&quot;). U=
SB resets of the Bluetooth function then fail (&quot;device<br>=C2=A0 =C2=
=A0descriptor read/64, error -110&quot;, &quot;device not accepting address=
,<br>=C2=A0 =C2=A0error -71&quot;).<br>2. Hours later, the Bluetooth functi=
on enumerates again on its own.<br>3. Shortly after that (46 s on 10-03, 3 =
s on 10-04), a scan fails with<br>=C2=A0 =C2=A0&quot;Message 00020016 timeo=
ut&quot; and &quot;driver own failed&quot;, then four times<br>=C2=A0 =C2=
=A0&quot;MT7927 WFSYS reset timeout (ROMCODE_INDEX=3D0xffff)&quot;.<br>4. T=
he next scan oopses with a supervisor write to a not-present page<br>=C2=A0=
 =C2=A0at mt76_dma_add_buf+0x9c. The call path is:<br>=C2=A0 =C2=A0 =C2=A0n=
l80211_trigger_scan<br>=C2=A0 =C2=A0 =C2=A0-&gt; mt7925_hw_scan<br>=C2=A0 =
=C2=A0 =C2=A0-&gt; mt7925_mcu_hw_scan<br>=C2=A0 =C2=A0 =C2=A0-&gt; mt76_mcu=
_skb_send_and_get_msg<br>=C2=A0 =C2=A0 =C2=A0-&gt; mt76_dma_tx_queue_skb_ra=
w<br>=C2=A0 =C2=A0 =C2=A0-&gt; mt76_dma_add_buf<br>=C2=A0 =C2=A0The kernel =
then panics (&quot;Fatal exception in interrupt&quot;,<br>=C2=A0 =C2=A0pani=
c_on_oops=3D1).<br><br>The full oops was captured by efi_pstore on 2026-10-=
04. On 2026-10-03<br>pstore was not enabled yet. That journal stops right a=
fter the same<br>reset failures, and the next boot reports &quot;Previous s=
ystem reset reason<br>[0x00080800]: software wrote 0x6 to reset control reg=
ister 0xCF9&quot;.<br><br>The late Bluetooth enumeration came just before t=
he Wi-Fi failure both<br>times. That is only a correlation; the logs do not=
 prove that one<br>causes the other.<br><br>Possibly related: &quot;wifi: m=
t76: mt7925: check drv_pmctrl return in the<br>PCIe reset path&quot; (Aug 2=
026, not in mainline as far as I can tell)<br>describes mt7925e_mac_reset()=
 carrying on after &quot;driver own failed&quot;.<br>That could leave the r=
ings in the state that this hw_scan then trips<br>over.<br><br>Expected<br>=
--------<br>Once the WFSYS reset has failed, the driver should treat the de=
vice as<br>dead. Further MCU commands such as hw_scan should then fail with=
 an<br>error, rather than being queued to a DMA ring that is no longer mapp=
ed.<br><br>Workaround in place: blacklist mt7925e. I can test patches on th=
is<br>machine.<br><br>The full oops and the kernel log excerpts are attache=
d<br><div>(mt7927-panic-logs.txt).</div><div><br></div><div>--------</div><=
div>Quick note: I am not an expert in any way in that domain, this is a bug=
 I found and claude made that troubleshooting and email. Regards.</div></di=
v>

--000000000000f91fbb065d019156--
--000000000000f91fbe065d019158
Content-Type: text/plain; charset="US-ASCII"; name="mt7927-panic-logs.txt"
Content-Disposition: attachment; filename="mt7927-panic-logs.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_mutp47qf0>
X-Attachment-Id: f_mutp47qf0

MjAyNi0xMC0wNCwgb29wcyBhbmQgcGFuaWMgKGVmaV9wc3RvcmUsIHByaW50ayB0aW1lc3RhbXBz
KToKClsyNjA1Ni42MDIyMTZdIG10NzkyNWUgMDAwMDowOTowMC4wOiBNZXNzYWdlIDAwMDIwMDE2
IChzZXEgMykgdGltZW91dApbMjYwNTcuNjIyMTk1XSBtdDc5MjVlIDAwMDA6MDk6MDAuMDogZHJp
dmVyIG93biBmYWlsZWQKWzI2MDU4LjA1NDIwM10gbXQ3OTI1ZSAwMDAwOjA5OjAwLjA6IE1UNzky
NyBXRlNZUyByZXNldCB0aW1lb3V0IChST01DT0RFX0lOREVYPTB4ZmZmZikKWzI2MDU5LjA3NDE5
M10gbXQ3OTI1ZSAwMDAwOjA5OjAwLjA6IGRyaXZlciBvd24gZmFpbGVkClsyNjA2MC4wOTQxNzRd
IG10NzkyNWUgMDAwMDowOTowMC4wOiBkcml2ZXIgb3duIGZhaWxlZApbMjYwNjAuNTI2MTczXSBt
dDc5MjVlIDAwMDA6MDk6MDAuMDogTVQ3OTI3IFdGU1lTIHJlc2V0IHRpbWVvdXQgKFJPTUNPREVf
SU5ERVg9MHhmZmZmKQpbMjYwNjEuNTQ2MTcyXSBtdDc5MjVlIDAwMDA6MDk6MDAuMDogZHJpdmVy
IG93biBmYWlsZWQKWzI2MDYyLjU2NjE2M10gbXQ3OTI1ZSAwMDAwOjA5OjAwLjA6IGRyaXZlciBv
d24gZmFpbGVkClsyNjA2Mi45ODkxNTJdIG10NzkyNWUgMDAwMDowOTowMC4wOiBNVDc5MjcgV0ZT
WVMgcmVzZXQgdGltZW91dCAoUk9NQ09ERV9JTkRFWD0weGZmZmYpClsyNjA2NC4wMDkxNTFdIG10
NzkyNWUgMDAwMDowOTowMC4wOiBkcml2ZXIgb3duIGZhaWxlZApbMjYwNjUuMDI5MTM0XSBtdDc5
MjVlIDAwMDA6MDk6MDAuMDogZHJpdmVyIG93biBmYWlsZWQKWzI2MDY1LjQ1OTE0M10gbXQ3OTI1
ZSAwMDAwOjA5OjAwLjA6IE1UNzkyNyBXRlNZUyByZXNldCB0aW1lb3V0IChST01DT0RFX0lOREVY
PTB4ZmZmZikKWzI2MDY2LjQ3OTEzMF0gbXQ3OTI1ZSAwMDAwOjA5OjAwLjA6IGRyaXZlciBvd24g
ZmFpbGVkClsyNjA2Ni40NzkxNjFdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBwYWdlIGZhdWx0IGZv
ciBhZGRyZXNzOiBmZmZmZDE5MzgxOTkwZmYwClsyNjA2Ni40NzkxNjRdICNQRjogc3VwZXJ2aXNv
ciB3cml0ZSBhY2Nlc3MgaW4ga2VybmVsIG1vZGUKWzI2MDY2LjQ3OTE2NV0gI1BGOiBlcnJvcl9j
b2RlKDB4MDAwMikgLSBub3QtcHJlc2VudCBwYWdlClsyNjA2Ni40NzkxNjZdIFBHRCAxMDAwMDAw
NjcgUDREIDEwMDAwMDA2NyBQVUQgMTAwMmU0MDY3IFBNRCAxMDJlNWYwNjcgUFRFIDAKWzI2MDY2
LjQ3OTE2OF0gT29wczogT29wczogMDAwMiBbIzFdIFNNUCBOT1BUSQpbMjYwNjYuNDc5MTcxXSBD
UFU6IDggVUlEOiAwIFBJRDogMTMxOSBDb21tOiB3cGFfc3VwcGxpY2FudCBUYWludGVkOiBHICAg
ICAgICAgICBPRSAgICAgICA3LjIuNS0zLW9tYXJjaHkgIzEgUFJFRU1QVChmdWxsKSAgMjQwZjll
YzVhODAyMmIxYTdmNTc4YjAxOTkwMzNiZjA2NzY1OGZiYwpbMjYwNjYuNDc5MTc0XSBUYWludGVk
OiBbT109T09UX01PRFVMRSwgW0VdPVVOU0lHTkVEX01PRFVMRQpbMjYwNjYuNDc5MTc0XSBIYXJk
d2FyZSBuYW1lOiBBU1VTIFN5c3RlbSBQcm9kdWN0IE5hbWUvUHJvQXJ0IFg4NzBFLUNSRUFUT1Ig
V0lGSSwgQklPUyAyMTAzIDAzLzA5LzIwMjYKWzI2MDY2LjQ3OTE3NV0gUklQOiAwMDEwOm10NzZf
ZG1hX2FkZF9idWYuaXNyYS4wKzB4OWMvMHgyMzAgW210NzZdClsyNjA2Ni40NzkxODJdIENvZGU6
IDQ1IDMxIGM5IDRjIDg5IDZjIDI0IDM4IDRjIDg5IDdjIDI0IDQ4IDg5IDQ0IDI0IDBjIDRjIDg5
IDU0IDI0IDEwIDQ4IDg5IDRjIDI0IDE4IGViIDNhIDg5IGMxIDgwIGNkIDQwIDQ0IDM5IDRjIDI0
IDBjIDBmIDQ0IGMxIDw0NT4gODkgMjggNDEgODMgYzEgMDIgNDggODMgYzYgMjAgNDUgODkgNzgg
MDggNDEgODkgNjggMGMgNDEgODkgNDAKWzI2MDY2LjQ3OTE4M10gUlNQOiAwMDE4OmZmZmZkMTkz
ODc4Mjc0YTAgRUZMQUdTOiAwMDAxMDIwNgpbMjYwNjYuNDc5MTg0XSBSQVg6IDAwMDAwMDAwNDM1
NDAwMDAgUkJYOiAwMDAwMDAwMDAwMDAwMDAwIFJDWDogZmZmZjg5YWMwZGYzNDAxMApbMjYwNjYu
NDc5MTg1XSBSRFg6IDAwMDAwMDAwMDAwMDAwMDAgUlNJOiBmZmZmZDE5Mzg3ODI3NGY4IFJESTog
ZmZmZjg5YWMwZGNlMTZiOApbMjYwNjYuNDc5MTg1XSBSQlA6IDAwMDAwMDAwMDAwMDAwMDAgUjA4
OiBmZmZmZDE5MzgxOTkwZmYwIFIwOTogMDAwMDAwMDAwMDAwMDAwMApbMjYwNjYuNDc5MTg2XSBS
MTA6IDAwMDAwMDAwMDA0ZmZlMDIgUjExOiAwMDAwMDAwMDAzNTQwMDAwIFIxMjogMDAwMDAwMDAw
MDAwMDAwMApbMjYwNjYuNDc5MTg2XSBSMTM6IDAwMDAwMDAwZWUyMjcwMTAgUjE0OiAwMDAwMDAw
MDAwMDBmZmZmIFIxNTogMDAwMDAwMDAwMDAwMDAwMApbMjYwNjYuNDc5MTg3XSBGUzogIDAwMDA3
Yjg2YjU3YjA0MDAoMDAwMCkgR1M6ZmZmZjg5YmIyMzczMTAwMCgwMDAwKSBrbmxHUzowMDAwMDAw
MDAwMDAwMDAwClsyNjA2Ni40NzkxODddIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6
IDAwMDAwMDAwODAwNTAwMzMKWzI2MDY2LjQ3OTE4OF0gQ1IyOiBmZmZmZDE5MzgxOTkwZmYwIENS
MzogMDAwMDAwMDEyZmM2YzAwMCBDUjQ6IDAwMDAwMDAwMDBmNTBlZjAKWzI2MDY2LjQ3OTE4OV0g
UEtSVTogNTU1NTU1NTQKWzI2MDY2LjQ3OTE5MF0gQ2FsbCBUcmFjZToKWzI2MDY2LjQ3OTE5MF0g
IDxUQVNLPgpbMjYwNjYuNDc5MTkxXSAgbXQ3Nl9kbWFfdHhfcXVldWVfc2tiX3JhdysweDEyYi8w
eDIzMCBbbXQ3NiBjNDQzNjUyMDY5NTFjMTdkN2Q2MmFjYWVkN2Y1ZTZkY2MxMzQzOTgzXQpbMjYw
NjYuNDc5MTk1XSAgbXQ3Nl9tY3Vfc2tiX3NlbmRfYW5kX2dldF9tc2crMHgxMTkvMHgyZTAgW210
NzYgYzQ0MzY1MjA2OTUxYzE3ZDdkNjJhY2FlZDdmNWU2ZGNjMTM0Mzk4M10KWzI2MDY2LjQ3OTE5
OV0gIG10NzkyNV9tY3VfaHdfc2NhbisweDM2YS8weDRiMCBbbXQ3OTI1X2NvbW1vbiAwYmMxNDA2
M2E4YTAwYjk5MTcwMWEzYTliYWQyNTJjMzNkOWJiZmIxXQpbMjYwNjYuNDc5MjAzXSAgPyBtdDc2
X2Nvbm5hY19wbV93YWtlKzB4NGQvMHgxOTAgW210NzZfY29ubmFjX2xpYiA1NGJiOTFiODIwYmM0
MmU5NDNkNDViODBiNDRlMzhiMmExMTEzM2UzXQpbMjYwNjYuNDc5MjA3XSAgbXQ3OTI1X2h3X3Nj
YW4rMHg1ZC8weGEwIFttdDc5MjVfY29tbW9uIDBiYzE0MDYzYThhMDBiOTkxNzAxYTNhOWJhZDI1
MmMzM2Q5YmJmYjFdClsyNjA2Ni40NzkyMDldICBkcnZfaHdfc2NhbisweDhiLzB4MTYwIFttYWM4
MDIxMSBkYmU4ZDdmMGIyMWI2NzM1YzA3OTdlOGZiYmMwZTY2ZGExMDQ5MzUyXQpbMjYwNjYuNDc5
MjMxXSAgX19pZWVlODAyMTFfc3RhcnRfc2NhbisweDJkYy8weDgxMCBbbWFjODAyMTEgZGJlOGQ3
ZjBiMjFiNjczNWMwNzk3ZThmYmJjMGU2NmRhMTA0OTM1Ml0KWzI2MDY2LjQ3OTI0N10gIHJkZXZf
c2NhbisweDNmLzB4MTMwIFtjZmc4MDIxMSA1NmE3NWM2ZDNhNTMxZGQ4ZmU1NDZlY2QzMDA0ZjRj
NjUyYzdmNzBjXQpbMjYwNjYuNDc5MjY5XSAgY2ZnODAyMTFfc2NhbisweDEyYi8weDFiMCBbY2Zn
ODAyMTEgNTZhNzVjNmQzYTUzMWRkOGZlNTQ2ZWNkMzAwNGY0YzY1MmM3ZjcwY10KWzI2MDY2LjQ3
OTI4NF0gID8gY2ZnODAyMTFfb2ZmX2NoYW5uZWxfb3Blcl9hbGxvd2VkKzB4M2IvMHhkMCBbY2Zn
ODAyMTEgNTZhNzVjNmQzYTUzMWRkOGZlNTQ2ZWNkMzAwNGY0YzY1MmM3ZjcwY10KWzI2MDY2LjQ3
OTI5OV0gIG5sODAyMTFfdHJpZ2dlcl9zY2FuKzB4NTQzLzB4ODYwIFtjZmc4MDIxMSA1NmE3NWM2
ZDNhNTMxZGQ4ZmU1NDZlY2QzMDA0ZjRjNjUyYzdmNzBjXQpbMjYwNjYuNDc5MzE2XSAgZ2VubF9m
YW1pbHlfcmN2X21zZ19kb2l0KzB4MTQ4LzB4MWIwClsyNjA2Ni40NzkzMjFdICBnZW5sX3Jjdl9t
c2crMHgxZTIvMHgzMjAKWzI2MDY2LjQ3OTMyMl0gID8gX19wZnhfbmw4MDIxMV9wcmVfZG9pdCsw
eDEwLzB4MTAgW2NmZzgwMjExIDU2YTc1YzZkM2E1MzFkZDhmZTU0NmVjZDMwMDRmNGM2NTJjN2Y3
MGNdClsyNjA2Ni40NzkzMzZdICA/IF9fcGZ4X25sODAyMTFfdHJpZ2dlcl9zY2FuKzB4MTAvMHgx
MCBbY2ZnODAyMTEgNTZhNzVjNmQzYTUzMWRkOGZlNTQ2ZWNkMzAwNGY0YzY1MmM3ZjcwY10KWzI2
MDY2LjQ3OTM1MF0gID8gX19wZnhfbmw4MDIxMV9wb3N0X2RvaXQrMHgxMC8weDEwIFtjZmc4MDIx
MSA1NmE3NWM2ZDNhNTMxZGQ4ZmU1NDZlY2QzMDA0ZjRjNjUyYzdmNzBjXQpbMjYwNjYuNDc5MzY0
XSAgPyBfX3BmeF9nZW5sX3Jjdl9tc2crMHgxMC8weDEwClsyNjA2Ni40NzkzNjVdICBuZXRsaW5r
X3Jjdl9za2IrMHhjZC8weDE1MApbMjYwNjYuNDc5MzY2XSAgZ2VubF9yY3YrMHgyOC8weDQwClsy
NjA2Ni40NzkzNjddICBuZXRsaW5rX3VuaWNhc3QrMHgyYWEvMHgzZTAKWzI2MDY2LjQ3OTM2OF0g
IG5ldGxpbmtfc2VuZG1zZysweDIxZi8weDQ4MApbMjYwNjYuNDc5MzY5XSAgX19fX3N5c19zZW5k
bXNnKzB4M2E3LzB4M2UwClsyNjA2Ni40NzkzNzFdICA/IGltcG9ydF9pb3ZlYysweDMyLzB4NTAK
WzI2MDY2LjQ3OTM3M10gIF9fX3N5c19zZW5kbXNnKzB4ZTEvMHgxNDAKWzI2MDY2LjQ3OTM3NV0g
IF9fc3lzX3NlbmRtc2crMHhhNC8weDExMApbMjYwNjYuNDc5Mzc3XSAgZG9fc3lzY2FsbF82NCsw
eGFhLzB4NjkwClsyNjA2Ni40NzkzNzldICA/IG5ldGxpbmtfc2V0c29ja29wdCsweDJhZi8weDUx
MApbMjYwNjYuNDc5MzgxXSAgPyBkb19zb2NrX3NldHNvY2tvcHQrMHhkMi8weDFlMApbMjYwNjYu
NDc5MzgyXSAgPyBhdWRpdF9yZXNldF9jb250ZXh0KzB4MmMxLzB4MzQwClsyNjA2Ni40NzkzODRd
ICA/IF9fYXVkaXRfc3lzY2FsbF9leGl0KzB4YTEvMHgxMDAKWzI2MDY2LjQ3OTM4NV0gID8gZG9f
c3lzY2FsbF82NCsweDY0Zi8weDY5MApbMjYwNjYuNDc5Mzg2XSAgPyBfX2F1ZGl0X3N5c2NhbGxf
ZXhpdCsweGExLzB4MTAwClsyNjA2Ni40NzkzODddICA/IF9feDY0X3N5c19wc2VsZWN0NisweDg0
LzB4YjAKWzI2MDY2LjQ3OTM5MF0gID8gZG9fc3lzY2FsbF82NCsweDY0Zi8weDY5MApbMjYwNjYu
NDc5MzkwXSAgPyBhdWRpdF9yZXNldF9jb250ZXh0KzB4MmMxLzB4MzQwClsyNjA2Ni40NzkzOTFd
ICA/IF9fYXVkaXRfc3lzY2FsbF9leGl0KzB4YTEvMHgxMDAKWzI2MDY2LjQ3OTM5Ml0gID8gZG9f
c3lzY2FsbF82NCsweDY0Zi8weDY5MApbMjYwNjYuNDc5MzkyXSAgPyBfX2F1ZGl0X3N5c2NhbGxf
ZXhpdCsweGExLzB4MTAwClsyNjA2Ni40NzkzOTNdICA/IGRvX3N5c2NhbGxfNjQrMHg2NGYvMHg2
OTAKWzI2MDY2LjQ3OTM5NF0gID8gYXVkaXRfcmVzZXRfY29udGV4dCsweDJjMS8weDM0MApbMjYw
NjYuNDc5Mzk1XSAgPyBfX2F1ZGl0X3N5c2NhbGxfZXhpdCsweGExLzB4MTAwClsyNjA2Ni40Nzkz
OTZdICA/IGRvX3N5c2NhbGxfNjQrMHg2NGYvMHg2OTAKWzI2MDY2LjQ3OTM5Nl0gID8gX19hdWRp
dF9zeXNjYWxsX2V4aXQrMHhhMS8weDEwMApbMjYwNjYuNDc5Mzk3XSAgPyBhdWRpdGRfdGVzdF90
YXNrKzB4M2MvMHg1MApbMjYwNjYuNDc5Mzk5XSAgPyBfX2F1ZGl0X3N5c2NhbGxfZW50cnkrMHgx
MzYvMHgxODAKWzI2MDY2LjQ3OTQwMF0gID8gZG9fc3lzY2FsbF82NCsweDVmLzB4NjkwClsyNjA2
Ni40Nzk0MDBdICBlbnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHg3Ni8weDdlClsyNjA2
Ni40Nzk0MDJdIFJJUDogMDAzMzoweDdiODZiNGYyMzA0OApbMjYwNjYuNDc5NDE3XSBDb2RlOiA0
OCA4YiAwNSBjYiA1YyAwZiAwMCA2NCA4OSAxMCA0OCBjNyBjMiBmZiBmZiBmZiBmZiBjOSA0OCA4
OSBkMCBjMyAwZiAxZiA0MCAwMCA0NSAzMSBjOSA0NSAzMSBjMCA0NSAzMSBkMiBiOCAyZSAwMCAw
MCAwMCAwZiAwNSA8NDg+IDg5IGMyIDQ4IDNkIDAwIGYwIGZmIGZmIDc3IDBkIGM5IDQ4IDg5IGQw
IGMzIDBmIDFmIDg0IDAwIDAwIDAwClsyNjA2Ni40Nzk0MThdIFJTUDogMDAyYjowMDAwN2ZmYzc5
OTQzOTYwIEVGTEFHUzogMDAwMDAyNDYgT1JJR19SQVg6IDAwMDAwMDAwMDAwMDAwMmUKWzI2MDY2
LjQ3OTQxOV0gUkFYOiBmZmZmZmZmZmZmZmZmZmRhIFJCWDogMDAwMDVlODkzMzFkMTI2MCBSQ1g6
IDAwMDA3Yjg2YjRmMjMwNDgKWzI2MDY2LjQ3OTQxOV0gUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJT
STogMDAwMDdmZmM3OTk0MzljMCBSREk6IDAwMDAwMDAwMDAwMDAwMDYKWzI2MDY2LjQ3OTQxOV0g
UkJQOiAwMDAwN2ZmYzc5OTQzOTcwIFIwODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6IDAwMDAwMDAw
MDAwMDAwMDAKWzI2MDY2LjQ3OTQyMF0gUjEwOiAwMDAwMDAwMDAwMDAwMDAwIFIxMTogMDAwMDAw
MDAwMDAwMDI0NiBSMTI6IDAwMDA1ZTg5MzMyZDM3YzAKWzI2MDY2LjQ3OTQyMF0gUjEzOiAwMDAw
N2ZmYzc5OTQzOWMwIFIxNDogMDAwMDVlODkzMzFkYWYxMCBSMTU6IDAwMDAwMDAwMDAwMDAwMDAK
WzI2MDY2LjQ3OTQyMV0gIDwvVEFTSz4KWzI2MDY2LjQ3OTQyMl0gTW9kdWxlcyBsaW5rZWQgaW46
IG5mdF9uYXQgbmZ0X2N0IG5mdF9maWJfaW5ldCBuZnRfZmliX2lwdjQgbmZ0X2ZpYl9pcHY2IG5m
dF9maWIgbmZ0X21hc3EgdmV0aCBicmlkZ2Ugc3RwIGxsYyBvdmVybGF5IGhpZF9wbGF5c3RhdGlv
biBmZl9tZW1sZXNzIGxlZF9jbGFzc19tdWx0aWNvbG9yIHVpbnB1dCBzbmRfc2VxX2R1bW15IHNu
ZF9ocnRpbWVyIHNuZF9zZXEgeHRfY29ubm1hcmsgeHRfTUFTUVVFUkFERSB4dF9tYXJrIG5mdF9j
aGFpbl9uYXQgbmZfbmF0IHR1biBibmVwIG50ZnMzIHZmYXQgZmF0IGFtZF9hdGwgaW50ZWxfcmFw
bF9tc3IgaW50ZWxfcmFwbF9jb21tb24gc25kX2hkYV9jb2RlY19hbGM4ODIgc25kX2hkYV9jb2Rl
Y19yZWFsdGVrX2xpYiBzbmRfaGRhX2NvZGVjX2dlbmVyaWMgbXQ3OTI1ZSBzbmRfaGRhX2NvZGVj
X2F0aWhkbWkgc25kX2hkYV9jb2RlY19udmhkbWkgbXQ3OTI1X2NvbW1vbiBidHVzYiBzbmRfaGRh
X2NvZGVjX2hkbWkgYnRtdGsgbXQ3OTJ4X2xpYiBrdm1fYW1kIGJ0cnRsIG10NzZfY29ubmFjX2xp
YiBzbmRfaGRhX2ludGVsIGJ0YmNtIG10NzYgc25kX2hkYV9jb2RlYyBrdm0gc25kX3VzYl9hdWRp
byBzcGQ1MTE4IGJ0aW50ZWwgYXN1c19lY19zZW5zb3JzIGVlZXBjX3dtaSBzbmRfaGRhX2NvcmUg
aXJxYnlwYXNzIHNuZF91c2JtaWRpX2xpYiB4b25lX2RvbmdsZShPRSkgbWFjODAyMTEgeG9uZV9n
aXAoT0UpIHJhcGwgYXN1c193bWkgYmx1ZXRvb3RoIHNuZF91bXAgaTJjX3BpaXg0IHNuZF9pbnRl
bF9kc3BjZmcgd21pX2Jtb2Ygc3BhcnNlX2tleW1hcCBwY3Nwa3IgazEwdGVtcCBpMmNfc21idXMg
c25kX2ludGVsX3Nkd19hY3BpIHNuZF9yYXdtaWRpIHNuZF9od2RlcCBjZmc4MDIxMSBzbmRfc2Vx
X2RldmljZSBhdGxhbnRpYyBtb3VzZWRldiBqb3lkZXYgbWMgc25kX3BjbSBpZ2MgbWFjc2VjIHBy
b20yMV94aGNpIHJma2lsbCBwdHAgdWNzaV9hY3BpIHNuZF90aW1lciBsaWJhcmM0IHBwc19jb3Jl
IHR5cGVjX3Vjc2kgc25kIHJvbGVzIGdwaW9fYW1kcHQKWzI2MDY2LjQ3OTQ0OF0gIHNvdW5kY29y
ZSB0eXBlYyBncGlvX2dlbmVyaWMgYWNwaV9wYWQgbWFjX2hpZCBpcDZ0X1JFSkVDVCBuZl9yZWpl
Y3RfaXB2NiB4dF9obCBpcDZ0X3J0IGlwdF9SRUpFQ1QgbmZfcmVqZWN0X2lwdjQgeHRfTE9HIG5m
X2xvZ19zeXNsb2cgbmZ0X2xpbWl0IHh0X2xpbWl0IHh0X2FkZHJ0eXBlIHh0X3RjcHVkcCB4dF9j
b25udHJhY2sgbmZfY29ubnRyYWNrIG5mX2RlZnJhZ19pcHY2IG5mX2RlZnJhZ19pcHY0IG5mdF9j
b21wYXQgeF90YWJsZXMgbmZfdGFibGVzIG5jdDY3NzUgbmN0Njc3NV9jb3JlIG50c3luYyBzcDUx
MDBfdGNvIGh3bW9uX3ZpZCBpMmNfZGV2IGNyeXB0b191c2VyIHVoaWQgenJhbSA4NDJfZGVjb21w
cmVzcyA4NDJfY29tcHJlc3MgbHo0aGNfY29tcHJlc3MgZG1fY3J5cHQgZW5jcnlwdGVkX2tleXMg
dHJ1c3RlZCBhc24xX2VuY29kZXIgdGVlIGRtX21vZCBhbWRncHUgZHJtX2J1ZGR5IGFtZHhjcCBp
MmNfYWxnb19iaXQgZHJtX2V4ZWMgZHJtX3BhbmVsX2JhY2tsaWdodF9xdWlya3MgZ3B1X3NjaGVk
IG52bWUgZHJtX3N1YmFsbG9jX2hlbHBlciBhZXNuaV9pbnRlbCBnZjEyOG11bCBkcm1fZGlzcGxh
eV9oZWxwZXIgY2NwIG52bWVfY29yZSBjZWMgbnZtZV9rZXlyaW5nIG52bWVfYXV0aCB0aHVuZGVy
Ym9sdCBoaWRfbG9naXRlY2hfaGlkcHAgaGlkX2xvZ2l0ZWNoX2RqIG52aWRpYV9kcm0oT0UpIGRy
bV90dG1faGVscGVyIHR0bSBudmlkaWFfdXZtKE9FKSBudmlkaWFfbW9kZXNldChPRSkgdmlkZW8g
d21pIG52aWRpYShPRSkgYWVhZApbMjYwNjYuNDc5NDcxXSBDUjI6IGZmZmZkMTkzODE5OTBmZjAK
WzI2MDY2LjQ3OTQ3Ml0gLS0tWyBlbmQgdHJhY2UgMDAwMDAwMDAwMDAwMDAwMCBdLS0tClsyNjA2
Ni41NzU4NTZdIFJJUDogMDAxMDptdDc2X2RtYV9hZGRfYnVmLmlzcmEuMCsweDljLzB4MjMwIFtt
dDc2XQpbMjYwNjYuNTc1ODY4XSBDb2RlOiA0NSAzMSBjOSA0YyA4OSA2YyAyNCAzOCA0YyA4OSA3
YyAyNCA0OCA4OSA0NCAyNCAwYyA0YyA4OSA1NCAyNCAxMCA0OCA4OSA0YyAyNCAxOCBlYiAzYSA4
OSBjMSA4MCBjZCA0MCA0NCAzOSA0YyAyNCAwYyAwZiA0NCBjMSA8NDU+IDg5IDI4IDQxIDgzIGMx
IDAyIDQ4IDgzIGM2IDIwIDQ1IDg5IDc4IDA4IDQxIDg5IDY4IDBjIDQxIDg5IDQwClsyNjA2Ni41
NzU4NjldIFJTUDogMDAxODpmZmZmZDE5Mzg3ODI3NGEwIEVGTEFHUzogMDAwMTAyMDYKWzI2MDY2
LjU3NTg3MV0gUkFYOiAwMDAwMDAwMDQzNTQwMDAwIFJCWDogMDAwMDAwMDAwMDAwMDAwMCBSQ1g6
IGZmZmY4OWFjMGRmMzQwMTAKWzI2MDY2LjU3NTg3Ml0gUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJT
STogZmZmZmQxOTM4NzgyNzRmOCBSREk6IGZmZmY4OWFjMGRjZTE2YjgKWzI2MDY2LjU3NTg3Ml0g
UkJQOiAwMDAwMDAwMDAwMDAwMDAwIFIwODogZmZmZmQxOTM4MTk5MGZmMCBSMDk6IDAwMDAwMDAw
MDAwMDAwMDAKWzI2MDY2LjU3NTg3Ml0gUjEwOiAwMDAwMDAwMDAwNGZmZTAyIFIxMTogMDAwMDAw
MDAwMzU0MDAwMCBSMTI6IDAwMDAwMDAwMDAwMDAwMDAKWzI2MDY2LjU3NTg3M10gUjEzOiAwMDAw
MDAwMGVlMjI3MDEwIFIxNDogMDAwMDAwMDAwMDAwZmZmZiBSMTU6IDAwMDAwMDAwMDAwMDAwMDAK
WzI2MDY2LjU3NTg3NF0gRlM6ICAwMDAwN2I4NmI1N2IwNDAwKDAwMDApIEdTOmZmZmY4OWJiMjM3
MzEwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbMjYwNjYuNTc1ODc1XSBDUzogIDAw
MTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzClsyNjA2Ni41NzU4NzZd
IENSMjogZmZmZmQxOTM4MTk5MGZmMCBDUjM6IDAwMDAwMDAxMmZjNmMwMDAgQ1I0OiAwMDAwMDAw
MDAwZjUwZWYwClsyNjA2Ni41NzU4NzddIFBLUlU6IDU1NTU1NTU0ClsyNjA2Ni41NzU4NzhdIEtl
cm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24gaW4gaW50ZXJydXB0Clsy
NjA2Ni41NzU5MzldIEtlcm5lbCBPZmZzZXQ6IDB4MTdlMDAwMDAgZnJvbSAweGZmZmZmZmZmODEw
MDAwMDAgKHJlbG9jYXRpb24gcmFuZ2U6IDB4ZmZmZmZmZmY4MDAwMDAwMC0weGZmZmZmZmZmYmZm
ZmZmZmYpCgoyMDI2LTEwLTA0LCBzYW1lIGJvb3QsIEJsdWV0b290aCBhbmQgV2ktRmkgbGluZXMg
ZnJvbSB0aGUgam91cm5hbAooQ0xPQ0tfTU9OT1RPTklDLCBhYm91dCAwLjUgcyBhaGVhZCBvZiBw
cmludGspOgoKWzE1LjE4ODA1MV0gdXNiIDgtNjogbmV3IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBu
dW1iZXIgMyB1c2luZyB4aGNpLXBjaS1wcm9tMjEKWzE2LjQ0MjA3MV0gbXQ3OTI1ZSAwMDAwOjA5
OjAwLjA6IGVuYWJsaW5nIGRldmljZSAoMDAwMCAtPiAwMDAyKQpbMTYuNDQyMTgyXSBtdDc5MjVl
IDAwMDA6MDk6MDAuMDogZGlzYWJsaW5nIEFTUE0gIEwxClsxNi40NTAwMDJdIG10NzkyNWUgMDAw
MDowOTowMC4wOiBBU0lDIHJldmlzaW9uOiAwMDAwClsxNi40NTAwOThdIG10NzkyNWUgMDAwMDow
OTowMC4wOiBNVDc5MjcgcmF3IENISVBJRD0weDAwMDAsIGZvcmNpbmcgY2hpcD0weDc5MjcKWzE2
LjQ1MjAwM10gQmx1ZXRvb3RoOiBoY2kwOiBIVy9TVyBWZXJzaW9uOiAweDAwMDAwMDAwLCBCdWls
ZCBUaW1lOiAyMDI1MDYwNjIwMTIzNQpbMTYuNDcwMDE1XSBtdDc5MjVlIDAwMDA6MDk6MDAuMDog
SFcvU1cgVmVyc2lvbjogMHg4YTEwOGExMCwgQnVpbGQgVGltZTogMjAyNjA0MTQxMzM3NTBhClsx
Ni41NTMwMDNdIG10NzkyNWUgMDAwMDowOTowMC4wOiBXTSBGaXJtd2FyZSBWZXJzaW9uOiBfX19f
MDAwMDAwLCBCdWlsZCBUaW1lOiAyMDI2MDQxNDEzNDI1NQpbMTcuMDcyMDA2XSBtdDc5MjVlIDAw
MDA6MDk6MDAuMCB3bHA5czA6IHJlbmFtZWQgZnJvbSB3bGFuMApbMjkuMjc2MDEwXSBCbHVldG9v
dGg6IGhjaTA6IEV4ZWN1dGlvbiBvZiB3bXQgY29tbWFuZCB0aW1lZCBvdXQKWzI5LjI3NjA3MF0g
Qmx1ZXRvb3RoOiBoY2kwOiBGYWlsZWQgdG8gc2VuZCB3bXQgZnVuYyBjdHJsICgtMTEwKQpbMjku
Mjc2MDg3XSBCbHVldG9vdGg6IGhjaTA6IEhDSSBFbmhhbmNlZCBTZXR1cCBTeW5jaHJvbm91cyBD
b25uZWN0aW9uIGNvbW1hbmQgaXMgYWR2ZXJ0aXNlZCwgYnV0IG5vdCBzdXBwb3J0ZWQuClszNC4z
OTUzNTJdIEJsdWV0b290aDogaGNpMDogRmFpbGVkIHRvIHJlYWQgdWh3IHJlZygtMTEwKQpbMzQu
NTc3MDA2XSB1c2IgOC02OiByZXNldCBoaWdoLXNwZWVkIFVTQiBkZXZpY2UgbnVtYmVyIDMgdXNp
bmcgeGhjaS1wY2ktcHJvbTIxCls0MC4yMDMwMDldIHVzYiA4LTY6IGRldmljZSBkZXNjcmlwdG9y
IHJlYWQvNjQsIGVycm9yIC0xMTAKWzU2LjA3MzAzNF0gdXNiIDgtNjogZGV2aWNlIGRlc2NyaXB0
b3IgcmVhZC82NCwgZXJyb3IgLTExMApbNTYuNTU5MDI1XSB1c2IgOC02OiByZXNldCBoaWdoLXNw
ZWVkIFVTQiBkZXZpY2UgbnVtYmVyIDMgdXNpbmcgeGhjaS1wY2ktcHJvbTIxCls2Mi4yMTcwNzRd
IHVzYiA4LTY6IGRldmljZSBkZXNjcmlwdG9yIHJlYWQvNjQsIGVycm9yIC0xMTAKWzc4LjA4OTA3
M10gdXNiIDgtNjogZGV2aWNlIGRlc2NyaXB0b3IgcmVhZC82NCwgZXJyb3IgLTExMApbNzguNTc1
MDA2XSB1c2IgOC02OiByZXNldCBoaWdoLXNwZWVkIFVTQiBkZXZpY2UgbnVtYmVyIDMgdXNpbmcg
eGhjaS1wY2ktcHJvbTIxCls4My4zNzYwMzBdIHVzYiA4LTY6IERldmljZSBub3QgcmVzcG9uZGlu
ZyB0byBzZXR1cCBhZGRyZXNzLgpbODguMzkwMDExXSB1c2IgOC02OiBEZXZpY2Ugbm90IHJlc3Bv
bmRpbmcgdG8gc2V0dXAgYWRkcmVzcy4KWzg4LjU5NjAyMF0gdXNiIDgtNjogZGV2aWNlIG5vdCBh
Y2NlcHRpbmcgYWRkcmVzcyAzLCBlcnJvciAtNzEKWzg4Ljk3NTAyNV0gdXNiIDgtNjogcmVzZXQg
aGlnaC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciAzIHVzaW5nIHhoY2ktcGNpLXByb20yMQpbOTMu
Nzc1MDI3XSB1c2IgOC02OiBEZXZpY2Ugbm90IHJlc3BvbmRpbmcgdG8gc2V0dXAgYWRkcmVzcy4K
Wzk4Ljc4ODAzMV0gdXNiIDgtNjogRGV2aWNlIG5vdCByZXNwb25kaW5nIHRvIHNldHVwIGFkZHJl
c3MuCls5OC45OTYwMTRdIHVzYiA4LTY6IGRldmljZSBub3QgYWNjZXB0aW5nIGFkZHJlc3MgMywg
ZXJyb3IgLTcxCls5OC45OTYwNjddIHVzYiA4LTY6IFVTQiBkaXNjb25uZWN0LCBkZXZpY2UgbnVt
YmVyIDMKWzk5LjE3NjAwNV0gdXNiIDgtNjogbmV3IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBudW1i
ZXIgMTEgdXNpbmcgeGhjaS1wY2ktcHJvbTIxClsxMDQuNzE0MDIxXSB1c2IgOC02OiBkZXZpY2Ug
ZGVzY3JpcHRvciByZWFkLzY0LCBlcnJvciAtMTEwClsxMjAuNTg1MDEyXSB1c2IgOC02OiBkZXZp
Y2UgZGVzY3JpcHRvciByZWFkLzY0LCBlcnJvciAtMTEwClsxMjAuODcwMDQ5XSB1c2IgOC02OiBu
ZXcgaGlnaC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciAxMiB1c2luZyB4aGNpLXBjaS1wcm9tMjEK
WzEyNi4yMTcwMTBdIHVzYiA4LTY6IGRldmljZSBkZXNjcmlwdG9yIHJlYWQvNjQsIGVycm9yIC0x
MTAKWzE0Mi4wOTAwMjRdIHVzYiA4LTY6IGRldmljZSBkZXNjcmlwdG9yIHJlYWQvNjQsIGVycm9y
IC0xMTAKWzE0Mi42NDAwMTddIHVzYiA4LTY6IG5ldyBoaWdoLXNwZWVkIFVTQiBkZXZpY2UgbnVt
YmVyIDEzIHVzaW5nIHhoY2ktcGNpLXByb20yMQpbMTQ3LjQzOTAxMF0gdXNiIDgtNjogRGV2aWNl
IG5vdCByZXNwb25kaW5nIHRvIHNldHVwIGFkZHJlc3MuClsxNTIuNDUxMDE2XSB1c2IgOC02OiBE
ZXZpY2Ugbm90IHJlc3BvbmRpbmcgdG8gc2V0dXAgYWRkcmVzcy4KWzE1Mi42NjAwMTVdIHVzYiA4
LTY6IGRldmljZSBub3QgYWNjZXB0aW5nIGFkZHJlc3MgMTMsIGVycm9yIC03MQpbMTUyLjgzODAw
NF0gdXNiIDgtNjogbmV3IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBudW1iZXIgMTQgdXNpbmcgeGhj
aS1wY2ktcHJvbTIxClsxNTcuNjM3MDE3XSB1c2IgOC02OiBEZXZpY2Ugbm90IHJlc3BvbmRpbmcg
dG8gc2V0dXAgYWRkcmVzcy4KWzE2Mi42NDQwMTJdIHVzYiA4LTY6IERldmljZSBub3QgcmVzcG9u
ZGluZyB0byBzZXR1cCBhZGRyZXNzLgpbMTYyLjg1MzA1OV0gdXNiIDgtNjogZGV2aWNlIG5vdCBh
Y2NlcHRpbmcgYWRkcmVzcyAxNCwgZXJyb3IgLTcxClsyNjA1My45MzUwMTldIHVzYiA4LTY6IG5l
dyBoaWdoLXNwZWVkIFVTQiBkZXZpY2UgbnVtYmVyIDE1IHVzaW5nIHhoY2ktcGNpLXByb20yMQpb
MjYwNTQuMjE5MDEwXSBCbHVldG9vdGg6IGhjaTA6IEhXL1NXIFZlcnNpb246IDB4MDAwMDAwMDAs
IEJ1aWxkIFRpbWU6IDIwMjUwNjA2MjAxMjM1ClsyNjA1Ny4wNTIwMDRdIG10NzkyNWUgMDAwMDow
OTowMC4wOiBNZXNzYWdlIDAwMDIwMDE2IChzZXEgMykgdGltZW91dApbMjYwNTguMDcyMDA3XSBt
dDc5MjVlIDAwMDA6MDk6MDAuMDogZHJpdmVyIG93biBmYWlsZWQKWzI2MDU4LjUwNDA2NF0gbXQ3
OTI1ZSAwMDAwOjA5OjAwLjA6IE1UNzkyNyBXRlNZUyByZXNldCB0aW1lb3V0IChST01DT0RFX0lO
REVYPTB4ZmZmZikKWzI2MDU5LjUyNDA1M10gbXQ3OTI1ZSAwMDAwOjA5OjAwLjA6IGRyaXZlciBv
d24gZmFpbGVkClsyNjA2MC41NDQwMTldIG10NzkyNWUgMDAwMDowOTowMC4wOiBkcml2ZXIgb3du
IGZhaWxlZApbMjYwNjAuOTc2MDU0XSBtdDc5MjVlIDAwMDA6MDk6MDAuMDogTVQ3OTI3IFdGU1lT
IHJlc2V0IHRpbWVvdXQgKFJPTUNPREVfSU5ERVg9MHhmZmZmKQpbMjYwNjEuOTk2MDE4XSBtdDc5
MjVlIDAwMDA6MDk6MDAuMDogZHJpdmVyIG93biBmYWlsZWQKWzI2MDYzLjAxNjAwOF0gbXQ3OTI1
ZSAwMDAwOjA5OjAwLjA6IGRyaXZlciBvd24gZmFpbGVkClsyNjA2My40MzkwMDddIG10NzkyNWUg
MDAwMDowOTowMC4wOiBNVDc5MjcgV0ZTWVMgcmVzZXQgdGltZW91dCAoUk9NQ09ERV9JTkRFWD0w
eGZmZmYpClsyNjA2NC40NTkwMjNdIG10NzkyNWUgMDAwMDowOTowMC4wOiBkcml2ZXIgb3duIGZh
aWxlZApbMjYwNjUuNDc5MDA3XSBtdDc5MjVlIDAwMDA6MDk6MDAuMDogZHJpdmVyIG93biBmYWls
ZWQKWzI2MDY1LjkwOTAxNl0gbXQ3OTI1ZSAwMDAwOjA5OjAwLjA6IE1UNzkyNyBXRlNZUyByZXNl
dCB0aW1lb3V0IChST01DT0RFX0lOREVYPTB4ZmZmZikKWzI2MDY2LjkzMzk2Nl0gbXQ3OTI1ZSAw
MDAwOjA5OjAwLjA6IGRyaXZlciBvd24gZmFpbGVkCgoyMDI2LTEwLTAzLCBlbmQgb2YgdGhlIGpv
dXJuYWwgYmVmb3JlIHRoZSBmaXJzdCByZWJvb3Q6CgpbMTkzMjYuNTczMDI4XSB1c2IgOC02OiBO
ZXcgVVNCIGRldmljZSBzdHJpbmdzOiBNZnI9NSwgUHJvZHVjdD02LCBTZXJpYWxOdW1iZXI9Nwpb
MTkzMjYuNTczMzg3XSB1c2IgOC02OiBQcm9kdWN0OiBXaXJlbGVzc19EZXZpY2UKWzE5MzI2LjU3
MzQ5NF0gdXNiIDgtNjogTWFudWZhY3R1cmVyOiBNZWRpYVRlayBJbmMuClsxOTMyNi41NzM1ODRd
IHVzYiA4LTY6IFNlcmlhbE51bWJlcjogMDAwMDAwMDAwClsxOTMyNi43NDAwMjZdIEJsdWV0b290
aDogaGNpMDogSFcvU1cgVmVyc2lvbjogMHgwMDAwMDAwMCwgQnVpbGQgVGltZTogMjAyNTA2MDYy
MDEyMzUKWzE5MzQ2LjU3MDk4M10gQmx1ZXRvb3RoOiBoY2kwOiBEZXZpY2Ugc2V0dXAgaW4gMTkz
Nzc0OTkgdXNlY3MKWzE5MzQ2LjU3MTEyNV0gQmx1ZXRvb3RoOiBoY2kwOiBIQ0kgRW5oYW5jZWQg
U2V0dXAgU3luY2hyb25vdXMgQ29ubmVjdGlvbiBjb21tYW5kIGlzIGFkdmVydGlzZWQsIGJ1dCBu
b3Qgc3VwcG9ydGVkLgpbMTkzNDYuNzM1MjQyXSBCbHVldG9vdGg6IGhjaTA6IEFPU1AgZXh0ZW5z
aW9ucyB2ZXJzaW9uIHYxLjAwClsxOTM3My4wMjEwMTJdIG10NzkyNWUgMDAwMDowOTowMC4wOiBN
ZXNzYWdlIDAwMDIwMDE2IChzZXEgMTIpIHRpbWVvdXQKWzE5Mzc0LjA0MTAyNl0gbXQ3OTI1ZSAw
MDAwOjA5OjAwLjA6IGRyaXZlciBvd24gZmFpbGVkClsxOTM3NC40NzMwMjhdIG10NzkyNWUgMDAw
MDowOTowMC4wOiBNVDc5MjcgV0ZTWVMgcmVzZXQgdGltZW91dCAoUk9NQ09ERV9JTkRFWD0weGZm
ZmYpClsxOTM3NS40OTQwMTZdIG10NzkyNWUgMDAwMDowOTowMC4wOiBkcml2ZXIgb3duIGZhaWxl
ZApbMTkzNzYuNTE1MDE1XSBtdDc5MjVlIDAwMDA6MDk6MDAuMDogZHJpdmVyIG93biBmYWlsZWQK
WzE5Mzc2LjkzMjAxOV0gbXQ3OTI1ZSAwMDAwOjA5OjAwLjA6IE1UNzkyNyBXRlNZUyByZXNldCB0
aW1lb3V0IChST01DT0RFX0lOREVYPTB4ZmZmZikK
--000000000000f91fbe065d019158--
