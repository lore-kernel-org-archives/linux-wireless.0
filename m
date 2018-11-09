Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E621C0044C
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 18:20:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E015920855
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 18:20:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="fSXjsxmr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E015920855
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbeKJECE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 23:02:04 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:59961 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728492AbeKJECE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 23:02:04 -0500
X-IronPort-AV: E=Sophos;i="5.54,484,1534834800"; 
   d="scan'208";a="22615795"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Nov 2018 11:20:19 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Fri, 9 Nov 2018 11:20:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JgnxwWXDopj28kybctKRII3R99URFSkCrlKSACLf6pA=;
 b=fSXjsxmrYV6yhpvs0yio0IIzqg+bUXxxnjOuHw9xVB/6VsksLVNY9tY58KEiduEiEgic2lqXu65CKtdKqcDfwib4xcDSSMbIVpl+1QofQNWrSD/Zi3X22eWmju2CYURu79Cel/J0ZmrBAOmaSFkTqCi4MR79BcUASZL63cGgH3c=
Received: from SN6PR11MB3407.namprd11.prod.outlook.com (52.135.111.96) by
 SN6PR11MB3392.namprd11.prod.outlook.com (52.135.111.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.26; Fri, 9 Nov 2018 18:20:17 +0000
Received: from SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::7d22:c5b8:9e2e:2281]) by SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::7d22:c5b8:9e2e:2281%2]) with mapi id 15.20.1294.034; Fri, 9 Nov 2018
 18:20:17 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <johannes@sipsolutions.net>
Subject: [PATCH v5 3/3] staging: wilc1000: Remove unused mutex cfg_values_lock
Thread-Topic: [PATCH v5 3/3] staging: wilc1000: Remove unused mutex
 cfg_values_lock
Thread-Index: AQHUeFjdxx6+NtqwyEiUTdSV2ak5gA==
Date:   Fri, 9 Nov 2018 18:20:17 +0000
Message-ID: <20181109182008.4328-4-adham.abozaeid@microchip.com>
References: <20181109182008.4328-1-adham.abozaeid@microchip.com>
In-Reply-To: <20181109182008.4328-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::24) To SN6PR11MB3407.namprd11.prod.outlook.com
 (2603:10b6:805:bd::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB3392;6:ExxwZUt1B3WYKaX+1FOHxn6XfmQUXG0R887mqotxzXqiklBD+UwwLzfiF+9141FtTvtUU7eKMPf7BA2rrSqVtwYJ2sPXRnCyyhg7afDqpoHbMwwBbJNABp5XzHEK3exCIlA1B1vppOM4CKeGisLgQROCvbTrLbFcB05RBHDvknxseGwf82w7VnBJkc3db/TPCrb0l1kX9MhrmkAoY3sG4iaG2EkqIGbcrOGmcz/qByWUILS8EG5qQiOA7LHBUAdYYQ5OxlyUrFEE3I0oCg7WKn/Bj1sl43zuywcw9VI2FPVVZs5/1x2TwtJReon6n0fAGHDhxMAdNvaeZy7bPPOx9EwfQBR0hiJUQ9K24R8XjKRCm6rhqLwfXCM9zCU6AKns1dptQej1K6S33OTHB5M0jexRnJE0DIYeOOH/YlcGbQruvXVOWRtQql777Qw9e8cmH7ra/i7dG/bbyNklQabMoA==;5:YW9rjBhACN7RGjdv2y6D2DbbDVk7ynKu3kDI0Dd+JeX2VA8ouPvfd4gplw/Ia0bWGjceiyOuw67aQIDQ2u0WwYSSPJO4VEKW0HG2MUYSsDkpTVyBcguHmEKDf5C78jJ8dSO4zUf+wvWF5DHxMdTrAr6gM1srbQnGKEWzE4CKFL8=;7:SfWHD3NvqBNKfm3Lbs1aeENe4Xg+b26HUqLjL/jGRRW4be+NV1PZ4XVNAenBplQbNL+go06nTvknIcPaLVjg6bh7Ft71tKQrpz8lmivS+nJCap5VIxSyNQiUcX67H6DsyXtiAYLlGbNktXRJRGip6A==
x-ms-office365-filtering-correlation-id: 7c508456-f853-49f9-2119-08d646700016
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR11MB3392;
x-ms-traffictypediagnostic: SN6PR11MB3392:
x-microsoft-antispam-prvs: <SN6PR11MB3392D8D6731D4B74F52855BB8DC60@SN6PR11MB3392.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(21532816269658);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123564045)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB3392;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB3392;
x-forefront-prvs: 08512C5403
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(396003)(346002)(376002)(39860400002)(199004)(189003)(14454004)(5640700003)(6436002)(386003)(52116002)(102836004)(76176011)(14444005)(53936002)(256004)(2900100001)(81166006)(2351001)(6512007)(81156014)(6506007)(4326008)(72206003)(36756003)(25786009)(6486002)(8936002)(8676002)(71200400001)(478600001)(68736007)(2906002)(1076002)(86362001)(5660300001)(6116002)(6916009)(3846002)(71190400001)(66066001)(476003)(2616005)(105586002)(11346002)(446003)(26005)(106356001)(99286004)(486006)(305945005)(54906003)(2501003)(316002)(97736004)(186003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB3392;H:SN6PR11MB3407.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: fFw0mWWD+WxAp3KyXXrDaiBds8mOWbUZDDRaKif1a9i51g5M0JvH/rUnEbaW8Tw4V3KPnPMMHrvbsG40Pz969Q+vDVtstJrmG7EIygVijSFnIwDlIdCMpGO1Ol5tSfDogLi5abG8zCu7hz3U5N4gsLFbDj9dqT04HeuWTtG/MB0VZVqrnVIHnIkr+tYVYzih5PzhBwksq87OoEt6uuSqoAJ5DkowDjXCWFfF85vTFIPPenFL4F9q1Mx9EqxjIB40RJv9xpz2FQ9grkmXF1CpUG4jeeXIOvalei7my7o58+wyeJmHoPbfrkRrBiONat548AqnBjKz19CddO3VqKNYa+MFucd9yndaTKyHOR3O1fk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c508456-f853-49f9-2119-08d646700016
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2018 18:20:17.3423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3392
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Adham Abozaeid <adham.abozaeid@microchip.com>

After removing cfg_values member, cfg_values_lock that was used to protect
it can also be removed.

Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 9 ---------
 drivers/staging/wilc1000/host_interface.h | 2 --
 2 files changed, 11 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 8d1142776310..2bf91df1ded1 100644
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
@@ -3240,15 +3236,10 @@ int wilc_init(struct net_device *dev, struct host_i=
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
index 1e2e50e91f76..523b46bfb488 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -293,8 +293,6 @@ struct host_if_drv {
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

