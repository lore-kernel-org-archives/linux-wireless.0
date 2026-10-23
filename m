Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792752127;
	b=oe/0LjPZkFzw6jtHGCbFpFO3SSWCzlUl8VZSNVGhH0M16O88nVydL4jneoOjvPNLa2yx
	 brhhkA1ggDO4fnrakM5R2Hsg5nNAR7LtXDD5Cq5aUAn081Rl+VYuYsM2UjXptZTflinFQ
	 uGm8BaT9Ng1t5ajG0LGkhZ40y6g/vgdCp9fdVtHxIqvM08Vv6y7KPJGynhoew8RNVNGUf
	 e2t9JB/jQx/zE4MJKvrQ9/tKrrYnw8WQG0XUnQOhoiRr2/77zyChh02fDKTyuY85sIUTL
	 rGBxwU4Xiz2tuNpiKmEMddhiC1EnZJ9GW42+/TTnv18rbik39fGXE3cJ28aFWZOwfwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792752127;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=/NFK43oOzJfr8L2hy16WF2YSsrjDDXnWtTpY4uSA574=;
	b=h7/Reuh5A299/E/pBnEcy9JbXsghL4eE9Pyt+5RKZ63jpXR5/DzvfQ9R6ds4CDWh8wng
	 qJcJ3XsrxlAem4SmBdikuE3HYONMx3ROwUUBotlMDcrXBagQGlA/UobhXoUc+ErDMJ3dI
	 yA9DfCH5wJXTjgrbCLYJ/YTSuW0u6AMDFOlsRYdonCd2spkmfmjXUn7ITE8zhEJN5odSO
	 spPHPbkkJwVr946B1D5DvYCrAZ5rnJYApc1zwFhNFuZOxrBhsuKJHCjh9thI6aGMT1RSa
	 r+M5lH9VJirUEMTCMVXPg5T5hwWlqbCLaB5uU3/M7/WvpgRbzt5hZq1w/8Quvj0KOaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Gpceg3xr;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8957606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 10:42:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8957606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Gpceg3xr
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so3850795e9.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 03:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792752125; x=1793356925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/NFK43oOzJfr8L2hy16WF2YSsrjDDXnWtTpY4uSA574=;
        b=Gpceg3xrXgFA+DKsoVAbMos73W+cLVI9xIoWVPYxVJtjtNr05ux7SDs23k+/70PzsI
         6ojDF3R00BDPYS0HvJYtimBpCN+l2kUwu9tllEhhcdKwfSTk2Rx4U14HZ4s+4U/3fdnd
         OGKxYRQnVFE5aLUPoK7dDOTxd4+QVhVFCeIJon8rWJk5Me1dblZKt0txLZakfXBBS9k7
         ZfxhPQHHGCs/ZyZtF5p9lXvG+neWFtVPae+jykx5xJoqMMj305iNRdGTcIt7DYIVFjhf
         +i2yhCG+5hUo+QhTr4xxTi3uy9myDX0ycuQP/1yTm1BNExVoPRxPfsseCyVgxXFw3gfv
         +mXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792752125; x=1793356925;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/NFK43oOzJfr8L2hy16WF2YSsrjDDXnWtTpY4uSA574=;
        b=s0czmELP3AD/pq7T/MsKdXFZ7MSgXtpcGHWJoxozsYwAaBPors40wdGg9oOCbdwFcw
         Kb7dFRmGBMXeGwcdJf97XHFX9VYx2lFJK305cFdckNbX9AM9sMbvcBLOWIIhFKREgN1f
         fDwXL9OEp/q7z4dTfLNjVW15E7+L5tKe4r4sH9x+gMstegaFXUkVdl4Ql+uLnFDNbSAy
         VFaldz9AzjiD60Jh6hnFyDvzjlqdOZF0Uq1hdNem7zkaU+lwZyDuTm/lh8lPyHAOYp1i
         dgXnyFzxP/qgt6nvT6Xsu+qqaGEg5JqaUaFsyLsJMBW9FJIgfttJrzwc8WnoQFGi7o1P
         j96Q==
X-Gm-Message-State: AFq9FYInTgcMQGAHgXpt7RSd6shDv2jRJiQqTZiQGKyVp5sdUy9h17/M
	tJmCXH9GnXRUrqahGNxznAo4SmlN3WTSdhZIQLzCPyH2QUZlOuqUBkM8Dp+6Dw==
