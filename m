Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793267283;
	b=fYuCxRmwOrxz2Em1MUCg+wcZLV7zv8kihIpWNRd8UkKX1leZDDIugbLUYVnwsQq3gvLb
	 JOkc8ExIXLXCHwQKnwpubf5k/e24rpPpyHvBWmTS9lRs+IYmDbRYySRlvL4B607Ph5wGD
	 BXVyFwaSZvJ2ewn6RTfCDwcO5Qh2qpzb7E/eReYHA8gm172yozTpWF0THtAhoWBcRUo19
	 wzFJbVWvOp1c7SHOHJ4NODSV3EvkezQiFbDv1ajg5enFJp41x3uZnmLimmGTIkAul2E9u
	 SxznPInq6ZdGg6A51f1rbFoW1O3NvC5M6UnPeWXMejMIibnmzM/sxBfMhmibeotyoDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793267283;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=aA4dQ1HDNVp6PloZLXeJ1kd3NLKw0188KeBSwOCLWMY=;
	b=PD7jd7EPfGM/QwiE2iHy+1qmvkBrNik4oJnV/fXRAlw+Gthfay+moCxi/UkxTN0WFqpi
	 FnJ4zDBwRV/gP2l06J78jLkyNZ8OzK4J9vv7Fr/7HdgMz99raIIDHK0zTZ5OdNEEquflJ
	 Ylm83N/aac8EJnOIvUfCwQwsJmMKjG/npZSUFdHul6b6CWN7VsYaCggfX8gvlIe/Qe/yK
	 CtWHJcnKnsIf3oVV4NLFxRqzdB+FdE52Xeh52G96weyut0SfRU5HSfWgeFBlf98vedT3r
	 P4e93/15BD3XWHDXLp93NzUffz2dIfA4sP2DoTdhvCrHckXx+eB3PtKzeVW7gygHLMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AVw43DXB;
	arc=none smtp.remote-ip=209.85.210.170
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7622A606A323
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 09:48:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7622A606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AVw43DXB
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8a07078200fso991929b3a.2
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 02:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793267283; x=1793872083; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aA4dQ1HDNVp6PloZLXeJ1kd3NLKw0188KeBSwOCLWMY=;
        b=AVw43DXBiUII8K4oi4Y9CYkVK44ibUTbT/35PQgwdH65QJHiKCdQnkdxjFOqDKpppt
         cXK9SDiuD1mh7L/uyLS8yunJYr/FFn5c//YgdwMFHjfS12T/bWYdHDqj+XXHNo8i57L3
         4IO6z14DdxtLa6OJnl8l9IunM3Q33qRmOPPPgy8IWF6RXN1wscg6XNPlGzG2iqf5WBYO
         EEc1TpAPwDt8IDhhPziHZgZBSWTdxK6ZMMtv9FvTnHschxj0ZVHaUi0Y8t1uJJQJq40C
         H5XuCNNnaHRiP6ltJDemWOJ6pNw/JLVsrXLqraekWZfYD45xmdBiGYvuFh8IciISJwdr
         aJeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793267283; x=1793872083;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aA4dQ1HDNVp6PloZLXeJ1kd3NLKw0188KeBSwOCLWMY=;
        b=Pd6EavfNirWEgZc1ZktyWX2Jg7+VhlO07MGBm1EpWW6I8LCMUDQkNxDz4fpW/TsTEj
         /e+bJTHMzVD/z3CzuvvAYtob84hSiBJ1IyB9A+mXgB7EPEvAzPTIWO7Q8di1zl8J77QB
         52wNE+32vruE80QkNVMPIAm7QvvN6HnTXk0cIubztkpTlP5uwyc74H3VvkC/9RSDpwun
         i60Zd3eTDf7O105pYnYn0jZLsjR8ifKZ2G0Wb5fbseMAiKNWCcIoSXrnaJfl/1Q9aKk1
         dTncYUXe9YIqkmuduGf+FTgAMgTkVIv69OTFrRWAhfenotLY9Trx8QK/aaVmtsPYVWMz
         Mztw==
