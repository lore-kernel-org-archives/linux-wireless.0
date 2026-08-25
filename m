Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7FD2F12CE;
	Tue, 25 Aug 2026 07:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787644019; cv=none; b=RdfkDkrBoby9dMHNkU1HKHeYEb6lKNvGadpQgOfj8ydL+Sx+6mQnDBJ4Ku8tfRu9mpy6wU8YJJ1jJYm3zaB53TxguegjrS1WhtYBTuTDIEhxvykFqU/M86FLPaKYd0pW3ZqZN2o9zxxmCcHLWHdfwr96YYA9CZMgQnUrD37aUwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787644019; c=relaxed/simple;
	bh=pkIUPtAH5+Mw3Robj37NwRuACN33LqIOtoDTjp/YI2Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Wq3RXm1Di6OmhodG0BJkXT+960VJYm7902dBpxfIag2tfry1Jv+ZKY9ACyZGz3IYAZr++OzAbCn3WsfsD1YaXrlGQrzILsH67fzoHijGhnpGjvVSVJvOJkTkD166UosSYqEDTkfZgKLHongd8t5EqE4L+oQ0so2R6fen9ldMbQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=h55ck8DB; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="h55ck8DB"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67P7ksmZ73613723, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787644014; bh=cIfAFMhqO26kp3jU7N0ZsAWLVV6Jj1k6Q1Qbx9ecEqA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=h55ck8DBtR6U/Eg0FlN6do++tZ5NLRIfUQcHS04BzmHddyyOH1x9CVemHgU1Ul84c
	 iCrNjXh1/edZlnsneJptClzGcqsxgFpfWtNdEgVaWhFRJZac6umnjReo8iI8Y/aDrX
	 tnkntPnfgi4EhDedsN0N2uuOMhyz3RTI0v2V+BE+vgYrCXEFhItc63ffBQERFu0ffm
	 ziX2hDOiyy/923vNciGh76poc5ibcXYaTLxTATN3js49auepVaHszE8F2I1OXSYQvJ
	 W2gUAqwG//bWFUpBRLXD1oJnXp9o6fGitUsU5CevNDGUMyoXZzIwENqWEheL+pum+t
	 OrO4+INkE0wxw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67P7ksmZ73613723
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 25 Aug 2026 15:46:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 15:46:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 15:46:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Tue, 25 Aug 2026 15:46:54 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Arsenii Pashchenko <ulijg308@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v6 0/3] wifi: rtw88: rtw8822c: refactor DAC IQ
 calibration to s32
Thread-Topic: [PATCH rtw-next v6 0/3] wifi: rtw88: rtw8822c: refactor DAC IQ
 calibration to s32
Thread-Index: AQHdLJn7EIEsdGNue0GE5SAf2uTqwLaucZow
Date: Tue, 25 Aug 2026 07:46:54 +0000
Message-ID: <2d54066757df4755967f091c0aa441f8@realtek.com>
References: <cover.1786784750.git.ulijg308@gmail.com>
In-Reply-To: <cover.1786784750.git.ulijg308@gmail.com>
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

Arsenii Pashchenko <ulijg308@gmail.com> wrote:
> Testing:
> - Note: The author does not possess the actual rtw8822c hardware. Actual
>   throughput and runtime performance verification is left to the vendor
>   or community testers.

As I mentioned earlier, we need testing on real hardware, and then I can
merge it. But you can continue to update your patchset.

Ping-Ke

