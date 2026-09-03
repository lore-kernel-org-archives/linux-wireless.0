Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC614A6CDD
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 15:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788448579; cv=none; b=j2G0DJJh//c3aJBnfKIMTLFFfDT8fyz+LVKPrgRYe2R8ODYOdkRSIL58ZI1IonyUatkygPNIrJ8FZZSjNpWo9UdCQWp8r3s+f+/qQ5H+8GLZqRmAHwHGoFdTR9px1qXdD/QxD5inYVG3pZjagNZyAKm5Rr11HF8ftVUknrAUyG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788448579; c=relaxed/simple;
	bh=WH0QTFAGkBASqEUK10naybiWkASY5mU9qZY1XfCsA78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z4dOpNVy/E//65p4dpLQv+quFNj0xte4PfcRfJaa2HsaX2XozrhVktKUQfdQaAVigz6Y+r7yKvdBa74wHsHwZ/320pLDsYxLIulS8RFjN5wGMGoN7dVr7tq+klLeQGZVvk8qVmNfkDJKjlLV2Nj5Nj4Hhc5M412plaEr9XRR+mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q8lyWZr3; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q8lyWZr3"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4980fe6b3beso8682625e9.0
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 08:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788448575; x=1789053375; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=THzjvy5iGboyhx98aFSf1bvAFTvgaD3XGcWeB3Rn6lc=;
        b=q8lyWZr3Xabqle0f9H9eOKFn3E8+g7J59Ye3A4mb5saWN1koySi5EalvqQgfpxzM2C
         /+kOXQs9//0OcH+i8Qm4H6V1JA7etWUxC5wFDyahxX0Ps/hJY2FOCGx1fXuTlbO51wnE
         ASvQO3C5YZmjOOAaYGDSWguG6cZvyirySi+NiPxZnoV0s9cq+b5ptfY3rzEeSlwSSp83
         Z/+kA9Gy/iYiWLHy6/6+0oEOMiuflq27JgaCcUaVxba1CS9dcvJz1JEYuPsOqWPiPkZx
         MW9DXSH6vW1yf1iNcDgb1WsFo21EXFyn9Fc8P8O5H7+5shMs0umBSxEIV3lrT24GG8Ph
         /mig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788448575; x=1789053375;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=THzjvy5iGboyhx98aFSf1bvAFTvgaD3XGcWeB3Rn6lc=;
        b=bRQaaScQjq4zM8XFHgszmoYxkT4+4GLKLTIo2QOMvphVAcKwhw0GSxdyw5C2ZVlgh8
         mjc2WIyG9HfuPtVhIg7ymz1V00nSdoaCIb7ftULAu6Syfg44flBzz+XEnMMGXDGMj1fp
         qWfjHN0bqzcfYDQz4qfiIVWkZDmxGVu7wMW2sLLrsFS8OFPDZSXMLZ12JQvEmXTFCnmb
         DrNsKO/KijWtqmLyp8IoVFzeLbk4UQqFU7EdAPE4A/955uCbQ8P4BR8+rMZGQVeZOkK0
         s8aW4tsTugINtDj2KWS7vOXQCeDSFXKJUq8XyqMSvTbr8/23ozQqW2d3nBlxlPyF63xh
         GOPA==
X-Gm-Message-State: AFuF++mY1U55lJFan1IZyaquFb3EELw0APOWfz8QkN5y8ASqdbAl1n7E
	rEfucghXGo9boJoGDynbIeUCgOQ73Yru9bUHCURMN/SvivQjxTwHtM0jUfj/nYAhzmA=
X-Gm-Gg: AYBFou2ZRklk2N/6OYXUXojOXaZ2fErHLpwSGHs/KLHNAZUA40LIwizZgj87Iov1RLs
	+uI0CyZN9B/zHDuAk6Gd2TGZCMDkxycEZg2B8zMMIy9w4JWEMeNnHRNRowoR0aLSWYOgk1F7YjR
	omsb6DBKqAGBnUXwGey8EPsRbTh4rLjTqIlNF1p+OMVZEpcs6fJ4ZyuXhRQszvOXdWCGbnlsbrm
	Q7IiR4ovCCqTVH36/ihqSc9RS+pxo8i8hub8v4n/GsugeggP93Gu63zI3r1BUKb/tPVr04AlcGA
	f3HfrFNA83SCbthVRiHdF+amJOJ2ECVCCEqUhIbLSMG0Q1vPNRfcdvz4gGHlutxhj8dj3ghDhl2
	qc27p2wzwugEth0/2Yu3Z12hLp/k9L2i/QdPlT5/apn5FrzFpPDW/9Vfo57RPCbW51SNHILF22l
	Nt4CXcbjy73A8WkKiFEQs5i74Xl/DUi0i9qzmL73t5MgWndI7rILEn8m4HkA==
X-Received: by 2002:a05:600c:348a:b0:49c:f13e:e4d with SMTP id 5b1f17b1804b1-49cf15a3672mr43673625e9.10.1788448574919;
        Thu, 03 Sep 2026 08:16:14 -0700 (PDT)
Received: from metepc ([46.197.185.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee80eda4sm77097075e9.15.2026.09.03.08.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 08:16:14 -0700 (PDT)
From: =?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	kvalo@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	syzbot+adeb8550754921fece20@syzkaller.appspotmail.com,
	syzbot+101224300649c3eb8af4@syzkaller.appspotmail.com,
	syzbot+8141dcbd23a8f857798a@syzkaller.appspotmail.com,
	syzbot+b0ae8f1abf7d891e0426@syzkaller.appspotmail.com,
	syzbot+d6bbe0f5705cb8a5aa2b@syzkaller.appspotmail.com
Subject: [PATCH v2] wifi: cfg80211: avoid holding rtnl_mutex across all cfg80211_leave() calls
Date: Thu,  3 Sep 2026 18:13:11 +0300
Message-ID: <20260903151542.486376-2-omermetekaya0@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903151542.486376-1-omermetekaya0@gmail.com>
References: <20260903111705.472491-1-omermetekaya0@gmail.com>
 <20260903151542.486376-1-omermetekaya0@gmail.com>
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
  INFO: task hung in tun_chr_close
  INFO: task hung in switchdev_deferred_process_work

Fix by walking cfg80211_rdev_list under RCU and acquiring rtnl per-device,
so other rtnl waiters get a chance to run between devices.

I could not add the Fixes: tag because this patch addresses five separate
hung task reports whose cause bisections all failed, making it impossible
to identify a single introducing commit.

Reported-by: syzbot+adeb8550754921fece20@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=adeb8550754921fece20
Reported-by: syzbot+101224300649c3eb8af4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=101224300649c3eb8af4
Reported-by: syzbot+8141dcbd23a8f857798a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8141dcbd23a8f857798a
Reported-by: syzbot+b0ae8f1abf7d891e0426@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b0ae8f1abf7d891e0426
Reported-by: syzbot+d6bbe0f5705cb8a5aa2b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d6bbe0f5705cb8a5aa2b
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

