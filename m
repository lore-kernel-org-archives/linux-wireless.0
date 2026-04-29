Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB418154425
	for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2026 05:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777441404; cv=none; b=lgFS6vlj4AC/fbxH99JaYVS46cju2aCYrQydIHcB6hK0/Wo3ohtfZf2UWUIgrDEYu2JurN6IXy93CT88T/GA53EiJ/mnJISxjHtEHVd8Qub6xETXPl8JVJXCKdaA8+k1LU8Mkd4eoskyOsOG9bIGzrqQehWM6VvnBcrs/RYUxw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777441404; c=relaxed/simple;
	bh=X2m8AtVHw+6LwIZXeXliVetGhTXsdgrE8KolQq6e2E4=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=F6U/XNLJnS63jeW1uRU9qBHDnbQNu8X5W1hQyKe0LHGYF262VBFesXMAc+rgPVJUdT9s2I98b+ZA/b13EJt3Bqwz1F3Nv7oSNA2JWtg255K7MnPKRKC+Z/YtqO4JM4KwB6bEXFRpMsJkSy0nHFzWj7WEZeXu5Dm6KHpThgDJ/JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=C28nTMfw; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="C28nTMfw"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 63T5h2mN51018709, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1777441382; bh=QbSIAmLZ1TGbIJc/MrOG7ALlnpR8yPv2nEFlj/k4V5E=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=C28nTMfwbSXMedZLZUVQ1cyeuMkDjkc04pJzl6YPlK+4vNk2VC7b4GrHFbzXA/Fl7
	 R4Mpys41ptw/sBPWOUCGXMcQMxFPYCSGJAtYC8X0PAm8P9hQGJ78f9U+TxxtNOArcP
	 GPgD6MSUBQAsHgB0JW+LrcNL8lx9f9ef+jL8AM0aKEg92YYsg8jmW31PAhbQfmYvaj
	 UWQ0N1chTBGj5DlQ1At83Nlhrc3m3K9ewYDv6sA+81WU3btYSdpqz+eyJamCeBBEtv
	 Omf7ZMAy9RYK9+pt/8hVfdJhvvK9d7x29aabWz/jdEt0MUyqjHCqjjYRQXz0Wz7Io6
	 FiscygRuqqZ5Q==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.27/5.94) with ESMTPS id 63T5h2mN51018709
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Apr 2026 13:43:02 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 29 Apr 2026 13:43:03 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Wed, 29 Apr 2026 13:43:03 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Tristan Madani <tristmd@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>,
        Tristan Madani
	<tristan@talencesecurity.com>
Subject: Re: [PATCH v3] wifi: rtw89: add bounds check on firmware mac_id in link lookup
In-Reply-To: <20260421111442.3395411-1-tristmd@gmail.com>
References: <20260421111442.3395411-1-tristmd@gmail.com>
Message-ID: <d2637877-5967-49ca-a945-4738c2a75516@RTKEXHMBS03.realtek.com.tw>
Date: Wed, 29 Apr 2026 13:43:03 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Tristan Madani <tristmd@gmail.com> wrote:

> From: Tristan Madani <tristan@talencesecurity.com>
> 
> The mac_id field in RX descriptors is 8 bits wide (0-255), but
> assoc_link_on_macid[] has only RTW89_MAX_MAC_ID_NUM (128) entries.
> While the driver currently assigns mac_id values below 128, the
> descriptor value comes from firmware and is not validated before use
> as an array index. Add a defensive bounds check in
> rtw89_assoc_link_rcu_dereference() to guard against out-of-range
> firmware values.
> 
> Fixes: 144c6cd24b35 ("wifi: rtw89: 8922a: configure AP_LINK_PS if FW supports")
> Signed-off-by: Tristan Madani <tristan@talencesecurity.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

6d88244bb129 wifi: rtw89: add bounds check on firmware mac_id in link lookup

---
https://github.com/pkshih/rtw.git

