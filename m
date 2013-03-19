Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:59274 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932911Ab3CSP7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 11:59:13 -0400
Received: by mail-ee0-f52.google.com with SMTP id b15so322263eek.11
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 08:59:12 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] bcma: define board types
Date: Tue, 19 Mar 2013 16:58:59 +0100
Message-Id: <1363708739-25721-2-git-send-email-zajec5@gmail.com> (sfid-20130319_165918_683044_86E77059)
In-Reply-To: <1363708739-25721-1-git-send-email-zajec5@gmail.com>
References: <1363708739-25721-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using that IDs we can write workarounds for various cards

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 include/linux/bcma/bcma.h |   54 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index e0ce311..0ab6712 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -173,6 +173,60 @@ struct bcma_host_ops {
 #define BCMA_CHIP_ID_BCM53572	53572
 #define  BCMA_PKG_ID_BCM47188	9
 
+/* Board types (on PCI usually equals to the subsystem dev id) */
+/* BCM4313 */
+#define BCMA_BOARD_TYPE_BCM94313BU	0X050F
+#define BCMA_BOARD_TYPE_BCM94313HM	0X0510
+#define BCMA_BOARD_TYPE_BCM94313EPA	0X0511
+#define BCMA_BOARD_TYPE_BCM94313HMG	0X051C
+/* BCM4716 */
+#define BCMA_BOARD_TYPE_BCM94716NR2	0X04CD
+/* BCM43224 */
+#define BCMA_BOARD_TYPE_BCM943224X21	0X056E
+#define BCMA_BOARD_TYPE_BCM943224X21_FCC	0X00D1
+#define BCMA_BOARD_TYPE_BCM943224X21B	0X00E9
+#define BCMA_BOARD_TYPE_BCM943224M93	0X008B
+#define BCMA_BOARD_TYPE_BCM943224M93A	0X0090
+#define BCMA_BOARD_TYPE_BCM943224X16	0X0093
+#define BCMA_BOARD_TYPE_BCM94322X9	0X008D
+#define BCMA_BOARD_TYPE_BCM94322M35E	0X008E
+/* BCM43228 */
+#define BCMA_BOARD_TYPE_BCM943228BU8	0X0540
+#define BCMA_BOARD_TYPE_BCM943228BU9	0X0541
+#define BCMA_BOARD_TYPE_BCM943228BU	0X0542
+#define BCMA_BOARD_TYPE_BCM943227HM4L	0X0543
+#define BCMA_BOARD_TYPE_BCM943227HMB	0X0544
+#define BCMA_BOARD_TYPE_BCM943228HM4L	0X0545
+#define BCMA_BOARD_TYPE_BCM943228SD	0X0573
+/* BCM4331 */
+#define BCMA_BOARD_TYPE_BCM94331X19	0X00D6
+#define BCMA_BOARD_TYPE_BCM94331X28	0X00E4
+#define BCMA_BOARD_TYPE_BCM94331X28B	0X010E
+#define BCMA_BOARD_TYPE_BCM94331PCIEBT3AX	0X00E4
+#define BCMA_BOARD_TYPE_BCM94331X12_2G	0X00EC
+#define BCMA_BOARD_TYPE_BCM94331X12_5G	0X00ED
+#define BCMA_BOARD_TYPE_BCM94331X29B	0X00EF
+#define BCMA_BOARD_TYPE_BCM94331CSAX	0X00EF
+#define BCMA_BOARD_TYPE_BCM94331X19C	0X00F5
+#define BCMA_BOARD_TYPE_BCM94331X33	0X00F4
+#define BCMA_BOARD_TYPE_BCM94331BU	0X0523
+#define BCMA_BOARD_TYPE_BCM94331S9BU	0X0524
+#define BCMA_BOARD_TYPE_BCM94331MC	0X0525
+#define BCMA_BOARD_TYPE_BCM94331MCI	0X0526
+#define BCMA_BOARD_TYPE_BCM94331PCIEBT4	0X0527
+#define BCMA_BOARD_TYPE_BCM94331HM	0X0574
+#define BCMA_BOARD_TYPE_BCM94331PCIEDUAL	0X059B
+#define BCMA_BOARD_TYPE_BCM94331MCH5	0X05A9
+#define BCMA_BOARD_TYPE_BCM94331CS	0X05C6
+#define BCMA_BOARD_TYPE_BCM94331CD	0X05DA
+/* BCM53572 */
+#define BCMA_BOARD_TYPE_BCM953572BU	0X058D
+#define BCMA_BOARD_TYPE_BCM953572NR2	0X058E
+#define BCMA_BOARD_TYPE_BCM947188NR2	0X058F
+#define BCMA_BOARD_TYPE_BCM953572SDRNR2	0X0590
+/* BCM43142 */
+#define BCMA_BOARD_TYPE_BCM943142HM	0X05E0
+
 struct bcma_device {
 	struct bcma_bus *bus;
 	struct bcma_device_id id;
-- 
1.7.10.4

