Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0846C43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 22:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68AF22146F
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 22:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730196AbfAHWtz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 17:49:55 -0500
Received: from mail-oln040092071059.outbound.protection.outlook.com ([40.92.71.59]:18825
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729328AbfAHWtz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 17:49:55 -0500
Received: from AM5EUR03FT023.eop-EUR03.prod.protection.outlook.com
 (10.152.16.51) by AM5EUR03HT211.eop-EUR03.prod.protection.outlook.com
 (10.152.17.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1382.18; Tue, 8 Jan
 2019 22:49:52 +0000
Received: from AM6PR07MB5608.eurprd07.prod.outlook.com (10.152.16.52) by
 AM5EUR03FT023.mail.protection.outlook.com (10.152.16.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18 via Frontend Transport; Tue, 8 Jan 2019 22:49:52 +0000
Received: from AM6PR07MB5608.eurprd07.prod.outlook.com
 ([fe80::68b1:73c3:455d:de2a]) by AM6PR07MB5608.eurprd07.prod.outlook.com
 ([fe80::68b1:73c3:455d:de2a%2]) with mapi id 15.20.1516.010; Tue, 8 Jan 2019
 22:49:52 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v4 3/4] rtl8723ae: Re-introduce the adaptive rate control
Thread-Topic: [PATCH v4 3/4] rtl8723ae: Re-introduce the adaptive rate control
Thread-Index: AQHUp6R3Y/XmF/ONQ0CG44v3TaPe1w==
Date:   Tue, 8 Jan 2019 22:49:52 +0000
Message-ID: <AM6PR07MB5608240FFF88B2221B4DB9CFE48A0@AM6PR07MB5608.eurprd07.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR0202CA0044.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::21) To AM6PR07MB5608.eurprd07.prod.outlook.com
 (2603:10a6:20b:6f::21)
x-incomingtopheadermarker: OriginalChecksum:4E55CAB58F6D7CDA5E32B168F651DA4FA2BCFED895A91C5DC2469B0C0EB3DB0D;UpperCasedChecksum:B2100A657C5135AE699B4D8E45015B858D364B6C524E95751C51FEA120B4B536;SizeAsReceived:8791;Count:62
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [P4AXnPoVxkKelXa5cvig6LQX5GiR82G7]
x-microsoft-original-message-id: <71a0571e-f313-59a6-5c1d-aab2dbdfa5ea@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM5EUR03HT211;6:7BGqp79Wmdq46JU1Cb5QZcACtSwp3sq5yEcR1l26YKvcMxJaOK7xiUcv0fzk9NKg/l/G1DVVm4syDyTTMEbDbI8nJyN5dJSu2RWjUhOBayJ75piwfSYR5TATHBdkyFkFqbVNv7o+s+LbwEPrY1zdlspc+doQidz4iSlln+SwJw80d3djKn7DoGOqHicbT4DRwjltdvvQ4u/wgqoB3ZidBhRhFmr0xpKtDljU8mJL36Tdl6G8JSgGQeLP96MFIvrmMXXlOJv4Hi8GmtoZVWBfay9XrdRONUA5ZAbn7xpje0xWzl4SFMxds7jybAQwnY5sr0+kQtdMjEKAlJ3QkrogD8/Bh6sYlYaZu6kVJnMAo537ytsGnFGTni22Ti33I/EDf21grwN7T9AugWULxACN/xuRpq7p3EB3ePvHdT0Szx7r3uQZcEnUlkpMmw/aZqWWcFGonvCw0kQrHy309g2WJA==;5:BVAq4vReIdT4ipQMmOmTp0AVEdqLT0B4IfZpbDYSU9/VGedqPNrVRag15wAChLrIAtfGeMrtZVKE8hc8t/6I63gkEwJgxJVKGgotPay13nrdmMM7p6TVEMijomtgmMYJpn/qESMfWWWWMeFhbV+MJeEtKvsXTyjQVj+INFM+nfg=;7:0C6I4AUZS0/l2pHA4Brkdq1BBv2s7hI+e/Ka9H7o7xlZRmsYww0CcGhyjOFEvOnR6DnVYhjpAU0DZR2NdqvPN4+Je8eb1uR6qn7myKDvmg0XCnkEmoGcZW+q4ewuoEOHecZqE4w6DqL2AldIQdg4BQ==
x-incomingheadercount: 62
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:AM5EUR03HT211;
x-ms-traffictypediagnostic: AM5EUR03HT211:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:AM5EUR03HT211;BCL:0;PCL:0;RULEID:;SRVR:AM5EUR03HT211;
x-microsoft-antispam-message-info: h5ieEx42S66JZg437qPSuECfFCKlwAmQ2OTfDjOc4292CT6HcSzm3CGR/b/uJpI2
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <4D1EEA57CE62C24BAAB7B3F36E4E8568@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: d12b7fbb-b95e-4ce2-8574-08d675bb99e2
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2019 22:49:51.7185
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5EUR03HT211
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This re-introduces the function rtl8723e_dm_refresh_rate_adaptive_mask.

This function was present in a previous version of the code base,
it works just fine for me -- as long as it is not using stale data.

Unlike the original version of this function it avoids using
dm.undec_sm_pwdb when no beacon was received.

Fixed a style nit in rtl8723e_dm_init_rate_adaptive_mask.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
v2: Improve patch description.

v3: Improve patch description, mention that dm.undec_sm_pwdb
is not used when no beacon received. 
Make the title fit in one line.

v4: Try to fix the line endings the message body.
---
 .../net/wireless/realtek/rtlwifi/rtl8723ae/dm.c    | 87 +++++++++++++++++++++-
 1 file changed, 85 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c
index 902b944..acfd54c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c
@@ -673,7 +673,7 @@ void rtl8723e_dm_check_txpower_tracking(struct ieee80211_hw *hw)
 void rtl8723e_dm_init_rate_adaptive_mask(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rate_adaptive *p_ra = &(rtlpriv->ra);
+	struct rate_adaptive *p_ra = &rtlpriv->ra;
 
 	p_ra->ratr_state = DM_RATR_STA_INIT;
 	p_ra->pre_ratr_state = DM_RATR_STA_INIT;
@@ -685,6 +685,89 @@ void rtl8723e_dm_init_rate_adaptive_mask(struct ieee80211_hw *hw)
 
 }
 
+void rtl8723e_dm_refresh_rate_adaptive_mask(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rate_adaptive *p_ra = &rtlpriv->ra;
+	u32 low_rssithresh_for_ra, high_rssithresh_for_ra;
+	struct ieee80211_sta *sta = NULL;
+
+	if (is_hal_stop(rtlhal)) {
+		RT_TRACE(rtlpriv, COMP_RATE, DBG_LOUD,
+			 " driver is going to unload\n");
+		return;
+	}
+
+	if (!rtlpriv->dm.useramask) {
+		RT_TRACE(rtlpriv, COMP_RATE, DBG_LOUD,
+			 " driver does not control rate adaptive mask\n");
+		return;
+	}
+
+	if (mac->link_state == MAC80211_LINKED &&
+	    mac->opmode == NL80211_IFTYPE_STATION) {
+		switch (p_ra->pre_ratr_state) {
+		case DM_RATR_STA_HIGH:
+			high_rssithresh_for_ra = 50;
+			low_rssithresh_for_ra = 20;
+			break;
+		case DM_RATR_STA_MIDDLE:
+			high_rssithresh_for_ra = 55;
+			low_rssithresh_for_ra = 20;
+			break;
+		case DM_RATR_STA_LOW:
+			high_rssithresh_for_ra = 60;
+			low_rssithresh_for_ra = 25;
+			break;
+		default:
+			high_rssithresh_for_ra = 50;
+			low_rssithresh_for_ra = 20;
+			break;
+		}
+
+		if (rtlpriv->link_info.bcn_rx_inperiod == 0)
+			switch (p_ra->pre_ratr_state) {
+			case DM_RATR_STA_HIGH:
+			default:
+				p_ra->ratr_state = DM_RATR_STA_MIDDLE;
+				break;
+			case DM_RATR_STA_MIDDLE:
+			case DM_RATR_STA_LOW:
+				p_ra->ratr_state = DM_RATR_STA_LOW;
+				break;
+			}
+		else if (rtlpriv->dm.undec_sm_pwdb > high_rssithresh_for_ra)
+			p_ra->ratr_state = DM_RATR_STA_HIGH;
+		else if (rtlpriv->dm.undec_sm_pwdb > low_rssithresh_for_ra)
+			p_ra->ratr_state = DM_RATR_STA_MIDDLE;
+		else
+			p_ra->ratr_state = DM_RATR_STA_LOW;
+
+		if (p_ra->pre_ratr_state != p_ra->ratr_state) {
+			RT_TRACE(rtlpriv, COMP_RATE, DBG_LOUD,
+				 "RSSI = %ld\n",
+				 rtlpriv->dm.undec_sm_pwdb);
+			RT_TRACE(rtlpriv, COMP_RATE, DBG_LOUD,
+				 "RSSI_LEVEL = %d\n", p_ra->ratr_state);
+			RT_TRACE(rtlpriv, COMP_RATE, DBG_LOUD,
+				 "PreState = %d, CurState = %d\n",
+				 p_ra->pre_ratr_state, p_ra->ratr_state);
+
+			rcu_read_lock();
+			sta = rtl_find_sta(hw, mac->bssid);
+			if (sta)
+				rtlpriv->cfg->ops->update_rate_tbl(hw, sta,
+							   p_ra->ratr_state,
+								      true);
+			rcu_read_unlock();
+
+			p_ra->pre_ratr_state = p_ra->ratr_state;
+		}
+	}
+}
+
 void rtl8723e_dm_rf_saving(struct ieee80211_hw *hw, u8 bforce_in_normal)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -834,7 +917,7 @@ void rtl8723e_dm_watchdog(struct ieee80211_hw *hw)
 		rtl8723e_dm_dynamic_bb_powersaving(hw);
 		rtl8723e_dm_dynamic_txpower(hw);
 		rtl8723e_dm_check_txpower_tracking(hw);
-		/* rtl92c_dm_refresh_rate_adaptive_mask(hw); */
+		rtl8723e_dm_refresh_rate_adaptive_mask(hw);
 		rtl8723e_dm_bt_coexist(hw);
 		rtl8723e_dm_check_edca_turbo(hw);
 	}
-- 
1.9.1
