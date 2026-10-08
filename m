Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF586483BD9
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 09:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791452398; cv=none; b=UjXxQ5L2bB6bqZ98EKyHIOm8U8TkEFHyEhIs0J11S6YLr4M2XrOfKO0EoPZeG7HGxkiQzkPH/jt3h7Gb1fPUNKEbFZOh9HaKhP89BPljPEQ5K1D1rCooEigrznayVEShc4vXi3a7xkyItGYwSPbxqTYixVz8h/21AMEO4Wogi/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791452398; c=relaxed/simple;
	bh=s7TN/7DaZSQtAFpuMU7K2xGC/Cz7TyKSI0wxoOHf2yQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CF1ZvwrfRU1h71C+dsuuw0asxxfDtYVTOYbZriMM5c6m3LLg0JiEeiFnFFPDm+YU3o2Kr2Qui2eVm5SY+TVSoh7/ObDnWdjH3diM+15ix/DhdV8gaZZ1hV+XFYF6r8LTpTtY1JM1yhrzuEz7D7U8lfi4L0js0n5eKOLPeFR9Ouc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JPzuBL0V; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JPzuBL0V"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-3514b90bb89so4330460eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 02:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791452396; x=1792057196; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZGNeCe/ZoKzEMv+TkjDlhnFjoO5jcCxTWVNHD8J+Fqo=;
        b=JPzuBL0Vr4uPsuTFB3IcHo4A2ZedbzlTH8cuXpjRoTih5uuZc2BmGUPvLbM2Y+45ux
         Ayz5tn7GT3cyfoHUS09yoV+KnXIGuHSEC4DYhu0QojABWXqvAOyGsFYY3cX27bfFboS6
         5+0iuy9XHlTpEXpaj0ZI92h2yqsyA2TTiDAHCxn/ZMjNSjU5qR+R98/p2nYwTFVa8NJb
         IRSNbbEMlQKIHrV+xZRCPxT920GUen6FDXwYWh1PItUF0IyaGUky/FIWaOZrn1fQWGJ7
         0iWhUe/3VpkC43Pccj5YQxsHH/uQdZuoDyV9Z65lFJPjwkcDBLk4KcGW1TRB4xITswl2
         gwWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791452396; x=1792057196;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZGNeCe/ZoKzEMv+TkjDlhnFjoO5jcCxTWVNHD8J+Fqo=;
        b=oKyMtgSUegDnMgfoa5gJw020IH5FE9nBfawkCM3uz7B/Q9g0Mio53yNklknA83xI0R
         kK5h7JDg4UFNyldWYnXgh2fExXRCnUWmAwMy1RyKdl2tq7ufgJhqcyUilEnmaY6rouZA
         2Rt3vW431UGR6lKccynIpttlp6i4Z8f4WYEoeQIY/gZyIJozOTMuiqzBX09JRbc8gPC5
         uUtz/NQxi9OuVmTMxJ4/hRH9EschmknhhCvqLMafiDS/5PGfKOOG5EEPZiyY9F/ERFHf
         FGtdUNIp4wddMgwYslP8vTrEDPYOmQOUGu63HjSemRB+TEHjYb2+SNu5oImXhy+WtcJT
         gNJg==
X-Forwarded-Encrypted: i=1; AKwUvBwUVrQEeQbtlIXKfZPomSSrF6CPMhCNCTsy3w9ubal0enbR4ftwPQ33sTmvmpbpbTfgRcwp3na7vF3cHZMs9w==@vger.kernel.org
X-Gm-Message-State: AFq9FYIeRr96wBciu5jzQAdaTSe5MMH+G5poyAryQTa5BBgDO48Ke3TO
	TKvUgzWCGhMCVoP6ithpoHeZ0Tagr2dcR/BPw+Z7vZRokJJ9Ym6i9C1R
X-Gm-Gg: AYBFou2GXpBbZVKPC6e66gsWIf3nll+sSSHIyEUT+WKk0hBhz5wlBcEdY9LeEp1uHn8
	/IpOxH7aOpT3hwjBeXWvbCs0IMerPYih5euIBQruHnJ8gPZHEJoXN+qEu/yKr7uK3tC0Ys8OL3d
	pt1M7SGWOuuzVO5PbYr1ycCWctKJmYqkkJmcv5XAS8PmB2880UyKvnpDZj4F9D0efigI9O9v7Zi
	P4+rw1rw1kHUPTgrY9NQJzP96l7Mugws7SowgjVW9RgiJD/1A0nYqyBmfCCML9BcMvhFyYHPkK4
	sJM9PxQUqv8wl/7H3k0qdpg1DIDZIjRVyE8WmrJzDfmcZjv9as6VrIXeJHo85C14uw9+06DFLLm
	I0aNLFb29IqdFVUSdAP7tYjh7SwviZwdYrXIrMnsKmLtQ7kZiekvWuyJwSmYOPVuZW49foCQ+I3
	TRbToN6pN4KymElSeynIaV1JvYnOvP59VAmlyFPMA0MBkNlSAxbiTind7sdmBDi8E0RqdhbUr3Y
	HwZwS1ct2sBDnqE8HazyhKD+9MnLAZMvkOvnW1fwGjZ02SOGdb3UGFvR/7pp58=
