Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17270C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDE9E20645
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:12:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="ngKeIVW1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BDE9E20645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbeJERKZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 13:10:25 -0400
Received: from mail-sn1nam01on0065.outbound.protection.outlook.com ([104.47.32.65]:3040
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727354AbeJERKZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 13:10:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JlSkaE+yQZLKAYzAsOTKaJjjSOUZfwInx8SvaA4kVY8=;
 b=ngKeIVW1lbO2O/RIXLC9CH87blcE2xi6VE1V1nUpnHmMrr9XRxPIp3UETG8ef/VNnZlSndNUMgv4mQ6RVs0PdjdlmbUX2wJFd6ClBkMI2/KQLJri2lfhZXaIY3C2nVdy/CQfPeaVEUTDT5dIacgpupz9ln5InQxYmaxdUZ9VzqY=
Received: from BYAPR05MB4597.namprd05.prod.outlook.com (52.135.233.18) by
 BYAPR05MB4439.namprd05.prod.outlook.com (52.135.203.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.13; Fri, 5 Oct 2018 10:11:45 +0000
Received: from BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373]) by BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373%4]) with mapi id 15.20.1207.021; Fri, 5 Oct 2018
 10:11:45 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 12/13] qtnfmac: drop redundant data copy in control path
Thread-Topic: [PATCH v2 12/13] qtnfmac: drop redundant data copy in control
 path
Thread-Index: AQHUXJPRg67aDI8ig0WVAbmEnxP4yQ==
Date:   Fri, 5 Oct 2018 10:11:45 +0000
Message-ID: <20181005101114.3013-13-sergey.matyukevich.os@quantenna.com>
References: <20181005101114.3013-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181005101114.3013-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5P194CA0013.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:203:8f::23) To BYAPR05MB4597.namprd05.prod.outlook.com
 (2603:10b6:a03:4c::18)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR05MB4439;6:7JQnzgNIDHqBWdzRfIo2JoXFZh5loJ/hqLCHPiZg5jKNQy7KCT4pppe3sU0QWUKnIFO1AVb38aHHf/VYwJKVgPYG1h/dayBOb8mPLfgFO2fvhfleG7ki8NwtPoxQcB0fq//jGiTX2HMqfncdFnu6SRLqvf2mao4xKYf5OrX2Gv5RlZ1fRHcmVpG1GP92LwmU4uFy5wYECA8eU1tQ/22LkZHfiWML1eI+THITyRkHsXjpndxTIReNRMo0qumbtS87R2UsShF5UggFUkTYjLuZxSfcMJipRCA84g14xiLLVYju3K5SqVtU8cawSAieE7/bKchC28eZtnCIWiNYX33qu78xanRfLzcB3Ol2dwj7KaO3nHZHNttf42aHDBJXR4hrb8FRDwdqPP3IQ2ZdgUnrFo80EVpCDcz72B28zJBT1eBqViP56N3ENgLeppS6L3YcaCD07HM5JK6udYHaCbPXFA==;5:bxmA3/fHrUtSdgzlBvXqIYK9gXbeBDJEuBSqTL6aQjc5M8qQ1yVudvQJPUO99fVAVSoxpn5cnSm9bax2czAccLcZlt2LBg7sorCw9aoKvUAHxtqTeh5Xtdf2HXdYcx2cijPGQO6bqPdz2xeiRs8DJH5vSw3RcWLju9ry0UHIp/w=;7:JS9k6K9YdZp5SbzwNZaiIuRaZU+QRJ9j1Czjn8xh98VEt6/oVXZ8KCSL/v7WRtfNQKomsdEZcazWhZhoXUoRm2JMQ82qPz+HF11Lnfsd+owD4VkGaPzQbjF9aUVRsFwDaDhWVwNf0ikixNfSoNIdNJq1CULy0yCHwDvwv/VkZMo0Qc/pMIuEEbuTTnM3O5wKydudn+aiQQikuTCi0+H4qDg++uh/+rAg2eELdEKWMstsQSZ6dsVK6dTB2djGn5XC
x-ms-office365-filtering-correlation-id: 98bdb181-bc2c-4ceb-0bc5-08d62aaaf434
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB4439;
x-ms-traffictypediagnostic: BYAPR05MB4439:
x-microsoft-antispam-prvs: <BYAPR05MB443929BEAC1E89CE1C3AFB5BA3EB0@BYAPR05MB4439.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(10201501046)(93006095)(93001095)(3002001)(149066)(150057)(6041310)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123564045)(201708071742011)(7699051);SRVR:BYAPR05MB4439;BCL:0;PCL:0;RULEID:;SRVR:BYAPR05MB4439;
x-forefront-prvs: 0816F1D86E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39850400004)(396003)(366004)(136003)(189003)(199004)(305945005)(7736002)(26005)(1076002)(186003)(103116003)(2906002)(36756003)(2616005)(54906003)(256004)(86362001)(476003)(11346002)(446003)(14454004)(486006)(575784001)(6512007)(2351001)(316002)(106356001)(105586002)(8936002)(81156014)(81166006)(97736004)(8676002)(478600001)(53936002)(66066001)(5250100002)(5640700003)(6436002)(2900100001)(68736007)(2501003)(4326008)(71190400001)(6486002)(76176011)(71200400001)(102836004)(6506007)(386003)(5660300001)(6916009)(3846002)(99286004)(52116002)(6116002)(107886003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4439;H:BYAPR05MB4597.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: oa6yggRCTjmip5imySBrKygA52/E3ZCUh6sDp3cCoOYL1Op5ANKXPSjvNsD14Ar8CYzcAuvkfiGMFZh8baBENgQF43K7XNtRZwKv/ebM08YhsOLzUytFUJwFmNsmQwYBtFLG61yQYkc7yVPP13SvmBDIYVS4d+4Z/6Z/rkc3I/YXX5WR+3Rhy5PwjYlWzIur0giGpUsPv7bQNcjRtVL0YKcT/ox0qdgRrM3nD2ylkM7HQsNxx81U4UT4B5ofbZQ874TJTtk3fOi4toIWZCsNdpmNPUAX+ht1jd26ua7VXA5dOxD+5XzaJEgseSOgC7ptF+qvBLEwD7mS+rsH+UNaRFZX4Nt0ZecyYy6zRnsTTYA=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98bdb181-bc2c-4ceb-0bc5-08d62aaaf434
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2018 10:11:45.2844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4439
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

