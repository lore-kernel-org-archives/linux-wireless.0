Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A95C43444
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 22:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E8472146F
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 22:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730079AbfAHWt2 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 17:49:28 -0500
Received: from mail-oln040092072048.outbound.protection.outlook.com ([40.92.72.48]:16480
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729328AbfAHWt2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 17:49:28 -0500
Received: from AM5EUR03FT023.eop-EUR03.prod.protection.outlook.com
 (10.152.16.56) by AM5EUR03HT054.eop-EUR03.prod.protection.outlook.com
 (10.152.17.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1382.18; Tue, 8 Jan
 2019 22:49:24 +0000
Received: from AM6PR07MB5608.eurprd07.prod.outlook.com (10.152.16.52) by
 AM5EUR03FT023.mail.protection.outlook.com (10.152.16.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18 via Frontend Transport; Tue, 8 Jan 2019 22:49:24 +0000
Received: from AM6PR07MB5608.eurprd07.prod.outlook.com
 ([fe80::68b1:73c3:455d:de2a]) by AM6PR07MB5608.eurprd07.prod.outlook.com
 ([fe80::68b1:73c3:455d:de2a%2]) with mapi id 15.20.1516.010; Tue, 8 Jan 2019
 22:49:23 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v4 1/4] rtl8723ae: Take the FW LPS mode handling out
Thread-Topic: [PATCH v4 1/4] rtl8723ae: Take the FW LPS mode handling out
Thread-Index: AQHUp6RmDijYI8GSZ0Oks0cNbTl2qw==
Date:   Tue, 8 Jan 2019 22:49:23 +0000
Message-ID: <AM6PR07MB5608D3B84CFB7EB8A84C2030E48A0@AM6PR07MB5608.eurprd07.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR0202CA0064.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::41) To AM6PR07MB5608.eurprd07.prod.outlook.com
 (2603:10a6:20b:6f::21)
x-incomingtopheadermarker: OriginalChecksum:F67BFE7AEFB5CC74BDFB262E29E6E8F2C2C3B75122C22919837D603BDF07F59D;UpperCasedChecksum:535BE324B378FD6DC25A0BBA81C0E3FF4C22054CF32F5CB5781F8B62F146B469;SizeAsReceived:8778;Count:62
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [zuLHMHZlQpP/+x4ZPW57g99Qfdsn9ohz]
x-microsoft-original-message-id: <b58c84d9-67f5-f990-dfbb-82dae7f9bd2f@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM5EUR03HT054;6:lhYrEg4+zKIMnSDWaoaa6hz6PZCI2bLQUnyofGcyg2WuxwEyGCAuBFTYj88z1+HdEnHhrasULLPGmyWsmAtyIVMXsFhvoS/xKGaayYyUyUg/6K049YAkPJutBYI7Zd+84IygDUTUesAA5CHG0xn8w3tlEDBI/I0qA0mRlZ8JbgdEvwiNVB6UF7g7cfh97EJLcO1wETi19dKU0U+la6/PAQl3qQPn58wbDZEXAzIkB57FAoSX0gqLZVO03iLCVlSlFAv7mXw7zlRwqXknkpq2x8LqyDb7qLil3/leYLB9OXc124XalaH6XaxP/omeLDRvDruLaImFvl695GO5nkc/YZPY8LC/7y7F8OxNNvai5gzle7tlcvmOKmPo0RFJHLFKkzgVRaqnRl5Js1uE/MRB4U8BvQjp9i9ZsKuEzw4ANcss3lzctQ9uf0Gf1EFtasH4DifiqwY3jZK3Bu16B4QOYQ==;5:+jttb/sdstd1EH2eSCQJsO8qE9QERp7L8NDnBB+D84wjw8yjLxfqYKVRiORBCvFneUhEEAd0Sr0bw6sVRV/g9UpF7+uNMai/RcHM3P8Qv1K8dTY3hB0wWH9rT0YJv7CYonU+ikhOopavI6uLgtk/0oOBwRFhBi+bjEw0oZCYaic=;7:htZOK6Wm38LnvkawIzELfVynqpH/kliVBJ1l/kvD6Fz+fRu+KpCzBa2U/F0IrsHoAJJUEhegAv7dVtwGHaushE1yLvKW7r1x8pDnF6ep4IjGNb945lp8LczQ+elfGzA9kGrcI0qpYULfDuy4XieROA==
x-incomingheadercount: 62
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:AM5EUR03HT054;
x-ms-traffictypediagnostic: AM5EUR03HT054:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:AM5EUR03HT054;BCL:0;PCL:0;RULEID:;SRVR:AM5EUR03HT054;
x-microsoft-antispam-message-info: qGgv7u71Tk8ay/H1hM3Ycc8ml2B1UTdYjx/+7bv9vm9UHSdJtym9sfDaJULtplBo
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <5C60488ADFDF104693C168DE625A0E9B@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: d0a313bb-3526-41e6-8648-08d675bb88a5
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2019 22:49:22.8475
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5EUR03HT054
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This appears to trigger a firmware bug and causes severe
problems with rtl8723ae PCI devices.

When the power save mode is activated for longer periods
of time the firmware stops to receive any packets.

This problem was exposed by commit 873ffe154ae0 ("rtlwifi:
Fix logic error in enter/exit power-save mode").

Previously the power save mode was only active rarely and
only for a short time so that the problem was not noticeable.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
v2: Adjust the defaults of swlps and fwlps module
parameters to match the firmware capabilities instead of removing
the whole code, so it can be easily re-activated once a firmware
update is available.

v3: Make the title fit in one line.

v4: Try to fix the line endings the message body.
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
index 07b82700d1..3103151 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
@@ -266,8 +266,8 @@ static bool is_fw_header(struct rtlwifi_firmware_header *hdr)
 static struct rtl_mod_params rtl8723e_mod_params = {
 	.sw_crypto = false,
 	.inactiveps = true,
-	.swctrl_lps = false,
-	.fwctrl_lps = true,
+	.swctrl_lps = true,
+	.fwctrl_lps = false,
 	.aspm_support = 1,
 	.debug_level = 0,
 	.debug_mask = 0,
@@ -395,8 +395,8 @@ static bool is_fw_header(struct rtlwifi_firmware_header *hdr)
 		   bool, 0444);
 MODULE_PARM_DESC(swenc, "Set to 1 for software crypto (default 0)\n");
 MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
-MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
-MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
+MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 1)\n");
+MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 0)\n");
 MODULE_PARM_DESC(msi, "Set to 1 to use MSI interrupts mode (default 0)\n");
 MODULE_PARM_DESC(aspm, "Set to 1 to enable ASPM (default 1)\n");
 MODULE_PARM_DESC(debug_level, "Set debug level (0-5) (default 0)");
-- 
1.9.1