X-Received: by 2002:a05:7301:7187:b0:351:1c52:3869 with SMTP id 5a478bee46e88-3515de76802mr5767814eec.41.1791452395823;
        Thu, 08 Oct 2026 02:39:55 -0700 (PDT)
Received: from dtor-ws.sjc.corp.google.com ([2a00:79e0:2ebe:8:3002:e11e:c053:ebcb])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3517810b895sm6873252eec.17.2026.10.08.02.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 02:39:55 -0700 (PDT)
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Thu, 08 Oct 2026 02:39:43 -0700
Subject: [PATCH v2 2/2] wifi: carl9170: Revert "carl9170: devres-ing
 hwrng_register usage"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-carl9170-reverts-v2-2-3ecb12089797@gmail.com>
References: <20261008-carl9170-reverts-v2-0-3ecb12089797@gmail.com>
In-Reply-To: <20261008-carl9170-reverts-v2-0-3ecb12089797@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>, 
 Kalle Valo <kvalo@kernel.org>
Cc: Christian Lamparter <chunkeey@gmail.com>, 
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
X-Mailer: b4 0.17-dev-e6826

This reverts commit 23de0fa0d2a05ff71c7bc8df9d12c9f23be83f13.

carl9170_usb_disconnect() frees struct ar9170 inside .disconnect()
before devres release (and devres on &ar->udev->dev is not released
on interface unbind), leaving the embedded struct hwrng registered
on rng_list in freed memory. Furthermore, if carl9170_rng_get() fails
in carl9170_register_hwrng(), the HWRNG also remains registered while
ar is freed on the error path. Revert the devres conversion to restore
explicit HWRNG unregistration.

Fixes: 23de0fa0d2a0 ("carl9170: devres-ing hwrng_register usage")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/net/wireless/ath/carl9170/carl9170.h |  1 +
 drivers/net/wireless/ath/carl9170/main.c     | 29 +++++++++++++++++++++++++---
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index e66e3e2ae952..03a94a5a209b 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -454,6 +454,7 @@ struct ar9170 {
 # define CARL9170_HWRNG_CACHE_SIZE	CARL9170_MAX_CMD_PAYLOAD_LEN
 	struct {
 		struct hwrng rng;
+		bool initialized;
 		char name[30 + 1];
 		u16 cache[CARL9170_HWRNG_CACHE_SIZE / sizeof(u16)];
 		unsigned int cache_idx;
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 702b6d113b18..8ca76e9044de 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1545,7 +1545,7 @@ static int carl9170_rng_get(struct ar9170 *ar)
 
 	BUILD_BUG_ON(RB > CARL9170_MAX_CMD_PAYLOAD_LEN);
 
-	if (!IS_ACCEPTING_CMD(ar))
+	if (!IS_ACCEPTING_CMD(ar) || !ar->rng.initialized)
 		return -EAGAIN;
 
 	count = ARRAY_SIZE(ar->rng.cache);
@@ -1591,6 +1591,14 @@ static int carl9170_rng_read(struct hwrng *rng, u32 *data)
 	return sizeof(u16);
 }
 
+static void carl9170_unregister_hwrng(struct ar9170 *ar)
+{
+	if (ar->rng.initialized) {
+		hwrng_unregister(&ar->rng.rng);
+		ar->rng.initialized = false;
+	}
+}
+
 static int carl9170_register_hwrng(struct ar9170 *ar)
 {
 	int err;
@@ -1601,14 +1609,25 @@ static int carl9170_register_hwrng(struct ar9170 *ar)
 	ar->rng.rng.data_read = carl9170_rng_read;
 	ar->rng.rng.priv = (unsigned long)ar;
 
-	err = devm_hwrng_register(&ar->udev->dev, &ar->rng.rng);
+	if (WARN_ON(ar->rng.initialized))
+		return -EALREADY;
+
+	err = hwrng_register(&ar->rng.rng);
 	if (err) {
 		dev_err(&ar->udev->dev, "Failed to register the random "
 			"number generator (%d)\n", err);
 		return err;
 	}
 
-	return carl9170_rng_get(ar);
+	ar->rng.initialized = true;
+
+	err = carl9170_rng_get(ar);
+	if (err) {
+		carl9170_unregister_hwrng(ar);
+		return err;
+	}
+
+	return 0;
 }
 #endif /* CONFIG_CARL9170_HWRNG */
 
@@ -2053,6 +2072,10 @@ void carl9170_unregister(struct ar9170 *ar)
 	}
 #endif /* CONFIG_CARL9170_WPC */
 
+#ifdef CONFIG_CARL9170_HWRNG
+	carl9170_unregister_hwrng(ar);
+#endif /* CONFIG_CARL9170_HWRNG */
+
 	carl9170_cancel_worker(ar);
 	cancel_work_sync(&ar->restart_work);
 

-- 
2.56.0.385.gd3acb90ef8-goog

