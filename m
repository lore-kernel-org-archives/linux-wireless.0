Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7055BC0044C
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 10:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D7F620827
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 10:27:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="N6+tG9iL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D7F620827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729755AbeJ2TP2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 15:15:28 -0400
Received: from mail-cys01nam02on0105.outbound.protection.outlook.com ([104.47.37.105]:34496
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729602AbeJ2TP2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 15:15:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxtaMbL0MmM02vbaZiD1cBAcAtxCsGMO3pG1bWFq7zo=;
 b=N6+tG9iLLCqh1idwKON8xXlBbycS4yr6TQZ6Vt3lsdH1cYw7n6UZ00O5cKNq7kIekmMuTfddeMvWVEp+PVr1c8hXbtR+13LYWc8hyDU1zz+SMpNwyFrAPnz9Dfh4+YSzaxW7TZo5q4nZ7a/Bz8aiJ1oyNm53GCZddoz3G8O01lA=
Received: from BYAPR06MB3992.namprd06.prod.outlook.com (52.135.200.22) by
 BYAPR06MB5303.namprd06.prod.outlook.com (20.178.50.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.24; Mon, 29 Oct 2018 10:27:21 +0000
Received: from BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::e059:d46e:4de6:4bae]) by BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::e059:d46e:4de6:4bae%2]) with mapi id 15.20.1273.027; Mon, 29 Oct 2018
 10:27:21 +0000
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
Subject: [PATCH 2/3] brcmfmac: add credit numbers updating support
Thread-Topic: [PATCH 2/3] brcmfmac: add credit numbers updating support
Thread-Index: AQHUb3H6UjCqWYxoE0WZE4qJFjplhg==
Date:   Mon, 29 Oct 2018 10:27:21 +0000
Message-ID: <1540808552-28738-3-git-send-email-wright.feng@cypress.com>
References: <1540808552-28738-1-git-send-email-wright.feng@cypress.com>
In-Reply-To: <1540808552-28738-1-git-send-email-wright.feng@cypress.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: TYAPR01CA0025.jpnprd01.prod.outlook.com
 (2603:1096:404:28::13) To BYAPR06MB3992.namprd06.prod.outlook.com
 (2603:10b6:a02:90::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [61.222.14.99]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR06MB5303;6:jZ3pA9pMhKwtJp8bfn/XlXP7WAksODduY01l1+vmkFoM0xgML+W/h2Bhjw7xcdkCXkxup/aWBNEl9HDsVWaRKnIFu8gttLz2nPbzxp7KBa+eSfF0jLFWXkDDk199VIPcpXuKyzYN4Zs8Osme4WXDO8oupoleILx7o4v9rnm/rL1n+VoXWLhT6odSu/M18GgA/W2XHrAl3geco05cLtYB4LV+HwcqT4FufLSN8j/x5ysYLBg74LIAdTPmVZ0nJ08Fh5FxSOKtQZJrVXUTPGVKqlXb6Zapp3ViH8YmhyK/NMxhQnhnFJIF82LYJlgFXFBCY3OcSjNWFm3wMQ9FsGy2jvMLTsCId/f7VtQbzTTFufAFuG95oqev+3DKrWZEO6PP/QeNsg/UevVJHEtMUrZqZ24mfGXLa8SsojEYKz6Gy6BxBAtV1qFtr2+bFGyDJOI5qFts/15xpn4M7IGFzW2oqQ==;5:7cOxdQ+5GvhTd7CotcNRHggXtmUgjIIe89JkgwGXWxguq93fN+Q9Ld/XLP6Dd3XjP6+w0nXrenkNcLM/X1lgk1USX/hppgjglhBX4wk57pGx1Slef7/L6ROtSruqDON09TVby9NpfzFOKRALj8mNBeZ46nfWsuAw4BleqWepk30=;7:SBXdEw1As+mpUc2cQpBMu2D16LBsRjqyGHi6NWcmb52OqlFEK8SPUscEIJu2l5C+w+ht/WEjm9hsRamvXWcCEjR0xV4C+n7TI6EhXtZ1gKbVjQTGpfPRHuS08bTWmwaK/r+czJwUz7FQ5u5/Y6YluA==
x-ms-office365-filtering-correlation-id: 56d493e2-c05e-4763-99bd-08d63d891c5d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BYAPR06MB5303;
x-ms-traffictypediagnostic: BYAPR06MB5303:
x-microsoft-antispam-prvs: <BYAPR06MB5303AABD75661375E0ABC0B8FBF30@BYAPR06MB5303.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(93006095)(93001095)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123564045)(20161123560045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BYAPR06MB5303;BCL:0;PCL:0;RULEID:;SRVR:BYAPR06MB5303;
x-forefront-prvs: 084080FC15
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(346002)(39860400002)(366004)(376002)(199004)(189003)(305945005)(71200400001)(26005)(71190400001)(2900100001)(2501003)(72206003)(6916009)(105586002)(5250100002)(7736002)(5660300001)(86362001)(2351001)(68736007)(106356001)(476003)(2616005)(11346002)(486006)(6436002)(8936002)(99286004)(36756003)(2906002)(256004)(81166006)(81156014)(8676002)(316002)(14444005)(5640700003)(6486002)(54906003)(4326008)(6506007)(76176011)(44832011)(25786009)(386003)(478600001)(102836004)(446003)(14454004)(53936002)(186003)(6512007)(97736004)(3846002)(66066001)(52116002)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR06MB5303;H:BYAPR06MB3992.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: l2qI3fnM27j8vqBS6Z4YTP0/+WgC9UIN8UzUWWVu8FcolAUFhAAdFa1GGGYGMK2KAW3NNB1BvSuhYRgwbZxJkhAtKLqI5H7bc8NAlfHl6516fmdTqrUXJrJc0r3609VwhbaBZ1Xo5qw8KCsagP41muFPJdjyyu20Z6ZCJCsV+In6NcDEacLhPDl7mvbTtNYkh/bNv4ZMx6xS77u0+6iZjYe061MTC4DkEuFi+napzCVw+EKtPVejJrxGCQhmfWQSa0zHijjCdgZE0uDFeVw17Ycj33E5nix8UI0+Y3IgQ537yMZ9xluFOhxBNWelyZFtPjqD8804+L+2jzQtg0XxFosLodIULiuL0hzOqx5pDgc=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56d493e2-c05e-4763-99bd-08d63d891c5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2018 10:27:21.8026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB5303
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
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         | 23 ++++++++++++++----=
----
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index f3cbf78..e0910c5 100644
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
+		if (fws->fifo_credit[i] < 0)
+			brcmf_err("fifo_credit[%d] value is negative(%d)\n",
+				  i, fws->fifo_credit[i]);
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
1.9.1

