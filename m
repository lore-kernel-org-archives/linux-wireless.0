Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793162678;
	b=3GFH30eIhdTiqwfEKLnt/oJw9Loj7L82bQb2b9+lPKxE7SvxsrXtVy6JakW7k2rbD4af
	 oSto5OMSxWS+bR4D5DnRRvoUdSZWj3KCFwbkgW2VG6/xSrV1nrtnEstTVpkt+4DhyeG64
	 1yhJ27qgnl2PVxAF1quHCQ11+uFZS93G2zwnuTfTxvp9OtgFvJKMP237I1kgAgR0aqJPc
	 RBAPSOlD4DdTibfQbsSTsUjAdWyUEdachiVEzmQXiGIsaODOQC+OrZcFcxXVickP2zlWB
	 BnOHdko2PYf17BXZL0KCHpiIbF6wU0RLrysnOBiuikV4zrpFSSZ2u3F7U8uKqoqDRyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793162678;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VXmZOTxdsLJK1EDMTCaYAUpMCTb68Aj29QTz4k8oJNA=;
	b=32IGULxF/8QOFS/DAhln9JKJDDHiZsCdePvyHQckXfwJiVyi4K4JdUiPfjyeYIetPJQe
	 7QdkhSOUgT2nqC+7hpQqUscQTfQ1O6mcsInuFhJEt2EQzswd8EGWRuyXsJiUTbvxG0cA1
	 p/gVDyrEOxkPGw0Hj0TtH77az8lLQNsvJGOQysiohCcNOsmnvdMXUs4++mzWttJIYG2+z
	 U9hPf6LRF770DmnsARmvl2/M5wlZgfLzB471b4BdirN6uoC5yjKnJCwqm3iJhtB182FpT
	 DhohfDvkCQGZYb8gyMVBPfzoWFBMCwpBt+M0Z76QtGt9KJlivkVSRfxJlKVr8yWlwow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=morsemicro.com;
	spf=pass smtp.mailfrom=morsemicro.com;
	dkim=pass header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VIOkDTP8;
	arc=none smtp.remote-ip=209.85.216.51
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212DA606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 04:44:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 212DA606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VIOkDTP8
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3ac7c7b3a90so277085a91.3
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 21:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20260707.gappssmtp.com; s=20260707; t=1793162677; x=1793767477; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VXmZOTxdsLJK1EDMTCaYAUpMCTb68Aj29QTz4k8oJNA=;
        b=VIOkDTP8Bzbko5Lo3/SA0pZ/AAXNAx6wPzFsTC6vlRt/FaNo40eb2SM/Wux9hYYwph
         u47sGddu3XsqRJqm78meaAKc1KlUqBc+yJI4O1gTou48RJHDWgX0/RFUjmeTr2PYeYyE
         OPNJ2UvJ55uy27WjV/I7estBNFjXrZnbNYUwfsGz4NManu3FUcHI+Vkmvo53nC605nCA
         SQn6BPDMEZE/O03u732B5DBJ94H+YFUzG7HJygUr00I/nWEtVlymNa82X2EMJsiL4pPw
         xLFtSOIWZV7eTRhToI0HsBofJokJs6K4+ac6qUXBpWJ3qD3zIQzQFWTPgS/0s6VSo0wC
         VlQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793162677; x=1793767477;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VXmZOTxdsLJK1EDMTCaYAUpMCTb68Aj29QTz4k8oJNA=;
        b=PEcAlm9mnsIPfVVSqU8upf7c56R/H0ryOtR2RHTcMgcHYZLWwuklAMnBL06VYja8Vl
         7UP8ybf72XQSbjHxbPu9i9uDp4xsNWEd0Ulv1S3JnceCOtOlASCjm1uSKPkDCif+AK5A
         /oI009Zmg56jw6uk+zTfua5OLr74RnP+oehkQTKF5NpQLxX+JNMAqK5GgGSwba1SIG7r
         cl+VRt6S2LKhfMfbC/6pm9gwxqkNlDSbN6eodcDpIuK8hhnqPR3a7VQAUVCM3uD8fEfC
         JbKQR5/a5u7IytoVmG0mYaP7Sk148azsTidSHtVWsXaf+Y2ebMf4vHm6W/ktzbdY/mU2
         r4vw==
X-Forwarded-Encrypted: i=1; AKwUvBy0zxKpHodon8iodu9+cZL5fuxBBYlYL2VOUXbHQeWpn5wuhUxBrh1fByXXkYhw8j66p6cQTf2hC72i9MoPkQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYL6OXE0K2sPtOCQIiu+eho89+CjzHOBm/RBhsvZgdvw0bd/+JfR
	XgJ+45ni9Lw4qEi1CwDvdoel10V2fdBZlweivmtwwtwXyRoOQwz7KAcwZiYTBZltxgw=
