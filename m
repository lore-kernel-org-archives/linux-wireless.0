Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70780ECDE4C
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 21:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A46E2081C
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 21:50:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="bam4xG0f"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A46E2081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbeKIH1y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 02:27:54 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:31324 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbeKIH1x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 02:27:53 -0500
X-IronPort-AV: E=Sophos;i="5.54,480,1534834800"; 
   d="scan'208";a="22570809"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 08 Nov 2018 14:50:27 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 8 Nov 2018 14:50:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zzpIAdbhOE52KmbDJxdPd0Pa7aLWv1G2ZBzX24foXSQ=;
 b=bam4xG0f64TL0rFkxpna1ZBmjIYWIF+uJ/yhFqik2vPt+/el1q7wQxMOgD9qZL4fq7YyZ0U57PVdh0vSSdmBSRsHUpRcYg3y/ivhrEhxJj3wq59HoJgKQwGonsrgaq9np8TX+r1JW+QIefPSJ9UGiJZLqiRcrUpTHmYMnmdZofM=
Received: from SN6PR11MB3407.namprd11.prod.outlook.com (52.135.111.96) by
 SN6PR11MB3488.namprd11.prod.outlook.com (52.135.112.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.30; Thu, 8 Nov 2018 21:50:26 +0000
Received: from SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::7d22:c5b8:9e2e:2281]) by SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::7d22:c5b8:9e2e:2281%2]) with mapi id 15.20.1294.034; Thu, 8 Nov 2018
 21:50:26 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <johannes@sipsolutions.net>, <adham.abozaeid@micochip.com>
Subject: [PATCH v4 2/3] staging: wilc1000: Don't keep a copy of wiphy
 parameters in the driver
Thread-Topic: [PATCH v4 2/3] staging: wilc1000: Don't keep a copy of wiphy
 parameters in the driver
