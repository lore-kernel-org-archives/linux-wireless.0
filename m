Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5379C43444
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 22:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB4032146F
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 22:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730152AbfAHWtq convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 17:49:46 -0500
Received: from mail-oln040092070052.outbound.protection.outlook.com ([40.92.70.52]:24064
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729328AbfAHWtp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 17:49:45 -0500
Received: from AM5EUR03FT023.eop-EUR03.prod.protection.outlook.com
 (10.152.16.51) by AM5EUR03HT198.eop-EUR03.prod.protection.outlook.com
 (10.152.17.133) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1382.18; Tue, 8 Jan
 2019 22:49:42 +0000
Received: from AM6PR07MB5608.eurprd07.prod.outlook.com (10.152.16.52) by
 AM5EUR03FT023.mail.protection.outlook.com (10.152.16.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18 via Frontend Transport; Tue, 8 Jan 2019 22:49:41 +0000
Received: from AM6PR07MB5608.eurprd07.prod.outlook.com
 ([fe80::68b1:73c3:455d:de2a]) by AM6PR07MB5608.eurprd07.prod.outlook.com
 ([fe80::68b1:73c3:455d:de2a%2]) with mapi id 15.20.1516.010; Tue, 8 Jan 2019
 22:49:40 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v4 2/4] rtl8723ae: Dont use old data for input gain control
Thread-Topic: [PATCH v4 2/4] rtl8723ae: Dont use old data for input gain
 control
Thread-Index: AQHUp6RwBjS7FcN11Uyxbem1jV10Cg==
Date:   Tue, 8 Jan 2019 22:49:40 +0000
Message-ID: <AM6PR07MB560811DC708B66768CF754A1E48A0@AM6PR07MB5608.eurprd07.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR0202CA0062.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::39) To AM6PR07MB5608.eurprd07.prod.outlook.com
 (2603:10a6:20b:6f::21)
x-incomingtopheadermarker: OriginalChecksum:7664C94729DFAE6804AEA1EE688F3F4DF90BBBB221617C73812CC23EA15D5FFF;UpperCasedChecksum:2CA964F87CC7B55747C33EF93495F77CC68361A9D079869CDC28EE9EC6A6BBD3;SizeAsReceived:8797;Count:62
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [A6faOYTlYMoRLurXZoxlc/80yvo++FH9]
x-microsoft-original-message-id: <133010c2-768e-4285-1d59-21a0690596a1@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM5EUR03HT198;6:Yu7uWedzVQ3OnEb5o0kdNDzDyHtlR+O1RLaUrBTmtDZg7WNHF2IXYUwWmsoma/nLNXjb6KTkJHY+a5uZnZ7jJ3l0oxHAT+MHbSOwCfxQuy5NNUVVok7Pacb2kpWLGJfSCgVATtGoZJP4YPVrpLTA022FhAm5i4ojabTjLPzMdWbu1j/K9aDYREgl0SZzWjjuKrSH2FWx8AVLu5zolYnhKCg47cuxHmDWXnzZ2GUHbzOMZW3pgx1+1s6vExuPzR5pi9u8kqpnloymJTQhDBnzR+7+JKi9XRcqwFGqqWP5OCE33jwU17FdQK6fqk1esHZ1roGCKrPA5dimiBUGtOHm3zvrPw6tLGuihTkbLFRygSkV3EanDXQJ4PZpHiFJvU5NOBbAVg2GdNKuo9azRVRFetYryN3kG4+d7zl7uQ6DoOwdeDthGZh3aRvLKUZD86vUthJtY3S1AudlzLZo/VUu+Q==;5:Qi0ResKwjVwVRP9GO6AoIxEfZeBN/xJVApjJ6wi9HitxMhEwflF9FeQWhaFww0/gozvC8mCbc3STKMcnSHwE1zR73sELO04h/fl6gXYAX7ki248dU7hmvtAIQAi5EkPQDGfDDQ3gk8uWzDEGGEWWA/pndrpweGDHtFewei7kjhQ=;7:GaByRj6U1M0FQ/FTiHZDYgtiNhQ6eVQ6p9IBoDLnVepCRBjGPzw/b25eMstZRlUzzjqU5bELiAPwWCCm0/0spyEHrxKmX9Ro3xhyrKzwTscgW1iu2X4+WYn0vQmr1icf+Z4AwucdDy1OJhjTgxf1eQ==
x-incomingheadercount: 62
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(20181119063)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:AM5EUR03HT198;
x-ms-traffictypediagnostic: AM5EUR03HT198:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:AM5EUR03HT198;BCL:0;PCL:0;RULEID:;SRVR:AM5EUR03HT198;
x-microsoft-antispam-message-info: rHKh+BePZhIC3IbhBA+b2pMTBMlzAJ1xY0wAO5TkEujJSZIZiYHTIeqXJ0cDPvMx
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <18C2F3CD9A12314C94152D4937AB6BAA@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d13f912-1279-4133-2202-08d675bb929a
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2019 22:49:39.5520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5EUR03HT198
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When no beacon was received, the value in dm.undec_sm_pwdb is most
likely out of date and should not be used to adjust the input path.
Assume instead that the signal level is low.

