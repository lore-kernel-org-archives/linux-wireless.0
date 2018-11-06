Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D51C0044C
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 00:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A97322083D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 00:01:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="R02bxlSQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A97322083D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728136AbeKFJXl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 04:23:41 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:41791 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbeKFJXl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 04:23:41 -0500
X-IronPort-AV: E=Sophos;i="5.54,469,1534834800"; 
   d="scan'208";a="22705238"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Nov 2018 17:01:24 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.106) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 5 Nov 2018 17:01:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mZ2lB/4ASxi7OBfJU4mEw8ABxxDWI2cwY9oVY61Glb0=;
 b=R02bxlSQ2qCOA29rgcStBnFAVSr0fk+aE2+mlWi1+o6XIgoL5NOyxZmc41EozEEIdSo6Ga8mseMaj1CIJPaMeJw4RM0jSFWCQjfXmQtPiX4IcgqsecYiPgjpQMiY/w4GgtzcHIyAPTdX1uSq8HUhQ742TmMJhI7s4b87cDUQ23Q=
Received: from SN6PR11MB3407.namprd11.prod.outlook.com (52.135.111.96) by
 SN6PR11MB2639.namprd11.prod.outlook.com (52.135.91.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.26; Tue, 6 Nov 2018 00:01:20 +0000
Received: from SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::a1c0:26cf:6e24:2feb]) by SN6PR11MB3407.namprd11.prod.outlook.com
 ([fe80::a1c0:26cf:6e24:2feb%2]) with mapi id 15.20.1250.028; Tue, 6 Nov 2018
 00:01:20 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <johannes@sipsolutions.net>
Subject: [PATCH v3 4/4] staging: wilc1000: Remove unused mutex cfg_values_lock
Thread-Topic: [PATCH v3 4/4] staging: wilc1000: Remove unused mutex
 cfg_values_lock
Thread-Index: AQHUdWPYkP7QvLxzV0+sJxJvn3G43A==
Date:   Tue, 6 Nov 2018 00:01:19 +0000
Message-ID: <20181106000109.6178-5-adham.abozaeid@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;SN6PR11MB2639;6:1ZjSHfXheJA4iqgFore+Z6Z06W3IeERqmKzEc7OJ6esp+cZpQumdkaqEorSnJeJLyBMcVmJHc8ZuVghxLfbZn2e2nFOMDe/mJ3kRB8FrVfzV62eOqcsVuBU8wygcbA30hecexzT4Ak4h/F3ULa0UVZl9l+0bG3ZfYVQYVJfGgs08o13jbVIJc2OFKA/vDaZpVs9aWSkK4M5bhbci3cTcY2BwEwaHKM3zUuNeJ4Zmxt9VDFf2nnsdoNsAgVlAxJ1NYwVSTbTWtVkvRmAC6xxYdF+Xiek1RzdCBgFE/vmokE1F/5MO9CTRWL4NUftvn7VDRgY5XwwsiGEu6bIh+BTN5l+D5AGkzIAQh5AYKcT6UTGwVehcjMSTtVYgklXrmogwsXuGtLeA4rCadCWA2c06O112NQFSKqZYVIscPkDiTGvBd5OQ1dFsBtMVBxTJkNGv4RPzxItwBz2g1DHRcmxLVA==;5:Y59GnAE7TpZaBO+ubLPZtKLZDdpwFbM4SQMnOYsop6vlBjl/jGNwjyGeK/NJeV5a0X4T+pVrdz8o0SMJFgz53zAc5ZsuRUvmXU+ui5CZtqRyMPHFdlI2rn9PrLhKLx6ujt9httbOXFNEz2XZMFL2Q8Pbc1m6SkxancCXTCzHMew=;7:yfitimcOY6tpWCSaXPpCQdotvB032XIaddPhnOF0/4Tpn7EuCPprdRM+UJNfoCmwIPscS8Ud7vW8zYb+0cpGgxe0Z2TOcNi7nk/VwECYmWCqJ5T4RczpCMhRLJY9bgUSnpPuLQpQwZN6lOcVlgXKAw==
x-ms-office365-filtering-correlation-id: f6623b89-a4fe-44f4-85b9-08d6437afb08
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR11MB2639;
x-ms-traffictypediagnostic: SN6PR11MB2639:
x-microsoft-antispam-prvs: <SN6PR11MB2639109E64875DED68691B558DCB0@SN6PR11MB2639.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(21532816269658);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231382)(944501410)(52105095)(93006095)(93001095)(3002001)(10201501046)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123564045)(20161123558120)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB2639;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB2639;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(39860400002)(346002)(366004)(136003)(189003)(199004)(99286004)(1076002)(3846002)(6116002)(8676002)(6486002)(6436002)(36756003)(86362001)(5640700003)(316002)(54906003)(6506007)(5660300001)(76176011)(72206003)(71190400001)(6916009)(52116002)(386003)(71200400001)(53936002)(6512007)(81156014)(81166006)(8936002)(14454004)(2906002)(256004)(68736007)(66066001)(14444005)(486006)(4326008)(478600001)(102836004)(2501003)(186003)(26005)(305945005)(2351001)(11346002)(7736002)(2616005)(446003)(106356001)(105586002)(2900100001)(25786009)(97736004)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB2639;H:SN6PR11MB3407.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: +nO+MuLr5zRXZDT3OuhbXAx54SAbeLVFfCKXO5BiI7gRUShlSO2kbrqux0ojHpVFPVrE86DjXPpMB5t9lkXLnDYKY0r/337aK5Mx6JA0wW+YO2sRwz8xtxoEKcO2Syb5z2zbV8bADSMx6WNRXeoIiHIUai2GUliEb8rWOUyIEQwtmjG5v00TYK9EY0xYCJhPclV6547kGCISHM7Cx5ru2Ie4c131VTe6cxA0jkfb3Y28XnXMaDJPIzqFWPKvTHzz/bpcLF9H7NW8CDwVjeVyS1ANW1mDScV4p5o41Hxj04G9q8A82kgHMLyiEP4NFARTfr99WbEdq+6zpXm9koedu/eQtJgQeTHOPzZJlLsbN2U=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f6623b89-a4fe-44f4-85b9-08d6437afb08
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 00:01:20.0027
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

