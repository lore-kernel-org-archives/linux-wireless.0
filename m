Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68974C433F4
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 161F321486
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 05:14:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="0zLhGxX+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 161F321486
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbeIXLOP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Sep 2018 07:14:15 -0400
Received: from mail-eopbgr700066.outbound.protection.outlook.com ([40.107.70.66]:28567
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727441AbeIXLOP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 07:14:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSLRPmTqOCHBzd9NN6JYdsch896jDqLJem6rKsjp4F4=;
 b=0zLhGxX+sbI/wJJmsTRyXHFMmybolMONVvPDX9UFTJPFix27/DkgZZ0+BxeehZCY/Ge/qPoQqnNrVmKp0gjO0Ddfneaz31+LslrA3TIzyA4tHlSWHJCBaJC/maaXyoF4ohaE1KVNCicnGQHmSiurqBoL3Djn/FYx+sYlT/t+uuw=
Received: from MWHPR05MB3326.namprd05.prod.outlook.com (10.174.174.165) by
 MWHPR05MB2975.namprd05.prod.outlook.com (10.168.246.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1143.11; Mon, 24 Sep 2018 05:13:32 +0000
Received: from MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc]) by MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::6d10:24a9:2432:b2dc%2]) with mapi id 15.20.1164.017; Mon, 24 Sep 2018
 05:13:32 +0000
From:   Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH 10/11] qtnfmac: wait for FW load work to finish at PCIe remove
Thread-Topic: [PATCH 10/11] qtnfmac: wait for FW load work to finish at PCIe
 remove
Thread-Index: AQHUU8VW9j44LsgSGUSDXLhFXSXbLQ==
Date:   Mon, 24 Sep 2018 05:13:32 +0000
Message-ID: <20180924051246.13371-11-igor.mitsyanko.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;MWHPR05MB2975;6:q9oDe/X5yzpTpHFKzREw0QaOHx4KHdBL/IV/Hq3IgDW29bP85tdkp9OkIRJpFegZ8VLrhgDNFyuva3KTTaX7YST8jazfNXi2kmsqtZEsYyJ9d8OkTcCZLF/WNWYknRUJuOL73NEKiTSg9a4Gfo3uaQ2doAeKYkR+u1DZ3WWzEtt5qK7f+Qaevt+ToU5EeprsI8+LWSFyRsV2HcE81hUE8zrc7fJ+MPG5cP25+OQT3fZHlAOMFwB3FD7qP397LVJy1YWI8zxzTa0d+1kWcjmKaP1nEASCpboQ10svH7aPg0tJtYseGvmwsWD1NKcJXX1PWQDhG1sXMPXB8BB2Ll0XlbNbxA5XUPnsxbCGw/Aly7WtEhw5QsQWlkAeQC52hE84Wwi3zn4rWzSvYK6DIe1x5osspg9gFg7juR3nTt7T/rXlfhTobkXeTPU8aLLjR4gM29qMdwMYeHU6og8xrhDTKQ==;5:9G8nhTcIRjbXdWkHVKX0w4sXcpBIYaZAzEhzKoAXY8FWYTw5HcfAxv89N6kHes6kLNVVoPEW0u2JD2RXBjw7EcRYU0d8emf9Dts0ALokCeay4mEgyWfKCOdqUMY2+QTgPe/jdd3qTYxJUZWpoYElB+lRtXPOODPPVh/MpQY+EE4=;7:Bh/pRG3WdAxaydUy0SoowCuoiDL5niDq1u31N5SKlYVulFNVTfY4XXRDc5oFBdjnRhGTj0/bbbTuFnZ1th7TIUR/WRygEP+r/FK70sOzwEN2WdtrF5DqpUxvcrxReeSzES7npaJogq2EMapdKtOrP1BrhCKg2gC819e+ZQb8KOywfRRaSOjQN/wPi98tpG6k5HYoXlhstnA+AcPVQfmOphQJMx8gUwq+z2/LGm2sK+CZqgAITPfyRQsv0cVP/1Ro
x-ms-office365-filtering-correlation-id: 972bfe25-b63f-4e50-1cf5-08d621dc78d3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MWHPR05MB2975;
x-ms-traffictypediagnostic: MWHPR05MB2975:
x-microsoft-antispam-prvs: <MWHPR05MB2975FCF944960F3DEFEF251AB0170@MWHPR05MB2975.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231355)(944501410)(52105095)(3002001)(10201501046)(149062)(150027)(6041310)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123558120)(201708071742011)(7699051)(76991041);SRVR:MWHPR05MB2975;BCL:0;PCL:0;RULEID:;SRVR:MWHPR05MB2975;
x-forefront-prvs: 0805EC9467
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(346002)(376002)(136003)(366004)(396003)(39840400004)(199004)(189003)(86362001)(68736007)(81166006)(52116002)(2900100001)(6916009)(99286004)(486006)(36756003)(316002)(2616005)(305945005)(71200400001)(71190400001)(6512007)(105586002)(106356001)(7736002)(107886003)(103116003)(8936002)(14444005)(14454004)(54906003)(81156014)(5250100002)(446003)(25786009)(478600001)(6486002)(97736004)(6116002)(1076002)(2501003)(5660300001)(3846002)(256004)(76176011)(66066001)(102836004)(6346003)(2906002)(5640700003)(26005)(53936002)(386003)(6506007)(6436002)(476003)(4326008)(186003)(8676002)(11346002)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB2975;H:MWHPR05MB3326.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=igor.mitsyanko.os@quantenna.com; 
x-microsoft-antispam-message-info: 0F5CbjCiEQ2/t8jNAuk9dumndAfaRYMZDGmFk7ZbLlCdiQwfT8JxvGFJ3uUxFtDKl90DB6EN9WhJ0YhZL+zb+/pDUa735t2kMUXqXOkgf8qSk+Qwa3Ax/V172uFcS5nfZQrMRTvrO5sOkDDQhNyXU3EFMIU1y0qn7anh43id4zHQmwMKk5mwwL3HRFIoW/GrkROodrgoPa7ODhNr6mAoNMV4kD9cEjpccwk7Y3Za/i/ba2A7XVe8/UDFxQBDdN9/fRI5mmXEdQ35U6pTbqimTSuMLB3ii3RbS98jegBXnMqjxiKNdcxT8I86Diflj0FwnylJSwTtf4weQ2f7GIz2+T2AfrtG59fqcE9rwgqLTXA=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 972bfe25-b63f-4e50-1cf5-08d621dc78d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2018 05:13:32.6369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2975
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org
Message-ID: <20180924051332.Ej1e52YraJV50tqlw4iTEQ4rX9uW2elejcLQH3L6aKM@z>

