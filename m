Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5280233BBCD;
	Tue, 24 Mar 2026 08:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774341839; cv=none; b=goAiR/ClNM8ndpGzWnYR3hcuffTc54pF3iGc28nr06a9n1mGhgD55Pi+M2yB7cpbgB8YmxbKSXy/42Df+5oF7yMMYZn1JPV6vkSqlhFgSM2bX1mKnkRegMYviB6pa8QMQDnsNExMgDUh8Hcv1b8GtsyUUIN7bJsSiuUDPtt6MC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774341839; c=relaxed/simple;
	bh=Rb5CZtCPjbDIshXMhjMYdSsThf3g6EytpWixHKrcR0o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JLUiGyn52eSUeK0BYHMNgAByKwtnJFk/RvuYsv79SJqLzlN8EgjjPf51LEviG6XWOGUvoVJ0u/CKTQILrpbTFsvjNQq5KW8YTMacZ/97aqYBCX14fNoIt8ckhI6BnxWIJTUZ4bINQRU+2OvtQx8RVpmfbvQzZq+vJwc2SDkqEkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=cL7o9rr8; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="cL7o9rr8"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 62O8eCIO1751213, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1774341612; bh=IezQCVaqZWlndew01lWE/wjEE9A1Gs8V3V56SwEGZtQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=cL7o9rr8Vg/ddkNBaCCFmJgnVbV/G3wulbcmvfE8n92Ppza9i9mhRBYnQMe3U/hZB
	 To/7MF17VWcN28us9bSCtI7DCswBkGYQrZFLwLZ5X+/R7JNJco6jSd1q69Mua/Iuuk
	 SlgI8KBqmQQysLL+b+58+kjRnRYGrnd37OgXU06ArSQa+IBSnht7uWWN1Z4Ou5/M/3
	 xQo5GZbUHBW5xwwcVhOeWHyoojEhg9wGQG4cKuJ7n+duQGmeRYL9lHHfdp/RnDImJT
	 ahQ5TeHTSzoeCRnsCI7WlNl8e1cgsAJHsZ5kcFekTLDnBjCDJnFqlkKj606cGFA16p
	 6FQWVR1AM+8Uw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.21/5.94) with ESMTPS id 62O8eCIO1751213
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Mar 2026 16:40:12 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 24 Mar 2026 16:40:11 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 24 Mar 2026 16:40:10 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::4cbd:6c6c:b92b:3913]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::4cbd:6c6c:b92b:3913%10]) with mapi id
 15.02.1748.010; Tue, 24 Mar 2026 16:40:10 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Johan Hovold <johan@kernel.org>,
        "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: Jeff Johnson <jjohnson@kernel.org>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Brian Norris
	<briannorris@chromium.org>,
        Francesco Dolcini <francesco@dolcini.it>,
        "Felix
 Fietkau" <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee
	<ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang
	<sean.wang@mediatek.com>, Jakub Kicinski <kuba@kernel.org>,
        Stanislaw Gruszka
	<stf_xl@wp.pl>,
        Hin-Tak Leung <hintak.leung@gmail.com>,
        Jes Sorensen
	<Jes.Sorensen@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea
	<claudiu.beznea@tuxon.dev>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 00/18] wifi: drop redundant USB device references
Thread-Topic: [PATCH v2 00/18] wifi: drop redundant USB device references
Thread-Index: AQHcrUaQqpIAa3otvkWvbF5YVc2cqrW88IqAgACH0lA=
Date: Tue, 24 Mar 2026 08:40:10 +0000
Message-ID: <923278a6deae44f4bec8bc2ede1022a1@realtek.com>
References: <20260306085144.12064-1-johan@kernel.org>
 <acJL3c5J6sT59sjx@hovoldconsulting.com>
In-Reply-To: <acJL3c5J6sT59sjx@hovoldconsulting.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Johan,

Johan Hovold <johan@kernel.org> wrote:
> On Fri, Mar 06, 2026 at 09:51:26AM +0100, Johan Hovold wrote:
> > Driver core holds a reference to the USB interface and its parent USB
> > device while the interface is bound to a driver and there is no need to
> > take additional references unless the structures are needed after
> > disconnect.
> >
> > Drop redundant device references to reduce cargo culting, make it easie=
r
> > to spot drivers where an extra reference is needed, and reduce the risk
> > of memory leaks when drivers fail to release them.
>=20
> > Johan Hovold (18):
>=20
> >   wifi: mt76: drop redundant device reference
> >   wifi: mt76x0u: drop redundant device reference
> >   wifi: mt76x2u: drop redundant device reference
> >   wifi: mt76: mt792xu: drop redundant device reference
> >   wifi: mt7601u: drop redundant device reference
>=20
> All of these are now in linux-next except for the five Mediatek fixes.
>=20
> Could someone pick them up as well? Not sure which tree they'd usually
> go through.

  wifi: rtl818x: drop redundant device reference
  wifi: rtl8xxxu: drop redundant device reference
  wifi: rtw88: fix device leak on probe failure

Realtek WiFi got merged into my tree (not in linux-next yet), and I plan to
send pull-request to wireless tree before 7.1 merge window.=20

Ping-Ke

