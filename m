Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197284;
	b=peaicA9/xlmBPRPeN9N4v8f8EVgDNmfhCX0Vzruv1jFN1HPhMMQasko/+oJpD7RBwA4/
	 k2QR2t+h4MLHm9NY1YW0moGwbk95mc0SC2hWCRypNnY73We8HoV/HJQ9tzaKhkz90kv8n
	 Dp5LcE6fkLCCn5FYR5SDFDsegC9TsGWqbvwbEfe7PUwJwDIKbvzBUBy2kb8w6dGkFGdcO
	 BfStrhOsEi+Q0aimqTF92R84z4tTNE1MmBb6cYgIRUWE0cYgpC/vFsi+CdaGMP32sNxSW
	 f6E1LpqmXE6a5eEI3DAGHY7B1ZZifsb/wzjvjl8cLPsrkqZ1IxKo8YtQEuY8t9SZyyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197284;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=iVPlVEgXcfYnc5ByflI8cqyqM/yX51vQqKw2Q7ZDD9M=;
	b=dBFhZocvfuyUGXAxk9tfTqp3a2yuURNxGgx99gmgK8upjfAQrlM4ssjE/Y+j2pNZLl1l
	 UZmv8ifaMBhHGnC/i/OMxAwQFyeOeMywkmx9dlBeFc7UBGNgJRBVSxs+2SYz9zGJvd0Lz
	 oLVDwyKyv+jgnm4+c1hwN4OaF58hVZfIxXUcqPT5I0Fv9ENgOWBjTrCLJr11PcPgpjZTF
	 mW2+GtIuAsPaKPHg97qMKkBZMXxRnaGca1lWfu8g5wmzbw6HJU3uv1G76xDbrsvfDHP+S
	 rgSNxibQAllSkEWKJSF3V0CitpvMq7aTrrAGrhNH4d5CHK6XKcYtUEib5NLMpqt+h1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nYBYvAxt;
	arc=none smtp.remote-ip=209.85.210.174
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67024606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:21:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67024606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nYBYvAxt
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8a07078200fso552217b3a.2
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197283; x=1793802083; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iVPlVEgXcfYnc5ByflI8cqyqM/yX51vQqKw2Q7ZDD9M=;
        b=nYBYvAxtQdanTSZ59b3PuIx5c1SuFOrfLYb/dMQsaq2CcGQPSP4C9zAeW4zoAHwNoV
         mtctK+YdQfGnsgomBssdpL879SI8U7T5Mpks8tY65xwxOcNZVnLN4sm6OhrAFsRiVqLw
         QfWKKdVWlPhis9AmPbqx2cxTLMQz+un+WFfQRwHziCrjbc3DHatMD2Ol52+CwaqFuIgD
         U6Y3mSS6mFXb7RmAiBvnSenuyWjgRMjy2/hFMg/u3crczo3+kQ1tdSs6hUrnLfe8aRUL
         Coo/jQYoOZK6GJ/ykBjSlTz5OCjHAXGB962VAGGlWfAWS8q/H6YZgHFJM8bnmZYqtF01
         9BAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197283; x=1793802083;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iVPlVEgXcfYnc5ByflI8cqyqM/yX51vQqKw2Q7ZDD9M=;
        b=2EyMfZHv2uMGRVzD2hmHctl88g4gmfVUpPEjv87Xt1cUFYV86/3XQ4QkYK25BDD5ts
         QQwCes4f0KP1/ROEhm/hfBRmZZ3916vHG86JKlTZsW8/yfu6WL1gPWdT7FrLbL2LqKiL
         8nd2VXpUFkdBfOBa5tLzMA1UuovYfqhqoSCqL7g3k4fmfRlI+0LkB+koco8/NWHumFxM
         lI7V9Ml0VLTxf2i3kWOsdOQXX+XpW/Y73GNaQUK010/gDql0/dyg2Iaa3UWRNWKo2Guo
         I45TY6jxTuwhEhuDWfmIRzQG+yisPrz0MCPxrqJuemk4VeM8ykeAX1seVK4jGWbOWWtN
         A3zA==
