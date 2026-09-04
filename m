Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB158525A65
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 19:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788548630; cv=none; b=DSjQ8KsBXJHPeVtQbYwCV2kTsDfcnyfwJkjYhJe5G/dJReDcFNTtcMvVrWh5TgvkwkAwGnN2fYBkm/wjp8EnQ1yo9f6+Hpw+KTETk/LO/b9kB8xeQgV+fE3earcUhT6HBd5MfiUbMHHiVt9ypS0/Y4ZxDaVM3tKSza/t6evt2ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788548630; c=relaxed/simple;
	bh=zZQIwDx/ISY8S9Dqj7FflEO92WTHvz5pSxY9afstFwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t3wnnd6aHVq2kv50hl5AR75RjNNYCZbqG7HRC4CNoIfgMl+hYFhTOsvsHAGS8uZGI33iqmCcS6AqFY648oOz2CVbTzh0kvX9IhxrN0vrOjQTE7+zV/sgmdvlrJG1xxpCTtCcwrh0zXimCterTRWIFbseSzW0rOI0nubZLIHtTJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ai86ceRQ; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ai86ceRQ"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-499ac87c92bso15412875e9.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 12:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788548619; x=1789153419; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=V6qnCY+SnZIeKvw5ogqQJc7nrfyUhzrkXNUqPQpouis=;
        b=ai86ceRQXNTriDT/R1Uj0W2xOWoiBI5TlUapLJEYalo33S3aDJTCQTBnxH7LCdVqRS
         MpvgkVDsP2NJ5ZkJPgUD0taliU5+Bl7rt6K4+m5Z7TPzfdtCRX/oNudJ5djeZIYabcmc
         y/Qr0z/WXFBggeVEIGDK4DAamivnA0bj/s7fs/MA14B/xUDYKJLXXO1Y9y2Ej2SZTP3X
         ViTGLDfljtj5BmRAmGeiRYUDjXJqRARgevc8Rbufdl8nbKwdwf0S8ltyVtnM1WlRy8w8
         O7XJk9EA6BSI67uoDX3nq3US8EG3cju//wipr1Y3nESzRlfsA8yhX+vqSd/v52c9SsmP
         uJsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788548619; x=1789153419;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V6qnCY+SnZIeKvw5ogqQJc7nrfyUhzrkXNUqPQpouis=;
        b=NMnIrfE5Z6vrOqzl/XjqsuRWhgS2bGSdm9KGAf5rqSp8N0rwjTWctanj+pR8eRv5Oy
         J7NFDLQdrqHncQUfpVxGQmY7N1iHqUXX68+++Qtc8bZJn9TqCaFxGGdBAymLBh1gBT+q
         2k+65ssldPfJdIeXiZLoe6FmzB6cule9+uh5xA4JWORGNZP988mX4hSrHnVWCatvyNER
         jP/vDKNDoct41GgFwOSWyWXhAaVrAk/JvTITebqoLdYv0tx3FfCoV405OhFKnjrzAq5I
         Lay8QnDKxCHJQhBteil3ofrtgaWuf2w2MgXQJT4/MuFocYP/0j3R4ovWIusIONqecG0Y
         SAow==
X-Forwarded-Encrypted: i=1; AKwUvBxeQfyT25LaARXTh9NyGFYwIfr6loKRHsuoyopS7du2PgICrzoOrNGit5KeBSdoaIMnTsW1PKk5fdxZJv9J9Q==@vger.kernel.org
X-Gm-Message-State: AFuF++lV1DlDuegBu2bxttKRVgo+9Wbk459jirXzu9N0bFxFlq0xUFk+
	MdDNu9BjO6/P4SrhZk4zWc0oac4w1AnLwv1YMmyqsra1KfPNV26CBow=
