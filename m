Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADC82C234E
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 08:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027703; cv=none; b=UiYhJQAf+ieZnh+YeA9YJMW6MLiiZN2MnNIpfd4Mi+uREEsesitXPKfE1oRykvQt1/XguPI0v+MJ92rbliEEcc3en8d88RcC/YPObK4cOrjyC4rgni0HsheBM6Ih+Ptr6FBCfPmUbCsUY7/1vqW6qrPkUyu1lL0xH12mxF5Tx2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027703; c=relaxed/simple;
	bh=QWvT3GYVTZMpzawpDLwGWtYO7D3lX+prXNvyUr2j8gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z1PgR6yDzYg0BndR7McmPM4ixjSala8zWUbsuJO0A60SfEroLNumBkEQLn9LUwlFBmX+yCO73DcijLD7zFCPVwFLIeEC8RgxolZOGkQS5qH0ZqpEm+go3rokqRSW8SceF6KDlaS0/j/Te2BpfISDqTsXW+NoXbznj0EldhB8RW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iwQfS6q8; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iwQfS6q8"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cc439bfb2d8so4490972a12.2
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 01:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789027702; x=1789632502; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GFur5lMKzWOr/vPCQGQAzSEKh1oHhUM+qY0sKZHwzYc=;
        b=iwQfS6q8maTM47rKORKXV/aqOwGnZrno/zFtM5Ak++8/WuzD+2NOo3mqF9r2p4sd2E
         jJkgpI1H8ZTXXABz3xwCHrTIWaJqgjR8DLGgj3Yn/sQPyBnkJJDn3f2O7Xar0U+yaP05
         wXCXAMJUqWJtKkLuBOeOKHWKuW1zsDEswuM3ulAkscwSIEUf1Q1V72q+MWRkAmA5oWFS
         9mIqOJSUTDETXMcf5Z0givkSQZ2dhesXc7ut+zYWzzMdB3yX4vcQNEccdKtkExaI/qSh
         Zlg3ZcKneRzogOc0gF1XpFg1VCkTgyr8DzVDno7We//88C5zQAHDXhSz8b6gguRTBAHd
         6PcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789027702; x=1789632502;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GFur5lMKzWOr/vPCQGQAzSEKh1oHhUM+qY0sKZHwzYc=;
        b=avioRwGqLE1UfGW8T89G46lFBY9wuxzAhKWD6jDVf/w/ylTEm+P5x0aB6/Tvha34WL
         465HcEXESqEGWS5Lyb5QvLtNXGlXMARJ7qgyiKhKFRL68v3f84PkpgfCwc9KM4JrzNJu
         SULWbyHjnj3CRrUvIEsW5N5MTW7Tg2P5iDChHXwPPvAEd9NjrGygFfFZ844RszY6p43L
         V4YaTnzfxc4Rhn77WlLD28gpZTViwei571CdRm2dL198LGUHp2E7K2ewyrvCpRM2Vm1r
         yNGOor/RxZs2ZOIs/eT3F/TGlTrQOTzcYyYm6to36n2vcLtxrZ2ecgDwLp58d/T5UzTK
         iVCQ==
X-Gm-Message-State: AFuF++ljQI1KBZa//ACx1toitdAieeREAU+gMN0TTFb6EbyYvzMJ+lSn
	o0dhye68qy6jRQMQuIlP8Uk+/cA98bpwyTzQJi0rSBm7KfK1Iu0K4JLTzQ/OSQ==
X-Gm-Gg: AYBFou26+pIy6oNOIHrdxKxDdNe6/pzv1Vmcpp1j50dSF9/f2sEZifwwsK1uSdk35i5
	UdBUpGKuVgFrFZFhtN4mtTwQDV8OYTj0TFSzQixUmGYj0i8WFqvdZaiJXOqerktsb0usf4586Lh
	kVzdcVJVAnEOoIPmI947sm545ja4JLt+o57cmBQWc8EF7dgv4vTqSo6A8LZOjxeq8SWHFe9+vjR
	QR2ylTo40+6arw1KiBxt+jthVwqJ2/Bx4SeIFg1yZ2NuTxwnjaJTIhLLUlHVLKGNmk7pJlpWbHo
	lqWP3NNOpU7XkxTjnY4ZX9NX8ff3du/rxfVYeKknHVU6qkv0SsGngpfsbBJVMLLUANaTWVeeOyl
	G9cjq52jvYKXUT/KapQlAo1Gj8NVTlCy27NrwUNxXGtn4oe8CZOUTxG5opsE/+1YX8kTxyk0Aon
	5PUqYj2YP7EeIhKHHBlm8AX/MR2txbhJJYkVlINIiTpnJeICT10Cht5nXfRpPZgGUST6sOktU0r
	qS8WPoYWr78i89cnwxF/uWwnDZIxrQAN4vWcZo2qJ9nVkTPni0+hYcG0h+XsTSZ9B2gDzevlb5Q
	pGdP5BmtoD8U
X-Received: by 2002:a17:90b:2d0b:b0:398:c794:ca26 with SMTP id 98e67ed59e1d1-39b263167f7mr58516127a91.25.1789027701516;
        Thu, 10 Sep 2026 01:08:21 -0700 (PDT)
Received: from codespaces-1adab9.ktkhmpmw22vebpok31ngjx2qsb.ix.internal.cloudapp.net ([23.97.62.116])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d77486a1esm4607521a91.12.2026.09.10.01.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 01:08:21 -0700 (PDT)
From: Rivaldi Hormat <rivaldihormat@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@kernel.org,
	ath10k@lists.infradead.org,
	Rivaldi Hormat <rivaldihormat@gmail.com>
Subject: [PATCH 1/2] wifi: ath10k: Add missing validation in debugfs mem_value and reg_value
Date: Thu, 10 Sep 2026 08:06:58 +0000
Message-ID: <20260910080659.20831-1-rivaldihormat@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Rivaldi Hormat <rivaldihormat@gmail.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index fb61e53ff..50e017021 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -729,6 +729,13 @@ static ssize_t ath10k_reg_value_write(struct file *file,
 
 	reg_addr = ar->debug.reg_addr;
 
+	/* FIX: Validate register address */
+	if (reg_addr > ar->hw_params.reg_size) {
+		ath10k_warn(ar, "Invalid register address 0x%08x\n", reg_addr);
+		ret = -EINVAL;
+		goto exit;
+	}
+
 	ret = kstrtou32_from_user(user_buf, count, 0, &reg_val);
 	if (ret)
 		goto exit;
@@ -819,6 +826,19 @@ static ssize_t ath10k_mem_value_write(struct file *file,
 
 	mutex_lock(&ar->conf_mutex);
 
+	/* FIX: Validate address against memory size */
+	if (*ppos > ar->hw_params.mem_size) {
+		ath10k_warn(ar, "Invalid address 0x%08x for mem_value\n", (u32)*ppos);
+		return -EINVAL;
+	}
+
+	/* FIX: Validate size against remaining memory */
+	if (count > ar->hw_params.mem_size - *ppos) {
+		ath10k_warn(ar, "Invalid size %zu for mem_value at 0x%08x\n",
+			    count, (u32)*ppos);
+		return -EINVAL;
+	}
+
 	buf = vmalloc(count);
 	if (!buf) {
 		ret = -ENOMEM;
-- 
2.53.0

