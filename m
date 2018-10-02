Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 386AFC004D2
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E868F20878
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="2hQ23aZW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E868F20878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbeJBQId (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 12:08:33 -0400
Received: from mail-by2nam01on0054.outbound.protection.outlook.com ([104.47.34.54]:16160
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726543AbeJBQIc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 12:08:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JlSkaE+yQZLKAYzAsOTKaJjjSOUZfwInx8SvaA4kVY8=;
 b=2hQ23aZWFnyew6JhUb5dVVKqbZP5JUPukQRnNINcTWb+rr/x9qSmY+0Pgxndz4x7CY3q8cuNE1iNyI+iqXrpm6l8u/snEtW6nsOEMnUSy2Y+HpwuIZaF81ifdlwXM09RoOAKmck6aDijxAaL6Ow44ddk4ywC7Q4uGmkAVLMyudo=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB5266.namprd05.prod.outlook.com (20.177.242.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.11; Tue, 2 Oct 2018 09:26:09 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a%3]) with mapi id 15.20.1185.024; Tue, 2 Oct 2018
 09:26:09 +0000
From:   Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko OS <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 12/13] qtnfmac: drop redundant data copy in control path
Thread-Topic: [PATCH 12/13] qtnfmac: drop redundant data copy in control path
Thread-Index: AQHUWjHzUCDo+hFy4kOmIIrSh4yV2w==
Date:   Tue, 2 Oct 2018 09:26:09 +0000
Message-ID: <20181002092542.18966-13-sergey.matyukevich.os@quantenna.com>
References: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR06CA0023.eurprd06.prod.outlook.com
 (2603:10a6:206:2::36) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5266;6:b0gxp2dT5i06EdT8vMToHSEuDTxdXoQYKrrOmYFG9Z5q3DHaaploz1788Agy/+xW9To+p/wtz1xywF4fBvS+ZrlFzgeMfY2zYaUCRzC+ohjuZG0MZYO4KuJZiKqD+YP8yN8m7OLngvppEs21IigOc3ypDpIxC1yXL7QJd0lWjlCWgCjO3WZjJbs9gvAQwpdWS/dLA2XthLLyacElUxQ+WXc8gssR57OZ0GxnquQFWcottraK80epTTiHX83upYS9ThyjvMXpNeoJXtF1spXBgFQ81k021U66IWBDT9WIycHg2HuTMc62n43cv1jfTTSJXDhVYoIgmI/bfxZvJSj3DMmzD0gNu0Wx5swoTqXDJB3IOugCSCF7A8qGyhjx3xyuJSNvZ3FpJNOgLWWy8ZdS7ASwD76CP53jVwZQ75hho5xUpViP06dW7oSjSncjCI+vFxBm+R+LwWYsjRvthSA+HQ==;5:0OiMIiwIwtZPpwvww4c6JnGRCiAuwhCOleNgcUvchgkZnXKuxEu4rISux4Vm0aB7GRTVdAkepMI5Ukh2rwXnO5fRPd5ZbLnHZDbMGK4hhdP7V5jfUcM6E79rVoOrVMUMvwDJuKzXl7nCAIyWfIHvcp63CZQJQUEMCG22bbjSXfg=;7:Ujmm+zQY8lHdS4kAwq4NLaNURShd0bEj9nHntwD0k1yB/mWGhOwHnb/Aw6plqSXg4x5LVurlSUULe4VnWcKvKGQz2g3YWrUzeU2G52+dGmIRDiRKohU4fauYDKb11yaBFxDXU7k7Z1RUP610FH7282lD2mu7IJRDn+bpLWUTre0wn08XXpI1gh+IV/y9mKPXiGVQ9mLrpyEIjmbMUVrldAIxI31NdbFvDNlN1oI1Nvfdd6QXjk503hei5a/376U0
