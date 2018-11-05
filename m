Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BFC1ECDE44
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 05:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C27020827
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 05:51:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="RK0ZanES"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C27020827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbeKEPJx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 10:09:53 -0500
Received: from mail-sn1nam02on0122.outbound.protection.outlook.com ([104.47.36.122]:15392
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728985AbeKEPJx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 10:09:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G5LiTqO2GwiFWevR9XtTSscp2BjRLs3TYF0Qc8vQzgc=;
 b=RK0ZanESWlfJKnp1jLxqHlmWDm81HjPkRTZoWAxo0s7N5CI3FlhqVWNvdfIHep2a872TKGdlOKbfeSVs8fDj6Y/9eTt1u3LV+SerSellN3Okpd3QwbqOvd8+P7gtzFjrXc0EFd/t+LTyngoYJZcWQlaBsWGhdzZOgAvBRPcDN9Q=
Received: from BYAPR06MB3992.namprd06.prod.outlook.com (52.135.200.22) by
 BYAPR06MB4231.namprd06.prod.outlook.com (52.135.238.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.26; Mon, 5 Nov 2018 05:51:54 +0000
Received: from BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986]) by BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986%3]) with mapi id 15.20.1294.032; Mon, 5 Nov 2018
 05:51:54 +0000
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
Subject: [PATCH v3 1/3] brcmfmac: add credit numbers updating support
Thread-Topic: [PATCH v3 1/3] brcmfmac: add credit numbers updating support
Thread-Index: AQHUdMunJ0F2PsdgjEmrkPMlafJbpQ==
Date:   Mon, 5 Nov 2018 05:51:54 +0000
Message-ID: <20181105055137.13333-2-wright.feng@cypress.com>
References: <20181105055137.13333-1-wright.feng@cypress.com>
In-Reply-To: <20181105055137.13333-1-wright.feng@cypress.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: TYAPR01CA0049.jpnprd01.prod.outlook.com
 (2603:1096:404:2b::13) To BYAPR06MB3992.namprd06.prod.outlook.com
 (2603:10b6:a02:90::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [61.222.14.99]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR06MB4231;6:fUR840DJd+fNOJ/Mi/o3THxh4v0XPpDsZyTZ1LNXgPWP7MCLtrYak1aKkBuT3REjbJrnOpkNPLn1yaUhr49vwWpFFZYvg1WiDNeSRf6P+vBusEwBIy8rcRHFUUVOgZf9WWTE/dk/Z2bm/QyPYhJUvXZ9ZyylUvXy34XSzvcodPoWJ+NfA0LIdopnPRayhJeKhdtkiznTUR/3CaWiCOMU00R8+BV0jDRy8Qvs+nhewGMPoiP0RahiFQkHm04kBZYFEqQ9jHuLsGXLTfnV+M37yRdRFypNH87sEecTaq4OZzwEmlYjWndAyBZcK3wV5f5MmuVMkwzF1TZ8ml6/noeB623PlQxs1u/qyMYqEJkCA7K6jhtaH6LBtSl5d+frYNYD/vXzitnkmxN7O9fa3K9IM5TEDvP4vtsLUo3rTKnNJTCTuN0dKNu+cH9SmIFIa0Ewt2naduDq6iiw/ZKq4CUxlg==;5:cZ2rycjTp/YB88zDLsAfHv7psfvrPh46MMEVvdixgP5JRAP272MycC6c2P9smPVQjEzYZwb02AzzLF8HOPDp4Bk9AsgifJsEtdxwOhMTm8T3dzn9ILk1+rToV8vKbQ4X7tocfInKUdi0ewYgBJ4T8FB9Sg7L9ifRSQRiyRYfk5k=;7:n+tZd4/sInBw0/noRHqec/wNHvhhTJCQC64Q+SPneLb+nHGsIlmn5DT9dUUqqnSMf894ra13iDInAVtKnm4gh1E5eDiawazCQ2CxA67DpCjZpZT3yXcNdhV/i9moyyPZKFUw9dKOjg9KYha8fDVbfg==
x-ms-office365-filtering-correlation-id: 66c0742e-025d-4d93-5874-08d642e2ca37
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR06MB4231;
x-ms-traffictypediagnostic: BYAPR06MB4231:
x-microsoft-antispam-prvs: <BYAPR06MB423169E1699E4A51E9B260BCFBCA0@BYAPR06MB4231.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(788757137089)(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(10201501046)(3002001)(93006095)(93001095)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123564045)(20161123560045)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BYAPR06MB4231;BCL:0;PCL:0;RULEID:;SRVR:BYAPR06MB4231;
x-forefront-prvs: 08476BC6EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(136003)(346002)(39860400002)(366004)(199004)(189003)(6116002)(3846002)(97736004)(99286004)(1076002)(4326008)(102836004)(71190400001)(71200400001)(76176011)(68736007)(6506007)(386003)(106356001)(36756003)(105586002)(2351001)(6436002)(5640700003)(5660300001)(2906002)(2900100001)(2501003)(53936002)(6486002)(6512007)(72206003)(478600001)(14454004)(6916009)(54906003)(186003)(52116002)(26005)(7736002)(316002)(476003)(11346002)(8936002)(81156014)(81166006)(305945005)(66066001)(256004)(2616005)(446003)(14444005)(25786009)(44832011)(486006)(8676002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR06MB4231;H:BYAPR06MB3992.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: KW4xT1AtNwL8rd76PBjAxZzb8zhXr70dAUO9mEMyT6OtpQMbE4QuIVwloeS749UvHjjsYHIoSvwSNDK48oRwK4bW7pFf3hkJcw1i6LUO6Q3FbYV1GFK5xN20snGoJbH/rjbe3IfMEOt14gRKKY0yIsOjeKS+bKyWlvbtXGNqrW7pIDmn1RunPRyjYYIK2ofY0zJteA9fqlJD3ETf5sAb/+5VBuotG/W+usBG0ZWFPE/+93v6vLRwdTiX+oHWPqlpGZoFjLxZ5WZTmAQa2CAxqXL5vfEgkJiZ8ln85SWJDHRGF526uKz4LqZ7WVJlu1JrBybCyEDYmNu9U1HqKDqLBSTE53cSEnbDE4oyhM756a4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66c0742e-025d-4d93-5874-08d642e2ca37
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2018 05:51:54.5295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB4231
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
v2: Replace brcmf_err with WARN_ONCE
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