X-Gm-Gg: AYBFou3eeVGqBhB7yspGF6XahyokKz31GJbkCoqFgI7MujWeyupX/UOtNiqmEgaxwdk
	38csW5b075+hnB2DqFLtyuWJdgcOh3nMxIi3l7Cai+eB8M4mFGJNw+7gpbUy7JgGrrZpqUJsJLG
	MGjkbk7WkiPdoraStHdSBQR5VYttfC03ZLY2ZmUb+ZTWEWWKYooVByh0/EMi6+zwiPp2plYscJO
	wfFhIcStMK5kxNZQlavVNyIdXCH0Md4G6B1j/HwbDAZAb9ODBsUnTJOS3G5mu4c/4VkjYgUenuC
	WR34LPFn+SJHYiju0cdsNFP3BmkVPysOC65DcCiZGPGz2Pq0BlYKAuY9YUiQe2HJQYeqyX75LyI
	O2my4NMvpXVuoSc67chTb+GwVTFncEcG1HFLnJsiaK31Wr24WoBa/lOsV42YFNeBExDEFPHhEeA
	667jcVDvrcRLGh45Y+D11U2pvfxvQRTZ3uEgdQv9hmJyIxOwIvqG2/BOHVCe06/TX38f2OhQwt9
	GUZ8V0vUCxqa+Zc73qZu0o1r9VYtAEg7HycATbevHMGQV/rG0du0xbzlw/T7iKjhwWU3jFd0rbK
	ZRpZhlMWbSx2/Zj8
X-Received: by 2002:a05:600c:6090:b0:49c:e3b1:d826 with SMTP id 5b1f17b1804b1-49cf825ab42mr91291895e9.13.1788548619011;
        Fri, 04 Sep 2026 12:03:39 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf7710aa5sm89643535e9.7.2026.09.04.12.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 12:03:38 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] wifi: ath9k_htc: count WMI commands and timeouts in debugfs
Date: Fri,  4 Sep 2026 22:03:32 +0300
Message-ID: <20260904190332.815525-3-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904190332.815525-1-nerijus.bendziunas@gmail.com>
References: <20260904190332.815525-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A WMI command that times out is only visible with CONFIG_ATH_DEBUG and
the WMI debug bit set. A register read that returns -1 gives no
indication whether the register holds all ones or the command never
completed.

Count the commands issued and the commands that timed out in struct
wmi and expose both in a new "wmi" debugfs file, so timeouts can be
seen on a kernel built without debug output.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 .../net/wireless/ath/ath9k/htc_drv_debug.c    | 25 +++++++++++++++++++
 drivers/net/wireless/ath/ath9k/wmi.c          |  2 ++
 drivers/net/wireless/ath/ath9k/wmi.h          |  2 ++
 3 files changed, 29 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index 9437d69877cc..fab613199ca2 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -310,6 +310,29 @@ static const struct file_operations fops_slot = {
 	.llseek = default_llseek,
 };
 
+static ssize_t read_file_wmi(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct ath9k_htc_priv *priv = file->private_data;
+	char buf[128];
+	unsigned int len;
+
+	len = scnprintf(buf, sizeof(buf),
+			"%20s : %10u\n"
+			"%20s : %10u\n",
+			"Issued", priv->wmi->cmds_issued,
+			"Timeouts", priv->wmi->cmds_timed_out);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_wmi = {
+	.read = read_file_wmi,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static ssize_t read_file_queue(struct file *file, char __user *user_buf,
 			       size_t count, loff_t *ppos)
 {
@@ -505,6 +528,8 @@ int ath9k_htc_init_debug(struct ath_hw *ah)
 
 	debugfs_create_file("slot", 0400, priv->debug.debugfs_phy,
 			    priv, &fops_slot);
+	debugfs_create_file("wmi", 0400, priv->debug.debugfs_phy,
+			    priv, &fops_wmi);
 	debugfs_create_file("queue", 0400, priv->debug.debugfs_phy,
 			    priv, &fops_queue);
 	debugfs_create_file("debug", 0600, priv->debug.debugfs_phy,
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 284e8c13b043..552ae9f8bdaf 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -345,8 +345,10 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 	if (ret)
 		goto out;
 
+	wmi->cmds_issued++;
 	time_left = wait_for_completion_timeout(&wmi->cmd_wait, timeout);
 	if (!time_left) {
+		wmi->cmds_timed_out++;
 		ath_dbg(common, WMI, "Timeout waiting for WMI command: %s\n",
 			wmi_cmd_to_name(cmd_id));
 		spin_lock_irqsave(&wmi->wmi_lock, flags);
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index 5c3b710b8f31..ee72b0fba31b 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -158,6 +158,8 @@ struct wmi {
 	u8 *cmd_rsp_buf;
 	u32 cmd_rsp_len;
 	bool stopped;
+	u32 cmds_issued;
+	u32 cmds_timed_out;
 
 	struct list_head pending_tx_events;
 	spinlock_t event_lock;
-- 
2.55.0