X-Gm-Gg: AYBFou1ndkxvTQ8YKR2pln8MsNQIKA4j9KQs9kOp9W/c/uqMB/GhSpW/2G8ZNc5jFDT
	FmQtBcTCl044PJ3EssNqoCNbCOvF11cL0EWSFt6DtCZaLT6JD8BTXle5CpKno8jFoeBhuOueIew
	HiGPF8Fp2RFyicwL0sEaTXYfkE3qtY3/344BNTik/4ogKy4kRHQo5Atn0h76UsscXySdYUzUUNB
	FyS+0A9u8J+Kb6pa2x/I/IE/IwD6WxpNTGLsJauuEMqe38A8tLP7iZ5a990RqCsCQr2w28uULIf
	wfPLa6s2IUb9AH/DrdlevSJmz7TKaPxqEeNlN4z975j1sZ+sOUnEpbLti1yPSjzFE466CTCXiZ9
	egxMfAXqPaJE97wZT9+391Au2f6KRMigYG3o9yM+JwRk5AJPdOCdIoiii8HxVqyiy9j1CSm6Ovz
	9ZcoTLeIehT3ZjNf6QXRM0xh0t1Cc7VOtkRggvuDhAgtDwtnydT8JedkyFsPFPtiRcHkyEN/S6z
	lE+99vpOMZV+hmLEVwPcjzjYNsHVph3cgxMrWnovjtheKTjKQiH8fbVTdkVZ46grnSBDtV1ezVg
	pk668USywGxH3U+0Y2MNnmg0CFSKstI8m5EkMOzoW6u4Vgi7O46H1fdoUGBXOf7/QA2qAl/r/wP
	idt8=
X-Received: by 2002:a05:600c:4e55:b0:4a1:d41b:5060 with SMTP id 5b1f17b1804b1-4a211ed013emr27247015e9.22.1792752125001;
        Fri, 23 Oct 2026 03:42:05 -0700 (PDT)
Received: from omarchy ([2a02:ff0:1e10:93f:e71c:400:f186:eea4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a210487d16sm66719955e9.15.2026.10.23.03.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 03:42:04 -0700 (PDT)
From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com,
	linux-kernel@vger.kernel.org,
	rtl8821cerfe2@gmail.com
Subject: [PATCH rtw-next v5] wifi: rtw88: pci: wake the TX queues after restart_hw and interface up
Date: Fri, 23 Oct 2026 13:41:54 +0300
Message-ID: <20261023104154.2755289-1-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a TX ring fills, rtw_pci_tx_write() stops the mac80211 queue and
records it in ring->queue_stopped. The completion loop in
rtw_pci_tx_isr() is what clears them, and it needs a descriptor to
complete. If the device goes down first, rtw_pci_dma_release() rewinds
the indices and frees what was in flight, so nothing is left that
could. ieee80211_reconfig() does not help either: it wakes only
IEEE80211_QUEUE_STOP_REASON_SUSPEND, and an interface down/up does not
reach it at all. TX then stays dead although the device came back.

Reset that state where the device starts, which both
ieee80211_restart_hw() and an interface down/up reach through
rtw_core_start(). Gate the wake on ring->queue_stopped so that a
start which stopped nothing leaves the queues alone. The wake cannot be
narrowed to the queue the ring-full path stopped: the flag sits on the
ring, and rtw_tx_queue_mapping() puts management frames and multicast on
rings of their own whatever queue they came from, so a flag there does
not name a queue. mac80211 also keeps a single non-refcounted DRIVER
stop per queue, shared with the scan paths in fw.c, so
ieee80211_wake_queues() releases whatever holds that slot.

Signed-off-by: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
---
v5:
 - reset the flags before rtw_pci_enable_interrupt(), move it into
   rtw_pci_reset_tx_queue_state(), and add the blank line before
   running = true (Ping-Ke Shih)
 - justify the gate by what it does on a start that stopped nothing,
   and give the cannot-be-narrowed note its actual reason (Luka Gejak)

v4: reset the flags and wake from rtw_pci_start() instead of
    rtw_reconfig_complete(), so an interface down/up is covered as well,
    and name restart_hw in the subject (Ping-Ke Shih)
v3: wake from rtw_reconfig_complete() on RECONFIG_TYPE_RESTART
v2: wake from rtw_pci_reset_trx_ring(), gated on ring->queue_stopped
v1: https://lore.kernel.org/linux-wireless/20261002231013.11792-1-abdurrahmankaradag19@gmail.com/

 drivers/net/wireless/realtek/rtw88/pci.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 66d2e5f..c7ccde8 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -568,6 +568,23 @@ static void rtw_pci_napi_stop(struct rtw_dev *rtwdev)
 	napi_disable(&rtwpci->napi);
 }
 
+static void rtw_pci_reset_tx_queue_state(struct rtw_dev *rtwdev)
+{
+	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
+	enum rtw_tx_queue_type queue;
+	bool wake = false;
+
+	lockdep_assert_held(&rtwpci->irq_lock);
+
+	for (queue = 0; queue < RTK_MAX_TX_QUEUE_NUM; queue++) {
+		wake |= rtwpci->tx_rings[queue].queue_stopped;
+		rtwpci->tx_rings[queue].queue_stopped = false;
+	}
+
+	if (wake)
+		ieee80211_wake_queues(rtwdev->hw);
+}
+
 static int rtw_pci_start(struct rtw_dev *rtwdev)
 {
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
@@ -575,6 +592,8 @@ static int rtw_pci_start(struct rtw_dev *rtwdev)
 	rtw_pci_napi_start(rtwdev);
 
 	spin_lock_bh(&rtwpci->irq_lock);
+	rtw_pci_reset_tx_queue_state(rtwdev);
+
 	rtwpci->running = true;
 	rtw_pci_enable_interrupt(rtwdev, rtwpci, false);
 	spin_unlock_bh(&rtwpci->irq_lock);
base-commit: 9b0be45d4d52fd223994e151f169743a97abd290
-- 
2.56.0

