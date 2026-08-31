Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE586374183
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 02:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788143290; cv=none; b=qT/gqJD7rJGyK9U5w2bIlBgKmzA58RlhEd/TP7dJyB6RloSMT9me3a5peqkDNgnMdmhWoxvCT/35JeSGfTtnd8WHCoYDuRH2BU2ea32+ABLyD72dEhAXwsgEzrnbz+MmO4HVEqQQp+9LiKzvYYugGD3qQrhnMNelUwTDq43q7Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788143290; c=relaxed/simple;
	bh=AsCszcVTP90WA2hIHrY8GfFTL1AtLkQ2uSVLayoZ6BI=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rSkr7Hj/4A++/4zJpkXNiUuJ2erYhOstybVHA6oZ8vUAZJHasHjfQ3ouhpEobvVNDdBSeCIoiSxEF88uipO+eVMLSRH/roC9oolRfH6UmvrXtVggr91HkVrNXG3x3//YNYJW5IZ7/EvY0bL2sIBDvKkRIopdhqS6kihgpPRfRt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=mc50a5Ju; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="mc50a5Ju"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67V2RltlE373257, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788143268; bh=AsCszcVTP90WA2hIHrY8GfFTL1AtLkQ2uSVLayoZ6BI=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=mc50a5Juf2eqzpCWcZnTM3OiGU2MlX85TTkwEXBTMocbg24/LKEkBn3xurPX73nNx
	 JJadzCflX7P+LE9lo5BShQ43gSEDDSahqY+N6lHgMhtF9cZdK7ee5Ix2WoW9T6brWK
	 +D9yE2pCp1vbMzubLYIi4Xn1+TzlCCDxZ71c8xDdBzeLtWOe94pgMm9joD1HauB//I
	 idAR7ft/G6CH9bx8cMUg9t4g8GVHK4ktdIwY1ZN95CHznvVrsqaaCKiR/OdME6cfBU
	 PUYJ6qH9wa5PasBEURQ8TPiUdtu0RCZzDVTZgy69kfO9EZCESqtICkrsS4zQ34gaxJ
	 IcFK1GHC1aRiQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67V2RltlE373257
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 31 Aug 2026 10:27:47 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 31 Aug 2026 10:27:47 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 31 Aug 2026 10:27:47 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "nick@venenga.com" <nick@venenga.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next] wifi: rtw89: add ASUS BE93
Thread-Topic: [PATCH rtw-next] wifi: rtw89: add ASUS BE93
Thread-Index: AQHdN8ccJ3n3oYaKf0+0LBdQO30Ysra3cCCA
Date: Mon, 31 Aug 2026 02:27:47 +0000
Message-ID: <f2715f2bb895467baa47f1062e5d9071@realtek.com>
References: <010f01a04dda7149-4e2628cf-4fc0-40f1-bd49-1c94cceccdfb-000000@us-east-2.amazonses.com>
In-Reply-To: <010f01a04dda7149-4e2628cf-4fc0-40f1-bd49-1c94cceccdfb-000000@us-east-2.amazonses.com>
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

nick@venenga.com <nick@venenga.com> wrote:
> From: Nick Venenga <nick@venenga.com>
>=20
> ASUS USB-BE93 Mini USB-C adapter
> Originally added and tested here https://github.com/morrownr/rtw89/pull/1=
21
>=20
> Signed-off-by: Nick Venenga <nick@venenga.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

To be clear this is RTL8922AU, I'd change subject to

wifi: rtw89: 8922au: add ASUS BE93

