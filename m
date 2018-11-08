Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C279C32789
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 03:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF2D820684
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 03:48:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="cSZs7m9X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF2D820684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbeKHNVx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 08:21:53 -0500
Received: from mail-eopbgr700128.outbound.protection.outlook.com ([40.107.70.128]:28160
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728621AbeKHNVx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 08:21:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R9hTQkPB3buVA4dXzvH+VvkmHo2/426VhA/4uX4UXRY=;
 b=cSZs7m9XTbfkxRXn0F1QOfFpqv062E+6IYtrroExEIgFPqpvjo3yLTUQAWAyLJebcr5YMrxEMjavW7eMY1OqstKZytz161csxPpmRudmhcUqmEYmgYpPR2a/j1BXntUNLSRKpu5TbsnwO0YCww8bmvYu0Q4Qb5gitPo+VbSV+ZA=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1387.namprd06.prod.outlook.com (10.162.111.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.28; Thu, 8 Nov 2018 03:48:08 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.034; Thu, 8 Nov 2018
 03:48:08 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Madhan Mohan R <MadhanMohan.R@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH 3/5] brcmfmac: p2p cert 6.1.9-support GOUT handling p2p
 presence request
Thread-Topic: [PATCH 3/5] brcmfmac: p2p cert 6.1.9-support GOUT handling p2p
 presence request
Thread-Index: AQHUdxXc3XSx4lbuXE+GWA6BIJ9K8A==
Date:   Thu, 8 Nov 2018 03:48:08 +0000
Message-ID: <1541648845-194984-4-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1387;6:D+xJNN+BBzf+pHIUi2Gk5+DBCtNs3RntjJW5AmPI/dJbHbuEWMiFH0Ch2V4DOhdP1fKGL1KQ5bUQ408I5dnePdU81sDDgYEmrwahrdTFcZReOCYh/qAEDKzpWDsJBQwIag/2at4taAhN5VENlGI+cr8yfjs5G52kVlopYPR0HUNXtVh5zxqHkqKU6986UFsIAY38aHrmBZEVC+F5CejXi9Y6ZDsZ/ed5Y31ZU/sB2O7Gyx5hBCkUAlzv4vPcskv22lZDu0LELyn28i2pwfCgKbOdRjWaq5F8gMVmKlWMzHDx85ec6gpUnnkYp3mAHoevwWWOPOKjpKCvtB75SwExQDcZ2Qd+ildyM7nbFYWlSJc56xIZ7TEi3zAOo9VXnfixXwHgTIU5FnYi3b9ygfqy/9PIkZBtdK0z46XaXe0qyRfA8xRqgjY+eUJjYlcYWDOM3RGFUSTWzEDpLJ4Nx7QJ3Q==;5:+hBCy7X6BZ1BhiGhdhCnNlrHozhh+CXV8CTzNYYawjh12zahlNfMXyACg3ya+xe/qVMWzBQT+bfvwGHAlM7ToiPEQxyrCjttLOgsOVrBnapQiazKSytspMVd8OTmmDe3B2LdjoaTFg3AM0UUJu/ld/K+a9eytTj3d+gqjDzE7Us=;7:SIRYTIyxnJf7j4UHCGv4hPa1Bx9GXv2AE3SCcShjhyxTJpMye5c4Bxo6OEwdqEZRotdxX3UKHkFVK1k91Lfg/gD+7v93uXJEhFrfnDl4NYVpu6D9ttOZouYTEismPQrwP5IGjrBP4oV56DZ1HB2oBA==
x-ms-office365-filtering-correlation-id: 3d2496bd-e37c-4b45-f3e3-08d6452cff19
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1387;
x-ms-traffictypediagnostic: BY1PR0601MB1387:
x-microsoft-antispam-prvs: <BY1PR0601MB13874198443A79874FFAD432BBC50@BY1PR0601MB1387.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1387;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1387;
x-forefront-prvs: 0850800A29
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(136003)(396003)(376002)(39860400002)(199004)(189003)(68736007)(6116002)(3846002)(256004)(6916009)(316002)(72206003)(66066001)(7736002)(305945005)(71200400001)(14444005)(71190400001)(2351001)(186003)(2616005)(36756003)(476003)(105586002)(446003)(11346002)(26005)(97736004)(486006)(106356001)(386003)(81156014)(76176011)(81166006)(4326008)(6436002)(2906002)(25786009)(6506007)(52116002)(8936002)(53936002)(102836004)(6512007)(14454004)(478600001)(99286004)(5660300001)(54906003)(8676002)(107886003)(6486002)(5640700003)(2501003)(2900100001)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1387;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: u+HxF83hy16mRxCE3lbrBFdyrmaeSEb6AQ6i4K2NyRX33HFPThDdhnlaQL7qTmG25aQ+UIeufzw3bN9j4EN0exNOq6mfWcobpWfcjd8TUhyWY0RauQGqvlt98GHplhkMeKnW5yEc4U3RTBhTHPRjbpre6E7XXXtYxMjeGRXlFMGaS+yASP1KAULXOU13LjlZLFWUdQo8Q14O/mlPe8gEU5fobHr+DqB2xZ/7zng0gZaqy/HFyR6VM4z9fb5FewYq62APMYKi9q6UnsNFA5Gm7Wc+jRxXmxSTEv4+ONH64KIMPnyUe5aNZNvIgPzymMIzt2+6wX6qC6rYYE3EqCdK1cA9k/6OBjtVXd32UkBlFu8=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d2496bd-e37c-4b45-f3e3-08d6452cff19
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2018 03:48:08.6437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1387
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Madhan Mohan R <MadhanMohan.R@cypress.com>

Send p2p presence response from the p2p interface address instead
of the p2p device address. This is needed for p2p cert 6.1.9 to pass.

Signed-off-by: Madhan Mohan R <MadhanMohan.R@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drive=
rs/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 456a1bf008b3..dfdd30b19c42 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -1493,6 +1493,7 @@ static s32 brcmf_p2p_tx_action_frame(struct brcmf_p2p=
_info *p2p,
 				     struct brcmf_fil_af_params_le *af_params)
 {
 	struct brcmf_cfg80211_vif *vif;
+	struct brcmf_p2p_action_frame *p2p_af;
 	s32 err =3D 0;
 	s32 timeout =3D 0;
=20
@@ -1502,7 +1503,13 @@ static s32 brcmf_p2p_tx_action_frame(struct brcmf_p2=
p_info *p2p,
 	clear_bit(BRCMF_P2P_STATUS_ACTION_TX_COMPLETED, &p2p->status);
 	clear_bit(BRCMF_P2P_STATUS_ACTION_TX_NOACK, &p2p->status);
=20
-	vif =3D p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
+	/* check if it is a p2p_presence response */
+	p2p_af =3D (struct brcmf_p2p_action_frame *)af_params->action_frame.data;
+	if (p2p_af->subtype =3D=3D P2P_AF_PRESENCE_RSP)
+		vif =3D p2p->bss_idx[P2PAPI_BSSCFG_CONNECTION].vif;
+	else
+		vif =3D p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
+
 	err =3D brcmf_fil_bsscfg_data_set(vif->ifp, "actframe", af_params,
 					sizeof(*af_params));
 	if (err) {
--=20
2.1.0