Waiting for "completion" to be set in FW load thread can not be used
in case PCIe remove is called before FW load work was scheduled.
Just wait for work completion instead to avoid problems.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/bus.h       | 1 -
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 4 +---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/bus.h b/drivers/net/wir=
eless/quantenna/qtnfmac/bus.h
index 7c4f856..528ca7f 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/bus.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/bus.h
@@ -62,7 +62,6 @@ struct qtnf_bus {
 	struct qtnf_hw_info hw_info;
 	struct napi_struct mux_napi;
 	struct net_device mux_dev;
-	struct completion firmware_init_complete;
 	struct workqueue_struct *workqueue;
 	struct work_struct fw_work;
 	struct work_struct event_work;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/n=
et/wireless/quantenna/qtnfmac/pcie/pcie.c
index ab42d11..fd2f1a1 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
@@ -143,7 +143,6 @@ void qtnf_pcie_fw_boot_done(struct qtnf_bus *bus, bool =
boot_success,
 		bus->fw_state =3D QTNF_FW_STATE_DETACHED;
 	}
=20
-	complete(&bus->firmware_init_complete);
 	put_device(&pdev->dev);
 }
=20
@@ -317,7 +316,6 @@ int qtnf_pcie_probe(struct pci_dev *pdev, size_t priv_s=
ize,
 	pcie_priv->pdev =3D pdev;
 	pcie_priv->tx_stopped =3D 0;
=20
-	init_completion(&bus->firmware_init_complete);
 	mutex_init(&bus->bus_lock);
 	spin_lock_init(&pcie_priv->tx_lock);
 	spin_lock_init(&pcie_priv->tx_reclaim_lock);
@@ -389,7 +387,7 @@ static void qtnf_pcie_free_shm_ipc(struct qtnf_pcie_bus=
_priv *priv)
=20
 void qtnf_pcie_remove(struct qtnf_bus *bus, struct qtnf_pcie_bus_priv *pri=
v)
 {
-	wait_for_completion(&bus->firmware_init_complete);
+	cancel_work_sync(&bus->fw_work);
=20
 	if (bus->fw_state =3D=3D QTNF_FW_STATE_ACTIVE ||
 	    bus->fw_state =3D=3D QTNF_FW_STATE_EP_DEAD)
--=20
2.9.5

