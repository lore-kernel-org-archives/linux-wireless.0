Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793623739;
	b=0+tFpG3TJwLKt9G0lfpAAEzV71kYVklftw7Y9Vb9yXBqj4/f2SdIyYU9UP5BdznB21vA
	 7R0wgvnRJPiK9ynEkbEole3qhIryNvq5fgCpBwOW8/EiqHchoXaJ1WZpbsXuEv5MVTOGo
	 iynTCkhe4WHRg6MJ3HKBU4/WJrmzuBzUrWas4SIXSy9u9Ly99ioRhpZFtK+dKWDkxNAKs
	 zIzuUFmRyIcXiB9rtLNtU9Rra3PfrwxUbRzCDoVWo5A8P22MqBxhzSRmXCI4cFSlXLNE2
	 L8WTepACe8tC+ZDQ9zx/xRWsCHf6elq3SbCLzF7OwH9HJEgac+e+jGXcfMH21mSU2XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793623739;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FHXKwfyjhX6mVoz3qAoilKz+1ex0M8UbC4u4Bj+pau0=;
	b=Ru753J9ud+kEomwjlWy7KBMhlAV4tT06b7pmm/zy+0sJl1koTA+9aLM8ue/GIPrK/lCh
	 D9Nci0HyF1UccQiMG8PI1dVqfIrlPh6zSB5rlYtrZQAPjzO0PHACpVqEzVhMaAewA9Vcc
	 0zyVvThOANLD7X/aFCqap+pYCyQsXcvS/r5AEElRueBDDB660pJTAQF+FVasRYNtbI9pc
	 eoBmcxD7Mov2rEbjYBUvxnqc//cAry/0+umPpVyjfHw3k62cf/5PwblHqtnaFBy1gxiiK
	 XLremmoRotp6kvmseXXqP8dRKMBCaIP1+XMP9Wtl2WRW0r72rpCgaDU/lTJDfTh54ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=auizdsJy;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C37960A2604
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 12:48:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C37960A2604
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=auizdsJy
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48e6eb21a8fso1132588f8f.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 04:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793623737; x=1794228537; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FHXKwfyjhX6mVoz3qAoilKz+1ex0M8UbC4u4Bj+pau0=;
        b=auizdsJy9Ldf+7S8Yco2jp5IjDhkadRv9VqvTUgnZK2styt4f3erznGi6atB80o6pq
         xYX3KBYX8QfSqNbTKsowMMz3NRmyRZkmMNrkUXoMHOwYW0Z3K/Bc2sD1CWJiCQn8ts9J
         LWNzH8c/uhoMk74cWwNyp+Rfl4Wm5FSuF+KBhf3vJnGYcapv/xET46KEwc4Lbu/t97EB
         GK+G5/66dwGRCmvCRuYVM5hfmJciH+GYllsIMV7EO4XMcc+WVFMcUhBKbK6GCZJpIX9C
         uZUsglGN6vZrjHCgQvUQklmLOB5ogtTHHRpg4NMXbmHxPQAdmoJ+BwRIIvaBgbUZR10P
         16vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793623737; x=1794228537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FHXKwfyjhX6mVoz3qAoilKz+1ex0M8UbC4u4Bj+pau0=;
        b=DTZbdqlaiD9P9uIjPj7fmehCk/1mmpA1WubP70oLc2ldfUJHZDgu+cWUpoUX/i2ZG5
         b6YrCDA+HbBK0lvb0cfmWdxVNRq8O3NZs3m65RvYCNgLkhKON7I2Ib4MdTcOpYSU3pSB
         mcoACKee51NGFCEWtThdYsZyW6SM1iLlsjkFZyIntdlZE7ZbhEpX0dhOC7GKKULCLmGH
         jfX4TMFw7Za8Rew0RTgmjJ2VKqkSuhe6QdhgVoh0Y2fUTvXypD1gtBQUbrKFi0u9iHoD
         S95RDK5wNZxjSU4uUPcquii6PwOwmVgalyr0p0JJyl3LFwgxXUnbOXJT4ZtI5RMNydDq
         WZEw==
