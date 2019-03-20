Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16066C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF30D2184E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="YTOccwVZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbfCTKFU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:05:20 -0400
Received: from mail-eopbgr750073.outbound.protection.outlook.com ([40.107.75.73]:64128
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726922AbfCTKFT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 06:05:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFvWZXZPKt6Tm02zJm8z0/WooYTzEfrQl3CHuD0Song=;
 b=YTOccwVZK5gWZbX0cdgOB4beIFMP/EVofM78tjwgQiCuLub8V18MK2dTRaVV/1k0qvT0u1euAK4V/IkQFWFtJuVYXFgMgUfWJFJZlrl3oPfX6s2ssRGYg4lIef8NqRYgv2OPaxYdZGv+1Y5+s/OtQOHcd6uRcemUpWpjjD8ujtY=
Received: from SN6PR05MB3952.namprd05.prod.outlook.com (52.132.125.24) by
 SN6PR05MB3950.namprd05.prod.outlook.com (52.132.125.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.5; Wed, 20 Mar 2019 10:05:15 +0000
Received: from SN6PR05MB3952.namprd05.prod.outlook.com
 ([fe80::1919:d446:7250:b010]) by SN6PR05MB3952.namprd05.prod.outlook.com
 ([fe80::1919:d446:7250:b010%5]) with mapi id 15.20.1730.013; Wed, 20 Mar 2019
 10:05:15 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5661.namprd05.prod.outlook.com (52.135.111.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.15; Wed, 20 Mar 2019 10:04:05 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:04:05 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 10/14] qtnfmac: simplify firmware state tracking
Thread-Topic: [PATCH 10/14] qtnfmac: simplify firmware state tracking
Thread-Index: AQHU3wQ/DJAHy2WlYU6HX+UIZrhFPw==
Date:   Wed, 20 Mar 2019 10:04:04 +0000
Message-ID: <20190320100340.14168-11-sergey.matyukevich.os@quantenna.com>
References: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0106.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::47) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.11.0
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 024dab55-e6cf-4017-49e8-08d6ad1b61d8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5661;
x-ms-traffictypediagnostic: SN6PR05MB5661:|SN6PR05MB3950:
x-moderation-data: 3/20/2019 10:05:13 AM
x-microsoft-antispam-prvs: <SN6PR05MB39504EAE314961FB1A72FA2EA3410@SN6PR05MB3950.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(396003)(376002)(136003)(39850400004)(189003)(199004)(103116003)(486006)(36756003)(2616005)(11346002)(476003)(5640700003)(305945005)(4326008)(256004)(6486002)(5024004)(6436002)(50226002)(446003)(6916009)(436003)(186003)(7736002)(1076003)(107886003)(478600001)(25786009)(106356001)(105586002)(2906002)(2351001)(54906003)(6512007)(3846002)(6116002)(8936002)(316002)(97736004)(14454004)(53936002)(52116002)(86362001)(5660300002)(76176011)(81166006)(81156014)(99286004)(8676002)(26005)(71200400001)(71190400001)(2501003)(102836004)(66066001)(6506007)(386003)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB3950;H:SN6PR05MB3952.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tFVosfNCWxHbXqUCExACefwZd8i8V1uJLj9GoeBaH1StvNjdh0aRLcKIkquRQBovSBIYrffxYio8zEYuxIY36t+0eq+MsnNajutuqCT8/8nkZ1J+KveDePKfD09O4qGQqBn3wEge+sCrqznQt7+IPWVTp+/m6eV0DHrZrQN1w/0NxamcoWrIniKw2KI2npb8xWOh+lm5NS1SVQbYaQDVsTSb8MMZ3JhxHDoK55DgK1J4m6B0YxsybGjYhYTLlrPgS6I94/Yng+X5wPSD8veDhZcFaF8wyd0pmVJfN7aQzh8khsTpd3Ew0p3+8qWy9u8F9j8hfvsTP75chF5wp6mGbIqgw42gArkI7pIy7WiG5anj+kLhqU+CZgHog2JBtGoXGCTnGnpO9U2q7znE5V1dgo37elxGSspqhFMO2Ek1bMs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 024dab55-e6cf-4017-49e8-08d6ad1b61d8
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 10:05:15.2366
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB3950
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch streamlines firmware state tracking. In particular, state
QTNF_FW_STATE_FW_DNLD_DONE is removed, states QTNF_FW_STATE_RESET and
QTNF_FW_STATE_DETACHED are merged into a single state. Besides, new
state QTNF_FW_STATE_RUNNING is introduced to distinguish between
the following two cases:
- firmware load succeeded, firmware init process is ongoing
- firmware init succeeded, firmware is fully functional

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/bus.h       | 24 ++++++++++++++++++=
----
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |  3 +--
 drivers/net/wireless/quantenna/qtnfmac/core.c      |  8 +++++---
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 10 ++++-----
 4 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/bus.h b/drivers/net/wir=
eless/quantenna/qtnfmac/bus.h
index 14b569b6d1b5..dc1bd32d4827 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/bus.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/bus.h
@@ -13,12 +13,11 @@
 #define QTNF_MAX_MAC		3
=20
 enum qtnf_fw_state {
-	QTNF_FW_STATE_RESET,
-	QTNF_FW_STATE_FW_DNLD_DONE,
+	QTNF_FW_STATE_DETACHED,
 	QTNF_FW_STATE_BOOT_DONE,
 	QTNF_FW_STATE_ACTIVE,
-	QTNF_FW_STATE_DETACHED,
-	QTNF_FW_STATE_EP_DEAD,
+	QTNF_FW_STATE_RUNNING,
+	QTNF_FW_STATE_DEAD,
 };
=20
 struct qtnf_bus;
@@ -58,6 +57,23 @@ struct qtnf_bus {
 	char bus_priv[0] __aligned(sizeof(void *));
 };
=20
+static inline bool qtnf_fw_is_up(struct qtnf_bus *bus)
+{
+	enum qtnf_fw_state state =3D bus->fw_state;
+
+	return ((state =3D=3D QTNF_FW_STATE_ACTIVE) ||
+		(state =3D=3D QTNF_FW_STATE_RUNNING));
+}
+
+static inline bool qtnf_fw_is_attached(struct qtnf_bus *bus)
+{
+	enum qtnf_fw_state state =3D bus->fw_state;
+
+	return ((state =3D=3D QTNF_FW_STATE_ACTIVE) ||
+		(state =3D=3D QTNF_FW_STATE_RUNNING) ||
+		(state =3D=3D QTNF_FW_STATE_DEAD));
+}
+
 static inline void *get_bus_priv(struct qtnf_bus *bus)
 {
 	if (WARN(!bus, "qtnfmac: invalid bus pointer"))
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index 2e658e394dc6..a04321305ebc 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -89,8 +89,7 @@ static int qtnf_cmd_send_with_reply(struct qtnf_bus *bus,
=20
 	pr_debug("VIF%u.%u cmd=3D0x%.4X\n", mac_id, vif_id, cmd_id);
=20
-	if (bus->fw_state !=3D QTNF_FW_STATE_ACTIVE &&
-	    cmd_id !=3D QLINK_CMD_FW_INIT) {
+	if (!qtnf_fw_is_up(bus) && cmd_id !=3D QLINK_CMD_FW_INIT) {
 		pr_warn("VIF%u.%u: drop cmd 0x%.4X in fw state %d\n",
 			mac_id, vif_id, cmd_id, bus->fw_state);
 		dev_kfree_skb(cmd_skb);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wi=
reless/quantenna/qtnfmac/core.c
index f04f4e1f7d68..eed12e4dec65 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -589,8 +589,6 @@ int qtnf_core_attach(struct qtnf_bus *bus)
 	int ret;
=20
 	qtnf_trans_init(bus);
-
-	bus->fw_state =3D QTNF_FW_STATE_BOOT_DONE;
 	qtnf_bus_data_rx_start(bus);
=20
 	bus->workqueue =3D alloc_ordered_workqueue("QTNF_BUS", 0);
@@ -639,6 +637,7 @@ int qtnf_core_attach(struct qtnf_bus *bus)
 		}
 	}
=20
+	bus->fw_state =3D QTNF_FW_STATE_RUNNING;
 	return 0;
=20
 error:
@@ -657,7 +656,7 @@ void qtnf_core_detach(struct qtnf_bus *bus)
 	for (macid =3D 0; macid < QTNF_MAX_MAC; macid++)
 		qtnf_core_mac_detach(bus, macid);
=20
-	if (bus->fw_state =3D=3D QTNF_FW_STATE_ACTIVE)
+	if (qtnf_fw_is_up(bus))
 		qtnf_cmd_send_deinit_fw(bus);
=20
 	bus->fw_state =3D QTNF_FW_STATE_DETACHED;
@@ -683,6 +682,9 @@ struct net_device *qtnf_classify_skb(struct qtnf_bus *b=
us, struct sk_buff *skb)
 	struct qtnf_wmac *mac;
 	struct qtnf_vif *vif;
=20
+	if (unlikely(bus->fw_state !=3D QTNF_FW_STATE_RUNNING))
+		return NULL;
+
 	meta =3D (struct qtnf_frame_meta_info *)
 		(skb_tail_pointer(skb) - sizeof(*meta));
=20
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/n=
et/wireless/quantenna/qtnfmac/pcie/pcie.c
index a693667a83d7..b561b75e4433 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
@@ -56,7 +56,7 @@ int qtnf_pcie_control_tx(struct qtnf_bus *bus, struct sk_=
buff *skb)
=20
 	if (ret =3D=3D -ETIMEDOUT) {
 		pr_err("EP firmware is dead\n");
-		bus->fw_state =3D QTNF_FW_STATE_EP_DEAD;
+		bus->fw_state =3D QTNF_FW_STATE_DEAD;
 	}
=20
 	return ret;
@@ -132,11 +132,10 @@ int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus)
 {
 	int ret;
=20
-	bus->fw_state =3D QTNF_FW_STATE_FW_DNLD_DONE;
+	bus->fw_state =3D QTNF_FW_STATE_BOOT_DONE;
 	ret =3D qtnf_core_attach(bus);
 	if (ret) {
 		pr_err("failed to attach core\n");
-		bus->fw_state =3D QTNF_FW_STATE_DETACHED;
 	} else {
 		qtnf_debugfs_init(bus, DRV_NAME);
 		qtnf_debugfs_add_entry(bus, "mps", qtnf_dbg_mps_show);
@@ -335,7 +334,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const =
struct pci_device_id *id)
 	pcie_priv =3D get_bus_priv(bus);
 	pci_set_drvdata(pdev, bus);
 	bus->dev =3D &pdev->dev;
-	bus->fw_state =3D QTNF_FW_STATE_RESET;
+	bus->fw_state =3D QTNF_FW_STATE_DETACHED;
 	pcie_priv->pdev =3D pdev;
 	pcie_priv->tx_stopped =3D 0;
 	pcie_priv->rx_bd_num =3D rx_bd_size_param;
@@ -410,8 +409,7 @@ static void qtnf_pcie_remove(struct pci_dev *dev)
=20
 	cancel_work_sync(&bus->fw_work);
=20
-	if (bus->fw_state =3D=3D QTNF_FW_STATE_ACTIVE ||
-	    bus->fw_state =3D=3D QTNF_FW_STATE_EP_DEAD)
+	if (qtnf_fw_is_attached(bus))
 		qtnf_core_detach(bus);
=20
 	netif_napi_del(&bus->mux_napi);
--=20
2.11.0

