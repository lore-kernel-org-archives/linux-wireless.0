Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7213E1CF8
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 04:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790829945; cv=none; b=lK0BXhQ3wANeHF25FPdMaxFTkzimSyLjskb2BB9KmvucKbBRlaERQ68kaXG4IySAjn9Dfz10cykbSR3HcuM+NG390i8hiRpB/PCT9jQuIkq+z6S10t1W+6NEXjnUghhty+bhZikEfIG1fNBY5A3xXFQuQ/OFxjx+kwkdqS8ra+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790829945; c=relaxed/simple;
	bh=cSXL+FyasWHX9BJAX8tqgjRouttLDk5Tcanh9t3zTLE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uWnPQBhaz6KAwKd9T5YIzqX35RhhL+qwd1h+vQ+5Ggwrt9xnGi1W0P5d4x2acv/+/YWflydZXaVfwM8LupMOg0SlXUrW9thR83n7vAGeClB4Zv7wpGD9PP9Tqq0Wo0fwQnnFg3YM5F9R1NDlhdqEwzRQpMFnU91WUFqbfZMer34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lBOjV/Zg; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lBOjV/Zg"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-34abf779ac9so2028281eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 21:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790829941; x=1791434741; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qcb3FfIrBxLpO2EHSQg6zxkLxfR+fnWXXmdDoehAGw8=;
        b=lBOjV/ZgmBEHvu+ZaWFAzABCXR7w4B2SyTLy3fJI6Hn7ZfZSSjp9efIkFWzIeC2Ip/
         8z5tL+89wo8S75I+N6RxjtSHAPcx+pqAdhL3gxMyWYEG9sJCwunvWUb8AkwgBf7FXSC5
         Oao8BGiAU2us2u00/HfyNqkG4YhBwH29W2VCCWAMUXIBxpPoAzrj6nMaly6UON2+e2G5
         Ib/gS8CLFw1xrLNH008TR0+Mt2SQxYk0bE39P7n8NRoYOzWt0kS2hcCJlV43OwFb+/04
         NVmnRzwM2HLQORaHAd2BAQ83O/4x9V9M+CAVIat25RWUVTNmR33s5nt8XnFUjUxUXbAm
         Outg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790829941; x=1791434741;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qcb3FfIrBxLpO2EHSQg6zxkLxfR+fnWXXmdDoehAGw8=;
        b=X39ED4uArIQ3ueQJ3J3FmY3Z002JuGh5bk9Fy+twNoQduAALwmbKwL3u713hVz9TR3
         fYBMkqhHS5h/VQnrcg356EmpWDfKt93IhqkK67VSz6BlW20E+epK4RFF9J9acJV/WRje
         w5jFnHFeVbu7SIVffJ0BSj5BdIPZ4hdtVJwrBXvzCPqHj7EjUzcMCBLt64+yLS2P5ei8
         3uJod+GmIEnqhllJS+guKv1F/gdT5fJt7DB6L+p9sJogqjuJ/CFBYqQniAIioRW5ixEZ
         /MWcBvRQCHXjMI9AvNwFfHtV/emTs7fZOzoCK2BuIt403x5HoblWtEtyvFiwyBUqCeFd
         oZ9g==
X-Forwarded-Encrypted: i=1; AKwUvBxSzqc5RtXJ9taExU4Gce16RtmNV98yGQ++MtR59GSYyIYwpfkaCY/aD78iQJLBBGkjhUrFVunS9dOws92SyQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYL3DhDGR8g5lFYUTiU1LmkVFOQNLDh4fOqKCmt375rl3wj6dHEM
	ugKeUa2PacH03oQUctA2jPCf2yHmk6GBiezJVKUPtoTuVwKbNNKvHgAhcmn7gN7Q
