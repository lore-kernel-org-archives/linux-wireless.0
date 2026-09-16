Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928AB3939B3
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 03:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789528480; cv=none; b=TFfnaSMsZwXOkJj2tUaSOO0p8dHdZgeHulTO/ia1VYaEUY5q9TEjjmDsE/9AFEpARv8Q/LP1pSHE73KtbGiVjZu7tRA6q5zmdWilrp2C7rGr6Ix+JpjAgVyUfmm+PldXxCY1yobDZvAPIHVYRJ2ok6yLVWNgGsg6AjZkkysyJqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789528480; c=relaxed/simple;
	bh=FrNxa5PTmT9z2ZkPcAYFci+r4NcdwB51TgT/tuTIZZM=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=CLiFixQhaZ7hnemPPZWKe9SnOrhH6u2G8OlU3z5V+0aCF3U6f9pUo1Opt0jldunJf1mivNMKDTHfuAz9b6/mTj16WZhOMsYG4JJPhKmTRG6dt9giXIvlf9NfEmBXhREn0Qpz1Q8uDcsy36q5UnU5B/Fl0qS8BRLYaFaQuuLFn0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=O+evZJ46; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="O+evZJ46"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G3ELZM02056053, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789528462; bh=XSBYJUglmJk+RvsfDLAtI/GRADTK/P2aUdUHBdh+vR0=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=O+evZJ46KM/q1aXSF0jy6vDJyBjBvSGEcQrko3uYD9+zntB2UXGKZrwDhyvfKwRsi
	 n1WsaPzVrBNb8487BmiloVR/Ul8KJKw9/DnaDhTNyYzoZA6V+5e1cfRVRXXkv1jCbD
	 tm3r5zNpAvnfEvhhsqqgGGtBbZjDyl2gJZaB1vzM+MosJ626e8lCdOGNcztJXR1vZN
	 ln3LRfo7wR9OHDvQve0m9qJjCnPwwUAqS2plrEBvz8Nf1a5H1CM0ZE5YyESVK38cfC
	 rhdXlxn8u98i8ZTnsm6MNsVX67aM6P9aEHvhdjzxoISJEmrtVwEvgh8dt15qylu6TP
	 zG+3T9QYBidjg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G3ELZM02056053
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 11:14:22 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 11:14:20 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 11:14:19 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] wifi: rtw89: avoid iter_keys_rcu() where not needed
In-Reply-To: <20260908192948.8a5318efb4df.I56408c1ff0b5c3bcb19a1054858076443fcae3b3@changeid>
References: <20260908192948.8a5318efb4df.I56408c1ff0b5c3bcb19a1054858076443fcae3b3@changeid>
Message-ID: <d49c65f7-1382-4e3c-9274-7caed65dbd2c@RTKEXHMBS06.realtek.com.tw>
Date: Wed, 16 Sep 2026 11:14:19 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Johannes Berg <johannes@sipsolutions.net> wrote:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> All of this code already holds the wiphy mutex, so none
> needs the _rcu() variant. Simplify the code.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

5bfbd61717c6 wifi: rtw89: avoid iter_keys_rcu() where not needed

---
https://github.com/pkshih/rtw.git

