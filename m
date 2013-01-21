Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36450
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090Ab3AUVrS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2013 16:47:18 -0500
Date: Mon, 21 Jan 2013 16:47:08 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: David Miller <davem@davemloft.net>
Cc: mcgrof@do-not-panic.com, sgruszka@redhat.com,
	bhutchings@solarflare.com, netdev@vger.kernel.org,
	edumazet@google.com, greearb@candelatech.com, bjorn@mork.no,
	linux-wireless@vger.kernel.org, mirqus@gmail.com,
	johannes@sipsolutions.net
Subject: Re: [PATCH v3] net, wireless: overwrite default_ethtool_ops
Message-ID: <20130121214708.GF1432@bombadil.infradead.org> (sfid-20130121_224724_093665_B71A13F0)
References: <1357934432.2643.4.camel@bwh-desktop.uk.solarflarecom.com>
 <20130111.155936.1799008114956712424.davem@davemloft.net>
 <CAB=NE6XjvupJ5XO0EN0HVwdy61ECWL=Ey0g1gsNm+v8Sen=nsQ@mail.gmail.com>
 <20130121.160404.1007504714461228602.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130121.160404.1007504714461228602.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 21, 2013 at 04:04:04PM -0500, David Miller wrote:
> 
> It's queued up for -stable already as is clearly seen at:
> 
> http://patchwork.ozlabs.org/user/bundle/2566/?state=*

Thanks, I was not aware of this bundle. In this case assuming
this goes into v3.7.5 this is being backported with special handling
between 3.7.0 and 3.7.5 as follows onto compat.

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] compat: backport netdev_set_default_ethtool_ops()

Stanislaw found that due to commit 2c60db03 by Eric Dumazet
the wireless core was not assigning driver specific ethtool_ops.
This was fixed by Stanislaw's commit d07d7507 which added
netdev_set_default_ethtool_ops(). Since Eric's commit 2c60db03
is on v3.7-rc1 Stanislaw's fix is required down to v3.7 as well.
The d07d7507 commit is currently present on v3.8-rc4 and is on
its way to what we think may be v3.7.5. Because of this kernels
older than v3.7.5 will require the full implementation while
older kernels than v3.7.0 will require just assigning the ops
passed only if netdev has no ops already set just as we used
to have it implemented on cfg80211.

mcgrof@frijol ~/linux-stable (git::linux-3.8.y)$ git describe --contains 2c60db
v3.7-rc1~145^2~142

mcgrof@frijol ~/linux-stable (git::linux-3.8.y)$ git describe --contains d07d75
v3.8-rc4~29^2~4

ckmake results:

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
17  3.0.50              [  OK  ]
18  3.1.10              [  OK  ]
19  3.2.33              [  OK  ]
20  3.3.8               [  OK  ]
21  3.4.17              [  OK  ]
22  3.5.7               [  OK  ]
23  3.6.5               [  OK  ]
24  3.7.0               [  OK  ]

real    0m34.791s
user    11m38.572s
sys     3m56.927s

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 compat/compat-3.8.c        |   22 ++++++++++++++++++++++
 include/linux/compat-3.8.h |    6 ++++++
 2 files changed, 28 insertions(+)

diff --git a/compat/compat-3.8.c b/compat/compat-3.8.c
index 034dd77..1867258 100644
--- a/compat/compat-3.8.c
+++ b/compat/compat-3.8.c
@@ -16,6 +16,28 @@
 #include <linux/hid.h>
 #include <linux/module.h>
 #include "hid-ids.h"
+#include <linux/netdevice.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,7,5))
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,7,0))
+void netdev_set_default_ethtool_ops(struct net_device *dev,
+				    const struct ethtool_ops *ops)
+{
+	if (!dev->ethtool_ops)
+		dev->ethtool_ops = ops;
+}
+#else /* kernel is between 3.7.0 and 3.7.4 */;
+void netdev_set_default_ethtool_ops(struct net_device *dev,
+				    const struct ethtool_ops *ops)
+{
+	if (dev->ethtool_ops == &default_ethtool_ops)
+		dev->ethtool_ops = ops;
+}
+#endif
+
+EXPORT_SYMBOL_GPL(netdev_set_default_ethtool_ops);
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,7,5) */
 
 /* a list of devices that shouldn't be handled by HID core at all */
 static const struct hid_device_id hid_ignore_list[] = {
diff --git a/include/linux/compat-3.8.h b/include/linux/compat-3.8.h
index 052de95..942b4cb 100644
--- a/include/linux/compat-3.8.h
+++ b/include/linux/compat-3.8.h
@@ -6,6 +6,12 @@
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(3,8,0))
 
 #include <linux/hid.h>
+#include <linux/netdevice.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,7,5))
+extern void netdev_set_default_ethtool_ops(struct net_device *dev,
+					   const struct ethtool_ops *ops);
+#endif
 
 #define HID_BUS_ANY                            0xffff
 #define HID_GROUP_ANY                          0x0000
-- 
1.7.10.4

