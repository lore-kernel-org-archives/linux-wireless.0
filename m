Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793404658;
	b=qseCcNyKLYqunl0PHBt3jrACqnP6O7kEwRhcF9EfqFPpX7IbsjPrxt62e6Z0/UI/QeES
	 epVHqwL77FjAHX5Dnb8/b/zAr1NFaL9CHHkbSBIQF31+IXC3WpJWfvsZBoh2giQahoVr0
	 yPcrafhxFa2thbKR3ShvOaLBH1BohdXx/gVv+OcoWlGNVRMhyQ+sW2vhRj6ZytzQkFvOl
	 c6Ry/8QUGlFrOu8k2RmXNmGDZ+ps8nruoI/QYQ+0YSLB5Uu51IGWYrY9hFU9Xru8QqDBv
	 IRKyls1DcSNLh0Gn/PGuSfBCKLQFfxQJYWx2Y/AXCOz5o5rZW9aVnZ6iQM4v4DmsG8g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793404658;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=4yzPnyew9QEMmru9umOoTOA+WxUeqUnPHxZ35Kso82c=;
	b=cFw1k8zJMram/TyyZOe3FXQuZu8uYiI0C+ub4ZyVNBF+KWCJWSR0rma5ZjClJRofFgcS
	 0x/sUw3kDL2Hcw3fLk6KdHecSk7fyqiQLllZxO+aM1oqMzf2EY84Y1Kwm1CPOoWl4z7i/
	 U+fk4toB9QLuioADEoV95WiEIHOlcu6qX/1PV38vtEELahrvt0c/kwP0bokKGrVUjgaJF
	 0hMRHATJRmqXD/k3viUmXefxNWehgfqSVn40VVLUnz/5dVEO9qgZ4RQAHkwAfCtqqAGrs
	 VncwUbxzZDT0WEuc2D6QOBHvISOhZ65V9UlABmbBeVjBFq0RDh8x1AhIRzOWdUuhlwg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="F/enRrYW";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE783606A323;
	Fri, 30 Oct 2026 23:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F/enRrYW
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793404657;
	b=on4HdvmjDM3bNSPkHLImF3vmmStTJxVPn92lVhW542O0DSaO+cmv/UM/AtoTzNX8gIHN
	 AizNPX7FdL93lcAq18ZCg9U2f+YxT/VJ1zSqGMU+myZ+dxV0yGDuUYcElBM8UgksXrY2N
	 u1uOiJFikb8Og1szmTmBCTN1hnX6L73Dz54pgxh1CmismcN/wdHQamzjDBA+AXX0xxNdE
	 ZFBCYcEy2kylb27VU/tV5hHPQKvTRVWqKC2qOlal+NfoDlo5okVvUDi7hK4UriVXQZf7s
	 4n6H4G41gtnbs0AzxJvkkQcJg0wMklbADs7ZGlOvZHfmhn994wuWTKjVLzH0pginoEQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793404657;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=4yzPnyew9QEMmru9umOoTOA+WxUeqUnPHxZ35Kso82c=;
	b=PPjLS1zxx5WMi5G149fFwFgjyWIe/NgWW1hEPLG/saaTMLqhLqwlEfs9FLWvV8YxDtH5
	 DJSo2Jqd0TJdjyen5HtTr6+RoEnx7SfbZd6pbMIpqJ1eK72TNMoUs8DnB24qOPFge3eQn
	 AlU+k3qyfN2EuwmvsOdFekespPIRcdzbxaxzzQvtJ+WG6gTJid2KfOd3TJzCFErF49TMa
	 hmLQakQ1Cd0+5T4dAWZjMi9N+G7I0S/KGZQ2Dk3Wis74oUgL5ovuGF43OABjqf7h95rkd
	 WdG3gQffWDfuYcbtMNm38twynZOONQfV7oLLpXp2CzyWx+//ajdT90K/7Iso8UkdlWA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 099801F000C1;
	Fri, 30 Oct 2026 23:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793404657;
	bh=4yzPnyew9QEMmru9umOoTOA+WxUeqUnPHxZ35Kso82c=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=F/enRrYW6Gphbzj2+AhfjOx37f6LaueGAYR+9r11qrnYnQfED+10jAM1VIktmq0Xu
	 N0vUXBhVz6W0oFDojXSj6KflWmSdKI6U5Te/lswv1cfOv9u1OS1wYvqOQL/4l/oQ8l
	 4VcYl3ReckM/SD+pTkDVVbTyJFgIUa6Dnnkte2QhbBHhCu754hL2Q9tMjDnXewyWZt
	 4gzC45norGCkx1aNIqBebzxxu9VitwtzWZk0sXjU0YZDRRrErRWwkf9hOapj4s/1io
	 YGITfIB+YvbTK6IEetYioYhDFkFqNTx3QadkCNo+VVmT7HWmLrsf4hXTS7j4NgzWDQ
	 ZjBO1QpRWQaiw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7DF0A442E0;
	Fri, 30 Oct 2026 23:57:36 +0000 (UTC)
