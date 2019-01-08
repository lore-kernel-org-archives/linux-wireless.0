Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 704CCC43444
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 22:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4365A2146F
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 22:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729978AbfAHWtQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 17:49:16 -0500
Received: from mail-oln040092070099.outbound.protection.outlook.com ([40.92.70.99]:54912
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729328AbfAHWtP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 17:49:15 -0500
Received: from AM5EUR03FT023.eop-EUR03.prod.protection.outlook.com
 (10.152.16.58) by AM5EUR03HT048.eop-EUR03.prod.protection.outlook.com
 (10.152.16.228) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1382.18; Tue, 8 Jan
 2019 22:49:12 +0000
Received: from AM6PR07MB5608.eurprd07.prod.outlook.com (10.152.16.52) by
 AM5EUR03FT023.mail.protection.outlook.com (10.152.16.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18 via Frontend Transport; Tue, 8 Jan 2019 22:49:12 +0000
Received: from AM6PR07MB5608.eurprd07.prod.outlook.com
 ([fe80::68b1:73c3:455d:de2a]) by AM6PR07MB5608.eurprd07.prod.outlook.com
 ([fe80::68b1:73c3:455d:de2a%2]) with mapi id 15.20.1516.010; Tue, 8 Jan 2019
 22:49:12 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v4 0/4] rtlwifi: Fix issues with rtl8723ae
Thread-Topic: [PATCH v4 0/4] rtlwifi: Fix issues with rtl8723ae
Thread-Index: AQHUp6Rfr9Iz7uv1rEeuaROPn9OP4w==
Date:   Tue, 8 Jan 2019 22:49:12 +0000
Message-ID: <AM6PR07MB560811200F9507F8DB95488AE48A0@AM6PR07MB5608.eurprd07.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR0202CA0040.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::17) To AM6PR07MB5608.eurprd07.prod.outlook.com
 (2603:10a6:20b:6f::21)
x-incomingtopheadermarker: OriginalChecksum:08B8F3932A87FA2E83AE8D3E68949B5CA46A21BA888889CFB5CCA3762ADE31D6;UpperCasedChecksum:EE8879DF503B84D4ABBB3CF69FCE5A1C5B843BA14E31F29C8A9761C24AD216B3;SizeAsReceived:8760;Count:62
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [Vxpt+ff+8sETw2ZJqIETryNj6N+qNAiO]
x-microsoft-original-message-id: <84b88c8c-5ebc-cfcd-2cc5-43ece0f95327@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM5EUR03HT048;6:+76MGc3rRM7zaG5KNBZkxXygRQ6xqpdxGfERi4h7g6qGKDGi45qrLNC3HEoaNlMVwxIw3UiRUDPUruxtL2yvCA0pJnBMVIYmPEjE8nO7NAdq3T9yWWxuxJYBDjF/pNLQzV5rypVQUYkKjcpIiNrKZwb+d+1MWiBgR1SkjdtmQutRf8e97HVz462rkqEqM7gn5ayX7kvQimzh3g06aYMbB3kct6hiC8HeUl1QTjrP172yy1HZstJnbNmPIzy61Us3CA6x5vhe4vzUATfoq0k2EkvJUIF/Hv0dzrgT58Y2ohi6o6W4APv+8D4JhffY/mphYMCC2WhrCMLPFBCyNHOLk+Ob2cC9T9sN9etfsW9DjTBMJHvL0bDI54xArPveCgUyZ7GZxcAwWjrFbMWbpugGeOYMMwU3RuSYquuTwGOkaLIlVqpkjmlNp65Ru6jjGi8au4igaye4Qc9cCBdPy9AMVA==;5:rCVjQ3nPnGFzYnVaF17vINXxiKZ9O0HZFSpg1XePgwIA39Oph0XnYtj3eVfQCC/MSqOtyFow0dRPSrktdnTFGjCn+n9kScIo1SbznpJJAg+KcS/qMjzxGirVKkrNIOHg8AIrCKZHewMnz8SMZngkh+BSQwNjwJnaOTeC4+rtO/M=;7:MiYlLkQCMx9+/yDdxGEKkGaGXgypGkFB//GV5dHSvIcwJ/j/dJjJY0Rwj7WXLEHAffOY6uxSLtKK7JhbgSf2e4xtegDV08Qti1sjF0U3TnWseVlqu2uAYYEOQCMaOtEDSa0W2gB76tKXqKK/kcdYfw==
x-incomingheadercount: 62
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:AM5EUR03HT048;
x-ms-traffictypediagnostic: AM5EUR03HT048:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:AM5EUR03HT048;BCL:0;PCL:0;RULEID:;SRVR:AM5EUR03HT048;
x-microsoft-antispam-message-info: YA5/tAzlxLtGU9dsaEt222mx0Ez9pEcit/4/Vape/oC7xGxMdG8zJ3CIYOO+AyDn
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <961E1058F82B4A42B29226D76C372F6E@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: a3d94d6f-31d9-4d12-c5c5-08d675bb8211
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2019 22:49:11.7988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5EUR03HT048
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently the rtl8723ae driver is broken (since v4.7).

Connection to AP is lost very often, especially when
the signal level is not very good.

The main issue is the power save mode is basically
not working, and seems to trigger a firmware bug.
So I had to take out the FW LPS mode handling.

While debugging the driver I found a couple related issues,
for instance that the signal level in dm.undec_sm_pwdb
is no longer accurate (may be even much too high) when no more
packets are received, and it increases the likelihood to receive
something if the input gain is set to maximum.

The patch was tested with the rtl8723ae PCI card in my laptop
against a FRITZ!Box 7590 AP -- the WiFi connection works now
very reliable for me.

ChangeLog:

v2: Adjusts the defaults of swlps and fwlps module
parameters to match the firmware capabilities instead of removing
the whole code, so it can be easily re-activated once a firmware
update is available.

v3: Make the title of each patch fit in one line.

v4: Try to fix the line endings the message body.
    Which is an exchange server issue.
    The patch does not change at all.

Bernd Edlinger (4):
  rtl8723ae: Take the FW LPS mode handling out
  rtl8723ae: Dont use old data for input gain control
  rtl8723ae: Re-introduce the adaptive rate control
  rtlwifi: Don't clear num_rx_inperiod too early 

 drivers/net/wireless/realtek/rtlwifi/base.c        |  4 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |  2 +
 .../net/wireless/realtek/rtlwifi/rtl8723ae/dm.c    | 95 +++++++++++++++++++++-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/sw.c    |  8 +-
 4 files changed, 101 insertions(+), 8 deletions(-)

-- 
1.9.1
