Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B734F322A1C;
	Thu, 13 Aug 2026 05:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786600471; cv=none; b=cfap1siveRxOxhCyMC3SykyTmS2poDVVTxjhPRpGmdtDNM9rvqwR94oPrr2hf7d6W0O+E9d6d16w8bABMpMmNC7INBAE+8yK/A1+8jtMWrgKfWHVaErL8bHahON4WR2HA+4UVxaSYJuE8+ceyKz9XMlIa4Tx1JUfLJ9Rs/QXKNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786600471; c=relaxed/simple;
	bh=hw09XuBU8gKu+4yCoNGT5z/LjpFaJGHOgY835c5X19s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=o7UHeGu4Mz/duT7zCmGHUjA7utgC7XOhkV+FNLxiQ3l9v2cVi96VoFcQZ3cLDYGv8RFuc/WqPPXU+oyFa4x5QzAti5CsigUA/5VnHWJXk9u4bSKaF+tE+47D15uFE9dLAHme/gshwNw0Ru70FzHWG9wJRG/rb54EDLvIEudwSfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ZSdCTk2S; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ZSdCTk2S"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67D5sPCG1040276, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786600465; bh=v0eb4ES9EaRszp3SqAO/SDXUpud2y3Sob8TmoXK8Aak=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=ZSdCTk2SthTaq6y847PBSYYJXqtQHIfANUC9anU0BiseO3sb79kMqz5uNfx8NgTIy
	 j1jUl7hP1CzZhVQgND9ujETNjRzMK4kdB/ktaD6BP7H7mdEb2Il0+vslfnROYBIElx
	 GEpHZ5FhrxF0DQ5YmgpWo9aqtIuSaLPfFxqsfElVnK1d3LJ48TVBODRS5rm4cms/KV
	 quVc+7xXwuGA4DyXj/rKDgCQRPFdddEU1pY2dFDKnpvHl+Jgr/cRdvwQkoleKoUKFt
	 NQcepcjEY9776P8klrIb+Tu/+JGsBQlBsRIKZhlhbZS/KTeB73P0d9xcGDumtBlGgf
	 G2gAX/RRda06Q==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67D5sPCG1040276
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 13 Aug 2026 13:54:25 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 13 Aug 2026 13:54:25 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Thu, 13 Aug 2026 13:54:25 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Arsenii Pashchenko <ulijg308@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH wireless-next v2 0/4] wifi: rtw88: rtw8822c: refactor DAC
 IQ calibration to s32
Thread-Topic: [PATCH wireless-next v2 0/4] wifi: rtw88: rtw8822c: refactor DAC
 IQ calibration to s32
Thread-Index: AQHdKudPkAZdnwCNNkWKGmmluBiRRrabejRA
Date: Thu, 13 Aug 2026 05:54:25 +0000
Message-ID: <18267f0f1bfe435883817276dc540ff4@realtek.com>
References: <cover.1786599645.git.ulijg308@gmail.com>
In-Reply-To: <cover.1786599645.git.ulijg308@gmail.com>
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

>  - Fixed missing target tree name in the subject prefix (switched to wire=
less-next).

The correct tree tag is rtw-next. https://github.com/pkshih/rtw.git


