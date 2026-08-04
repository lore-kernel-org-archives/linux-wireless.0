Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A5B46A603
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 17:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785865830; cv=none; b=TBEYbd970fa4+KSC5D9rm9FSLDuMWeMH3VJJYiaIpWVRfrHZm4n499gXKSfnfhsQVYk4OWsF3Oxo4swo+1gTOZSUV+i1xTcvSFnk9HVSzGD3cgBezesZ5OsYlMyRQKmXFRDek1UpG8CJtYbqDe/WmR0MIU+GPKsqWH48yq/98ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785865830; c=relaxed/simple;
	bh=SgQnSI2IymoKAzubqF+WYt20+Nk9490lu5FyzcsSa+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uV2+7lYKpC9j8XOM3bPN2RnhuY5wXfGwrAVJEdxEo99lxGCi1eUN+2sj8sJ2kYntc9IAR6ixOJyNaZQcHu7xe6FuXOHRk1tbYoWFOsxeA5GFRPMZHDy9ORpMaH4vmwaCf9j0+qlDVUgt8D98DNpxW4BgkfgGR9O3Sw1wZkfA+Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YBhuampq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YBhuampq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785865823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZJeNAJHrN9oQZwhJNPweXx9iOGIgQoj+dUI//LdBdWo=;
	b=YBhuampqdls7Tu3fVhmvVsEReTeAcyV2iTbuhDXNL7+WPmvI1Uj7rnC4GjKDr3N2CrnuHU
	Hw68uKtFhEIllRdDdkLrOxtNITUBiG7emmxPDFoP6RpNLpEiEjS0KV4cJ9CsLrRwPSXi4I
	azk/g2upDjKewzl+UMjECo8jLAGhTCk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-336-afvGNtrLPp6T9LOWV6ORog-1; Tue,
 04 Aug 2026 13:50:21 -0400
X-MC-Unique: afvGNtrLPp6T9LOWV6ORog-1
X-Mimecast-MFC-AGG-ID: afvGNtrLPp6T9LOWV6ORog_1785865820
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8956118002C1;
	Tue,  4 Aug 2026 17:50:20 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.70])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 77459180044F;
	Tue,  4 Aug 2026 17:50:18 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v2 3/3] wifi: ath12k: skip connection_loss_work for MLO beacon miss
Date: Tue,  4 Aug 2026 19:50:01 +0200
Message-ID: <20260804175004.1761075-4-jtornosm@redhat.com>
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

When firmware reports a beacon miss, ath12k queues connection_loss_work
as a 3-second backup timer that forces a full VIF disconnect via
ieee80211_connection_loss(). This work can only be cancelled when a
beacon frame arrives through WMI in ath12k_mac_handle_beacon_iter().

In MLO, this mechanism causes periodic spurious disconnections because
the firmware does not reliably forward beacon frames to the host via
WMI, making the cancellation path ineffective. The result is a full
VIF disconnect every ~16 seconds during normal MLO operation, easily
reproducible under heavy traffic.

Skip queueing connection_loss_work for MLO VIFs. The mac80211 AP probe
triggered by ieee80211_beacon_loss() is sufficient to detect real AP
unreachability. Other MLO-capable drivers such as mt76 and rtw89
similarly rely on ieee80211_beacon_loss() without adding a backup
disconnect timer.

Tested on WCN7850 with MLO (Wi-Fi 7).

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v2: No modification
v1: https://lore.kernel.org/all/20260727162748.963275-6-jtornosm@redhat.com/

 drivers/net/wireless/ath/ath12k/mac.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index af09153ad9d9..dfd69822c5ce 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -2008,9 +2008,16 @@ void ath12k_mac_handle_beacon_miss(struct ath12k *ar,
 	 * (done by mac80211) succeeds but beacons do not resume then it
 	 * doesn't make sense to continue operation. Queue connection loss work
 	 * which can be cancelled when beacon is received.
+	 *
+	 * Skip for MLO because connection_loss_work disconnects the entire
+	 * VIF based on a single link's beacon miss, and its cancellation
+	 * mechanism (beacon reception via WMI) is unreliable. The mac80211
+	 * probe triggered by ieee80211_beacon_loss() above is sufficient
+	 * to detect real AP unreachability.
 	 */
-	ieee80211_queue_delayed_work(hw, &arvif->connection_loss_work,
-				     ATH12K_CONNECTION_LOSS_HZ);
+	if (!ieee80211_vif_is_mld(vif))
+		ieee80211_queue_delayed_work(hw, &arvif->connection_loss_work,
+					     ATH12K_CONNECTION_LOSS_HZ);
 }
 
 static void ath12k_mac_vif_sta_connection_loss_work(struct work_struct *work)
-- 
2.54.0

