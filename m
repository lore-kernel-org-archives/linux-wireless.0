Return-Path: <SRS0=+bZT=NF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99276C46475
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 21:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 418632083E
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 21:11:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="P5dYYxfJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 418632083E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbeJZFpZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 01:45:25 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:49536 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbeJZFpY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 01:45:24 -0400
X-IronPort-AV: E=Sophos;i="5.54,425,1534834800"; 
   d="scan'208";a="22149273"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 25 Oct 2018 14:11:06 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 25 Oct 2018 14:11:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EjFV2HqVoYcPVzMqSGgCUwrf+z1VaITyyp20GZlbdZw=;
 b=P5dYYxfJztgBp9F02HT24WnR45PaLGBZKdFDPjsMm4uKeqG4eUolx1RXAIi2AMA5neq69iq6VUB9MdBsrhn6nuz8ccH/bvrJCHUQ8G/oaxNpvGdyko09vvHM6GKqMMOXEDm3RL29OqNdqLLFZhnhhrW1ND0IhkM7pNKBeyICwfY=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0350.namprd11.prod.outlook.com (10.160.136.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.18; Thu, 25 Oct 2018 21:11:04 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e%10]) with mapi id 15.20.1250.028; Thu, 25 Oct
 2018 21:11:04 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Venkateswara.Kaja@microchip.com>,
        <Aditya.Shankar@microchip.com>, <Sripad.Balwadgi@microchip.com>,
        <Mrutyunjaya.Satapathy@microchip.com>, <johannes@sipsolutions.net>,
        <Adham.Abozaeid@microchip.com>
Subject: [PATCH 4/4] staging: wilc1000: Remove unused mutex cfg_values_lock
Thread-Topic: [PATCH 4/4] staging: wilc1000: Remove unused mutex
 cfg_values_lock
