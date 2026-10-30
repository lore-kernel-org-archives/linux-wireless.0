Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793351364;
	b=Zclb7t4kw1hGi/VGwQwSYFWlYe82tTKqY3y/ZVF5wDJjqOY0z+WEsqOUsiiuD/wFUxZy
	 0yt7UAhF0BA2J+vO7RzCB4gduFwY2fD1B9g5Rg0QzC5Mko+z2sc3Psb8XiJHimlxpFVIo
	 ZWCuVNJcL/CQFrrQ+zhlMzm8rtg2enFLanrcJoxcP37rnYz4AkkLqMKwHY5f0WTJXn1Uz
	 2Nv+7Ei1uu3RbuqPTtD7AbatdRfl4fpmEGp3SCAsYri9MbGUgREx2PGC9vLbtym59Eb7N
	 RaKeMuhBM5C3dPu0dXan0lfvpkOo4GQrmKmhQhNF5UV00FqXprK9kPATUvJzf6CUGig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793351364;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=ZkMDNCTbHZPjo1kRABP18CGjONpKH16ExnHAKYrhxSk=;
	b=hOESbP6iaGwlvt70E0lEot2/3B7NbKvDwihje1lPPbWD72vHg6F/OmnF7sjrWJ4rFvg5
	 iUoezqJFIGWN+FSt1bJ3t9upjVennaSIL/mp37mps+qQbT2DMseSsQQdKh0VYh7O7sS1H
	 psoqcQ+rrV5tCr9/3RCOWCG2L3eiZDlWFwsMAnA+5YdUwMqwat1F0olRok6i163OUdTW1
	 sZZZ8KYtu0y9299SCajJ+pHekcCsSixrkhhFSdEDqiPiPQ1xm58TCkVjB3GlVUbBPoN4z
	 n76d3o3xts7pcsJfcUKcImCwz3/I60WtxbngKloGmi2nhBxFPUCIV5/YRfjc+T/8y7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=AVBK7MtD;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B79B606A324
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 09:09:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B79B606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=AVBK7MtD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793351363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZkMDNCTbHZPjo1kRABP18CGjONpKH16ExnHAKYrhxSk=;
	b=AVBK7MtDNROxqDvOvWLbU6tKLnKZzA1nhIKqHySqpiKZQIDFTcW+T6xVhf/gDG1W+cdHlr
	cmbmtrKcSONeMymv5IL4jf0V8xYRPnBdoc0uS1IJP47ky+m74BMGTk59wRWTW3ar0S5s35
	cTa71VRZLy0AlF/fPMVDCKzjJHz5YHg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-_isT2R19MFe_XnFa7sZTSQ-1; Fri,
 30 Oct 2026 05:09:13 -0400
X-MC-Unique: _isT2R19MFe_XnFa7sZTSQ-1
X-Mimecast-MFC-AGG-ID: _isT2R19MFe_XnFa7sZTSQ_1793351352
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 59E2E1955EB0;
	Fri, 30 Oct 2026 09:09:12 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D0AC11800495;
	Fri, 30 Oct 2026 09:09:09 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH] wifi: ath12k: fix wrong register read for RU start index of 80_3 segment
Date: Fri, 30 Oct 2026 10:09:06 +0100
Message-ID: <20261030090906.298234-1-jtornosm@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

The RU start index for the fourth 80 MHz segment (80_3) is read from
rx_usr_info->info2 instead of rx_usr_info->info3. The bitmask used
(HAL_RX_USR_INFO3_RU_START_IDX_80_3) is correct for info3, so applying
it to info2 extracts garbage bits, producing an out-of-range shift
exponent that triggers a UBSAN splat:

  UBSAN: shift-out-of-bounds in drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c:302:22
  shift exponent 284 is too large for 64-bit type 'long long unsigned int'
  Call Trace:
   ath12k_wifi7_dp_mon_hal_rx_parse_user_info.cold+0x3a/0xef7 [ath12k_wifi7]
   ath12k_wifi7_dp_mon_rx_parse_status_tlv+0x621/0x990 [ath12k_wifi7]
   ath12k_wifi7_dp_mon_parse_rx_dest+0xa9/0x2b0 [ath12k_wifi7]
   ath12k_wifi7_dp_mon_srng_process+0x34f/0x560 [ath12k_wifi7]
   ath12k_wifi7_dp_mon_process_ring+0x205/0x270 [ath12k_wifi7]
   ath12k_wifi7_dp_service_srng+0x1b4/0x5e0 [ath12k_wifi7]
   ath12k_pci_ext_grp_napi_poll+0x43/0x100 [ath12k]

Read from the suitable info (in this case info3) like the other three
segments do.

Fixes: 5db19c488413 ("wifi: ath12k: Move MU user processing to Wi-Fi 7 module")
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
index 1e29c13ad66d..0e69d9fe138b 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
@@ -293,7 +293,7 @@ ath12k_wifi7_dp_mon_hal_rx_parse_user_info(const struct hal_receive_user_info *r
 	}
 
 	ru_type_80_3 = le32_get_bits(rx_usr_info->info2, HAL_RX_USR_INFO2_RU_TYPE_80_3);
-	ru_start_index_80_3 = le32_get_bits(rx_usr_info->info2,
+	ru_start_index_80_3 = le32_get_bits(rx_usr_info->info3,
 					    HAL_RX_USR_INFO3_RU_START_IDX_80_3);
 	if (ru_type_80_3 != HAL_EHT_RU_NONE) {
 		ru_size += ru_type_80_3;
-- 
2.56.0

