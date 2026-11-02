Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793639778;
	b=TqaGuCXJlYXJwii6n0ceAyUYeGeGf1EDYIBdSrLJjm+4qIoURi8P9vg6Hem4A0G/H+E8
	 XQxDDJpPRc+9jAB3gGg/lZNuwCiJ4hGid7rjyLHKalmhVE1f1AdRaxb8eNQ0K196qfJkb
	 fhoLupAP9/NPfsANlGU3uVBhbtzttq5ur5N5Gve3FcZ+u9d/5H4BdVQejR0bZolw3ZZoR
	 cFpj9dXKycvtBajItv78LthwQ/kutJ70PmefWqa0e3j82J+Q6EUcAiHhzFa1y4pF2Iq79
	 hmJUxEj1lHZYFyp0jl+UNCpvGSXzZXOqL7lJAOY0RaE54b5cXN90fx5J11sq6F5W9dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793639778;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Y64Q+8Q1ZhpnOCPcIn/HkC4IMP55Z2r9DID6/cPOxcY=;
	b=EMQFrFXAGVeKDXXt1upx0PAJ9p3zMhQhDB9z9NQUw2cuep2ShQ7DQ0pPevh8fqJ3uxhY
	 VOSaDYv9pixZMHU7YaM4fAPZLHcBDp/ontb0Qsg2dr0IiHona9qtcIkIublHgs4Fbb4dX
	 s7FjTD7xy9O3u7qge926A+rrv6ZbdH6cn/6KAfFCGklHk33Xvajl1jNVIY/Ap6qen+2DZ
	 MZIuHuUcIeY1Ac2dJiCtZ3GzGgOQ3vJx3Nf1O4IpHyqTtj9OBfZ9dT/EKks2PvMvtAYlV
	 RYtBowmyOw99wyrUZqxl2jSYQNvlZMfOGBG6duI0hyuXvvdyOI9+TOdfFajMUfZZNvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VOGnZa9H;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9E0606A93B
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 17:16:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED9E0606A93B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VOGnZa9H
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so42944565e9.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 09:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793639776; x=1794244576; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y64Q+8Q1ZhpnOCPcIn/HkC4IMP55Z2r9DID6/cPOxcY=;
        b=VOGnZa9HYa09YdmhXZF/uGcbNC2VXZbbSWjQPgoxhmHFQOVTLqsQAuoTQEWeTIrgI6
         adz0jqM8ZYQpoIpFJrPOvTVSoR2361QfYz4wHNS4V53JODd4HT/eWK2E/j3rJLAATv1s
         mQgb6FV+BVlvEZmNo+R0Hbs8V7Q4Z2DbuIuxYKOh8pn+osDGkSoYE5QXH5SvTtGTV1Bm
         rBrN6anGxSAYR9B4dC06KKYSViICVYNRKXKtSTPunATCoBJzYJYQmIbJgP5taNBcD5Hr
         4EiKmJaZvP3WkYaxOn36Cc5R+2Itx2sB1BFgAK3KH9mlXRzOAuIaTWf5Ng8bC6xbfgG9
         +IYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793639776; x=1794244576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y64Q+8Q1ZhpnOCPcIn/HkC4IMP55Z2r9DID6/cPOxcY=;
        b=j+3Qqk6XvRMQWzF9Eo/Xz4ZprQEUHrCGIFJ3Ebungj91v48m5ZInJHqkTjzwzCbnJb
         s2RgP4GVhuuho0NqFSm+pSoAlHg1OZLCeMeRCS9HlEN1/oBuEwd1lWE0dqj5ZwIEKCm/
         DsaUa9rR+SYSnnUb29KXF+SdV7yhucYA66pCB5fZ3IkKSu0xMA8cZW8RAaYX+81qS/Io
         Ar4BYVjlOO4/gapTdNDrBl0tEAFxesBTC7QmsfR3RSlXjlJOTiqyfSWAH5Ii5rFLeBuY
         h+3v1CyMG8x5CBPZyqQvIi+dZN9hWEwCJYvTln55pV8Xh9fLxdl0hGXksU852Q+HtLfb
         KUTg==
