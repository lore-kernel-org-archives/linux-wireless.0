Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF8BC32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 08:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0425E2081F
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 08:24:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="odmczB2E"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0425E2081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbeKBRa5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 13:30:57 -0400
Received: from mail-eopbgr700122.outbound.protection.outlook.com ([40.107.70.122]:9621
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726713AbeKBRa5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 13:30:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+FLCZ/1RuQrU1GpJGGHAL+Qs4hNvEeuD83mk4pstrPo=;
 b=odmczB2E7lwhwd0NmjiiiIlBm9Xs/5JS8uaGhzHVixP7ba+FOBkZ8DL5NlHvR+3YIkwyRuXv4bwdSyoJVelVUz+lj4S+x2NO5dOxXlodPwE9rLBiVgNnpyCkW8JL3DzGakZlrvD+MYhIMHW/uhdhdvpUGc+TU20rSxuP0qcxV4Y=
Received: from BYAPR06MB3992.namprd06.prod.outlook.com (52.135.200.22) by
 BYAPR06MB5062.namprd06.prod.outlook.com (20.177.186.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.26; Fri, 2 Nov 2018 08:24:33 +0000
Received: from BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986]) by BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986%3]) with mapi id 15.20.1294.024; Fri, 2 Nov 2018
 08:24:33 +0000
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
Subject: [PATCH v2 1/2] brcmfmac: add credit numbers updating support
Thread-Topic: [PATCH v2 1/2] brcmfmac: add credit numbers updating support
Thread-Index: AQHUcoV77Viu1Up5UUCF/8H+MssHlQ==
Date:   Fri, 2 Nov 2018 08:24:33 +0000
Message-ID: <20181102082403.11676-2-wright.feng@cypress.com>
References: <20181102082403.11676-1-wright.feng@cypress.com>
In-Reply-To: <20181102082403.11676-1-wright.feng@cypress.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: TYAPR01CA0164.jpnprd01.prod.outlook.com
 (2603:1096:404:7e::32) To BYAPR06MB3992.namprd06.prod.outlook.com
 (2603:10b6:a02:90::22)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [61.222.14.99]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR06MB5062;6:Qpj0vSpKfuYOgVm0MZZf2sNaOG6wK8rwlItjiwwhLqR4fbxASV/e5AmGoGCxrXd4IKy8R8ebKIfysgwb1/iPpJB6v3BU7gRRg4W7LcCpfDmXMDNtpoPvuj5b4eg/04bD094RSv2lzruPIivBwbkG4ffQ0M11lj3ItI6Rq/XT8yZfzATWbvlKgN/6CFhnyt5NkeSoMQ6+5XnKEePg1EHWTRhQG3B5PVxWY7OuhM0WfIDd1pR1ZGajhyD8qPrJbDv1p1m+wZcr7N2W9T4VJ4qX13Ko4+zZGXur+TUMMn+IHbgZd7bOQb4414MGNGTepvT+TCgll6kNFuo1Qcv/XpA0B3qfaACuT4rBLgoEapKX+iTNya6tceMO2JYNBrJQuJmJDhX1Sx7wDXMZZefTVBUp1ndMXhgM6NA3pLYTgBCRinD7qccU2oL0iUAksoKHLzbtpeswYnCyJ+Wi//cy+ZFukQ==;5:zhR6jKJzPNNVc03+l71rwTAUmA27+Lp9xp2OECyrFsRCPSiUd72iEC7Eq4QGh2AtNW3N85q1ta3Yuf61FTqYEvpMmrc9x0pVIt5j/DUPJucZu5GVvSfhaozplZ6N5Y4Axd1xfhJ/6imAaST5YNPEb96FGLOPfjFvoUNZi9Rt6S8=;7:bMECYtQzXYMftN+vbT97b4UI4dI6G00Tz2JRsDDno9W3IlEke+MvGe8BkwKu6VR3ss07TXKBqk2CxVbMUVPWvf3OPErsf/Xw/YwywxZNR9DzQBLPana2FUWGG4uEO7wmIxtEwyHvTeCrh3ild6Gc9A==
