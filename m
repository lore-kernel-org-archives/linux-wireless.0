Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37322 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933053AbeFTIpY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 04:45:24 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v6 (resend) 2/3] bitfield: add u8 helpers
Date: Wed, 20 Jun 2018 08:58:29 +0200
Message-Id: <20180620065830.6612-3-johannes@sipsolutions.net> (sfid-20180620_104619_939582_8FB5EE88)
In-Reply-To: <20180620065830.6612-1-johannes@sipsolutions.net>
References: <20180620065830.6612-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no reason why we shouldn't pack/unpack bits into/from
u8 values/registers/etc., so add u8 helpers.

Use the ____MAKE_OP() macro directly to avoid having nonsense
le8_encode_bits() and similar functions.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/bitfield.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
index 147a7bb341dd..65a6981eef7b 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -143,6 +143,7 @@ static __always_inline base type##_get_bits(__##type v, base field)	\
 	____MAKE_OP(le##size,u##size,cpu_to_le##size,le##size##_to_cpu)	\
 	____MAKE_OP(be##size,u##size,cpu_to_be##size,be##size##_to_cpu)	\
 	____MAKE_OP(u##size,u##size,,)
+____MAKE_OP(u8,u8,,)
 __MAKE_OP(16)
 __MAKE_OP(32)
 __MAKE_OP(64)
-- 
2.14.4
