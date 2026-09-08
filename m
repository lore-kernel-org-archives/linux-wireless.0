Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8455C53ED15
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 12:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788871624; cv=none; b=XePKqHZRXUaBf8LAr4XsMKiag+QUhD471vs+o/7LP4Sv2w+DS5emC38pY+1AyWOFQYYLmcwm5l8EtefyE+hrD45ghGRWdykXTNu15XF63ohtC/5CTESQykRFPZg3yeuUuZP7RtBelxZoXPgTMzW+7ef7kLKApkXCKM+P7Zy87Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788871624; c=relaxed/simple;
	bh=nSIsuNFgivXXUQFkkh2UAm69QxMNGxyM6y0WeZlnB1s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SYhenBDpMXkIB6OSg+dM8R5ipH5pwAt4zJ9kR0wRQ1OtdZfQxSTRWI+iHiZpNadsBJj4WfHQ/bUIHfzl5mayJKY618ZdNZE4IqS04itvYh3pmVq2gt+49sKu4a9Vuo9ItpApsn9kIbZahGqIIR9Xh32TyRpiGZN00iXWHKlfhoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=KbXeLyQB; arc=none smtp.client-ip=212.77.101.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="KbXeLyQB"
Received: (wp-smtpd smtp.wp.pl 667 invoked from network); 8 Sep 2026 14:46:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1788871612; bh=QuutxINxLELqJqoI08YM99QjWjCEZXXayskBtNn5lDM=;
          h=From:To:Cc:Subject;
          b=KbXeLyQBKiq/uRJrrI7/4OQRrB9TFm/VsmyNarTl/XTUVr1EYGpGCeK2w2KjZd7LL
           0rAOcsr/IZvXVnx4InqppLRqi2ybpE/iSd/0cu7ge2HFzZopdJ29Fba4AOKCE2r1LO
           Di5SczAzRHN7Tv9wIaaIsimcmzLB8imGj18s3SrHpt0yOHBTV/vggo6xdUTCKZ11cw
           jXq7AC8n09TXtJkZHASseRWSDfehSAlLk5O8Qw564skqOYO7Tf9vfQLPFF9KcStv09
           03S7v6h99JcfQ1in9H5kE7pWpUNTdfEunILVcxzfuz0YjgHnjxFyenr7Pod51CyGPD
           1FSKuJ98Wte1A==
Received: from localhost (77-236-6-58.static.play.pl [77.236.6.58])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <johannes@sipsolutions.net>; 8 Sep 2026 14:46:52 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH RESEND v2] wifi: mac80211: queue frames while off-channel
Date: Tue,  8 Sep 2026 14:46:51 +0200
Message-Id: <20260908124651.2995-1-stf_xl@wp.pl>
X-Mailer: git-send-email 2.25.4
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: c459ff43650ff9bbb31ac43ff463a6e9
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [wUOk]                               

Drivers without FAST_XMIT and hardware scan support currently drop TX
frames during software scanning while being off-channel. This happens
in ieee80211_tx_h_check_assoc() before frames reach internal TX queue.

Move the off-channel check to invoke_tx_handlers_late(), after
ieee80211_queue_skb(). Frames can then remain queued and be transmitted
when the interface returns on-channel. This how TX works currently when
code goes via ieee80211_xmit_fast() path.

Below is rt2x00 driver ping output example while scanning, before and
after the fix. After the fix, packets are no longer lost. Some have
increased latency, what is expected behavior.

BEFORE:
64 bytes from 192.168.0.1: icmp_seq=29 ttl=64 time=3.61 ms
64 bytes from 192.168.0.1: icmp_seq=31 ttl=64 time=3.33 ms # Missed 30
64 bytes from 192.168.0.1: icmp_seq=32 ttl=64 time=4.03 ms
64 bytes from 192.168.0.1: icmp_seq=34 ttl=64 time=3.10 ms # Missed 33
64 bytes from 192.168.0.1: icmp_seq=36 ttl=64 time=3.04 ms # Missed 35
64 bytes from 192.168.0.1: icmp_seq=38 ttl=64 time=3.05 ms # Missed 37
64 bytes from 192.168.0.1: icmp_seq=40 ttl=64 time=4.14 ms # Missed 39
64 bytes from 192.168.0.1: icmp_seq=41 ttl=64 time=4.50 ms

