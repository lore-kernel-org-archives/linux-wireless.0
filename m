Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03296C43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 22:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD33E214C6
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 22:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730281AbfAHWuO convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 17:50:14 -0500
Received: from mail-oln040092072090.outbound.protection.outlook.com ([40.92.72.90]:6338
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729328AbfAHWuO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 17:50:14 -0500
Received: from AM5EUR03FT023.eop-EUR03.prod.protection.outlook.com
 (10.152.16.57) by AM5EUR03HT201.eop-EUR03.prod.protection.outlook.com
 (10.152.17.252) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1382.18; Tue, 8 Jan
 2019 22:50:11 +0000
Received: from AM6PR07MB5608.eurprd07.prod.outlook.com (10.152.16.52) by
 AM5EUR03FT023.mail.protection.outlook.com (10.152.16.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18 via Frontend Transport; Tue, 8 Jan 2019 22:50:11 +0000
Received: from AM6PR07MB5608.eurprd07.prod.outlook.com
 ([fe80::68b1:73c3:455d:de2a]) by AM6PR07MB5608.eurprd07.prod.outlook.com
 ([fe80::68b1:73c3:455d:de2a%2]) with mapi id 15.20.1516.010; Tue, 8 Jan 2019
 22:50:10 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v4 4/4] rtlwifi: Don't clear num_rx_inperiod too early
Thread-Topic: [PATCH v4 4/4] rtlwifi: Don't clear num_rx_inperiod too early
Thread-Index: AQHUp6SC8r1w83ZuyUSZa/fZVTIQLw==
Date:   Tue, 8 Jan 2019 22:50:09 +0000
Message-ID: <AM6PR07MB56088926A38CC1188EBCB56EE48A0@AM6PR07MB5608.eurprd07.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR0202CA0044.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::21) To AM6PR07MB5608.eurprd07.prod.outlook.com
 (2603:10a6:20b:6f::21)
x-incomingtopheadermarker: OriginalChecksum:F87B65D8440940669ABD98019F1F40C3C9AA84B70A8C575266543B5B9B8D58AD;UpperCasedChecksum:7BF64386373019B204CA359039A02BCAA850BAC3FE8A0156804CB61DBF796372;SizeAsReceived:8799;Count:62
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [YdZb3YgA7+wtqWGa8Ch/4KNZo50jDcQR]
x-microsoft-original-message-id: <1e89861e-c921-9100-7d5a-224ed33207ca@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM5EUR03HT201;6:3Gn7zrFaNX5gCfLYDHPyzA9zDENvf8GPTHOfbBpDyx7wvt/zXXpSuHVIIBlPdpkC+9WQpYQWuJTfIR+ohUfage3pCh5rCvJqr21/GlAd8XXYBEzxEjz0Y/z/xuzkl4YKItgbCSUrXi1uB1RN91X3JRUg+xB6RA5S2xh2n4eN5cYuQ0nmCL3OpLKeRlghOV8R1fb0B6X2q0jFAz9Hx+3fq9F7DTS6JxowkqnVL1iI861KINrPYDJN9T+fJIAtXdpdQCbNhFbu586ZHWeT1pgE088qDa//gTDq1cdK0f/7Cs4ongyFa1OfRG3O7RWPCVxF4iOgefnBWSZgXrSYQ7J79WG3JG1p3acrpi3WnrsOg6ypF6jF6eoq9tALkyzpRGTULx2OZMy6N5yj7I/+MbJSjOhjTkWRx68HUGyfhXKU0b8NlekXfnYrN1t6nUaY5mwtoK2LMtQu5/HjQTKUKxWEpg==;5:mvQcGi4t70sojHyiF5Kl+Oze4IJQtZbbx5E0ns+Ejuti32TJiMz2snsMytB8E0G0Wi3+8BXT7gfHJlvMTrB8QaPKBIpoyFp3ktA26Bb7O2oergqoiELad63JijGtIi6r0feJyyh1I/6FavlJGDCIYOSLYUTUKNlrwyDPUcL07BQ=;7:p6/Y6SAECtam19WXbFdXzyKf5aYGAbUU6QIUcRT6pxzb2Soz0PqROzyB4UuJMojhYBspc37g6OctdmKXdmRsx5r99mTY4ETSBcwhvcLJbraPvQvXQ3FPl8K6slFJsRF+cPnMw+hB9efbQoTxG8do/A==
x-incomingheadercount: 62
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(20181119063)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:AM5EUR03HT201;
x-ms-traffictypediagnostic: AM5EUR03HT201:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:AM5EUR03HT201;BCL:0;PCL:0;RULEID:;SRVR:AM5EUR03HT201;
x-microsoft-antispam-message-info: U3ITlpjxp2S+yx7sBu4VgJ6Zf0V4e96entPbPZIQObvVXKKgCKvRcF3kayxfnAkC
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <710DD038E4CCE24DB9CC5DE021EDF983@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aedd9d2-d39e-4f44-498f-08d675bba465
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2019 22:50:09.3777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5EUR03HT201
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch moves the clearing of rtlpriv->link_info.num_rx_inperiod in
rtl_watchdog_wq_callback a few lines down.

This is necessary since it is still used in the "AP off" detection
code block. Moved clearing of rtlpriv->link_info.num_rx_inperiod
as well for consistency.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
v2: Improved patch description.

v3: Make the title fit in one line.

v4: Try to fix the line endings the message body.
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index ef9b502..7aa68fe 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -2172,8 +2172,6 @@ void rtl_watchdog_wq_callback(void *data)
 		;
 	}
 
-	rtlpriv->link_info.num_rx_inperiod = 0;
-	rtlpriv->link_info.num_tx_inperiod = 0;
 	for (tid = 0; tid <= 7; tid++)
 		rtlpriv->link_info.tidtx_inperiod[tid] = 0;
 
@@ -2236,6 +2234,8 @@ void rtl_watchdog_wq_callback(void *data)
 			rtlpriv->btcoexist.btc_info.in_4way = false;
 	}
 
+	rtlpriv->link_info.num_rx_inperiod = 0;
+	rtlpriv->link_info.num_tx_inperiod = 0;
 	rtlpriv->link_info.bcn_rx_inperiod = 0;
 
 	/* <6> scan list */
-- 
1.9.1
