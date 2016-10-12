Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:38704 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932280AbcJLJC1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 05:02:27 -0400
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u9C6H2Pn026163
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-wireless@vger.kernel.org>; Wed, 12 Oct 2016 06:17:02 GMT
Date: Wed, 12 Oct 2016 09:14:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: toke@toke.dk
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] mac80211: Move reorder-sensitive TX handlers to after
 TXQ dequeue
Message-ID: <20161012061458.GM12841@mwanda> (sfid-20161012_110238_197165_14D22F50)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Toke Høiland-Jørgensen,

This is a semi-automatic email about new static checker warnings.

The patch bb42f2d13ffc: "mac80211: Move reorder-sensitive TX handlers 
to after TXQ dequeue" from Sep 22, 2016, leads to the following 
Smatch complaint:

net/mac80211/tx.c:3242 ieee80211_xmit_fast_finish()
	 error: we previously assumed 'key' could be null (see line 3209)

net/mac80211/tx.c
  3208	
  3209		if (key)
                    ^^^
Check.

  3210			info->control.hw_key = &key->conf;
  3211	
  3212		ieee80211_tx_stats(skb->dev, skb->len);
  3213	
  3214		if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
  3215			tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
  3216			*ieee80211_get_qos_ctl(hdr) = tid;
  3217			hdr->seq_ctrl = ieee80211_tx_next_seq(sta, tid);
  3218		} else {
  3219			info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
  3220			hdr->seq_ctrl = cpu_to_le16(sdata->sequence_number);
  3221			sdata->sequence_number += 0x10;
  3222		}
  3223	
  3224		if (skb_shinfo(skb)->gso_size)
  3225			sta->tx_stats.msdu[tid] +=
  3226				DIV_ROUND_UP(skb->len, skb_shinfo(skb)->gso_size);
  3227		else
  3228			sta->tx_stats.msdu[tid]++;
  3229	
  3230		info->hw_queue = sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
  3231	
  3232		/* statistics normally done by ieee80211_tx_h_stats (but that
  3233		 * has to consider fragmentation, so is more complex)
  3234		 */
  3235		sta->tx_stats.bytes[skb_get_queue_mapping(skb)] += skb->len;
  3236		sta->tx_stats.packets[skb_get_queue_mapping(skb)]++;
  3237	
  3238		if (pn_offs) {
                    ^^^^^^^
Maybe when pn_offs is non-zero that implies key is non-NULL? 

  3239			u64 pn;
  3240			u8 *crypto_hdr = skb->data + pn_offs;
  3241	
  3242			switch (key->conf.cipher) {
                                ^^^^^
Unchecked dereference.

  3243			case WLAN_CIPHER_SUITE_CCMP:
  3244			case WLAN_CIPHER_SUITE_CCMP_256:

regards,
dan carpenter
