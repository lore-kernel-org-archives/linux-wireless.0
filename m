Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4B140A927
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 11:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788434274; cv=none; b=Z7AMrQe+o4ra94ZkxMGzgnLHjlrkmiHutlQwsX7K44SzVskIpRPoBTwaTwOCHw/4DDOZqpd2cU/+fPOd2upex6i3p7T00+w7hncHgvKDNHh4a2q55FwcpLRnimkjR2wQD3ZfZGl8MkZO6ZLHJ66fuNRQJ5lLCwTv4JeM18cEhn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788434274; c=relaxed/simple;
	bh=AdXjsJSb0AgDi206MKbT5/ujhqsAVhxwhwcTX58F0jQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tFgTeEbLxDHoRu1jSPZKM/mLUnUx4OKLeRbNdc96WOcpRAQPI6+VASQTGbWTwa4x7WbUlUBU8uxVBx4RkqPi2C0rotqSrae0eqfhTi5IGe/RP9IAtqah3NDBWRQkFHbLrtmxgAmXquEZqP9WeHSmbxUiKMz5rgYwpGUWLjjAdyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cHepJILW; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cHepJILW"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49556f97a9dso17994915e9.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 04:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788434266; x=1789039066; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qFdHzHR5U7XzX4GuMeX3+jxmp2FmD4vKpiX8boMmw/8=;
        b=cHepJILWEa5/YNK4HX4rx7cVqq5LALV6nAvVgY8tOKvtEwrzHSQIHQWf9l/d6vk5vI
         YsiCvs+cUbMbndDaFZDU0tDqHT3ehgvZ71Co12de8fQd3UXoYssVp8gecyA1172EjVCm
         RdW5eOEv48xgHGcRTZXTgw8dVNK9ibSCgr3fzpLMlXxyu0C4bDJUdo5y64xEzOjtcWIY
         GmxG+y2j5cYrQXrq2RYM/3JGZQO5wfeJSHnExaypuKbYF10d3FXHt71n7vaXHkUy3G3D
         7kMSq9UuluIUd4tTX3xfLb83pr21h3V1ytsl8r/RZY70HbGp3/o2U84Y3ysZAq5Z1ExH
         jCmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788434266; x=1789039066;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qFdHzHR5U7XzX4GuMeX3+jxmp2FmD4vKpiX8boMmw/8=;
        b=Y7kOBokuMgLLvyaASzvUg2uWCf5jIEBccT7snCoUyIlu7V4zaBY5TyN81ySF8ktKmr
         D5Vdx/0ar8ZCGcdwvjKVA1GrlCODZvNBkjWv3J/lZoT1nEk2JfcQdP67CPDSwXdLHMzU
         WevCCc+QiUETIKdmW8835ync9WdxikmAec0ZferKlBijz6+PKvxZcHyn9p1VA+Hi7tOO
         v7gSfHnOxhce2wiRAVdjWy8FjCXF6xmeD0AnNY3uHgUlyx03tJ6vdhv9UC8ZilPsZxMB
         dcqELC6RGElOZ1+tZLp72W5okDH1dhc0nXVPE4RG4A3e/Pwkw9bAWag3HJmJRPjvRJo9
         h+OQ==
X-Gm-Message-State: AFuF++nU0h4VvZu88ey8qgjCqbWmt/QEMhz1PORh+/F+08Tjxfh3w5lg
	hfh/x5e4jmpKGpaE9U/U/1kl1fYf1hmt9D7KyD9hbrIjYWbNlJfI+gmAPROQdAw7HKs=
