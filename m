Return-Path: <SRS0=M3au=QJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D4EAC282DB
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62E3B2082C
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 19:17:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="a9IFxnQB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfBBTQ7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Feb 2019 14:16:59 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:55561 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfBBTQ7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Feb 2019 14:16:59 -0500
X-IronPort-AV: E=Sophos;i="5.56,553,1539673200"; 
   d="scan'208";a="26075155"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 02 Feb 2019 12:16:58 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 2 Feb 2019 12:16:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FxgC7uJa6E9tYnTjPsmrM+kNhwimeheJk/XP+3cAOJg=;
 b=a9IFxnQB307CVfGBMFSzRTLP1rrfsjLJVI6Mp2M3RDoaq5cNAfQr6MN1zW4m6gydeUtpWu/ouPy07ysfbr6ULy7sFQ6wsGau2bVFk/5V+mWUrWdNJP3+J4IJQ3teMj/444VVOwiu4CYy5IoBqtrrs/XkZDdSBG5X81HyDCMDlgk=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2998.namprd11.prod.outlook.com (20.177.224.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.21; Sat, 2 Feb 2019 19:16:56 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1580.019; Sat, 2 Feb 2019
 19:16:56 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 02/15] staging: wilc1000: remove conditional lock in
 wilc_wfi_deinit_mon_interface()
Thread-Topic: [PATCH 02/15] staging: wilc1000: remove conditional lock in
 wilc_wfi_deinit_mon_interface()
Thread-Index: AQHUuyvcCrP3DvDHr0a0oJV3zTfU0A==
Date:   Sat, 2 Feb 2019 19:16:56 +0000
Message-ID: <1549134974-5545-3-git-send-email-ajay.kathat@microchip.com>
References: <1549134974-5545-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549134974-5545-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0011.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::21) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [49.205.218.11]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2998;6:55wkJUKyNhkNKEPKNGO+CzJCJwUKukpTIdOqm/braqxHriHLNjB4obW/XaUyQC8KyEMYgfD6+wUK1Ho2YFVPZiyfp+K3iRZWPLH69LBhk6HOcsUyRPQ9o/dLpToTvZyt6UBrUPAAl51w2uy4Zp9nTRr6rIWo9PdVK7su7NPK6/IFvGnPF0qjX7Y8UOmYkzYU0qoMlQUfCJaRbzZukE1BI3BG+1zDsfOGNKCZOPiQD1DMHbjWflzBPID8eo308QS1B8o1VVjSpBvKNms3Sai7LkamfC0fkwxuWh6KptkageZr3XZGYrp10c5Lu+Ogl/SfMDf7uPplKoqCn/BpwTyalo95X/rGIC3+iA9kUR0Et4IMGVkmhkieOoHosAAWRmRq/OYfle8FNceSCUw2Xcgocul9A8A8762ZlopVy93XYiF9aCjyH26oBz3JDHOw8BnKqm5oVq3B1WH+XxruBf63HA==;5:dyc5u8TS4mqbs9kTmHcekaTH+JfrsyhBwxpf8R18R/BWGFm0Bd7TrIixkRpIukgCjhNUkjwEXeZudv8o6P41fkYrGQPXTqNgusl1TLhsSi9JwjiS0ipPC+eoE3auuXxN1aGKAtzaA1X+jWzNDXbwtA5p7jD6qpB5sb6D95NUKGcsdqprGPgpbxVw5liOQctoIxg2iHFVOi338z+JJ38/9Q==;7:4APA4G6LKnnyXkK3llkM9fo2bwYjhjIhaTMSYYY5Z7XSVBqVhnzhbCUYaf1UMbfRVGona7cseh0GXvafYIS+83vhMP2YX868lWVL5p7MqmzvGS94xeYDBp79emaZZFFr5V3Swj0iaraXODWVfK7LoA==
x-ms-office365-filtering-correlation-id: 56d47ac5-589e-46e9-44fd-08d68942ff24
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2998;
x-ms-traffictypediagnostic: BYAPR11MB2998:
x-microsoft-antispam-prvs: <BYAPR11MB2998E26625DDF345C7E73469E3930@BYAPR11MB2998.namprd11.prod.outlook.com>
x-forefront-prvs: 09368DB063
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(366004)(346002)(39850400004)(189003)(199004)(25786009)(107886003)(105586002)(78486014)(36756003)(50226002)(2501003)(6916009)(66066001)(8936002)(3846002)(4326008)(305945005)(7736002)(71200400001)(71190400001)(8676002)(6116002)(54906003)(81166006)(316002)(446003)(81156014)(6436002)(6486002)(2906002)(2616005)(486006)(476003)(76176011)(256004)(99286004)(11346002)(14444005)(52116002)(53936002)(72206003)(478600001)(186003)(386003)(26005)(14454004)(106356001)(86362001)(5640700003)(97736004)(2351001)(68736007)(6506007)(102836004)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2998;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NwtBiWT1Xc7e3NfxtnvPCD+GXpvzZ91WeUJ7ky9QbhBeRXS2eFSz+AQ+H2dgfdtPCW3Mza1aMCRwM6K9amviSmhhtEIsyk6Nt0/7+elNDAkANhVes9VdoCcrll1nzoYZk5hHquc0NTzu9Y20SUFwdrCi/ne4V5aaeTzwggQalKJ3ANQp0pJfNbDP2Pm7G63GHbud95rjsmhkT3KePo4mjcBYuE4zgJ+csGsaPJ5Nxh8Bs84nX5UdUY8O8yYzmMC8OpSceGtHomWusSmY+qsmt0OcEBE05aar4bd8tWjEyCy3Kn1w46S6uy5ls4N8Hr/bqyF42PMSfh1keHcVSw4ZAr7wSgzYylnFElA612qsUCVsb21bFNUZpw1dTTlI8ir6q0JQRCIyjBJCTzT0092kXVhmczcWp3Fli5A6pYAsr7g=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 56d47ac5-589e-46e9-44fd-08d68942ff24
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2019 19:16:54.1804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2998
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

