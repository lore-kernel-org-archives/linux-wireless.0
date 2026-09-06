Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF6D17C203
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 02:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788662556; cv=none; b=tdy9AB6FxnguOyrSuzNdZDHwsK1N+LNej1FZeXZbEMf/aoyihbWywCZ1qGgq9w8Y0TCyKl3hQtMHuHEQiitVCJsVrmbT0NSt3flEcDYtiwgvEDcNB6p96jAeCzYYBxokmvQUYXpL+5WcxLw4eriY0TFAir9Xopnzdh7TFkVJBWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788662556; c=relaxed/simple;
	bh=6kIDuePJVRjtAcgl1iwx6ulfKrRsgD6jZuu3eZNqtBk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tuCaizwOM1v+RetqSV6bVJO640UMcVCRgiw8E8Q4prO7umkaVjY0CKc53ALczwLgeFQtVWhxJIGmsS/gh5cdOmpiz0uvakj0N1MFgaa3l5PxQpBQRiajOWM99AuyHV4i7cCr6IPuHWRujOKFJ4Whuf4Hwqg9yAfA429w7xh2cjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=H92tzadh; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="H92tzadh"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6862gUomD1591723, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788662550; bh=xSQkd5i9LDz98I1xpXkr08c2ncyTsqRcraO4bo0fzsE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=H92tzadhzYOPsTHHGEpZDzOTwkYo+K7kO+aFALmtypiPPaPM5goy3DiT9bTauy9du
	 EkIAuSVZ8CkCjsFEYQsU2RfJM+KBmUtcLoAZpP039BiA5tbQm2gH3O1Ir4z8k3AD0g
	 utHHMevRaQj/1jHrCufwLhAImkxTVmLruAZtY8NyA/8+pCQW8RXlmjY9rD+0tcxfvB
	 e0Sxp9S3RTS1hGFDhfP1MVZ6Fwvr5LgjqK0/UgDgj9q9QfK3vU90Lyl9AqWVHtTw0a
	 EGzO9KT6KhdFXL4A/EGAyOfX0M2Q+QCwY43lc8qnGhmxrfW8qFoK756lYRMKuXUJw2
	 3r/8ja4mt4O7g==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6862gUomD1591723
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 6 Sep 2026 10:42:30 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sun, 6 Sep 2026 10:42:30 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sun, 6 Sep 2026 10:42:30 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Sun, 6 Sep 2026 10:42:30 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: andres parra <andres.parrab@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC PATCH 0/4] wifi: rtw89: add NL80211_IFTYPE_P2P_DEVICE
 support
Thread-Topic: [RFC PATCH 0/4] wifi: rtw89: add NL80211_IFTYPE_P2P_DEVICE
 support
Thread-Index: AQHdMl2v7tQ2zv4uLUO5Yj5iw+rPVLav6JQwgAgPEICACPKoQA==
Date: Sun, 6 Sep 2026 02:42:30 +0000
Message-ID: <6f1348e20ecd4df383904c5225cd0954@realtek.com>
References: <20260822174229.65643-1-andres.parrab@gmail.com>
 <fe4778c07f644ed38a03c467ef1293d7@realtek.com>
 <20260831175044.208200-1-andres.parrab@gmail.com>
In-Reply-To: <20260831175044.208200-1-andres.parrab@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

andres parra <andres.parrab@gmail.com> wrote:
> On the two things I asked about:
>=20
> 1. Cross-band cost: confirmed reproducible with your patches too, and
>    it matches your explanation exactly -- forced the STA link onto
>    5GHz while the P2P-Client link stayed on 2.4GHz (same channel it
>    started on), and casting became noticeably choppier, then smooth
>    again once STA moved back to 2.4GHz. Consistent with TDMA timeslot
>    sharing rather than a bug in either patch set.

It depends on the bandwidth the casting needs.=20

The TDMA timeslot is assigned according to TBTT of AP and GO, but the
DUT (RTL8922AE) plays STA and GC, which he has no way to arrange a
good TBTT to yield 50/50 timeslot for 2/5GHz bands.

Which means if DUT is STA and GO, it will try it best to share the
timeslot for two roles.

>=20
> 2. Same-band channel-switch disconnect: reproduced it with your
>    patches too, while writing this email. My AP did a real, ordinary
>    channel switch on the STA link (CTRL-EVENT-STARTED-CHANNEL-SWITCH
>    -> CTRL-EVENT-CHANNEL-SWITCH, 2462 MHz -> 2412 MHz, i.e. channel 11
>    to channel 1, both 2.4 GHz),

Do you know why your AP want to switch from channel 11 to channel 1?
Or you manually control it to do so?

>    while the P2P-Client link was still
>    active on channel 11. Result, same signature as with my own patch:
>=20
>      p2p-wlanX-Y: CTRL-EVENT-BEACON-LOSS
>      p2p-wlanX-Y: CTRL-EVENT-DISCONNECTED bssid=3D<GO> reason=3D4 locally=
_generated=3D1
>      P2P-GROUP-REMOVED p2p-wlanX-Y client reason=3DIDLE

In our side, the setup below can work with RTL8922AE firmware v0.35.115.2
(not release yet; and it will be public soon)

PC#1  (AP)
   wls1 -> softap (ch 11)
   hostapd_cli wls1 ... [A]
PC#2  (GO)
   wpa_cli p2p-dev-wls1 p2p_group_add -> [p2p-wls1-0] p2p-GO (ch 11)
   wpa_cli p2p-wls1-0 ... [B]
PC#3  (STA + GC)
   wpa_cli wls1 -> connect to PC#1 sotap
   wpa_cli p2p-dev-wls1 ... [C]
   Then,
   make p2p connection via [B] and [C] -> PC#3 becomes SCC (ch 11 + ch 11)
=20
   Finally,
   set chan_switch via [A] -> PC#1 becomes ch 1 -> PC#3 becomes MCC (ch 1 +=
 ch 11)
   (chan_switch <cs_count> <freq>)

Ping-Ke

