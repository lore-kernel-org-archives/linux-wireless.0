Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792635906;
	b=LEZO/t5z+xgY8IudGje+o/OzTmYM/Lr6INduQpOHPVSxUxHCj/Gn2bDao9s32EQeReyE
	 VOzqr3uPN/vWwaaM5d9ApU2ma1FhPddDHHImrob44dQu44t6WdD/pzP4jdCtJ8+zK4EYs
	 t+BKwf0BtnrjunKXEDMncXX4qAZfkbbY2U38EUpcTtcJbpof0djgZHCmSSy2ecYEFqihp
	 GCUXjTxe2NrRZmC8O9vJNWJ/hXO04eQcqVfa++cLDYbcZ2UBLpwrdUKLKFWygWNu6C1S4
	 Ij8eCDke5cQglcsWSsB7/q+DlPKMnnuw4KODfP1yWeqbZDyISXuLx3TC+wr8QQ9uDVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792635906;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=AYLwfa7nt8RqVoStesXznFTvEO2nsHJc4ALfOcelwW8=;
	b=G1AeZn6joLMHWvyS0RtcQI7aHlK0Ug3uINU+LIw8A4ob7n3RN6XRqa1TyxpObBUugnhC
	 z3jgOkcAFGh7OhklqeqyK++N7FdWnv7czQbNrPM7Gc/u6rw5UV1nrp8fVsmvDDREkpv2L
	 iWuKS6dHp85tpRQ1pNdzF4e6FhIuX5f7DEPIJPIrOUsccRJVGrBxKpfqOfUrmUy8xwBCY
	 Qo111zUJctc/ubrHChHddM1GwwdGqkzovv6BXsSaUwiD6oFuUIXvXvjOshGNuwI6KD1XD
	 kXAQqVsCxoQGKbbDgJoKeGhw0gIqulYjD5rxzVsU00XjALLtNl4Fqrbmorj/mkBYFbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=MUvRVlQz;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4AB606A319
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 02:25:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC4AB606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=MUvRVlQz
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69M2OxlB6477221, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792635899; bh=AYLwfa7nt8RqVoStesXznFTvEO2nsHJc4ALfOcelwW8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=MUvRVlQz/p1l7cJNr15cYnKf5ZiQmqI1JR5lkzmmcyiHZsbfu+fxRj3bQ3Z3zLNOu
	 xjmLkOXv2m8DLorPN7p+PaJBLdNHChcfnj+72SQsN6wGjeHG2xeckwDlayQV37vy9o
	 Gy3G5ByU1RhhkywZ+n9y9Tu60iEssM2XKs1Aksmb1vlxK0Xq6RyXy2gTMW3EauLgH0
	 7RJsIj09ordC8BgneoX3XruFqzS4rq9ckt8lfO3gK8gC6N08wpAzGZHYJsYpUdIhmD
	 kml7qFpVGTp1q4nwnx1gN+m8hmiYy4WLcXjrdyPw3iFcDpm63oX59/OZH7jH/jiSiu
	 Hoim+iaQlzN0g==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69M2OxlB6477221
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 22 Oct 2026 10:24:59 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 10:24:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Thu, 22 Oct 2026 10:24:58 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2 2/2] wifi: rtw88: sdio: limit the high queue
 to DTIM delivery
Thread-Topic: [PATCH rtw-next v2 2/2] wifi: rtw88: sdio: limit the high queue
 to DTIM delivery
Thread-Index: AQHdYVnJG9JyRljXv0iDmLu7bg5MyrcI1STQ
Date: Thu, 22 Oct 2026 02:24:58 +0000
Message-ID: <ea2137c603f146738f8db100e905060a@realtek.com>
References: <20261021124318.15993-1-luka.gejak@linux.dev>
 <20261021124318.15993-2-luka.gejak@linux.dev>
In-Reply-To: <20261021124318.15993-2-luka.gejak@linux.dev>
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

Luka Gejak <luka.gejak@linux.dev> wrote:
> In AP mode every broadcast and multicast (bmc) frame is sent through the
> high queue, which the hardware only drains after a DTIM beacon. Only a
> few frames leave per DTIM, so steady multicast traffic builds a backlog
> that holds the TX pages the other queues need. Unicast traffic then
> stalls for seconds and clients can no longer renew their DHCP lease.
>=20
> USB had the same problem and was fixed by commit c710c7c2e038 ("wifi:
> rtw88: usb: route bmc frames via the high queue only for DTIM delivery")
> and the two commits that followed it. Use the same rule for SDIO. A bmc
> frame goes to the high queue only when mac80211 asks for DTIM delivery
> because a station is dozing, the frame is ARP, EAPOL or DHCP, and the
> budget allows it. All other bmc frames go out on their access category
> queue.

I'd remove second paragraph since it just describes the patch 1/2 does.=20

>=20
> Tested on RTL8723BS with an ath9k client.
>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>




