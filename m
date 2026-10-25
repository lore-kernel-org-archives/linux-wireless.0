Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792951652;
	b=Adij0MHlJoZlyCUrLCdN7tvaIyoMZKmuG6r3+ZEAQWsswM3pANbnW5/uKrwaI4KA9/VB
	 n7f2Qa6spYApQ/BY0hItgZfUB75+H9XE0CePFwuzf6+OxZCFBdTgY7/D2LzxH6hUKuOOb
	 urL8jODGvs9mJ/HHbf3u5sTMUaEiyYy+tkKgap0kRcsEduPsbp/87myKm1WYzALUZWgh+
	 tbFkGwSDt19rC2LO4ppeuE+LLrEgd/2Jso/Ga0aoZCL5uxl5hbR/N5ubH7id35HT+hn9e
	 +fiqJBhQTbb/8CUrxEOq3JGjRd3NfyfKhj6TIv+A+Q8nmNABAGbuwFGcs6jwWMocdig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792951652;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m0Ydq/j/RR3Dd8rFJdmc4BDtehwDcl6LEDUrs2GefBw=;
	b=OXBcLq8oJg3bwIsH5jhs+Q3AkPiAGIJnCWtqOknxVG3Ju9Tz1MCYw+Icc2uPuGk+1ede
	 RiJSIw22rJXKtOuAAb8nLDYzyLKXU/dqNqayBWBRbjF+4HAB5V7t0lZppMmY8g7XR0z0l
	 jdk9vbx2LdO2avyluo3B4yPfUGBd0fWwuTmWGkJraqizPcuA0ZiHOVux/fyjWY5rODi6N
	 kHWGfmy1XN1ynyeso96MyRaI/Nn5M4xhYNUyu9PF1EkMayIxzWikcMkW8cBDyaTc+QCRw
	 3jkqCe/zWLkguDuqj1f85it/7m5eI72LnuyLgHOLFDdfKxrzO4bPhJQzTLm/+8OAHBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YZENF7MF;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A01606A31A
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 18:07:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0A01606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YZENF7MF
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48df4f540ebso1123920f8f.3
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 11:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792951650; x=1793556450; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=m0Ydq/j/RR3Dd8rFJdmc4BDtehwDcl6LEDUrs2GefBw=;
        b=YZENF7MFYp2iASoQnSKb6fMHyB+Ur17NlSLHLfambPG1WyYcjpD7Nv1gFbyFyXNvwr
         v8Bx9cG9Q/Sd8CKko9Eog/h5tkw2ArY9XeHTdf4RQU7mNXIM2yH3XbFXIEkGWCzN9IKY
         39XLZlyvqdxYPyn8uelhW9L6qDNgS9xaLZ7SkaDe4iQ2XpceC8XTpYtXZ+0HxzMZsliV
         Xziow0M5YIOYiXni0OlGZqcOdftfvWlQmjwHc1s+LqOeMOaSlM25b5lVycgjdYSI5Ew8
         ZHFyW5ss5Wa4TBKWaNhhz/3Yp8lOZUGN/MOighU1+8XSv1urwvnUoGdI2/ZvwIOKiU/S
         PElw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792951650; x=1793556450;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m0Ydq/j/RR3Dd8rFJdmc4BDtehwDcl6LEDUrs2GefBw=;
        b=zzJv+T2WWMs6icGyGpJ3Y+xbTI6fY4EOlVLvKHv1+2graFjHNehpBzqJrTRmv0t0e4
         lbjnOitL4JIgXHXrfs615ENClqQDD9rbVkXawmAQYUIqxES+GeEHtIXpMbZ9DZC29zRY
         nbeC56hl3LGqi9k9Bj4enR8tmDXk4NkeuNEzQSc3KjNcgLNK2TBl/dixS+uJ+a9KYolP
         umkzTXtinw+78N2F3k3WPVCCjIvg8jImvZgxt2g3jsGI7yrFe0bDVHTRGWwR3OxTGIqb
         /eaDJmz8PILUhVYXI6vRGLpyptuj4giOe3GIuEgPyNfh+8NoYT5Vrp828og5CZbtf1a1
         MKSg==
