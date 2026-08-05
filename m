Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22D83FADE8
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 19:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785957788; cv=none; b=SsXYIwTL2/KVAD1CwlGmq3mkRchyTy56d7ZsLYSSw9F56MKBYtp6WrxvKUpZDTidzt7MfHepqCcTnyntPLd4HJQr5LG/xFwGl//fIDoHD5RY7TEPRWnQIwL27X+Ww5W4529RdtYVuBUALC9z4Q3cqKWe5q1prrpb6vLLMOCs0us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785957788; c=relaxed/simple;
	bh=xJ1s7r38HIwv4XJzwXlsQBj8krthuIXQuGjxORyM9IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FR828s1e2ZRYCEaK+sCB0Yk4ag6ZXHWfZhbT2MeEV3xi9s8T26NaHYGJiPaBCJf3F96WuvZTzxBsfYeKkseCKvwEzGNvkJ/gKW08y8iyrCw9TvQEjR1pEMHOKlIC5LdBnC5PFeI6mACJ49SE13yyiqoHuF8bBZAAs60fNWOoM0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=LeMb1Kxb; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="LeMb1Kxb"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a14f118a46so1998587a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 12:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1785957774; x=1786562574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lTF4WLzFw0fB3oAy0Rqnuzx+Ko8HpiZOmOtSBbcLZxo=;
        b=LeMb1KxbuOHf26206HZCrQCI28mCxog+nPI/YhDtV4qmbSxS7dj+yN4IR/Ux7OF/cy
         R6cvMAyUpQfE3hn2QEWiPlXpABVJVxhaf/EhfMswBZkM1QL2Svi0TIlB9JKKU3uOGBkN
         5P2A4AwU4oM17iPgeh80yb9l0II6dBAobOi87ieSYxm0Gv4CKDngctQtj2/q7znebBZR
         gZ3aV9PdiKQrqROvljJT9vfR7NGolB/2bMWX/fKeSKfd5u1wHxg5Q3FWaJpz70gJJNyZ
         ZJ/3CmD1+m4rLJ8PmPpmi6FH3j45oA+U9N4nzrpDb97bbHdthhFV1nlQcxKB3zuLOz4x
         kXXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785957774; x=1786562574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lTF4WLzFw0fB3oAy0Rqnuzx+Ko8HpiZOmOtSBbcLZxo=;
        b=YwRbFQJDKbB/U7eTOKnLgDwtixwTD94Qk2V2Zvaf6Y1xm/82PEbTNcFZlsxmb20pyU
         fsvhnjHQ/xIMco2b8gxFCym3iOBeKyU5z43SMzmsKNrQxOC46gjZclshio8QBc2sDQDX
         lXS2fuprM9fIrvK9Gb/KCKaM8+bn592cLNFjWUxvBLwdyUmyqoBXqjkU8fxyMKltGeSB
         0m3zfj8PzJCCoCe3YQYBbn4Z66P4Woz4FlIdqTj3RyiGI5CDFWL1Lk1P1l7MeIM7rKUP
         5JSVCB8Bn8mDJW56scqYoPGXy8ZZ4lv7PRhtsNqr4GtK8Y6Zsn33rPMJgjp30xuJpR9Q
         WMKQ==
X-Forwarded-Encrypted: i=1; AHgh+RoUe1A8NciEXdIziwGmIktgEndE7icwzVRgQljSAnhXeFZS56TO3QWMjk1ncoo9lL3AVt0cF5fLjVjtvNvcmA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyWr6zg+aGJjrB+qq4xRd156Fhy5kcJkZyufpi7DLHcqvI3vMPC
	QlQdAFnbkxpbqnxfFUZT9N2KDq9Aq+1VqOXsCteryW/GNlOv+wuJbn0BhzP4AULczQ==
X-Gm-Gg: AR+sD139KC4BvzhETFrebj3tP8Tmf6nqnKI567W3/CL++loXLW9M9K+PzFzU4KKU5ov
	D3o1Z5kF3LBSCriZ34QmSYs/NqqieHij7ukjKlX+JA9ppK5H2XC5vw1jOPoZ0m1Cv9Zzd4+NARU
	N2rvYA8lOXt17vc6ucHR31PuMu4Ch8VIi5ybSGYykyFT4JxXDFVo57nhXcbvY6Hs/H9piLbjPXe
	x6NH2bLWL0eQWjMTIQgtF+u1eGeOqGD14C0VNNsFEmP8XU+3H06CJ7LMyJkPRgLCBzSZL+Muq90
	6DaYoiYDrBzVmxKfSUzdPp5Br+8dPqTLmuQ9yuYLWHdL2hvKwlnQmCekP09T6gZhHuARok4rNC2
	VRs5A4YWDBQteQ/lNYRyi9SVylwWwe1/Z9g9vf9IfofRr9zqer8Y0guKj+UbvXagAf1pWU0cGpD
	Dc60QM3kIBUHrMgW+oI2joLteBGQzwlRYtgHoMzibZ6qMIKO8jwsd4Du0TwlLbQgvlwvVwHHflW
	86mj10gmVRQh/JYzc38NWbBwmQ8brC2iWGfbBYsKfNZAXlsjNfRFYyYNSyVFeIT/WsGbUwdt8dy
	Mj8+ppITD8rLR4NxHcV9y+edYXM/31b3bww7hmFEJpk77+/iRa+AQwu/ZQKFw+0QS/Z8ia4bLpg
	lsGlZFeO0YNh46wJnXdaamdeqzEu5mLc+DCZjChJjGSd8Unqm4qPV+CXuHUR7Dk9MI5+SZbzK1K
	bqcue8GLXpbJ+XpGDDCa/0ltpd
