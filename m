Return-Path: <SRS0=K5U7=PM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99022C43387
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 06:11:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B3092070D
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 06:11:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="JGfoyhyp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfADGLx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Jan 2019 01:11:53 -0500
Received: from mail-eopbgr680095.outbound.protection.outlook.com ([40.107.68.95]:14151
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726093AbfADGLx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Jan 2019 01:11:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FfRsdblEN2xaFSci9ihOoDGs7Exjvh3VhKSxekuwB9A=;
 b=JGfoyhyp6EtDliujbsyHWXCJpxJc1lgrwxgdvQrhaFZscC8H+kSyfPx4ug4zxlZkRlwRctMw14njax3bkFNAY6j7jidN3T4nKjSNJ779KSh31gRpPBydZlGAmaa4Kn2wbpaBkJ1tBy4OvgZIW5dTUwe7YR0JfhGGWuk7NATT0EY=
Received: from DM6PR06MB5804.namprd06.prod.outlook.com (20.179.161.141) by
 DM6PR06MB5577.namprd06.prod.outlook.com (20.178.31.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.6; Fri, 4 Jan 2019 06:11:09 +0000
Received: from DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea]) by DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea%4]) with mapi id 15.20.1495.005; Fri, 4 Jan 2019
 06:11:09 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanley Hsu <Stanley.Hsu@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH 2/6] brcmfmac: send port authorized event for 802.1X 4-way
 handshake offload
Thread-Topic: [PATCH 2/6] brcmfmac: send port authorized event for 802.1X
 4-way handshake offload
