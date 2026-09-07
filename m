Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391B5136351;
	Mon,  7 Sep 2026 00:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788742418; cv=none; b=a0F0+kKB5UuMNWAu3JoxhFGKWfexB0zcZ0TEyD0jT660Al64vz/7gcKZ7JtgNLYDmBIutKeocysTbI/9ZkkHgK+S9gzXmW+i6e2KXxf0S8Ahux4dtlAC2oOaGhbzGvUhkUMXhN6sr/UcrtEGC/EPKyLrg7KbmU2dagvRe7P76co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788742418; c=relaxed/simple;
	bh=8oerNDadBeL5/DMlpJ6zVKmqUvuHWphCdDja55UIutY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mJ1A+EyUjNkX/bz2KyId8wxZl396SmyIekFOBcgrL1dqRvK6sAl3Awcsg0eBtazSKQz9N20qgWphMnxXNCrh/WBLz9Uwcx5P18UagtsZzceoLoxaOmdnM5TvFDhIU+xqaAwY7i11oPZ4ZEn8iUmnarswQ6OlC5yZREhFUUS1ECc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=VjqAjtZA; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="VjqAjtZA"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6870rW3x92353040, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788742412; bh=VXNvg6DFW62+TDnBK7kaCLKyc1Lj68wdQzE/9+J7o6E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=VjqAjtZACeIJVZ4VeRQVK0NIRG7agc735voKhdvTfFvwRlTnAKRAu4gdln8Gu/E0I
	 WmrPX6qjxmg9L5b+l32c3EPOFj/578x7+8PigR8x4JVzLqXDR+T1xrY1Ibe8edHA0A
	 K50eSrZvw0nePny01eXM1TEDQr6vQLLQTbA5TjNb1FmxwDo0GEayPf8W2gCxKMJtBi
	 10WWdRoUYPzE9K1bAceVTj6HOUCmyab5chfCexQLKXIs68bQT7fhkokIQY3UJjsmWy
	 nLGrseQ+gr3Ry/z9gRQyD+NEaqX6Ivm826Uq09iU6yyQdYnfAwkYTHUHPg/3TquJfH
	 UX9Ur+jO1jp8Q==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6870rW3x92353040
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 7 Sep 2026 08:53:32 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 7 Sep 2026 08:53:33 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 7 Sep 2026 08:53:33 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Maxim Skokov <skokovmaksimevg@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw89: fix typos in comments, debug messages and
 struct field
Thread-Topic: [PATCH] wifi: rtw89: fix typos in comments, debug messages and
 struct field
Thread-Index: AQHdPLxoeqCUhqVOYE+KCJqv7rQpLLbCTFvg
Date: Mon, 7 Sep 2026 00:53:33 +0000
Message-ID: <8094bfc474e34b2f826b9487e49bd601@realtek.com>
References: <20260904222548.19732-1-skokovmaksimevg@gmail.com>
In-Reply-To: <20260904222548.19732-1-skokovmaksimevg@gmail.com>
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

Maxim Skokov <skokovmaksimevg@gmail.com> wrote:
> Correct several misspellings found by codespell:
>=20
>   moniter   -> monitor     (struct rtw89_btc_wl_role_info_bpos field)
>   serach    -> search      (comment)
>   Unsupport -> Unsupported (error message)
>   nofity    -> notify      (comment)
>   updat     -> update      (debug message)
>   lagacy    -> legacy      (comment)
>=20
> The renamed struct field has no users, so no further changes are
> needed. No functional changes.
>=20
> Signed-off-by: Maxim Skokov <skokovmaksimevg@gmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


> ---
>=20
> Notes:
>     Found with codespell. Patch prepared with AI assistance; all changes =
reviewed by me.

Add a tag like  Assisted-by: LLM codespell ?

Just reply this mail, no need to resend v2.=20

