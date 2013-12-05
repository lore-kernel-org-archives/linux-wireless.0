Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30905 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab3LEKey (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 05:34:54 -0500
Date: Thu, 5 Dec 2013 13:34:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: brian@cozybit.com
Cc: linux-wireless@vger.kernel.org
Subject: re: mwl8k: differentiate between WMM queues and AMPDU queues
Message-ID: <20131205103448.GA3091@elgon.mountain> (sfid-20131205_113458_215381_B5BE3097)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Brian Cavagnolo,

The patch e600707b021e: "mwl8k: differentiate between WMM queues and
AMPDU queues" from Mar 17, 2011, leads to the following
static checker warning: "drivers/net/wireless/mwl8k.c:2456
mwl8k_cmd_get_hw_spec_sta()
	 error: buffer overflow 'cmd->tx_queue_ptrs' 4 <= 11"

drivers/net/wireless/mwl8k.c
    98  #define MWL8K_RX_QUEUES         1
    99  #define MWL8K_TX_WMM_QUEUES     4
   100  #define MWL8K_MAX_AMPDU_QUEUES  8
   101  #define MWL8K_MAX_TX_QUEUES     (MWL8K_TX_WMM_QUEUES + MWL8K_MAX_AMPDU_QUEUES)
   102  #define mwl8k_tx_queues(priv)   (MWL8K_TX_WMM_QUEUES + (priv)->num_ampdu_queues)
   103  

In theory mwl8k_tx_queues() is 4-12 as we can see below.

  2539                  priv->ap_macids_supported = 0x000000ff;
  2540                  priv->sta_macids_supported = 0x00000100;
  2541                  priv->num_ampdu_queues = le32_to_cpu(cmd->num_of_ampdu_queues);
  2542                  if (priv->num_ampdu_queues > MWL8K_MAX_AMPDU_QUEUES) {
  2543                          wiphy_warn(hw->wiphy, "fw reported %d ampdu queues"
  2544                                     " but we only support %d.\n",
  2545                                     priv->num_ampdu_queues,
  2546                                     MWL8K_MAX_AMPDU_QUEUES);
  2547                          priv->num_ampdu_queues = MWL8K_MAX_AMPDU_QUEUES;
  2548                  }

->num_ampdu_queues can go up to 8.


  2454          cmd->num_tx_queues = cpu_to_le32(mwl8k_tx_queues(priv));
  2455          for (i = 0; i < mwl8k_tx_queues(priv); i++)
  2456                  cmd->tx_queue_ptrs[i] = cpu_to_le32(priv->txq[i].txd_dma);

This code is super confusing because it is copied almost verbatim in two
places.  It took me a long time to figure that out.  Anyway,
->tx_queue_ptrs[] is an array with 4 elements.  If ->num_ampdu_queues is
anything besides zero then we are corrupting memory.  It's entirely
possible that ->num_ampdu_queues is zero here but I got a headache
trying to sort out the duplicate copies of this code.

A cleaner way to write this would be:

		for (i = 0; i < MWL8K_TX_WMM_QUEUES; i++)

or

		for (i = 0; i < ARRAY_SIZE(cmd->tx_queue_ptrs); i++)

That we don't have to follow all the callers and verify that adding
->num_ampdu_queues is a no-op.

priv->txq[] is 12 element array.

  2457          cmd->num_tx_desc_per_queue = cpu_to_le32(MWL8K_TX_DESCS);
  2458          cmd->total_rxd = cpu_to_le32(MWL8K_RX_DESCS);

regards,
dan carpenter