X-Forwarded-Encrypted: i=1; AKwUvBxkAqbrL2pQi9KY7tm8eVgjaWZR/F6PFcA60n+ua9VicUdXzJBC4A0OXxTnKdPVq6opbZAvZmJpGeBPeDsjCQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLz6A5sPqspoSHbfYZ6VRDsznZwLqpHX5Toq1sNuKRh0eujMLXE
	s5F2PgQTpVgHzyiEArnUBWpzFQ91u2r3Ot4zkwslus5L70+3Wf+BA7Rb
X-Gm-Gg: AYBFou3w415ddUO8459SXJZCgz3tawuAyKnQPxH6s6nsywP+yfSPF+AJiyCRkIT470Y
	s2+4dpwl/Z8OvGzS/+MpeC41hWfImI4+M/cnObulbmFMqtR9MQoggE+U0LkZiXgo2BRoGwYcYzJ
	8+g5ZUchlpLpI2N0Ub3f0sj85B98BoW0K5fZeGb6sk7SjobXIpoDH5KaZdxjuYtYn1dGMEPhzHa
	+kLO/9HT2UbLVZzuE0id/apqiraJw8hCbK2VvwugepEyYwBiZNU4JhbIHn8RMMWqC8yoc9hoXxV
	rbLm6163XNmwqtGWnu53Rua7LLnpBZKVZZafk7Ps9GAGg6GFzC9W8CIZCoWHJqGFX6hZiwal/E7
	NlNzcPud5CDMaWB6ewCkyuFkiS5yYiu0R4BDLSd7nvnsjTPN5qvnVcvVN3d86XLIohGQdhjLLO9
	rkD8phTBD4PPF0HDWUZdE76HL5iNVeu1bOAZao/cpdRtQ97OfqpqreK6P/fe+kdihVpLDxt9PWE
	iMmsg2B9ZOGf4LmYDvjbIy2BPeSrQVD6U/Y2W5YeAj8QPYhUGIWNplrIZj1x3Y71r2ugIeK35SX
	e3QMyLzEhHe3l5HySGi1RivBSbH0Pbt77VnGqPZgY+JWTvbdPZz9QvX98c+S6hZglZitQ7uYXQf
	BahxpLayh4w==
X-Received: by 2002:a05:6a00:854:b0:89e:ba55:119a with SMTP id d2e1a72fcca58-8a6e83aa99amr3590208b3a.47.1793267282263;
        Thu, 29 Oct 2026 02:48:02 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a662b9f5sm2187143b3a.21.2026.10.29.02.47.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 29 Oct 2026 02:48:01 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH wireless v2] wifi: iwlegacy: unregister the LED if 3945 hardware registration fails
Date: Thu, 29 Oct 2026 17:47:42 +0800
Message-ID: <20261029094741.21162-2-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
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

If ieee80211_register_hw() fails during 3945 probe, the LED class device
stays registered after probe frees the il_priv that embeds it. The next
LED trigger registration, or a write to the LED's sysfs brightness file,
then uses freed memory.

il3945_setup_mac() registers the LED before the mac80211 hardware, and
il3945_pci_probe() unwinds a registration failure without calling
il_leds_exit(). 4965 already performs this cleanup: when
il4965_mac_setup_register() fails, il4965_ucode_callback() calls
device_release_driver(), and il4965_pci_remove() then calls
il_leds_exit().

Unregister the 3945 LED before unwinding a failed hardware registration.

LLM assistance was used to find the bug and review.

Fixes: 5ed540aecc2a ("iwlwifi: use mac80211 throughput trigger")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Changes in v2:
- Explain how 4965 already performs this cleanup (Stanislaw)
- Describe the use-after-free concretely
- No code change

v1: https://lore.kernel.org/r/20261028142328.18560-1-enderaoelyther@gmail.com

Validation: A W=1 module build with MODPOST passed. Not
reproduced; 3945 hardware was unavailable.
Sparse C=2 passed. Targeted Smatch introduced no new diagnostics.

 drivers/net/wireless/intel/iwlegacy/3945-mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index f7ca182d1494..5e11f0597255 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -3529,6 +3529,7 @@ il3945_setup_mac(struct il_priv *il)
 	ret = ieee80211_register_hw(il->hw);
 	if (ret) {
 		IL_ERR("Failed to register hw (error %d)\n", ret);
+		il_leds_exit(il);
 		return ret;
 	}
 	il->mac80211_registered = 1;

base-commit: 25e73f1d6868c759c8eb56cad4e411692c5341b4
-- 
2.56.0

