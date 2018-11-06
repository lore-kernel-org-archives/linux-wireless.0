Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B73C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B1DD20818
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="li3htgwt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B1DD20818
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387446AbeKFNNq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 08:13:46 -0500
Received: from mail-eopbgr810120.outbound.protection.outlook.com ([40.107.81.120]:58734
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387424AbeKFNNq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 08:13:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VG/o6sICQAneLzPuErt0knQa5IXhi4SeQrtfgncNA+c=;
 b=li3htgwtykuRuNjzsIqTcWz5unQNshwo8Z2cSWXv2EC0FF4BLVoX5JQjTyLdJkmguhj8AFm5kqDpRCx8PZTxkR1TNp4BLLin2ezGmL8LVHUvffl/WmG2EkDXeXtuBCFzVyDgoRCfnl7PqTCd/u1Yb8Ay1m8t7gfOHyPBpPRS5GI=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1142.namprd06.prod.outlook.com (10.160.196.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.27; Tue, 6 Nov 2018 03:50:26 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.032; Tue, 6 Nov 2018
 03:50:26 +0000
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
Subject: [PATCH 08/11] brcmfmac: 4373 save-restore support
Thread-Topic: [PATCH 08/11] brcmfmac: 4373 save-restore support
Thread-Index: AQHUdYPaRKN2lEL9VEu4JExKGqQ8kQ==
Date:   Tue, 6 Nov 2018 03:50:26 +0000
Message-ID: <1541476188-75475-9-git-send-email-chi-hsien.lin@cypress.com>
References: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: MWHPR2201CA0082.namprd22.prod.outlook.com
 (2603:10b6:301:5e::35) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1142;6:gmeRiug7fnwmpyl+kb1bOKnAyXoaflqbCxeN9BDQZyx3plnNpDbqDy6jXYOqThrCiVFN/KWvvkT4Usc1kyc4tuLtPsF0+9Sv51/jAmrPwfDxr1TTPXCVAVzkY2vfuJBBT9CBM8CyPKTIIwkbn3DH740JPTqH81nn0WfNLzQxWUTo4PI1pXpM9c9PTe0XovPfFNjTz3wEII+SYVvjE1aScCBpeOaKZiRf2qP2vUVGdK7U45bRyXjWw7Ym5QU4/JG2PHnYvMPrPbT42kV4IpmJvJJbx35CJ4xG5d1HipXecXj54hbwMJ20dc4Ip2AVmqIc9q0wHPbPf766oB0N7ayKuJJEH+DmMCPFVXJMD5s0xyIIbw+1wZ0Q05ZN9BZRbDJE4a169AEXSw8dp6Dmt2qLgs0ytvzskKkv2T667dWC+LBrw0VnutdkcyteIpuCfZQmxbk4zLTBl3Ysdx9sVT+gXg==;5:pPWp/dOGdLar4wpToZvobo/GWJdsJK8KRnur3+SNA2RFEYN7773cAknGEpkS1X7QaeFswZ77E2yF7dNb6Sj1w+FqB+Cq3jW9HeGwLuXDChbf3dNnAq3sty//1pihjZ9Te47EkDMaWRxi2MTNbr0NCRO1C0IZQrYvoHQ9Xop717U=;7:e+IAMdlldVByXHy6ezyoENKRCwqDVaF7QL+gNFmVzBOu3kPVf2vq/+dLiej3ovJcfLr2SofpoeRT1SIqoAQbeDGxV3+UHCg1AbA7I6LH/zxuEYkSuPDtiDI3nz50TuDOl9cqpxtTLbDzDLqVONccdA==
x-ms-office365-filtering-correlation-id: e874d8e8-6883-4d84-877b-08d6439afc6b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1142;
x-ms-traffictypediagnostic: BY1PR0601MB1142:
x-microsoft-antispam-prvs: <BY1PR0601MB11425AA11A1C2111066F3146BBCB0@BY1PR0601MB1142.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123562045)(20161123558120)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1142;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1142;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(376002)(366004)(39860400002)(346002)(199004)(189003)(6506007)(36756003)(386003)(102836004)(186003)(2906002)(6916009)(8936002)(54906003)(5660300001)(81156014)(5640700003)(81166006)(14454004)(26005)(8676002)(476003)(486006)(2351001)(2616005)(446003)(97736004)(11346002)(6436002)(106356001)(105586002)(6512007)(256004)(6486002)(14444005)(4326008)(3846002)(6116002)(7736002)(68736007)(99286004)(72206003)(53936002)(305945005)(76176011)(66066001)(2501003)(107886003)(86362001)(316002)(71200400001)(71190400001)(52116002)(25786009)(478600001)(2900100001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1142;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: IosNGMzKCfrZAeCmvBRUfqRFPXG9ZihKVNihY1EFSUWY6NsXwQ0tYU4if4AXa6zJFY9lmE0UgXE6qGdBUQfAo8xCMfWK0fpij6PiElZu+0S10bfLj0ecACIhXMlb1y+BGSKwO5xSOyYpqvj82xen2t0AAVcghHNTLtKtLviX3+lxBGNHWzfk40iUDauJ3jHgEsqQmEP+6Tah/+DsmPEcQRFDcwh1fOa1irawm9st9hLhvhdgbXOwBeO2ZWHCwWL39iJ5BcFIiOR1atFdWzka5ad9n/oa76RsmdMyKF+XW/wAB2HB2hEIkRTq7zm/OcY9v8YmYojYE88RVmC5WVEzTysV4Z/6bxC/r5mQ6z9G8sU=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e874d8e8-6883-4d84-877b-08d6439afc6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 03:50:26.3077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1142
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use sr_eng_en bit to check 4373 sr support.

Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index a8d3b96b727f..dfc2af943bff 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -1332,7 +1332,7 @@ bool brcmf_chip_set_active(struct brcmf_chip *pub, u3=
2 rstvec)
=20
 bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
 {
-	u32 base, addr, reg, pmu_cc3_mask =3D ~0;
+	u32 base, addr, reg, sr_eng_en, pmu_cc3_mask =3D ~0;
 	struct brcmf_chip_priv *chip;
 	struct brcmf_core *pmu =3D brcmf_chip_get_pmu(pub);
=20
@@ -1365,6 +1365,12 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
 		addr =3D CORE_CC_REG(base, sr_control1);
 		reg =3D chip->ops->read32(chip->ctx, addr);
 		return reg !=3D 0;
+	case CY_CC_4373_CHIP_ID:
+		/* explicitly check SR engine enable bit */
+		sr_eng_en =3D BIT(0);
+		addr =3D CORE_CC_REG(base, sr_control0);
+		reg =3D chip->ops->read32(chip->ctx, addr);
+		return (reg & sr_eng_en) !=3D 0;
 	case CY_CC_43012_CHIP_ID:
 		addr =3D CORE_CC_REG(pmu->base, retention_ctl);
 		reg =3D chip->ops->read32(chip->ctx, addr);
--=20
2.1.0

