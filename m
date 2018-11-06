Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B66EC46465
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 00:01:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 175442083D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 00:01:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="YzX2/JpQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 175442083D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbeKFJXs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 04:23:48 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:22115 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbeKFJXs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 04:23:48 -0500
X-IronPort-AV: E=Sophos;i="5.54,469,1534834800"; 
   d="scan'208";a="19973278"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Nov 2018 17:01:23 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 5 Nov 2018 17:01:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IN5CIXOIFMpcCFiLwdu0rHAgdRDXaeinHDWcc5B/zF0=;
 b=YzX2/JpQlCK+7ezc2+p5r1rEy4XgotCOyGpmKdb59uRF7KNzXbAB9RxkJShg81hfCWjdJP/b7/e2Wdmfk8lD8JYeHyPsB653c9ATgtcY2rUuGzQ74Fx+QqU9wOSs6RARfF5egW3fMIrTGkHRGS8fnz2pwWPNiVUtkvQcwjEklOI=
Received: from SN6PR11MB3407.namprd11.prod.outlook.com (52.135.111.96) by
 SN6PR11MB2639.namprd11.prod.outlook.com (52.135.91.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.26; Tue, 6 Nov 2018 00:01:19 +0000
Received: from SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::a1c0:26cf:6e24:2feb]) by SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::a1c0:26cf:6e24:2feb%2]) with mapi id 15.20.1250.028; Tue, 6 Nov 2018
 00:01:19 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <johannes@sipsolutions.net>
Subject: [PATCH v3 3/4] staging: wilc1000: Don't keep a copy of wiphy
 parameters in the driver
Thread-Topic: [PATCH v3 3/4] staging: wilc1000: Don't keep a copy of wiphy
 parameters in the driver
Thread-Index: AQHUdWPYTYWY18NIQUON/TJQsYkLug==
Date:   Tue, 6 Nov 2018 00:01:19 +0000
Message-ID: <20181106000109.6178-4-adham.abozaeid@microchip.com>
References: <20181106000109.6178-1-adham.abozaeid@microchip.com>
In-Reply-To: <20181106000109.6178-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR11CA0084.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::25) To SN6PR11MB3407.namprd11.prod.outlook.com
 (2603:10b6:805:bd::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB2639;6:Cgm9tk+RrWLx0vHvRnKxeJvOLpAsuGYAiJ/ngjOqfVWCt88euOHfzbyNVLAu10Y83GbFV+t0w/bitjQn48fnuw82B7GAsFdruHrI/aNJ0HuqUlhgVbnnWVaAM8FC8nUDs93f+BInPjK+xBFqFcmBXn/qKvsZFL6l+HHy9tydsWD258yspSQxX7jMomDggzUXpV+ZIK3y/Lp+YsQnRbJxYBqW1446klW1iYUy87855jzIvctyq44z1MAFiQwydLD/fJnajR1eewX6OmalhoM1O8zWW6MhqDKBpwh9Cmb0mu4Y1R+5CLJx6Puccy8ZBUz0dEjTCr5iSOq0yLi1yloC33jY/60cwllPwxSB8dk5BqI1Uk9R/Th5+OUZTfaqnZMOTKqKwKFf7JbOqhgUzShOcUSqmyFuYeBynQgyCOLZf78Lw/VFQuUbBwOpkDkyYDdK+ZWwyvbj2i94PSbNtimAHg==;5:dVXCvC3eyvTQ2JxP7e+pBFNhDLxnZdOslVmcho8yJ+UBGT4KmLo+nPO1BjJxXpaG9/D7pfypghaUUrUOHslIq77Il7F+ymkWSDUJD5HikTiziPaRGYHUpPKZSHJZun7CRlTe+Ih2kS13WNlDcTd1glcqDyTPz7svGUq6sWPzW7Y=;7:UZGpDkqnIbsF1/1QwCyIROFQqlOxQqFT7m8Mbr5kNsljm8OX7b3hw49Rcis5kpJGv6rw/f0T6XIUb7Od3zGLjvm9j7ws9846+B3/S/ObAAk+7N99U9aszIgYq4ye38gk6IRsp1b5drgDEiTF7kKLRQ==
x-ms-office365-filtering-correlation-id: e127fea5-400c-49e7-6910-08d6437afa7d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR11MB2639;
x-ms-traffictypediagnostic: SN6PR11MB2639:
x-microsoft-antispam-prvs: <SN6PR11MB2639B1705B4147BA7F10372F8DCB0@SN6PR11MB2639.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231382)(944501410)(52105095)(93006095)(93001095)(3002001)(10201501046)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123564045)(20161123558120)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB2639;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB2639;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(39860400002)(346002)(366004)(136003)(189003)(199004)(99286004)(1076002)(3846002)(6116002)(8676002)(6486002)(6436002)(36756003)(86362001)(5640700003)(316002)(54906003)(6506007)(5660300001)(76176011)(72206003)(71190400001)(6916009)(52116002)(386003)(71200400001)(53936002)(6512007)(81156014)(81166006)(8936002)(14454004)(2906002)(256004)(68736007)(66066001)(14444005)(486006)(4326008)(478600001)(102836004)(2501003)(186003)(26005)(305945005)(2351001)(11346002)(7736002)(2616005)(446003)(106356001)(105586002)(2900100001)(25786009)(97736004)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB2639;H:SN6PR11MB3407.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 9Yb1IDVuIAi/etmS/qTnrX3rz+vTsOUba6SQII9sw+ioOmh00xKHHPAkwWWK1KmHspbc+xzRXbI9e/jzleU91503azzNA//bYBc2FFXvLUQE4hf8jZFg9N5FRdQGeBUlJvJEUBCztEmvqpz6/XDb15hPSPqF8Gb4bmty0ZjlfIKauRR8ah9HJuFQM2CecDpwNepp9AINIdjCEe2q1I9Hij69iRhRde7NetS/ins14KK+M8ObZoYwHX0Jof/gPbuFCnvaTrleD0jKe2ivOiJ5RqqOAu0ueobmjjNZD0501WJ3PSOExkB+SGDVtbZRSPhc7w0Y9qrgaWAyj51a2SLdqUghZmCH8QzxADmagsF/Noo=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e127fea5-400c-49e7-6910-08d6437afa7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 00:01:19.0540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2639
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Adham Abozaeid <adham.abozaeid@micochip.com>

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

