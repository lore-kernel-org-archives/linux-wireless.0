Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:24369 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab0DJJIh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Apr 2010 05:08:37 -0400
Message-ID: <4BC04027.1090802@acm.org>
Date: Sat, 10 Apr 2010 11:08:55 +0200
From: U Kuehn <ukuehn@acm.org>
MIME-Version: 1.0
To: Intel Linux Wireless <ilw@linux.intel.com>
CC: linux-wireless@vger.kernel.org
Subject: Problem: Regression with iwl 4965 since 2.6.32.10
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

since 2.6.32.10 I am experiencing problems with my iwl4965 card. The
system is a Thinkpad X61s under debian unstable with self-compiled kernel.

In my usual setup, I connect to an WPA2-configured access point using
wpa_supplicant. Starting with 2.6.32.10 networking stops to work shortly
after the 4-way handshake. After the next re-keying it works again for a
short time.

I tracked the problem down to commit
44af042e42f2231579ea8ef7586d3789d198f609.

More precisely, it seems to work again, if I revert the second part of
it, i.e.

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c
b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 2ca947e..f449f06 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1071,6 +1071,7 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv,
int txq_id, int index)
        struct iwl_queue *q = &txq->q;
        struct iwl_tx_info *tx_info;
        int nfreed = 0;
+       struct ieee80211_hdr *hdr;

        if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
                IWL_ERR(priv, "Read index for DMA queue txq id (%d),
index %d, "
@@ -1085,6 +1086,10 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv,
int txq_id, int index)

                tx_info = &txq->txb[txq->q.read_ptr];
                ieee80211_tx_status_irqsafe(priv->hw, tx_info->skb[0]);
+
+               hdr = (struct ieee80211_hdr *)tx_info->skb[0]->data;
+               if (hdr && ieee80211_is_data_qos(hdr->frame_control))
+                       nfreed++;
                tx_info->skb[0] = NULL;

                if (priv->cfg->ops->lib->txq_inval_byte_cnt_tbl)


(However, doing the similar thing on 2.6.33.2, it does _not_ work.)



Here is the output of sh scripts/ver_linux:
Linux kallisto 2.6.32.11-toi3.1 #8 SMP PREEMPT Fri Apr 9 20:51:09 CEST
2010 i686 GNU/Linux

Gnu C                  4.3.4
Gnu make               3.81
binutils               2.19.51.20090827
util-linux             2.16.1
mount                  support
module-init-tools      3.10
e2fsprogs              1.41.9
pcmciautils            014
PPP                    2.4.4
Linux C Library        2.10.2
Dynamic linker (ldd)   2.10.2
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15
Sh-utils               7.4
wireless-tools         29
Modules Loaded         iwlagn iwlcore mac80211 cfg80211 kvm_intel
tp_smapi thinkpad_ec


If I can help with any more information or testing to track down the
problem please let me know.

Best regards,
Ulrich
