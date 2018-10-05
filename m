Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4814BC65BA7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0057B20645
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:11:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="p3kkuS6o"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0057B20645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbeJERJi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 13:09:38 -0400
Received: from mail-bl2nam02on0042.outbound.protection.outlook.com ([104.47.38.42]:30496
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728025AbeJERJi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 13:09:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMZwiB34r0+j+TOYKfgXdqyb4IR+iGzNarTPysNRe58=;
 b=p3kkuS6o6i325DFbXjQlSZUi9kR+xOhJ/oArDIKqIJAt/mJc22j+3e1S4l1un2ABHySxZhXRHeY7vfsxvXinDT+DpUBvQhu+gz4/gwXfRAJn9bbqPxxXRdn9Xz2+DUdY7N6R7A3lOGEupiKggqqWj2ZaQmY4wySq3IOujLoO1OI=
Received: from BYAPR05MB4597.namprd05.prod.outlook.com (52.135.233.18) by
 BYAPR05MB4375.namprd05.prod.outlook.com (52.135.202.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.13; Fri, 5 Oct 2018 10:11:30 +0000
Received: from BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373]) by BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373%4]) with mapi id 15.20.1207.021; Fri, 5 Oct 2018
 10:11:30 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH v2 03/13] qtnfmac: request userspace to do OBSS scanning if FW
 can not
Thread-Topic: [PATCH v2 03/13] qtnfmac: request userspace to do OBSS scanning
 if FW can not
Thread-Index: AQHUXJPISlsKP0wcNkuNFKGzKPwXYg==
Date:   Fri, 5 Oct 2018 10:11:30 +0000
Message-ID: <20181005101114.3013-4-sergey.matyukevich.os@quantenna.com>
References: <20181005101114.3013-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181005101114.3013-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5P194CA0013.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:203:8f::23) To BYAPR05MB4597.namprd05.prod.outlook.com
 (2603:10b6:a03:4c::18)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR05MB4375;6:kwoWkoAF3TZGsHifOnhQMEKgMscWZdw4xzvcvI87AzzHpwMeU4e0qC3gAMBMLPruwUrS/PiVzsM02ZdQD3x6RNqLHfO4KNj4zfc2HjxV5SVRsV1xj2hGx5Ds/GCQYZXA6+XqHjxsqnRW5Ilicrj6lVtCEnialorp5nJBsn59SwNg9FS8sXfjFebFjDcx2nR7945JJ8rw8QVC586cPhOl9pjJFEkYoYnBlqQErkRbH5gGAu5O7gphspEQefS2ZaHz0PiIUKpxnFR/fYEF3gK1kiRjhvUTInCOHKrYzwWwmEa7hFSd6Yo2nXBki7huV/lDFbYN9thqzY5nxXISyKB1j8Y3Mzc54liC6yDlh7AtYxetuSFu5KVuFmEwFqcWHyCmtnBTsI9Wv/NfKbsTKOMkBOOUJAd8Q73cFD3YH+cusbpUxL2UEUC7mGb3gGqwwDqaUJy2nsN+9GX6jx+QRsnOnw==;5:bnBW1ytvas8DJwFFjWpKH+3cPotXXIDJEzayilBsziGvCfN7cM0IeAaJstM+EvbKz0HyufXB3+OVTGdZ61ZkK3UDxhLGCb7krgdHbiGxRyVGI99BMH67YizgXEgbaAUsrJrsATgL9HUj75jH3a8AjPy0KP/TxDvfiP34b72NJ4E=;7:N4UtT+Y0Gt072woVrO3MeDfId9Urn9Be8kR5ITH9luGR2oOIhRTvmQBrQH5USvl2Y3NOQ6nuF/ajK3+4o0sPoO9hPSqbAn0PkffJxH951eYcrjtafCFw36xVxiQhWSOPYC6hbrrTai5UAdrXiZ26Ua0OsmWbWiB/o70YbkF13dXAteOkxoU/ajNzWvJif2ks8fxO1AhnZWyn7D6ea94B2DbJFAddkTLm6RtIm6h2DqK/Y6GYl2+SwKLc3mZ5c6nT
