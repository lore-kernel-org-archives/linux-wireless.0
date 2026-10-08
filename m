Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44108450410
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 12:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791462536; cv=none; b=aDOFgZN2fhZk8ZzVNXvtBFXbNAC7t0n9UCweW16UtAI+HruRc6a494BzzvzGVGcsu2F0OroH+CWNJc4hSBXVOa+t9G3CA5Q3S6NJ9dCfcKkuUKke5qTpTqW1gXj5XRxA/3yPTkdf/HLFJ38En6qqcM/sJx3UszgXf5QurdCsKrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791462536; c=relaxed/simple;
	bh=IbVo6s7b5sBB9lnd9tmlCLjiyw9VvCQfz+4RT3BW5pM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=No0/yJle9JDm1WA2UrvmDS+5TopXrcOK7+RX9lbmTMj4i+FYpmlLdpctrM/5ePeDHMfNgdD/4xcBXyIvciHUHlcT/2MJw7mkDjPUOpxlgUTqtRBr98Yuaa9B4O7caJ+F+3cKDp3coi1cCzC31cZF/YBjMhECSwc91CZp55gyIVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NfbDHTSx; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NfbDHTSx"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2e608cd460eso11739795ad.3
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 05:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791462534; x=1792067334; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=COAThH0ap4EmFyle9qndKOJa6dHiJ8hI93mqQf8LdaM=;
        b=NfbDHTSxcSTnBm4E49y/qbTrOaokcCeDllIcPxd04VMni+t9gQoUXdK7fK7/W7D21L
         yCjPNY0DV0GUepQl1+2YP3xsAJ8jvU2b2j/FyCherRbziOcXx8njM0sUWc9+QARH6tWm
         oA4IEMMfuOJ9vJypwm9GCHcOwHCbfVwQeki4/jL+dQxsTBUSdE0FPMwofUkJRr43fZZO
         X2dRc6gqR6QtcYdkYcjq2XG4DgNucIA2LU+vJE3477kZmfanmWPbhCCIuqKHXLKgZj2f
         AoZ7rGSBIGZzxB6J7XCQZYyvacRYjzQQ3wQyCV6iGR6mMQjdUD5HWkl6oQp6BuRlEhIV
         iCXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791462534; x=1792067334;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=COAThH0ap4EmFyle9qndKOJa6dHiJ8hI93mqQf8LdaM=;
        b=OU3byOEmnLq/r2wC5o0db6rPmYi3DXEir/M+SaQHdHeuCBSEXHcm9HecOOkj9rokCO
         ELkNzD9SNQjsVW/LCq8/p1xVCxCOMKU/CvKzc3Vdklkikv7qtTtJwK60BtGG50a8MQTw
         XHMSdr6LrIL1NrHE4bmcJ2PMy4oHamhoJeUElBR5xdnSlfxqzJPZ48Cn89uL6uFoiomA
         5b95Xj5bKNvI6R/9aLD6TSJsYcBY0RzFgQAuAeBIrvFMbt9yuEZJpTMgfxmv3qDM9d9D
         Htr7QEe4pT+ynp2CCW2gJOzoIRogIXgoveSANhcp4YYQOKTrZecvX8Z0K0goPHEErcWC
         gmrA==
X-Gm-Message-State: AFq9FYIDsVdnEL7YKwk25u8CQnyCyF1466K2z6+ZbtUUZ+vyT60pUbCp
	JSlDJd9RErq1qYsk5HThXqHb4b8bAr3YeHX+aZ/1sqMH1Y05txoPoLjY
X-Gm-Gg: AYBFou1DAMX0QbxCHruUf6bV8RLb2e7DXYq2vOHBvKq5JXh/4PwZz7X8uR7izLJXgWu
	sp9woSbLolqYfJwMIY5AFNc27oOWBLe+2vcntiIwuzA6kIMoonCcizSyyQukXIhQIjh2GONHN/R
	Os1olUZVIFnAJtsdSd94q5gu6o3/+gl2f7Jy271wlWlOcLzbo0NKTllkEqDKy8ZSAE0Ih1FHfEb
	kl1yY73+J5wfN8SdygtcGA3taGFqhj+bXa4IhHTLCk13UMoMgJx0i+V5sWWC9IZcTWv6PxElTy5
	11K9crxbLL4ezdheGv19qDs/IyZRRnhb6hZZxLqP1nyMu/vXOyKyP1VhqWdeW4UKOB05dkv/DT2
	fj0YJcF0wV1xUEWA985SKn5XRJcrmqONDXCFSMH08zya1GVbCJ2qzCsuuyGykc7SvtILkffjr//
	M7KBZnFVxseuzZYp/z/1ncXTVlyIQfYlYmWo+Q3z6oyVn+X/K/j6XB2JOjTNs0/aAwZw==
X-Received: by 2002:a17:902:ce07:b0:2e2:de8e:7315 with SMTP id d9443c01a7336-2e6004d2ccemr43775815ad.38.1791462534502;
        Thu, 08 Oct 2026 05:28:54 -0700 (PDT)
Received: from dungbv.. ([58.186.69.27])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e60443810asm22985415ad.9.2026.10.08.05.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 05:28:49 -0700 (PDT)
From: Bui Viet Dung <dungvn2345@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bui Viet Dung <dungvn2345@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] wifi: mac80211_hwsim: Pin module for debugfs file operations
Date: Thu,  8 Oct 2026 19:28:38 +0700
Message-ID: <20261008122838.224835-1-dungvn2345@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An open debugfs file retains its file_operations pointer in the
debugfs proxy state. However, hwsim_background_cac_ops and
hwsim_simulate_incumbent_signal_fops in mac80211_hwsim_main.c have no
.owner set to THIS_MODULE.

As a result, full_proxy_open_regular() calls fops_get() which succeeds
without taking a reference to the mac80211_hwsim module. When a userspace
process opens either of these debugfs files, a subsequent module unload
(rmmod mac80211_hwsim) can succeed while the file descriptor remains open.

When the userspace process subsequently closes the descriptor,
full_proxy_release() accesses the already unmapped file_operations
structure, triggering a kernel oops in full_proxy_release():

  BUG: unable to handle page fault for address: fffffbfff84f49e7
  Oops: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:full_proxy_release+0x8e/0x140
  Call Trace:
   <TASK>
   __fput+0x39f/0xa60
   __x64_sys_close+0x80/0xe0
   do_syscall_64+0xc3/0x590
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
   </TASK>

The issue was discovered via manual code audit of mac80211_hwsim_main.c
and reproduced on a Linux 7.3-rc6 test VM with CONFIG_MAC80211_HWSIM=m.

Set .owner = THIS_MODULE on both debugfs file_operations structures in
mac80211_hwsim_main.c so that debugfs pins the module until close has
completed.

Cc: stable@vger.kernel.org
Signed-off-by: Bui Viet Dung <dungvn2345@gmail.com>
---
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index b9446577ff49..3ae46d78d68a 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -1149,6 +1149,7 @@ static ssize_t hwsim_background_cac_write(struct file *file,
 }
 
 static const struct file_operations hwsim_background_cac_ops = {
+	.owner = THIS_MODULE,
 	.write = hwsim_background_cac_write,
 	.open = simple_open,
 	.llseek = default_llseek,
@@ -1209,6 +1210,7 @@ static ssize_t hwsim_simulate_incumbent_signal_write(struct file *file,
 }
 
 static const struct file_operations hwsim_simulate_incumbent_signal_fops = {
+	.owner	= THIS_MODULE,
 	.open	= simple_open,
 	.write	= hwsim_simulate_incumbent_signal_write,
 };
-- 
2.43.0

