Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:61760 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269AbaIKNaE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 09:30:04 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: ethtool_ops.set_coalesce parameters
Date: Thu, 11 Sep 2014 16:29:54 +0300
Message-ID: <5130891.eDc4i9xPH6@lx-wigig-72> (sfid-20140911_153113_132742_B3AE1FC7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

 I have question regarding ethtool_ops.set_coalesce parameters.

>From one side, documentation (include/uapi/linux/ethtool.h) states:

 * Each pair of (usecs, max_frames) fields specifies that interrupts
 * should be coalesced until
 *	(usecs > 0 && time_since_first_completion >= usecs) ||
 *	(max_frames > 0 && completed_frames >= max_frames)
 *
 * It is illegal to set both usecs and max_frames to zero as this
 * would cause interrupts to never be generated.  To disable
 * coalescing, set usecs = 0 and max_frames = 1.

So, it suggests:

 Drivers for hardware that does not support
 counting completions should validate that max_frames == !rx_usecs.

Thus, I can conclude I should verify this for every pair.

Then, same documentation states following must not be 0:
- stats_block_coalesce_usecs
- rate_sample_interval


But, I see drivers either ignore unsupported values, or check that all of it are 0,
see for example in drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c:
	/* Check for not supported parameters  */
	if ((ec->rx_coalesce_usecs_irq) ||
	    (ec->rx_max_coalesced_frames_irq) ||
	    (ec->tx_coalesce_usecs_irq) ||
	    (ec->tx_max_coalesced_frames_irq) ||
	    (ec->stats_block_coalesce_usecs) ||
	    (ec->use_adaptive_rx_coalesce) ||
	    (ec->use_adaptive_tx_coalesce) ||
	    (ec->pkt_rate_low) ||
	    (ec->rx_coalesce_usecs_low) ||
	    (ec->rx_max_coalesced_frames_low) ||
	    (ec->tx_coalesce_usecs_low) ||
	    (ec->tx_max_coalesced_frames_low) ||
	    (ec->pkt_rate_high) ||
	    (ec->rx_coalesce_usecs_high) ||
	    (ec->rx_max_coalesced_frames_high) ||
	    (ec->tx_coalesce_usecs_high) ||
	    (ec->tx_max_coalesced_frames_high) ||
	    (ec->rate_sample_interval))
		return -EOPNOTSUPP;


Bottom line, my question is: what is the right way to handle parameters in
ethtool_ops.set_coalesce?

Thanks, Vladimir
