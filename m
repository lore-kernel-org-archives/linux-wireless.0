Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5C844471A
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 13:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787231946; cv=none; b=hx0sMQzk21H5Wak7ZOj4lif8oBH5eHb2D3x5kwWKrTkGi+mPch4ZSf/6ippmfllXg8EBugPBFawcxpU1gtaixTejr3S0qbFpkR+s7Q/84edLHmUQ8qe0v7EWaiKwkqz5rezYiKA9FA0+HdBceLgI+uCO0f2SfQ0VDoEIg0xDZ9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787231946; c=relaxed/simple;
	bh=BWBLcC43y00u6v+Y+h7GNtDflDGLzfGeFV6Zd3kxg0c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XyetsD6/wVOmsWfpAhUaOqZgSKa7hicveoIw+QOXJlHZA22Co4cifiPseo9P3AJVMwZq9PxKAEicEuiBSvZEx4o+aRyndzL5V6ORKZvKqjffGvDjU3dJYx8GuPZsvC5EaLe+Z3BLUFbVakd6OCfw+l55M8WQtXLEs6MBrtdHRK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=rEkP3gF1; arc=none smtp.client-ip=212.77.101.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="rEkP3gF1"
Received: (wp-smtpd smtp.wp.pl 15893 invoked from network); 20 Aug 2026 15:12:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1787231538; bh=zMap4A58a7q0c3p5AS1hsWEXzFWMyTnIFIZMeXjMhB8=;
          h=From:To:Cc:Subject;
          b=rEkP3gF1uvz48AHL+73slS070vWJ7uzU+B6vwiSzZzC61djGvcZC6tdyQblR3BUXM
           g+e7OrpU/hMTxUoe3jvPRB254VmfkDx1if9S83Y+BuzZMsGcLw3cgqMxMRML470DYa
           Pt/3BJJQ/p/jBGLNckhmujutRbtfCozs2Ul5q0SQbhzev04vAmcIhYTJI0GXJgEFfP
           U9EpOzfc6jZJISKO2MlN6Eb+KNuw8NWNlY9zy3nICwtumMRus/QqO25zEQi3BtHsZJ
           +ApWVsJJsD3Ou8DAE1vXW7/nTIY5a7bx4EpOyN2JPzEFc7p5LRZuQSw+Zd1Rn4xwvg
           lEeEgVPmsZzVQ==
Received: from localhost (77-236-6-58.static.play.pl [77.236.6.58])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <johannes@sipsolutions.net>; 20 Aug 2026 15:12:17 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wifi: mac80211: queue frames while off-channel
Date: Thu, 20 Aug 2026 15:12:17 +0200
Message-Id: <20260820131217.21824-1-stf_xl@wp.pl>
X-Mailer: git-send-email 2.25.4
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 7cdcf4681a1e6c424f3b1843cb93c39d
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [IfNA]                               

Drivers without FAST_XMIT and hardware scan support currently drop TX
frames during software scanning while being off-channel. This happens
in ieee80211_tx_h_check_assoc() before frames reach internal TX queue.

Move the off-channel check to invoke_tx_handlers_late(), after
ieee80211_queue_skb(). Frames can then remain queued and be transmitted
when the interface returns on-channel. This is how TX works currently when
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

The change depends on the iTXQ resumption handling introduced by
commit 4444bc2116ae ("wifi: mac80211: Proper mark iTXQs for resumption")
and the wake_tx_queue support introduced by
commit a790cc3a4fad ("wifi: mac80211: add wake_tx_queue callback to drivers"),
so use those in 'Fixes' tag.

Cc: <stable@vger.kernel.org> # v6.2
Fixes: a790cc3a4fad ("wifi: mac80211: add wake_tx_queue callback to drivers")
Fixes: 4444bc2116ae ("wifi: mac80211: Proper mark iTXQs for resumption")
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 net/mac80211/tx.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 91b14112e24f..842368cc45dc 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -267,20 +267,14 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 }
 
 static ieee80211_tx_result debug_noinline
-ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
+ieee80211_tx_h_check_offchannel(struct ieee80211_tx_data *tx)
 {
-
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
-	bool assoc = false;
-
-	if (unlikely(info->flags & IEEE80211_TX_CTL_INJECTED))
-		return TX_CONTINUE;
 
 	if (unlikely(test_bit(SCAN_SW_SCANNING, &tx->local->scanning)) &&
 	    test_bit(SDATA_STATE_OFFCHANNEL, &tx->sdata->state) &&
 	    !ieee80211_is_probe_req(hdr->frame_control) &&
-	    !ieee80211_is_any_nullfunc(hdr->frame_control))
+	    !ieee80211_is_any_nullfunc(hdr->frame_control)) {
 		/*
 		 * When software scanning only nullfunc frames (to notify
 		 * the sleep state to the AP) and probe requests (for the
@@ -290,6 +284,20 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 		 * off-channel. See __ieee80211_start_scan() for more.
 		 */
 		return TX_DROP;
+	}
+
+	return TX_CONTINUE;
+}
+
+static ieee80211_tx_result debug_noinline
+ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+	bool assoc = false;
+
+	if (unlikely(info->flags & IEEE80211_TX_CTL_INJECTED))
+		return TX_CONTINUE;
 
 	if (tx->sdata->vif.type == NL80211_IFTYPE_OCB)
 		return TX_CONTINUE;
@@ -1864,6 +1872,7 @@ static int invoke_tx_handlers_late(struct ieee80211_tx_data *tx)
 		goto txh_done;
 	}
 
+	CALL_TXH(ieee80211_tx_h_check_offchannel);
 	CALL_TXH(ieee80211_tx_h_michael_mic_add);
 	CALL_TXH(ieee80211_tx_h_sequence);
 	CALL_TXH(ieee80211_tx_h_fragment);
@@ -4686,10 +4695,6 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 	queue = ieee80211_select_queue(sdata, sta, skb);
 	skb_set_queue_mapping(skb, queue);
 
-	if (unlikely(test_bit(SCAN_SW_SCANNING, &local->scanning)) &&
-	    test_bit(SDATA_STATE_OFFCHANNEL, &sdata->state))
-		goto out_free;
-
 	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (unlikely(!skb))
 		return;
@@ -4756,11 +4761,6 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
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

