Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A64DC65BAF
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 658DD20881
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 18:02:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="vCZAzjyj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 658DD20881
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725777AbeLBSCb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 13:02:31 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:52831 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbeLBSCa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 13:02:30 -0500
X-IronPort-AV: E=Sophos;i="5.56,307,1539673200"; 
   d="scan'208";a="23451081"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 02 Dec 2018 11:02:27 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sun, 2 Dec 2018 11:02:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=njCKqgmGUQmx+6uZ8txvzbXOEy68fYV4ZtQRAVV/QDY=;
 b=vCZAzjyjQ+K2Mi01n8JCDzLnOdQtpp5WeTPFLDt07+F0QdPD2Zl/IC5z+wC7QeH0qHShnRV5XaBP2J+TeWLAtNrzfLTvv8lkBskgXRkcnI55LDS2ETSRHfMuN5WxXMmupuPQ67rbHP6vfGMEqVm+kwzE7xK075iT41bC5j+fn+A=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3334.namprd11.prod.outlook.com (20.177.185.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1382.19; Sun, 2 Dec 2018 18:02:25 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::391c:cb9c:2556:436f%4]) with mapi id 15.20.1382.020; Sun, 2 Dec 2018
 18:02:25 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 04/29] staging: wilc1000: use mutex lock to synchronized
 sending 'wid' cmd to firmware
Thread-Topic: [PATCH 04/29] staging: wilc1000: use mutex lock to synchronized
 sending 'wid' cmd to firmware
Thread-Index: AQHUimkuJ+UGe/H8iEeaWt7U24vD6Q==
Date:   Sun, 2 Dec 2018 18:02:25 +0000
Message-ID: <1543773663-20561-5-git-send-email-ajay.kathat@microchip.com>
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
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3334;6:GUUcwXRE1qx8+HTEWeQLIuI96Abwk0RXvZEZYVm7ONHjg0c3X+Gaqn5vRoN+lyEiwJuivbFDxW1kkRcjq58ja8D+YBVQj2Fin610V1B+cunbLREU6+Geb1vZPkX89D3nFBRQVPr0VUpDkJ4xtZDKXW4Qlc4j4scDqNYCdIVgfL9wnQhlU7ctUhAdnO/tMqCJcbxp5RRnLkNMI3hT2FTmIOXes2Y3jcJkrm+yFKzioHEUGYiJLuYHlT3Z2oYuAp+sswkFvpZXlxi3DroEc2avlxj6JOZfRde2OGLK+cSH6LWFjCn80Z7kkBy5wb1IcygtZiV3sFTYLH3Y7C7f+R2r5x0Ffjkf9OOCdHOdJ9ZwR2479mtwDVV7GQasSFdQUJbJKCk9hSp0jFQ9zenfraT//Kb79gkp1LmnR8SO45yvZc/Bvfn/6LQjasx7HbJRJotrX0jwJRcISNRDW9967dNkkw==;5:YAFpaTNGRfuiT1VZgrd4NTUYcLF2r5fYYA2r4t0r69EOVwT4DrlcAX0d1ZkJ7LDmZkcGzmpH2RH2Le2HRPpocDJfanW8ccyI2Gm1xBLzDT2ii+j3as/UUKn4h1wR2cQ5UD6+0n3x5PrXp/1olUaFuA72D2DTs1gS8PHxotOrgkk=;7:/Nz40RA2kcE+rEx9ldrBeZrtwYz9zHaNBg+3lmbGsXJ0P3ZGqkU4e0ojVz3RaxUUfO2Jdv2P4CcLF3QWZz/RoGKPjL1xFxIqE7IEoZeKjvH17SiP1uCmTJPNqHSRpU+d5VDZ/VtTkumX+1ZU79iVwA==
x-ms-office365-filtering-correlation-id: 6b210567-c120-48b2-f08f-08d6588050b1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3334;
x-ms-traffictypediagnostic: BYAPR11MB3334:
x-microsoft-antispam-prvs: <BYAPR11MB333441CC1F8FF2CFE25277F7E3AD0@BYAPR11MB3334.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(3231455)(999002)(944501491)(52105112)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BYAPR11MB3334;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB3334;
x-forefront-prvs: 087474FBFA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(366004)(376002)(396003)(39850400004)(199004)(189003)(107886003)(6916009)(386003)(5660300001)(5640700003)(446003)(4326008)(11346002)(6506007)(78486014)(2906002)(6512007)(53936002)(54906003)(3846002)(6116002)(2351001)(81166006)(316002)(81156014)(52116002)(8676002)(26005)(8936002)(256004)(14444005)(76176011)(6436002)(97736004)(106356001)(99286004)(486006)(6486002)(68736007)(105586002)(14454004)(478600001)(2616005)(7736002)(66066001)(36756003)(305945005)(72206003)(186003)(2501003)(86362001)(575784001)(102836004)(476003)(71190400001)(25786009)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3334;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: vUDyjf8ZayDnCtPJnEMdUrjLvOSyWcJlYncUf0CaZKQND5NVB4CowOm4sALhMsO1qxuM6EIDcgbA2kCkGob968h13GJjDRTQtpUydfz/qq5kC7MHAl/WVVHydAc0mIOOvvEqiGTEBM1qFz1euLObVxiFqr5Goj8T8fQCjxbkHN+ogVMb5QgjumaqVrgvMg87ZTSu1b4SpFtMXZgbO3HZWZC8QRIJN6lcArJ+4Hh7TErhdgjatCSQC5enDogUbHVu+8WtqOTSQ+6PkVnMqvAdawAsn1lH2x2WydHPIRq+3zBOQdeGNS1ysvRDjl/3jHqMX5bpcDCzTquFHXAZtC0jqnEOALNhk+M5hrWGdKFhz84=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b210567-c120-48b2-f08f-08d6588050b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2018 18:02:25.5272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3334
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Use mutex lock to protect the issuing of wid cmd to the firmware.
Currently the wid commands are synchronized by use of hif_workqueue work
queue.
Now, these changes are required to synchronize the access to wid
command, so the commands can be issued directly from cfg80211 context
and 'WILC_wq' thread.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c         |  2 ++
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  3 ++-
 drivers/staging/wilc1000/wilc_wlan.c          | 21 ++++++++++-----------
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index c92ee79..e246d18 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -531,6 +531,7 @@ static void wlan_deinit_locks(struct net_device *dev)
=20
 	mutex_destroy(&wilc->hif_cs);
 	mutex_destroy(&wilc->rxq_cs);
