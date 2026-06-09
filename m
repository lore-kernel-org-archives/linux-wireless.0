Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A15724BD03;
	Tue,  9 Jun 2026 00:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780965885; cv=none; b=EGdmkirnozNPHEgZms9J1XrR5MVLRFHGfqN8xG/nN847DuzZ2ByCfXVxxKL8dnMVQ8RvwciHLmDJ5+T46LI010wSAA1FnDiJ1bq80MKzDanx0rCCAd17Pu5r4htfh/fEhy3zpUbcnDlwog8ny426xLXAuLrx4JbADovxrBcuyO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780965885; c=relaxed/simple;
	bh=OMOnNf67dhajL95LBndmKkwgnUOwdYU9XDWpBEw6ZcY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UHgPJarW5k3vZXvYM01ShNmNssKA9Jkxl7nFRXFsqv+BhEW5TN/ZH8J6xurdGhW+dCsAahTavmo6hYKIibUtj8di6MUytMTzNgf7wL7rygR94kLmyWGFRosS+f3T3pnc3aZUeDBQayRlPBR3Pbkek+s6RExDB/qByaqahMKRloQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=iX7VOQNI; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="iX7VOQNI"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6590icYG34019531, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1780965879; bh=OMOnNf67dhajL95LBndmKkwgnUOwdYU9XDWpBEw6ZcY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=iX7VOQNIAftuMlYCQBw19C8m7fxpsSsKsWbh49TCnOzVNOJO54NIzEHEAnQ9U7EBo
	 dXGAbuM1+3pofuGQfNbmUPbkvmI5JERhuYQs6f3UbI7J8+j/0U4ZlXIfsr68fJiOw+
	 9t0qlfRiKKsgsRMOfuBFHlZM+eUmrZI21RvtmPBfrAeMg/a7OMvZHALWt3vVf1E6hI
	 HzfSvLwewICm6e40v9voZ6k+LfuqZ4vSM3T+338pm6n5+5mLln1wU7742IUc9CsWGb
	 MTQpPpzBF88pbmAUHt78h/6t7sboo2ITnpihKsFqghX7EgpdvmDnRRQF6odPfa9/Rb
	 TbgJ4+WCieHUg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6590icYG34019531
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 9 Jun 2026 08:44:38 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Jun 2026 08:44:39 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Jun 2026 08:44:39 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Tue, 9 Jun 2026 08:44:39 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Dan Carpenter <error27@gmail.com>, Damon Chen <damon.chen@realtek.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH next] wifi: rtw89: debug: fix off by on in
 rtw89_ppdu_str()
Thread-Topic: [PATCH next] wifi: rtw89: debug: fix off by on in
 rtw89_ppdu_str()
Thread-Index: AQHc90NBELWPFUshn0eHlWtcYb9z6LY1Y0Tw
Date: Tue, 9 Jun 2026 00:44:38 +0000
Message-ID: <68c89cedd8d746c7b694a5ec98064d15@realtek.com>
References: <aia25i0ds3B6QF6c@stanley.mountain>
In-Reply-To: <aia25i0ds3B6QF6c@stanley.mountain>
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

Dan Carpenter <error27@gmail.com> wrote:
> This > comparison should be >=3D to avoid an out of bounds access.
>=20
> Fixes: 419ed7f4a053 ("wifi: rtw89: debug: extend bb_info with TX status a=
nd PER")
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Thanks for the finding.=20

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


