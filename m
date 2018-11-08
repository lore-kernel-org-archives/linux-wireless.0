Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413E8C32789
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 03:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F18D420684
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 03:48:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="U6txQ5Qc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F18D420684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbeKHNVz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 08:21:55 -0500
Received: from mail-eopbgr700128.outbound.protection.outlook.com ([40.107.70.128]:28160
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728652AbeKHNVz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 08:21:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DH6wggynTqLbz9NiBtsYcN2eUHjKVHRfbzfxc3J4zMo=;
 b=U6txQ5QcITdCeLy9kuaMqK5Q1sXMKon8fRg3yS0jdseIYhc8oQB6CvqY1FH2Lo9qlv4+f5IEB+ymtDpafuLdNqCSETfFFOxOnj681j7UXeqdpbO0u2oFM/WUEl8F7EQainO8S3pf/vAslejbf9DLTZrzE/6xFhAGuhn+6gh+Olo=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1387.namprd06.prod.outlook.com (10.162.111.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.28; Thu, 8 Nov 2018 03:48:10 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.034; Thu, 8 Nov 2018
 03:48:10 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH 4/5] brcmfmac: only generate random p2p address when needed
Thread-Topic: [PATCH 4/5] brcmfmac: only generate random p2p address when
 needed
Thread-Index: AQHUdxXd3lsn11F9p0y3tsTW/V9B5g==
Date:   Thu, 8 Nov 2018 03:48:10 +0000
Message-ID: <1541648845-194984-5-git-send-email-chi-hsien.lin@cypress.com>
References: <1541648845-194984-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1541648845-194984-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: MWHPR15CA0064.namprd15.prod.outlook.com
 (2603:10b6:301:4c::26) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1387;6:5U3BfwJ3/zNPZwy0Q0rzI2YKxth+o6YiSBJnQ+6Z+i26ZQosEyesRSebStM8iZqvMTkGMqPga9qSbeg/tFv/UJ0O0Wl6r7AGEv+NDB3OnPB6gLYVC6rszuZB/OOqyfU9WKiwjLFgsgY7fGrMZEQvVL9cFlVj9P9n06LZBhs2disRpOkB19uNNZVmu6KtpGqKII3utKNfxW/zldoB5GHAGOpRUSp6fsLjLUK+/lefFfOLRUDPr0cQoDrMcHGMiyDTmf3TNBF5AVcrm/0YgHrDjYsitv95bH2N3SkC/arHXVl84kK5UvSYLQxFxYrTEhr0OBicsks2lk/zaSpbeY7I7Obccwie6pPMbFz6g3VLOv0vU+5v2jWnTqjh/Jfko/SDXCoBPGsVnwT0MLtUitTAs5YVjR7TkcuwIYe54xaeSn5P5YEYWdiU3L3BxnvVIouSNeZyDm8ZgJqP3wf53U+46Q==;5:Wn5600zDksBX3h3u6PK8L+r5uKb3QIIuL2X9Dz8x0AhfL8ZwoEJRHILENhp0KBhkKOovYuYL28AXwa8LlwXaF9HZW1bj1FtwhyS5+0GS+Krgywg1kUJD4uu9IbS3i34iENZp2ydY5CNvPCNUvg4jHD57DHKtiRXc41NORDStEN0=;7:X0lG3iXnhMvVnpjvDmBNTldG0162LObYefccl47UkwZonttJtY0m2ltTxXz5Z/grJ0kfTfv7Szy3z6dTSr+Xqcqgreq9IYZjEEqJlsrTslZcx5NocBuPwFlPUW2YMa0Vy9uc+WA03ivmzjDcuFSiww==
x-ms-office365-filtering-correlation-id: f9d89ece-e4d3-4fcf-ac9d-08d6452d0018
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1387;
x-ms-traffictypediagnostic: BY1PR0601MB1387:
x-microsoft-antispam-prvs: <BY1PR0601MB1387EDED2D4142F77D5489B0BBC50@BY1PR0601MB1387.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1387;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1387;
x-forefront-prvs: 0850800A29
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(136003)(396003)(376002)(39860400002)(199004)(189003)(68736007)(6116002)(3846002)(256004)(6916009)(316002)(72206003)(66066001)(7736002)(305945005)(71200400001)(71190400001)(2351001)(186003)(2616005)(36756003)(476003)(105586002)(446003)(11346002)(26005)(97736004)(486006)(106356001)(386003)(81156014)(76176011)(81166006)(4326008)(6436002)(2906002)(25786009)(6506007)(52116002)(8936002)(53936002)(102836004)(6512007)(14454004)(478600001)(99286004)(5660300001)(54906003)(8676002)(107886003)(6486002)(5640700003)(2501003)(2900100001)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1387;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: aoMvJeB80R20YShIkiQV72NaD5B+glJC2j9fL4z6jJw44mXxwBvfLwXODrIjT01wFz1K2kMa8rRQf7etXBt6PemlKL1sqU/+5vKP8czLh0qC3NqePQeQPN5jbXuLlKR+on+JC64nCM6bFHjt88XYQ+zKM9oR5oIJ2D4i0831Qk1wDsIxRHonnYImXgETwyYb7cXQXMPUe9AejLnKheSJbyfJmHaRFcOiRdbFnSOnt3wYE7+Ojhd9gpFqwtJbPKHvU9nSnaghzLcCYYgE6rWA01nbo76HdYn7tgyOLqTkjofco/Pl0C590j+Rvxod1bDCjh8V6Qnqg9roIvpeJuzOeNm+ls6pvC0o9uz6sVe2QCg=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d89ece-e4d3-4fcf-ac9d-08d6452d0018
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2018 03:48:10.2470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1387
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

P2p spec mentioned that the p2p device address should be the globally
administered address with locally administered bit set. Therefore,
follow this guideline by default.

When the primary interface is set to a locally administered address, the
locally administered bit cannot be set again. Generate a random locally
administered address for this case.

Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 18 ++++++++++++++=
++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drive=
rs/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index dfdd30b19c42..1629ceecd9b5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -467,10 +467,21 @@ static int brcmf_p2p_set_firmware(struct brcmf_if *if=
p, u8 *p2p_mac)
  */
 static void brcmf_p2p_generate_bss_mac(struct brcmf_p2p_info *p2p, u8 *dev=
_addr)
 {
+	struct brcmf_if *pri_ifp =3D p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif->ifp=
;
 	bool random_addr =3D false;
+	bool local_admin =3D false;
=20
-	if (!dev_addr || is_zero_ether_addr(dev_addr))
-		random_addr =3D true;
+	if (!dev_addr || is_zero_ether_addr(dev_addr)) {
+		/* If the primary interface address is already locally
+		 * administered, create a new random address.
+		 */
+		if (pri_ifp->mac_addr[0] & 0x02) {
+			random_addr =3D true;
+		} else {
+			dev_addr =3D pri_ifp->mac_addr;
+			local_admin =3D true;
+		}
+	}
=20
 	/* Generate the P2P Device Address obtaining a random ethernet
 	 * address with the locally administered bit set.
@@ -480,6 +491,9 @@ static void brcmf_p2p_generate_bss_mac(struct brcmf_p2p=
_info *p2p, u8 *dev_addr)
 	else
 		memcpy(p2p->dev_addr, dev_addr, ETH_ALEN);
=20
+	if (local_admin)
+		p2p->dev_addr[0] |=3D 0x02;
+
 	/* Generate the P2P Interface Address.  If the discovery and connection
 	 * BSSCFGs need to simultaneously co-exist, then this address must be
 	 * different from the P2P Device Address, but also locally administered.
--=20
2.1.0

