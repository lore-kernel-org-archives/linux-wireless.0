Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:17555 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab2DPKzc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 06:55:32 -0400
Date: Mon, 16 Apr 2012 13:55:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: arik@wizery.com
Cc: linux-wireless@vger.kernel.org
Subject: re: wlcore/wl12xx: change GEM Tx-spare blocks per-vif
Message-ID: <20120416105528.GA25190@elgon.mountain> (sfid-20120416_125536_008436_5B289366)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Arik Nemtsov,

This is a semi-automatic email about new static checker warnings.

The patch 3edab305dfd4: "wlcore/wl12xx: change GEM Tx-spare blocks 
per-vif" from Dec 7, 2011, leads to the following Smatch complaint:

drivers/net/wireless/ti/wlcore/tx.c:231 wl1271_tx_allocate()
	 warn: variable dereferenced before check 'wlvif' (see line 208)

drivers/net/wireless/ti/wlcore/tx.c
   207		else if (wlvif->is_gem)
                         ^^^^^^^^^^^^^
New dereference.

   208			spare_blocks = wl->gem_tx_spare;
   209	
   210		total_blocks = wlcore_hw_calc_tx_blocks(wl, total_len, spare_blocks);
   211	
   212		if (total_blocks <= wl->tx_blocks_available) {
   213			desc = (struct wl1271_tx_hw_descr *)skb_push(
   214				skb, total_len - skb->len);
   215	
   216			wlcore_hw_set_tx_desc_blocks(wl, desc, total_blocks,
   217						     spare_blocks);
   218	
   219			desc->id = id;
   220	
   221			wl->tx_blocks_available -= total_blocks;
   222			wl->tx_allocated_blocks += total_blocks;
   223	
   224			/* If the FW was empty before, arm the Tx watchdog */
   225			if (wl->tx_allocated_blocks == total_blocks)
   226				wl12xx_rearm_tx_watchdog_locked(wl);
   227	
   228			ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
   229			wl->tx_allocated_pkts[ac]++;
   230	
   231			if (!is_dummy && wlvif &&
                                         ^^^^^
Old check.

   232			    wlvif->bss_type == BSS_TYPE_AP_BSS &&
   233			    test_bit(hlid, wlvif->ap.sta_hlid_map))

regards,
dan carpenter