x-ms-office365-filtering-correlation-id: e895a3b0-4dd1-4b96-6368-08d62aaaeb35
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB4375;
x-ms-traffictypediagnostic: BYAPR05MB4375:
x-microsoft-antispam-prvs: <BYAPR05MB43751A75904E380666301623A3EB0@BYAPR05MB4375.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(20558992708506);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231355)(944501410)(52105095)(93006095)(93001095)(3002001)(10201501046)(149066)(150057)(6041310)(20161123564045)(20161123562045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(201708071742011)(7699051);SRVR:BYAPR05MB4375;BCL:0;PCL:0;RULEID:;SRVR:BYAPR05MB4375;
x-forefront-prvs: 0816F1D86E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39850400004)(366004)(376002)(346002)(189003)(199004)(6916009)(478600001)(6506007)(386003)(106356001)(105586002)(99286004)(6512007)(2900100001)(97736004)(2351001)(4326008)(25786009)(76176011)(36756003)(53936002)(2906002)(103116003)(107886003)(2501003)(52116002)(486006)(5660300001)(5250100002)(2616005)(446003)(476003)(305945005)(8676002)(8936002)(102836004)(14444005)(26005)(11346002)(3846002)(71190400001)(71200400001)(1076002)(6116002)(14454004)(68736007)(6436002)(6486002)(5640700003)(7736002)(186003)(86362001)(316002)(256004)(66066001)(81156014)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4375;H:BYAPR05MB4597.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: nekjUPzWJdImCSUkLwsLo0oXyMcd2ihlEE1k7k4D4wo9vLxlSpx5Njxm2j8gCBwI9aDfNCTc0fGeI9y3PJebwPaW7z0hvoTKA17EL2qkW0HBoB2PIw3r2bD0ycr8JZVNVqGKX2MfPnSo3CHlZ6K+qooO+GXcfjOpDRAVQ8IhGlCHmULDyzHO5us6/1rvQfOSb2E8zX2aB5UyOPOMH8o9uqmb3H9RxBA3GGHH+DKv85gC6nUJaD2HiMt1oROxt2/k8WsXsD+QrsWSHAjjGpoAj14ClEf9Aty5OIgc/QXLkIIJr7/Ew1rCToCfjNt68iKjGPeAORhtNkldhbxbivmeSegDXNkzA+zR5mrdjdfayZE=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e895a3b0-4dd1-4b96-6368-08d62aaaeb35
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2018 10:11:30.1667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4375
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

In case firmware reports that it can not do OBSS scanning for 40MHz
2.4GHz channels itself, tell userpsace to do that instead by setting
NL80211_FEATURE_NEED_OBSS_SCAN flag.

Signed-off-by: Igor mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 3 +++
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index 87f48b7fb673..c4961e16d91a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -1099,6 +1099,9 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info,=
 struct qtnf_wmac *mac)
 	if (hw_info->hw_capab & QLINK_HW_CAPAB_SCAN_RANDOM_MAC_ADDR)
 		wiphy->features |=3D NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
=20
+	if (!(hw_info->hw_capab & QLINK_HW_CAPAB_OBSS_SCAN))
+		wiphy->features |=3D NL80211_FEATURE_NEED_OBSS_SCAN;
+
 #ifdef CONFIG_PM
 	if (macinfo->wowlan)
 		wiphy->wowlan =3D macinfo->wowlan;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/w=
ireless/quantenna/qtnfmac/qlink.h
index 99d37e3efba6..c5ae4ea9a47a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -71,6 +71,7 @@ struct qlink_msg_header {
  * @QLINK_HW_CAPAB_DFS_OFFLOAD: device implements DFS offload functionalit=
y
  * @QLINK_HW_CAPAB_SCAN_RANDOM_MAC_ADDR: device supports MAC Address
  *	Randomization in probe requests.
+ * @QLINK_HW_CAPAB_OBSS_SCAN: device can perform OBSS scanning.
  */
 enum qlink_hw_capab {
 	QLINK_HW_CAPAB_REG_UPDATE		=3D BIT(0),
@@ -78,6 +79,7 @@ enum qlink_hw_capab {
 	QLINK_HW_CAPAB_DFS_OFFLOAD		=3D BIT(2),
 	QLINK_HW_CAPAB_SCAN_RANDOM_MAC_ADDR	=3D BIT(3),
 	QLINK_HW_CAPAB_PWR_MGMT			=3D BIT(4),
+	QLINK_HW_CAPAB_OBSS_SCAN		=3D BIT(5),
 };
=20
 enum qlink_iface_type {
--=20
2.11.0