x-ms-office365-filtering-correlation-id: 90029e7a-6ad7-44b6-7367-08d6409c9e1c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BYAPR06MB5062;
x-ms-traffictypediagnostic: BYAPR06MB5062:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-microsoft-antispam-prvs: <BYAPR06MB50620EE2A30309DEDB37F803FBCF0@BYAPR06MB5062.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(788757137089)(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(3231382)(944501410)(52105095)(3002001)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BYAPR06MB5062;BCL:0;PCL:0;RULEID:;SRVR:BYAPR06MB5062;
x-forefront-prvs: 08444C7C87
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(39860400002)(366004)(376002)(346002)(189003)(199004)(7736002)(6436002)(256004)(71200400001)(8936002)(14444005)(71190400001)(97736004)(66066001)(316002)(3846002)(81156014)(5660300001)(76176011)(81166006)(6116002)(25786009)(8676002)(476003)(102836004)(446003)(478600001)(99286004)(2501003)(11346002)(26005)(106356001)(2351001)(105586002)(44832011)(6506007)(386003)(4326008)(52116002)(2900100001)(54906003)(305945005)(2616005)(486006)(2906002)(6486002)(86362001)(72206003)(5640700003)(186003)(14454004)(36756003)(1076002)(53936002)(68736007)(6916009)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR06MB5062;H:BYAPR06MB3992.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 0pKdJ6FUiuNWdpGN6CDXbEvgewuG6DTF3wO/LEgzVifn0kouIdY5FPl04YCXOIuklLusZZKXlB0Z8HXt9cFRauGhBkM14ig+EME13qYSD2EwpLqh9OC+jkgC/9JceZ8vk1w3AJSS3wXEnCyiBhlennRmj3H40MaYxgCiJHcId2hFByvQEOiXVKTuM75f/W1hfjSMxOAh4O7BTQi3lbDjO25A5d1kHKEocKmwI9py2pl+h9FHzhcwllEP3+0vuMyZd36FZzuPFmQhWlWmPPkgfjIo4ym1DpJrfHbjjp68MROMy/9kmC7jqLBr3/U9PMxk+aW86+C23TakzM3NYgJYJcEfHGhXwzwTMd29+QGpZP0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90029e7a-6ad7-44b6-7367-08d6409c9e1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2018 08:24:33.4838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB5062
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The credit numbers are static and tunable per chip in firmware side.
However the credit number may be changed that is based on packet pool
length and will send BRCMF_E_FIFO_CREDIT_MAP event to notify host driver
updates the credit numbers during interface up.
The purpose of this patch is making host driver has ability of updating
the credit numbers when receiving the BRCMF_E_FIFO_CREDIT_MAP event.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
---
v2: replace brcmf_err with WARN_ONCE
---
 .../broadcom/brcm80211/brcmfmac/fwsignal.c    | 23 ++++++++++++-------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index f3cbf78c8899..c75be2703b3e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -511,6 +511,7 @@ struct brcmf_fws_info {
 	struct work_struct fws_dequeue_work;
 	u32 fifo_enqpkt[BRCMF_FWS_FIFO_COUNT];
 	int fifo_credit[BRCMF_FWS_FIFO_COUNT];
+	int init_fifo_credit[BRCMF_FWS_FIFO_COUNT];
 	int credits_borrowed[BRCMF_FWS_FIFO_AC_VO + 1];
 	int deq_node_pos[BRCMF_FWS_FIFO_COUNT];
 	u32 fifo_credit_map;
@@ -1237,6 +1238,9 @@ static void brcmf_fws_return_credits(struct brcmf_fws=
_info *fws,
 	}
=20
 	fws->fifo_credit[fifo] +=3D credits;
+	if (fws->fifo_credit[fifo] > fws->init_fifo_credit[fifo])
+		fws->fifo_credit[fifo] =3D fws->init_fifo_credit[fifo];
+
 }
=20
 static void brcmf_fws_schedule_deq(struct brcmf_fws_info *fws)
@@ -1595,19 +1599,21 @@ static int brcmf_fws_notify_credit_map(struct brcmf=
_if *ifp,
 		brcmf_err("event payload too small (%d)\n", e->datalen);
 		return -EINVAL;
 	}
-	if (fws->creditmap_received)
-		return 0;
=20
 	fws->creditmap_received =3D true;
=20
 	brcmf_dbg(TRACE, "enter: credits %pM\n", credits);
 	brcmf_fws_lock(fws);
 	for (i =3D 0; i < ARRAY_SIZE(fws->fifo_credit); i++) {
-		if (*credits)
+		fws->fifo_credit[i] +=3D credits[i] - fws->init_fifo_credit[i];
+		fws->init_fifo_credit[i] =3D credits[i];
+		if (fws->fifo_credit[i] > 0)
 			fws->fifo_credit_map |=3D 1 << i;
 		else
 			fws->fifo_credit_map &=3D ~(1 << i);
-		fws->fifo_credit[i] =3D *credits++;
+		WARN_ONCE(fws->fifo_credit[i] < 0,
+			  "fifo_credit[%d] is negative(%d)\n", i,
+			  fws->fifo_credit[i]);
 	}
 	brcmf_fws_schedule_deq(fws);
 	brcmf_fws_unlock(fws);
@@ -2013,7 +2019,7 @@ static int brcmf_fws_borrow_credit(struct brcmf_fws_i=
nfo *fws)
 	}
=20
 	for (lender_ac =3D 0; lender_ac <=3D BRCMF_FWS_FIFO_AC_VO; lender_ac++) {
-		if (fws->fifo_credit[lender_ac]) {
+		if (fws->fifo_credit[lender_ac] > 0) {
 			fws->credits_borrowed[lender_ac]++;
 			fws->fifo_credit[lender_ac]--;
 			if (fws->fifo_credit[lender_ac] =3D=3D 0)
@@ -2210,8 +2216,9 @@ static void brcmf_fws_dequeue_worker(struct work_stru=
ct *worker)
 			}
 			continue;
 		}
-		while ((fws->fifo_credit[fifo]) || ((!fws->bcmc_credit_check) &&
-		       (fifo =3D=3D BRCMF_FWS_FIFO_BCMC))) {
+		while ((fws->fifo_credit[fifo] > 0) ||
+		       ((!fws->bcmc_credit_check) &&
+			(fifo =3D=3D BRCMF_FWS_FIFO_BCMC))) {
 			skb =3D brcmf_fws_deq(fws, fifo);
 			if (!skb)
 				break;
@@ -2222,7 +2229,7 @@ static void brcmf_fws_dequeue_worker(struct work_stru=
ct *worker)
 				break;
 		}
 		if ((fifo =3D=3D BRCMF_FWS_FIFO_AC_BE) &&
-		    (fws->fifo_credit[fifo] =3D=3D 0) &&
+		    (fws->fifo_credit[fifo] <=3D 0) &&
 		    (!fws->bus_flow_blocked)) {
 			while (brcmf_fws_borrow_credit(fws) =3D=3D 0) {
 				skb =3D brcmf_fws_deq(fws, fifo);
--=20
2.19.1

