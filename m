Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8104CC04EB8
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 429242082F
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="IrrgTFvO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 429242082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbeLBSCt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:02:49 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39776 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbeLBSCt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:02:49 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="24754996"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Dec 2018 11:02:47 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:02:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MjrTeDt1jZFIEHycKahQPpYawtMBYp45QJpMAQN+H+E=;
 b=IrrgTFvOy6Zkix4IVDsXhvxDVVkpC6aEk9SfSdnRQShCIebLCoJq3LTQIynstMBa/PnsuuQBhD/Jp8D8+Fbkdi1Y4055e1PWwyQ4SZKcuR2E01iCQ4GL4obr2LJLwZH2iHQw487Us9aXaJywvPlsMEhN0BJw2GZSOIgC3W2E+OY=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2806.namprd11.prod.outlook.com (52.135.228.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18; Sun, 2 Dec 2018 18:02:45 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:02:45 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 11/29] staging: wilc1000: handle delete beacon cfg ops from
 cfg80211 context()
Thread-Topic: [PATCH 11/29] staging: wilc1000: handle delete beacon cfg ops
 from cfg80211 context()
Thread-Index: AQHUimk6m4xaZYq6oUiIA/wAs8jokQ==
Date:   Sun, 2 Dec 2018 18:02:45 +0000
Message-ID: <1543773663-20561-12-git-send-email-ajay.kathat@microchip.com>
References: <1543773663-20561-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1543773663-20561-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0063.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::25) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [183.82.18.98]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2806;6:oiJWj+h/+lvRGprgoSpaqr8p/lPyBpOIkf5Mo1UfqfW68xNswGnL4JG8mNkCvnGti6OLVr0YDYVVHUoxl2XItn2CNQODSnL7/vAmdNp5MFb79Mg3WRqXDTsbh167z8tvhxzDmz4Rhsq8xCYO5Z/J9D+qSxfYK0S5bRgUmLePtV8JRDzQE1nIHwRraTeKCzS67wJtb6d7zZt9JKa4UeirU18bu+FTtQc+M3fyTzYQXp/eMxYazb52dqI7uwFLEQZljrM7daqwvPJUo4SWL3xG7blzuYndO14ufnYf3ugr7KdE0HbhpbVNiv0GSERAGO9FbsqEfsALZhwTqZcB+uvLpAPCRl1MUcVzlpsF88TWfOUeomFEYVcA4Gx4UBC5wBPGXKYjwk7MAkbOyEJa6Y9MBszw9Kc/dJLjs4k4ZuqALLpN7ILxohHhzbRkvazRP5bnHHKJrBn3V4KW+DC4Kw47hg==;5:QpMCYSVnseTyG1s/hZ7GNmhyR8ioIom8VhtIciHs9RMk/aK2RqupZP1CDsb0ror8o9e/k0wWI+j9IBISOHEpbigvZaagmGtir/MmX8p7zXNxDNIAPfdJ/yfR/I69hlFriAyD/WXdyIRuqeo6lYLvz1u49bmlkwrrlYrGJ5F456k=;7:jn5jW4KPSw4d1vLEhm6FaDlMFH7HFx9LRXeekBz4HZ48KnYJHt5gCWkbJZoyrTkNOH+mU40xjt+PEgWMUFiQtkAOUaqIjBWrV9gWwUbxQJJtXmAQ5eMAllGx04sLHKSOMWQwh9G9DeBR8lELjd9zVw==
x-ms-office365-filtering-correlation-id: 9cc8e05a-fab8-4d7a-d02e-08d658805cab
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2806;
x-ms-traffictypediagnostic: BYAPR11MB2806:
x-microsoft-antispam-prvs: <BYAPR11MB2806607044CECCF55E0139FCE3AD0@BYAPR11MB2806.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(10201501046)(3231455)(999002)(944501491)(52105112)(148016)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2806;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2806;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(199004)(189003)(186003)(4326008)(7736002)(26005)(14454004)(2906002)(107886003)(305945005)(386003)(53936002)(6506007)(36756003)(76176011)(6512007)(71190400001)(52116002)(71200400001)(5640700003)(14444005)(256004)(3846002)(6116002)(99286004)(5660300001)(78486014)(6486002)(446003)(11346002)(486006)(86362001)(105586002)(8676002)(97736004)(68736007)(316002)(2616005)(6436002)(476003)(54906003)(66066001)(25786009)(102836004)(81156014)(81166006)(8936002)(72206003)(2351001)(2501003)(478600001)(6916009)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2806;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: yCDkGkiWDyjFrYBIcgAkNLJXcOC2egZKr8ulSz1Q3d/cd94I76fQWT3Jy6LOHen5OmyqXlryzmszytHFjpJ1gcYBcdxr6MThxB1G4zZxZi0HO+/NO/14RXfmwSvJie0617CKGYyc+CHWa39i1bebTz86u2gvhrNth02sFoBI0DRv3VqTfMgmxzbQhbHgmKLUWxmWKKE4B9SBdBVnvmIS3ImGdWKJ8VEgCM/sxtgtiiQVp13fwQvm0OAzSRAlxjlACUV1S2W0R2/zCzh1hjQVcn2pq9sbsr3pXxgUPZD1B3gMM8Iky8TB2ETVVrg099n+WwOkMq+npSZ5gbNgvq4APv+UG1EtYtN1U4Jhc141cJs=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cc8e05a-fab8-4d7a-d02e-08d658805cab
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:02:45.7869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2806
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Refactor the code to handle delete beacon cfg operation from cfg80211
context.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 39 ++++++++-------------------=
----
 1 file changed, 10 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 310138d..995ca65 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1934,26 +1934,6 @@ static void handle_add_beacon(struct work_struct *wo=
rk)
 	kfree(msg);
 }
=20
-static void handle_del_beacon(struct work_struct *work)
-{
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-	struct wilc_vif *vif =3D msg->vif;
-	int result;
-	struct wid wid;
-	u8 del_beacon =3D 0;
-
-	wid.id =3D WID_DEL_BEACON;
-	wid.type =3D WID_CHAR;
-	wid.size =3D sizeof(char);
-	wid.val =3D &del_beacon;
-
-	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
-				      wilc_get_vif_idx(vif));
-	if (result)
-		netdev_err(vif->ndev, "Failed to send delete beacon\n");
-	kfree(msg);
-}
-
 static void wilc_hif_pack_sta_param(u8 *cur_byte, const u8 *mac,
 				    struct station_parameters *params)
 {
@@ -3326,17 +3306,18 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 inter=
val, u32 dtim_period,
 int wilc_del_beacon(struct wilc_vif *vif)
 {
 	int result;
-	struct host_if_msg *msg;
+	struct wid wid;
+	u8 del_beacon =3D 0;
=20
-	msg =3D wilc_alloc_work(vif, handle_del_beacon, false);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
+	wid.id =3D WID_DEL_BEACON;
+	wid.type =3D WID_CHAR;
+	wid.size =3D sizeof(char);
+	wid.val =3D &del_beacon;
=20
-	result =3D wilc_enqueue_work(msg);
-	if (result) {
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-		kfree(msg);
-	}
+	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1,
+				      wilc_get_vif_idx(vif));
+	if (result)
+		netdev_err(vif->ndev, "Failed to send delete beacon\n");
=20
 	return result;
 }
--=20
2.7.4

