Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986F2C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 11:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 572C021872
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 11:29:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="g6cXYr1B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfBGL3W (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 06:29:22 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:21405 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbfBGL3W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 06:29:22 -0500
X-IronPort-AV: E=Sophos;i="5.56,564,1539673200"; 
   d="scan'208";a="27383688"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 Feb 2019 04:29:18 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.38) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 7 Feb 2019 04:29:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=afOrfstXAiQi11aSr3LL7QeJgSTXfe4qk+yBMFZ4GH4=;
 b=g6cXYr1B31ruqR8szhBryGusvAUHbFJY2JcvKJqSF5ZqJvIv7ia8JEtBagXOhzSVHsvJcuHpcCd1UAAuas4iJxYxQLkvMwJt7Qvk2d5bABrGQoXRPu+bat1KxGHx8qtVFKDjgngvH57+QW2OpIdDbTpZEu/qSOSw2xddqmLCce4=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB2792.namprd11.prod.outlook.com (52.135.228.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Thu, 7 Feb 2019 11:29:17 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Thu, 7 Feb 2019
 11:29:17 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH v2 7/8] staging: wilc1000: remove 'linux_' prefix in function
 names
Thread-Topic: [PATCH v2 7/8] staging: wilc1000: remove 'linux_' prefix in
 function names
Thread-Index: AQHUvthc7XqXqz9sa0OaUcurwVt/8A==
Date:   Thu, 7 Feb 2019 11:29:16 +0000
Message-ID: <1549538913-17463-8-git-send-email-ajay.kathat@microchip.com>
References: <1549538913-17463-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549538913-17463-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0060.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::22) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [27.59.126.210]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB2792;6:ujSH6VRCEn7cxd3MTz+dFOncIcYpt0SN7TZGulHyqxnzQOma4W8zAMA5vmivHYeHysIXQ5eEg0oC3nily6SLu1+wjSdj6WTc6feERc0yuoxss1odrUOPYSWf5D2iEqKj8FZI/JYmxUGvtWhtY5sFmyjxdMRQ6IJ6FDjzbNwyJ++fKAwfVzQePqjzdL6ErB1aNl61NZPxFfsj2SunuSYbZjKmsWnQqSnP9mlne4yCq3HMLyF+ctVy5fO6alhT7hIKYGVqjXV5lobHvbw2tmZqR5TSc+9erdqclqBebXGcTdv9AUINLmR0B9TpYehcCS+rlFd3sUOr17el+leuK7qs2jMLAAyw3nDTp3/dJWFcGbJR/992B91gbz2pIbBRP+yGclUUEaBZUfE25q6znLqiNNAmYsj9LBB6BnhQfQWHElApHPWpsgxGbaI+WukhNI6cTZ1w33ca7oJOUK+6gIQI7A==;5:S8+ze6udOrAlf+4PZyy7MQGjFSq0CcfE4FCVvUTnM8FGsN3V3QD40/BO9FiTChY2kom+Ip8FxlgJpWVtAtDIXdeyTV169jPIky9+lHyt+T2gbDmew5A743iq8QLgin6vZ5FPZ2M1nkNPB/R9q1tJRsfbpI4mQp/E98HwgQIlfo+uDXBjXh8z6PTBg3WR9zPnoqLKufGZAazniigjUqdsyQ==;7:jMLYicyI09zugQ/UpnElRbD3g13nOymhK6qWWCtt0jdO4xTILk2UWFkAb7nMrtu6WKD3y7WW1IANLk3tiNpTSTjVBDBgzNecF+YD4jAsx/ZPZwM/thjhlJZd0aa9Vgdgt6AslIBr8T9dD5IVkgCw3w==
x-ms-office365-filtering-correlation-id: 5d0d30d6-2e5d-4ae5-8888-08d68cef7e82
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2792;
x-ms-traffictypediagnostic: BYAPR11MB2792:
x-microsoft-antispam-prvs: <BYAPR11MB279203328CEFF131F01BB653E3680@BYAPR11MB2792.namprd11.prod.outlook.com>
x-forefront-prvs: 0941B96580
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(366004)(376002)(39860400002)(189003)(199004)(2501003)(256004)(7736002)(68736007)(107886003)(81166006)(81156014)(305945005)(186003)(8676002)(8936002)(66066001)(50226002)(97736004)(52116002)(4326008)(11346002)(86362001)(316002)(25786009)(476003)(2616005)(54906003)(478600001)(6486002)(105586002)(486006)(6916009)(106356001)(6436002)(14454004)(6512007)(53936002)(2906002)(2351001)(71200400001)(71190400001)(6116002)(3846002)(386003)(6506007)(446003)(76176011)(36756003)(26005)(5640700003)(102836004)(99286004)(72206003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2792;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5ASW2wC+huSOu10Eu/ZfvFAPer/7LUFQc6zF7xJHRqcKg4g/JCUJPqcWkY+8bd4T/oqbA7v3mUAk71oZfdb/mqDTzH1irpxvCGst2Bu1qeGWzs5Y7WVIscji0538KgE9vs6M44H4HpzjWsCRb5DTAtQCyfabBn63NT+ivuvbm0st8xKWDaeM34U5WlhPQVDfymzlg4xZeBenyVoKFDnKxfqG6uSy26zxx4+y9rRCOzsu4BthQ8jkn3m5P1zUY36psEmvCFVU2DS1SMTQt4TBxt50iubLkVkMkbeOl+BK11W6srng8VlrtGKWKeCWMkPFJFmUaLvzLy8GSMyGIczzT7JVr90jp9GujzHR9l5L7BGXU2dY8dLejGdulPhLZ5bP7+K4P+VvyVzgxumPOfs2Di5JJi5RzxG1Da3U/CFf6b8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d0d30d6-2e5d-4ae5-8888-08d68cef7e82
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2019 11:29:14.3483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2792
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
index 1e2f6f4..1787154 100644
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

