Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:11248 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab0BRDoq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 22:44:46 -0500
Subject: Re: compat-wireless + Linux 2.6.26.8 testing results
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e891002161459m4174654aj8d7985f32cb8678d@mail.gmail.com>
References: <43e72e891002121810g25d21eb5y254969458a9a58e7@mail.gmail.com>
	 <1266124222.13902.42.camel@mj>
	 <43e72e891002161323v70636defr2500784ffb44d775@mail.gmail.com>
	 <1266358340.2659.37.camel@mj>
	 <43e72e891002161459m4174654aj8d7985f32cb8678d@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 17 Feb 2010 22:44:35 -0500
Message-Id: <1266464675.3065.30.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-02-16 at 14:59 -0800, Luis R. Rodriguez wrote:

> > Anyway, I'd rather see
> > dma_sync_single_range_for_device() for ARM backported.
> 
> Patches are welcomed for it indeed.

Here's the patch.  I'm not sure if include/net/compat-2.6.27.h or
compat/compat-2.6.27.h is the real source file, as I was patching the
downloaded tarball.

The missing functions are only used by b44.  The functions available in
2.6.26 don't have the offset argument, so I had to extend the range to
start at zero.  This could affect the b44 throughput, but I would not
worry too much about it.

The is another problem.  For some reason, CONFIG_SSB_PCMCIAHOST is
enabled in compat_autoconf.h, even though the target kernel lacks PCMCIA
support.  However, CONFIG_SSB_PCMCIAHOST is not set in the makefiles, so
ssb.ko is compiled with CONFIG_SSB_PCMCIAHOST, but pcmcia.o is not
linked into it, which leads to unresolved symbols.  However, the build
succeeds and there are no warnings about it.


--- a/include/net/compat-2.6.27.h
+++ b/include/net/compat-2.6.27.h
@@ -185,4 +185,28 @@
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)) */
 
+#ifdef CONFIG_ARM
+
+/*
+ * The caller asks to handle a range between offset and offset + size,
+ * but we process a larger range from 0 to offset + size due to lack of
+ * offset support.
+ */
+
+static inline void dma_sync_single_range_for_cpu(struct device *dev,
+		dma_addr_t handle, unsigned long offset, size_t size,
+		enum dma_data_direction dir)
+{
+	dma_sync_single_for_cpu(dev, handle, offset + size, dir);
+}
+
+static inline void dma_sync_single_range_for_device(struct device *dev,
+		dma_addr_t handle, unsigned long offset, size_t size,
+		enum dma_data_direction dir)
+{
+	dma_sync_single_for_device(dev, handle, offset + size, dir);
+}
+
+#endif /* arm */
+
 #endif /* LINUX_26_27_COMPAT_H */

-- 
Regards,
Pavel Roskin