X-Gm-Gg: AYBFou0VPDNiXP+U9PdIk/9Q1rqUuf9IwAxJBDnzCHCpVjwdes7q/WlMpIJoQm+VVOo
	XFKZi4smgGif4UMlaisYvHvTC+qkVSOq4Dr2GIsYA2UDHge57UmY+bmAvHHDOHdwD2iyhgyKxLX
	OX9XXgJD0sdLLRHIUgeURxtcS2KbiKq3hpNSRNK4WrIo9V/eLSkqv8IscmqRWgRxTn6443jz6GZ
	+YK6h8NvKJ+9PCJ3sgFkbSRUCAFQ6kINlyc69CG+Osd+lKojl9JvW6cii60Pz2JYFkyY13zrd0V
	oCYc2mzQomBLeWQCuGcD6TjAKGByZWM91JqwWt4m8pPCGWipnRNKOmyPwFLFJN4keNZP7dO8ANj
	b2ZO+622RMfaU6eCbCrAn6pueRssyWvGB6NnY+qjqDGuZy8Oboafu9iNJtwSHP5mWP8TYavBv89
	3lQWLhCXbKuc8/QshUvgLIlEZQkk1b3X0TAhouVTuVwycNEEFNrH5tbmCySA==
X-Received: by 2002:a05:600c:8b05:b0:499:b65d:124f with SMTP id 5b1f17b1804b1-49ce5823d9dmr246591005e9.11.1788434265759;
        Thu, 03 Sep 2026 04:17:45 -0700 (PDT)
Received: from metepc ([46.197.185.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5d587csm68738785e9.4.2026.09.03.04.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 04:17:45 -0700 (PDT)
From: =?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org,
	johannes@sipsolutions.net,
	kvalo@kernel.org,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	syzbot+adeb8550754921fece20@syzkaller.appspotmail.com,
	syzbot+101224300649c3eb8af4@syzkaller.appspotmail.com,
	syzbot+8141dcbd23a8f857798a@syzkaller.appspotmail.com
Subject: [PATCH] wifi: cfg80211: avoid holding rtnl_mutex across all cfg80211_leave() calls
Date: Thu,  3 Sep 2026 14:13:53 +0300
Message-ID: <20260903111705.472491-1-omermetekaya0@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

reg_check_chans_work() holds rtnl_mutex for the entire duration of
iterating over all registered devices and calling cfg80211_leave() on
each invalid wdev. cfg80211_leave() can be slow (disconnect, stop AP,
leave mesh), causing rtnl_mutex starvation when many wireless interfaces
are present. This results in tasks waiting for rtnl_mutex for longer
than hung_task_timeout_secs:

  INFO: task hung in inet_rtm_newaddr
  INFO: task hung in inet6_rtm_newaddr
  INFO: task hung in nsim_destroy

Fix by walking cfg80211_rdev_list under RCU and acquiring rtnl per-device,
so other rtnl waiters get a chance to run between devices.

I could not add the Fixes: tag because this patch addresses three separate
hung task reports whose cause bisections all failed, making it impossible
to identify a single introducing commit.

Reported-by: syzbot+adeb8550754921fece20@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=adeb8550754921fece20
Reported-by: syzbot+101224300649c3eb8af4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=101224300649c3eb8af4
Reported-by: syzbot+8141dcbd23a8f857798a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8141dcbd23a8f857798a
Signed-off-by: Ömer Mete Kaya <omermetekaya0@gmail.com>
---
 net/wireless/reg.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a8336baf85dc..a2e0d1cf8317 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2466,12 +2466,21 @@ static void reg_check_chans_work(struct work_struct *work)
 	struct cfg80211_registered_device *rdev;
 
 	pr_debug("Verifying active interfaces after reg change\n");
-	rtnl_lock();
-
-	for_each_rdev(rdev)
+	/*
+	 * Acquire rtnl per-device instead of holding it for the entire loop;
+	 * cfg80211_leave() can be slow and starve other rtnl waiters otherwise.
+	 * wiphy_unregister() holds rtnl across list_del_rcu() + synchronize_rcu(),
+	 * so rdev cannot be freed while we hold rtnl_lock() below.
+	 */
+	rcu_read_lock();
+	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list) {
+		rcu_read_unlock();
+		rtnl_lock();
 		reg_leave_invalid_chans(&rdev->wiphy);
-
-	rtnl_unlock();
+		rtnl_unlock();
+		rcu_read_lock();
+	}
+	rcu_read_unlock();
 }
 
 void reg_check_channels(void)
-- 
2.55.0

