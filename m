Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4805 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182Ab1HZNT5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 09:19:57 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 08/13] staging: brcm80211: assigned physical addresses
 in dma.c correct type
Date: Fri, 26 Aug 2011 15:19:35 +0200
Message-ID: <1314364780-9462-9-git-send-email-rvossen@broadcom.com> (sfid-20110826_152020_163174_4CC13E71)
In-Reply-To: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
References: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Physical addresses in dma.c are all allocated by calls to
pci_alloc_consistent(). Since that call returns physical addresses as
type 'dma_addr_t', all physical addresses in dma.c were changed from
'unsigned long' to 'dma_addr_t'.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/dma.c |   35 ++++++++++++-----------------
 1 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index e53088e..42446cd 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -250,9 +250,9 @@ struct dma_info {
 	/* pointer to parallel array of pointers to packets */
 	struct sk_buff **txp;
 	/* Aligned physical address of descriptor ring */
-	unsigned long txdpa;
+	dma_addr_t txdpa;
 	/* Original physical address of descriptor ring */
-	unsigned long txdpaorig;
+	dma_addr_t txdpaorig;
 	u16 txdalign;	/* #bytes added to alloc'd mem to align txd */
 	u32 txdalloc;	/* #bytes allocated for the ring */
 	u32 xmtptrbase;	/* When using unaligned descriptors, the ptr register
@@ -266,9 +266,9 @@ struct dma_info {
 	/* pointer to parallel array of pointers to packets */
 	struct sk_buff **rxp;
 	/* Aligned physical address of descriptor ring */
-	unsigned long rxdpa;
+	dma_addr_t rxdpa;
 	/* Original physical address of descriptor ring */
-	unsigned long rxdpaorig;
+	dma_addr_t rxdpaorig;
 	u16 rxdalign;	/* #bytes added to alloc'd mem to align rxd */
 	u32 rxdalloc;	/* #bytes allocated for the ring */
 	u32 rcvptrbase;	/* Base for ptr reg when using unaligned descriptors */
@@ -327,14 +327,14 @@ static bool _dma_isaddrext(struct dma_info *di);
 static bool _dma_descriptor_align(struct dma_info *di);
 static bool _dma_alloc(struct dma_info *di, uint direction);
 static void _dma_ddtable_init(struct dma_info *di, uint direction,
-			      unsigned long pa);
+			      dma_addr_t pa);
 static void _dma_rxenable(struct dma_info *di);
 static struct sk_buff *_dma_getnextrxp(struct dma_info *di, bool forceall);
 static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags);
 static u8 dma_align_sizetobits(uint size);
 static void *dma_ringalloc(struct dma_info *di, u32 boundary, uint size,
 			   u16 *alignbits, uint *alloced,
-			   unsigned long *descpa);
+			   dma_addr_t *descpa);
 
 /* Prototypes for 64-bit routines */
 static bool dma64_alloc(struct dma_info *di, uint direction);
@@ -521,7 +521,7 @@ static inline u32 parity32(u32 data)
 
 static inline void
 dma64_dd_upd(struct dma_info *di, struct dma64desc *ddring,
-	     unsigned long pa, uint outidx, u32 *flags, u32 bufcount)
+	     dma_addr_t pa, uint outidx, u32 *flags, u32 bufcount)
 {
 	u32 ctrl2 = bufcount & D64_CTRL2_BC_MASK;
 
@@ -557,20 +557,15 @@ static bool _dma_alloc(struct dma_info *di, uint direction)
 }
 
 void *dma_alloc_consistent(struct pci_dev *pdev, uint size, u16 align_bits,
-			       uint *alloced, unsigned long *pap)
+			       uint *alloced, dma_addr_t *pap)
 {
-	void *rc;
-	dma_addr_t dma_addr;
-
 	if (align_bits) {
 		u16 align = (1 << align_bits);
 		if (!IS_ALIGNED(PAGE_SIZE, align))
 			size += align;
 		*alloced = size;
 	}
-	rc = pci_alloc_consistent(pdev, size, &dma_addr);
-	*pap = dma_addr;
-	return rc;
+	return pci_alloc_consistent(pdev, size, pap);
 }
 
 /* !! may be called with core in reset */
@@ -644,7 +639,7 @@ static bool _dma_isaddrext(struct dma_info *di)
 
 /* initialize descriptor table base address */
 static void
-_dma_ddtable_init(struct dma_info *di, uint direction, unsigned long pa)
+_dma_ddtable_init(struct dma_info *di, uint direction, dma_addr_t pa)
 {
 	if (!di->aligndesc_4k) {
 		if (direction == DMA_TX)
@@ -814,7 +809,7 @@ bool dma_rxfill(struct dma_pub *pub)
 	u32 flags = 0;
 	uint n;
 	uint i;
-	unsigned long pa;
+	dma_addr_t pa;
 	uint extra_offset = 0;
 	bool ring_empty;
 
@@ -977,7 +972,7 @@ u8 dma_align_sizetobits(uint size)
  */
 static void *dma_ringalloc(struct dma_info *di, u32 boundary, uint size,
 			   u16 *alignbits, uint *alloced,
-			   unsigned long *descpa)
+			   dma_addr_t *descpa)
 {
 	void *va;
 	u32 desc_strtaddr;
@@ -1203,7 +1198,7 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p0, bool commit)
 	uint len;
 	u16 txout;
 	u32 flags = 0;
-	unsigned long pa;
+	dma_addr_t pa;
 
 	DMA_TRACE(("%s: dma_txfast\n", di->name));
 
@@ -1331,7 +1326,7 @@ struct sk_buff *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 		goto bogus;
 
 	for (i = start; i != end && !txp; i = NEXTTXD(i)) {
-		unsigned long pa;
+		dma_addr_t pa;
 		uint size;
 
 		pa = cpu_to_le32(di->txd64[i].addrlow) - di->dataoffsetlow;
@@ -1366,7 +1361,7 @@ static struct sk_buff *dma64_getnextrxp(struct dma_info *di, bool forceall)
 {
 	uint i, curr;
 	struct sk_buff *rxp;
-	unsigned long pa;
+	dma_addr_t pa;
 
 	i = di->rxin;
 
-- 
1.7.4.1


