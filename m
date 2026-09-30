Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F81F547059
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 02:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790734676; cv=none; b=JdxktyMpaxX67aEfVpB5U5OBgXXLBmlucaQucJQHx3w0BtQdHZVu5cUcpoXV1/k4qb7qo210JQSzs9C6pP1R+DBTBMpliepLIdZBU8CsQ9hwpU9PCMOBLGL+KgWCQNGOE3p8/adYA4yzpgbnevT4EJ6LO87QYbxzpTB3678CVFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790734676; c=relaxed/simple;
	bh=/npLcIKGGHLFw+nZ0DjKVt0Hk5HbsSIBb6yRgr1AYSQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=FrtN8CBvqChKfmKjzvzNCy6ZyXOADHCfWLvjETP94AhiVElFukrzLP24RtXDEoUXV6YaxiBLWxTWxHcqHVw17mpDTxiQLYQbZYPp8z+JMnak90Nf6v4zgdCXPbTc8kBs/wMTFBKMEzCSA75Pvn0e25hXP++ciUx0CjPeeA0Jfd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ASpqSACc; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ASpqSACc"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68U2Hqf861779609, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790734673; bh=qtpjx65Qyjv2cm+gUYmo8mj3ZQGBp7xaOqu60JeDhbU=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=ASpqSACcYZvcme3BQ3eZb+aHYBBJrbmYEWznWrIy637jiGHGcAIUTKTUadClRtWHR
	 ifo20qKpNGsX18A9I8jwoNi+RiiAnR57l/79HOLGLFI/UXyfufvk1qR2JiHwUmUIBl
	 PD6pGjX3IE3YNwN74D3WpI5Q44A/i7kXvQGoYYutOHLeomllMDSQIeB9oRis0kBYZS
	 bMG6MXV/QUj6HrwZk4x4pk7jVuNZC+KB3kr1j8PHcK2A770ERpmg79zo9C/pxeZWGf
	 trMpNJJPD7wq/Zl2vVXVQXQ6M99CgArQffgK54JQgPDGv8Y1d6s2W5bdROZ84SdXqN
	 Y8fRWrA+S5iSQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68U2Hqf861779609
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 10:17:53 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 10:17:52 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 10:17:51 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <kevin_yang@realtek.com>
Subject: Re: [PATCH rtw-next 1/3] wifi: rtw89: ser: reset map of associated links when L2 SER
In-Reply-To: <20260923072741.54118-2-pkshih@realtek.com>
References: <20260923072741.54118-1-pkshih@realtek.com> <20260923072741.54118-2-pkshih@realtek.com>
Message-ID: <3f7f8460-a662-43b0-8dc2-e2f7f7a5b271@RTKEXHMBS06.realtek.com.tw>
Date: Wed, 30 Sep 2026 10:17:51 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Zong-Zhe Yang <kevin_yang@realtek.com>
> 
> There is a map used to record the associated links by MAC ID, but L2 SER
> (system error recovery) will invoke ieee80211_restart_hw to reset things.
> After ieee80211_restart_hw, the associated links will re-configure, but
> each associated link might not use the same MAC ID as the original one.
> If an associated link doesn't and the old MAC ID is not re-used, the map
> keeps the old pair of old MAC ID and it. And then, if somehow HW fills a
> wrong MAC ID, e.g. the old MAC ID above, in RX, SW will still obtain the
> associated link. Once the one is really disconnected, the memory will be
> freed and this case will cause problems.
> 
> So, reset entire map of associated links before ieee80211_restart_hw call.
> 
> Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

3 patch(es) applied to rtw-next branch of rtw.git, thanks.

533c404af22c wifi: rtw89: ser: reset map of associated links when L2 SER
39884f761fe6 wifi: rtw89: wow: check AOAC report C2H event length
cab0aec92072 wifi: rtw89: wow: check AOAC report key index

---
https://github.com/pkshih/rtw.git

