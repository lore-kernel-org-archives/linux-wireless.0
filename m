Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB39441F36F
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 08:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788682825; cv=none; b=n5KgE1ZPzDZ9aqW+y1+dqyHZ86KPUO+ILGoPVE9CFHotYGT772mvEL00s/g2bI2nwjbnMZLPld0OherThckiTP84K3KjcEZ9Zr2sGgMsTi+8ddTXzd2lRHm1Xfflfk8+C13GwYc4MD1M5kHFn6XWp97/1Qb79/4ZwyaYMpHadOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788682825; c=relaxed/simple;
	bh=0xEFt0KId1bbWO4JnsEecscMQi9htX6BeILroRgbeaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkGM83uW19ZQ9KkmZsB8VSNXV8sM9M1Y7NQrgRjO7lyAS5gLofGZDrOyDrYqfbNIIiY7+XriIBUR4mOI8xjAD+T4A39xpPNJZxcCRTw8+/f0pI27btPWYVhiKF2H9FA5IVpjejd/JLSKpLFjFFKop972DMKP7xTiJ0tvwSVRbg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lYh7BE3c; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lYh7BE3c"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-484392e3d33so1599408f8f.2
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 01:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788682822; x=1789287622; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HGjJR7TkWHBBnrChtfogwR7ut4m/2TgeTRgKs4bJcgs=;
        b=lYh7BE3cpcfsWfGpd6+gm05qmAqsk5zH35j1YdNQw9p+NL1Kp8Eq/OXQYgJalm8552
         yV+dG5szNXjTwQNi+dB5hLA5VlqenWQz6hjOTZqYwimI0wPVZfSZVjdbbcNjXOXWRo6/
         B423aBLblHeRSJmUL34aww/p6Hp+L+UVY9Xw0GMuOjVyx87vwrcze5teni7mdwo3g+Mx
         G/GNCgc8QbztkYV/oQhQheiiQGD1C95IhdXnHxjgEUM3QbSxkR7pu5e+lEIrkPsiS7Dp
         zlYeU/dyQAvIw7a2aWSxjMKX86R1nn/AGWzJkDiQCdpaYTPBCYZ+FdpVX4hscKf+QdBC
         gI5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788682822; x=1789287622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HGjJR7TkWHBBnrChtfogwR7ut4m/2TgeTRgKs4bJcgs=;
        b=bgCPRUEthapZv+aSO/gyuw5tT2qWT6snwr/SgTK8Xd3lapYamqY5J5y31wBjTLdNGY
         THuchMQUx2rSArf6JSn+VMz0lSxuYzyvhgpFfMMtMp2avLJCaVB6G92La2M7IQw07Uiv
         YI8dfK063NdCeTKhMQWBnHweBJEBTm+8mcC7okYYc61WfvwlZVz40DKrWQu35QcTWWHH
         jwGol7g9f4kv5P/nXGfeUUO7SWH83Kpdrt5TfBSKfmq5AcAJ35n/2m49yaBsA/xl+huY
         n/OB1jOUHRMSiUaG3eZbnoKq8+RTDD7IR2spSh/WMjTpCzLFWiqX26hC9jMVsYSoaeTN
         DqJA==
X-Forwarded-Encrypted: i=1; AKwUvBw9b/n6YPO1RNHQZPO02UWjOu2TCrrMgwzHsSG7JUpRHCaZVE6sYN4scLevtYawATOSTrHA7pj1UVpiY9s/3Q==@vger.kernel.org
X-Gm-Message-State: AFuF++ki70vb+PAdXkfYJgG2WoF/0xmT+yWME9cpbgCP54HUg7zTN9tw
	2OHNRNZRvr/Cc3UIN8/butb9J09xh0NtDJeY8a966D+5IOlc6pSrIp+h
X-Gm-Gg: AYBFou08tTE/089KLHl+38fh6Y67PPUqV+GxGzBWC0y2nKh9KEc5iJSxzMkD9bYheBN
	7kWacwAzr22IHNPuZ1fIqLpjzdLXayvNSy+la3zmCVgVzeDlLxCWmcLqmYItfmk9yGeGee5fcpJ
	bvy0f8Zmusjg5AC7+ktYVYsqzcpCRQmXXZJBw9OGxb4DRxntVY8CGvOg+o455jijaQGPZZ5YcP7
	OfVfg2JpoA9yF3x0JvzkFa7iyLOAawF/2HUcmpKK6xpQ5lj4Vqsjt7IFE2WmwT4nSKHw2rJCQXr
	Quf93n77p71n7FMzlz4DUycKlqOUgSFQFJTobmA50SjZng0i8j3gds/trKn3JR3XWNYsg9z/MVr
	j6va/p1UJ7Z8rxfWk6ta87MqRWZE1XEsmH5SzJoEdsi9uaHjApOVhUKi4VBjgwEEOTNa/m39BDk
	bXU8R4k5SG20TtDRL5ZgMXUcmuN1/4ig3Bh5kN0Qy/0bMn2Cffj2DzFTzBFQCjlEbp3Q==
X-Received: by 2002:a05:600c:4e46:b0:49b:910c:7703 with SMTP id 5b1f17b1804b1-49cf823f160mr166433125e9.9.1788682821879;
        Sun, 06 Sep 2026 01:20:21 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf7740d44sm480033995e9.15.2026.09.06.01.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 01:20:21 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mehmet Fide <mehmet.fide@screeningeagle.com>
Subject: Re: [PATCH rtw-next 2/2] wifi: rtw88: usb: only let the frames a dozing station needs use the after-DTIM queue
Date: Sun,  6 Sep 2026 10:20:20 +0200
Message-ID: <20260906082020.909598-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <e0c709bd661044d799c3f04ec7348c4d@realtek.com>
References: <e0c709bd661044d799c3f04ec7348c4d@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ping-Ke,

> The existing is messed already. But could please put them in increasing
> alphabet order? (only apply the part of '#include <linux/*')

Will do.

> In reverse X'mas tree order. If you want keep 'struct' and 'unsigned int'
> together individually. We can have
> 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> 	unsigned int paylen = sizeof(rfc1042_header) + sizeof(__be16);
> 	unsigned int hdrlen = ieee80211_hdrlen(hdr->frame_control);

Will use exactly that order (fewer of them after the change below).

> Can we just 'skb->protocol == htons(ETH_P_ARP)' ?

Yes. mac80211 keeps skb->protocol and the network header offset from the
netdev path (ieee80211_build_hdr() only pushes the 802.11 and SNAP headers
in front, the offsets are relative to skb->head), so the SNAP parsing, the
hw_key->iv_len handling and the unaligned.h include can go entirely. For
EAPOL I will test IEEE80211_TX_CTRL_PORT_CTRL_PROTO like
rtw89_core_tx_btc_spec_pkt_notify() does, which also covers a non-default
control port protocol.

> udphdr = udp_hdr(skb); ?
> reference to rtw89_core_tx_btc_spec_pkt_notify().

Will do: skb->protocol == htons(ETH_P_IP), ip_hdr(skb)->protocol ==
IPPROTO_UDP, then udp_hdr(skb) for the 67/68 ports, same shape as the rtw89
helper. The transport header is set by the IP stack for the frames this
matters for (the AP's own DHCP replies).

v2 early next week, with the changes to 1/2 and, if you agree with the
proposal in the other thread, a third patch for REG_ATIMWND.

Mehmet
