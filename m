Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793506244;
	b=NPIl9p6rEgLLbAun/sd6UQbqDhubSfxJfYKbAwIPg/kyeIIlNgUwILSmLXNhX6sGmo5J
	 3s98Kj6Eh+93mRJDsu39MuGTEwHzSPJIRsAnx6rTuKGBU8FL1f2/Qjia1/nyxrJkNA5UD
	 19qukBWhryiNcZH8tMl0q6SvedJgke/Knj9BEP59+S+X9ufVX0Oyik/vd/CrsDwj1d4rz
	 gZnCYdxrwjGPZl8Q/GQZV4ULQvMBgJcu7uqvR70rBkQnktRn+v/t6dbiVt/1hi9afE5BK
	 HTHbsSbdyXObVLzITWmEpOAhI/vB0NmAVnDqaYvEUMCeV4d+OGM81aHdLshhIC+eXFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793506244;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=ajv74E5wtth3Pw8MLINuzItuOII5QRVD8ZuJ0OYqSmU=;
	b=xebC4tZlOMCGNhLMt9nKl1MVjUT/XQoVBdln8TXKiKYwsgDeBw66lh/F3+nx3yLBGi90
	 JdQuHx9teeZdYVhyMoXqFwbyQImU8x/A5EUnmA6lJsCWrMY8d6o/GHC88VGzqCzXeIWAE
	 RTNENG6yTDmpIWIBIVri7UyrLGHn45gqwiRxCNJa5ABO/NWWMp86uKSLge1ptFVpewzB1
	 E5LYxZIKO/NeSjmP5ubCnPxDzrdilgrSUevunjQiymHeXrr4qVSMq/sywBKRD6zOp6yu0
	 fNomK7GjlDWUXKA2KruczcPioUrciV2aBxnj2ad8Lug3PAbyBncepv8Rz1ODABX3q6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=waYcafKc;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76B6606A324
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 04:10:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A76B6606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=waYcafKc
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A14AOA401036247, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793506224; bh=ajv74E5wtth3Pw8MLINuzItuOII5QRVD8ZuJ0OYqSmU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=waYcafKcNLhr5C+v9lycLaRR5mVbHA99h1Ymn8Db0Owk0ob08ywN46GM3FfoMbQ35
	 Hg6kUxCFM6eRuANdRp31smzJFsku9pj7f1xsHqhIbcF4UKYFZh7SFS0LTPEcqocs4l
	 sP0j0Asa3A/adcIKtTC+2Yau4z6xAAQIppWRDZ9Vt5Bv64mzt5+PUeKYtHfILMbJdC
	 E29VzfG8bJ+BFuQcNuxf+UDNkwFDFIVh3XO7s2gnayzcLA3yQZqUsO48S3BAPPmyFY
	 nnyRsFwnk71orzX1zpP3LlD0Tf8pA8K5RcYDQTcqIumsd/6CdqFcsTf5DnbjScqfDJ
	 PQ6qNr3fAuUyA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A14AOA401036247
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 1 Nov 2026 12:10:24 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Sun, 1 Nov 2026 12:10:24 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Sun, 1 Nov 2026 12:10:24 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Sun, 1 Nov 2026 12:10:24 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "hi@shreyan.sh" <hi@shreyan.sh>, Jes Sorensen <Jes.Sorensen@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtl8xxxu: Enable AP mode for RTL8188EU
Thread-Topic: [PATCH] wifi: rtl8xxxu: Enable AP mode for RTL8188EU
Thread-Index: AQHdaEhpWqRVzw+aqkmzkIP8D0CnC7cYm7VA
Date: Sun, 1 Nov 2026 04:10:23 +0000
Message-ID: <81c3d0056a0849078715e0f0be074d1e@realtek.com>
References: <1381CC32-E73C-483E-8F64-27EDE6AE8E6E@shreyan.sh>
In-Reply-To: <1381CC32-E73C-483E-8F64-27EDE6AE8E6E@shreyan.sh>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

hi@shreyan.sh <hi@shreyan.sh> wrote:
> From 0a3cdd4c6cc416804e49c935516a22e854a87483 Mon Sep 17 00:00:00 2001
> From: Shreyansh Khajanchi <hi@shreyan.sh>
> Date: Fri, 30 Oct 2026 12:34:44 +0530
> Subject: [PATCH] wifi: rtl8xxxu: Enable AP mode for RTL8188EU
>=20
> The RTL8188EU shares the AP mode implementation in core.c with the
> other chips supported by this driver, so advertising
> NL80211_IFTYPE_AP is enough to make it usable as an access point.
>=20
> Set max_macid_num to 32 as well, so that max_ap_assoc_sta is
> initialised. The vendor driver defines NUM_STA as 32, and starts
> station MAC IDs at 2 because 0 and 1 are reserved for
> broadcast/multicast. This matches RTL8192CU, which also sets
> max_macid_num to 32.

Do you have a sniffer to have air capture to check beacon?

If so, please check TIM for unicast packets if station goes
sleepy, and TIM for broadcast/multicast packets (for example,
send a broadcast ARP by ping a non-existing IP).

>=20
> Tested with an RTL8188EUS (0bda:8179) on a Raspberry Pi Zero running
> 6.12 (armv6): hostapd serves a 2.4 GHz WPA2 network, clients associate
> and pass traffic.
>=20
> Signed-off-by: Shreyansh Khajanchi <hi@shreyan.sh>

I give my reviewed-by, but still want test results of TIM.

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>