X-Forwarded-Encrypted: i=1; AKwUvBzQ9Arq+Ba3/3HrqHPQXGeOQeyDpdXNTubRah5DOlCQwMwLUyeaaj3tWbCFQ7pZGbgo/c9fqu3AyKad9CNrjA==@vger.kernel.org
X-Gm-Message-State: AFq9FYKtP5E1V/Xs84rPmcFLRv73NitcMF0l6L/6vmuAHcylqr3xOhkG
	Ty47WGI7fb87qOWByONbPJXcCtJaYas491KatFJZv/Fl2dnMkFPNu8Cs
X-Gm-Gg: AYBFou3zPz+uhxvLL17L2I8XgV2rnKBXXmnWA2MmjuBujR9q2lBIVTAGxl+hx+13oCn
	JwTCyTn8rw2ERocEheerqbUCn4NB3URfefhSo2uCUzpCNAYSTcldNwrA2CeH16pOBHB3mnr/k/N
	rxrHWI/c7nj4FaNfwfagXXMtlKqj52effp6uh42OCqNTu3ZzuFm+JVhDwJJc5V6R6ylrIoUl+kK
	QwrXERXpWYk4vz9kzvtzbTrNVGLhNQuK0Ovd2+49tcuEj13DhrVnefLQXnxmGNXBC93iuOibjNw
	1DS6kEy4GrT3X0hvNjPlO4v+/9F06IYVEipfhs/j/ZFB4UhV+fviqSjKxMhXOGvKGSebvxcO3t5
	tmf9zGHDIr0PV+Nd2dI/26cjrwy4VCIzSkI1wgf1iV5lMOTqUJQH8LIzwsRuUP45whkgS93bVeW
	N9thnFyiUxYxSl1HtoQHkGDMTa88ktXueArYibf+D/WpsYo1UDzlUbhwR6j71UQT4xqExi3oqQ9
	J5DCyOIUqJws1opR1eMtYyAAgkLkEkp336uRC8fY9Kf2GB7iieWLvRu3WwEeySl8iy28sm3ejsu
	RuAiIa/sJPYVcpaSiL40Evr2lMbgwmH480l4MgB7XYbx8GZHKTfibN5vI4nvnwUYhFzQ
X-Received: by 2002:a05:6a00:3d48:b0:84e:909:ac03 with SMTP id d2e1a72fcca58-8a6e72dc627mr1999640b3a.10.1793197282428;
        Wed, 28 Oct 2026 07:21:22 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6dbfd4d9asm968825b3a.9.2026.10.28.07.21.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:21:22 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>,
	Sven Eckelmann <sven@narfation.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] wifi: mac80211: recheck injected headers after removing FCS
Date: Wed, 28 Oct 2026 22:21:01 +0800
Message-ID: <20261028142101.11994-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
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

Injecting a short frame with IEEE80211_RADIOTAP_F_FCS on a monitor
interface can pass a truncated 802.11 header to transmit handlers.

ieee80211_monitor_start_xmit() validates the linear 802.11 header before
parsing radiotap. Radiotap parsing then removes the four-byte FCS without
rechecking the remaining header length. Software encryption can subtract
the larger header length and pass the resulting negative length as an
unsigned size.

Recheck the required linear header length after pulling the radiotap
header and before handing the frame to the transmit path. Require at
least addr1, which the transmit path reads even for extension frames
whose header is shorter.

LLM assistance was used to find the bug and review.

Fixes: bddc0c411a45 ("mac80211: Fix NULL ptr deref for injected rate info")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Validation: A W=1 module build with MODPOST passed. In a QEMU KASAN
guest on the declared base, six truncated data and QoS-data injections
with the FCS flag reached transmit before the change and were dropped
after it. Injections that keep a full header, including 10-byte ACK and
extension frames, were unchanged. KASAN reported nothing in either
kernel, as expected for a length check. A reproducer is available on
request.
Sparse C=2 passed. Targeted Smatch introduced no new diagnostics.

 net/mac80211/tx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 32f94761cf32..f2772b1736f0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2511,6 +2511,12 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	/* remove the injection radiotap header */
 	skb_pull(skb, len_rthdr);
 
+	/* FCS removal may have shortened the 802.11 header. */
+	hdrlen = max_t(int, hdrlen,
+		       offsetofend(struct ieee80211_hdr, addr1));
+	if (skb_headlen(skb) < hdrlen)
+		goto fail_rcu;
+
 	ieee80211_xmit(sdata, NULL, skb);
 	rcu_read_unlock();
 

base-commit: 25e73f1d6868c759c8eb56cad4e411692c5341b4
-- 
2.56.0