x-ms-office365-filtering-correlation-id: b300b840-8b14-4cf3-c2bc-08d62849161b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5266;
x-ms-traffictypediagnostic: BL0PR05MB5266:
x-microsoft-antispam-prvs: <BL0PR05MB52665FCC4D4D2E42AAAF17BDA3E80@BL0PR05MB5266.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231355)(944501410)(52105095)(3002001)(10201501046)(149066)(150057)(6041310)(20161123564045)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051);SRVR:BL0PR05MB5266;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5266;
x-forefront-prvs: 0813C68E65
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(376002)(39850400004)(136003)(396003)(199004)(189003)(1076002)(316002)(105586002)(186003)(305945005)(11346002)(3846002)(486006)(5640700003)(256004)(6512007)(6436002)(8936002)(14454004)(476003)(36756003)(2351001)(106356001)(2616005)(81156014)(66066001)(81166006)(86362001)(54906003)(446003)(575784001)(68736007)(6116002)(5250100002)(107886003)(5660300001)(25786009)(71190400001)(6916009)(99286004)(2906002)(71200400001)(26005)(102836004)(2501003)(6506007)(386003)(52116002)(76176011)(478600001)(97736004)(103116003)(8676002)(6486002)(2900100001)(7736002)(4326008)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5266;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 5AohdGTOer72rlcLpEyZX6Zypj09IzyqWOHnG1gyQEk9y6bYB0QogKXhXSTxFpIe9AqToip/mPLdi12/wrO9T5k1cDug/DJUUDWdqxmP/mrI/J4C2IDHjj7XmPo9wICrCn2oXjzU0y5QZlcLthj8Swjzy2ZLCfMRLWpf0unfSmdphZrdu/5/xYSHOvI9z1SxLcO7som+tUR83445QOOV7aiqMbmo1npiC2QVNbp9XbwYuBH3slXzO1HJGrGM+/NkxHuyJHhyL9FQ5X+JRvwwc6odeSWAdFQNYCEmLp3Bxpb9fW8oz6holfhnQWAHZOPt32kkarzkuzX4H/HBAa8naDxOov3ncd0e23S/vn9C2ak=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b300b840-8b14-4cf3-c2bc-08d62849161b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2018 09:26:09.1818
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5266
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Command responses and events from the firmware are copied twice in
control path: at first in shm core (qtnf_shm_handle_new_data) and
then in pcie bus drivers (qtnf_pcie_control_rx_callback). There
is no need to copy this data twice, it can be done only once
in rx callbacks.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c |  5 +++--
 drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c   | 13 ++++++-------
 drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h   |  4 +---
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/n=
et/wireless/quantenna/qtnfmac/pcie/pcie.c
index d1637f2354a6..16795dbe475b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
@@ -242,7 +242,8 @@ static int qtnf_pcie_init_memory(struct qtnf_pcie_bus_p=
riv *priv)
 	return 0;
 }
=20
-static void qtnf_pcie_control_rx_callback(void *arg, const u8 *buf, size_t=
 len)
+static void qtnf_pcie_control_rx_callback(void *arg, const u8 __iomem *buf=
,
+					  size_t len)
 {
 	struct qtnf_pcie_bus_priv *priv =3D arg;
 	struct qtnf_bus *bus =3D pci_get_drvdata(priv->pdev);
@@ -260,7 +261,7 @@ static void qtnf_pcie_control_rx_callback(void *arg, co=
nst u8 *buf, size_t len)
 		return;
 	}
=20
-	skb_put_data(skb, buf, len);
+	memcpy_fromio(skb_put(skb, len), buf, len);
=20
 	qtnf_trans_handle_rx_ctl_packet(bus, skb);
 }
diff --git a/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c b/drivers/net=
/wireless/quantenna/qtnfmac/shm_ipc.c
index aa106dd0a14b..2ec334199c2b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c
@@ -42,19 +42,18 @@ static void qtnf_shm_handle_new_data(struct qtnf_shm_ip=
c *ipc)
 	if (unlikely(size =3D=3D 0 || size > QTN_IPC_MAX_DATA_SZ)) {
 		pr_err("wrong rx packet size: %zu\n", size);
 		rx_buff_ok =3D false;
-	} else {
-		memcpy_fromio(ipc->rx_data, ipc->shm_region->data, size);
+	}
+
+	if (likely(rx_buff_ok)) {
+		ipc->rx_packet_count++;
+		ipc->rx_callback.fn(ipc->rx_callback.arg,
+				    ipc->shm_region->data, size);
 	}
=20
 	writel(QTNF_SHM_IPC_ACK, &shm_reg_hdr->flags);
 	readl(&shm_reg_hdr->flags); /* flush PCIe write */
=20
 	ipc->interrupt.fn(ipc->interrupt.arg);
-
-	if (likely(rx_buff_ok)) {
-		ipc->rx_packet_count++;
-		ipc->rx_callback.fn(ipc->rx_callback.arg, ipc->rx_data, size);
-	}
 }
=20
 static void qtnf_shm_ipc_irq_work(struct work_struct *work)
diff --git a/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h b/drivers/net=
/wireless/quantenna/qtnfmac/shm_ipc.h
index 453dd6477b12..c2a3702a9ee7 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h
@@ -32,7 +32,7 @@ struct qtnf_shm_ipc_int {
 };
=20
 struct qtnf_shm_ipc_rx_callback {
-	void (*fn)(void *arg, const u8 *buf, size_t len);
+	void (*fn)(void *arg, const u8 __iomem *buf, size_t len);
 	void *arg;
 };
=20
@@ -51,8 +51,6 @@ struct qtnf_shm_ipc {
=20
 	u8 waiting_for_ack;
=20
-	u8 rx_data[QTN_IPC_MAX_DATA_SZ] __aligned(sizeof(u32));
-
 	struct qtnf_shm_ipc_int interrupt;
 	struct qtnf_shm_ipc_rx_callback rx_callback;
=20
--=20
2.11.0

