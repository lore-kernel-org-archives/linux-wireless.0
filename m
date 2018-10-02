Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82FC2C43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4014A20878
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="VIzlLe3l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4014A20878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbeJBQIb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 12:08:31 -0400
Received: from mail-by2nam01on0054.outbound.protection.outlook.com ([104.47.34.54]:16160
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726691AbeJBQI2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 12:08:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T1F0TlLn2H9HbN2VKELFtZRc8OrpRs/JOxS8pban2oE=;
 b=VIzlLe3l9lt/VV+fizN8d388pggNa97J4sN1dWCGDslD2KIRj6uxzhLKVU+Wqn992sFJclM5EqURLc9mocIt5WxAoK8ilxhwe/D7/c0TIKAi8qsv+WePpX18VX5S+kYZY+gvtQtCWKSCuqLlZYsUVwDc4mRZlODLieAJz8Xb5UQ=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB5266.namprd05.prod.outlook.com (20.177.242.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.11; Tue, 2 Oct 2018 09:26:07 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a%3]) with mapi id 15.20.1185.024; Tue, 2 Oct 2018
 09:26:07 +0000
From:   Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko OS <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 11/13] qtnfmac: add support for scan dwell time configuration
Thread-Topic: [PATCH 11/13] qtnfmac: add support for scan dwell time
 configuration
Thread-Index: AQHUWjHyni+CjYKSe0aJgaTZRQTbOA==
Date:   Tue, 2 Oct 2018 09:26:07 +0000
Message-ID: <20181002092542.18966-12-sergey.matyukevich.os@quantenna.com>
References: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR06CA0023.eurprd06.prod.outlook.com
 (2603:10a6:206:2::36) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5266;6:nnQGy2NDyqPsv2R3XCvIwxLpR8RGoCrhxgJ30DF4rELXDvNiemb1MjcX9rA3BZhm3orX1jO1txL+oi3K8byln1zg8i8H/3km4cVtlHCxoi2jJXYc3cFUKurkCRvpm2jh/hHpT00qDMU0fLcjb7xPJv+rFL+/VzYmz5K6s6qO1PC2aad8bLNCcLrObUjtbzjk9SlhbvtD95mpLL2oYDmTpqmNb+tPrlg2FHvzLfpFq2IWtSmsNhhsuM6XCfgleTcxEgrmsbmjG8eMj/G2BE9afLSSYAjuo8HIA97RFSbOxSG7T1iEuu5YhRadZazr37UrYoLKa0Ybpar4ozPY5MPVas/DDhS7fq1KIOI9ryXYao2CkDAN9+7LhFGGcMxhPREXX7FsL0j+wNeomfc+BOqRjCXTx7cCjRBmLehxIktiXssaOs/ImF5X92l1bHqdtslI/0ttU+Jy+kYwUwrsgeMM2A==;5:jI1aeamFY6IEKDFVHmWzTaGObi7xi+8c8fLzGVMGm1X/e15Ukxwu8SmTFR2t0uIuQ0+hGVjpAhKgZvWABGAgg3P5/j1Vc42tlG0784dxAAfUzqwUult/WP2yHJVQfX/O6bN1iNIiFc29qcOPF13D+EGHQgCe8LFr1KJfEeT0KeQ=;7:liBZNshInGYAwpZOD/DWuPnSOCt2OzTctwDenn859cOKlJijTXES3X9a9R0J7Zt2r1GHfcXW5/QXupdAmFeDzG7QGk9IKr6I/6xOmu2p3ucmHha9TJ4NlobkyQntVhRymO2pFcIrMdMDTQ0HjIHB3MGecXGdIUosYgLOctzH+fkiuiVwvdwpreAJXkNlHlBp8A8CeY1Qo7k79LK31RMVE6d1/QILUtIM0Jl5sPYZoJasngRzn8h5skA+YgM1OsGU
