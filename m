Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EA240DFB3;
	Mon, 30 Mar 2026 00:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774831877; cv=none; b=rfpsP4TNpv/tSQCgVFpImaAxXnmLrdyPHhp983RNaP11gTAN33ajfTHePVIoYSIBXRvzH3w/oQIhZLv5HtncHJ90sqYLexTQdpGwkwQGyfD2ENJTD7nJgjCO0tWTE3n1tlnkXvL3DQq/Qv3/utuhT2a5O33j7uT0qQafE1qXn6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774831877; c=relaxed/simple;
	bh=uIhNkmk34Cc7yrWrqQshaHmUfdwx3bc2CUf8IKD3GsM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RMY0AHt+GhQN28ug/DNJHHX7iFxsu7FIWjG2yTvir2+qal3SCT5KwRf/wLW8kTRhZjwyw0yj0/iwCohYmdPlsZAIjRcZ7sIa/wSEqF92GlH4d1sy1oK+HRLW7httYPCi18PvPEzWmwWUfzn7P8KrRdoZkdZbs2jVdKgVYfd9Yt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Xw8TPZCZ; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Xw8TPZCZ"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 62U0pC2I14187202, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1774831872; bh=8cTiFt00QE5ZnODyqgWa37na5VDfkPFpa5dkduoXlns=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Xw8TPZCZJNXSm7hPxvnVunhoJbTLhus9Kom5NE+zSRh3sEGRUs+JnQlty7aVSjgTK
	 c18vo17hy5E0T1FIkUIYLhpRZioWYATPVuBdjLsiL4nbdQNlnc1LeaPG7NNiouBQZ7
	 ykYB2prJocn2ThzVWpwHVtI3rRR5tWg72LMhnTK0DOm4GFBneqJh5lX3w6hsOShV0e
	 zH5QAE2OfRCXPysgMkqhtagCQnrGWkfzvaT2S6JcuI+wysOYv2mmQtb2BQ86wx9Udp
	 KJqkvNTzxBybxMQEPpV26VQAtF1ojes6jAT0t2d2BWb9Q01EyIUtF9rTQWXgSp1zBt
	 hk3BVmanvHxLA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 62U0pC2I14187202
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Mar 2026 08:51:12 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 30 Mar 2026 08:51:12 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::46e9:fab9:b2cf:c99b%10]) with mapi id
 15.02.1748.010; Mon, 30 Mar 2026 08:51:12 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Christos Longros <chris.longros@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw89: fix typo "frome" -> "from" in
 rx_freq_frome_ie
Thread-Topic: [PATCH] wifi: rtw89: fix typo "frome" -> "from" in
 rx_freq_frome_ie
Thread-Index: AQHcv1AWRe9PTWqYJ0udSkWQeRkZfbXGP9/g
Date: Mon, 30 Mar 2026 00:51:12 +0000
Message-ID: <9576b272b6964507b3632f04cd20eb3e@realtek.com>
References: <20260329074550.114787-1-chris.longros@gmail.com>
In-Reply-To: <20260329074550.114787-1-chris.longros@gmail.com>
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

Christos Longros <chris.longros@gmail.com> wrote:
> The chip_info field rx_freq_frome_ie (RX frequency from Information
> Element) has a typo.  The function that uses it is already spelled
> correctly: rtw89_core_update_rx_freq_from_ie.  Rename the field to
> match.
>=20
> Signed-off-by: Christos Longros <chris.longros@gmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>



