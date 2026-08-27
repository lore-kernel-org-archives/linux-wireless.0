Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A9A40B0EC
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 13:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787836395; cv=none; b=RjKrMEP6eDFeDH1S+E5gCfRri3bEJ/14t279pg4WZnV6Cl8SX+hce5xTJpbaufZKTnchaigZNN15bqzwpzf5c3zJt/cYWizhCwa5/5iuYBLu18JCRpwGRd0xxoDNf1fmxIzJg0QxkD7ve8Tqn1SIePZZYPisn7Qa70KksdxP1hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787836395; c=relaxed/simple;
	bh=31CUeemL+eQQbUBoYqrag2sUv8JBAfW59q4FvsljVrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYOsftmbovfC2UC4XQYtj4JXTPwo4UoFwbcmkguM8aAtIDz6vWfwTCuN4Fg1jsJj4jNK3Rv74J4U4l9ScjopUkJ8o7+3fnNDiMz8v2F+YS2LfNK0TbfNYgA3IRFr90iSi1OiDmNzL8lP8t1txTDi+XlkKi0ukZWEx4PRXSlB1CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l33GG/lv; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l33GG/lv"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-498028b3d5eso21146805e9.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 06:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787836388; x=1788441188; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YWJcL1I0OwWaQgShlWqUYQ+qUtUeV+AX1JUrEJNdqMo=;
        b=l33GG/lv+ZqNPdmTVjDEKGVGkyMsU11W+QhcXIL32WnQxjXWkS11rBJwXmZ9rt2G7+
         LoK8B/LYBPziI4QpNWO0704EX7joINql3y0xEAnx49eevoKmOueV4VmwVQ8kXkB1Njy6
         6KMK5oT1rBu1Nb2c5v7NzgezCdf3emFPyL4MO/07zoOA5GTyNvcVQwQtFWYUS1pupu9m
         1mc5Kb90bTU+vwJGx1cKx0pyimsM+i5nib1aidIX3QfFhEVZDdI7YTWCzKgkty01qMMj
         gbCLqQURYIUI81SA1UDhbWEMhYtMDy+seHAKl5q9msv4dU6JWWxOg34cIjY2DD6ZS6s0
         1uVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787836388; x=1788441188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YWJcL1I0OwWaQgShlWqUYQ+qUtUeV+AX1JUrEJNdqMo=;
        b=pKHsh4JqadsYA1EPHwMN8OP+a+o/CKDKt2tOCx0AcKJ6+bqlP7ntnCJ0nwlLJtHpph
         2t0ZxQpj/PAdeb9fmccuBJSrGFyIonH6T6PHo6oNlfJihSNyb70W0Z/OurZB4XkZLkit
         Txcegw5kNyMEEARpDDvGu8lSZQTjDoETf0VlW+rLwu/iO+lmrO1lPNuj24+EqNnmQtT7
         eJKpaIAvlUJR8lnZ4kPfQiHmJZC5VSZCe3g1AJph7oGTWPw1Yn0Gwl26UnOybH8KatZZ
         Od3TVyHAdDNakMBjp+bCofLc1LVqdblQzW5RoWtyaD2wmWp62V3iORukgOWtKKZaFy5d
         lcXQ==
X-Gm-Message-State: AFuF++ntioplmqIb40hprKxiMw99f8J4QellJclkHCGdWvdKxauG6yK7
	SoHir6UhFuDioq5vkAtwFE2/jDRKYBgjXngeltXvXeIf87PxT1nQJ0CzO0AKwB9b
X-Gm-Gg: AR+sD10+3Bgxz0HOTVilLXTiqicQ1j/uagvTsmM9VObE2WiBl+F8JrwA94yUZoeAZEd
	avOs579zxsvz9B4qFbWtSNcWZ/9ekA+upyk8GCEURBhqymF+Ed3HU8duW2CxkHysEjQWTkz8r8C
	cv7UwjuQfrH77opRHwqIE25r7pDmC4G4Bonk0trKNR3w4TRa9YA225F9CkDhlo9nOqkt0aYfu1c
	VSmp+rGsWiUG6zAH3192nas4LIft1F2zELfSjJk5ILwrwHMYBpTKvtvdv1fNYsdU9PrWymqehXh
	R4o63NMkZHf52FmQB7LO3v7PBPgwP2RTohVIScOtddNHwv0JCvDhEMa9jgGMEMS/u+A01OW2FhT
	RRYUoX7rLqovpZPRvpfGwymNbm3xqKRONOfFxGoDgktmrGBtDrBjYXxwCzEYElgQz5VVEba7Clv
	8ZfAF1ELh26jZzWTkI/SNA0qaxg9vV0+PP3g+7ZOQRjX+2uoamgXI1Cmy4QScmbuBS6BYGNotOd
	ZloExsxcKy4sKKYEg6CCq/N7rsV6HUwJjYS8spkugBT9wluA72/PZHDppDn2VQMHPeNqr2eEdPL
	DXKYg8YS
X-Received: by 2002:a05:600c:3b1a:b0:493:c47f:3c55 with SMTP id 5b1f17b1804b1-499dc6fb0fcmr176333935e9.5.1787836387697;
        Thu, 27 Aug 2026 06:13:07 -0700 (PDT)
Received: from omarchy ([31.223.97.101])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499dd56acedsm81184345e9.3.2026.08.27.06.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 06:13:06 -0700 (PDT)
From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com,
	johannes@sipsolutions.net,
	kvalo@kernel.org,
	briannorris@chromium.org,
	Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
Subject: [PATCH v2 wireless] wifi: rtw88: debugfs: don't vzalloc(0) when rsvd_page is read unconfigured
Date: Thu, 27 Aug 2026 16:12:44 +0300
Message-ID: <20260827131244.35623-1-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827124837.14370-1-abdurrahmankaradag19@gmail.com>
References: <20260827124837.14370-1-abdurrahmankaradag19@gmail.com>
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
v2: no code change. Add the wireless target tree to the subject and Cc
    the maintainers/blamed authors that v1 missed.

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

