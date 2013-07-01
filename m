Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:58219 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab3GAUzj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jul 2013 16:55:39 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 3/3] backports: add SPEED_UNKNOWN and DUPLEX_UNKNOWN
Date: Mon,  1 Jul 2013 13:55:20 -0700
Message-Id: <1372712120-16606-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20130701_225541_918086_E03103A5)
In-Reply-To: <1372712120-16606-1-git-send-email-mcgrof@do-not-panic.com>
References: <1372712120-16606-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This gets us in synch with next-20130618.

This was added via uapi/linux/ethtool.h but using
that file causes some odd issues I simply cannot
resolve right now. I stuff these definitions into
the regular include/linux/ethtool.h for now.

This backports commit 589665f5 added via v3.2.

mcgrof@frijol ~/linux-stable (git::master)$ git describe --contains \
	589665f5a6008dbce1d0af2cb93e94a80bf78151
v3.2-rc1~4^2~10

commit 589665f5a6008dbce1d0af2cb93e94a80bf78151
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Fri Nov 4 08:21:38 2011 +0000

    bonding: comparing a u8 with -1 is always false

    slave->duplex is a u8 type so the in bond_info_show_slave() when we
    check "if (slave->duplex == -1)", it's always false.

    Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

1   2.6.24              [  OK  ]
2   2.6.25              [  OK  ]
3   2.6.26              [  OK  ]
4   2.6.27              [  OK  ]
5   2.6.28              [  OK  ]
6   2.6.29              [  OK  ]
7   2.6.30              [  OK  ]
8   2.6.31              [  OK  ]
9   2.6.32              [  OK  ]
10  2.6.33              [  OK  ]
11  2.6.34              [  OK  ]
12  2.6.35              [  OK  ]
13  2.6.36              [  OK  ]
14  2.6.37              [  OK  ]
15  2.6.38              [  OK  ]
16  2.6.39              [  OK  ]
17  3.0.79              [  OK  ]
18  3.1.10              [  OK  ]
19  3.10-rc1            [  OK  ]
20  3.2.45              [  OK  ]
21  3.3.8               [  OK  ]
22  3.4.46              [  OK  ]
23  3.5.7               [  OK  ]
24  3.6.11              [  OK  ]
25  3.7.10              [  OK  ]
26  3.8.13              [  OK  ]
27  3.9.3               [  OK  ]

real    15m7.262s
user    335m33.818s
sys     82m36.486s

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 backport/backport-include/linux/ethtool.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/backport/backport-include/linux/ethtool.h b/backport/backport-include/linux/ethtool.h
index 0c1eee6..2f323b0 100644
--- a/backport/backport-include/linux/ethtool.h
+++ b/backport/backport-include/linux/ethtool.h
@@ -3,6 +3,14 @@
 #include_next <linux/ethtool.h>
 #include <linux/version.h>
 
+#ifndef SPEED_UNKNOWN
+#define SPEED_UNKNOWN  -1
+#endif /* SPEED_UNKNOWN */
+
+#ifndef DUPLEX_UNKNOWN
+#define DUPLEX_UNKNOWN 0xff
+#endif /* DUPLEX_UNKNOWN */
+
 #if LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0)
 #define ethtool_rxfh_indir_default LINUX_BACKPORT(ethtool_rxfh_indir_default)
 static inline u32 ethtool_rxfh_indir_default(u32 index, u32 n_rx_rings)
-- 
1.7.10.4

