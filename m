Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBAC379C55
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 05:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784612414; cv=none; b=rUnjY1eDLWMZJIp1K3bqU1VU8ARMwFQkWdRlV+F4tRwRGihyBStjO37XRYkCpxCvOyQ98p+V4psDmXL911YBQzg4YLaUUKJ95xHzns899tk5EUB4LVYVktt7CJtwkixjGcV9qt6aQO+WSXPbJ6ZW1/xoDIg76ifS+4gWZsQOmZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784612414; c=relaxed/simple;
	bh=snjRBJneEvg77eHN7l3yxDVsSjyMxWpw3c8nWT82tOA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u4Aw6nMkyy6qDpOyiJ7rnyU1naIXb0r0ZFhDYq3aDBaR0UGPMKNu0KjW3nj8TcYm51s0CN0RaRAnFa2ysskaeokJv3it11rL1zB8xT5diSMuS+yagqqn2Eyiu/D9pYnyquSZf6lq5gZNXkO/N/yWQlo3VCGlc7rkef0q160l74s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=P2aZGkVX; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="P2aZGkVX"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84864086bfeso11582690b3a.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 22:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1784612411; x=1785217211; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yfdsN6fNjHwoyUYuGQVTryUEUs7pGIumpUdIdP8Mfvk=;
        b=P2aZGkVXghnTSh/Opna1SmzpWQx1UjP9XaNrSVUklqu9xS+GW0hyMa8cSACyK0zMCp
         0MZYfHNwRihkFFW44lt8A+Vb7CyVsHh56fkagOdivAn6TqTuTErrEXx1hDZtJ1GCySNK
         F9dLAoVUhm8QGq9cyrjwtPQTCCHy1TXGBF/c6yPP+ju2RLCWaGEsdkGjPMFP/rwRziXg
         eb2l4WlJ5wnnixxyjX4j/4/5A7bXtwmTq3BI21c/CNEXNrf6fEhO3hHElx/LKEor2PT1
         BtgWZJ32daejtXEXsT9SC75W5ZsP0SmhuX6npB599x1TR7yeSzzYKKrNyeofqcj7KG41
         C8Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784612411; x=1785217211;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yfdsN6fNjHwoyUYuGQVTryUEUs7pGIumpUdIdP8Mfvk=;
        b=D+XaknoGe3qpM8MfacZiAbmE/swDTHt4dZhCR+l2EInECipWRLzaacc2l0yf9gDkko
         zaxy9btYd/30Rqjpy3PajrBFom+Kj8f5c/TIWXvQoU671yBn+0fRtR2V37bNdSkebiFx
         NGN9wPEkxmNxPSxYP9zM5Sj92QxCSJE6XScIn1Xl/5wBMMM+YZupbQ4XlEJbtCCLA19P
         J5pKZPUKGQMLiikfD+wubPe28H6dja6AfH8sbM/DEaOXB/IQ4JCk1M2TXDhNDkIM8/n6
         dBAfxzti6MycAbkchIYZ4DfcHwCZPyprC+q5OUYbYLIEmGYzrGqj2Sywyq2Z8vaZvRXY
         NOdQ==
X-Gm-Message-State: AOJu0Yz83pxCPyx/Es5GtlylezmYE0ZI3Ybdl2poXOjOzrsR/Jk3dpzY
	HgkrP685dgsVMDxJDKcs7cIINNNKtn9MwpoAAIkiRxw+1otwuBihV9ZR71F3vcPuuh2w01VdzXm
	4tzK49ag=
X-Gm-Gg: AfdE7cnrHOdQAmFXrfdVyamYbV0/Zy41YTl6La2bbq5jY9dFv2TqrwX9qz7N22i2QyC
	KGVCFWKugRknmh3zIKXNJxQudvKwj5kNGHjKcEHSW1Y/2XxfmhYF7TlTuBR9QG4pLJqreA+2e8I
	y9cAMPOiW5iepnrwmbseSZqHXC4ZsjcptlEeg0ReXk6sYue1CXiCFcZz/vcD6TBnGlkDTQi5Q1z
	Qo9JP2mYM2SK1w9RD/xXo6D4QEJ2QaFAm6u7F+L33MoizNxFVjg8XQeoDfpxlIPsDme03qHValp
	ephoLEjc2jDm/JqD9w5a3Gk9v0bqTdHuxCO6+CgunfytorAv8XN8VKqP3C33YhBGr2vpgtpdqKL
	SmkZkresWOVXo7aKgnTO7V8EIQr4RLq0x1MA3uOVtGpJyNk8MHHxLfIMxaLGLN/0faEuTfPCCRv
	tky6N7+b5ahNy8JXAO9OXmdlbZ3Xc10Y7eFbOjqRTtD6Yhuamc8SDhNtl2Tfggc5exgSXASZxZM
	nMxxCiDNA==
X-Received: by 2002:a05:6a21:4584:b0:3b4:61f:1fec with SMTP id adf61e73a8af0-3c3ad5d572dmr20019949637.2.1784612411280;
        Mon, 20 Jul 2026 22:40:11 -0700 (PDT)
Received: from mma-H9MHD44.lan (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31429f9d444sm49569653eec.6.2026.07.20.22.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 22:40:10 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>
Subject: [PATCH wireless-next] wifi: cfg80211: include cf1 offset when sending chandef
Date: Tue, 21 Jul 2026 15:39:58 +1000
Message-ID: <20260721053958.227853-1-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The cf1 offset is not included when sending the chandef leading
to incorrect channel resolution in usermode. Include it.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 net/wireless/nl80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 242071ad10d6..3d1452ee32f2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4627,6 +4627,10 @@ int nl80211_send_chandef(struct sk_buff *msg, const struct cfg80211_chan_def *ch
 		return -ENOBUFS;
 	if (nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ1, chandef->center_freq1))
 		return -ENOBUFS;
+	if (chandef->freq1_offset &&
+	    nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ1_OFFSET,
+			chandef->freq1_offset))
+		return -ENOBUFS;
 	if (chandef->center_freq2 &&
 	    nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ2, chandef->center_freq2))
 		return -ENOBUFS;
-- 
2.43.0

