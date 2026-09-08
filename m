Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986823C3C0E
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 08:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788856069; cv=none; b=W9Lh4rL1f3tOhgNuPVO7b7zPTgi69CCbTubudAmwpfXDGwbLfkcrou6XU9a5O4t92ShsRxeMbeKqtVDULfMTQr1XDKNZzUFJPwEyQK7Y02S7H24jLrYqVVAj8gh9my/ro61VDEomAQaLRwShJZ+bdT5hlxo2dsIFarS2RqONI50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788856069; c=relaxed/simple;
	bh=wGWJGM/NS2T9XuzwoW91+XbZD5uWEEXTuVbuuctBpkY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PCxiqV1HPGNDAj23HBzmRdEy9+oUBhZGrUDTtKumYAHsuw1GrXKPJ6fMGaj72Yu5pqQhLRpIcb1BC72LeFtX0sxlDFuE+lBJAe7Bjxi3MdWJ/SyhfU19WdIKvUqSd34aq7Wap6sla9G8AvTV0L8cYGQop4Bt4Yvy0E6H8QryqNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I+q7KJ/n; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I+q7KJ/n"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38511175ad3so3697744a91.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 01:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788856067; x=1789460867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cDCa4a8fieQ7UPqOtYIBeaZ67Cj9e1mlkdWpIAId3Co=;
        b=I+q7KJ/n/b43/m1CfsFZ/ELR9WDP2Vi6jawa3zCOI/2VXyUdA3HFU+K5fLuWCKXhc7
         9bgUnRK1/dFDq/Tpvpq4h7BYpo08Iy6UQLe2u5dw5kdJM4Fsv4c5oijxMH1B5l8mp7p6
         QZyL+13qTH281gltcITaVrKcXjkVrMlSyJTiHuDuyxZiV7z2TDDBazRfSqGzV0E/Trzd
         v4YhrErCiB8hNie4/A6fTAjQiHxhlU3FbSgqCcjjqZ1nwF0xesaws4EuyHgqMhhm45Bi
         GyTNNzHNh2itYjz12IuLl9NfJFD1Ho0djuDmjGzjjXbDectLknK7HSMjFBNqp1vYD3dy
         A/kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788856067; x=1789460867;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cDCa4a8fieQ7UPqOtYIBeaZ67Cj9e1mlkdWpIAId3Co=;
        b=gLVy+Lpy5ugXY+hBQlPXAnNc2x3uIKLUcoyo5RwNz7h0fPPN7ZD331/TKLx2hrWP6a
         lunqXEKFPKsmcMSW590QIYDxmxfLED5xAZKhNjC8TibWlq4emuE11YWSc3ZfF3Igj0qA
         P2vQER0k9u9ri598wlAYkYrTkR04tZzZqS+0lCC6YHrG3jYsNBhXrwjCnMq2QyTd23s0
         G9IrpcjVHu6g3sLh4tm2x0vMwuZuaTUURCJjvQ25jpum3h13oNnJj5Exrjq+xFJTJgBX
         otoSMbAXl9+AjzTyi+Ad2VUr6Z2WFyLWFbCXoHOfRixSzIJeEAUzRZcLQ4JevWYFOxKj
         7aBA==
X-Forwarded-Encrypted: i=1; AKwUvBxFDOBonaW4/78QqceOt9T50XNkUs4AB1VkVydo3kdcpIOl10t14h5ZraqPBaAX7RbzBCYmLT7Ktw+RCOmEAg==@vger.kernel.org
X-Gm-Message-State: AFuF++maPEdwkvd9zeM1zyGk0ob5ms7Ok9gOgXp9oykqVZIZFvEq53VX
	R5jUIcsXSaAFnqmMrZ1kwCbnyQ5av+dpm1zNRT+sMQLJk79zhVhFu5Up
