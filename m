Return-Path: <SRS0=qkCK=NK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28534C6786F
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 04:23:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA36C2082D
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 04:23:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="uEporkhs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA36C2082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbeJ3NOw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 09:14:52 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:41576 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbeJ3NOv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 09:14:51 -0400
X-IronPort-AV: E=Sophos;i="5.54,442,1534834800"; 
   d="scan'208";a="23285779"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 29 Oct 2018 21:23:03 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Mon, 29 Oct 2018 21:23:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKBy8Qi+Qq5h8PCdvEprQ5XKGMTRfXRm8Y2FcLvL3/w=;
 b=uEporkhs7PuV/xfS4Ng0m9HBRtKAvktxcTMpfcxb4HK6NkfF0DvAfR+g5uqNaujxB2vI8sYLKMBLMg234aHqJ2TW+WfSbY8MVdmPc6YiiqVj4/1iQGUiUFV+ErLxPhz9OrRAqdjF/aoAaOs9HdtSnfjlWgmD3fEgOuEyf/2OLOg=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0256.namprd11.prod.outlook.com (10.160.136.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1250.30; Tue, 30 Oct 2018 04:22:59 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e%10]) with mapi id 15.20.1250.034; Tue, 30 Oct
 2018 04:22:59 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>, <Aditya.Shankar@microchip.com>,
        <Sripad.Balwadgi@microchip.com>,
        <Mrutyunjaya.Satapathy@microchip.com>, <johannes@sipsolutions.net>
Subject: [PATCH v2 4/4] staging: wilc1000: Remove unused mutex cfg_values_lock
Thread-Topic: [PATCH v2 4/4] staging: wilc1000: Remove unused mutex
 cfg_values_lock
Thread-Index: AQHUcAg97RI3p2yhdUyb1/kF1kmofQ==
Date:   Tue, 30 Oct 2018 04:22:59 +0000
Message-ID: <20181030042243.2153-5-adham.abozaeid@microchip.com>
References: <20181030042243.2153-1-adham.abozaeid@microchip.com>
In-Reply-To: <20181030042243.2153-1-adham.abozaeid@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
x-clientproxiedby: BYAPR07CA0025.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::38) To DM2PR11MB0255.namprd11.prod.outlook.com
 (2a01:111:e400:3c24::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0256;6:T9ke4b98TVoX99bYl2CTTsTTUe3uTg3QwMdO3i94jbPaRecJv7at2nP14dkM6HJtKpI9I6r/9QznGwh9cBETOQQPUIt99nYF8nAXaamA3qOYvYWCNfKpUAOZunuyeXrzpbLptO0SuiXyckufF7f8BsMK/qBxQSW0eAgrhZDPVOh9NJBo0cY8nj+Vc+9GA1qAI3czntIeF3X5AASlcYRZm7TAKX0nQDKduNYsi8chHxSz4SQJu5EpRqJJmNpBXGv/11pvdWjtJffvcnWmNWNf/RaEp3d61nqKtrMjMykdNms5OzLpqMrLBSHnDEiUS33oK3oX1GckuJLOiSfPRWm+E9XL3Pm74/AVjwEQKSEnaSlismZBiVPXlHDRjF8G3RlGGU/g5uevF5j4uGZOa4fV1bRLkuaWtCY93cmPwiKplkXFJVaHLXyJKM92ouQcU6+yNP/EH92n+0T8He9x2Wn+gg==;5:a6xttoDYrNgng/yki6lv5YQ7zQl/vnXRPjI3YkTDW2AZcwjq39l/hycKZdLorxqK+0Rzs8f8W4KmrymjOXJezZkFzka027bV6ayNuebNKEvlqwBpv1oWVMybYTQlstXCFBYVb+csEtFIe9jMlrRHd0nJLIUWRy0x44utMZNIgiA=;7:fK0c3mnw3ifE/EIA+fSLOfsSE8Pcju0KbwDy6BsUhshNRfAjfRDf07DyzQQ16Gk1xkiU0ECXeNib+MRE4Xgkjqz0pfAo9mrICsunXH3zJ47pN/0jPvMCzpg9kKmXUlv4GW88CLAc3ePq+BmmhPqd7G/BVGl/5In2o3H/K4i8zLRG0KlFLqG4dgKkLqEKrkx9JS2jNPamkVkPsOyVkP7tJI0Gp6iPO8dOZQOxZVTLdXBmbTLu2kR4qGntYQ7WWRDD
x-ms-office365-filtering-correlation-id: 3b3f961a-f4c0-4190-2a6b-08d63e1f5fd4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0256;
x-ms-traffictypediagnostic: DM2PR11MB0256:
x-ld-processed: 3f4057f3-b418-4d4e-ba84-d55b4e897d88,ExtAddr
x-microsoft-antispam-prvs: <DM2PR11MB0256100B24203C8427E0B65C8DCC0@DM2PR11MB0256.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(21532816269658);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(93006095)(93001095)(3231382)(944501410)(52105095)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123562045)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:DM2PR11MB0256;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0256;
x-forefront-prvs: 08417837C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(136003)(366004)(376002)(396003)(189003)(199004)(5660300001)(36756003)(106356001)(14454004)(6486002)(105586002)(72206003)(71200400001)(2351001)(71190400001)(186003)(66066001)(6916009)(446003)(3846002)(81156014)(8676002)(6116002)(1076002)(6512007)(81166006)(99286004)(5640700003)(26005)(97736004)(386003)(11346002)(476003)(6506007)(2900100001)(5250100002)(8936002)(25786009)(53936002)(486006)(102836004)(4326008)(54906003)(478600001)(86362001)(305945005)(68736007)(6436002)(316002)(52116002)(256004)(76176011)(14444005)(7736002)(2906002)(2501003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0256;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: vV5z8Zr34SaJ+QRbDXYzrR2MD+13f5sPUUXYlIC8OlnrRQh5liVMLVE5Bi0KG0x/UrXHSxDOYI7yJEN27od6sgAeb0vwM955e7wetxC+/FHeDy4an/Ul5QQxypPAxipyB0tKfjAJCcBZAQJ8DzHN3HIxBWtVEBAH4B7/a/bWb8GQsWWonl+O5kBelbg1kmbcgZlOBVQJURGbzFh5ZdtOI2t3qHgCHlYEz0F+DPDiQ3S/jZABGX9Mq6AXHavbp6Qr5UD8VoYqEAA/lVz5csvPeQMTr0UZ+RpdNbnTqh1ofdhW5UjTvEWdhAyVQbyxtOjKHX2dvT/PLI4ZTA6Ib4/mcJlyhqUUP2e11Ety4CAT+WY=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b3f961a-f4c0-4190-2a6b-08d63e1f5fd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2018 04:22:59.6495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR11MB0256
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