+	mutex_destroy(&wilc->cfg_cmd_lock);
 	mutex_destroy(&wilc->txq_add_to_head_cs);
 }
=20
@@ -592,6 +593,7 @@ static void wlan_init_locks(struct net_device *dev)
=20
 	mutex_init(&wl->hif_cs);
 	mutex_init(&wl->rxq_cs);
+	mutex_init(&wl->cfg_cmd_lock);
=20
 	spin_lock_init(&wl->txq_spinlock);
 	mutex_init(&wl->txq_add_to_head_cs);
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/stagin=
g/wilc1000/wilc_wfi_netdevice.h
index e71d949..02970c3 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -247,7 +247,8 @@ struct wilc {
 	struct task_struct *txq_thread;
=20
 	int quit;
-	int cfg_frame_in_use;
+	/* lock to protect issue of wid command to firmware */
+	struct mutex cfg_cmd_lock;
 	struct wilc_cfg_frame cfg_frame;
 	u32 cfg_frame_offset;
 	int cfg_seq_no;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc100=
0/wilc_wlan.c
index f0b10e2..3c5e9e0 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1122,8 +1122,7 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start=
, u16 wid, u8 *buffer,
 	int ret_size;
 	struct wilc *wilc =3D vif->wilc;
=20
-	if (wilc->cfg_frame_in_use)
-		return 0;
+	mutex_lock(&wilc->cfg_cmd_lock);
=20
 	if (start)
 		wilc->cfg_frame_offset =3D 0;
@@ -1134,11 +1133,12 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int sta=
rt, u16 wid, u8 *buffer,
 	offset +=3D ret_size;
 	wilc->cfg_frame_offset =3D offset;
=20
-	if (!commit)
+	if (!commit) {
+		mutex_unlock(&wilc->cfg_cmd_lock);
 		return ret_size;
+	}
=20
 	netdev_dbg(vif->ndev, "%s: seqno[%d]\n", __func__, wilc->cfg_seq_no);
-	wilc->cfg_frame_in_use =3D 1;
=20
 	if (wilc_wlan_cfg_commit(vif, WILC_CFG_SET, drv_handler))
 		ret_size =3D 0;
@@ -1149,9 +1149,9 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start=
, u16 wid, u8 *buffer,
 		ret_size =3D 0;
 	}
=20
-	wilc->cfg_frame_in_use =3D 0;
 	wilc->cfg_frame_offset =3D 0;
 	wilc->cfg_seq_no +=3D 1;
+	mutex_unlock(&wilc->cfg_cmd_lock);
=20
 	return ret_size;
 }
@@ -1163,8 +1163,7 @@ int wilc_wlan_cfg_get(struct wilc_vif *vif, int start=
, u16 wid, int commit,
 	int ret_size;
 	struct wilc *wilc =3D vif->wilc;
=20
-	if (wilc->cfg_frame_in_use)
-		return 0;
+	mutex_lock(&wilc->cfg_cmd_lock);
=20
 	if (start)
 		wilc->cfg_frame_offset =3D 0;
@@ -1174,10 +1173,10 @@ int wilc_wlan_cfg_get(struct wilc_vif *vif, int sta=
rt, u16 wid, int commit,
 	offset +=3D ret_size;
 	wilc->cfg_frame_offset =3D offset;
=20
-	if (!commit)
+	if (!commit) {
+		mutex_unlock(&wilc->cfg_cmd_lock);
 		return ret_size;
-
-	wilc->cfg_frame_in_use =3D 1;
+	}
=20
 	if (wilc_wlan_cfg_commit(vif, WILC_CFG_QUERY, drv_handler))
 		ret_size =3D 0;
@@ -1187,9 +1186,9 @@ int wilc_wlan_cfg_get(struct wilc_vif *vif, int start=
, u16 wid, int commit,
 		netdev_dbg(vif->ndev, "%s: Timed Out\n", __func__);
 		ret_size =3D 0;
 	}
-	wilc->cfg_frame_in_use =3D 0;
 	wilc->cfg_frame_offset =3D 0;
 	wilc->cfg_seq_no +=3D 1;
+	mutex_unlock(&wilc->cfg_cmd_lock);
=20
 	return ret_size;
 }
--=20
2.7.4

