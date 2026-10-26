Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793013717;
	b=nnQGxOL/074krbFsuPsp6vg0a35kRNEVZM3YgpXEdO00Uo4BazlDxgZZ39WfsOUJL8Jo
	 O/qKvGWq57jsa+07jyNfDEf4B5u8/ulN0VxfPpm0tRWcGRKKIha1DKRHJIx0+QEfh84kx
	 yxWrM9ITel85zi2rAkf9aZ5YLtLjloKZ7lWC+Srhe8TfR6ce/s7kFuVo5eYBd/E+xMEJS
	 CYqWcfrHiXYMRRh7Xvn2h9y3SyLAQL8oGErKlSZTqMt8tupdTuOJMbJqO0OhV5rz3Nd9o
	 fCjD+4vehG4qI44MnOFPLt+YuS1IgMae/n2Xq/ZCCkvQp54jr/PoqDSiAeegbXeRrRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793013717;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ab3qsq0Zm/wtrlV42bZPrMrfiWNQtv9iNLW5xd0R+EM=;
	b=cYVJY77mhArmP/uhiSj5x46sUiZs7bpSW0V58AzSxG3Ld1kyGi7Ive3IMDHvtqlPAa5v
	 1B/aOZeQ4ML6plRlQZRUGXf+wRnxiZeFr0DAcLKKSZmUjb+lKqarsIRIzHhLpas/pOg4X
	 5MDU9+FBPYfcvZXrmtELMCALIJJtNmYT5cQgv5vWImM9VuoDYdBEMqkc6M6Dh0IidQ4LB
	 b0J+huGipYZ7iZ5QqrEi4MHf7y3UXbWNUh4z5m2pJGcA/VtY2ZxRXvfl1dqKVogNtIcvA
	 cOyboeqoahMdF8u0lwoiqp3yNu0rE7QRkURO5ZA/lKG8vxBOqonfdY1LkwHXtIqG/5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=HdjiHgPA;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF54606A332
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 11:21:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CF54606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=HdjiHgPA
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48c45111bebso1277485f8f.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 04:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793013715; x=1793618515; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ab3qsq0Zm/wtrlV42bZPrMrfiWNQtv9iNLW5xd0R+EM=;
        b=HdjiHgPAzwt2JgdA8b+cpEzFUMRzTseR+tU8GvQdsFatxrRF0b3mVOviRInlkvJdZo
         rCqKmwQ7mFhleew1GAsOe0yU0+VOk+57HdtMp5pMhJ3TVz4XQ/On2jnDmOLuw9SF94BE
         MjFUY1IN7EG37pQud43tdpITRvJo9K4G1Sr808f02MhPzjZ/qy84pm60Wi2Gwcv1I+C4
         5aSTq7PL1gREjfz1DFxHsxduoqSMls3XdU1I6zOyN2H42TGgyyOSPHR35fgB6I4wKvNX
         QzsZdfmokJji7OqFUAyRKIZ3+U/rxIqdF++wwI0H8VmLtP6kVzzlIDao/mMZhb16vlX8
         GBBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793013715; x=1793618515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ab3qsq0Zm/wtrlV42bZPrMrfiWNQtv9iNLW5xd0R+EM=;
        b=T9T5ObBh1pN1BS74cz1rAJBVpGjyG755pXvH1j+KWZCThBYU9yK7J8QtJ3Nqevaitm
         Wv7dreulcWM0usz3p7jDQWRW8hdL3uywNas5/4L/8zgLuaNw8qwWA+M1AC9FxajcOw5d
         a0p0XtGc+WOvSM0uopHgeK2ab2g92ZIyPvLM24H5jn9IUM2R3bfrVr01NLt+sC6eIY18
         wBanj/kJGxy9t4iV7II0AU+7nCpyaYnuWE9mutvp3oegvVxGbagXf36qw10MgoEUoTC4
         ljNfUqjSs84XRlqFAJQzBlZNWSiPuVaPi7x8nWoy4UvHbw/sDSa4/5LkwWd18oe/1Exb
         5Sbg==
X-Forwarded-Encrypted: i=1; AKwUvBwu4EgD1GH0YJAlMBF/zTv1niF+/5OkPqMGtIYFHZmBK04Zcxxg6y1QN5z6nnE1OUk1/+4RpClOFFPPTvYf5w==@vger.kernel.org
X-Gm-Message-State: AFq9FYKivlkqzcErBdPdMJ4Iu8urVePp+u1n10tpYjPUnRqM3IyvYPLj
	t9nZG2L6Uq+V8/puBuCsHDO6SU/wcnRyPls5Ms5OyVB0pf9tPlr/LHQ=
X-Gm-Gg: AYBFou3t1FLgM1vtmAxWf5PjbhOWBSkOm1O1aJI4kDgH2WBoDfAbFE/VzMuIEG8tUgP
	G78AvWIT6R6WUNwQyb4e7Fo78bevuaBKxtDf0hTsGBtTmXzvCFneE4VUEB1WChiw/XyDkJ5w3Wx
	D76hIb8+jKpqWjq7DUFW4UstzHJKfj566uRDJWY3tVUjiHYr8GhRf+NdkMRZnlT36iDKBQdbg6C
	U6QY+5napAqcGvCuaCOfcmJDopd6HT5JiGaNgP8QixHug32bfvdzPoG9txkqFCKQoEqLBQ+uWUG
	Cw+pXHMP5DBoGCDSw7HzxGZcOHLR5OxJFm3Hj/zBczuqGS9hsh2P6/w6ijrXB5SvvEbl1SM6Yyr
	TPaGeA6wTRW79VVm5D+I0HasHgUUI74BZwb3iwygv3gGYT1A2Cmk23Tcr7MlaNGBlGbGPZOmatG
	7ctdb6MVDYaoOuKReoGz5i9eag51jFYU2wCl4tJcaCvMWIeAJoIB+aj28MkbgtrtxrN3h/CyOgN
	Dx5hdZf0AlAA4WGzwJo1siS
X-Received: by 2002:a05:6000:24c5:b0:48c:69bd:e971 with SMTP id ffacd0b85a97d-48e3eb859dcmr11804667f8f.16.1793013714844;
        Mon, 26 Oct 2026 04:21:54 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecdfd8dsm15048703f8f.56.2026.10.26.04.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 04:21:54 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Kees Cook <kees@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless 2/3] wifi: rt2x00: fix IE parsing loop bounds check
Date: Mon, 26 Oct 2026 11:21:50 +0000
Message-ID: <20261026112151.2515228-2-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261026112151.2515228-1-tristmd@gmail.com>
References: <20261026112151.2515228-1-tristmd@gmail.com>
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

rt2x00lib_find_ie() iterates over information elements using a loop
condition of while (pos < end). When only one byte remains
(pos == end - 1), the loop body accesses pos[1] which reads one byte
beyond the validated buffer boundary. The read happens in the bounds
check expression pos + 2 + pos[1] > end before the result of that
check can prevent the access.

Fix by tightening the loop condition to while (pos + 2 <= end),
which ensures that at least the IE id (pos[0]) and length (pos[1])
bytes are within bounds before any access.

Fixes: 1c0bcf89d85cc ("rt2x00: Add autowake support for USB hardware")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 4d94b7062f440..5623ab11c6142 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -564,7 +564,7 @@ static u8 *rt2x00lib_find_ie(u8 *data, unsigned int len, u8 ie)
 
 	pos = (u8 *)mgmt->u.beacon.variable;
 	end = data + len;
-	while (pos < end) {
+	while (pos + 2 <= end) {
 		if (pos + 2 + pos[1] > end)
 			return NULL;
 
-- 
2.47.3