AFTER:
64 bytes from 192.168.0.1: icmp_seq=29 ttl=64 time=3.40 ms
64 bytes from 192.168.0.1: icmp_seq=30 ttl=64 time=6.10 ms
64 bytes from 192.168.0.1: icmp_seq=31 ttl=64 time=4.69 ms
64 bytes from 192.168.0.1: icmp_seq=32 ttl=64 time=4.49 ms
64 bytes from 192.168.0.1: icmp_seq=33 ttl=64 time=148 ms
64 bytes from 192.168.0.1: icmp_seq=34 ttl=64 time=6.83 ms
64 bytes from 192.168.0.1: icmp_seq=35 ttl=64 time=8.66 ms
64 bytes from 192.168.0.1: icmp_seq=36 ttl=64 time=13.0 ms
64 bytes from 192.168.0.1: icmp_seq=37 ttl=64 time=4.78 ms
64 bytes from 192.168.0.1: icmp_seq=38 ttl=64 time=3.85 ms

Cc: <stable@vger.kernel.org>
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
v1 -> v2: 
 - drop wrong Fixes tags 
 - move handler function to keep order in the code  
 - do not remove info->flags & IEEE80211_TX_CTL_INJECTED check
 
 net/mac80211/tx.c | 52 +++++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 91b14112e24f..08a39272f26a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -269,7 +269,6 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 {
-
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	bool assoc = false;
@@ -277,20 +276,6 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 	if (unlikely(info->flags & IEEE80211_TX_CTL_INJECTED))
 		return TX_CONTINUE;
 
-	if (unlikely(test_bit(SCAN_SW_SCANNING, &tx->local->scanning)) &&
-	    test_bit(SDATA_STATE_OFFCHANNEL, &tx->sdata->state) &&
-	    !ieee80211_is_probe_req(hdr->frame_control) &&
-	    !ieee80211_is_any_nullfunc(hdr->frame_control))
-		/*
-		 * When software scanning only nullfunc frames (to notify
-		 * the sleep state to the AP) and probe requests (for the
-		 * active scan) are allowed, all other frames should not be
-		 * sent and we should not get here, but if we do
-		 * nonetheless, drop them to avoid sending them
-		 * off-channel. See __ieee80211_start_scan() for more.
-		 */
-		return TX_DROP;
-
 	if (tx->sdata->vif.type == NL80211_IFTYPE_OCB)
 		return TX_CONTINUE;
 
@@ -805,6 +790,33 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	return TX_CONTINUE;
 }
 
+static ieee80211_tx_result debug_noinline
+ieee80211_tx_h_check_offchannel(struct ieee80211_tx_data *tx)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+
+	if (unlikely(info->flags & IEEE80211_TX_CTL_INJECTED))
+		return TX_CONTINUE;
+
+	if (unlikely(test_bit(SCAN_SW_SCANNING, &tx->local->scanning)) &&
+	    test_bit(SDATA_STATE_OFFCHANNEL, &tx->sdata->state) &&
+	    !ieee80211_is_probe_req(hdr->frame_control) &&
+	    !ieee80211_is_any_nullfunc(hdr->frame_control)) {
+		/*
+		 * When software scanning only nullfunc frames (to notify
+		 * the sleep state to the AP) and probe requests (for the
+		 * active scan) are allowed, all other frames should not be
+		 * sent and we should not get here, but if we do
+		 * nonetheless, drop them to avoid sending them
+		 * off-channel. See __ieee80211_start_scan() for more.
+		 */
+		return TX_DROP;
+	}
+
+	return TX_CONTINUE;
+}
+
 static __le16 ieee80211_tx_next_seq(struct sta_info *sta, int tid)
 {
 	u16 *seq = &sta->tid_seq[tid];
@@ -1864,6 +1876,7 @@ static int invoke_tx_handlers_late(struct ieee80211_tx_data *tx)
 		goto txh_done;
 	}
 
+	CALL_TXH(ieee80211_tx_h_check_offchannel);
 	CALL_TXH(ieee80211_tx_h_michael_mic_add);
 	CALL_TXH(ieee80211_tx_h_sequence);
 	CALL_TXH(ieee80211_tx_h_fragment);
@@ -4686,10 +4699,6 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 	queue = ieee80211_select_queue(sdata, sta, skb);
 	skb_set_queue_mapping(skb, queue);
 
-	if (unlikely(test_bit(SCAN_SW_SCANNING, &local->scanning)) &&
-	    test_bit(SDATA_STATE_OFFCHANNEL, &sdata->state))
-		goto out_free;
-
 	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (unlikely(!skb))
 		return;
@@ -4756,11 +4765,6 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tpt_led_trig_tx(local, len);
 
 	ieee80211_tx_8023(sdata, skb, sta, false);
-
-	return;
-
-out_free:
-	kfree_skb(skb);
 }
 
 static bool ieee80211_check_mcast_offload(struct ieee80211_sub_if_data *sdata,
-- 
2.50.1