X-Gm-Message-State: AFq9FYK65/vbymE2VBBAFFLFTfyeci3wB6UfYh/cHtpBlBVCCcsTjaQM
	I09oOQPSJUKUGdy73G/g/cdpHYhIoj6lAcORWonQTOHpEUN8eZYF0t+/qYcf
X-Gm-Gg: AYBFou3gcKiJ6kKEY51NPb+r/nruip3MOE5TP5TuhJ9sPN1FE5Fmll8U+UEyRyMlNtF
	LNJYcsZJ8SiqYBySnGAUwRgy4UTEh566BpJR78rF/QtKxDhcPWhQbE1/kY9Fk0ung9NM9lBG8Lr
	fBZuyPOUXTlHfYNrO/aRZqq6W68KAjvQPTcqYDuDFKyLquXCNEFXcwOLUghzSfxsXteOUKQHMdh
	w9tp8WQI0zWF8/ppOiIwy+fV57HGFLhPwIct0/KXA+VqSMcyKRFMym6iFFfQFzT+1vcNgMDAH5l
	UxNeCojisJx3v3pqxw4ClC3LAqDmM/iDmpeDF5OESnJaLZdEK7G/hFAi6IBSECaZZp/iLZ94Xit
	KNJDzH4B/93F0d0MvG6ikohQMvfT/i+jsT53S3GOpC5bxHzXKbDLENJfLrtJ29ZX85Z1jMJUF2e
	j/VjtGU+vHmhahd6Ev8YrWw8K4vFuVcJ1JKMMBlhJCke8xSZLK1JDeAqAV3pnkbiE4cfr4DMMRv
	RAGsSw088va8peEJO9MK0z9RlJBFfQ2BsvslIA=
X-Received: by 2002:a5d:5e0a:0:b0:48d:f957:bca4 with SMTP id ffacd0b85a97d-48e3eba18bamr7432826f8f.44.1792951650070;
        Sun, 25 Oct 2026 11:07:30 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3eb8f37csm9333778f8f.8.2026.10.25.11.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 11:07:29 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	amitkumarjain0211@gmail.com,
	siva8118@gmail.com
Subject: [PATCH wireless] wifi: rsi: shut down roc_timer before freeing mac80211 hardware
Date: Sun, 25 Oct 2026 18:07:27 +0000
Message-ID: <20261025180728.3678113-1-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
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

rsi_mac80211_detach() calls ieee80211_free_hw() which destroys the
ieee80211_hw structure, but the ROC timer can still fire and call
ieee80211_remain_on_channel_expired() with the freed hw pointer.

Add timer_shutdown_sync() in rsi_mac80211_detach() before
ieee80211_stop_queues() so the timer cannot fire after the hardware
structure is freed. Also add a belt-and-suspenders shutdown in
rsi_91x_deinit() for the probe-error paths that call deinit directly
without going through rsi_mac80211_detach(). timer_shutdown_sync()
prevents the callback from rearming the timer.

Fixes: df771911914a ("rsi: add support for p2p listen")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 3 +++
 drivers/net/wireless/rsi/rsi_91x_main.c     | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 3faf2235728be..90b0fb80d91f8 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -301,9 +301,12 @@ static void rsi_mac80211_cancel_hw_scan(struct ieee80211_hw *hw,
  */
 void rsi_mac80211_detach(struct rsi_hw *adapter)
 {
+	struct rsi_common *common = adapter->priv;
 	struct ieee80211_hw *hw = adapter->hw;
 	enum nl80211_band band;
 
+	timer_shutdown_sync(&common->roc_timer);
+
 	if (hw) {
 		ieee80211_stop_queues(hw);
 		ieee80211_unregister_hw(hw);
diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 2ce5147666208..e893bba868b72 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -419,7 +419,7 @@ void rsi_91x_deinit(struct rsi_hw *adapter)
 #endif
 
 	common->init_done = false;
-
+	timer_shutdown_sync(&common->roc_timer);
 	kfree(common);
 	kfree(adapter->rsi_dev);
 	kfree(adapter);
-- 
2.47.3

