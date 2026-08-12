Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A84352025
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 19:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786561567; cv=none; b=Av8/6cu06ZK8XGyLtmjoa3r4J00gXerVuGlGKCIP4zHBsp4pIg3WiNq/3XwPQxkkFQghiOxHvLkKa8dTLmeP+M8IN2a04vhRSDtOy0MzIxoWQn4Lbv6mBJmvJfOCzWy5buekyodKToK09Oe08yH0tAj77psJnq8konunWb/eexQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786561567; c=relaxed/simple;
	bh=XgKH/QMgnQwl7EBN8sR3LbzgpflW0fob5QcEkkgOi6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Apxk+e8pVXYwgUnlEreZgM9hQ6vFLthPIDtrhPXK88b3Dvd4WAePcpRgAMzHolPTQjnWQczvHuqXwQqr9PX61VEiSHbj2nZ/shyT6Vl0Ng7tq6Nk3nQofxBn/4j2+Tgko6OA+wJIwl+HL78k4dzt6TsvnUM0b4yDu++THuVijwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JAHV+02N; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JAHV+02N"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47fecbbafdaso412365f8f.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 12:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786561562; x=1787166362; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/1tMxUnulpGOwRXNg8wdc8brX/d0czOuEVfcemqNqzM=;
        b=JAHV+02NPqcAu4lrYJDl3p7Pdi8ohEOQCtgshlnKQ1CduvJ+s1KmkNY91liKpASGzk
         oQJ8TBZ3t0s0BcUD7mCDF5LvuRXH2zTGxNo55U+pJubBYeESrAGxOg1NfC7JtL07+Z9A
         rUC6fWGhCC+iGoo2IOQ2HHBC+ay9Uk48zfBiUCY7KLGHTciid/urCDJd2blkmCZctXml
         HtX7UPwwCRl589p23rgSKgsqoo2CtewVbL1QSEafkM0FOxpD3NYDVP/7chj6G2cnp7q9
         obxW8gngUIRWwUjqUIuKhEgHZBVp09muzMjiexeZt86RsSGN+muhx59sr2U0X9chQLOb
         6eGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786561562; x=1787166362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/1tMxUnulpGOwRXNg8wdc8brX/d0czOuEVfcemqNqzM=;
        b=A7mcH/RUWsPdeOPkeOuJ6qtFKmNt66nPd/VY1yBSYsbZuLSXVV1NtjHckc94sYYmFl
         QDSqnajP2qw8aCb7n2yVIKkrnJAa/IhrtZcddfnaQydICHOGQSZ4i/UVzVXrw1rrHNM9
         wd7wz7umWU9JSZWxj5kt3xogAE1Z7iKfUoHy3YxcychgQwIL45+DmBjUh2eRBy98piI4
         3+Jkdawm+YTey53OKqJg83j4DNEbnNo68u86ZPJUx2eJqkvxl7QHWyhluD9Z/zYxeJ/Z
         +g2zL3fcvhT7zAtmiSzbnuqBIG2zI+Hll+JdafKBNsHAFvU8jrRtQsRrRy0xrkalFxJw
         FWMw==
X-Forwarded-Encrypted: i=1; AHgh+RpZKjynajyLhJb92yv0HfjFhXjheQF0sZAOtYCdFNzMbekyZXwOOoPeYmuq6FXOHYeD2EV/4FuWMIVrSewf7w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy74tDEWI+ULndFtL7vZWE0ZpR+33VhCD7IpZFPW55pOO6RLkZn
	TeE3ZjM1WGFEg0ewJK2RstO7PrNvz9tuVd7Ym6CdUBtBmHM9fYdVVpTt
X-Gm-Gg: AR+sD12qTuEMmiz2Bi5S98h+q1Au8Gq3+aMRmDgDkF+/coknPu5ARdh/x9o5Zfh47IG
	EqplTmGQlOnD659dEECvxKCnYyc8Q1wSAW8FKeXHpNxJL4GGF8jcJsRC1o1kpeq6+kokMomrPyB
	IVbYWE4i1CrytEnddq3JzyvqPoxU8JZqXpUzyoskfBGgAEso/NboeoNs7KtC8xecYHtpha0Eeuf
	m095xcH7b46qtKSTrwy4IkCqrBEfwJj2m7L1Fh9E+V3jDHI7rV/PAxTKv2+yiCHZDDKg1h2vnB/
	sjXVnOsQeJNMqFyYjSyXjoENUkxTK0hSzuudrHjOpOEfsYe0NfEJRRIRZ8KYu1bxm3sHZirGy/V
	RvOv384+8PqzZdZ0IF2h5Xx0v7J9/et8EAzvE6BwPMPcq51mMSdPQSQmqNDxC1Q9xCG4fjRJb4c
	Q1+B7XStDgrCM/xwP6eB+XodF5iu7PqLpwlD/CQRH/3Au5cCRXm6m4ruN5iLsf8Nj056z9a7LyW
	KIJWWEI1Y1rt7cqUVLzNc4081oekU8EdZTiT9/gkJxAUg8kwwZLIGvylGojSCz5BcmtKxKanbEN
	Nkr0OQ==
X-Received: by 2002:a5d:50cc:0:b0:481:51ce:542f with SMTP id ffacd0b85a97d-4815a028804mr313422f8f.21.1786561561990;
        Wed, 12 Aug 2026 12:06:01 -0700 (PDT)
Received: from Mac.home ([95.35.242.1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48150d5eb2csm9179875f8f.30.2026.08.12.12.06.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 12 Aug 2026 12:06:01 -0700 (PDT)
From: Shmulik Cohen <anuk909@gmail.com>
To: stas.yakovlev@gmail.com
Cc: johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shmulik Cohen <anuk909@gmail.com>
Subject: [PATCH 2/3] wifi: libipw: reject too-short association responses
Date: Wed, 12 Aug 2026 22:04:11 +0300
Message-ID: <20260812190412.18333-3-anuk909@gmail.com>
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

libipw_handle_assoc_resp() reads the capability, status and aid fields
of the 30-byte association response prefix and then computes the
information element length as

	stats->len - sizeof(*frame)

stats->len is a u16 and sizeof() has type size_t, so the subtraction is
evaluated as size_t and wraps instead of going negative.  Truncating
that to the u16 length parameter of libipw_parse_info_param() turns a
frame shorter than the fixed fields into a length near 64 KiB, and the
parser then reads past the receive buffer.

Both the ipw2100 and ipw2200 management receive paths reach this
function having established only that the frame carries the generic
24-byte three-address header.

Reject the frame before any fixed field is touched.

Found by an AI-assisted review of length arithmetic in management frame
parsers.  Verified with a KUnit case under Generic KASAN on arm64 under
QEMU; I do not have the hardware, so it is not tested on a real device.

Fixes: 9e8571affd1c ("[PATCH] ieee80211: Add QoS (WME) support to the ieee80211 subsystem")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Shmulik Cohen <anuk909@gmail.com>
---
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
index 2661dac6985e..424349a6935e 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
@@ -1209,6 +1209,9 @@ static int libipw_handle_assoc_resp(struct libipw_device *ieee, struct libipw_as
 	struct libipw_network *network = &network_resp;
 	struct net_device *dev = ieee->dev;
 
+	if (stats->len < sizeof(*frame))
+		return 1;
+
 	network->flags = 0;
 	network->qos_data.active = 0;
 	network->qos_data.supported = 0;
-- 
2.50.1 (Apple Git-155)

