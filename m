Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31203D7D69
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 20:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784838170; cv=none; b=Qq40Y3PTUkRODq27B4bTtPsRH9odo2/ftAdWs6vIT3xo1Azt8VJ0eFu98L1TnnRM6Gnzwu2IN5zYQ2kVs894y+zMi2vGarNeoBXmBJgcjdImQs2qFeAJoztpU6L3WWEZKlp5/l+UEYrhIzlQQEdcYBFry5YjXGzYtlJ7JWmW9e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784838170; c=relaxed/simple;
	bh=V1hSLIbjJIafMetq/iu7GVV4opdCYHpidy44iIwNch8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SffzjZ2oM+fF9naRB+9nKssgmsfQScvTnTFMDroEIf8b/ztVOJtoqp8hvGu2sjjNH7+7A0GbNDHLRmSEmq8yk1xgg6XbfoyHpT4glB55oWkxaZPJWihkZjE+Ailx3xMfuXoK1VooPJPuyNZuPyHjWomtm7uFJyjI4Q4Xjok3H2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TilODulu; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TilODulu"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38ea87caafeso898259a91.3
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 13:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784838168; x=1785442968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RH1XbIQ8E22rKZgx9gpnUFs1WJC3giaIlWrSChX8/Ts=;
        b=TilODulueoL/PJBkHi8xBYdEPsnMCNT50kBf3ENkkPC/+yKfM74WUpIqb1so5fSe0L
         BfflNomGSL0KdJf7B3EvrnuQi4pL02NW2J/x4ONUqibxRoMEoj8QaIgG2qV3VAfdcIse
         Pmy6pPOhFfw/W3vc5j1/OXy9D6LqzpsKNHApmM+HqvEHwYcXNQ5RiUtsUyoDPeyL1ovg
         a9ADAyu5UrbMKg6kOdc2L3fJf6ScvlN4ez//IMr6Thuh9H80Zvd3U2TcirVNVO7E0w6z
         85toKncOq/KSvl1DKYcudcwWWpvdeM+0oE8C+1xxbd4kt7xagBzwq7d/EzS2NqB7EwGE
         UMyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784838168; x=1785442968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RH1XbIQ8E22rKZgx9gpnUFs1WJC3giaIlWrSChX8/Ts=;
        b=XWbSMwQBxkzvrYwYtgOxgIA05tsS05A0LOTuveXzTgwnBJZqIx0K2iXVioLwXooKc6
         RHSOrbJJNEBb+j8yIvxvntWRKlpkb0Df2a79Z7aEg1w9Bqj2ZQEe1lzfgQaX30ToC1wv
         eQwq81ryS16lwXVlvrg0/3+pHnRsgi3M6rodcmIKWWWLx+/Ct9ntQ4rQEK37M2U+2RE8
         9hDFPGivJj/3GFMt+qHniojjvz85j1+KX1YcsQtMrf+T5fvyo+rz96kOHJq51eX9KZX9
         ShJF8iKqSYnkxvoiKFPpGrC43Gs1vrEwv3Xsh12vCOTAWBEAymVnGUy0D+VlhiSJczoK
         5srQ==
X-Gm-Message-State: AOJu0YwI7rGw8UlKwu1R0FBwqm7CMLmgtuD4KDNQFJbE8Gz/Fh85obpx
	JLR6STZQRAZrzt7ze3Y9vtUQRekeC3hy6dRi/maMRUkXw6Fc8DI8YboQ
X-Gm-Gg: AR+sD11ZGOi0cxG5tgmruiu3ink4RSgrmwJC13kusdi12ttnM+s4N1Eg/+a6fRU+JKJ
	yQGuxj27kJDMUBPq0JGBqRT1CdL97oiXDxnUHvR8R1lYXZuH+5lHbNB3W2tRRwUpOngktb1j/8Y
	mRCLgSGSj7yOJtIXpwdvQiii8fmpoHq1FawC+fsn9PlYhACydJgASgXauGF3IaaZZFYXDsu8F/v
	tXyPJRltNrpHp3Vgw2PsTu6C2CfLWOsfZSjx2gh7mIFwZDnIS5jMTxYW7PZj92FRONz8GQSzjQE
	Vmi/kkXl+eGdku23HuGzDbMNGjs9hut2CXDQKWyEpc0bvc1D0lcos+WDzJ4tAb5fhXtVtNyz4Nf
	0mGli5EtGsSG0BHhBX2RrUPSJU9JQwujgHlECPK4lvUIvVMAQVoe5fCZny8Zku6zPjzbXPpuVt9
	VyH1MHeJ2GyYpt8g8OVPvHjbHay9CHI2NMxaN3ISog
X-Received: by 2002:a17:90b:5588:b0:38e:6a44:671b with SMTP id 98e67ed59e1d1-38ec6281ddemr4527010a91.0.1784838168031;
        Thu, 23 Jul 2026 13:22:48 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([61.141.241.112])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f058118f2sm140429a91.1.2026.07.23.13.22.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jul 2026 13:22:47 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Brian Norris <briannorris@chromium.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] wifi: mwifiex: validate action frame fixed fields
Date: Fri, 24 Jul 2026 04:22:39 +0800
Message-ID: <20260723202239.158-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260723144127.GA234631@francesco-nb>
References: <20260723144127.GA234631@francesco-nb>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 23 Jul 2026 at 16:41:27 +0200, Francesco Dolcini wrote:
> I am confused, why is this check needed here, and not done in
> mwifiex_process_mgmt_packet()?

I double-checked the arithmetic and, yes, I made a mistake. The header
check is redundant while the other two checks are needed.

mwifiex_process_mgmt_packet() already validates:

	if (pkt_len < sizeof(struct ieee80211_hdr) + sizeof(pkt_len)) {

After subtracting sizeof(pkt_len), the len passed into
mwifiex_parse_mgmt_packet() is at least sizeof(struct ieee80211_hdr).
So the if (len < sizeof(*ieee_hdr)) guard is redundant.

The remaining two guards check that the category and action_code bytes
are present beyond the header. Keeping these subtype-specific checks in
the parser places them next to the corresponding reads.

I will drop the redundant header check and resend as v3.

Thanks,
Zhao
