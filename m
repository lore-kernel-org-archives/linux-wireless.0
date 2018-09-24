Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96023C433F4
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F4A621480
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:13:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="PDq5zI0V"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F4A621480
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbeIXLOK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Sep 2018 07:14:10 -0400
Received: from mail-eopbgr700066.outbound.protection.outlook.com ([40.107.70.66]:28567
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726366AbeIXLOJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 07:14:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Plo5lGVh7NrSvi2wRL6j+fFTh0Ub02ujTMeN7Oer85A=;
 b=PDq5zI0VLvOfGzokjTFARYJwN116ejKphHP+EkoyjVQ0FcqbA//n4HRQf7CGLTpXfAUW5U4L35rV5tqpIB6yud/RJHbSNARduFXtjBiTDSso03XUCwOiy0+TVt/PX8iyRFiEbuQMPTklW5AmZPHnrLQKFpULnevfP7v1SARTIek=
Received: from MWHPR05MB3326.namprd05.prod.outlook.com (10.174.174.165) by
 MWHPR05MB2975.namprd05.prod.outlook.com (10.168.246.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1143.11; Mon, 24 Sep 2018 05:13:27 +0000
Received: from MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc]) by MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc%2]) with mapi id 15.20.1164.017; Mon, 24 Sep 2018
 05:13:27 +0000
From:   Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH 05/11] qtnfmac_pcie: pearl: rename spinlock tx0_lock to
 tx_lock
Thread-Topic: [PATCH 05/11] qtnfmac_pcie: pearl: rename spinlock tx0_lock to
 tx_lock
Thread-Index: AQHUU8VTJgwfT3iaeEySKlKyRJn+bw==
Date:   Mon, 24 Sep 2018 05:13:27 +0000
Message-ID: <20180924051246.13371-6-igor.mitsyanko.os@quantenna.com>
References: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
In-Reply-To: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0002.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::15) To MWHPR05MB3326.namprd05.prod.outlook.com
 (2603:10b6:301:3d::37)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.131.200.68]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MWHPR05MB2975;6:dL58Ps4cDnrNWRQPOMGnRs1qSYpN7XmHi2P+7tzCTRZ3jzcrGjMzaXnkRfqzH4nLWFdnJKNi32cJk2/qu+3ebwJRkRwbpe2k9r+p8YqVKzVOGyy4SFtvw4O6hcDAN/z/c1yP6AcuR3mdvEolqsTWRorrAIn346P5E/dtOofpGGgsqSA7Kxu68QmEgjFro/fOoTczqH965I63J75D6qUwQ6LZEdNSaemCRGLIl7b5lapVWRhJIqP63TRoM+oQtl3SMlZK4pTt8IqAgtK2lTr7GrTNm8bq/Gip/LbGove53wytAI1zqJRli4pHX4J01oBo24JgL1xtlbtj5/uttGdhuM/MnJqmFArNfAyQOBMgIB17Vxy28I04lepRXJkOKeEjHuol4kojtD6cMSA3OmQzapOg3SSSrDkGMZS3qBs0O74hH4zZ4uff0pMw1/4HrC/iAjhzhoX7DDs/FQJX2VYwRg==;5:uNxODcCano0f2NFrpnSq1vfDkXBe19i/Rc1s7R/gz9AZXFlad/XTMj4KJ1yrrEj0sRo4e/lKY5thkvBeX2wnyJB+s7StZPUI2kyOGtEJCn+ETfmvxcEu+TcdGsj9Jh/L/ySIJEQAk0MBdEixTMqgYA1ySk5NdWxpzSA5zR5Vc/Y=;7:7GTovJ8gBEbYmnVvtfKn1xiwfPpr6vSHT49Laxezom302Bfj6ax3eaZZ6dmfk19MCytRHfAcpkbtzRtm97sP+RpMXBf3t1nbjsdVd2QR0Yqkd/qsYBoAEDFQ8kaeqAkst0oTObsOOPHLvKObuoilL13A6enTNeBBfUquXoCbL1CSKdDcvi8sKF3R5voCVP+wXcLeSwSItXVSaLE/4/12KiZwqYwKwoYSzkqRbr0dmZyknpPVaoiLdFtI7CTAsS5O
