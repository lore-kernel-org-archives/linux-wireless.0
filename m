Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18720 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbcBHR43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 12:56:29 -0500
Date: Mon, 8 Feb 2016 20:55:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: gwingerde@kpnplanet.nl
Cc: linux-wireless@vger.kernel.org
Subject: re: rt2x00: Fix queue related oops in case of deselected mac80211
 multi-queue feature.
Message-ID: <20160208175559.GA13933@mwanda> (sfid-20160208_185632_436557_8092159A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Gertjan van Wingerde,

I have a question about patch 61448f88078e: "rt2x00: Fix queue related
oops in case of deselected mac80211 multi-queue feature." from May 10,
2008 because I think there is an off by one.

drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
  1239          /*
  1240           * We need the following queues:
  1241           * RX: 1
  1242           * TX: ops->tx_queues
  1243           * Beacon: 1
  1244           * Atim: 1 (if required)
  1245           */
  1246          rt2x00dev->data_queues = 2 + rt2x00dev->ops->tx_queues + req_atim;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We allocate everything at once in once chunk of memory.

  1247  
  1248          queue = kcalloc(rt2x00dev->data_queues, sizeof(*queue), GFP_KERNEL);
  1249          if (!queue) {
  1250                  rt2x00_err(rt2x00dev, "Queue allocation failed\n");
  1251                  return -ENOMEM;
  1252          }
  1253  
  1254          /*
  1255           * Initialize pointers
  1256           */
  1257          rt2x00dev->rx = queue;

This is equivalent to &queue[0].  It's actually helpful to static
checkers and people reading the code if you write it that because we
are talking about the first element only and not the whole buffer.
Meanwhile, people do it the reverse way and refer to &foo->start to talk
about that whole "foo" buffer...  :/

  1258          rt2x00dev->tx = &queue[1];
  1259          rt2x00dev->bcn = &queue[1 + rt2x00dev->ops->tx_queues];

There are 2 ->tx_queues, I think so we skipped one queue.  We should
have put it at &queue[2].  I looked at it briefly and I didn't see where
the second queue is ever used so maybe this is harmless beyond the
slight waste of memory.

  1260          rt2x00dev->atim = req_atim ? &queue[2 + rt2x00dev->ops->tx_queues] : NULL;
  1261  
  1262          /*

regards,
dan carpenter
