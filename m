Received: from mta0.migadu.com (out-215.mta0.migadu.com [91.218.175.215])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5CB3CFF55
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 13:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.215
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790256608; cv=none; b=hcEWb/tDGVvEd0d7ktIPQFgiZL4qEhUHDIDrdZNFCN4KZY+7cEsoCQhPs7xKWiPli76SXMk3muQbZu8b5a+eguBRAvnyGj4dzBiMPuKeiFMuRNbA9p08DjpWXGRPjkJ/dtyf4e0Kh3wDEwmAMrLbTDIe6wNNy9UTFfITkK8rVTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790256608; c=relaxed/simple;
	bh=Q7yicSputjqRAaiSihpg7uwoEulKD0sbMOpWliDD7xU=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc; b=kKJAv86wKoH/cIpz/uCjRNKV+/3TEDMLXWYJ2qqSE/I0vXTFmOzBDT2sPsyHr9RdDQo+WzaSVtHZPQJskrpIvWBLbufcIv9Etzadof/7pvN34BGHAcJlhmWjrEEwG3lNT+2LzDq0P+RVn2DER2BDhdrliw8duot5Dh0FC1jXUOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Qbuyc4H3; arc=none smtp.client-ip=91.218.175.215
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Qbuyc4H3"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Q7yicSputjqRAaiSihpg7uwoEulKD0sbMOpWliDD7xU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790256598; v=1; x=1790861398;
 b=Qbuyc4H392b8HeErCDtSJJgQWIXyXyc2iJ0VPsIa4YveN9IQmeTArwuLq8n4bNKkzcobtAGg
 tyAqFUTc7CiF5PVmAMKh/2Er/qhMt/Iq4iG3DUlKcwcamv7eYzow8KNkD6ZTkC4XC3I+IL+tw7Z
 7uU8RzfJzc+6zjV/4Z7Sj5DQ=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f5b068c74c8d52c8;
	Thu, 24 Sep 2026 13:29:58 +0000
X-Mizu-Trace-ID: f5b068c74c8d52c8
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 24 Sep 2026 13:29:58 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Tianchu Chen" <tianchu.chen@linux.dev>
Message-ID: <441ed914aa1db14a140e6263243579f952d5805b@linux.dev>
TLS-Required: No
Subject: [PATCH] wifi: ath10k: fix OOB write from unbounded SDIO RX bundle
 count
To: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
 jjohnson@kernel.org
Cc: alagusankar@silex-india.com, quic_wgong@quicinc.com

From: Tianchu Chen <flynnnchen@tencent.com>

An RX event here is one invocation of
ath10k_sdio_mbox_rxmsg_pending_handler(), triggered by the mailbox
"RX pending" interrupt.  During such an event the device announces
pending packets through lookaheads, the first one read from the
HTC register table, the following ones carried in the trailers of
the packets just fetched.  ath10k_sdio_mbox_rx_alloc()
pre-allocates one rx_pkts[] slot per announced packet, after which
the device transfers exactly that many packets over SDIO.

A lookahead whose HTC header carries a bundle count K stands for
K+1 packets.  However, only the raw lookahead count is checked
against ATH10K_SDIO_MAX_RX_MSGS; the expanded total pkt_cnt is
never compared against the size of ar_sdio->rx_pkts[] (64 entries),
the index is simply advanced and written to.  With up to 32
lookaheads per round (the trailer record limit) each claiming
K=3D32, the loop stores up to 32 * 33 =3D 1056 struct
ath10k_sdio_rx_data entries into the 64-entry array, i.e. 992
entries (~31KB) past its end, overwriting the members that follow
it in struct ath10k_sdio.

Add the missing comparison: the current lookahead and its bundled
packets must fit into the remaining rx_pkts[] slots before any of
them is allocated.

This is expected to keep behavior unchanged on most cases: The new
check drops exactly when the old code would have written past
the array and corrupt the driver state.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: 8d985555ddaa ("ath10k: enable RX bundle receive for sdio")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireles=
s/ath/ath10k/sdio.c
index 65e941b527517..5dc2ad432b099 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -540,7 +540,7 @@ static int ath10k_sdio_mbox_rx_alloc(struct ath10k *a=
r,
 {
 	struct ath10k_sdio *ar_sdio =3D ath10k_sdio_priv(ar);
 	struct ath10k_htc_hdr *htc_hdr;
-	size_t full_len, act_len;
+	size_t full_len, act_len, bndl_cnt;
 	bool last_in_bundle;
 	int ret, i;
 	int pkt_cnt =3D 0;
@@ -579,14 +579,23 @@ static int ath10k_sdio_mbox_rx_alloc(struct ath10k =
*ar,
 			goto err;
 		}
=20
-=09	if (ath10k_htc_get_bundle_count(
-			ar->htc.max_msgs_per_htc_bundle, htc_hdr->flags)) {
+		bndl_cnt =3D ath10k_htc_get_bundle_count(
+			ar->htc.max_msgs_per_htc_bundle, htc_hdr->flags);
+
+		/* One rx_pkts[] slot per lookahead plus one per bundled packet */
+		if (bndl_cnt + 1 > ATH10K_SDIO_MAX_RX_MSGS - pkt_cnt) {
+			ath10k_warn(ar,
+				    "rx bundle count %zu exceeds remaining pkt slots\n",
+				    bndl_cnt);
+			ret =3D -ENOMEM;
+			goto err;
+		}
+
+		if (bndl_cnt) {
 			/* HTC header indicates that every packet to follow
 			 * has the same padded length so that it can be
 			 * optimally fetched as a full bundle.
 			 */
-			size_t bndl_cnt;
-
 			ret =3D ath10k_sdio_mbox_alloc_bundle(ar,
 							    &ar_sdio->rx_pkts[pkt_cnt],
 							    htc_hdr,
--=20
2.51.0