x-ms-office365-filtering-correlation-id: 95d8e2bb-e11d-4b67-3d72-08d621dc75f7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MWHPR05MB2975;
x-ms-traffictypediagnostic: MWHPR05MB2975:
x-microsoft-antispam-prvs: <MWHPR05MB2975F9B3957D04DD05D40093B0170@MWHPR05MB2975.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231355)(944501410)(52105095)(3002001)(10201501046)(149062)(150027)(6041310)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123558120)(201708071742011)(7699051)(76991041);SRVR:MWHPR05MB2975;BCL:0;PCL:0;RULEID:;SRVR:MWHPR05MB2975;
x-forefront-prvs: 0805EC9467
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(366004)(396003)(39840400004)(199004)(189003)(86362001)(68736007)(81166006)(52116002)(2900100001)(6916009)(99286004)(486006)(36756003)(316002)(2616005)(305945005)(71200400001)(71190400001)(6512007)(105586002)(106356001)(7736002)(107886003)(103116003)(8936002)(14444005)(14454004)(54906003)(81156014)(5250100002)(446003)(25786009)(478600001)(6486002)(97736004)(6116002)(1076002)(2501003)(5660300001)(3846002)(256004)(76176011)(66066001)(102836004)(6346003)(2906002)(5640700003)(26005)(53936002)(386003)(6506007)(6436002)(476003)(4326008)(186003)(8676002)(11346002)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB2975;H:MWHPR05MB3326.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=igor.mitsyanko.os@quantenna.com; 
x-microsoft-antispam-message-info: b0uZMe31wMLQcWgTMi2Ir6Kds1yCYoCkCMWl66zoLVcNkY70UTdZWzU2sboBzMSBhaDIw4VmWN50dD+uwWkHKj0QXJr4bug0XePyj/5JRIeqWbFU6tV1Iub1lUTYg2bpvhzfKsZa614rRds84V3lSY/dySoloMIlSKPJ2DqKZ5h9vEabBDNdxIgs/Q+5mvfEeQkHT6+q94iHeS68GCIXyZ2fYFhavaC3T/rcP7Z/Md1TSdChOFaRICQAKZpURpj36Q1LCznnylbV9VQ0InUzwHq6ZPQM/th3wheIDgyDTA6js7xuisK5v6cyxdUAJoQb/kFH7EXKahctpv7QOevA5y9Eeaza+deZ+qp6pmHctUE=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95d8e2bb-e11d-4b67-3d72-08d621dc75f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2018 05:13:27.8515
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2975
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org
Message-ID: <20180924051327.ibDVgxkj8JHPi7in-TaU02mxiO8zRgXskrsn_vRy0-U@z>

tx_lock name will later be reused when common pcie code is extracted to
separate files.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/dri=
vers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 4e9eb46..791a1e3 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -110,7 +110,7 @@ struct qtnf_pcie_pearl_state {
 	/* lock for tx reclaim operations */
 	spinlock_t tx_reclaim_lock;
 	/* lock for tx0 operations */
-	spinlock_t tx0_lock;
+	spinlock_t tx_lock;
 	u8 msi_enabled;
 	u8 tx_stopped;
 	int mps;
@@ -794,7 +794,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, stru=
ct sk_buff *skb)
 	u32 info;
 	int ret =3D 0;
=20
-	spin_lock_irqsave(&priv->tx0_lock, flags);
+	spin_lock_irqsave(&priv->tx_lock, flags);
=20
 	if (!qtnf_tx_queue_ready(priv)) {
 		if (skb->dev) {
@@ -802,7 +802,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, stru=
ct sk_buff *skb)
 			priv->tx_stopped =3D 1;
 		}
=20
-		spin_unlock_irqrestore(&priv->tx0_lock, flags);
+		spin_unlock_irqrestore(&priv->tx_lock, flags);
 		return NETDEV_TX_BUSY;
 	}
=20
@@ -852,7 +852,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, stru=
ct sk_buff *skb)
 	}
=20
 	priv->tx_done_count++;
-	spin_unlock_irqrestore(&priv->tx0_lock, flags);
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
=20
 	qtnf_pcie_data_tx_reclaim(priv);
=20
@@ -1404,7 +1404,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *id)
=20
 	init_completion(&bus->firmware_init_complete);
 	mutex_init(&bus->bus_lock);
-	spin_lock_init(&pcie_priv->tx0_lock);
+	spin_lock_init(&pcie_priv->tx_lock);
 	spin_lock_init(&pcie_priv->irq_lock);
 	spin_lock_init(&pcie_priv->tx_reclaim_lock);
=20
--=20
2.9.5

