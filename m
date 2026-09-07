Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27800231A23;
	Mon,  7 Sep 2026 04:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788754811; cv=none; b=WFmley6/b9KxtLCmSHao0UDN0K8/PHW8aweHgsymIYb1JfsnufKGp+fx1F1KxoSa60U70EWgHzX/zzQKjIDvViRAChXspv5Nz9ATZWNQHGWlCVtxoOAlHx2KUsvC4vZ8Z8kuPNLQh84fUaA85ep605KAJaWIrN+T9ru5DFYktR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788754811; c=relaxed/simple;
	bh=2rsl+IYV+VUXtnGe5HjIkZsjEq+4jEk2yrcyww/b5PY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CyXbVkWf/lo3VqvzX59yg1QcELj5mDz1skZUvviAl9Mva+7XM0PvuZHaC1LDJVyBVdtJx9nAToYPWX36wdqyBtg8/cEv2nnq5g8ylpD/8hZyvMRALLD/5J0MaF+9Gj+qnstIAsnFKGVaWoqFL7gA4dRe/4wfrLvoqdOP1MjlAaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=fEVOsKDc; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="fEVOsKDc"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6874K48P02477569, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788754804; bh=gZQxxIroQCW41fkQSFmNF5m5zpzRECw7Xc/Jy4JusiE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=fEVOsKDcjJSGd7LNw3LnR+RgBN0yde9VDWGtaE3y+FDo0O2yvOivTcrfLLGs9HcgE
	 d6u/WsI0n8kXdnjzYhnptpVzAtdfz2tLCR/uPtr8/FL7c9Gz+fjxezxhs40EH0uklW
	 wIownfK/A5S2XIT9YSENtJCnOQwjJzvE7JYb3ZDqm3maeVSGty3gViMe3skiNypPFB
	 bTSSS9KwlwsMFvFuNfPTMSutbAFD5/ouLf4KsQU5cnjVZ6PwHSO/92KpJBKMeM3DW0
	 qbVSPmHlHpqcwVn0qcWZnn71VnveZKR6thYdJXChi+Xf1731qOuPcUVdvNsRSjHxBH
	 LAlqSuc552tXA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6874K48P02477569
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 7 Sep 2026 12:20:04 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 7 Sep 2026 12:20:05 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 7 Sep 2026 12:20:05 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Maxim Skokov <skokovmaksimevg@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw89: fix typos in comments, debug messages and
 struct field
Thread-Topic: [PATCH] wifi: rtw89: fix typos in comments, debug messages and
 struct field
Thread-Index: AQHdPLxoeqCUhqVOYE+KCJqv7rQpLLbCTFvg//+u7ICAAIsTYA==
Date: Mon, 7 Sep 2026 04:20:05 +0000
Message-ID: <8906397e40454e45b82c12ea272b3a9f@realtek.com>
References: <20260904222548.19732-1-skokovmaksimevg@gmail.com>
 <8094bfc474e34b2f826b9487e49bd601@realtek.com>
 <20260907040138.4321-1-skokovmaksimevg@gmail.com>
In-Reply-To: <20260907040138.4321-1-skokovmaksimevg@gmail.com>
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
> Ping-Ke Shih <pkshih@realtek.com> wrote:
> > Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> >
> > Add a tag like  Assisted-by: LLM codespell ?
> >
> > Just reply this mail, no need to resend v2.
>=20
> Yes, thanks, that is the right tag and it matches the format documented i=
n
> Documentation/process/coding-assistants.rst.  Please add:
>=20
> Assisted-by: LLM codespell
>=20

I think "LLM" should point out the model explicitly, such as
Claude:claude-opus-5, Codex:gpt-5.6-terra, ...


