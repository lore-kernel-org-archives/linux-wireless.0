Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EFA1C004D2
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC6A32089A
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="uFD/ECzf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC6A32089A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbeJBQIX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 12:08:23 -0400
Received: from mail-bn3nam01on0070.outbound.protection.outlook.com ([104.47.33.70]:28864
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726251AbeJBQIX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 12:08:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMZwiB34r0+j+TOYKfgXdqyb4IR+iGzNarTPysNRe58=;
 b=uFD/ECzfjcNukPU2ayWzkX8Ku8BOHGUx+q6Ch6E0TfZfEkVJN57GoQ+h5ahojCB2qorjZH47BXnVEdXnxje8phwC5Dt7qafK/5TRsU/MZTgjYiBKN49kCC6gelhFe8ixSXNMcVvYL3lGOhrUV4TAytTvSzu7Cn369U8AFbmHGlw=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB5092.namprd05.prod.outlook.com (20.177.241.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1185.18; Tue, 2 Oct 2018 09:25:58 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a%3]) with mapi id 15.20.1185.024; Tue, 2 Oct 2018
 09:25:58 +0000
From:   Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko OS <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 03/13] qtnfmac: request userspace to do OBSS scanning if FW
 can not
Thread-Topic: [PATCH 03/13] qtnfmac: request userspace to do OBSS scanning if
 FW can not
Thread-Index: AQHUWjHtjiAj75DiPE2gorfXztImgw==
Date:   Tue, 2 Oct 2018 09:25:58 +0000
Message-ID: <20181002092542.18966-4-sergey.matyukevich.os@quantenna.com>
References: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR06CA0023.eurprd06.prod.outlook.com
 (2603:10a6:206:2::36) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5092;6:VKyw7vA6Ulva0gsZ5ZMlyZbSdzTpdgCJunfo/5Tb2L3JTrvU+rPulTe/2ewtrD1a6VZofBT15AjgGsxrAWkOhmyfejaR9WlUY71Sl+v7twj6vR4weSscXM30sH/ik0rpW/LyJ2oGdLdAIiS34GN8qfScuf95zTVvYf1BzLLkrsZeDv+Ukph7qq09EUDOkNUQvOvGdKtqmxCTPkr0+cy2SPNRkT/yqRKEmGVbPwJn4Jj8zHcxdbI00yTCKlAQBJD0VNLrtGmNWbKkUIlJ83yPaHb+DCn2NzLWj853g0gNrlZ/oz+S6PKpx6XyRgc/dwuqKvQj/DTKm57RY/T3oGV1B4A4ePKxTPMm4yHdDC640M+XsyQeDb5HHEbIdzpGmWWB6zfm9Bli9rOyJlFadh43rq2RyNAuEwnHZgv2YawgjcGGh3vOFjT9jcVLzyr7/oEGad3GjCmbE7PZ2Y/qgO5lgQ==;5:FfHyoo0gGiIfpa5few3TMshRN0m1OW12vUEz3r/62famGu1LSq+BXeD5/pFAClO4E6zNki/VK3NMUy3yUR7yVMVbhz5NE9az+lzjCMXtu1bg6m9SFv6wf0NuaHK2S7dlRmU4jvdSduQLNzj0ci/uhqDxzOFq6nre+lKUk8X2nj4=;7:JnJxcqqoUA+qfCksrgNIsG77fYdrPxqROldlTU2Yaoyx+PWW9pX0BNVM1WVJNgz46//PwrcBDS/L4JjHv9JDFcy7SnNwJniFLiyYq8AjDcMUdev5SYQ34QDXPIsq0FFFggDOREFAHceJurB6JNRWww8nNvoTXnZlMPY+7LnBsUtXnsgjUr4njrhB5cadm7Y/16YR3b7N6o+TdEeCMvN47r6XZCZ23h+Y/TysV24Ve1c5wQco+JBEUXPm3hIi5efL
x-ms-office365-filtering-correlation-id: 7e19188a-e1f1-4c34-e66b-08d628490f88
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5092;
x-ms-traffictypediagnostic: BL0PR05MB5092:
x-microsoft-antispam-prvs: <BL0PR05MB50928F209753899B9BB5D975A3E80@BL0PR05MB5092.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(20558992708506);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991041);SRVR:BL0PR05MB5092;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5092;
x-forefront-prvs: 0813C68E65
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39840400004)(136003)(396003)(376002)(366004)(346002)(189003)(199004)(478600001)(97736004)(256004)(386003)(6506007)(2501003)(5250100002)(305945005)(86362001)(1076002)(6512007)(316002)(52116002)(99286004)(8676002)(14444005)(6346003)(4326008)(26005)(36756003)(2616005)(6436002)(76176011)(102836004)(6916009)(2906002)(105586002)(106356001)(2900100001)(14454004)(446003)(476003)(6486002)(5660300001)(103116003)(71200400001)(6116002)(7736002)(186003)(486006)(71190400001)(3846002)(81156014)(11346002)(81166006)(68736007)(8936002)(2351001)(107886003)(25786009)(66066001)(5640700003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5092;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-message-info: FAbW91jsz1ju5OI1dz+JSMoVmrAvPRNE/hLDEF7iNLoktsCdiK0w1oW5k7CGUoNp/qzFH0RfnCVVzm6khfYbpDXobLqGBlHU6AyL1NjJj101zsrTIlbK3TAqqNVQQTl6bK+1ZsdQD4C5QQ18XYWsYJ//xkcnGez0PGziD0ndW2O8jrtiyD4WcHmD1KNK98dFCEEVPZc4kTpo3HOm7pqbu7mtENJDui4iWnoJAngVwNXXRQOxD3xChnOuN44f1LsNCOs/vr0uDW6aryvkPnI6875w3j9i0Zb76x7bBzkg7auAEI4qK8Cf3WqKBsolmUAa4IlNNnVh1GjA3/HA0uRsHhJd0v0/MZHUqvCWLCXIzKc=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e19188a-e1f1-4c34-e66b-08d628490f88
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2018 09:25:58.1590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5092
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

