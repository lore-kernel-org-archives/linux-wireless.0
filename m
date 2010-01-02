Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:54409 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab0ABOK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2010 09:10:58 -0500
Received: by fxm25 with SMTP id 25so7654862fxm.21
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jan 2010 06:10:57 -0800 (PST)
Date: Sat, 2 Jan 2010 16:09:57 +0200
From: Dan Carpenter <error27@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, yi.zhu@intel.com
Subject: re: iwmc3200wifi: fix array out-of-boundary access
Message-ID: <20100102140957.GB5076@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It don't think 6c853da3f30c93 is right.  That's the patch 
titled "iwmc3200wifi: fix array out-of-boundary access"

	Allocate priv->rx_packets[IWM_RX_ID_HASH + 1] because the max array
	index is IWM_RX_ID_HASH according to IWM_RX_ID_GET_HASH().

In 2.6.33-rc2 IWM_RX_ID_GET_HASH() doesn't go as high as IWM_RX_ID_HASH 
and I don't see any array out-of-bounds.

#define IWM_RX_ID_GET_HASH(id) ((id) % IWM_RX_ID_HASH)

All the other code has the same assumptions.

Cscope tag: IWM_RX_ID_HASH
   #   line  filename / context / line
   1    175  drivers/net/wireless/iwmc3200wifi/iwm.h <<GLOBAL>>
             #define IWM_RX_ID_HASH 0xff
   2    271  drivers/net/wireless/iwmc3200wifi/iwm.h <<GLOBAL>>
             struct list_head rx_packets[IWM_RX_ID_HASH];
   3    292  drivers/net/wireless/iwmc3200wifi/debugfs.c <<iwm_debugfs_rx_ticket_read>>
             for (i = 0; i < IWM_RX_ID_HASH; i++) {
   4    176  drivers/net/wireless/iwmc3200wifi/iwm.h <<IWM_RX_ID_GET_HASH>>
             #define IWM_RX_ID_GET_HASH(id) ((id) % IWM_RX_ID_HASH)
   5    279  drivers/net/wireless/iwmc3200wifi/main.c <<iwm_priv_init>>
             for (i = 0; i < IWM_RX_ID_HASH; i++)
   6    396  drivers/net/wireless/iwmc3200wifi/rx.c <<iwm_rx_free>>
             for (i = 0; i < IWM_RX_ID_HASH; i++) {

regards,
dan carpenter
