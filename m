Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B6EC64EB4
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B117F2080A
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:03:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="TMK5Z9Fo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B117F2080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbeLBSDi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:03:38 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:63046 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbeLBSDi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:03:38 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="23749614"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 02 Dec 2018 11:03:36 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:03:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uWg16O5cFn6MJ9BPk5f9KcOhdZT9bSi5AiZUi88yqT8=;
 b=TMK5Z9FoUK4ahr/9SSU3NqXG50OHQ3T89ud4aQfcrQGshIyvoBILR+yMFPKwOdhdI8EQnH30rdxTQya9O1uBtrxm2ThB5v8lKzC9YDo6pM8q9F/hWWOhJRWF0FXHc53Wi88ogNTk0MbaW9xYR1xawJC37CgpLmQS3AuDxyHE564=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2806.namprd11.prod.outlook.com (52.135.228.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.18; Sun, 2 Dec 2018 18:03:22 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:03:22 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 24/29] staging: wilc1000: handle remain on channel cfg ops
 from cfg80211 context
Thread-Topic: [PATCH 24/29] staging: wilc1000: handle remain on channel cfg
 ops from cfg80211 context
Thread-Index: AQHUimlQakLtXRwGtk+e0/s+Yut5pw==
Date:   Sun, 2 Dec 2018 18:03:22 +0000
Message-ID: <1543773663-20561-25-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2806;6:N1AQA+06PVlTtcCzglTqEGRLpPyE8oPKo8KO4IO1roafrViPz0z17S/T+/vRh4e96ZLoiVXos040A0dfXOo6lRPvNiBg3+HNZCQA34B2ZxkpoYOjZ4HYeV9iyFUZRQlOE8jGqwZt0nhc3abNNzYovGv96wU6+LPKULZrmAnJ1/dSkK8Dv5HgvOLezEX9NFBITC923MjC2gg7EmzV69qMnxDXZRfzRq+trBMZBRai9odrCGZpk7yAxd9MUQ28soQxlhsUTcD3CX6nRaNOrUs7ZOHKZzjYYLXA6JpTDy4awXqARY2l3kD2Ipo5PGhvhSqkutJ0qnPEY8ba5MlLW69qh4Z4HL/X8z3F3s9iGB/9a3kDRbtjY+fMTYXp0eh67bU69Ts7ugeRlDVDkml+iyaxd8L5vZmIYd2w+SBLSjzrSPao40i2+P8TVOIJmzzh/EUkjcv0VraoP5IqMb2px5Ianw==;5:I12uoktjZGbrMKizBpjaXYlbmelJzvFRjSZpdUMVCpTSa/tKOeQMsecsf0oKK6H5Xup222Q5xq8t9heBkHj8lceAANz3gpCOpJquo6IVWcmwfKwIcKcXCMplnusP8Qqb9p61lTozmsOLygaExuSGKLDoCGUADwoIuNUsBYfXoSk=;7:WtcTVNZXuaU3AluOSvtMybMrNFRn5Au1E2K+jZmTx/Q9wW12ijURH9uMVCYCAJjIbht9i4sQca7Q417JrmPplFQBi7f6dAyLvJc7ag1RrTHu+I3ZFUSwCJEbMwYQdLKOOPg0CB3LfeCtrYtAvs1bQw==
x-ms-office365-filtering-correlation-id: 3811ee8a-6186-48e2-c40f-08d6588072c8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2806;
x-ms-traffictypediagnostic: BYAPR11MB2806:
x-microsoft-antispam-prvs: <BYAPR11MB2806F786BFE37D3B03DA6F95E3AD0@BYAPR11MB2806.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3002001)(10201501046)(3231455)(999002)(944501491)(52105112)(148016)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB2806;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2806;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(199004)(189003)(186003)(4326008)(7736002)(26005)(14454004)(2906002)(107886003)(305945005)(386003)(53936002)(6506007)(36756003)(76176011)(6512007)(71190400001)(52116002)(71200400001)(5640700003)(14444005)(256004)(3846002)(6116002)(99286004)(5660300001)(78486014)(6486002)(446003)(11346002)(486006)(575784001)(86362001)(105586002)(8676002)(97736004)(68736007)(316002)(2616005)(6436002)(476003)(54906003)(66066001)(25786009)(102836004)(81156014)(81166006)(8936002)(72206003)(2351001)(2501003)(478600001)(6916009)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2806;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: KTWgh5WYylorvgbamg7CRWFwME4whA6YfAveFFHBv0frQI39T1nnt7foxJzQdeJv3NAfUR8tshsk7Pb98Ma85wep3zFXN9DZnBgSRFBp3WlFX0Cbkk/BA/JEzqb/wTdgO9d6gYz4XTnpI06Gj4aDnirubcp72WTMkCQsNO6eDByoQXEE5mV5gcW2x4DlxM8/smkUR11b3KKkxVUstZUE3dG5xUbBI+ccnXl+yZIwTI417t/9+qVC6sIqRATRfCdmGu54PUJYaKhjkkKJGfnW93cFiUcUScykbwp3ySCSMz6kWZ53RJSZ38dzwHqI8A8p1Q8YDOWZBtD14qxH32XRmWSpkUF9VcSJUfTfk+gqYko=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3811ee8a-6186-48e2-c40f-08d6588072c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:03:22.7954
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

Refactor wilc_remain_on_channel() to handle remain_on_channel callback
from cfg80211 context.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 36 ++++++++++-----------------=
----
 1 file changed, 11 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 9139e0e..4762925 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1592,14 +1592,6 @@ static void handle_scan_timer(struct work_struct *wo=
rk)
 	kfree(msg);
 }
=20
-static void handle_remain_on_chan_work(struct work_struct *work)
-{
-	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
-
-	handle_remain_on_chan(msg->vif, &msg->body.remain_on_ch);
-	kfree(msg);
-}
-
 static void handle_scan_complete(struct work_struct *work)
 {
 	struct host_if_msg *msg =3D container_of(work, struct host_if_msg, work);
@@ -2527,25 +2519,19 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u3=
2 session_id,
 			   wilc_remain_on_chan_ready ready,
 			   void *user_arg)
 {
+	struct remain_ch roc;
 	int result;
-	struct host_if_msg *msg;
-
-	msg =3D wilc_alloc_work(vif, handle_remain_on_chan_work, false);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
=20
-	msg->body.remain_on_ch.ch =3D chan;
-	msg->body.remain_on_ch.expired =3D expired;
-	msg->body.remain_on_ch.ready =3D ready;
-	msg->body.remain_on_ch.arg =3D user_arg;
-	msg->body.remain_on_ch.duration =3D duration;
-	msg->body.remain_on_ch.id =3D session_id;
-
-	result =3D wilc_enqueue_work(msg);
-	if (result) {
-		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
-		kfree(msg);
-	}
+	roc.ch =3D chan;
+	roc.expired =3D expired;
+	roc.ready =3D ready;
+	roc.arg =3D user_arg;
+	roc.duration =3D duration;
+	roc.id =3D session_id;
+	result =3D handle_remain_on_chan(vif, &roc);
+	if (result)
+		netdev_err(vif->ndev, "%s: failed to set remain on channel\n",
+			   __func__);
=20
 	return result;
 }
--=20
2.7.4

