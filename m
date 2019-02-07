Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91EA0C282CC
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 07:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EF472075C
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 07:22:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="tqCZBpbx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfBGHWu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 02:22:50 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:47422 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfBGHWu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 02:22:50 -0500
X-IronPort-AV: E=Sophos;i="5.56,564,1539673200"; 
   d="scan'208";a="27377128"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 Feb 2019 00:22:48 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 7 Feb 2019 00:22:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWM0girD8R8tPSTRltytTGAFAeFjb24i94pXHM1xr6w=;
 b=tqCZBpbxGlMC2NoSnC8xQjWYILrHRBHVk4XKEjEgyPC9yvmKdzHge1/1vkkJDKrkU9g4ME+BWJwTw2Peh7SgEI54Owgn9HiKh+b5E6KyLGtLgw43INdRqEHKlO35HmuPmzMnT+3Rj5Quv1Ld7df57jJyP+irkAtPBYxzFTK2tuY=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3415.namprd11.prod.outlook.com (20.177.224.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.22; Thu, 7 Feb 2019 07:22:46 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Thu, 7 Feb 2019
 07:22:46 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 8/9] staging: wilc1000: remove 'linux_' prefix in function
 names
Thread-Topic: [PATCH 8/9] staging: wilc1000: remove 'linux_' prefix in
 function names
Thread-Index: AQHUvrXsRNaWhFujy0eS2YdplfimzA==
Date:   Thu, 7 Feb 2019 07:22:46 +0000
Message-ID: <1549519927-2651-9-git-send-email-ajay.kathat@microchip.com>
References: <1549519927-2651-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549519927-2651-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0020.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::30) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [223.237.230.157]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3415;6:eOi88eac1uyGklKa/eQ8teQUK3RAnyaxhPfQ7KGqIe+CxO24K8/nG26xWVuemGVR9xFrqcY3O9S/ZhouX3xE0i6lJq52ANXLROvFa1n6p+w3/tBDilqAV0GrelxJyGAmE1SpMP/WJWrapmlufJqyMK/tLDikeCgKjnTD0P9A60Dc9+OUlFCetV9CKFbqVuIlED+cZHXF2p8ezBmL6RfC8pKTQCQ631h8zeav+R0+ow6dm2I9Qlolhs9VYsumvpLqWfjkSeSYFkoae0Q8usp+gO91UV7Hz0rNMMzqgNQIfmYgPu1B+MD+tJYjQIS6euIygoErNLq/6n+xRNtXj2utuJnd9feh3+86mzgWojL6KT/Imd2QtxPJPStp9wRMwpkUiiHQvKI6oG1RV2toExj6XiMGtDGWv4lMdhWYgnzzDl/WxNtkVZtFBsLsEKG6wgYYSz65G3rgdusLhi9HuDcaqA==;5:Akdz6MqJxcnNMgkIRCQpcL/5Q1Ll/d82iwI7RsU5bYrGWGGpG0vxBbZ7lndiP5Jlk2JK5wY9diYPExg4hfaQDsnEQWTM5790EtGrGPTN1VuIaaYxVKMX5sp9FnMia0pQ9pm6m/s6f3FkJiNZzrCDYyKea8ZJrjPOXQHHuDjfpvbB5EDr8hRA3RRmCyb7TMay7JjBoS0gj2xt7kLWJPQwgg==;7:Zd8GuNRRWb/oR/zuqloKgYp+7DTpYxeEmJpbeKycq/3yS2xsQP/wG16ZVD6SRQhl0vjYUL9imdaLBNeThyPBG3s3Hk/mnKywPB7HN6bE+pKVzVOhmPsLncUyNpv8aG4OuT3QRa+uusoR2LUX4EoJKQ==
x-ms-office365-filtering-correlation-id: c6547463-73dd-411d-3dcf-08d68ccd0e94
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3415;
x-ms-traffictypediagnostic: BYAPR11MB3415:
x-microsoft-antispam-prvs: <BYAPR11MB3415996ED8612AD914B73CA7E3680@BYAPR11MB3415.namprd11.prod.outlook.com>
x-forefront-prvs: 0941B96580
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(136003)(366004)(396003)(376002)(189003)(199004)(86362001)(5640700003)(478600001)(6116002)(446003)(3846002)(72206003)(6486002)(11346002)(6436002)(25786009)(2351001)(2616005)(476003)(6512007)(105586002)(106356001)(486006)(26005)(6506007)(102836004)(386003)(36756003)(71190400001)(2501003)(97736004)(71200400001)(81156014)(305945005)(66066001)(54906003)(4326008)(186003)(68736007)(8936002)(81166006)(107886003)(52116002)(50226002)(53936002)(256004)(6916009)(316002)(99286004)(14454004)(2906002)(76176011)(7736002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3415;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HCS2FL/VCKYd7JBaXj/9l1V2Yk4YUm5l8ydNamUMKkpJ6G9KFszXUzJe0hD5bzU6B5I1J/W4e7ShowRf0Ty4lV/be2DJ0Iv7xzFmWzgWwCLwKBmdJcqeWtXK8oiHl6yTie2B7IJsj2W7qL7YDFz9ZUx3P256mq90KTISMSy3ztGmCw8ONSpElz3NPF7SiXWLXzaYLhUDku0UDnzEzWmOlzZrRJsIPU5yVNATHfiZj7NVvCiMBfW57XPLZhF6H05G9hcyoMypNuPWLCVb6vBs3jmohGdfxRmZj84qqnF1IfMY57kjaWd3T262WP6afInmAnOa9w3XpCHx4T3Ytob4MMmytxux9PWWgx49Dhouho1i3m1USpO+xS9phY75PN+nTKHF3t4SMu2Q9QM8PnL35j4khaardEzyfnh8Smz5DKw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c6547463-73dd-411d-3dcf-08d68ccd0e94
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2019 07:22:43.5717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3415
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Remove 'linux_' prefix and replace it with 'wilc_' namespace.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 17 ++++++++---------
 drivers/staging/wilc1000/wilc_sdio.c  | 10 +++++-----
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc10=
00/linux_wlan.c
index 533e444..5c05504 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -139,7 +139,7 @@ int wilc_wlan_get_num_conn_ifcs(struct wilc *wilc)
 	return ret_val;
 }
