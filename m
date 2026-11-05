Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793906420;
	b=TPauDL9JVcPMshhhDbgf6KyXtgIZGDs5C5W1bOuHXqsq9CbHnyy4sObLG9n5DZqKEt1L
	 lXEgOxSvb9ONZm6QvzSNLwlMsPXRlQmvkSfIIUUCyXf2giFPMnAhDoZorikDN9DICVAde
	 Mmy78XYpVJ631nQ+oFbCIXyKwZdO8vqFZ5wUpHp0hqfhphoLBpnJBiOy+7M7d3U87N/GX
	 nU/E/RqMEqIaj2qb/Vq5K/XhSDIA/yaiG7aOCAxst0llu4hT/K1XVBkn7fnIAvbNjSNsK
	 vfUoIUchVh/xZsGBjupLnLQX7OwDrnAAOAdbDhuBvYLT/ccQ8dLEalGNz7NcIz265Eg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906420;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=6Bljr1uC7IbWpOg6SVLCyxLBHvHmsEA9na/XTcirQ6A=;
	b=lP9nrA/Sowl5utlO8DIKMMizY0pusjSIsg+4Xi0EytGO8/91MyFKl21kJIOGPPX/AmOP
	 F02Y/Kril1HhW6wFXZAiBg1dHwOJVzIbT9kS2IlX5ij7DrnTrPSKZrCHXjZ9EVJjt1/F6
	 80xuk0hLuYzugkAvoVtMuCyklcuCxzE37asC5CuvUoS5Byo7Te+tY2A2/DxAbvH55aXIE
	 Eaka+4xjuulwRvvf/d/DfOjDfkCoBHP9JDTxA2krquXmZkIUK9Eh8N3H/hvOdadcjDz09
	 WZCKRg833Tb0V2qqh9oJvMOdVDMNS/g55qZ1XOBc3rw6BUgOiDErIlwDF8+sYE+oJVw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SWUUB8qK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B546606A32D;
	Thu,  5 Nov 2026 19:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SWUUB8qK
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793906419;
	b=CGIkOrBfFqzG/0QFZAe2wl9bcRAK0qEAoDQNpiY+AEDqn/ECeKejK5RpSP3aLzQrvSXq
	 sd3GNEOOtiFd8/9Vn+YgI7DzlwNwruP8i3S/b8qEnBamynNLIad7iYQaqGuH08wOvKDWR
	 5cbb0mL/eTdZ9TMA8JDWOCVemROvSicsI/hzTrHmDZDuJIhBGHirPs93M0jvnhmyFhGIL
	 lkzb1kp/H1O11oTUrBVzbPiI1JFMYpxlziVuSLvE1YSFCtajRliM3xjNFGlc9E7QytIIZ
	 QACk/j94c82AowIcbkMt+SGNLGYKzi2Wn6iFBMys7s3C2ghVGpVmQXhtwkYrMXgrOJg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793906419;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=6Bljr1uC7IbWpOg6SVLCyxLBHvHmsEA9na/XTcirQ6A=;
	b=0yUiHNigWA9ECRCBM37b9vC2PS90ohFJE0CaC/Io80vQspuDdWDU2Cuor8/BVaRP/f6c
	 RffzHAI+Xdf1EX69ckQ2zQVhJDlHBawrm5bsPalfvri8QE1smFDPJSe0xfYIKR5qngy0+
	 wD0YHSx3uC1E16Rfi6sDcxNppLUPPrs/t5M4w2V+0s+SaRdXQMbABt45mZoZ6Tx0RRa3n
	 B+7o0la6oSdjr9NIAobRUpn3jnQgWJB/DT9y3NBlt5gIZhulL/Hxo4dsgjwChe45qgdpC
	 AW2HrefwSsli3c56/uCZ5oMNLAb5AQKDe5E5iPHDgHl0wWzwNhBnCZEhDHvtRgdy9zg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 44EE41F000C1;
	Thu,  5 Nov 2026 19:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906419;
	bh=6Bljr1uC7IbWpOg6SVLCyxLBHvHmsEA9na/XTcirQ6A=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=SWUUB8qKgkBoNjcRM2a9/aa9bkjMy0tgY0yC9p5tYU7JJR2U1lMcUMSovPuvi/LiF
	 DIVV/pzEtuZS5bghYLatfE42B76KrDRu4g+eHhTpDu10sb/A/IyU0sCz2LsC2+ycI+
	 7a4IZk3bpp9t/luGMNxSSS7oaOyLfNzBxjgGoyEuxvjP5cusnkqUlWiuLRLbvZ4SVY
	 NDGJenvO/4GkxuEdvW0We4IrDj43uRFEr91v0hxiV1tclJllYN81shIHyvXc8BkVWN
	 p1Xs70PIaz4QlW5pFp1cEx9aNrJ0ZOKS1FVieQqlI3VWnEyIi6+MaXtP2J6SVCeHPg
	 NhiqAJ11uNC+A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 96DED473D0;
	Thu,  5 Nov 2026 19:20:18 +0000 (UTC)
