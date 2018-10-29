Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E2EC0044C
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 10:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6D5C2054F
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 10:27:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="CCYd2o8u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6D5C2054F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbeJ2TPV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 15:15:21 -0400
Received: from mail-cys01nam02on0099.outbound.protection.outlook.com ([104.47.37.99]:12800
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729343AbeJ2TPU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 15:15:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8MIw5v4RwwWBVyczMTCb0mEDlc3uPnCC2Wvd0eLrsNU=;
 b=CCYd2o8uTBqX5DbgoMUKB36/NikSHTMh/EL5xDxKkxGirnKluIDrA3MP+OiNBI57dLj4xhkQ9q9DQiLZFLZtaaiCorJk/BQc/ZnIHO+FZ/Q16ScA7Iz9F2AzoydsWe0tHXHK+qlKEwNosopQ3Z6wAido4mCZ1W62qWpDbKzcz0c=
Received: from BYAPR06MB3992.namprd06.prod.outlook.com (52.135.200.22) by
 BYAPR06MB5303.namprd06.prod.outlook.com (20.178.50.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.24; Mon, 29 Oct 2018 10:27:15 +0000
Received: from BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::e059:d46e:4de6:4bae]) by BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::e059:d46e:4de6:4bae%2]) with mapi id 15.20.1273.027; Mon, 29 Oct 2018
 10:27:15 +0000
From:   Wright Feng <Wright.Feng@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Wright Feng <Wright.Feng@cypress.com>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
Subject: [PATCH 1/3] brcmfmac: calling skb_orphan before sending skb to SDIO
 bus
Thread-Topic: [PATCH 1/3] brcmfmac: calling skb_orphan before sending skb to
 SDIO bus
