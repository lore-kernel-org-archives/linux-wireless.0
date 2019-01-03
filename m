Return-Path: <SRS0=/Gk3=PL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC313C43387
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 07:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99CEB2070C
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 07:46:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="Qmenqdyw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730305AbfACHqn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Jan 2019 02:46:43 -0500
Received: from mail-eopbgr780125.outbound.protection.outlook.com ([40.107.78.125]:10254
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729071AbfACHqn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Jan 2019 02:46:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4iy2LolmE3hr6deqAH3KH0nqaRBCh93G2ajpzDNYy6g=;
 b=QmenqdywCx09XmOZvRE9Fw7cj4BiLxSle8agFBew+/7LG7PjuPS5biYg1+yjysHJepvfrS4EJKbEZz9CBFip7FrnoMvWXR06om0xpnaNBejjCdCmflWQ2D1SvRzGfLYZxxKQeHZd1wDQ7e9jWDUQaarD8HQEHe/ZiM6dwFh4vCM=
Received: from DM6PR06MB5804.namprd06.prod.outlook.com (20.179.161.141) by
 DM6PR06MB5177.namprd06.prod.outlook.com (20.178.25.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.6; Thu, 3 Jan 2019 07:46:40 +0000
Received: from DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea]) by DM6PR06MB5804.namprd06.prod.outlook.com
 ([fe80::14e6:e072:bc55:7bea%4]) with mapi id 15.20.1495.005; Thu, 3 Jan 2019
 07:46:40 +0000
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
Subject: [PATCH 1/2] brcmfmac: fix system warning message during wowl suspend
Thread-Topic: [PATCH 1/2] brcmfmac: fix system warning message during wowl
 suspend
Thread-Index: AQHUozh22Qq2I1ZY/kmgrkvLrXjwAw==
Date:   Thu, 3 Jan 2019 07:46:39 +0000
Message-ID: <1546501565-40752-2-git-send-email-chi-hsien.lin@cypress.com>
References: <1546501565-40752-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1546501565-40752-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: BYAPR01CA0038.prod.exchangelabs.com (2603:10b6:a03:94::15)
 To DM6PR06MB5804.namprd06.prod.outlook.com (2603:10b6:5:1a6::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR06MB5177;6:GGkZD+PD4KEsnGdRhId3W76IlmDDjobyud/sE1iHGdAftYDu5BmhSfo1fyu0fLGvV2pE8rtXq/zawcNwYsC8/n7z1MEaEUEVwlP36ZWn7Bog+XSPtnbXlDj+2aJdXCFITcRKdbx0UrUiJkT5cL11iR1e8WaMo7lr6mkRJPcAExBylNkgJZU9bWcsHF47dUoUGm5P+PLUPxZNWaNen3a5TW0ER4EEJl1oMZsDnjVUIstJAt0c1ay+6eBW5LL7oPnlrsX0BwynnUc81eG+ycmhrviUI9XWzfXGY4t7kdYJeKf3GhUXrsNGe+snasj4nXCw9uGG5pryF4nEdtd0rMKBQ3khdwx0Xe8Cl3PpF1fU3glhVUMT8Xrx79647pqm5d1QqDiHxmbZ1nXETsqG1tpjDEmj+KHFbLRztbTPed341Cl9cnkrg+y12FS67/NvNSdMno9dZssSjR13BmHw9F24bw==;5:ks3C6wmmwwjuNKUE9w/wBILQgEfPgWCWV0LKQVXgSA/lLNU7CUgnrbNX4F7mvODud8VnUR0HyE+Ggll6+Y3sTtwcXR0ukWxo9qEwOIuHy86PozdbxOhqkexCRSS1iTDvQDRxIG/I0vR8wIPHN+Qcs1x6wRMvu1KN9NaxFV5yi3xymACUtTWGcu+GZXLU93LbBHkQqXsv76NYtMke8AtKoA==;7:moxR95i02TGTZg4eKGL53XWXFlwwt81Gdjngk8NrZhZScMf3NsnsnUn0EfyOayFH0DUzvjcSfrMdkV3hhdVQa1DftCSEqZFFAJI8CbM36DG8LBgI/x27gjAgraKILQGPC6VULAyDExudvar9J/eRLw==
x-ms-office365-filtering-correlation-id: 21cabff2-ec7e-497d-193a-08d6714f9891
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM6PR06MB5177;
x-ms-traffictypediagnostic: DM6PR06MB5177:
x-microsoft-antispam-prvs: <DM6PR06MB51772079E983EF335EECA259BB8D0@DM6PR06MB5177.namprd06.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(3230021)(908002)(999002)(5005026)(6040522)(8220060)(2401047)(8121501046)(10201501046)(3002001)(93006095)(93001095)(3231475)(944501520)(52105112)(6055026)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123558120)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:DM6PR06MB5177;BCL:0;PCL:0;RULEID:;SRVR:DM6PR06MB5177;
x-forefront-prvs: 0906E83A25
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(39860400002)(366004)(346002)(396003)(199004)(189003)(71200400001)(71190400001)(256004)(26005)(186003)(6512007)(478600001)(53936002)(305945005)(105586002)(8936002)(106356001)(2906002)(102836004)(6486002)(8676002)(7736002)(72206003)(52116002)(14444005)(81166006)(81156014)(2501003)(99286004)(68736007)(86362001)(2351001)(6506007)(76176011)(14454004)(386003)(3846002)(6116002)(15650500001)(486006)(11346002)(446003)(107886003)(54906003)(97736004)(316002)(2616005)(476003)(6916009)(4326008)(5660300001)(6436002)(25786009)(5640700003)(36756003)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR06MB5177;H:DM6PR06MB5804.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cAhSfVmQ7jXjXBd4qkDmEKqTEUGB0hpN7DmVbISQ5bnswLq0vQ4i8beqK8dUDgQIMYM3C9YHKQtp9lS5funPdbXVdmGImLRTdfu2AAUpnHkpe0Y39wGK8hNsSJfUUTiubX7M5LqA4HKgPEWIl1ZS3jasft5RwW86d1s0JhDaW9RlKQGu4ARSOMJhRH+d34dDG2COJyWTF19SF5nmKBNtU/i4to0UBHkIMKW94J7vGtb09rJynw3Qf+P3P7m6Lj/5mUH612e/YTA/h/+GQfkwzVJvRAFZtuwXCc8521mLz8wvQa1CnklLO31CvbuI3Oal
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21cabff2-ec7e-497d-193a-08d6714f9891
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2019 07:46:39.9597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR06MB5177
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lo-Hsiang Lo <double.lo@cypress.com>

There is a system warning message, warn_slowpath-fmt, during suspend
while using supplicant join AP and enable wowl feature by IW command.
It's cuased by brcmf_pno_remove_request path can't find the reqid.
This fix will not go to remove pno request function if there is no
pno scan.

Signed-off-by: Lo-Hsiang Lo <double.lo@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c b/drive=
rs/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
index ffa243e2e2d0..55974a43796a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
@@ -496,6 +496,11 @@ int brcmf_pno_stop_sched_scan(struct brcmf_if *ifp, u6=
4 reqid)
 	brcmf_dbg(TRACE, "reqid=3D%llu\n", reqid);
=20
 	pi =3D ifp_to_pno(ifp);
+
+	/* No PNO reqeuset */
+	if (!pi->n_reqs)
+		return 0;
+
 	err =3D brcmf_pno_remove_request(pi, reqid);
 	if (err)
 		return err;
--=20
2.1.0