From: Christopher Griffin via B4 Relay <devnull+christophergriffin05.gmail.com@kernel.org>
Date: Thu, 05 Nov 2026 13:20:18 -0600
Subject: [PATCH] wifi: ath11k: keep the PPDU status for the full monitor
 delivery
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261105-ath11k-full-mon-ppdu-status-v1-1-819a3e225b9b@gmail.com>
X-B4-Tracking: v=1; b=H4sIAPHW7GoC/yXMwQ6CMAwA0F8hPduEzcDBXzEexlqkiGNZN2JC+
 HenHN/l7aCchBVuzQ6JN1FZQ4W5NOAnF56MQtVgW9sb03bo8mTMC8eyLPheA8ZIBTW7XBRp8D0
 RdXy1HuoQE4/y+e/3x2ktw8w+/0o4ji9o+0FSfwAAAA==
X-Change-ID: 20261105-ath11k-full-mon-ppdu-status-dbc6ddd5e32c
To: Jeff Johnson <jjohnson@kernel.org>, 
 Aloka Dixit <quic_alokad@quicinc.com>, Kalle Valo <kvalo@kernel.org>, 
 Baochen Qiang <baochen.qiang@oss.qualcomm.com>, 
 Matthew Leach <matthew.leach@collabora.com>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, 
 Christopher Griffin <christophergriffin05@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793906418; l=3067;
 i=christophergriffin05@gmail.com; s=20261024; h=from:subject:message-id;
 bh=4fc48RxbyexxMZuKcYsZ86QAk9wyIus7mswxJpeNaL4=;
 b=WK2YA9h1OGQghson9ByDiVw1Yk8uOT5wEVWfCpprjGXlhy4pmBnjrs0003SkGBXpkiJhACRHO
 rkV3EfhvuD3AunvDGwOYvlu78FVAhnPm60sL1gMENVBq2FgoAarSVdq
X-Developer-Key: i=christophergriffin05@gmail.com; a=ed25519;
 pk=oa9tkTNpiGoFWdGvpDHXLSobApmsh9BfrJRJrRJAvWA=
X-Endpoint-Received: by B4 Relay for
 christophergriffin05@gmail.com/20261024 with auth_id=1309
X-Original-From: Christopher Griffin <christophergriffin05@gmail.com>
Reply-To: christophergriffin05@gmail.com
Content-Transfer-Encoding: 7bit

From: Christopher Griffin <christophergriffin05@gmail.com>

In full monitor mode (QCN9074), ath11k_dp_rx_process_full_mon_status_ring()
reaps the status buffer of the held PPDU with
ath11k_dp_rx_process_mon_status() and then delivers the PPDU's MPDUs with
pmon->mon_ppdu_info, the status that function parsed. But
ath11k_dp_rx_process_mon_status() clears mon_ppdu_info again after each
status buffer whose PPDU names a peer ID, whether the peer is found or
not. Since commit 2a2451a34afd ("wifi: ath11k: fix peer resolution on rx
path when peer_id=0") a PPDU from a station without a peer, which is
every frame a monitor hears from other BSSs, names peer ID 0 and is
cleared too. Every frame a QCN9074 monitor delivers then has an empty
status: signal -95 dBm (the default noise floor and a zero rssi_comb),
no TSFT, and the rate of its rx descriptor instead of its PPDU's.

Each status buffer is already parsed from a cleared status. Drop the
clear after it, so that the status of the last parsed PPDU stays for the
delivery. The other monitor path is not affected: it delivers from
within the loop, before the clear.

On a QCN9074 alone in monitor mode on 6 GHz (5975, 6135 and 6455 MHz,
frames from neighbouring APs), 311 of 313 frames had signal -95 dBm and
TSFT 0 before. After, 307 of 309 had their received level (-79 and
-80 dBm for the nearest AP's beacons) and their TSFT, and the beacons
their 6 Mb/s rate instead of 48.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.5.r4-00683-QCAHKSWPL_SILICONZ-1

Fixes: 67a9d399fcb0 ("ath11k: enable RX PPDU stats in monitor co-exist mode")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Christopher Griffin <christophergriffin05@gmail.com>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 6d95f7b343a55..8bee3bfe33dfe 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -5290,6 +5290,10 @@ int ath11k_dp_rx_process_mon_status(struct ath11k_base *ab, int mac_id,
 		if (log_type != ATH11K_PKTLOG_TYPE_INVALID)
 			trace_ath11k_htt_rxdesc(ar, skb->data, log_type, rx_buf_sz);
 
+		/* Each status buffer is parsed from a clear status. The last one's
+		 * stays in mon_ppdu_info: full monitor mode delivers its PPDU after
+		 * this returns, with that status (signal, TSFT, rate).
+		 */
 		memset(ppdu_info, 0, sizeof(*ppdu_info));
 		ppdu_info->peer_id = HAL_INVALID_PEERID;
 		hal_status = ath11k_hal_rx_parse_mon_status(ab, ppdu_info, skb);
@@ -5334,8 +5338,6 @@ int ath11k_dp_rx_process_mon_status(struct ath11k_base *ab, int mac_id,
 		rcu_read_unlock();
 
 		dev_kfree_skb_any(skb);
-		memset(ppdu_info, 0, sizeof(*ppdu_info));
-		ppdu_info->peer_id = HAL_INVALID_PEERID;
 	}
 exit:
 	return num_buffs_reaped;

---
base-commit: 5c8eab13e391aaabd5a1ad58f3ee4bb10ce7573e
change-id: 20261105-ath11k-full-mon-ppdu-status-dbc6ddd5e32c

Best regards,
--  
Christopher Griffin <christophergriffin05@gmail.com>


