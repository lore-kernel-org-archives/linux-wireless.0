Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17892 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbZI2CzH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 22:55:07 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2009 19:55:12 -0700
Date: Mon, 28 Sep 2009 19:55:09 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: compat-wireless master-2009-09-28 breakage and suggested fixes
Message-ID: <20090929025509.GB6529@mosca>
References: <3ace41890909281935k284402f3q90b54ae20a636eeb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <3ace41890909281935k284402f3q90b54ae20a636eeb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 28, 2009 at 07:35:22PM -0700, Hin-Tak Leung wrote:
> commit d0cf9c0dadcdc89a755bcb301cfc9c796eb28ccf
> Author: Stephen Hemminger <shemminger@vyatta.com>
> Date:   Mon Aug 31 19:50:57 2009 +0000
> 
>     wireless: convert drivers to netdev_tx_t
> 
> and the 2nd change due to this:
> 
> commit 384912ed194e43c03ad1cdaa09b0b1e488c34d46
> Author: Marcel Holtmann <marcel@holtmann.org>
> Date:   Mon Aug 31 21:08:19 2009 +0000
> 
>     net: Add DEVTYPE support for Ethernet based devices
> 
> Both of these changes are traced back to changes in
> <linux/netdevice.h> , which compat-wireless does not ship. What's your
> policy on these kind of changes to compat-wireless?
> (the 2nd SET_NETDEV_DEVTYPE change probably can be spanned by an
> ifndef SET_NETDEV_DEVTYPE, and roll into
> "compat/patches/01-netdev.patch"? Should the first kind of change also
> go into compat/patches/01-netdev.patch?)

I don't see this yet on wireless-testing but it is on 2.6.32.
I backported this as follows. I'll push this out shortly.

From: Luis R. Rodriguez <lrodriguez@atheros.com>
Subject: [PATCH] Fix compilation against for 2.6.32 changes

2.6.32 added SET_NETDEV_DEVTYPE() and netdev_tx

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 compat/compat-2.6.32.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/compat/compat-2.6.32.h b/compat/compat-2.6.32.h
index f7081f2..418b521 100644
--- a/compat/compat-2.6.32.h
+++ b/compat/compat-2.6.32.h
@@ -31,6 +31,18 @@
 
 #define dev_change_net_namespace(a, b, c) (-EOPNOTSUPP)
 
+#define SET_NETDEV_DEVTYPE(netdev, type)
+
+#ifdef __KERNEL__
+/* Driver transmit return codes */
+enum netdev_tx {
+	BACKPORT_NETDEV_TX_OK = NETDEV_TX_OK,       /* driver took care of packet */
+	BACKPORT_NETDEV_TX_BUSY = NETDEV_TX_BUSY,         /* driver tx path was busy*/
+	BACKPORT_NETDEV_TX_LOCKED = NETDEV_TX_LOCKED,  /* driver tx lock was already taken */
+};
+typedef enum netdev_tx netdev_tx_t;
+#endif /* __KERNEL__ */
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32)) */
 
 #endif /* LINUX_26_32_COMPAT_H */
-- 
1.6.3.3