X-Gm-Message-State: AFq9FYIB9PHCTKkRQbfIvKOf87bErwbwFGbiO7wo/l/cm/F9Hr7CbG3t
	QIWvJmBmX8yK7piSeAHbPPa+u+jx6CpVfvSVwzFcihAuvY/Jz7SH2ptG77pRSnkbta0+Qw==
X-Gm-Gg: AYBFou3szawdtwFGZnT+yQe5AMQoqMQZXz1JEtK+HWeSAu2SNl/UxIgAeKZJupRLbHU
	pylCp0CeTQ3sJIUcvogOq1V3995NZwj1fEH8e/WT4NnzF77jKjhFe8zSKUuwDqGQsYZfiiSWfvm
	JdA1DkQ7E3aRvqLOFbwnBnkskspOKhgjkKgC10wByxiAEHt05wtftxkiDPkoWzMaiUdHcyI7zC0
	qMLKHcskl5z4Y7BVSwHMHhHGd+auLqNc4hdrdFcL2RGTNK8y51SDuf/7oNRtrxL/M+z+B8NXozS
	fRpawvNs5m9B3qxZndx/DcjkimftKThURRUEoCWkC2HngVqOgMQhZooqthZzKycLeJgnDGN65fO
	a8Z4vRO7mYJQjNSkvnVp4QQckRoA5gEzcC370EIcffz93OfHLjpBAKLX+Ud2LeyAsVKeOQHJ4jd
	zIQIyzTsRWcwj69kJVVyJwhL6FGmKc2mb1R4jpu+bg563bYrn4LJcYqwcwepGpNVh7SX6ORuvsC
	iHgTTVD4f+ONZlS9MUK7wCcPQpPn35AtHBzy6XTaCIOkRnTC11ob8k1Y+UaOoTRU91V0JUcJAIJ
	2R/2NYCdjwE70aDBSfgERRd9lpIlzbzpC9Swp76odLZ9pjZr2ihe6vKAbeHqIBbGG4WkUyBOC7I
	f3ICuPxan
X-Received: by 2002:a05:600c:5d6:b0:49e:795e:ba89 with SMTP id 5b1f17b1804b1-4aa8a0f4e16mr218253975e9.6.1793639776324;
        Mon, 02 Nov 2026 09:16:16 -0800 (PST)
Received: from debian (ip-78-137-176-146.broadband.digiweb.ie. [78.137.176.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71a4d3e9sm23598760f8f.6.2026.11.02.09.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 09:16:15 -0800 (PST)
From: Pablo Mazzini <pmazzini@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Pablo Mazzini <pmazzini@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next 1/4] wifi: cw1200: don't update the beacon in station mode
Date: Mon,  2 Nov 2026 17:16:00 +0000
Message-ID: <20261102171603.368298-2-pmazzini@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261102171603.368298-1-pmazzini@gmail.com>
References: <20261102171603.368298-1-pmazzini@gmail.com>
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

A station has no beacon. The XR819 firmware never confirms the
UPDATE_IE request, so the command times out after association.

Signed-off-by: Pablo Mazzini <pmazzini@gmail.com>
---
 drivers/net/wireless/st/cw1200/sta.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/st/cw1200/sta.c b/drivers/net/wireless/st/cw1200/sta.c
index 5d8eaa700779..f3f31aa52499 100644
--- a/drivers/net/wireless/st/cw1200/sta.c
+++ b/drivers/net/wireless/st/cw1200/sta.c
@@ -1744,7 +1744,9 @@ void cw1200_set_cts_work(struct work_struct *work)
 
 	wsm_write_mib(priv, WSM_MIB_ID_NON_ERP_PROTECTION,
 		      &use_cts_prot, sizeof(use_cts_prot));
-	wsm_update_ie(priv, &update_ie);
+	/* A station has no beacon to update */
+	if (priv->mode != NL80211_IFTYPE_STATION)
+		wsm_update_ie(priv, &update_ie);
 
 	return;
 }
-- 
2.52.0