Thread-Index: AQHUo/RJmld6ks8tVkade7sZx+IvzA==
Date:   Fri, 4 Jan 2019 06:11:09 +0000
Message-ID: <1546582221-143220-2-git-send-email-chi-hsien.lin@cypress.com>
References: <1546582221-143220-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1546582221-143220-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: BYAPR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:a03:74::15) To DM6PR06MB5804.namprd06.prod.outlook.com
 (2603:10b6:5:1a6::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR06MB5577;6:FydtsgfsRhLFR7CpZ9FRPNxWaILCtswt+4SRfxftTAhBRsT6lmg+m6N+EGT5tT/w8BtelLcrYp6lLiAnPDSr8dbyVfrMGqMHAbtg/GoBfmf4yHiFb+Pmqs03FiZc/uNwhMLSveCDcTkmCVAxJmSsyugfQJb4isLShitObyBIp28cYKn2KVf11Lwi9P20GWVwNZfbbBO/tOpxM7gtMQfXgMh9KXKvLNDIehCYXR5ugI6fEC+/zoKynm0HDjHS+yk/2SyRZiwLUcUE9ml8Kz86kh/0foIeIES9HVkZLZlaeR2Ube78Fl9L4Do7sOBiwMeZ8xDHUe10qICebkx1CRBMOtK1k5ZhVne1WJA0bsl/942ajsSfHd1sX8npqU/uHMZQ9M0D09djolt9CBcaZlX1eDTrBkisb/EZdkhnCUfQOgJc1hhEeaL1aMpksXBcbtz999HwouI8BCKMcRtUJpnRTQ==;5:cFwFWHkWEIGPGcTPOOs1CRCRDXJPmIPrViWq5JtbCfkqt/yr5pz0QAqtjJMB8TDnYZUgDyo13J1baFbElpVMk2PLVkvzU4AT0uGB6I6a1DIhXXFnkhidZTCfYysnXiQPQMPYUKEtGhM+22Az2npJlI+U6rZtJWw1CQ3OAC/lvA3QUx9t8hfgApQAGTeIybGNezj/dK9Y3JATxMFVc1Soyg==;7:AcaY5zZ3sioRwz83eOgj7Odz0FGrsyDwyslUQEY7dMnupDya48XP4mbSoRv0Fr6hZsmMj434e9ZOkgK2kgBaTt9wdTDMl1q6TLPX9RrTWbZs+XKncX1KU9u/T2K0Klhx/BrOwmDTKpaD8FH2Ese1yQ==
x-ms-office365-filtering-correlation-id: c01da34d-9ff0-4357-ce07-08d6720b6b69
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM6PR06MB5577;
x-ms-traffictypediagnostic: DM6PR06MB5577:
x-microsoft-antispam-prvs: <DM6PR06MB5577D712A48B656964562F8DBB8E0@DM6PR06MB5577.namprd06.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(3230021)(908002)(999002)(5005026)(6040522)(8220060)(2401047)(8121501046)(3002001)(93006095)(93001095)(3231475)(944501520)(52105112)(10201501046)(6055026)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:DM6PR06MB5577;BCL:0;PCL:0;RULEID:;SRVR:DM6PR06MB5577;
x-forefront-prvs: 0907F58A24
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(136003)(366004)(346002)(396003)(199004)(189003)(54906003)(6436002)(446003)(106356001)(186003)(26005)(105586002)(102836004)(11346002)(6486002)(316002)(2501003)(6916009)(5640700003)(71190400001)(71200400001)(486006)(99286004)(476003)(2616005)(2906002)(97736004)(68736007)(6116002)(3846002)(36756003)(86362001)(575784001)(81166006)(81156014)(14454004)(478600001)(8676002)(72206003)(53936002)(4326008)(6512007)(107886003)(305945005)(25786009)(14444005)(76176011)(7736002)(256004)(66066001)(5660300001)(52116002)(8936002)(386003)(2351001)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR06MB5577;H:DM6PR06MB5804.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uMAI6TJUAPzPBiFnEAD/AxBxyqWUEIvzIL+sz+h/J1qQxxWK2QGbCk31Ufiv6LG+a2UNrP1FDviwpuvqL54/P+sAcJ0zSNCGSuu4ks8R2Act2iXtVEzqAAI8t4uTGoYxCqX/d+gZQMavdpG0TgRrqhIdJSnayNGnabTffV4x4YeIj1xcRmPuxgbr7J95JeBd/y3zkgUi6/eve8GQOQ1tVfCcCP19iFrzqC+cG2fgLnl9RbxHUGNjND7SnFgWSb+SOIY6c2oUSaulrfPM6AgzcxycmeTPM+ksfnWaAV+SHObz0D0tvrlPZ05TLBhn2YkC
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c01da34d-9ff0-4357-ce07-08d6720b6b69
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2019 06:11:09.7961
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR06MB5577
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Chung-Hsien Hsu <stanley.hsu@cypress.com>

With 4-way handshake offload for 802.1X authentication, a port
authorized event should be sent to user space after the completion of
4-way handshake. It is used to indicate that a connection is authorized
and 802.1X authentication is no longer required.

Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 23 +++++++++++++++---=
----
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 35301237d435..ad0d775a1244 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5266,10 +5266,13 @@ static bool brcmf_is_linkup(struct brcmf_cfg80211_v=
if *vif,
 	u32 event =3D e->event_code;
 	u32 status =3D e->status;
=20
-	if (vif->profile.use_fwsup =3D=3D BRCMF_PROFILE_FWSUP_PSK &&
-	    event =3D=3D BRCMF_E_PSK_SUP &&
-	    status =3D=3D BRCMF_E_STATUS_FWSUP_COMPLETED)
+	if (event =3D=3D BRCMF_E_PSK_SUP &&
+	    status =3D=3D BRCMF_E_STATUS_FWSUP_COMPLETED) {
 		set_bit(BRCMF_VIF_STATUS_EAP_SUCCESS, &vif->sme_state);
+		if (vif->profile.use_fwsup =3D=3D BRCMF_PROFILE_FWSUP_1X)
+			return true;
+	}
+
 	if (event =3D=3D BRCMF_E_SET_SSID && status =3D=3D BRCMF_E_STATUS_SUCCESS=
) {
 		brcmf_dbg(CONN, "Processing set ssid\n");
 		memcpy(vif->profile.bssid, e->addr, ETH_ALEN);
@@ -5280,11 +5283,10 @@ static bool brcmf_is_linkup(struct brcmf_cfg80211_v=
if *vif,
 	}
=20
 	if (test_bit(BRCMF_VIF_STATUS_EAP_SUCCESS, &vif->sme_state) &&
-	    test_bit(BRCMF_VIF_STATUS_ASSOC_SUCCESS, &vif->sme_state)) {
-		clear_bit(BRCMF_VIF_STATUS_EAP_SUCCESS, &vif->sme_state);
-		clear_bit(BRCMF_VIF_STATUS_ASSOC_SUCCESS, &vif->sme_state);
+	    test_and_clear_bit(BRCMF_VIF_STATUS_ASSOC_SUCCESS,
+			       &vif->sme_state))
 		return true;
-	}
+
 	return false;
 }
=20
@@ -5501,6 +5503,13 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *c=
fg,
 		brcmf_dbg(CONN, "Report connect result - connection %s\n",
 			  completed ? "succeeded" : "failed");
 	}
+
+	if (test_and_clear_bit(BRCMF_VIF_STATUS_EAP_SUCCESS,
+			       &ifp->vif->sme_state) &&
+	    profile->use_fwsup =3D=3D BRCMF_PROFILE_FWSUP_1X) {
+		cfg80211_port_authorized(ndev, profile->bssid, GFP_KERNEL);
+		brcmf_dbg(CONN, "Report port authorized\n");
+	}
 	brcmf_dbg(TRACE, "Exit\n");
 	return 0;
 }
--=20
2.1.0

