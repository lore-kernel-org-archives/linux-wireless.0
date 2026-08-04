Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4844756A0
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 17:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785865832; cv=none; b=nNduIvDogK64lAJxegfrTVh9I47Rq3NkwuEjdxTqv0Q1pxNPMxaTSS6eaUL0OxtYc1Wd86rmynRjsAb4RLyi7liNkQkBJYTTJLaNLkbCWvBTuCiMW/P/vDsmf72yHKrLL65ijA0cXV3BVlOrnaRuBPdlML7H4aKCP9hRXaOveZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785865832; c=relaxed/simple;
	bh=NRttHfrQMbSwV0j9al3v9vG2kQvP32A/IdIrSKkrFUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iugb39qQZU7gY6HFyGefhMkJTvXtwkfybxQseiQSBtMXVBWftA0yHzMeUXI8TDzu2wTtWD/zCAMDoVKCudNAWxbhC+Zwno0d/yIzNb2LJwXCejOnM2zoEseps20qBBPgW2CwuF0UzVwctUNDq1lo53dg5FmSJGepjMcu+h9p0Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IaD6tN16; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IaD6tN16"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785865822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3THMtZXW+3uc+ICg/Df1H+KExhySdFSX7okiNUpifcE=;
	b=IaD6tN16KOBoOS1frPeW8FR3UUeJWyBAECoWc2shnrRYkpxaTOSX6CCNmSpMziKUjzPO9G
	1ZY8eGQVWBVBjjQNiVaeMn09d446lHJ44fFRUkZK6CroBMo8dVzFi1kSbFYI9xRMooCY06
	UBoB2THUn8mbx9+uXaz4GeM3GUEuGsQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-298-3BnXttuiPQ6vBgz91YnuVw-1; Tue,
 04 Aug 2026 13:50:19 -0400
X-MC-Unique: 3BnXttuiPQ6vBgz91YnuVw-1
X-Mimecast-MFC-AGG-ID: 3BnXttuiPQ6vBgz91YnuVw_1785865817
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB9761956095;
	Tue,  4 Aug 2026 17:50:16 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.70])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 84015180044F;
	Tue,  4 Aug 2026 17:50:14 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v2 2/3] wifi: ath12k: prevent scan during firmware recovery
Date: Tue,  4 Aug 2026 19:50:00 +0200
Message-ID: <20260804175004.1761075-3-jtornosm@redhat.com>
In-Reply-To: <20260804175004.1761075-1-jtornosm@redhat.com>
References: <20260804175004.1761075-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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
v2: Fix radio[0] usage
v1: https://lore.kernel.org/all/20260727162748.963275-3-jtornosm@redhat.com/

 drivers/net/wireless/ath/ath12k/mac.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 7b7110ca6428..a57c2e91be84 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -5783,6 +5783,11 @@ int ath12k_mac_op_hw_scan(struct ieee80211_hw *hw,
 
 	lockdep_assert_wiphy(hw->wiphy);
 
+	for_each_ar(ah, ar, i) {
+		if (test_bit(ATH12K_FLAG_RECOVERY, &ar->ab->dev_flags))
+			return -EBUSY;
+	}
+
 	chan_list = kzalloc_objs(*chan_list, hw_req->req.n_channels);
 	if (!chan_list)
 		return -ENOMEM;
-- 
2.54.0