wilc_wfi_deinit_mon_interface() calls unregister_netdev() which
requires the rtnl lock again. Now move wilc_wfi_deinit_mon_interface()
out of wilc_mac_close(). Also remove explicit call to wilc_mac_close()
because unregister_netdev() takes care of calling wilc_mac_close().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_mon.c  | 19 +++++--------------
 drivers/staging/wilc1000/linux_wlan.c | 11 +++--------
 2 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc100=
0/linux_mon.c
index ed06834..32d0c81 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -253,19 +253,10 @@ struct net_device *wilc_wfi_init_mon_interface(struct=
 wilc *wl,
=20
 void wilc_wfi_deinit_mon_interface(struct wilc *wl)
 {
-	bool rollback_lock =3D false;
-
-	if (wl->monitor_dev) {
-		if (rtnl_is_locked()) {
-			rtnl_unlock();
-			rollback_lock =3D true;
-		}
-		unregister_netdev(wl->monitor_dev);
+	if (!wl->monitor_dev)
+		return;
=20
-		if (rollback_lock) {
-			rtnl_lock();
-			rollback_lock =3D false;
-		}
-		wl->monitor_dev =3D NULL;
-	}
+	unregister_netdev(wl->monitor_dev);
+	free_netdev(wl->monitor_dev);
+	wl->monitor_dev =3D NULL;
 }
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index 1362d8f..b0249d2 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -920,7 +920,6 @@ static int wilc_mac_close(struct net_device *ndev)
 		netdev_dbg(ndev, "Deinitializing wilc1000\n");
 		wl->close =3D 1;
 		wilc_wlan_deinitialize(ndev);
-		wilc_wfi_deinit_mon_interface(wl);
 	}
=20
 	vif->mac_opened =3D 0;
@@ -1006,19 +1005,15 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 		wilc->firmware =3D NULL;
 	}
=20
-	if (wilc->vif[0]->ndev || wilc->vif[1]->ndev) {
-		for (i =3D 0; i < WILC_NUM_CONCURRENT_IFC; i++)
-			if (wilc->vif[i]->ndev)
-				if (wilc->vif[i]->mac_opened)
-					wilc_mac_close(wilc->vif[i]->ndev);
-
-		for (i =3D 0; i < WILC_NUM_CONCURRENT_IFC; i++) {
+	for (i =3D 0; i < WILC_NUM_CONCURRENT_IFC; i++) {
+		if (wilc->vif[i] && wilc->vif[i]->ndev) {
 			unregister_netdev(wilc->vif[i]->ndev);
 			wilc_free_wiphy(wilc->vif[i]->ndev);
 			free_netdev(wilc->vif[i]->ndev);
 		}
 	}
=20
+	wilc_wfi_deinit_mon_interface(wilc);
 	flush_workqueue(wilc->hif_workqueue);
 	destroy_workqueue(wilc->hif_workqueue);
 	wilc_wlan_cfg_deinit(wilc);
--=20
2.7.4

