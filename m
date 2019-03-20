Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A40C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 629A52184E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="t2HZJ+mq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbfCTKFa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:05:30 -0400
Received: from mail-eopbgr790080.outbound.protection.outlook.com ([40.107.79.80]:24016
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727586AbfCTKFa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 06:05:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dv1SOnv5rgtLluI/Qo9lx2zzS+eUbHQ2NfmntrVipc0=;
 b=t2HZJ+mqWYqgpiGHYwRiUmEP/tYStTeO3rW6HKLSiQyS1U4cLhNBBAx6FGSX/9/jxfTSaONv2onBFULB6DU/CB8ZW0V7ipkpbfwZXgm7629Mczg1ZuzQbzcVt4kSbCcZXaMzzT3ApeTOU9tbwjqqPpsECIPr2Vjg/kYe/NPHxdw=
Received: from SN6PR05MB4096.namprd05.prod.outlook.com (52.135.66.154) by
 SN6PR05MB4880.namprd05.prod.outlook.com (52.135.117.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.16; Wed, 20 Mar 2019 10:05:15 +0000
Received: from SN6PR05MB4096.namprd05.prod.outlook.com
 ([fe80::48c3:e0cd:1006:7da6]) by SN6PR05MB4096.namprd05.prod.outlook.com
 ([fe80::48c3:e0cd:1006:7da6%5]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:05:15 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5661.namprd05.prod.outlook.com (52.135.111.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.15; Wed, 20 Mar 2019 10:04:06 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:04:05 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 11/14] qtnfmac: allow changing the netns
Thread-Topic: [PATCH 11/14] qtnfmac: allow changing the netns
Thread-Index: AQHU3wRArjeRqZAgvki0SX4sarCvGw==
Date:   Wed, 20 Mar 2019 10:04:05 +0000
Message-ID: <20190320100340.14168-12-sergey.matyukevich.os@quantenna.com>
References: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0106.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::47) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.11.0
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94107e6a-ac58-4eb9-51c1-08d6ad1b62de
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5661;
x-ms-traffictypediagnostic: SN6PR05MB5661:|SN6PR05MB4880:
x-moderation-data: 3/20/2019 10:05:12 AM
x-microsoft-antispam-prvs: <SN6PR05MB48808A53BCCFF0107D51F0B6A3410@SN6PR05MB4880.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(396003)(376002)(366004)(39850400004)(199004)(189003)(71200400001)(8936002)(436003)(476003)(2906002)(486006)(316002)(2616005)(11346002)(86362001)(2501003)(7736002)(71190400001)(50226002)(3846002)(305945005)(6916009)(5660300002)(6116002)(446003)(68736007)(5640700003)(6486002)(8676002)(2351001)(4744005)(53936002)(107886003)(25786009)(6506007)(66066001)(81156014)(81166006)(106356001)(6512007)(386003)(99286004)(102836004)(1076003)(97736004)(105586002)(103116003)(478600001)(54906003)(14454004)(14444005)(256004)(76176011)(6436002)(186003)(4326008)(52116002)(26005)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB4880;H:SN6PR05MB4096.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bx17tAmwC5/Jn8nc0iF7wa5toiT60JYlxFRpM64StQ/n4gVKq2M3oIdNdPO14JoPpLA+BnBGxAn3HDNAS5b6iScP7l6yo+ngVLdMjwUUgN9CCBQMRhOzS6C4tLXY8+S/voFhQNXIW72xelskxfzW0NvB7P9qnW/myLVUDXI5uSXLawI0MumI0kilvgtOJWlm+PhhPGauoX+R0PTt9FFobQ9pOUTRoBz/9bGdDVZ4y32oDzJKVdRAAOg6cSMhcVws+VGssuNtGSwuHWW+zQKpLPwLqrhl5X0/dfzAuIuaU99srI6/jwgvGyrO8wEUX8G08BpmXeNPtPiUtOa2+gqwgWECchQsM9hxRyb6QZCZoJi8pDfcoIm+NwWsipHG3REHKJa3tXnbZ97Stien+yZkhF/6WFqSjbYLwabAeYlyfI0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94107e6a-ac58-4eb9-51c1-08d6ad1b62de
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 10:05:15.0964
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB4880
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Allow to change netns for wireless interfaces created by qtnfmac driver.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index cea948466744..95572555ed6a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -1106,7 +1106,8 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info,=
 struct qtnf_wmac *mac)
 			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD |
 			WIPHY_FLAG_AP_UAPSD |
 			WIPHY_FLAG_HAS_CHANNEL_SWITCH |
-			WIPHY_FLAG_4ADDR_STATION;
+			WIPHY_FLAG_4ADDR_STATION |
+			WIPHY_FLAG_NETNS_OK;
 	wiphy->flags &=3D ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
=20
 	if (hw_info->hw_capab & QLINK_HW_CAPAB_DFS_OFFLOAD)
--=20
2.11.0

