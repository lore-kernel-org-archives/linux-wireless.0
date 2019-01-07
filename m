Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE758C43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 08:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85EBC20859
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 08:46:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="M1bWC36c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfAGIqT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 03:46:19 -0500
Received: from mail-eopbgr730114.outbound.protection.outlook.com ([40.107.73.114]:59712
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726404AbfAGIqT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 03:46:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rktK3R4hV/0Lq9D0lwqxnCcSwuV5IJmMurBqZckc/6A=;
 b=M1bWC36c1GSQudc61+ECHNeB2Iu71S5wpndhiDpaOAG+RAmvtqajvM7o5k6stl1B0LzGLMqEZu4ugWBH537+3VmzhlA5/w0P7jn+GGRoAxX7F1MU6boO8KkLaSkvlVGC44dio6X2AGKsgJ9AOJqGwSAWtku02FhJSivWCVzlqKA=
Received: from DM6PR06MB5804.namprd06.prod.outlook.com (20.179.161.141) by
 DM6PR06MB4747.namprd06.prod.outlook.com (20.176.112.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.7; Mon, 7 Jan 2019 08:46:16 +0000
Received: from DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea]) by DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea%4]) with mapi id 15.20.1495.011; Mon, 7 Jan 2019
 08:46:16 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Double Lo <Double.Lo@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH V2] brcmfmac: fix system warning message during wowl suspend
Thread-Topic: [PATCH V2] brcmfmac: fix system warning message during wowl
 suspend
Thread-Index: AQHUpmVzB8jeihteW02T1VRPWaav5g==
Date:   Mon, 7 Jan 2019 08:46:16 +0000
Message-ID: <1546850746-165123-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: BYAPR11CA0103.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::44) To DM6PR06MB5804.namprd06.prod.outlook.com
 (2603:10b6:5:1a6::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR06MB4747;6:OXl5CX2JdND2D06DFKhpqTnn6fDi8gRj5akkP9dASeEm85Ooa7fgABLoliUjh1RBidjMs11UP0gMmkM2370jaaicMnIyw+UP4pFRa5egp4i33V64EdIcMXefvkeO+8pEd3IEW0SKGO27Xf9j2FmajeDnRvElaDL18HdbuRmR8uUeaROctIrCn+GC3Tx7tfySTtKsSp1dBjClojSB5zKoHK9FFeh7hytAgJd7G47OOwUMEAK+UtYE69Bcqgbw6yFjwgUhkl8YGo4qbvrUIcivZXEOj9CKDTt2oblx+K4mNKrjKa4B1qBqdSqgif9c4ZORKq7vGJ2Jt3PoGFpO5sEJ1ECTS9CGnB80rj+dJNiucPwfijK1ls7xeIJZfOOfh+4KO2X2rIftcGXHuVzA4cpNu5GC5udk0HEltrdOvu+arePA36yupCUWclpnRhWxd4u4opieeJoblTJKbG9GXx+PWg==;5:7YGCOSyiiTptuolGhVETqTJg+pCZ+Je+93uM3RbYDhyKWRN0+NvE3ucW98gSNaLp32AmxbIzgM03Q36yJ5O9OmnB9aQh79GQxIgkTL3WEADqdxvDDKq0ifa0Ak/qPXO6ntuMAA42rSlGcviJOJinIFaP7U7sc+VqIp0zPKnO54odttZSAegmlLjZzJQ6jskgBiwIYBdZ+Sb34OVYUpbdTw==;7:A6vjTiaYwn5VPloNwp5tjjRMOr546FMW8c+ii+5aIA/zQpKuOeEMiUuWRWDVsJ5Y8iLy9ZWJkvWmHN+h54Dqvfn5JkML/m2+Gs5Cegb4WmSFeiVaFaOMKjvq0byjiyJFIVK5ORNp3EgTm6AxDqCcJg==
x-ms-office365-filtering-correlation-id: 1fef25f3-3ceb-47c3-0a9a-08d6747c95c3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM6PR06MB4747;
x-ms-traffictypediagnostic: DM6PR06MB4747:
x-microsoft-antispam-prvs: <DM6PR06MB4747ED4F1201FEB78FED1B03BB890@DM6PR06MB4747.namprd06.prod.outlook.com>
x-forefront-prvs: 0910AAF391
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(346002)(136003)(366004)(39850400004)(189003)(199004)(81156014)(81166006)(476003)(2906002)(6916009)(72206003)(14454004)(478600001)(5640700003)(5660300001)(97736004)(36756003)(6486002)(86362001)(2501003)(25786009)(15650500001)(53936002)(68736007)(105586002)(107886003)(106356001)(6436002)(305945005)(6512007)(2351001)(7736002)(71200400001)(486006)(71190400001)(4326008)(6116002)(99286004)(66066001)(3846002)(186003)(6506007)(26005)(102836004)(14444005)(2616005)(316002)(54906003)(256004)(8676002)(386003)(52116002)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR06MB4747;H:DM6PR06MB5804.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cZvJm4Yfw8lGwMBotbdXPbRLx2TXaj6sfczwbvr2nFqiUrnZVqc7XIjOF3ceicS3bfY5Y66ZGNbMIpjDQjyHI3WM+kDJO22slHXd7fK7Qhdr6A34+cFUsmwdjPqB3VbjjQfmY52ThyqdX6rmWxlR6Qzzw25kdTL8GPYgaJZjDV0ma6ljXBk8T+mtAPozqTI0MUeU6zUGIOd3wmNFpml5ApNiUn5QQtG2/ect9FVdcYPFQI7Jq8XlfG2gFbz5/Q/NPNkktHaO+aHED13BRW5Np+coxyhLW7d+cScGjKf3hTQ9TTexOv05PlBLN3CrQUeH
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fef25f3-3ceb-47c3-0a9a-08d6747c95c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2019 08:46:16.2170
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR06MB4747
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lo-Hsiang Lo <double.lo@cypress.com>

There is a system warning message, warn_slowpath-fmt, during suspend
while using supplicant join AP and enable wowl feature by IW command.
It's caused by brcmf_pno_remove_request path can't find the reqid.
This fix will not go to remove pno request function if there is no
pno scan.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Lo-Hsiang Lo <double.lo@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c b/drive=
rs/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
index ffa243e2e2d0..37b403877228 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
@@ -496,6 +496,11 @@ int brcmf_pno_stop_sched_scan(struct brcmf_if *ifp, u6=
4 reqid)
 	brcmf_dbg(TRACE, "reqid=3D%llu\n", reqid);
=20
 	pi =3D ifp_to_pno(ifp);
+
+	/* No PNO request */
+	if (!pi->n_reqs)
+		return 0;
+
 	err =3D brcmf_pno_remove_request(pi, reqid);
 	if (err)
 		return err;
--=20
2.1.0