Fix the state machine in rtl8723e_dm_cck_packet_detection_thresh
which did not clear pre_cck_fa_state when changing cur_cck_pd_state
from CCK_PD_STAGE_LOWRSSI/CCK_FA_STAGE_LOW to CCK_PD_STAGE_HIGHRSSI
and back again to CCK_PD_STAGE_LOWRSSI/CCK_FA_STAGE_LOW, the register
RCCK0_CCA not written to 0x83 on the second change.

Explicitly initialize pre_cck_fa_state/cur_cck_fa_state in
rtl_dm_diginit.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
v2: Improved patch description.

v3: Make the title fit in one line.

v4: Try to fix the line endings the message body.
---
 drivers/net/wireless/realtek/rtlwifi/core.c         | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 4bf7967..ce23339 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -1957,5 +1957,7 @@ void rtl_dm_diginit(struct ieee80211_hw *hw, u32 cur_igvalue)
 	dm_digtable->bt30_cur_igi = 0x32;
 	dm_digtable->pre_cck_pd_state = CCK_PD_STAGE_MAX;
 	dm_digtable->cur_cck_pd_state = CCK_PD_STAGE_LOWRSSI;
+	dm_digtable->pre_cck_fa_state = 0;
+	dm_digtable->cur_cck_fa_state = 0;
 }
 EXPORT_SYMBOL(rtl_dm_diginit);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c
index 42a6fba..902b944 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c
@@ -151,8 +151,14 @@ static u8 rtl8723e_dm_initial_gain_min_pwdb(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct dig_t *dm_digtable = &rtlpriv->dm_digtable;
+	struct rtl_mac *mac = rtl_mac(rtlpriv);
 	long rssi_val_min = 0;
 
+	if (mac->link_state == MAC80211_LINKED &&
+	    mac->opmode == NL80211_IFTYPE_STATION &&
+	    rtlpriv->link_info.bcn_rx_inperiod == 0)
+		return 0;
+
 	if ((dm_digtable->curmultista_cstate == DIG_MULTISTA_CONNECT) &&
 	    (dm_digtable->cursta_cstate == DIG_STA_CONNECT)) {
 		if (rtlpriv->dm.entry_min_undec_sm_pwdb != 0)
@@ -417,6 +423,8 @@ static void rtl8723e_dm_cck_packet_detection_thresh(struct ieee80211_hw *hw)
 		} else {
 			rtl_set_bbreg(hw, RCCK0_CCA, MASKBYTE2, 0xcd);
 			rtl_set_bbreg(hw, RCCK0_SYSTEM, MASKBYTE1, 0x47);
+			dm_digtable->pre_cck_fa_state = 0;
+			dm_digtable->cur_cck_fa_state = 0;
 
 		}
 		dm_digtable->pre_cck_pd_state = dm_digtable->cur_cck_pd_state;
-- 
1.9.1
