Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF5B1F938
	for <linux-wireless@vger.kernel.org>; Sat,  3 Oct 2026 02:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790993519; cv=none; b=rLuCqQ4GghWrTn82HDMTvpm1Cq6dOULTsF4Nw485c+Qg2n81Vtme0K9sALrpFASTmkjKcIbe7VcbF0MVfkrttjJJOcP+D61a7f+UWG9B4El7Y0pnyx3pfEln0lOjRK7Ajr1K0OQO9nOVC6NTQ38zvuJpwTMuuddZWnWf44TPA8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790993519; c=relaxed/simple;
	bh=5ba+AIFlGWceY3fXdaiAzze9Fa+HRQbU3Qoi67Cxed8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kiKdGUPIPFt01zCQ1A9KIeBcIAZKYxGZ1SYZXOU1PGpLZh5kMGj29TjtDatA7Tx+3wnj17nyh6cC6EV3Ceeh18gQwBhIzin6uBrszP+3MCGTW+3kX9RxKkWnsUf2+iLhNpQLMFRCAEIvAm8BRBHzDewEAZU2C0shDqdsrYsBsyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i02COPYn; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i02COPYn"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-34b48100af4so158047eec.3
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2026 19:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790993517; x=1791598317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=L190hWySRAxyQE87dH/KusnmVEu7556vLx/BbFXjBgc=;
        b=i02COPYnYsErH1fIEF/4efcCkIvyfYznmL5BzXiXmbutcMgrYIGvo1et1r99EaTimD
         hdUX/NBopTrs48o+GvnG0HWMrz55HKVMxb2bT7GSCAIdAxPWI030nseEVt11QqW/poTJ
         1ukN5zmNJT3mQysKwuV1A1D5yR72ZSnqiSqqBYAXVx09ENuHPsHdAPcWH6Qo7Axhb1TO
         o+l1OvlHSYo4geKbm/4/b07ZVKMLpeJkU9II55iudAHyE5VcjHH37HcDXpA9Ui/SOe47
         xnU/8ozrRu2N33XJLrVW4lvISUUGR8/YItjehS9sgSdnnBpNlKfG/g3f1kfzeoTinCFj
         Mxyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790993517; x=1791598317;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L190hWySRAxyQE87dH/KusnmVEu7556vLx/BbFXjBgc=;
        b=daZ8XAfmwttEoIri19TarBFCE4hLMZuunPlvWnpkV4C4BMETYPaLFyzr+LrKoMV62s
         BhBpOeDQ7AIv6xwBH+gwCpJzA7MYfCpSMZUM/rl6c0hVI2Q7u2BevnfofycjhzW1rj9a
         7sksfeUH+YGQxMyb68/4vWZl/9zWp2BMlsFYd86apuhGChOWT998ke3iEOxoKpSwkNJE
         l+S5TyX0IwoN4QRUkqm+0PlFI2xBZ/r4Fs3yR/bB/gmgroC+OVVXF/j5rCKyGLGUwGv4
         zf3c1NWH663Fy6evvvyZt+XwWZGIfPfVtTXS5iE5ClDkIPOzzYmqCR6Y4NN/7PrcwjmW
         HyKQ==
X-Gm-Message-State: AFuF++mzATj2yzffCdmheCFkeRtP9udBOECAaSEJV/QtaMsXvFmklp7o
	8TQ0fDv30tXx3Y4rXIYKSYhkpNvFOOQx+sUcEsdyEmEA7NGKa9RTnHmB
X-Gm-Gg: AYBFou1kvZte6WMdM7waJX5GUa30vcZvgYEUtDmCcufhtaETD/AvXIli2tpQlJyaZgg
	onG9qlDaeXSjc7/HnLndEETU/a6RcyZER03FXp6EJlhUfPIpQYrixFmbXc5wjxdYeZrsFQbqpll
	en397axgu1gPSrjgD/Jp5giBSKDwj7XhnaoLa+m/QvVSuEUnrf453CH2b2q83RZPEhdDpjWCUgR
	OcCm7obYdG+EEQ+35DwtbzgJXHj0khHq43JujCWyGo2mMyjQAk2jJM5CwrC5DGJIAz+jCioCCwE
	VTj7cxywvJcOxGsf8AXz2gxuaXvJKcR3Oyv3cxdgU4GWpvYhPWLuISdqEKyYpsw1p5ciWH9Kdyo
	mfsIQzeV3JaKxHJzwpke5THyQfk7nuCFDFPPY4hRqXEvECiT54Vqaz3RsCRdyhOoX1ttcN0Mggm
	MLO+zfTWHjaiTUjnUzt/BmQiRGOv215PtZFNcbppOL2XoVD9gsFXjz/PlaJtoJN9aifR7SxZuIR
	4LY2zOJiFq9z77UoO1ff/7Ilr44bEv34eSQGnC68kXMp30/pGuATkIQhATJrXmqG8juOeYvmw==
X-Received: by 2002:a05:701b:2505:b0:143:6080:668f with SMTP id a92af1059eb24-14f5b9fb5c5mr5271144c88.7.1790993517103;
        Fri, 02 Oct 2026 19:11:57 -0700 (PDT)
Received: from deepanshu-Legion-Pro-5-16AFR10.. ([2405:201:682f:383f:a40e:1ae:8931:c183])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-151fc87346bsm2316287c88.8.2026.10.02.19.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 19:11:55 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: toke@toke.dk,
	jeff.johnson@oss.qualcomm.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+e91dc13b1b37759b3d9f@syzkaller.appspotmail.com
Subject: [PATCH] wifi: ath9k: stop WMI event tasklet from rescheduling itself on probe failure
Date: Sat,  3 Oct 2026 07:41:47 +0530
Message-ID: <20261003021147.7461-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the init guards were consolidated, ath9k_wmi_event_tasklet()
reschedules itself until priv->initialized is set. If
ath9k_init_device() fails, initialized is never set, so the tasklet
keeps rescheduling itself while the probe error path calls
ath9k_destroy_wmi() and frees struct wmi. tasklet_action_common() then
touches the freed tasklet, causing a slab-use-after-free.

Make the tasklet drop its queued events and stop rescheduling once
wmi->stopped is set, and call tasklet_kill() before freeing wmi in
ath9k_destroy_wmi(). The probe error path already sets stopped and
kills the RX URBs first, so the tasklet cannot be re-armed afterwards.

Fixes: 1af8dc9ca726 ("wifi: ath9k: Clean up device initialisation guards")
Reported-by: syzbot+e91dc13b1b37759b3d9f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e91dc13b1b37759b3d9f
Tested-by: syzbot+e91dc13b1b37759b3d9f@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 drivers/net/wireless/ath/ath9k/wmi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 4a08babb6d9d..f8b174b0f209 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -122,6 +122,10 @@ void ath9k_stop_wmi(struct ath9k_htc_priv *priv)
 
 void ath9k_destroy_wmi(struct ath9k_htc_priv *priv)
 {
+	struct wmi *wmi = priv->wmi;
+
+	tasklet_kill(&wmi->wmi_event_tasklet);
+	skb_queue_purge(&wmi->wmi_event_queue);
 	kfree(priv->wmi);
 }
 
@@ -148,6 +152,10 @@ void ath9k_wmi_event_tasklet(struct tasklet_struct *t)
 
 	/* Check if ath9k_init_device() completed. */
 	if (!smp_load_acquire(&priv->initialized)) {
+		if (READ_ONCE(wmi->stopped)) {
+			skb_queue_purge(&wmi->wmi_event_queue);
+			return;
+		}
 		tasklet_schedule(t);
 		return;
 	}
-- 
2.43.0