=20
-static int linux_wlan_txq_task(void *vp)
+static int wilc_txq_task(void *vp)
 {
 	int ret;
 	u32 txq_count;
@@ -202,7 +202,7 @@ static int wilc_wlan_get_firmware(struct net_device *de=
v)
 	return ret;
 }
=20
-static int linux_wlan_start_firmware(struct net_device *dev)
+static int wilc_start_firmware(struct net_device *dev)
 {
 	struct wilc_vif *vif =3D netdev_priv(dev);
 	struct wilc *wilc =3D vif->wilc;
@@ -243,8 +243,7 @@ static int wilc1000_firmware_download(struct net_device=
 *dev)
 	return 0;
 }
=20
-static int linux_wlan_init_fw_config(struct net_device *dev,
-				     struct wilc_vif *vif)
+static int wilc_init_fw_config(struct net_device *dev, struct wilc_vif *vi=
f)
 {
 	struct wilc_priv *priv;
 	struct host_if_drv *hif_drv;
@@ -502,7 +501,7 @@ static int wlan_initialize_threads(struct net_device *d=
ev)
 	struct wilc_vif *vif =3D netdev_priv(dev);
 	struct wilc *wilc =3D vif->wilc;
=20
-	wilc->txq_thread =3D kthread_run(linux_wlan_txq_task, (void *)dev,
+	wilc->txq_thread =3D kthread_run(wilc_txq_task, (void *)dev,
 				       "K_TXQ_TASK");
 	if (IS_ERR(wilc->txq_thread)) {
 		netdev_err(dev, "couldn't create TXQ thread\n");
@@ -560,7 +559,7 @@ static int wilc_wlan_initialize(struct net_device *dev,=
 struct wilc_vif *vif)
 			goto fail_irq_enable;
 		}
=20
-		ret =3D linux_wlan_start_firmware(dev);
+		ret =3D wilc_start_firmware(dev);
 		if (ret < 0) {
 			ret =3D -EIO;
 			goto fail_irq_enable;
@@ -576,7 +575,7 @@ static int wilc_wlan_initialize(struct net_device *dev,=
 struct wilc_vif *vif)
 			firmware_ver[size] =3D '\0';
 			netdev_dbg(dev, "Firmware Ver =3D %s\n", firmware_ver);
 		}
-		ret =3D linux_wlan_init_fw_config(dev, vif);
+		ret =3D wilc_init_fw_config(dev, vif);
=20
 		if (ret < 0) {
 			netdev_err(dev, "Failed to configure firmware\n");
@@ -726,7 +725,7 @@ static void wilc_set_multicast_list(struct net_device *=
dev)
 		kfree(mc_list);
 }
=20
-static void linux_wlan_tx_complete(void *priv, int status)
+static void wilc_tx_complete(void *priv, int status)
 {
 	struct tx_complete_data *pv_data =3D priv;
=20
@@ -762,7 +761,7 @@ netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct n=
et_device *ndev)
 	tx_data->bssid =3D wilc->vif[vif->idx]->bssid;
 	queue_count =3D wilc_wlan_txq_add_net_pkt(ndev, (void *)tx_data,
 						tx_data->buff, tx_data->size,
-						linux_wlan_tx_complete);
+						wilc_tx_complete);
=20
 	if (queue_count > FLOW_CONTROL_UPPER_THRESHOLD) {
 		if (wilc->vif[0]->mac_opened)
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc100=
0/wilc_sdio.c
index 2ca6757..b789c57 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -117,8 +117,8 @@ static int wilc_sdio_cmd53(struct wilc *wilc, struct sd=
io_cmd53 *cmd)
 	return ret;
 }
=20
-static int linux_sdio_probe(struct sdio_func *func,
-			    const struct sdio_device_id *id)
+static int wilc_sdio_probe(struct sdio_func *func,
+			   const struct sdio_device_id *id)
 {
 	struct wilc *wilc;
 	int ret;
@@ -156,7 +156,7 @@ static int linux_sdio_probe(struct sdio_func *func,
 	return 0;
 }
=20
-static void linux_sdio_remove(struct sdio_func *func)
+static void wilc_sdio_remove(struct sdio_func *func)
 {
 	struct wilc *wilc =3D sdio_get_drvdata(func);
=20
@@ -1127,8 +1127,8 @@ static const struct dev_pm_ops wilc_sdio_pm_ops =3D {
 static struct sdio_driver wilc_sdio_driver =3D {
 	.name		=3D SDIO_MODALIAS,
 	.id_table	=3D wilc_sdio_ids,
-	.probe		=3D linux_sdio_probe,
-	.remove		=3D linux_sdio_remove,
+	.probe		=3D wilc_sdio_probe,
+	.remove		=3D wilc_sdio_remove,
 	.drv =3D {
 		.pm =3D &wilc_sdio_pm_ops,
 		.of_match_table =3D wilc_of_match,
--=20
2.7.4