Thread-Index: AQHUd60Ox6nih17oSEq0nQPk5STKLg==
Date:   Thu, 8 Nov 2018 21:50:26 +0000
Message-ID: <20181108214915.3733-3-adham.abozaeid@microchip.com>
References: <20181108214915.3733-1-adham.abozaeid@microchip.com>
In-Reply-To: <20181108214915.3733-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR07CA0013.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::26) To SN6PR11MB3407.namprd11.prod.outlook.com
 (2603:10b6:805:bd::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB3488;6:Z6hd6bGkx4kmiuY7VlrnptT0O19TTg/Dfe2oqS5aURFZ/lLCrjPA2dgTshJPL+oEFTd7zaqPgPJ8ppHAK6q7+C9H3Tqf5M4B7EX7eMWe0CIkalX6OI7JDnU+6xlTgaI/rHqPvebiro93bdZDGxMlktkSFLAhAUpW3BBVaNfD9ApjvAmdlSyuTIeYSkPSLoaip0eep2xOFrr47ZEIXx9vT4Pma7akcKsJxGVIxDhT0Ed3N7wUNYxT109e7TSInmnPGT3PpA5mtzeF1haOMkb0SKUpConYhk6HGadt5qTU4EUdtGYKwPHrPpOMq4JfUBqM8e4uTIpBomKMWgjA7wXTiR9HrdX5Y1173C/zGFhS9jgmdwmp4DXlZFtcbKYh8rgimSyb0TseKnPOVBK6IIy/2PhzrVZq+Y2AI3O4gRFnoWSrmqNb6TXATw+/y9GfsURiRCWQKwj9jsXgiGF1eDXWOg==;5:H+P/h3hbt0DPcAH7zRu17UO5KjojF/jBbPHF/bDcQ1qAmFLTOuVC0O5cSU8aivWtwJqxQn8emELD1SSCfp2iqwjWQWTjt9Cvn9OijGat31LaKMffnLr5C6Fwg7v47xwqDBGNbG3Y4FGeHrJ0noVr+k6gmRxLiBtYbeIS4+l1+0A=;7:QaefpSpkPdwuwQMnTi4S5GDBUSCxpaIzLr6m4v2OtNGF6IYf3XpT5t9gVEF77+9gKad0ulqVQMVvH6vRliCZJKSl5qQBGqOTV6Rl7skKV/tCtdDFbFf6epCyJmIz9iGTIu1PdZIGwtL5BpZuWEPF6Q==
x-ms-office365-filtering-correlation-id: 80644751-5e3f-45da-a457-08d645c43115
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR11MB3488;
x-ms-traffictypediagnostic: SN6PR11MB3488:
x-microsoft-antispam-prvs: <SN6PR11MB348895AD66BD0E9CD2258FC98DC50@SN6PR11MB3488.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123562045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB3488;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB3488;
x-forefront-prvs: 0850800A29
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(396003)(39860400002)(136003)(376002)(199004)(189003)(5640700003)(52116002)(76176011)(386003)(6506007)(1076002)(6436002)(14454004)(6486002)(25786009)(7736002)(6916009)(99286004)(305945005)(6512007)(81156014)(81166006)(66066001)(8676002)(186003)(8936002)(478600001)(68736007)(97736004)(26005)(2501003)(5660300001)(53936002)(3846002)(6116002)(102836004)(4326008)(106356001)(71200400001)(71190400001)(476003)(105586002)(2351001)(2616005)(54906003)(316002)(14444005)(486006)(86362001)(256004)(446003)(2906002)(36756003)(72206003)(2900100001)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB3488;H:SN6PR11MB3407.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: GSek9Us83DG7ovFcJarbTllaXlMqaWN334O0Ui6Ewp/WgPUxcP8DFaJkgE5piAxFl7OwWpXTelj2/2aXA3qbN43f0t1D9njZgo2EqZC6tMfA5yogVyJ0oFs+GCtm8k/9kAAL2XMRZXasctNUDhreMyUzbvCTi+yaniuEV5WhSvZkJF6h+5xWa4pfUyYxR/xOrXPLNkwP/Wn1hOhv1rDqhg61miX4HgfhbU6YsulOAQIzOaAnZRxaZNUPImOmnF1bmOIZG3zwEXe9TTcAmWp3UbO8Yavwbd+rNYcC7yCrxy8Aa2YK2qL2pxnZqWTRwjkkZqJoZ9YS3qgHfTjGDrDS7UMbgwQnocHRr1SRzXvbfxo=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 80644751-5e3f-45da-a457-08d645c43115
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2018 21:50:26.1099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3488
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Adham Abozaeid <adham.abozaeid@micochip.com>

From: Adham Abozaeid <adham.abozaeid@microchip.com>

host_if_drv.cfg_values is a write only member, and can be removed

Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 13 -------------
 drivers/staging/wilc1000/host_interface.h |  1 -
 2 files changed, 14 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index c1215c194907..8d1142776310 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -375,43 +375,31 @@ static void handle_cfg_param(struct work_struct *work=
)
 	mutex_lock(&hif_drv->cfg_values_lock);
=20
 	if (param->flag & RETRY_SHORT) {
-		u16 retry_limit =3D param->short_retry_limit;
-
 		wid_list[i].id =3D WID_SHORT_RETRY_LIMIT;
 		wid_list[i].val =3D (s8 *)&param->short_retry_limit;
 		wid_list[i].type =3D WID_SHORT;
 		wid_list[i].size =3D sizeof(u16);
-		hif_drv->cfg_values.short_retry_limit =3D retry_limit;
 		i++;
 	}
 	if (param->flag & RETRY_LONG) {
-		u16 limit =3D param->long_retry_limit;
-
 		wid_list[i].id =3D WID_LONG_RETRY_LIMIT;
 		wid_list[i].val =3D (s8 *)&param->long_retry_limit;
 		wid_list[i].type =3D WID_SHORT;
 		wid_list[i].size =3D sizeof(u16);
-		hif_drv->cfg_values.long_retry_limit =3D limit;
 		i++;
 	}
 	if (param->flag & FRAG_THRESHOLD) {
-		u16 frag_th =3D param->frag_threshold;
-
 		wid_list[i].id =3D WID_FRAG_THRESHOLD;
 		wid_list[i].val =3D (s8 *)&param->frag_threshold;
 		wid_list[i].type =3D WID_SHORT;
 		wid_list[i].size =3D sizeof(u16);
-		hif_drv->cfg_values.frag_threshold =3D frag_th;
 		i++;
 	}
 	if (param->flag & RTS_THRESHOLD) {
-		u16 rts_th =3D param->rts_threshold;
-
 		wid_list[i].id =3D WID_RTS_THRESHOLD;
 		wid_list[i].val =3D (s8 *)&param->rts_threshold;
 		wid_list[i].type =3D WID_SHORT;
 		wid_list[i].size =3D sizeof(u16);
-		hif_drv->cfg_values.rts_threshold =3D rts_th;
 		i++;
 	}
=20
@@ -3256,7 +3244,6 @@ int wilc_init(struct net_device *dev, struct host_if_=
drv **hif_drv_handler)
 	mutex_lock(&hif_drv->cfg_values_lock);
=20
 	hif_drv->hif_state =3D HOST_IF_IDLE;
-	hif_drv->cfg_values.scan_source =3D DEFAULT_SCAN;
=20
 	hif_drv->p2p_timeout =3D 0;
=20
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index df9fc33be094..1e2e50e91f76 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -293,7 +293,6 @@ struct host_if_drv {
 	enum host_if_state hif_state;
=20
 	u8 assoc_bssid[ETH_ALEN];
-	struct cfg_param_attr cfg_values;
 	/*lock to protect concurrent setting of cfg params*/
 	struct mutex cfg_values_lock;
=20
--=20
2.17.1

