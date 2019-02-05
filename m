Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97695C282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AC5B2081B
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 07:16:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="bFEafvTk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfBEHQF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 02:16:05 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:26935 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfBEHQF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 02:16:05 -0500
X-IronPort-AV: E=Sophos;i="5.56,562,1539673200"; 
   d="scan'208";a="26323441"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Feb 2019 00:16:04 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 5 Feb 2019 00:16:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gi7CD7HvY2ZfWcyyQAIDqB8+38Gny2rrizbEgBRKkJE=;
 b=bFEafvTkK0dKiVMFO45AtK01GL/X4wv0GPfc1w44typbFffxWMMP1KvJyx+27ElGKCOK6yYoYOLdDeVo34Jf05jwkxIRBVvIFvkRppC6y8MAjKDU26B10DLl0k7q8uFfG3P2yMMsFq77qepM+rErsxdawbcoFzmvwo1HbWOlax8=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2984.namprd11.prod.outlook.com (20.177.224.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.20; Tue, 5 Feb 2019 07:16:02 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Tue, 5 Feb 2019
 07:16:02 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 11/12] staging: wilc1000: move 'curr_channel' static variable
 in 'wilc' struct
Thread-Topic: [PATCH 11/12] staging: wilc1000: move 'curr_channel' static
 variable in 'wilc' struct
