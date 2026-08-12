Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8363644D1
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 19:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786561561; cv=none; b=RMJMkqrWTW5bZGvWHinY3tO7ikDZw4O2PTBqb6G0zuU5PCSP4y6H2qfI7Sz7/q1RcsAoHYV4cZaHY840dwrVl5WTSI6YGfRtX19zMKD2DpEI43NtchYC0SIqdC4370LJOzNqSI/u83vhk7OyfglqUQnD4ALjBDmnPjlRmUX6lxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786561561; c=relaxed/simple;
	bh=eQp8XVqRjvd60SUbMt+7dhshdzEr9vsuv1ssHGoq5HM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfEZAHBYk++2QELrtUZbWyBUKHXdnuteLMDRpXeSh1W1fTh6kXwBGdubyd2p37X9VJQxqMZRrLs8LQDPl5y1mxk3QFnISsV7aC9RLD66H3ldnopYxsPcl/GL4E2FPCsWgYE0kDp2eievS9hjQbuPRLz7PB7r4AnOdjBubw9liX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MEYFVEFO; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MEYFVEFO"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47f7872abb6so629330f8f.3
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 12:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786561558; x=1787166358; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VfMnRH4aX6HLrkbz/tRyXORgXHNB5l3UhNoONEXfJJI=;
        b=MEYFVEFOsOhn28YdReysg9cEPgapDU4qhiBTKkLuaaizeMI8xhJjgdIiLTlUVEBEOb
         XS2CV7A3iFdsrwIK4byFRq4uWC0xkp6ghOvean61pEeZ5l/bbKkA83qsYLX/KzMXtIVL
         QdyFzJbz+1Va70dweidd8P0vh82VF+L1TbXDFBQGy9l6SW7E6sd1GJnln0be4Z/L5wSX
         iLkaYlLt/CVHPLOFO/6LoMqSd8gLMtdJNTtdrUZQj7KeekWbEZ8BJCnplsIK7FJ4ycyp
         3ercN+k1/4MBpXRIw9mswSjojlBMpk/VIfxb47l5loRrOESBI09vXHvf/QQx3XtRYidh
         atzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786561558; x=1787166358;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VfMnRH4aX6HLrkbz/tRyXORgXHNB5l3UhNoONEXfJJI=;
        b=iqkmKgWLZXd+kLY2oUyRKNsyGFRy/Fhldt2e+2D9PC6AqwrfEdNL+ua2AdCePA5d2M
         8ca6XVEN8buNGRHjutS47t843tYg1P5V0nZ6PuBcEADsmh82ZNEt5bz7i6GPDjON7+cp
         h+oVx6wnPzZ9kYMccl6OkOv96Z18OF3nj3uJ9S7R8GYMI5eXkL5YN1Jioq9n7Y4+8dhT
         tLta+e2KxtX0L2b2QO0Y+dMoTYBnssMpOUW23wwjlgVakImD66hR8ezYgz05LYFiy/2y
         U7GTSnVxWGshwCtYHbmqIrWC9IzpyFZvbyuf84jyA7vuAFbK9TOzO7GyTbwuvyhNViwO
         QlNg==
X-Forwarded-Encrypted: i=1; AHgh+RpSCAsAyOIC9mAIZ5HWVISUZgR4cfZ1SSFRMMZGhy4heF/dsPzUt2yWpqLk/2eiEBEcnIxvqUT4JDnxqg5WPA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7dJuGm0tw2otZTHavxvnj9ncuemF+uYz6ZrchCCFDTsFc3mNo
	Ijw7XpAeaRk5J29naKuAepucunnPyqHklL2ySzzNjIxygO8l6vnSegaI
X-Gm-Gg: AR+sD117Wl+hFtRQ3bfDrABHVdQM/1lMsP+5X79A2DKkPt4jAu81IZsUakgbwGYmlOk
	2rRz/xPhcohVg5ry0S8EQBL0+rheG+FMCQQWS3SGT9lcnN6EeaInBHOStwl/HVCamycsbWwWkNt
	7IKY3nJPW3CQMHNcJnDe1f/9p9NHSrNek3ASvZPf0kykqPHmX4TJ0a48YGvNRZnSUGKd5IFOHss
	RNmDlSRVNj8YIeCiMnrjdvL8oMEBcQREnKVoQNbcTod9Z36gDeEA+w0MUlKDCfIkVOwKKI7fRsk
	xQx6ptkvbS+FwRDL1JnrQuiLP9WisNhSH/x+lhCxQviEQg748sbI1bC15awLo/r+6asVigjMVCn
	tabfEKNJrk/vdjJJSagGiOwE/YJC1Q3Fng7dez0YPfPr/+JymPNUV5fB+VUnD8EV4WG9UOuY+K5
	ErCtDdR30WBiPTpdYD+Vxloyq60dQub0zXwfF9/pgWkyANkhC1I4aC9yoZCARrRau5o2LI6e7GH
	JmgrM4FctC1bVyXhuQPtKR2IQ5D7wS+WCXvePanGEBH+JbhecodMjlsaLtififDBVear08Z/nwa
	p+JpNA==
X-Received: by 2002:a05:6000:29c2:b0:47f:71a6:970e with SMTP id ffacd0b85a97d-48159c8da03mr411377f8f.2.1786561557974;
        Wed, 12 Aug 2026 12:05:57 -0700 (PDT)
Received: from Mac.home ([95.35.242.1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48150d5eb2csm9179875f8f.30.2026.08.12.12.05.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 12 Aug 2026 12:05:57 -0700 (PDT)
From: Shmulik Cohen <anuk909@gmail.com>
To: stas.yakovlev@gmail.com
Cc: johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shmulik Cohen <anuk909@gmail.com>
Subject: [PATCH 1/3] wifi: libipw: reject too-short beacon and probe responses
Date: Wed, 12 Aug 2026 22:04:10 +0300
Message-ID: <20260812190412.18333-2-anuk909@gmail.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260812190412.18333-1-anuk909@gmail.com>
References: <20260812190412.18333-1-anuk909@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

libipw_process_probe_response() and the libipw_network_init() call it
makes assume the frame contains the full 36-byte beacon and probe
response prefix, but the ipw2100 and ipw2200 receive paths only
establish that a management frame carries the generic 24-byte
three-address header.

libipw_network_init() then computes the information element length as

	stats->len - sizeof(*beacon)

stats->len is a u16 and sizeof() has type size_t, so the subtraction is
evaluated as size_t and wraps instead of going negative.  Truncating
that to the u16 length parameter of libipw_parse_info_param() yields
65524 for a 24-byte beacon, and the parser then walks the receive
buffer as if it held almost 64 KiB of information elements, reading
past the allocation.

Reject the frame before any fixed field is touched.

Found by an AI-assisted review of length arithmetic in management frame
parsers.  Verified with a KUnit case under Generic KASAN on arm64 under
QEMU; I do not have the hardware, so it is not tested on a real device.

Fixes: b453872c35cf ("[NET] ieee80211 subsystem")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Shmulik Cohen <anuk909@gmail.com>
---
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
index c8841f9b9ad9..2661dac6985e 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
@@ -1421,6 +1421,9 @@ static void libipw_process_probe_response(struct libipw_device
 #endif
 	unsigned long flags;
 
+	if (stats->len < sizeof(*beacon))
+		return;
+
 	LIBIPW_DEBUG_SCAN("'%*pE' (%pM): %c%c%c%c %c%c%c%c-%c%c%c%c %c%c%c%c\n",
 		     info_element->len, info_element->data,
 		     beacon->header.addr3,
-- 
2.50.1 (Apple Git-155)

