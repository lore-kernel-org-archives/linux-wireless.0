Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792562987;
	b=O2Egq1glbzdJMekpM2hPJROnZ0YbwaDCwynWojavxx1FbQMXg/tsm3OVdUZDWERNXuE1
	 XxpdZ392Q/Fgs3GwN5aZ7QE1IOQyL5GJ1jq2Tg1dlOrGvC2Bj5l5hzlZBl7H2ZDx0PlzC
	 pidP3RW3JVsvg07mACRrzcWosJkS9dHmba19B+Vn7dXHY1+e8JE19r44HgWcQbRGSqwVo
	 +lPkT8BqnHkoP9C1DqLcruBjaNEh6Iw0jEeR0Z6q8z9vRzQbcsqFy4YhCA/V69Mt6FYRS
	 f6INZjKL2dW1jGgYpuF2lUT9jSjbKT15FXuFV126q6S1PNAfZx+lDY+WB8414Lt+3Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792562987;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=/oPZ5v8UURnygDGPq56oBxX6OW/e3IZH+1dLPLTtNgg=;
	b=FQglHMU1TiVjQ22N59CWmRDHuqsFw0kIaBbPiSwsoF0tAnEliCbt/C2Hrr3UCiWKHh6r
	 /6wO/CseyBwEYcS+rvkrK+0wbEkvsJASaH7Yf1uvy+MjFmITsQP4qytmn9P6d+HqDT8R7
	 RmOlD/edP2EJ6uO95OmvQySxsk+G+HAsbm9kQptdr6iUGpQ2dTlwY3sBQAvQltDkaiy4v
	 dVCQNYrTZkE8oP3hy6eEQITk9C8M+Tyx4toRM4PsLMPvBxG34Fg79D/hlbbTy5/lz2it/
	 pQxSjtpfxQ0nrM4OUs1r+nEgqZokMnbt+ih/4ltVWNRUi9cOmrJKTjpq07F0+zKa8fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=NStONL2R;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81714606A32E
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 06:09:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81714606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=NStONL2R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792562985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/oPZ5v8UURnygDGPq56oBxX6OW/e3IZH+1dLPLTtNgg=;
	b=NStONL2RYvttRjlT+puWzYWNLOgE33z/ELVpoKdN3/DN/tGKw18LMDgQsuHdbMV4Crq0Na
	J+ovLLessN85SwxVFSIXTPiWlhsJjFRDXnYLnI7StrTqoGZAkH09DtphJij8AqY+cwU6+c
	/LdrsT9kHJPAJm2H9GVfiHXJ8JvjWYY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-551-Or28QkqkNAyBY-zPtmy13w-1; Wed,
 21 Oct 2026 06:09:44 +0000
X-MC-Unique: Or28QkqkNAyBY-zPtmy13w-1
X-Mimecast-MFC-AGG-ID: Or28QkqkNAyBY-zPtmy13w_1792562983
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 280A4180066F;
	Wed, 21 Oct 2026 06:09:43 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6A1521800480;
	Wed, 21 Oct 2026 06:09:41 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v8 1/2] wifi: ath12k: remove skb parameter from get_ring_selector
Date: Wed, 21 Oct 2026 08:09:30 +0200
Message-ID: <20261021060931.249629-2-jtornosm@redhat.com>
In-Reply-To: <20261021060931.249629-1-jtornosm@redhat.com>
References: <20261021060931.249629-1-jtornosm@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Change the get_ring_selector hw_ops callback signature from
get_ring_selector(struct sk_buff *skb) to get_ring_selector(u8 ac),
removing the dependency on the skb.

All ath12k get_ring_selector implementations fall into two categories:
 - smp_processor_id(): ignores the skb entirely
 - skb_get_queue_mapping(): only reads the AC value from the skb

Since the AC is the only information extracted from the skb, pass it
directly as a u8 parameter instead. Callers in the dp_tx path now
pass skb_get_queue_mapping(skb), which preserves the exact same
behavior.

This change enables a subsequent patch to call get_ring_selector()
from wake_tx_queue using txq->ac, without needing access to the skb.
mac80211 guarantees that skb_get_queue_mapping(skb) == txq->ac
for any skb dequeued from a given txq, since both values are
derived from the same skb->priority through the same AC mapping.

No functional change.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v8: Split ath11k and ath12k into separate series to avoid conflict
    with Julius's airtime queue limits series (ath11k only) and help to
    unblock both
    No code changes from v7
v7: https://lore.kernel.org/all/20260917064825.12747-3-jtornosm@redhat.com/

 drivers/net/wireless/ath/ath12k/hw.h          | 2 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 2 +-
 drivers/net/wireless/ath/ath12k/wifi7/hw.c    | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
index 86fb8b719613..65caa7a2349f 100644
--- a/drivers/net/wireless/ath/ath12k/hw.h
+++ b/drivers/net/wireless/ath/ath12k/hw.h
@@ -243,7 +243,7 @@ struct ath12k_hw_ops {
 	int (*mac_id_to_pdev_id)(const struct ath12k_hw_params *hw, int mac_id);
 	int (*mac_id_to_srng_id)(const struct ath12k_hw_params *hw, int mac_id);
 	int (*rxdma_ring_sel_config)(struct ath12k_base *ab);
-	u8 (*get_ring_selector)(struct sk_buff *skb);
+	u8 (*get_ring_selector)(u8 ac);
 	bool (*dp_srng_is_tx_comp_ring)(int ring_num);
 	bool (*is_frame_link_agnostic)(struct ath12k_link_vif *arvif,
 				       struct ieee80211_mgmt *mgmt);
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index d2749de44553..74359e8eea47 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -111,7 +111,7 @@ int ath12k_wifi7_dp_tx(struct ath12k_pdev_dp *dp_pdev, struct ath12k_link_vif *a
 	 * If all rings are full, we drop the packet.
 	 * TODO: Add throttling logic when all rings are full
 	 */
-	ring_selector = dp->hw_params->hw_ops->get_ring_selector(skb);
+	ring_selector = dp->hw_params->hw_ops->get_ring_selector(skb_get_queue_mapping(skb));

 tcl_ring_sel:
 	tcl_ring_retry = false;
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index d9fdd2fc8298..7436cf70925a 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -49,7 +49,7 @@ ath12k_wifi7_hw_mac_id_to_srng_id_qcn9274(const struct ath12k_hw_params *hw,
 	return 0;
 }

-static u8 ath12k_wifi7_hw_get_ring_selector_qcn9274(struct sk_buff *skb)
+static u8 ath12k_wifi7_hw_get_ring_selector_qcn9274(u8 ac)
 {
 	return smp_processor_id();
 }
@@ -83,9 +83,9 @@ ath12k_wifi7_hw_mac_id_to_srng_id_wcn7850(const struct ath12k_hw_params *hw,
 	return mac_id;
 }

-static u8 ath12k_wifi7_hw_get_ring_selector_wcn7850(struct sk_buff *skb)
+static u8 ath12k_wifi7_hw_get_ring_selector_wcn7850(u8 ac)
 {
-	return skb_get_queue_mapping(skb);
+	return ac;
 }

 static bool ath12k_wifi7_dp_srng_is_comp_ring_wcn7850(int ring_num)
--
2.54.0