X-Received: by 2002:a05:6402:51cf:b0:6a1:4458:7f2d with SMTP id 4fb4d7f45d1cf-6a14f0a65d2mr4988463a12.5.1785957773983;
        Wed, 05 Aug 2026 12:22:53 -0700 (PDT)
Received: from Desktop (pd9513cee.dip0.t-ipconnect.de. [217.81.60.238])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a17d6216cesm1180713a12.31.2026.08.05.12.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 12:22:52 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baochen.qiang@oss.qualcomm.com,
	vasanthakumar.thiagarajan@oss.qualcomm.com,
	rameshkumar.sundaram@oss.qualcomm.com
Subject: [PATCH ath-next 2/2] wifi: ath11k: initialise the CE descriptor waitqueue once per device
Date: Wed,  5 Aug 2026 21:21:29 +0200
Message-ID: <20260805192129.61113-2-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260805192129.61113-1-julius@bairaktaris.de>
References: <20260805192129.61113-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k_wmi_pdev_attach() runs init_waitqueue_head() on the pdev's
tx_ce_desc_wq. It is called from ath11k_wmi_attach() ->
ath11k_core_start(), which firmware crash recovery re-runs through
ath11k_core_qmi_firmware_ready(), so the head is reinitialised on every
recovery - including while a task is still queued on it.

Parts with hw_params.credit_flow clear - ipq8074, ipq6018, ipq5018,
wcn6750 - take the else branch of ath11k_wmi_cmd_send() and sleep there
in wait_event_timeout() for up to WMI_SEND_TIMEOUT_HZ. That is longer
than a recovery takes, so an ordinary WMI command issued from userspace
just before the crash is still on the queue when the head is cleared
under it, and finish_wait() then deletes the entry from a list head that
no longer refers to it:

  WARNING: CPU: 1 PID: 1861 at lib/list_debug.c:62 __list_del_entry_valid_or_report+0x110/0x154
  CPU: 0 UID: 101 Comm: hostapd
  Call trace:
   __list_del_entry_valid_or_report+0x110/0x154 (P)
   finish_wait+0xcc/0xd0
   ath11k_wmi_cmd_send+0x150/0x2f4 [ath11k]
   ath11k_wmi_vdev_set_param_cmd+0x64/0xd8 [ath11k]
   ath11k_mac_op_bss_info_changed+0xe8/0xf60 [ath11k]
   drv_link_info_changed+0x118/0x160 [mac80211]
   ieee80211_link_info_change_notify+0xe0/0x100 [mac80211]
   ieee80211_change_bss+0x1c8/0x250 [mac80211]
   nl80211_set_bss+0x1a0/0x330 [cfg80211]

Initialise it where its credit-flow sibling ab->wmi_ab.tx_credits_wq is
already initialised, in ath11k_core_alloc(), which runs once per device.
The array is fixed size, so all of it can be set up before any pdev is
attached, and nothing on the recovery path touches the head again.

Reproduced on a Xiaomi AX3600 (IPQ8074 hw2.0) with a userspace loop
pushing beacon updates while the firmware is asserted through the debugfs
simulate_fw_crash 'assert' trigger, on a stock ath11k with no out-of-tree
modules loaded: one warning per recovery, on all eleven recoveries
observed across two builds, and none at all over six recoveries with this
applied.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.12-01460-QCAHKSWPL_SILICONZ-1

Fixes: f951380a6022 ("ath11k: Disabling credit flow for WMI path")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/core.c | 5 +++++
 drivers/net/wireless/ath/ath11k/wmi.c  | 1 -
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -2746,6 +2746,7 @@
 				      enum ath11k_bus bus)
 {
 	struct ath11k_base *ab;
+	int i;
 
 	ab = kzalloc(sizeof(*ab) + priv_size, GFP_KERNEL);
 	if (!ab)
@@ -2772,6 +2773,10 @@
 	INIT_LIST_HEAD(&ab->peers);
 	init_waitqueue_head(&ab->peer_mapping_wq);
 	init_waitqueue_head(&ab->wmi_ab.tx_credits_wq);
+
+	for (i = 0; i < ARRAY_SIZE(ab->wmi_ab.wmi); i++)
+		init_waitqueue_head(&ab->wmi_ab.wmi[i].tx_ce_desc_wq);
+
 	init_waitqueue_head(&ab->qmi.cold_boot_waitq);
 	INIT_WORK(&ab->restart_work, ath11k_core_restart);
 	INIT_WORK(&ab->update_11d_work, ath11k_update_11d);
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -9064,7 +9064,6 @@
 	ab->wmi_ab.wmi_endpoint_id[pdev_idx] = conn_resp.eid;
 	ab->wmi_ab.wmi[pdev_idx].eid = conn_resp.eid;
 	ab->wmi_ab.max_msg_len[pdev_idx] = conn_resp.max_msg_len;
-	init_waitqueue_head(&ab->wmi_ab.wmi[pdev_idx].tx_ce_desc_wq);
 
 	return 0;
 }