X-Gm-Gg: AYBFou0vW9VCK2nyX7ZC0rLsXtGJYqWvnA7mEzYwOm9glNxKKuB+GHgoyjLQCcXIbaD
	ZLj3b41xMw65omFIUWQ6xFCxKd6klBW4TwsLfYVjHP850pG26JEWAB7wE9llxcxMUNJLxtf7FwG
	bVu2SmtNeE8flk/8v2tmg13lSAY45u7UnU2EYhMAkh+aYOl/R8t9yx0PVLXoALXOrzEi4mDam3Y
	DiTpE1CXqNmVZtC/vuX/oMsjRzbjaMXe06Ze3zlFBfPJe0i5xOuEXQlZYfF7cCxw/aIoEfdDYLg
	+wCpc5p5cbtyoODiYHKojpAWJ4tOKgxwfOH5T7pfnrDFL3pHnQzAKbSBj1oWBA/QU0wZ6KovhxC
	EQQabtjla2TvCA8jEN5uTUr2qH/e6+HO7OWsjjBt5rk5pDaPPU1zy0LxgTUWXWibbRvQNc/f3PW
	qkuu3iOMujMQvV33ldp4Y8IfaGAC5z93smr+qF2NfgM2hK7u7rcMBXP3wUkvwoUPN1ac80xoly3
	+l34BaeQB1s3gp7zhndeUzvFEv9T0FReRWKl1thDa6sfC1qhyzaZZnq/xoZ2crlIP8wRu7LSD/E
	MJo2mYdk6tdSMHOS0x8Jaas4YGVralpT21akg1weQJiHTHnurSv67+07D/rdPOsXns/BlLUA2Pv
	Gj4F+2ZyO+55Zm/g0kx2BAzVLRgJvgGoTdiIHXd3J7WFJJ5XY1a9BOtE=
X-Received: by 2002:a17:90b:224f:b0:3a0:b312:1fbe with SMTP id 98e67ed59e1d1-3ae580a7ac7mr773945a91.23.1793162677412;
        Tue, 27 Oct 2026 21:44:37 -0700 (PDT)
Received: from mma-H9MHD44.lan (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a93b3f5sm1025226a91.5.2026.10.27.21.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 21:44:37 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: arien.judge@morsemicro.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH wireless] wifi: mm81x: report non-1MHz frames on the 1MHz control freq
Date: Wed, 28 Oct 2026 15:44:29 +1100
Message-ID: <20261028044429.1423116-1-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
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

With the recent changes to the Rx handling in mac80211 6d531b9af16e
("wifi: mac80211: rework RX packet handling") mac80211 is now stricter
when validating frames. Our firmware reports the overall center
frequency of the received frame when mac80211 really expects the
control channel even if the frame was received on a wider channel.

For frames _actually_ sent on a 1MHz channel (such as probe responses)
report the true frequency such that the APs channel can be determined.
For all other frames (i.e beacons sent on a 2MHz primary, data frames
sent on a 2/4/8 etc.) are then reported on the 1MHz control.
This enables 2MHz primarys to be used again.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/mac.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index 6f1feb24fe6a..cd0bb4d21acf 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -2005,6 +2005,23 @@ static void mm81x_rx_h_add_rt_s1g_tlv(struct sk_buff *skb,
 	rx_status->flag |= RX_FLAG_RADIOTAP_TLV_AT_END;
 }
 
+/*
+ * This is a hack to workaround how our firmware reports frequencies.
+ * For any 1MHz frames report them directly (i.e during scanning), else
+ * report the 1MHz control channel we are tuned to.
+ */
+static void mm81x_rx_h_fill_freq(struct mm81x *mors, u32 rx_khz,
+				 struct ieee80211_rx_status *rx_status)
+{
+	struct ieee80211_channel *chan = mors->chandef.chan;
+
+	if (rx_status->bw != RATE_INFO_BW_1)
+		rx_khz = ieee80211_channel_to_khz(chan);
+
+	rx_status->freq = KHZ_TO_MHZ(rx_khz);
+	rx_status->freq_offset = (rx_khz % 1000) ? 1 : 0;
+}
+
 static void mm81x_rx_h_fill_status(struct mm81x *mors,
 				   struct mm81x_skb_rx_status *hdr_rx_status,
 				   struct ieee80211_rx_status *rx_status,
@@ -2018,11 +2035,10 @@ static void mm81x_rx_h_fill_status(struct mm81x *mors,
 	rx_status->signal = le16_to_cpu(hdr_rx_status->rssi);
 	rx_status->encoding = RX_ENC_S1G;
 	rx_status->band = NL80211_BAND_S1GHZ;
-	rx_status->freq = KHZ100_TO_MHZ(freq_100khz);
-	rx_status->freq_offset = (freq_100khz % 10) ? 1 : 0;
 	rx_status->nss = NSS_IDX_TO_NSS(mm81x_ratecode_nss_index_get(ratecode));
 	rx_status->rate_idx = mm81x_ratecode_mcs_index_get(ratecode);
 	rx_status->bw = mm81x_rx_h_rc_bw_to_rx_bw(ratecode);
+	mm81x_rx_h_fill_freq(mors, KHZ100_TO_KHZ(freq_100khz), rx_status);
 	rx_status->mactime = timestamp;
 	rx_status->flag |= RX_FLAG_MACTIME_IS_RTAP_TS64;
 
-- 
2.43.0

