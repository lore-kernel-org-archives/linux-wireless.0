Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84A625B09E;
	Tue, 15 Sep 2026 00:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789432823; cv=none; b=q9Tw/qp4++UyQeMwrvsTCMSfLPq/skXdpEilexB47wqxpPww9pev5t1d7LSLhQ67T8/RxIk/FEa/EXnoHcHYaQK2DCSs1/iy8kYrJ9fVmQHjVdO/O7TzM5q1FJMk8vh19W+7Sa6gG/ypPllq4MM3CCkezwxITMOs5YeA9XGuZPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789432823; c=relaxed/simple;
	bh=ha7+AGq4swCCGi8az5HgRtPQvJkkNcZt9tTYI2z9AOc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SMAw0LSsT2XAJkbEORE5hpl+W9i1IfIUoDCnjS9A0LoAWfjvj+5wE/c/1KKfej72YAI57HNrm9+FLbz0c3HzIAd0KTHHvOq3tMo/ZlKR+AvGqFfq/yTCvyxTiX0ND5wk2WRloq6SWAhy7fD4/3bpcXF6AT/EHmLDYlkQNp0ZPg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=HRsGnHvK; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="HRsGnHvK"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68F0eBYr91150311, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789432811; bh=YDKgvmbQpYuceRlkPyqN48eYGAdVzrAI86Rqre6/b2g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=HRsGnHvKQeijs1Y+BU6VTPr4pT0ZQADRoE+nTRQl0Evp5YYnoPUklRm52WbZcW9KY
	 QGD9GWfjr7GUKmmY12R2D/byeMrtgDC/TpP7aQP3cqj6GTUrmkzzvqgB0XrEoW78fH
	 DZM5gHFQ4uzeWP7Y6NQdzz4z+I36fYYXUHIWe/GuoUNTuWlz3+77m+K+nbluOdhfgi
	 4FbC9wx2zT70TGL9vToj459x192emXk/1UUjRFFUt6YCEeImTR9533f9Raw6OebHgm
	 seOd9OWU6/itZRBxHETw8YCExZ2YA+Qh57Q7AIRbqTmdXt9gNedhflKQ/r03f1OvjI
	 4TB4rHzvj7Meg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68F0eBYr91150311
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 15 Sep 2026 08:40:11 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 15 Sep 2026 08:40:11 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 15 Sep 2026 08:40:11 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Maxim Skokov <skokovmaksimevg@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: rtw89: WOW_CPUIO_RX_CTRL is never answered on RTL8851B
Thread-Topic: rtw89: WOW_CPUIO_RX_CTRL is never answered on RTL8851B
Thread-Index: AQHdQu5+p1mtl9gOz0eDp/HSGCWOaLbNt3lA
Date: Tue, 15 Sep 2026 00:40:11 +0000
Message-ID: <95af665973144da2b527b9d6d445a6ca@realtek.com>
References: <20260912193939.5565-1-skokovmaksimevg@gmail.com>
In-Reply-To: <20260912193939.5565-1-skokovmaksimevg@gmail.com>
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
>=20
> but rtw89_fw_feat_list only carries
>=20
>         __CFG_FW_FEAT(RTL8852A, lt, 0, 13, 37, 0, NO_WOW_CPU_IO_RX),
>         __CFG_FW_FEAT(RTL8852B, lt, 0, 29, 30, 0, NO_WOW_CPU_IO_RX),
>=20
> and nothing for RTL8851B.

I'll send a patch to add this:

__CFG_FW_FEAT(RTL8851B, lt, 0, 29, 57, 0, NO_WOW_CPU_IO_RX),

>=20
> One unrelated note from the same trace: "Unknown wakeup reason 0" is not
> a failed AoAC read. AOAC_RPT_1 and AOAC_RPT_2 both succeed, and
> rtw89_wow_show_wakeup_reason() reads the reason straight from
> wow_reason_reg, which holds 0 because the card was not the wake source
> here, the RTC alarm was. The switch has no case for that and falls
> through to the warning.

I'll check this internally if it is possible to avoid the "reason 0"=20
message.=20