X-Gm-Gg: AYBFou0pFyBZv/V1TuKTeIvjJtzwoxdjy/CcO8FoGscz1xfFcNoDofyThPmm71x+Ske
	HHHCUV0iWe8zqadjqInC7hdvgQ9iLimmwbS77PrsRt8KrHMqkUUe75zU0v8Ztv4Wlr+UVIUitsq
	4TumwBmI34fMn2bdvbKRj+swe4zP+ijvAxRSIA8JgKPXZUoMYix4t78ENZpXyVdRwDpCHfoHKvx
	H9veZfOqODpgrYflKpunHNcELPomRaouY+QOMNNAO2L66h1IqL756QmaCvr+axOusCOvpB4ZKMZ
	Q6meVIPhfNSqdJCdkVXH/S181VOA6i7UPpWNEGs53iD82YEOEuwVjmPfTKZINmJ6KMcD+1uDWip
	E1cCfrsYy1EDRcPhLYiCEIFso631L7gzPGE/8r7pxID3ppB8g4fcPIJGfYhCQ/AbTZy/78qYtAf
	wNKfxjWQViF/tkz2QESKNHnfzvVF0dn57AnO48ddl8F3PyV+fnKLAOzUNNntm7UizVc++WnFm4X
	Ap1T4C6IdJlboTP/ocsASA3pwlgt9412ccc8g1IbKB81VrCRH+kAvMMdFOokkA=
X-Received: by 2002:a05:7301:6192:10b0:34b:2362:90a8 with SMTP id 5a478bee46e88-34cdc4c0558mr3779399eec.19.1790829941087;
        Wed, 30 Sep 2026 21:45:41 -0700 (PDT)
Received: from dtor-ws.sjc.corp.google.com ([2a00:79e0:2ebe:8:9835:e0ad:476f:74a9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34db3e3414asm3891332eec.19.2026.09.30.21.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 21:45:40 -0700 (PDT)
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Wed, 30 Sep 2026 21:45:30 -0700
Subject: [PATCH 1/2] wifi: carl9170: Revert "carl9170: devres-ing
 input_allocate_device"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-carl9170-reverts-v1-1-7033b5716c14@gmail.com>
References: <20260930-carl9170-reverts-v1-0-7033b5716c14@gmail.com>
In-Reply-To: <20260930-carl9170-reverts-v1-0-7033b5716c14@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>, 
 Kalle Valo <kvalo@kernel.org>
Cc: Christian Lamparter <chunkeey@gmail.com>, 
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
X-Mailer: b4 0.17-dev-6c14f

This reverts commit 87ddb2fc29f10cf689ff0dfb88a19b7d3687006b.

carl9170_register() is invoked asynchronously from the
request_firmware_nowait() callback after carl9170_usb_probe() has
already returned, and carl9170_usb_disconnect() calls
carl9170_unregister() followed immediately by carl9170_free(), which
frees struct ar9170 (including ar->wps.name and ar->wps.phys).

Allocating the WPS button input device via
devm_input_allocate_device(&ar->udev->dev) ties its unregistration to
the parent struct usb_device rather than the driver lifecycle. Even if
it were tied to &ar->intf->dev, devres_release_all() runs after
carl9170_usb_disconnect() has already freed struct ar9170 and
unregistered the parent wiphy device. Consequently, the input device
remains registered on input_dev_list with input->name and input->phys
pointing into freed memory, causing a use-after-free when reading
/proc/bus/input/devices or when generating the KOBJ_REMOVE uevent on
unregistration.

Fixes: 87ddb2fc29f1 ("carl9170: devres-ing input_allocate_device")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/net/wireless/ath/carl9170/main.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 61c7a1288743..702b6d113b18 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1500,7 +1500,7 @@ static int carl9170_register_wps_button(struct ar9170 *ar)
 	if (!(ar->features & CARL9170_WPS_BUTTON))
 		return 0;
 
-	input = devm_input_allocate_device(&ar->udev->dev);
+	input = input_allocate_device();
 	if (!input)
 		return -ENOMEM;
 
@@ -1518,8 +1518,10 @@ static int carl9170_register_wps_button(struct ar9170 *ar)
 	input_set_capability(input, EV_KEY, KEY_WPS_BUTTON);
 
 	err = input_register_device(input);
-	if (err)
+	if (err) {
+		input_free_device(input);
 		return err;
+	}
 
 	ar->wps.pbc = input;
 	return 0;
@@ -2044,6 +2046,13 @@ void carl9170_unregister(struct ar9170 *ar)
 	carl9170_debugfs_unregister(ar);
 #endif /* CONFIG_CARL9170_DEBUGFS */
 
+#ifdef CONFIG_CARL9170_WPC
+	if (ar->wps.pbc) {
+		input_unregister_device(ar->wps.pbc);
+		ar->wps.pbc = NULL;
+	}
+#endif /* CONFIG_CARL9170_WPC */
+
 	carl9170_cancel_worker(ar);
 	cancel_work_sync(&ar->restart_work);
 

-- 
2.56.0.rc1.315.gc6ed9934b7-goog

