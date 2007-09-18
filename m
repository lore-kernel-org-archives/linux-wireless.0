Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50314 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbXIRUVJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 16:21:09 -0400
Message-ID: <46F0332D.3050704@garzik.org>
Date: Tue, 18 Sep 2007 16:21:01 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com>  <20070918113401.6a8a737f@the-village.bc.nu>  <43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com>  <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org> <43e72e890709181207j7c85dc29sb355a9f5a4207411@mail.gmail.com> <alpine.LFD.0.999.0709181219020.16478@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0709181219020.16478@woody.linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------020900040104060002090203"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020900040104060002090203
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Linus Torvalds wrote:
> Why do people insist on 
> using the old interfaces (and matching them with the new setup)?


readl/writel is [slightly] faster, and possibility of using even-write 
__raw_writel() exists, in the old interface...

  ...but pci_iomap() is a bus-friendly wrapper that handles a few checks 
and function calls for you, even if you know your device is always MMIO.

A new pci_mmio_map() helper, to be used with 100% MMIO hardware, might 
help eliminate confusion.

	Jeff



--------------020900040104060002090203
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
index cde592f..69e5390 100644
--- a/include/asm-generic/iomap.h
+++ b/include/asm-generic/iomap.h
@@ -63,6 +63,7 @@ extern void ioport_unmap(void __iomem *);
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+extern void __iomem *pci_mmio_map(struct pci_dev *dev, int bar, unsigned long max);
 extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
 
 #endif
diff --git a/lib/iomap.c b/lib/iomap.c
index 864f2ec..c87d7f3 100644
--- a/lib/iomap.c
+++ b/lib/iomap.c
@@ -275,9 +275,32 @@ void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 	return NULL;
 }
 
+/* for people who wish to use readl/writel exclusively */
+void __iomem *pci_mmio_map(struct pci_dev *dev, int bar, unsigned long maxlen)
+{
+	unsigned long start = pci_resource_start(dev, bar);
+	unsigned long len = pci_resource_len(dev, bar);
+	unsigned long flags = pci_resource_flags(dev, bar);
+
+	if (!len || !start)
+		return NULL;
+	if (maxlen && len > maxlen)
+		len = maxlen;
+	if (flags & IORESOURCE_IO)
+		return NULL;
+	if (flags & IORESOURCE_MEM) {
+		if (flags & IORESOURCE_CACHEABLE)
+			return ioremap(start, len);
+		return ioremap_nocache(start, len);
+	}
+	/* What? */
+	return NULL;
+}
+
 void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
 {
 	IO_COND(addr, /* nothing */, iounmap(addr));
 }
 EXPORT_SYMBOL(pci_iomap);
+EXPORT_SYMBOL(pci_mmio_map);
 EXPORT_SYMBOL(pci_iounmap);

--------------020900040104060002090203--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