x-ms-office365-filtering-correlation-id: d3ad2df0-9cd5-4a47-2cce-08d628491537
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5266;
x-ms-traffictypediagnostic: BL0PR05MB5266:
x-microsoft-antispam-prvs: <BL0PR05MB52665FA15BF52D93DF8EE402A3E80@BL0PR05MB5266.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231355)(944501410)(52105095)(3002001)(10201501046)(149066)(150057)(6041310)(20161123564045)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051);SRVR:BL0PR05MB5266;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5266;
x-forefront-prvs: 0813C68E65
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(376002)(39850400004)(136003)(396003)(199004)(189003)(1076002)(316002)(105586002)(186003)(305945005)(11346002)(3846002)(486006)(5640700003)(256004)(6512007)(6436002)(8936002)(14454004)(476003)(36756003)(2351001)(106356001)(2616005)(81156014)(14444005)(66066001)(81166006)(86362001)(54906003)(446003)(68736007)(6116002)(5250100002)(107886003)(5660300001)(25786009)(71190400001)(6916009)(99286004)(2906002)(71200400001)(26005)(102836004)(2501003)(6506007)(386003)(52116002)(76176011)(478600001)(97736004)(103116003)(8676002)(6486002)(2900100001)(7736002)(4326008)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5266;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: WYgmiIV3fPA0Wl6yz4hXs30A59ZrcuVfeRYqIgi9tlCB9Kw+J2x8Qnmb+TEmBWMDLJFOxZLj984HFIRNpWaeHf6Z44D0QUYFdaCMBc0lz5nFFEtxIGVmcXf805QxX8W7ekmB3d0A2ysnuU4HvcaC7NJ40XPa9sY3JF85qn8p9exEvxJ69FVxs3osBDA6jP2lfp7sgIzl/w+/PkwW0x8ytvcMjqXRIGeOdKZ0hpmWP8NFxyt9zq1lzZpXKXul9n0UlCzoyMTCWf8/nxUkYYuADD0GDi7ji3Gtr/j3/x2P6ulEJKhpULtwL8+/XlLRgSv+2xPvDpTw+258BhAl9Ue3s36KTJwi9CcyqJ+LzuRGKxw=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3ad2df0-9cd5-4a47-2cce-08d628491537
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2018 09:26:07.7357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5266
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Firmware supports scan dwell time tuning for various types of scans.
Enable support for this feature:
- advertise capability to configure channel dwell time to host
- pass scan dwell parameters to wireless card in scan request

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 4 ++++
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 9 +++++++++
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 2 ++
 3 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index 9845cf287118..18179965bd38 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -1101,6 +1101,10 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info=
, struct qtnf_wmac *mac)
 	if (hw_info->hw_capab & QLINK_HW_CAPAB_DFS_OFFLOAD)
 		wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_DFS_OFFLOAD);
=20
+	if (hw_info->hw_capab & QLINK_HW_CAPAB_SCAN_DWELL)
+		wiphy_ext_feature_set(wiphy,
+				      NL80211_EXT_FEATURE_SET_SCAN_DWELL);
+
 	wiphy->probe_resp_offload =3D NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
 				    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2;
=20
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index 8fb15cbf5005..bfdc1ad30c13 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2203,6 +2203,15 @@ int qtnf_cmd_send_scan(struct qtnf_wmac *mac)
 		qtnf_cmd_skb_put_tlv_tag(cmd_skb, QTN_TLV_ID_SCAN_FLUSH);
 	}
=20
+	if (scan_req->duration) {
+		pr_debug("MAC%u: %s scan duration %u\n", mac->macid,
+			 scan_req->duration_mandatory ? "mandatory" : "max",
+			 scan_req->duration);
+
+		qtnf_cmd_skb_put_tlv_u16(cmd_skb, QTN_TLV_ID_SCAN_DWELL,
+					 scan_req->duration);
+	}
+
 	ret =3D qtnf_cmd_send(mac->bus, cmd_skb);
 	if (ret)
 		goto out;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/w=
ireless/quantenna/qtnfmac/qlink.h
index 699157100309..8d62addea895 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -80,6 +80,7 @@ enum qlink_hw_capab {
 	QLINK_HW_CAPAB_SCAN_RANDOM_MAC_ADDR	=3D BIT(3),
 	QLINK_HW_CAPAB_PWR_MGMT			=3D BIT(4),
 	QLINK_HW_CAPAB_OBSS_SCAN		=3D BIT(5),
+	QLINK_HW_CAPAB_SCAN_DWELL		=3D BIT(6),
 };
=20
 enum qlink_iface_type {
@@ -1152,6 +1153,7 @@ enum qlink_tlv_id {
 	QTN_TLV_ID_WOWLAN_CAPAB		=3D 0x0410,
 	QTN_TLV_ID_WOWLAN_PATTERN	=3D 0x0411,
 	QTN_TLV_ID_SCAN_FLUSH		=3D 0x0412,
+	QTN_TLV_ID_SCAN_DWELL		=3D 0x0413,
 };
=20
 struct qlink_tlv_hdr {
--=20
2.11.0

