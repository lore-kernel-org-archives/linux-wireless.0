Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661CC42376E
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 16:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785169696; cv=none; b=LaonMW9shTocSiDGDUGcIfTDZbhcwueLrtkIxdZeex/FsA5ImK97ZKoycTTNJf/wC/xIbTyLNshUAH1NvgJzYOD9iaS6fiKYFi0GMJnz96VHRzOd7MNWNaF6AGhWebPuCwIe+rNo0eJ6r1wNgPSjli+A62adr+10VZVh053ZQBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785169696; c=relaxed/simple;
	bh=zUUgCIsrjbafcQNdQe6N1OTXElxC7tytjLH6YwBdthg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBFdNShk0KbegFiuTjyThmRQ/UjVQCzdCHkNi/Zap5MStYeqPHuQaqif1s+XjtXPY/KXE+bFxFbT3fcOxtcI3kQWKqHCw+P0XmliS4WajeiPzE45aXnDY6dxp0VttFLa75hYu9Y1XJ1Ki3gwQzYk1okRc8V5XkTw+nh5XuPrL/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LQigu9Mj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LQigu9Mj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785169694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5c5LHNMDyrfpbCL+oP67Kl7Zt1ZSK6M0DXqAXGnTsGs=;
	b=LQigu9MjQGh85AhL8cTNi/TcI/tonN8NptlXkBsA3KjJhrnr28+8txNc5ag3sUONal/WwJ
	hkbC5itKlagppOekACPZyyjYWN4a/VsqeMs2KrqEUZ5reoNxf3ibKnbC9O1T82M0/hs1T1
	WlxoXHFJcm52uZLTrEGZfAO4QNe3DZg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-53-ZL5RVDsFO5aq4w3Pe7Z7_Q-1; Mon,
 27 Jul 2026 12:28:10 -0400
X-MC-Unique: ZL5RVDsFO5aq4w3Pe7Z7_Q-1
X-Mimecast-MFC-AGG-ID: ZL5RVDsFO5aq4w3Pe7Z7_Q_1785169689
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 939BC195606D;
	Mon, 27 Jul 2026 16:28:09 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.32.58])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 26858429;
	Mon, 27 Jul 2026 16:28:06 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH 2/5] wifi: ath12k: prevent scan during firmware recovery
Date: Mon, 27 Jul 2026 18:27:45 +0200
Message-ID: <20260727162748.963275-3-jtornosm@redhat.com>
In-Reply-To: <20260727162748.963275-1-jtornosm@redhat.com>
References: <20260727162748.963275-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

When firmware crashes while wpa_supplicant has an active connection,
wpa_supplicant may immediately attempt a scan via nl80211 while the
firmware is still powering on through MHI. ath12k_mac_op_hw_scan()
proceeds without checking the recovery state, accessing partially
initialized radio structures which leads to a NULL pointer dereference:

  BUG: unable to handle page fault for address: 0000000000001508
  RIP: ath12k_mac_op_hw_scan+0x148/0x2b0 [ath12k]
  Call Trace:
   drv_hw_scan+0x88/0x140 [mac80211]
   __ieee80211_start_scan+0x2bc/0x6b0 [mac80211]
   nl80211_trigger_scan+0x54a/0x9f0 [cfg80211]

Fix by checking ATH12K_FLAG_RECOVERY at the start of
ath12k_mac_op_hw_scan() and returning -EBUSY. mac80211 will retry the
scan after the recovery completes.

Tested on WCN7850 with MLO (Wi-Fi 7).

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index f33976fc1233..924c3c21ca78 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -5707,6 +5707,9 @@ int ath12k_mac_op_hw_scan(struct ieee80211_hw *hw,
 
 	lockdep_assert_wiphy(hw->wiphy);
 
+	if (test_bit(ATH12K_FLAG_RECOVERY, &ah->radio[0].ab->dev_flags))
+		return -EBUSY;
+
 	chan_list = kzalloc_objs(*chan_list, hw_req->req.n_channels);
 	if (!chan_list)
 		return -ENOMEM;
-- 
2.54.0

