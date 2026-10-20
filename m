Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792509880;
	b=nTsk5sylwHFIg6iw0tH5DUwrh/3VB4IJbqaw+FRs6cG3HP9Or6PvR7NZg0INOzY4Gq7H
	 Ai6vVp5+nf2wEU+Nv+qviy19XpefahVLNNSzAHGAs8OXBCE93n1E2QIqlcnLd2V3XtNcX
	 zT1tKjfbI0lFNQxyPnnXolSLM4ohAkrqVKZwDAUvEHLvh8Ia98k9uXq48mgvd9VP528Yl
	 qiLZvYpXgcNS+q2TA9ICEluBplQyAk7qSMYSjqVY1Nah76mmMS/UmO+UwVvzV2VDWmAJD
	 ZP3pQb6kz6opEzqq11e2Uw/mkSB1xblYmPtRnfkg9e/ERcKn6ekvCLBcsY9mB10o6CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792509880;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FFKFYTGpTq110qX3OBusAjjcUsko+0b14MxACIod3aE=;
	b=JVm4coS2RHmhkf/25T7a/JQhCDBYDQdrAc3UGDMOTkonNrxteEN09NF29yUoZrTI1/3Z
	 ENrRWV6SQNtnsR5RP+yn43EsR8fdwb6I5Lg+7N5ObLEsxRGjnoPb/wLJvaAoB37F0VXmD
	 xZXmx0EsmTV955STuIVy50e9MbB9Koo4zrQ54Ow3VGY2uKeWD0BKkns+pVK7WyRv/oaXJ
	 jV2uSekUmx7rZpxbD9UsPvwsMZW9y240h8f+1IaJukbUMq3QfUTSZPAKs0IyNe5xP9Zwj
	 0zreZU5BSBASJebECIIbjCzCZFlcnE+9tSdqtM3vVA6VgvgPyQwR80qHX85ucyQkmsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VlqAK4+O;
	arc=none smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0654606A333
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 15:24:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0654606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VlqAK4+O
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b1f31c63ebso1310357a12.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 08:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792509878; x=1793114678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FFKFYTGpTq110qX3OBusAjjcUsko+0b14MxACIod3aE=;
        b=VlqAK4+O4fAoKvoSRcPhhIDlfI6ZETlAY1GhZGMpDgijp3VIjQBeYdZuvyteCw8E4O
         853q8UMeEao9ukn5oQwcsp3eowxyyzyoErFlCdXzlxweUWWBDJxJgFT9id2as/FHfuPs
         /dqRQLeo/+nY7v0F1DW8Y2HJA8B81gjWdXN6TNBYQi4kVT8cYSGTddJok78G18DXME3i
         fMqXM0C9yFsx2O0PbdeNgsvtyqwJjvLLGmjMaDAzeYqJM2KvYWT4e2qEdzW8ZEXFOX7y
         hU5r5JUNqRH9lQT4pfeEfvZVVCYrDOd7vdrTNwL7bSRcwEVeTNtof7rzFxu/LfOxVLRQ
         8/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792509878; x=1793114678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FFKFYTGpTq110qX3OBusAjjcUsko+0b14MxACIod3aE=;
        b=sTzcx7kYy6e7FEOgCHP8dpacbdrvYas8KBwanG5hzQj25GEHzhEYr3/V9ROKpGLwzI
         hsgKwicdKNJLZoYCDfobvQjY5Mh1a0guxCHmUHwrTlctKQYhBCE4REoRCq+Ol2EuoS+9
         m3aPznpjaZVycIeBKd3rZL/y1nHKAzCj7hWizUCQ/1P7HuNWWJ43chp35AJSfnJNYqy7
         RN9nKBSGW5HxlEappi1D27DAmJMxdi0XfavYZR3jvSUBveQjrITNQv9Fz7tCA3G6luOq
         KbbER6hAjwBYqrumIQWEWudrjAVlOyzf0J7SEFNKvFe36HbOhG0PMeemYqUccwRWBstz
         TV6g==
X-Forwarded-Encrypted: i=1; AKwUvBxQmNEGxhsxqG2l71Fqmb8XC9wRYbtkMlJ+dElNCe0yR46gCjENbp553CceYKKbFWdI7vIzkpL9i4WM2I/kTg==@vger.kernel.org
X-Gm-Message-State: AFq9FYLcuhFNQ5MCZXB3qe/nRYt3BG2QRr87Npe103n3kNR92tf+Oydt
	VdP2VyjExtpSHyH12DM6n8feLxu4/UgwYlNO6ihtxKOUmzx3lpkA5Iri
