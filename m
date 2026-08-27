Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178AA26B2D2
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 12:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787834969; cv=none; b=g2GSYrVqK6HcRcg0QoDUJidB1b3hAz/XOisKh6MWw9CUQ5dbYCIUfAguOLVqnFX3JBMiSKE8SB6JNNQ5R+5tamHK3ObNIInJ1KqBVlKKVuDMGMbqFs6A4IxRs0RbqHFBPtiZcYX3MC4y0yXT3Etf6zKXgu8x7pVQHWFaaWw+G4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787834969; c=relaxed/simple;
	bh=6X+7aspQeWZrNJKQdfJqRHl3TSyYszr2i4+ksrcNn14=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OirbfIgg4s8clWo335/qTpCObX9ng5vNgx90RQ9dGoVtnWdTxT210MFVCuxX7ZtAoVPQJrX0+0AKI8sslsMN00ObYRpoapZFkhWEuASVK8Oj/Y2R3itBkJGHTISEp5/yGNVqkxwIysW/zogtl9yFmn2F+kQI8ztLzZASj3GYEmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pU0+ERqT; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pU0+ERqT"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-482dbe4d247so314696f8f.2
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 05:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787834945; x=1788439745; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=deQLONOLHQouvAEnQ9EvfbjW6sYhRlV+/puu/9H1X+g=;
        b=pU0+ERqT6HQE1lDXruH0OpUyayeScv0X+a7ZVv1Y4LmFxs4l6dClZ2r5qRpdsOoE4g
         anaJ3vJN/AepaLfJT87F3X9YodON6taPmtptTP1cD+HTsAYyqi+65K0JOqTMQnCNIjUb
         7EpH+/MVgfN68K2RhbFB3gXDUFtuuPpblWrTPLmT1pHXgdx2eYGl1Srhd+WSwcmOkdMf
         GkVKvC7u0cDUazbdG7j8tzxIb3eZHVmMQ912Mxgoxli3jKny3+9xzHtj2AV/VKTw3eDE
         Xip0QYYoj44rQAdk6VJxYoA0ODyIWSr0C72FPz/kQjTFYDBjFcdo3juq1IxFwZGw8QRq
         YgKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787834945; x=1788439745;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=deQLONOLHQouvAEnQ9EvfbjW6sYhRlV+/puu/9H1X+g=;
        b=jKttTI37Kvf13iOdaekZqfP3+Roup2FTkTDWvpCPvGKpqgb5cI7FjAmGk87qvhjMDn
         tEnH0LY3VaMbQyAh7rq07K8RfsSf7rk9x5wRmzUSo2sRolpKbCjFSBAPXOwLctmD8BQY
         GZoktZYJulXsYQML5q0oUOJLkfMmMIWNEHvXkfNVv3ES6l9NIXEEwK9205nSwCXc+Hlq
         Vglq47x35CfkBqtKRoYuWHVb6zhWanzowEJQ0gwIUZkRX1zTrM/+e82YWdoRk1wBt3UB
         UIs4jljjRHG6F1IvJfKEyOgZlieUNgOTaRoiGZh23Sf2bwTl+WKxrOwk0cKmfJTv6A3Y
         ABIg==
X-Gm-Message-State: AFuF++mx2U9WH7LvvLj1qwD3PrRfG5ozihTlnRkHmMOHgdLg9Xx3RNmU
	OCcBphCiu8KatC7F+t5JbzA4oewKc9d+caV64+Lq2heWTi8jBNnggIg970al2Q==
X-Gm-Gg: AR+sD12B4gYvLS8L9oRUP5+OzTt1hA94ETjNRNM3z3n/j+3yu0yG9qLN04pwX1YFX5E
	1ffl84o2zeUtZfKFsGQIR4rRcA3X8r00ksn8AhBMfjwdWIJGn38gsCX2EWYheAPTxAwpMxAakAH
	YzE+l+i8T0oj3SqCC7ZRTKWgcY/BABmztLKuxKh9ULOPd7McsWBYS6AJAInod2oPhagCjZTkLQF
	umggR2Zxt4IByMf9iv+7xjnLeBw3bZyQeru6wU0+4swJbvTtHfP9eL8MH7UupGN8yaBTUP2JGN0
	0nWkXjcoteJF98fSp5W9PQXCRz3mIdyJKRqiManA8xSTwo/s5EaopwlrpIeUjnYUXBNX9SaBnBx
	Z4wZVZDtpSx2H57hYnJXFdxuu+c+ACp6s1+ZfSe64pPsnATONfMQVMHXtw9vwZK7YjiLoIYMWjQ
	+kzwPTZskLqEzGztoHVs0JpUFpCe6GBW/CxGLCBV8WKTfIo21aNqcPy5AMlHX/tkh5Bs/sO+8f8
	dylilVFxv1gHKy/B1Lts5rPDZvKbda5RICSM2TU5S9m6LTdopdOEuW8B60xFFlp6NVCiPEXB9yG
	CKslMEAZlUpVOGasDd8=
X-Received: by 2002:a5d:64e8:0:b0:482:eabd:642c with SMTP id ffacd0b85a97d-482eabd665dmr10554372f8f.1.1787834944283;
        Thu, 27 Aug 2026 05:49:04 -0700 (PDT)
Received: from omarchy ([31.223.97.101])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482e28fe2ecsm8880568f8f.37.2026.08.27.05.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 05:49:02 -0700 (PDT)
From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com,
	Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
Subject: [PATCH] wifi: rtw88: debugfs: don't vzalloc(0) when rsvd_page is read unconfigured
Date: Thu, 27 Aug 2026 15:48:37 +0300
Message-ID: <20260827124837.14370-1-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reading the rsvd_page debugfs entry before writing a page offset and
count to it calls vzalloc() with a size of zero, because
rsvd_page.page_num defaults to 0.  vmalloc warns about this:

  WARNING: mm/vmalloc.c:4019 at __vmalloc_node_range_noprof+0x9ac/0xa30
  ...
  Call Trace:
   __vmalloc_node_noprof+0x4c/0x70
   rtw_debugfs_get_rsvd_page+0x4c/0x110 [rtw88_core]
   seq_read_iter+0x132/0x4b0
   seq_read+0x12e/0x1c0
   full_proxy_read+0x6f/0xc0
   vfs_read+0xdd/0x490

rtw_fw_dump_fifo() would reject the zero size anyway, but only after
the allocation.  Check for a zero buffer size first and print a short
usage hint instead of allocating.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index b67d69b..84e45af 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -315,6 +315,11 @@ static int rtw_debugfs_get_rsvd_page(struct seq_file *m, void *v)
 	int i;
 	int ret;
 
+	if (!buf_size) {
+		seq_puts(m, "usage: echo <page_offset> <page_num> > rsvd_page\n");
+		return 0;
+	}
+
 	buf = vzalloc(buf_size);
 	if (!buf)
 		return -ENOMEM;
-- 
2.55.0