Thread-Index: AQHUb3H2+mORDXs3gE6Xp6/NyHTPOA==
Date:   Mon, 29 Oct 2018 10:27:15 +0000
Message-ID: <1540808552-28738-2-git-send-email-wright.feng@cypress.com>
References: <1540808552-28738-1-git-send-email-wright.feng@cypress.com>
In-Reply-To: <1540808552-28738-1-git-send-email-wright.feng@cypress.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: OSAPR01CA0097.jpnprd01.prod.outlook.com
 (2603:1096:604:e::13) To BYAPR06MB3992.namprd06.prod.outlook.com
 (2603:10b6:a02:90::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [61.222.14.99]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR06MB5303;6:FyjRf/VJEcDUpPYniaHWs63lJDL3gHlWHFl6cvf4/6o7Wwi9aEvVwCtSiZoIVWaPHJHk1hgnWCm/g+Tym1rI8D1/uW05+af63BIzGMJjGs5eIDFfHsiwDHbYesejLinsptkvO4rZDuoup+Cto/R3erIH9YROASxgjseyDZ+EwAoVPh+65VGwV4Dbnq+oYzzbu0p/a6m+qYqhhni6gLV1kumg9SbTYqZ5l/NHE+rWN1ZjL0l/Yrhc8wPQpDrqG13+wAlrLWKYu6J7ZE6RU48d9d5c7+JIwukc3FHilVRc1Bc1RkTjMM6zOWwhr1rwy/78OvQWqp9KGzIL0sLSsV7+5TTV4yRKTE8wJrPRLhRui8yKNC3Tsk3cHnnDiiJhtMj4P9sN8hs3ryi/Ux7y66EQez6lifwFDCbHE4qJhpBE+6S+vcPN5Y67eI99lJCbBzHOrVuSJG6rFI+NnmXV5tFGGg==;5:P+pJpeKez8PLC7p9bzv+MQAdq5qz8XeKh4nq0+wvyff1N/YGrxrL3PqcAUCBYEzemnveOCbY/nhCCluezyCAO0wvjvi7BjXpfFfp+35ytLPzdNtKhOdlSaAEFwWm5Ge+UKDyYqYpJYa9iUIUQragDUJFB4ayUm7WKelF1KflR/c=;7:klefBSkux3x2/aIav12qpyHjpySX3n6wGrIPUgOt6PzyWtjYz3V2nJxBWiHRSzaikrABxpaml6l3rATXxwKOuL9/a6/5obKYKM89ATSc0TLMmuC9rG3PoQEvOYwQ54sSLVA7fFP2SgGzRbelp0H0Lg==
x-ms-office365-filtering-correlation-id: e58610a2-14eb-47fc-4cfa-08d63d891887
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BYAPR06MB5303;
x-ms-traffictypediagnostic: BYAPR06MB5303:
x-microsoft-antispam-prvs: <BYAPR06MB5303B31ACA940029B1AFEE6CFBF30@BYAPR06MB5303.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(60795455431006)(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(93006095)(93001095)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123564045)(20161123560045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BYAPR06MB5303;BCL:0;PCL:0;RULEID:;SRVR:BYAPR06MB5303;
x-forefront-prvs: 084080FC15
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(346002)(39860400002)(366004)(376002)(199004)(189003)(305945005)(71200400001)(26005)(71190400001)(2900100001)(2501003)(72206003)(6916009)(105586002)(5250100002)(7736002)(5660300001)(86362001)(2351001)(68736007)(106356001)(476003)(2616005)(11346002)(486006)(6436002)(8936002)(99286004)(36756003)(2906002)(256004)(81166006)(81156014)(8676002)(316002)(14444005)(5640700003)(6486002)(54906003)(4326008)(6506007)(76176011)(44832011)(25786009)(386003)(478600001)(102836004)(446003)(14454004)(53936002)(186003)(6512007)(97736004)(3846002)(66066001)(52116002)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR06MB5303;H:BYAPR06MB3992.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: QOHY/kQCedhNg3mIb/5sqSpnw5hAio0r78cmiDRE9QC4DUuvo6/aFlUMbOkchJF51txpKp5qgsJss6QJWEUDaGKb2jNJ0QAokGDeFjLzI5dd8ckmCrThaCtY4M8b/jrMJDk/K9+dOYETsrhrGe7SLyC1fCYSqJ3KC+uO/owD1PXI6k0yeJCuEr4D1wHvozRoNx5e0rognFqVwjGCarBbrxGgM0ABr/8KZ56qLVKnc/a39hCyHJ2aY9+HSDlOq97vCJJkUnl3hLQrOwBniu+gLhkC4+JbhUmhM1NMbs0CM4fYrGWEbktpAqxQ3M0VnD2mQaB0zPzuPUvxGurr5lTQKttsIA+QT3ZcaMstrbLD8QM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e58610a2-14eb-47fc-4cfa-08d63d891887
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2018 10:27:15.2869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB5303
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Linux 3.6 introduces TSQ which has a per socket threshold for TCP Tx
packets to reduce latency. In fcmode 1 and fcmode 2, host driver enqueues
skb in hanger and TCP doesn't push new skb until host frees the skb when
receiving fwstatus event. So using skb_orphan before sending skb to bus
will make the skb removing the ownership of socket. With this patch, we
are able to get better throughput in fcmode 1 and fcmode 2.

Tested 43455 TCP throughput in 20 MHz bandwidth with / without this patch.
fcmode 0: 59.5 / 59.6 (mbps)
fcmode 1: 59.3 / 23.4 (mbps)
fcmode 2: 59.6 / 21.5 (mbps)

Signed-off-by: Wright Feng <wright.feng@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index b2e1ab5..519b25d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -2298,6 +2298,7 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *b=
us, uint maxframes)
 					      &prec_out);
 			if (pkt =3D=3D NULL)
 				break;
+			skb_orphan(pkt);
 			__skb_queue_tail(&pktq, pkt);
 		}
 		spin_unlock_bh(&bus->txq_lock);
--=20
1.9.1

