Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6D13ECBED
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 04:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790829946; cv=none; b=bFPcplwXS9XcrZ9crfqoFvubbyovzqQsibqK3T6Ui1u9PqSMD2cuu27x/u5fxfuSvhY2dtW23Hq96H2giM13XiNrjpF0XwT5SuTD4sRYUHNRwruHA5beBVaJwDrmZ+algBM8jokljO9T4EX/dFtPNgMkvMpgj4e/4aaJ73xTAUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790829946; c=relaxed/simple;
	bh=Kl59HLPtGA0YGI1jSQ31FQyI2MljJt0I0JDgqMd96vQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QJgOesmDm0y2bg9mOykM7fvn0zriKO3T8WySfS7rqWyzrIpy882Uw6XTN8Evsqcne2qyIJJ11Z+Z9rurSTJjp4LX0MnO6gzTvj8LgcoHzmC3uL8W1Hub3wJneLAbXgaT2wKvyUTSmm2XzYJs+q3YP8RrDJaNKzaAGqVN0V48bJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KtGUEc1M; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KtGUEc1M"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-34b48100af4so2076019eec.3
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 21:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790829942; x=1791434742; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YUMtS5RjOq3z0OjJOB6QJzFPbiRJk8TU9R7d+42yRmI=;
        b=KtGUEc1MpzaMNdo0AEU8WdAS4UbLweNXb6eZ6LJPvwu2fuQ12KMrCLQWB3qMOidHUu
         S/BJPNxFmZg4isUf3JwxrbCmP7NKOr2F/ERwoFSGkuHpEAzXBZ8FOM++VkeVxu6x+LlA
         yysfDny6CuPAPStbeQde1Gn5oaW8dTpybOUVq7M+03gL9cOs5FOz3ocC0cFOZEisHJWV
         n2n1HD4qzipBXpQx2tDw46PYEvlF2nCwMhqtGoQRdquPf7xxU0UBJLUiD+/IWzDiqpfB
         GJYGdg6jSzg9JfX/RmiX9AVoUkbhXC3muRBDsm9uG/gwhhcBScfCwuIDLZvSx8Eca04Y
         lLoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790829942; x=1791434742;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YUMtS5RjOq3z0OjJOB6QJzFPbiRJk8TU9R7d+42yRmI=;
        b=sEvvOBPhnefMJHkiY5PGZxPdZxSpgilolIHOUJEwlJ6C0fPpUjfZBsuzmX6BGerNK6
         adZp523vSk/r8JJPveorJ6Xa728eGVGjkdphDBTBnYQaZB+rdAZ4S0rMg3Ixo6Prk/sQ
         foOJYLppRf83GqS2NBDeHMxJ08Wd17n+nxyl1K4TF5mSERqg8CMas+nStmEANddELiRV
         lrECD7S9UytS8E3vPP7iFibB9iSb/Ziz0WlJSq8ZdlXlGhz+L1T4ut2kzr3Ro6PVsdAJ
         of19g6sGq5f22pthDqqtQ5cwzp8vb/D4JKRBmuEnR/seZV1/G8KhHJhgnBIp4GA0Cpr3
         vfhA==
X-Forwarded-Encrypted: i=1; AKwUvByOCfLsxmlKu2/eGbSROFzPUqPcJmRiF1hee4BG8oBCW3YPrs3X55cLtzOY5NIalRTF5GYzwlJqwlZRafxJLQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYKXADkAwEExrSpCbjgvzRP1v6uxOOeXaGVgXkZUfRFtfNr+VNmX
	kHd3vXWQURHU6t6ho9KOFLzpE8vAUdk59VYAdmKK2Sl3oRtkNO8fXkGcrimg7Kel
X-Gm-Gg: AYBFou0Nyu6vDxJdfucNOjtLFI/kCFzzN0xYIUXqwuNuVktcqd2hzwBWSxn/92VMv8W
	GlCosXtPIXhxYFlhfzCCf1iNgFtLTg6AE75+d0XEU2JGO6r/Irk7pwbvRUWWAwWOTBuFZ/lhXH1
	sy4VuzULXpGYwykMAumaH0NC3yVaQDJaHOSR0tRVYdEX9WjdFpOzyZgNQGXIjbyr8MZ1E0PmgZN
	40VMZ4v97xP/9po+FEUPBBPlwlug5C3ws0ws5HD1U35pClUKB6+X13q13/78BUW09Ui3zEjXHyc
	04dysKskk6/OPmh6Nfo8/lOhpm0kJ2FaNqMgshowOLL3UeIl3E80Fum+bAfPwQ9WwnanPx4oYY1
	ZwlFbK0mpzjVpl9MdS/MJbinC65wf5nV/9J8SsN1yWm2upDHhaTA0ESvUCaRnpjrx2r7Oc5eI2r
	pbIBn8EqBu0qIPZpLSLY9ojLxHqKI7LNVJn6zsbvKfVQ89cgZufuH+7wEioVjNg5240ncTHntRd
	Xx2uedpZcpeE4Gc06dajyr7MR8vkzEu7nx5AZf3FrErF47mgPkJOVpqKMQeQIw=
X-Received: by 2002:a05:7301:730e:b0:34c:d1f2:b56d with SMTP id 5a478bee46e88-34cdc0cd8a4mr3523736eec.25.1790829942306;
        Wed, 30 Sep 2026 21:45:42 -0700 (PDT)
Received: from dtor-ws.sjc.corp.google.com ([2a00:79e0:2ebe:8:9835:e0ad:476f:74a9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34db3e3414asm3891332eec.19.2026.09.30.21.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 21:45:41 -0700 (PDT)
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Wed, 30 Sep 2026 21:45:31 -0700
Subject: [PATCH 2/2] wifi: carl9170: Revert "carl9170: devres-ing
 hwrng_register usage"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-carl9170-reverts-v1-2-7033b5716c14@gmail.com>
References: <20260930-carl9170-reverts-v1-0-7033b5716c14@gmail.com>
In-Reply-To: <20260930-carl9170-reverts-v1-0-7033b5716c14@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>, 
 Kalle Valo <kvalo@kernel.org>
Cc: Christian Lamparter <chunkeey@gmail.com>, 
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
X-Mailer: b4 0.17-dev-6c14f

This reverts commit 23de0fa0d2a05ff71c7bc8df9d12c9f23be83f13.

carl9170_register() is invoked asynchronously from the
request_firmware_nowait() callback after carl9170_usb_probe() has
already returned, and carl9170_usb_disconnect() calls
carl9170_unregister() followed immediately by carl9170_free(), which
frees struct ar9170 (including struct hwrng ar->rng.rng and
ar->rng.name).

Registering the hardware random number generator via
devm_hwrng_register(&ar->udev->dev, &ar->rng.rng) ties its
unregistration to the parent struct usb_device rather than the driver
lifecycle. Furthermore, if carl9170_rng_get() fails at the end of
carl9170_register_hwrng(), or when the interface is disconnected and
carl9170_free() frees struct ar9170 before devres_release_all() runs,
the embedded struct hwrng remains registered on the global rng_list in
freed memory, causing a use-after-free.

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
2.56.0.rc1.315.gc6ed9934b7-goog

