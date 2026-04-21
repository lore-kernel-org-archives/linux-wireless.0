Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC323D8114
	for <linux-wireless@vger.kernel.org>; Tue, 21 Apr 2026 13:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776779398; cv=none; b=MLJE8KfkRYxhyrX28RNUP90MHb7f2iKjvdGreOgYjaBtHG1wTduF3RpZcq1yWta9e0YIeXG0/m0Zpq81rHVezIHzdXhQeAUTPiLCfdSQZnWBOKImyrSDFwGuY1ycrtk2USx0KanTD/NXrRvm8+AP9xPUh0i6YQXi+R0biW4b2NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776779398; c=relaxed/simple;
	bh=VQJmGeicKEsi6S1aknxYXPHkbMtvDEapOhVDhRsNyb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9PA/B8Ri6BiSDsId7bsNSyTwZ4t+x+0cD6yJAV9CNxOLH52l12Ia0wEQ3aXuZn18Q916ApCLnAtNpQHXVnUnVz0WX/D1PMZaTPTmc2O5yCX19FV5oLshEF+rJRgI/i8SBA77vJ+ud/c2COJ5q1xz/s6qHtgu9+QO65JbJRbQnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OUJtJdOs; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OUJtJdOs"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4890098abbaso29139665e9.0
        for <linux-wireless@vger.kernel.org>; Tue, 21 Apr 2026 06:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776779395; x=1777384195; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XW7SuI64R5lXg3EcFdNoYLk+o32d4vhook9t2qciYl4=;
        b=OUJtJdOsxaoIeEDmx92xeuRCER3C+Hd8QJwVrboQYm2MTT5riRyXks6IeCSBiJaRij
         7U++RfRQVKsycwu4D5aMaZmJsuzUeYOuiHfBNiOZfkKo4UeHgrBLUgDpkyZKFKEXLrtm
         OFaG3n2/JSjjvS6MuwbpuNhN6mRMPBCJZHyiE9rD6TqHAt7EF+jdYJQ3cUr8Izu/9gQl
         nSNVz5PFRjT+etzcomgb78QyUh9GAXxfSbZQBS+jD+zNUDsdtzzoDFW5srPeUZCP5HaN
         0P91A9RAFgdc2I+F7JYysdtiyD6Bd1u1slNkb7Azf/O6qP2gzELEo7nhaY+ua8dUTGTe
         IRuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776779395; x=1777384195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XW7SuI64R5lXg3EcFdNoYLk+o32d4vhook9t2qciYl4=;
        b=JgurrfiR+DLG25G/UbBPSYO85ZHx8NhixreiBo4XTodxiIIs7U5JGcG+ejgrTDtUoK
         U30wMvzxRUPTsjt2O6mzF4yBS2swuCX54+k81U65nG1M9fxGbL9xc91lfMK55T5KxlGu
         TJPJYZwsedVzvXfsct5uxgnIBoPxVj1EYddz8KdPcGYXbyHr8nP9YWP30WBbZtAUeFcx
         O+VcTS7okbV2Jwkj1rGrbaYTNli9ND+ux85fQGOPEIVd7+4Z+tBOTZT2JUod8NUsD+CH
         dkEjsncjxnhTy3JvDQita/SjzopNr8FBNFwcSQOx4ixDpsu1+8AGU6Y7+JdxRjDP5ZdW
         49bg==
X-Gm-Message-State: AOJu0YyMZk/Xn+Wg3lGXX1O3P6KTUbBaCaqrkGMTeMXR1Y8krUz3q+wF
	zPslQOHQEZQFyWsIuFo29YYxqGREp3kDYUPazUn7zD6ESci8CP2vWzza7taE
X-Gm-Gg: AeBDievelvAaDJNeDR0Du29GpP8TbStSA4i1B9oFI78WXWGjMn4N8uYyCzQ9tWnzZHb
	dvg5LAOtj4hzz2FB34Ju8ILAywrRTfXgNQa1/YWOQSnLexRdL41e3+eT/gq7gugBEE08YIHXZPj
	uePVJSPEy3BSrPifXRuVT7UEri9DGadlbWBbb9vBZyaT72aEeenjjnCd/fXCbPVfTmVC7YO92MD
	iIbDI8Kuigo3qmBYY49t9ZW/dvDHcDtQfbnDvvICdHKssN6QOhbb2bsKB6LRPlf7dnqVUdCLXS/
	F2CFIyZGQrvRHDAMNKIbgXgfRPI7blqTG2vt/IqOtvOqY3t18eEzk5rrMqxk4yDcW6d+l+M7bCo
	7tGEU9BLhXghsF4IrXNU9UeNvzPB7Db65pXOpbdipr9NzlDvwlJOEjQ/jNKcJ9xAQM512y+lyCp
	FZpes=
X-Received: by 2002:adf:f2c7:0:b0:43f:e44a:f276 with SMTP id ffacd0b85a97d-43fe44b01a5mr20217458f8f.3.1776779395152;
        Tue, 21 Apr 2026 06:49:55 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb13a0sm37671480f8f.8.2026.04.21.06.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 06:49:54 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH v3 2/3] wifi: wlcore: fix OOB read from firmware max_buff_size in logger handler
Date: Tue, 21 Apr 2026 13:49:50 +0000
Message-ID: <20260421134952.338301-3-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260421134952.338301-1-tristmd@gmail.com>
References: <20260421134952.338301-1-tristmd@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

The firmware-controlled max_buff_size field is used to compute buffer
offsets in wlcore_event_fw_logger() without validation against the
4128-byte kernel allocation. An inflated value causes out-of-bounds
reads from kernel heap, with the data written to the debugfs-accessible
fwlog ring buffer.

Cap max_buff_size at the allocation size minus the header offset.

Fixes: 3719c17e1816 ("wlcore/wl18xx: fw logger over sdio")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
Changes in v3:
  - Regenerated from wireless-next with proper git format-patch to
    produce valid index hashes (v2 had post-processed index lines).

Changes in v2:
  - No code changes from v1.

 drivers/net/wireless/ti/wlcore/event.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index 6c3a8ea9613e9..26c74dfcaeeff 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -61,6 +61,13 @@ int wlcore_event_fw_logger(struct wl1271 *wl)
 	if (actual_len == 0)
 		goto free_out;
 
+	if (le32_to_cpu(fw_log.max_buff_size) >
+	    WL18XX_LOGGER_SDIO_BUFF_MAX - WL18XX_LOGGER_BUFF_OFFSET) {
+		wl1271_error("fw logger: max_buff_size %u exceeds buffer\n",
+			     le32_to_cpu(fw_log.max_buff_size));
+		goto free_out;
+	}
+
 	/* Calculate the internal pointer to the fwlog structure */
 	addr_ptr = internal_fw_addrbase + addr;
 
-- 
2.47.3

