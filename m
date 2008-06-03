Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:2192 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbYFCS0I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 14:26:08 -0400
Received: by nf-out-0910.google.com with SMTP id d3so644294nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jun 2008 11:26:06 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/11] rt2x00: Make rt2x00_set/get_field macros
Date: Tue, 3 Jun 2008 20:29:43 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200806032024.52931.IvDoorn@gmail.com> <200806032025.45029.IvDoorn@gmail.com> <200806032026.16128.IvDoorn@gmail.com>
In-Reply-To: <200806032026.16128.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200806032029.43881.IvDoorn@gmail.com> (sfid-20080603_202612_339969_EEBE9440)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rt2x00_set_field functions are very often used,
but GCC is better able to optimize them when they
are macros instead of static inline functions.

After changing it to macro's each rt2x00 driver will
loose about ~3500 bytes in size.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00reg.h |   71 +++++++++++++------------------
 1 files changed, 30 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index 7999d54..170c10d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -198,46 +198,35 @@ struct rt2x00_field32 {
 	};					\
 })
 
-static inline void rt2x00_set_field32(u32 *reg,
-				      const struct rt2x00_field32 field,
-				      const u32 value)
-{
-	*reg &= ~(field.bit_mask);
-	*reg |= (value << field.bit_offset) & field.bit_mask;
-}
-
-static inline u32 rt2x00_get_field32(const u32 reg,
-				     const struct rt2x00_field32 field)
-{
-	return (reg & field.bit_mask) >> field.bit_offset;
-}
-
-static inline void rt2x00_set_field16(u16 *reg,
-				      const struct rt2x00_field16 field,
-				      const u16 value)
-{
-	*reg &= ~(field.bit_mask);
-	*reg |= (value << field.bit_offset) & field.bit_mask;
-}
-
-static inline u16 rt2x00_get_field16(const u16 reg,
-				     const struct rt2x00_field16 field)
-{
-	return (reg & field.bit_mask) >> field.bit_offset;
-}
-
-static inline void rt2x00_set_field8(u8 *reg,
-				     const struct rt2x00_field8 field,
-				     const u8 value)
-{
-	*reg &= ~(field.bit_mask);
-	*reg |= (value << field.bit_offset) & field.bit_mask;
-}
-
-static inline u8 rt2x00_get_field8(const u8 reg,
-				   const struct rt2x00_field8 field)
-{
-	return (reg & field.bit_mask) >> field.bit_offset;
-}
+#define SET_FIELD(__reg, __type, __field, __value)\
+({						\
+	typecheck(__type, __field);		\
+	*(__reg) &= ~((__field).bit_mask);	\
+	*(__reg) |= ((__value) <<		\
+	    ((__field).bit_offset)) &		\
+	    ((__field).bit_mask);		\
+})
+
+#define GET_FIELD(__reg, __type, __field)	\
+({						\
+	typecheck(__type, __field);		\
+	((__reg) & ((__field).bit_mask)) >>	\
+	    ((__field).bit_offset);		\
+})
+
+#define rt2x00_set_field32(__reg, __field, __value) \
+	SET_FIELD(__reg, struct rt2x00_field32, __field, __value)
+#define rt2x00_get_field32(__reg, __field) \
+	GET_FIELD(__reg, struct rt2x00_field32, __field)
+
+#define rt2x00_set_field16(__reg, __field, __value) \
+	SET_FIELD(__reg, struct rt2x00_field16, __field, __value)
+#define rt2x00_get_field16(__reg, __field) \
+	GET_FIELD(__reg, struct rt2x00_field16, __field)
+
+#define rt2x00_set_field8(__reg, __field, __value) \
+	SET_FIELD(__reg, struct rt2x00_field8, __field, __value)
+#define rt2x00_get_field8(__reg, __field) \
+	GET_FIELD(__reg, struct rt2x00_field8, __field)
 
 #endif /* RT2X00REG_H */
-- 
1.5.5.3

