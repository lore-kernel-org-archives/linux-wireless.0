Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from promwad.com ([83.149.69.23]:37537 "EHLO promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbYKXNSJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 08:18:09 -0500
Received: from mail.promwad.com ([212.98.183.232] helo=intranet.promwad.com)
	by promwad.com with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.63)
	(envelope-from <ivan.kuten@promwad.com>)
	id 1L4bKJ-0000r6-8T
	for linux-wireless@vger.kernel.org; Mon, 24 Nov 2008 15:18:07 +0200
Received: from [192.168.11.101]
	by intranet.promwad.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <ivan.kuten@promwad.com>)
	id 1L4bKE-00078H-8U
	for linux-wireless@vger.kernel.org; Mon, 24 Nov 2008 15:18:02 +0200
Message-ID: <492B0BF2.9020505@promwad.com> (sfid-20081124_141813_580682_708F9098)
Date: Mon, 24 Nov 2008 15:17:54 -0500
From: Ivan Kuten <ivan.kuten@promwad.com>
Reply-To: ivan.kuten@promwad.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: PATCH: ieee80211_wep_encrypt_data_fix_unaligned_access.patch
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch fixes possible unaligned access in ieee80211_wep_encrypt_data function.

Signed-off-by: Ivan Kuten <ivan.kuten@promwad.com>

--- linux-2.6.28-rc3/net/mac80211/wep.c 2008-11-20 00:04:58.000000000 -0500
+++ linux-2.6.86-rc3.new/net/mac80211/wep.c     2008-11-22 00:37:53.000000000 -0500
@@ -123,10 +123,10 @@
  {
         struct blkcipher_desc desc = { .tfm = tfm };
         struct scatterlist sg;
-       __le32 *icv;
+       __le32 icv;

-       icv = (__le32 *)(data + data_len);
-       *icv = cpu_to_le32(~crc32_le(~0, data, data_len));
+       icv = cpu_to_le32(~crc32_le(~0, data, data_len));
+       put_unaligned(icv, (__le32 *)(data + data_len));

         crypto_blkcipher_setkey(tfm, rc4key, klen);
         sg_init_one(&sg, data, data_len + WEP_ICV_LEN);

---

Best regards,
Ivan

