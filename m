Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49310 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab0I1RZV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 13:25:21 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o8SHPKYs017917
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 28 Sep 2010 10:25:21 -0700
Message-ID: <4CA224FF.3030103@candelatech.com>
Date: Tue, 28 Sep 2010 10:25:19 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RFC:  Store premable and g-mode flags in ieee80211_tx_info
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This way, you don't need to pass vif to ieee80211_rts_duration.


diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index fe8b9da..5d3de80 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -321,6 +321,8 @@ struct ieee80211_bss_conf {
   * @IEEE80211_TX_CTL_LDPC: tells the driver to use LDPC for this frame
   * @IEEE80211_TX_CTL_STBC: Enables Space-Time Block Coding (STBC) for this
   *     frame and selects the maximum number of streams that it can use.
+ * @IEEE80211_TX_SHORT_PREAMBLE: Sdata->vif is configured for short_preamble.
+ * @IEEE80211_TX_GMODE: Sdata is configured for GMode.
   *
   * Note: If you have to add new flags to the enumeration, then don't
   *      forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
@@ -349,6 +351,8 @@ enum mac80211_tx_control_flags {
         IEEE80211_TX_INTFL_NL80211_FRAME_TX     = BIT(21),
         IEEE80211_TX_CTL_LDPC                   = BIT(22),
         IEEE80211_TX_CTL_STBC                   = BIT(23) | BIT(24),
+       IEEE80211_TX_SHORT_PREABLE              = BIT(25),
+       IEEE80211_TX_GMODE                      = BIT(26),
  };

  #define IEEE80211_TX_CTL_STBC_SHIFT            23
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e1733dc..0ed22b5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1264,6 +1264,14 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
         }
         info->flags |= IEEE80211_TX_CTL_FIRST_FRAGMENT;

+       /* Set this here so drivers don't need to reference vif
+        * when calling ieee80211_rts_duration
+        */
+       if (sdata->vif.bss_conf.use_short_preamble)
+               tx.flags |= IEEE80211_TX_SHORT_PREABLE;
+       if (sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
+               tx.flags |= IEEE80211_TX_GMODE
+
         return TX_CONTINUE;
  }

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index aba025d..bd2227d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -209,6 +209,10 @@ __le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
                 short_preamble = sdata->vif.bss_conf.use_short_preamble;
                 if (sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
                         erp = rate->flags & IEEE80211_RATE_ERP_G;
+       } else {
+               short_preamble = !!(frame_txctl->flags & IEEE80211_TX_SHORT_PREABLE);
+               if (frame_txctl->flags & IEEE80211_TX_GMODE)
+                       erp = rate->flags & IEEE80211_RATE_ERP_G;
         }

         /* CTS duration */

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