Thread-Index: AQHUbKc8fTgDDKcLq0GQb4foxioQKQ==
Date:   Thu, 25 Oct 2018 21:11:03 +0000
Message-ID: <20181025210849.20006-5-adham.abozaeid@microchip.com>
References: <20181025210849.20006-1-adham.abozaeid@microchip.com>
In-Reply-To: <20181025210849.20006-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR02CA0030.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::43) To DM2PR11MB0255.namprd11.prod.outlook.com
 (2a01:111:e400:3c24::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0350;6:AOlUCb5PDWJ9snIJYdWi00rrJkGYrpDBhQuWzRNVQv7QAGwm00tARRBtJBHQA2lo6pImk8heD1C+1zWUZQDmGRZPeYOaGqfUlZO12Ix9SAgxIdEhIVaivabDkuh0imZd5eJBfW/mi1J62vX89udh85qxRiGSW7ryoCjwqiggBpBjD6ujJT9dvB6tVpPhWOp2c49XXCBlLdEZ5Zuvci2IfhFnYn1gYpPLj1VaVZ/dVYE20lCsRufoYZ+zZjyy1x0xr3XnpWvdicreVsu3JkflL3qzfaVqH12ohFyKHKwTb+xH3qeFPVU7EGZ4fAXTVxbkzKKcB14QVlzGQGSOJ8LJYmYOEEDR6LCmYJicWbIPsOoQAcFwqIU1YgOv+x1ciYXckW2wNJ2WeKO6vai1mWYvc3C1Knlq/xnHnZBcY9nZ0aRmkhW9uzfCkDouC9EjYwgX1+xL6lm2KEt/f+xwqALKXA==;5:v4iYNvtpnqnE8LwLyOebQ5Kg4E7mZZGPjp+QePGN/1wn3IIllSTnCzOckeAaEyi8Z5A1eIu2ZotQqwzB3I6AY+IUap4MNe2LYbruMbJG+q3eYSe1hH0Cof3iVpR12mcu6xlXQbOWXkMwUcMDW5ugNiZZSR/VW6n8rbptLtUZNts=;7:1C7Oc3HrM0CoTKQkPytS3xMAfCNjvztTArF+FbD3/fUIZT6XXQ0GtYX3f53u6rESNq2U1mIzbHclfjXNSoXpLpuTN1AWEiQWQx/EA7DhIVt7FzolHY2jxu8LQsGZcEN3NC7b/vz7RBE8MufMd/c8wA==
x-ms-office365-filtering-correlation-id: d6023fda-3db8-4773-702e-08d63abe5f25
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0350;
x-ms-traffictypediagnostic: DM2PR11MB0350:
x-ld-processed: 3f4057f3-b418-4d4e-ba84-d55b4e897d88,ExtAddr
x-microsoft-antispam-prvs: <DM2PR11MB0350D7B11BB0116D0A3309578DF70@DM2PR11MB0350.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(21532816269658);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231355)(944501410)(52105095)(3002001)(93006095)(93001095)(10201501046)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:DM2PR11MB0350;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0350;
x-forefront-prvs: 083691450C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(386003)(11346002)(6506007)(2900100001)(14444005)(3846002)(6116002)(71200400001)(446003)(68736007)(36756003)(81166006)(5250100002)(81156014)(2906002)(2616005)(476003)(4326008)(71190400001)(1076002)(5660300001)(52116002)(105586002)(86362001)(8676002)(256004)(478600001)(76176011)(66066001)(99286004)(26005)(53936002)(102836004)(6512007)(54906003)(2351001)(2501003)(316002)(25786009)(97736004)(106356001)(72206003)(6436002)(5640700003)(6916009)(14454004)(305945005)(186003)(107886003)(8936002)(6486002)(7736002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0350;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: CUjgyei/qoA97NNrD1ydIfjGg/0IOyGMgJGSD6WrEuSBV6L2TEcjer4nTg7w5HNZDJz66BFUfO17bY2gsRMLI3g180v1cMJOrnsfpkdl4+VGorhQji0HDXcdhrn45IyYerWtM8LWkL5vHP8QbmvxSyLMR/lax41UC27WyoPCax188X80thzaI4fvBRO/js5XPT2da6jGOCwKc1D1RH1aXq1n65AUrULmtkz3e5KT3DI5mEwQmyX6EOeiOvnmBlB6MDRATanqk0DDIUedw8/1iw342LxpY7LKdDE4c4J6Oa6Rt2/Z2pGTUCHBEQYzTlEtJ62l7xUauDEDD58zUz9Lg/MajMoS4nsTHy64vtVKXX0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d6023fda-3db8-4773-702e-08d63abe5f25
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2018 21:11:03.8884
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR11MB0350
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

After removing cfg_values member, cfg_values_lock that was used to protect
it can also be removed.

Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 9 ---------
 drivers/staging/wilc1000/host_interface.h | 2 --
 2 files changed, 11 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index cdc495287949..165330b494f5 100755
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -369,11 +369,8 @@ static void handle_cfg_param(struct work_struct *work)
 	struct cfg_param_attr *param =3D &msg->body.cfg_info;
 	int ret;
 	struct wid wid_list[32];
-	struct host_if_drv *hif_drv =3D vif->hif_drv;
 	int i =3D 0;
=20
-	mutex_lock(&hif_drv->cfg_values_lock);
-
 	if (param->flag & RETRY_SHORT) {
 		wid_list[i].id =3D WID_SHORT_RETRY_LIMIT;
 		wid_list[i].val =3D (s8 *)&param->short_retry_limit;
@@ -409,7 +406,6 @@ static void handle_cfg_param(struct work_struct *work)
 	if (ret)
 		netdev_err(vif->ndev, "Error in setting CFG params\n");
=20
-	mutex_unlock(&hif_drv->cfg_values_lock);
 	kfree(msg);
 }
=20
@@ -3123,15 +3119,10 @@ int wilc_init(struct net_device *dev, struct host_i=
f_drv **hif_drv_handler)
 	timer_setup(&hif_drv->connect_timer, timer_connect_cb, 0);
 	timer_setup(&hif_drv->remain_on_ch_timer, listen_timer_cb, 0);
=20
-	mutex_init(&hif_drv->cfg_values_lock);
-	mutex_lock(&hif_drv->cfg_values_lock);
-
 	hif_drv->hif_state =3D HOST_IF_IDLE;
=20
 	hif_drv->p2p_timeout =3D 0;
=20
-	mutex_unlock(&hif_drv->cfg_values_lock);
-
 	wilc->clients_count++;
=20
 	return 0;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 60cb1a1fee1a..c78e0682a248 100755
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -238,8 +238,6 @@ struct host_if_drv {
 	enum host_if_state hif_state;
=20
 	u8 assoc_bssid[ETH_ALEN];
-	/*lock to protect concurrent setting of cfg params*/
-	struct mutex cfg_values_lock;
=20
 	struct timer_list scan_timer;
 	struct wilc_vif *scan_timer_vif;
--=20
2.17.1