X-Forwarded-Encrypted: i=1; AKwUvBxavAvGOMx45Q89vwEcYJdQFsLySzsJVeR0kEcBBnwiNPa8eKt4rCjIPQ6YwmvOsWak8P4WbzKoy/gGQJf6WA==@vger.kernel.org
X-Gm-Message-State: APuU4Z+C6xsQ28N2cJoFj3I7ydj0VdoNJ4DbHCz8rrbQNViU4jetXyyM
	w6yvcoEu81sr0VBeaEIuVchlFLNA6yLr0RZXKaNsnkk7Bhc6F3Uq+tM=
X-Gm-Gg: AYBFou1iMoZZ8UD9JgpzdthrB/1kLxi/ehNOLgCtYztO0y/UumVACqBfrtMH2uuX3HK
	oWLgaCrs+LnuMeUAczPjZOeNMSLYfn3wjE6pGYPW9h/1ykL17hflsSgYiawdsmz3tdGCtvpGRlf
	4CGGvqfNBJJl35JJ3VGc87yji0Ji7rLm2iHG0ydw590bwYTqE9iNRaagfJelC5DSYMRF03uzF55
	fQmSOSN+ekA4r9q+66BfRWYwc2qK5u8pHuAEW8AlMIsc5Ttvl2pEJPMp5wVm4aKBBzc8ALCEVlE
	LDdIjw0z7CDQw0H0T8MKbyVFquNSXH9sd7UuN6Ay1XC7gQnw89d4Xi3h10T9Ao57J13YOq62i6z
	EYGuX2dxFvhGr9pZ/YwelAHQjsC5PYxPVEZZl6qH1rygb692maafSKCiyj1n6k9Q/8QUCADbdmh
	SlFXDNi4iHfqIRI7ox8qBzo5hc53+LMKlEiaNjJdyguc7tkGfV09BT/rcccsrk1u0WMQPu55Uie
	qCbgZAbU1NjkazfGgQIlEOWAi3xdoTHnjLq31UtSxDF5dYVitNk+joHGWBvcmtdyJQCgtTVVQ==
X-Received: by 2002:a05:6000:22c8:b0:48e:4831:ae20 with SMTP id ffacd0b85a97d-48e6e305b92mr23429203f8f.37.1793623737454;
        Mon, 02 Nov 2026 04:48:57 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b723bfsm18719736f8f.15.2026.11.02.04.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 04:48:56 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>,
	stable@vger.kernel.org
Subject: [PATCH wireless 1/3] wifi: nxpwifi: validate HE capability TLV length in firmware response
Date: Mon,  2 Nov 2026 12:48:52 +0000
Message-ID: <20261102124854.325979-2-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102124854.325979-1-tristmd@gmail.com>
References: <20261102124854.325979-1-tristmd@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

nxpwifi_ret_11ax_cfg() parses TLV data from firmware without checking
that each TLV's declared length fits within the remaining buffer. A
firmware response with an oversized TLV length causes reads past the
response buffer.

Add a bounds check that the TLV header plus its declared length does
not exceed the remaining data before processing the TLV contents.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/nxp/nxpwifi/11ax.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/nxp/nxpwifi/11ax.c b/drivers/net/wireless/nxp/nxpwifi/11ax.c
index dc1e747383eca..1006b4a84de73 100644
--- a/drivers/net/wireless/nxp/nxpwifi/11ax.c
+++ b/drivers/net/wireless/nxp/nxpwifi/11ax.c
@@ -215,6 +215,9 @@ int nxpwifi_ret_11ax_cfg(struct nxpwifi_private *priv,
 		tlv_type = le16_to_cpu(header->type);
 		tlv_len = le16_to_cpu(header->len);
 
+		if (sizeof(*header) + tlv_len > left_len)
+			break;
+
 		if (tlv_type == TLV_TYPE_EXTENSION_ID) {
 			ext_id = *((u8 *)header + sizeof(*header) + 1);
 			if (ext_id == WLAN_EID_EXT_HE_CAPABILITY) {
-- 
2.47.3

