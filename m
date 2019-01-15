Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D64DC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 14:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4089820657
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 14:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbfAOOCN convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 09:02:13 -0500
Received: from mail-oln040092069071.outbound.protection.outlook.com ([40.92.69.71]:6311
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728812AbfAOOCN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 09:02:13 -0500
Received: from VE1EUR02FT036.eop-EUR02.prod.protection.outlook.com
 (10.152.12.51) by VE1EUR02HT122.eop-EUR02.prod.protection.outlook.com
 (10.152.13.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1537.18; Tue, 15 Jan
 2019 14:01:29 +0000
Received: from AM0PR07MB3874.eurprd07.prod.outlook.com (10.152.12.52) by
 VE1EUR02FT036.mail.protection.outlook.com (10.152.13.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1471.13 via Frontend Transport; Tue, 15 Jan 2019 14:01:29 +0000
Received: from AM0PR07MB3874.eurprd07.prod.outlook.com
 ([fe80::890e:c9ab:41b6:5f70]) by AM0PR07MB3874.eurprd07.prod.outlook.com
 ([fe80::890e:c9ab:41b6:5f70%2]) with mapi id 15.20.1537.018; Tue, 15 Jan 2019
 14:01:29 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] rt61pci: Work around a firmware bug with shared keys
Thread-Topic: [PATCH] rt61pci: Work around a firmware bug with shared keys
Thread-Index: AQHUrNrQpXGNfGU1T0qAvtjOCh7FvQ==
Date:   Tue, 15 Jan 2019 14:01:29 +0000
Message-ID: <AM0PR07MB3874E8F6ADD41C4E1BCBE43EE4810@AM0PR07MB3874.eurprd07.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0701CA0006.eurprd07.prod.outlook.com
 (2603:10a6:203:51::16) To AM0PR07MB3874.eurprd07.prod.outlook.com
 (2603:10a6:208:45::26)
x-incomingtopheadermarker: OriginalChecksum:36F56E63DAB9D81A219F58AE846C90EF6AB5715B9B16CDE0D422DBC8698EECE9;UpperCasedChecksum:E9352D3B9AAB1A3BE3D9476744027AE383D029078F6ACDE748020C4BFC967EF5;SizeAsReceived:8774;Count:62
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [fcJlskq3geKxWOml27fZ4gKDVwXaSf1x]
x-microsoft-original-message-id: <9bebc5fb-57fb-964f-4780-f4d43a6e114b@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;VE1EUR02HT122;6:upbIDOM/Xi9Yeu+Fjv+I1ix5IF6Y6jquasZTFP1uJDSd5nFH59S2ryz51cO8shL1RZByMrOUA6+vKROVlSr3Gs61Zj8c0EH69oyuxqsf2s3504YVlVFQlF3cBlh8dNwPJtpDOOAvp/kIa0E5eG/lLhVZ4c0hQmu9CiA7NGJBhAzGGkBAWuweWqSo+doZXpPAEILAFFzsKvc9u5Ty14QWFcZyPKtCxr5XAsqwWW7vk6U0Ib2vwQjgow5DW+X9d96PhetP0WiMbU3RpTsE5q0i8a8Krjm13RZZlGPzR6DXIyI7L8tyPvIVx04H35TBN74rQyq/LIlkdSFUHp5xSMkDE/+5WH0iWbcOXD3S3UuWyMOp7crkhwryBdxS+r/1mF1ahInx81Y+3xRrIrBpnqtcS/XkCXc3ZM3toHz4WjS/IMfTwPrj6RwE65Oi/XmBweC4MwBRx2aCoQtfZLWr66o81w==;5:f3qDMP5lzmEZHVBHG8/7LITLzThkKY7gVVmf7kIEqoPMalCl+PNasO3Azhk99+PR1vTZEZN4KBcS/t4W/FOkjcmhElioiMrpbmDctezMhi6/XN1W9twAoBJ0WBsX5h+VeftaN9EkthN7ivM/alzIgYBl8CPkuBO38yDczL8OdO7QILzwKpMKT9NzxGU4+l05ZAkxjiUA+YEg6S9GniIkoQ==;7:umIn5ScH/zOOSkgfmdkuS8fW9TWYQk+2elLSsQf5Hfvrl0Nh7U0/+zXoYiMShWG0OOmqSqpH50ZkaH0WX3XYaPNMCf3Ej5PNiLjxOjlurR6Kx9je1fvLa7To0oqJbuxpMba1GnvaYNUbIjsyjcNOHQ==
x-incomingheadercount: 62
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:VE1EUR02HT122;
x-ms-traffictypediagnostic: VE1EUR02HT122:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:VE1EUR02HT122;BCL:0;PCL:0;RULEID:;SRVR:VE1EUR02HT122;
x-microsoft-antispam-message-info: x3kP0B39GvU1iMxulV+IyYP1HPlcmLNuFM6f4aj2gNjExaUFgCi/ND2NNq6a7uO/
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <05F44D69B5EAF440AD117FD2C90D2487@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: 197b0f74-6c87-48e1-2e9b-08d67af1f27a
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2019 14:01:28.9710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1EUR02HT122
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Apparently the rt2x61 firmware fails temporarily to decode
broadcast packets if the shared keys are not assigned
in the "correct" sequence. At the same time unicast
packets work fine, since they are encrypted with the
pairwise key.

At least with WPA2 CCMP mode the shared keys are
set in the following sequence: keyidx=1, 2, 1, 2.
After a while only keyidx 2 gets decrypted, and
keyidx 1 is ignored, probably because there is never
a keyidx 3.

Symptoms are arping -b works for 10 minutes, since
keyidx=2 is used for broadcast, and then it stops
working for 10 minutes, because keyidx=1 is used.
That failure mode repeats forever.

Note, the firmware does not even know which keyidx
corresponds to which hw_key_idx so the firmware is
trying to be smarter than the driver, which is bound
to fail.

As workaround the function rt61pci_config_shared_key
requests software decryption of the shared keys,
by returning EOPNOTSUPP. However, pairwise keys are
still handled by hardware which works just fine.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
 drivers/net/wireless/ralink/rt2x00/rt61pci.c | 93 ++--------------------------
 1 file changed, 4 insertions(+), 89 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
index 4c5de8f..52b9fc4 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
@@ -321,97 +321,12 @@ static int rt61pci_config_shared_key(struct rt2x00_dev *rt2x00dev,
 				     struct rt2x00lib_crypto *crypto,
 				     struct ieee80211_key_conf *key)
 {
-	struct hw_key_entry key_entry;
-	struct rt2x00_field32 field;
-	u32 mask;
-	u32 reg;
-
-	if (crypto->cmd == SET_KEY) {
-		/*
-		 * rt2x00lib can't determine the correct free
-		 * key_idx for shared keys. We have 1 register
-		 * with key valid bits. The goal is simple, read
-		 * the register, if that is full we have no slots
-		 * left.
-		 * Note that each BSS is allowed to have up to 4
-		 * shared keys, so put a mask over the allowed
-		 * entries.
-		 */
-		mask = (0xf << crypto->bssidx);
-
-		reg = rt2x00mmio_register_read(rt2x00dev, SEC_CSR0);
-		reg &= mask;
-
-		if (reg && reg == mask)
-			return -ENOSPC;
-
-		key->hw_key_idx += reg ? ffz(reg) : 0;
-
-		/*
-		 * Upload key to hardware
-		 */
-		memcpy(key_entry.key, crypto->key,
-		       sizeof(key_entry.key));
-		memcpy(key_entry.tx_mic, crypto->tx_mic,
-		       sizeof(key_entry.tx_mic));
-		memcpy(key_entry.rx_mic, crypto->rx_mic,
-		       sizeof(key_entry.rx_mic));
-
-		reg = SHARED_KEY_ENTRY(key->hw_key_idx);
-		rt2x00mmio_register_multiwrite(rt2x00dev, reg,
-					       &key_entry, sizeof(key_entry));
-
-		/*
-		 * The cipher types are stored over 2 registers.
-		 * bssidx 0 and 1 keys are stored in SEC_CSR1 and
-		 * bssidx 1 and 2 keys are stored in SEC_CSR5.
-		 * Using the correct defines correctly will cause overhead,
-		 * so just calculate the correct offset.
-		 */
-		if (key->hw_key_idx < 8) {
-			field.bit_offset = (3 * key->hw_key_idx);
-			field.bit_mask = 0x7 << field.bit_offset;
-
-			reg = rt2x00mmio_register_read(rt2x00dev, SEC_CSR1);
-			rt2x00_set_field32(&reg, field, crypto->cipher);
-			rt2x00mmio_register_write(rt2x00dev, SEC_CSR1, reg);
-		} else {
-			field.bit_offset = (3 * (key->hw_key_idx - 8));
-			field.bit_mask = 0x7 << field.bit_offset;
-
-			reg = rt2x00mmio_register_read(rt2x00dev, SEC_CSR5);
-			rt2x00_set_field32(&reg, field, crypto->cipher);
-			rt2x00mmio_register_write(rt2x00dev, SEC_CSR5, reg);
-		}
-
-		/*
-		 * The driver does not support the IV/EIV generation
-		 * in hardware. However it doesn't support the IV/EIV
-		 * inside the ieee80211 frame either, but requires it
-		 * to be provided separately for the descriptor.
-		 * rt2x00lib will cut the IV/EIV data out of all frames
-		 * given to us by mac80211, but we must tell mac80211
-		 * to generate the IV/EIV data.
-		 */
-		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-	}
-
 	/*
-	 * SEC_CSR0 contains only single-bit fields to indicate
-	 * a particular key is valid. Because using the FIELD32()
-	 * defines directly will cause a lot of overhead, we use
-	 * a calculation to determine the correct bit directly.
+	 * Let the software handle the shared keys,
+	 * since the hardware decryption does not work reliably,
+	 * because the firmware does not know the key's keyidx.
 	 */
-	mask = 1 << key->hw_key_idx;
-
-	reg = rt2x00mmio_register_read(rt2x00dev, SEC_CSR0);
-	if (crypto->cmd == SET_KEY)
-		reg |= mask;
-	else if (crypto->cmd == DISABLE_KEY)
-		reg &= ~mask;
-	rt2x00mmio_register_write(rt2x00dev, SEC_CSR0, reg);
-
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static int rt61pci_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
-- 
1.9.1
