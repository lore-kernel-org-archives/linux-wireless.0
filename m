Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from promwad.com ([83.149.69.23]:55009 "EHLO promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbYKUWqt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 17:46:49 -0500
Received: from mail.promwad.com ([212.98.183.232] helo=intranet.promwad.com)
	by promwad.com with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.63)
	(envelope-from <ivan.kuten@promwad.com>)
	id 1L3elz-0007zT-0F
	for linux-wireless@vger.kernel.org; Sat, 22 Nov 2008 00:46:47 +0200
Received: from intranet.promwad.com ([192.168.10.1] helo=promwad.com)
	by intranet.promwad.com with esmtpa (Exim 4.69)
	(envelope-from <ivan.kuten@promwad.com>)
	id 1L3elw-0000Vk-0c
	for linux-wireless@vger.kernel.org; Sat, 22 Nov 2008 00:46:44 +0200
MIME-Version: 1.0
Date: Sat, 22 Nov 2008 00:46:39 +0200
From: Ivan Kuten <ivan.kuten@promwad.com>
To: linux-wireless@vger.kernel.org
Subject: =?UTF-8?Q?ieee=38=30=32=31=31=5Fwep=5Fencrypt=5Fdata=5Ffix=5Funaligned=5F?=
 =?UTF-8?Q?access=2Epatch?=
Message-ID: <eaf88bcfcb5b61c24cf1b8b682c5ff3c@promwad.com> (sfid-20081121_234653_121082_4B762D50)
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, 

Please review the following patch which is supposed to fix unaligned access
on Blackfin architecture.
In function net/mac80211/wep.c ieee80211_wep_encrypt_data:
__le32 *icv;
icv = (__le32 *)(data + data_len); 

after the operation above icv pointer may become unaligned. 
The patch below fixes this issue:


--- linux-2.6.28-rc3/net/mac80211/wep.c 2008-11-20 00:04:58.000000000 -0500
+++ linux-2.6.86-rc3.new/net/mac80211/wep.c     2008-11-22
00:37:53.000000000 -0500
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


Comments?

Regards,
Ivan