Thread-Index: AQHUvSKmslXJticxFka56zBK4xq01Q==
Date:   Tue, 5 Feb 2019 07:16:02 +0000
Message-ID: <1549350913-645-12-git-send-email-ajay.kathat@microchip.com>
References: <1549350913-645-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549350913-645-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0066.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::28) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [183.82.17.42]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2984;6:mlWups0JOWvmNEJT7Idie4ef8/znyrfj7OVm3QPt7U6DOlITd1dHa/hyyEHr5EmgwSM+ozPB1GKjkmrAVSxzLxtxssykBP1WXk6pcJB9AC1ZLKHD+ZoKCiguSbXrdOAfF+X8Fzz/w4b4SsfDCRmJvrdrumiWY862yZzjU51OQkwvHqBbxGPCHJU/Kbp3sOQL6Re2CmQjyxUmW8QdxHjtlN/yvwrUXh/bXvb54rXdRFDhY6xp9ccXlQafO3KtuAU0rkxFZUKwJkM8GMoMnE2xOCX3lWb4xphXrgZKgNJ/53cvoWw97r6OpYptVhG7j+mJcITb1PDu0GDUiY3YKlLcIt3SJv9QiEirPwk9eBRBVkTLrFHHG6AvE1RnCZ/ilNiVMEGQYTgOi+FfXhjWDeuWcWw/y/S/de7bBNeZJ0pIS5xzYxm0m9L2YAaRf89fmXvcRa/TokXaRukn4FxjEFWaqg==;5:OfKYUQgHT/APM7+Mr7fyAfqwK3tm+XJA9xSP+yC1WlPW4BptQEh8BqS9nQMlEGONDUf9gZBPi6CmEzFPIKZDA6tESdYW0IBBWJpfdc2gaMdsMSXXHrN2goQvCP70DKM1bd/6CqoLXD3Lzi8k3oyixUSUlH0+5GRV30Ccgs4QLMo0kqpXTyGBJ1N7ZBx6CpXPWvx1ZilPYO8hN5dJLjL+Zw==;7:G5jm6VXGyvNQgIu2kvcYOly1KzPjpzepm6hAHzXGQPtXpUIlXhh+RW3sYoDp00/CHPnfaL+ERIIwUZHa8xz55gI14nmxjpCmigJj+SDtBJ8FIMCCknCqP26QPY9aP4DPMxrYAFf0yku5+1qrCnl9fQ==
x-ms-office365-filtering-correlation-id: 01107d48-86c3-4ad1-c150-08d68b39c8ee
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2984;
x-ms-traffictypediagnostic: BYAPR11MB2984:
x-microsoft-antispam-prvs: <BYAPR11MB2984A47F3D1A4A357CFE66DBE36E0@BYAPR11MB2984.namprd11.prod.outlook.com>
x-forefront-prvs: 0939529DE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(376002)(396003)(346002)(136003)(199004)(189003)(4326008)(36756003)(386003)(6116002)(3846002)(102836004)(14454004)(68736007)(97736004)(11346002)(78486014)(316002)(2351001)(5640700003)(478600001)(25786009)(6436002)(53936002)(71190400001)(26005)(71200400001)(6486002)(106356001)(72206003)(6916009)(446003)(8676002)(105586002)(305945005)(6512007)(186003)(6506007)(7736002)(486006)(476003)(66066001)(2616005)(8936002)(107886003)(52116002)(81166006)(81156014)(76176011)(2501003)(50226002)(256004)(14444005)(99286004)(54906003)(2906002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2984;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jQvAxSe8vr5XCtsXCsIxJGZswGlC+ym4gfedbKnk8ziWThFqCN9loUXWyllOKtn49WYGCEz0WholqpNtECQKzJ8M5gP27/hk8EVQK5r8gr8dulyAFUXCQpHB6aWObdNPBQl8wM3eOJCnSRTKNsSR8dshav+ORqxYZup5P/oETqLdHiXrZlfng5GOiJQaHZzWtrfe9cv73fTolg2CuBTxQrFhBN2PxDlNAUJA3tem8VHWxVZ+3LLLWRnphVfm5GO+Y7YaxtvwVACuYQ1xIsxsMHBCTe0AphuJFg6hRG6hVGSvPNWDSZp8p1/m7W4uoDTysaJKPQeG02FvyY+Kdie6uVO0IeLQTYAS/4Rr3nXQKoJWqwJ8hN2KvQIhM/jeaIaUgzT/Y/v008cZOIjLGbEJiuGF/xlaBHkx+yqde4xWdGs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 01107d48-86c3-4ad1-c150-08d68b39c8ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2019 07:16:00.0747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2984
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Avoid the use of static variable and move it as part of wilc structure.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 22 ++++++++++++-------=
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  1 +
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index f1ce34f..dd1fe3f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -67,7 +67,6 @@ struct p2p_mgmt_data {
 	u8 *buff;
 };
=20
-static u8 curr_channel;
 static u8 p2p_oui[] =3D {0x50, 0x6f, 0x9A, 0x09};
 static u8 p2p_vendor_spec[] =3D {0xdd, 0x05, 0x00, 0x08, 0x40, 0x03};
=20
@@ -206,7 +205,7 @@ static int set_channel(struct wiphy *wiphy,
=20
 	channelnum =3D ieee80211_frequency_to_channel(chandef->chan->center_freq)=
;
=20
-	curr_channel =3D channelnum;
+	vif->wilc->op_ch =3D channelnum;
 	result =3D wilc_set_mac_chnl_num(vif, channelnum);
=20
 	if (result !=3D 0)
@@ -324,6 +323,7 @@ static int connect(struct wiphy *wiphy, struct net_devi=
ce *dev,
 	u32 cipher_group;
 	struct cfg80211_bss *bss;
 	void *join_params;
+	u8 ch;
=20
 	vif->connecting =3D true;
=20
@@ -427,16 +427,16 @@ static int connect(struct wiphy *wiphy, struct net_de=
vice *dev,
 		goto out_put_bss;
 	}
=20
-	curr_channel =3D ieee80211_frequency_to_channel(bss->channel->center_freq=
);
-
+	ch =3D ieee80211_frequency_to_channel(bss->channel->center_freq);
+	vif->wilc->op_ch =3D ch;
 	if (vif->iftype !=3D WILC_CLIENT_MODE)
-		vif->wilc->sta_ch =3D curr_channel;
+		vif->wilc->sta_ch =3D ch;
=20
 	wilc_wlan_set_bssid(dev, bss->bssid, WILC_STATION_MODE);
=20
 	wfi_drv->conn_info.security =3D security;
 	wfi_drv->conn_info.auth_type =3D auth_type;
-	wfi_drv->conn_info.ch =3D curr_channel;
+	wfi_drv->conn_info.ch =3D ch;
 	wfi_drv->conn_info.conn_result =3D cfg_connect_result;
 	wfi_drv->conn_info.arg =3D priv;
 	wfi_drv->conn_info.param =3D join_params;
@@ -1048,6 +1048,8 @@ void wilc_wfi_p2p_rx(struct net_device *dev, u8 *buff=
, u32 size)
 {
 	struct wilc_priv *priv =3D wiphy_priv(dev->ieee80211_ptr->wiphy);
 	struct host_if_drv *wfi_drv =3D priv->hif_drv;
+	struct wilc_vif *vif =3D netdev_priv(dev);
+	struct wilc *wl =3D vif->wilc;
 	u32 header, pkt_offset;
 	s32 freq;
 	__le16 fc;
@@ -1068,7 +1070,7 @@ void wilc_wfi_p2p_rx(struct net_device *dev, u8 *buff=
, u32 size)
 		return;
 	}
=20
-	freq =3D ieee80211_channel_to_frequency(curr_channel, NL80211_BAND_2GHZ);
+	freq =3D ieee80211_channel_to_frequency(wl->op_ch, NL80211_BAND_2GHZ);
=20
 	fc =3D ((struct ieee80211_hdr *)buff)->frame_control;
 	if (!ieee80211_is_action(fc)) {
@@ -1158,7 +1160,7 @@ static int remain_on_channel(struct wiphy *wiphy,
 	if (ret)
 		return ret;
=20
-	curr_channel =3D chan->hw_value;
+	vif->wilc->op_ch =3D chan->hw_value;
=20
 	priv->remain_on_ch_params.listen_ch =3D chan;
 	priv->remain_on_ch_params.listen_cookie =3D id;
@@ -1279,7 +1281,7 @@ static int mgmt_tx(struct wiphy *wiphy,
=20
 	if (ieee80211_is_probe_resp(mgmt->frame_control)) {
 		wilc_set_mac_chnl_num(vif, chan->hw_value);
-		curr_channel =3D chan->hw_value;
+		vif->wilc->op_ch =3D chan->hw_value;
 		goto out_txq_add_pkt;
 	}
=20
@@ -1290,7 +1292,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 		if (buf[ACTION_SUBTYPE_ID] !=3D PUBLIC_ACT_VENDORSPEC ||
 		    buf[P2P_PUB_ACTION_SUBTYPE] !=3D GO_NEG_CONF) {
 			wilc_set_mac_chnl_num(vif, chan->hw_value);
-			curr_channel =3D chan->hw_value;
+			vif->wilc->op_ch =3D chan->hw_value;
 		}
 		switch (buf[ACTION_SUBTYPE_ID]) {
 		case GAS_INITIAL_REQ:
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/stagin=
g/wilc1000/wilc_wfi_netdevice.h
index 29f220d..2b9b8b5 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -274,6 +274,7 @@ struct wilc {
 	/* deinit lock */
 	struct mutex deinit_lock;
 	u8 sta_ch;
+	u8 op_ch;
 };
=20
 struct wilc_wfi_mon_priv {
--=20
2.7.4