From: Alessandro Petrozzelli via B4 Relay <devnull+apetrozzelli.gmail.com@kernel.org>
Date: Sat, 31 Oct 2026 00:57:36 +0100
Subject: [PATCH wireless-next] wifi: rt2x00: rt2800lib: fallback to default
 RF config when EEPROM_NIC_CONF0 is 0x0000
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261031-fix-rt2800-eeprom-nic-conf0-zero-v1-1-a118ee775fcb@gmail.com>
X-B4-Tracking: v=1; b=H4sIAO8u5WoC/yWNQQrCMBBFr1Jm7cAkQgheRVzUZKIjmpRJqsXSu
 xt1+fj891aorMIVDsMKyk+pUnIHsxsgXMd8YZTYGSxZZ2hvMMmC2qwnQuZJywOzBAwlJ8I3a8E
 xJO+TizE6gq6ZlPvnlzjCS5TvXCtmXhqc/nOdzzcO7ZuBbfsA3K2+U5MAAAA=
X-Change-ID: 20261031-fix-rt2800-eeprom-nic-conf0-zero-acf88f6ddd60
To: Stanislaw Gruszka <stf_xl@wp.pl>, 
 Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Alessandro Petrozzelli <apetrozzelli@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2104;
 i=apetrozzelli@gmail.com; h=from:subject:message-id;
 bh=pnGNieAmqP5yjIcLc5cLxsweQychWUXH4HwSO++3Q88=;
 b=owEBbQKS/ZANAwAKAeWL0WdUYlOYAcsmYgBq5S7vWn4nbiRcMvaqp7EBX+ss33CIwrO2HUe/T
 h2jFTDGzTuJAjMEAAEKAB0WIQRWwqGiWlKpzW9/svzli9FnVGJTmAUCauUu7wAKCRDli9FnVGJT
 mBdED/9zrG+b/kXudUEdQEzyWBsqeX5A8CLKQffEcyJbIXZ377ujdJSn+slF/duO2lK+t/ezl0j
 HJmq/mfblroGPK1Fi8oqVStcyb2oy0TjcjtCH6tcndFu8tEbHKoJauSfHaVaDxVBPI/cGGCvUxw
 7hRPKkGrZa1vN7+2lNItzTEFZ63ruXKyF8tQfhbJm2nH1DCObCeXpd0v9rQTRSbMMUN/wZz2yOZ
 pXi0kTkpFI3Yu6pAmizOpL2rd63CXnwCloYIhhvMjTknimowjSEptJzv2WK3NcV2ZmJ9Oy46sky
 a6VpYKId1GYhV5RG2zzcfLCRTdwjoJKX25iSehmXQGDUWJ1ZnLuNtwN+NJtYikEp03ifn6Lly3N
 8iF/NxIiGif5hXAZQffJMpQC/Ove1xY4G05nITD32LcsQcS1OBSTGvfvynDzwYyGwEaMy8ZMuSQ
 ylFFKvPX6FyBULTIVnBM4josv2srr/GUxHb19brtpQh1NmMgBHL/YmciHR2MPhODsthauZbAIb6
 nDMXNrnTlBG9Owo86IozepfohFYpOE2Zv36I9P+t6KG+pLRHwfGqovoMPhD5r9JITrxCX0ZOaxv
 ZeoaH5OadjfyFo77gkpiXIMKiqqC8FYVyovlUCf68Ybg1FUCqTKlL1TPa5NAPziwERqWaL4EFRt
 Ose45R/z35s7cOQ==
X-Developer-Key: i=apetrozzelli@gmail.com; a=openpgp;
 fpr=56C2A1A25A52A9CD6F7FB2FCE58BD16754625398
X-Endpoint-Received: by B4 Relay for apetrozzelli@gmail.com/default with
 auth_id=1366
X-Original-From: Alessandro Petrozzelli <apetrozzelli@gmail.com>
Reply-To: apetrozzelli@gmail.com
Content-Transfer-Encoding: 7bit

From: Alessandro Petrozzelli <apetrozzelli@gmail.com>

On some Ralink PCI/PCIe wireless cards, such as the AzureWave AW-NE766
(Ralink RT2790 / RT2872, PCI ID 1814:0781, subsystem 1814:2790) bundled
in the ASUS EeeBox PC B202, reading EEPROM_NIC_CONF0 returns 0x0000
instead of 0xffff when the EEPROM word is uninitialized.

Currently, rt2800_validate_eeprom() only triggers the default RF2820
(1T2R) configuration fallback when EEPROM_NIC_CONF0 is 0xffff, unlike
other EEPROM validation checks in the same function (such as LNA gain
fields) which already check for both 0x00 and 0xff. As a result,
EEPROM_NIC_CONF0_RF_TYPE remains 0x0000 and rt2800_init_eeprom() aborts
device initialization with -ENODEV:

  rt2x00_set_rt: Info - RT chipset 2872, rev 0200 detected
  rt2800_init_eeprom: Error - Invalid RF chipset 0x0000 detected
  rt2x00lib_probe_dev: Error - Failed to allocate device

Since 0x0000 is never a valid RF_TYPE (valid chipsets start at
RF2820 = 0x0001), extend the EEPROM_NIC_CONF0 fallback check to also
handle 0x0000 so that these cards initialize and operate properly.

Signed-off-by: Alessandro Petrozzelli <apetrozzelli@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 2e2e382b6..dda5ba2ad 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -11047,7 +11047,7 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 		return retval;
 
 	word = rt2800_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0);
-	if (word == 0xffff) {
+	if (word == 0xffff || word == 0x0000) {
 		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_RXPATH, 2);
 		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_TXPATH, 1);
 		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_RF_TYPE, RF2820);

---
base-commit: 2c50cd5d10e8723797f28c7978f1f61688e0c0d2
change-id: 20261031-fix-rt2800-eeprom-nic-conf0-zero-acf88f6ddd60

Best regards,
--  
Alessandro Petrozzelli <apetrozzelli@gmail.com>