X-Gm-Gg: AYBFou3+AAxI18x5t6Jo/zM/eVzhLdMtFk49bccgyy1MI7SingrC/3BtgoqwrPJpUjq
	b11ih3YZ7JmfAgsjaZ6p7MAgvnkFrhr2B8e/KR8dNOYYm3YtXDSlEZaFxIOUFOXBTevajgAD7g2
	qoArNGyN4d/j8+/2hUUXXsi8o08PgLTmy/uN4bIDb8TBF/C/VJaB3JmJAQH6UX8h/tW/6pCKvYd
	sZHtmfHZPh1KbBsvRvdbimy5dYRVmebkqA+sqL8II4Wk9D7EXROHpsX4GDoR5hmWe3HTvp+F8Sz
	kS77QqvLCAGkP1Z2E452pbiJ9R3+EOf5ss5CxVHl//HPLTQiSonGx1FnOphTlC3rIn+br4ivqdh
	sWlc/0cD09MJ2BVeG3COEf4kt6xrzC8e4lx53cLr4pPIeAZ64O0oL6QqK/VHN9WeyNX7BiiKIrO
	Vpf6irRfo3+KzXN0Oa/xgnpQuYFb7qis5B74ILPUKdMBzVsIQXfpSvpZA3/loaNl6ZLndw2aZLK
	kyMtk5oFzgINbsMtHIwPREf9orIW3WWvALo8Acbp1ztfpZyTxgc/M5YportBrOpgDt2QT5VFgqI
	ZcZswBYAVtOKY3TRcFekTIYXfWYSU5UknQ==
X-Received: by 2002:a17:907:60d6:b0:c2e:616b:6763 with SMTP id a640c23a62f3a-c4600c87ff6mr231572266b.3.1792509877921;
        Tue, 20 Oct 2026 08:24:37 -0700 (PDT)
Received: from Martyna-s-A34.localdomain (ip-80-113-116-3.ip.prioritytelecom.net. [80.113.116.3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c40919bcfc5sm488110466b.59.2026.10.20.08.24.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 20 Oct 2026 08:24:37 -0700 (PDT)
From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mehmet Fide <mehmet.fide@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] wifi: ath9k: don't read past short WMI command responses
Date: Tue, 20 Oct 2026 17:24:11 +0200
Message-ID: <20261020152412.95560-2-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261020152412.95560-1-mike.michalo@gmail.com>
References: <20261020152412.95560-1-mike.michalo@gmail.com>
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

ath9k_wmi_rsp_callback() copies cmd_rsp_len bytes from the response
without checking how many bytes the device sent. A short or empty
response makes it copy stale bytes from the uninitialised USB REG_IN
buffer into the caller's buffer, e.g. into the value returned by
ath9k_regread().

Commit 93ce8ea70451 ("wifi: ath9k: reject short WMI command responses")
failed such responses with -EMSGSIZE, but AR9271 firmware answers
commands that return nothing with an empty response, so that broke
normal operation and was reverted by commit 90201351a862 ("wifi: atk9k:
Revert "wifi: ath9k: reject short WMI command responses"").

Copy only the bytes that were received and zero the rest of the
caller's buffer instead. Empty responses keep completing successfully,
and callers no longer see bytes the device never sent.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
 drivers/net/wireless/ath/ath9k/wmi.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 44e91815a1..76c8dfcc53 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -204,10 +204,20 @@ void ath9k_fatal_work(struct work_struct *work)
 
 static void ath9k_wmi_rsp_callback(struct wmi *wmi, struct sk_buff *skb)
 {
+	u32 len;
+
 	skb_pull(skb, sizeof(struct wmi_cmd_hdr));
 
-	if (wmi->cmd_rsp_buf != NULL && wmi->cmd_rsp_len != 0)
-		memcpy(wmi->cmd_rsp_buf, skb->data, wmi->cmd_rsp_len);
+	if (wmi->cmd_rsp_buf != NULL && wmi->cmd_rsp_len != 0) {
+		/*
+		 * The firmware may send a shorter (even empty) response than
+		 * the caller's buffer, e.g. for commands that return nothing.
+		 * Copy only what was received and zero the rest.
+		 */
+		len = min(skb->len, wmi->cmd_rsp_len);
+		memcpy(wmi->cmd_rsp_buf, skb->data, len);
+		memset(wmi->cmd_rsp_buf + len, 0, wmi->cmd_rsp_len - len);
+	}
 
 	complete(&wmi->cmd_wait);
 }
-- 
2.43.0