X-Gm-Gg: AYBFou1chjFmiFsgFCNKSnWpSMxJveGaRHgHgi9KDF2kiolBRlFau7iNKFZpEjfoOg2
	UZZ0H/M+kiO3nUOtYvWrMBL3ffgRLTA+lKpEX0B6kIC8d3ce7/UmSNWxUYR92xhkocaRNK5CH1r
	3Xr59LePDULZzdaV8sJFJp5rxk8OBJ929cgiwSsxPESKVohEk2KHXQVjNDA4TUghgNrOgEOU7+i
	PfrRXcbT9qQKtkVHAKWhzW2ZXpOH0AgPchDMHstMXkNfxXPhjA33FHvuySVnbrYvi5WjJOZA+4J
	qlZlzsGbQlj366D+NVqu5KXF9vjcGFYAfNF2nSEcbHuSSqKweUUeVaDOj0Z93Y26H/lE1qAKDiw
	mD3ueR+7X6InL9WGGuqJlPkFMXcBYqEBskbt4GMN+tzuVlAMJFtKxh45XxVeqYU98APaqzPq/4n
	fYYZFhVDs+zRLlSw4K0xkvCJubm4NryQ9lgqOS6IfX0WUl2agx0obv5HaNE/FK1gp+Rkh8F7Im3
	iaOj/PfcnE=
X-Received: by 2002:a17:90b:1b44:b0:398:ba96:1afd with SMTP id 98e67ed59e1d1-39b2613249fmr37760083a91.8.1788856066863;
        Tue, 08 Sep 2026 01:27:46 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db1495b57fsm55110925ad.24.2026.09.08.01.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 01:27:46 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: libipw: reject TKIP frames without a full MIC
Date: Tue,  8 Sep 2026 17:27:29 +0900
Message-ID: <20260908082729.209627-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

libipw_tkip_decrypt() accepts a frame containing the TKIP header and a
valid encrypted ICV even when the plaintext MSDU is shorter than the
eight-byte Michael MIC.  After it removes the header and ICV,
libipw_michael_mic_verify() subtracts the missing MIC from skb->len.

skb->len is unsigned, so a zero-byte plaintext makes

        skb->len - 8 - hdr_len

wrap to 4294967288.  michael_mic() then attempts 1073741822 four-byte
reads starting at the end of the 802.11 header.  Generic KASAN reports a
slab-out-of-bounds read once the loop leaves the skb allocation.

The ipw2100 and ipw2200 receive paths call this from a tasklet while
holding spin_lock_irqsave(), so the OOB access can panic the kernel or
stall a CPU with local interrupts disabled.

The trigger requires an affected IPW device using host TKIP
verification, an active TKIP key, and a sender able to construct a
non-replayed frame with a valid encrypted ICV.  This conservatively means
a malicious AP or a peer holding the same TKIP key.

Require the full MIC before entering the verifier.  A valid-MIC control
continues to pass.  A zero-payload frame with a valid encrypted ICV is
dropped without a KASAN report in three fresh boots through libipw_rx().

The KASAN reproduction uses a white-box module and the registered TKIP
crypto operations.  I do not have the hardware, so this has not been
tested over the air.

The initial candidate was supplied for validation.  AI-assisted tooling
traced the source and receive paths, prepared the reproducer and fix, and
ran the build and runtime checks.

Fixes: b453872c35cf ("[NET] ieee80211 subsystem")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
---
A tested source reproducer and full serial logs are available privately
to the maintainers on request.  They are not included because this
finding was validated with AI assistance, as required by
Documentation/process/security-bugs.rst.

The source-equivalent one-line change was apply-checked on every current
supported stable tag from v7.2.4 through v5.10.269.  v6.18 and older
require context or path-adjusted backports because libipw was moved and
the Michael helper was later changed.

 drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c b/drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c
index 24bb28ab7a49b..1fe543ea9dd26 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c
@@ -476,7 +476,7 @@ static int libipw_michael_mic_verify(struct sk_buff *skb, int keyidx,
 	struct libipw_tkip_data *tkey = priv;
 	u8 mic[8];
 
-	if (!tkey->key_set)
+	if (!tkey->key_set || skb->len < hdr_len + 8)
 		return -1;
 
 	michael_mic(&tkey->key[24], (struct ieee80211_hdr *)skb->data,

base-commit: da2ca406f45a6e21760243152ed8d2e8e72915c2
-- 
2.55.0

