Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aurora.create-net.org ([193.206.22.116]:34083 "EHLO
	aurora.create-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab1FFLMs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 07:12:48 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by aurora.create-net.org (Postfix) with ESMTP id 5FF8C2C081CD
	for <linux-wireless@vger.kernel.org>; Mon,  6 Jun 2011 13:12:47 +0200 (CEST)
Received: from aurora.create-net.org ([127.0.0.1])
	by localhost (aurora.create-net.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cQQR3VNBtozt for <linux-wireless@vger.kernel.org>;
	Mon,  6 Jun 2011 13:12:46 +0200 (CEST)
Received: from [192.168.9.180] (unknown [192.168.9.180])
	by aurora.create-net.org (Postfix) with ESMTPSA id C98C82C0817D
	for <linux-wireless@vger.kernel.org>; Mon,  6 Jun 2011 13:12:46 +0200 (CEST)
Message-ID: <4DECB62E.2020202@create-net.org> (sfid-20110606_131251_774448_A1BBA4AA)
Date: Mon, 06 Jun 2011 13:12:46 +0200
From: Roberto Riggio <roberto.riggio@create-net.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH] Frame injection
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is a combination of Matteo's patch and another submitted
several months ago on the list. It is tested for what concerns 11g rates.
However I did not manage to inject frames at 11n rates (tested only with
an atheros sr71a card)

Signed-off-by: Roberto Riggio <roberto.riggio@create-net.org>

--

diff -urN compat-wireless-2011-05-13.old//include/net/mac80211.h 
compat-wireless-2011-05-13//include/net/mac80211.h
--- compat-wireless-2011-05-13.old//include/net/mac80211.h    2011-05-16 
19:20:13.000000000 +0100
+++ compat-wireless-2011-05-13//include/net/mac80211.h    2011-05-30 
12:52:25.260002000 +0100
@@ -344,6 +344,7 @@
   * @IEEE80211_TX_INTFL_TKIP_MIC_FAILURE: Marks this packet to be used 
for TKIP
   *    testing. It will be sent out with incorrect Michael MIC key to allow
   *    TKIP countermeasures to be tested.
+ * @IEEE80211_TX_CTL_RC_BYPASS: Don't use rate control on the frame.
   *
   * Note: If you have to add new flags to the enumeration, then don't
   *     forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
@@ -374,6 +375,7 @@
      IEEE80211_TX_CTL_STBC            = BIT(23) | BIT(24),
      IEEE80211_TX_CTL_TX_OFFCHAN        = BIT(25),
      IEEE80211_TX_INTFL_TKIP_MIC_FAILURE    = BIT(26),
+    IEEE80211_TX_CTL_RC_BYPASS        = BIT(27),
  };

  #define IEEE80211_TX_CTL_STBC_SHIFT        23
diff -urN compat-wireless-2011-05-13.old//net/mac80211/tx.c 
compat-wireless-2011-05-13//net/mac80211/tx.c
--- compat-wireless-2011-05-13.old//net/mac80211/tx.c    2011-05-16 
19:20:13.000000000 +0100
+++ compat-wireless-2011-05-13//net/mac80211/tx.c    2011-05-30 
14:00:36.936002002 +0100
@@ -1040,11 +1040,14 @@
      struct ieee80211_radiotap_iterator iterator;
      struct ieee80211_radiotap_header *rthdr =
          (struct ieee80211_radiotap_header *) skb->data;
+    struct ieee80211_supported_band *sband;
      bool hw_frag;
      struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
      int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
                             NULL);

+    sband = tx->local->hw.wiphy->bands[tx->channel->band];
+
      info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
      tx->flags &= ~IEEE80211_TX_FRAGMENTED;

@@ -1092,6 +1095,55 @@
                  tx->flags |= IEEE80211_TX_FRAGMENTED;
              break;

+        case IEEE80211_RADIOTAP_RATE: {
+            int i, idx = -1;
+            int rate = *iterator.this_arg * 5;
+
+            for (i = 0; i < sband->n_bitrates; i++)
+                if (sband->bitrates[i].bitrate == rate) {
+                    idx = i;
+                    break;
+                }
+
+            /* Rate not available - rejecting */
+            if (idx < 0)
+                return false;
+
+            info->flags |= IEEE80211_TX_CTL_RC_BYPASS;
+            info->control.rates[0].idx = idx;
+            info->control.rates[0].count = 1;
+            for (i = 1; i < IEEE80211_TX_MAX_RATES; i++)
+                info->control.rates[i].idx = -1;
+            break;
+        }
+
+        case IEEE80211_RADIOTAP_DATA_RETRIES:
+            /*
+             * Only allow setting the number of retries in
+             * conjunction with the rates, when the rate control
+             * is bypassed.
+             */
+            if (info->flags & IEEE80211_TX_CTL_RC_BYPASS)
+                info->control.rates[0].count =
+                    *iterator.this_arg;
+            break;
+
+        case IEEE80211_RADIOTAP_MCS: {
+            u8 flags = iterator.this_arg[1];
+            u8 mcs = iterator.this_arg[2];
+            info->flags |= IEEE80211_TX_CTL_RC_BYPASS;
+            info->control.rates[0].idx = mcs;
+            info->control.rates[0].flags |=
+                IEEE80211_TX_RC_MCS;
+            if (flags & IEEE80211_RADIOTAP_MCS_BW_40)
+                info->control.rates[0].flags |=
+                IEEE80211_TX_RC_40_MHZ_WIDTH;
+            if (flags & IEEE80211_RADIOTAP_MCS_SGI)
+                info->control.rates[0].flags |=
+                IEEE80211_TX_RC_SHORT_GI;
+            break;
+        }
+
          /*
           * Please update the file
           * Documentation/networking/mac80211-injection.txt
@@ -1398,8 +1450,9 @@
      CALL_TXH(ieee80211_tx_h_ps_buf);
      CALL_TXH(ieee80211_tx_h_check_control_port_protocol);
      CALL_TXH(ieee80211_tx_h_select_key);
-    if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
-        CALL_TXH(ieee80211_tx_h_rate_ctrl);
+    if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) &&
+        !(info->flags & IEEE80211_TX_CTL_RC_BYPASS))
+         CALL_TXH(ieee80211_tx_h_rate_ctrl);

      if (unlikely(info->flags & IEEE80211_TX_INTFL_RETRANSMISSION))
          goto txh_done;
diff -urN compat-wireless-2011-05-13.old//net/wireless/radiotap.c 
compat-wireless-2011-05-13//net/wireless/radiotap.c
--- compat-wireless-2011-05-13.old//net/wireless/radiotap.c    
2011-05-16 19:20:10.000000000 +0100
+++ compat-wireless-2011-05-13//net/wireless/radiotap.c    2011-05-30 
12:51:56.348002001 +0100
@@ -40,6 +40,7 @@
      [IEEE80211_RADIOTAP_TX_FLAGS] = { .align = 2, .size = 2, },
      [IEEE80211_RADIOTAP_RTS_RETRIES] = { .align = 1, .size = 1, },
      [IEEE80211_RADIOTAP_DATA_RETRIES] = { .align = 1, .size = 1, },
+    [IEEE80211_RADIOTAP_MCS] = { .align = 1, .size = 3, },
      /*
       * add more here as they are defined in radiotap.h
       */
