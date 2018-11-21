Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0182C04EBA
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 07:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DCD52145D
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 07:54:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="Jf0xBNSe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DCD52145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbeKUS12 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 13:27:28 -0500
Received: from mail-eopbgr730138.outbound.protection.outlook.com ([40.107.73.138]:59712
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728285AbeKUS11 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 13:27:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Be11iNvYxsStvcW9ocCJyVZPVwaCjiR0/zdsd2Gd0E4=;
 b=Jf0xBNSecvNQfwHQQTtoHicxXP+3Tc1iUJ62ryAUXW5E+RQvhTOKBJ4Og2S4Mw78DLUMcfbwcMHYpjD9uRfQcah90uVQNz79pc8rgJBm2YNkTH7nBoJWiyTMmB2Phce1eMhXmc7ZGIaIFRzSCt8JUPvELD1brrUutfHnva8ouXg=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1174.namprd06.prod.outlook.com (10.160.195.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1339.23; Wed, 21 Nov 2018 07:53:49 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae%4]) with mapi id 15.20.1339.027; Wed, 21 Nov 2018
 07:53:49 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Naveen Gupta <Naveen.Gupta@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH V4 6/8] brcmfmac: update 43012 F2 watermark setting to fix DMA
 Error during UDP RX Traffic
Thread-Topic: [PATCH V4 6/8] brcmfmac: update 43012 F2 watermark setting to
 fix DMA Error during UDP RX Traffic
Thread-Index: AQHUgW9WGPjn5GwWlU+NeXk1PkQChg==
Date:   Wed, 21 Nov 2018 07:53:49 +0000
Message-ID: <1542786800-146083-7-git-send-email-chi-hsien.lin@cypress.com>
References: <1542786800-146083-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1542786800-146083-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: BYAPR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::37) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1174;6:euNDe8568dzLVADif92J+mFz14MPh/T02y84y7rJdrizrbb254+OUdVex3MF9HV+FKuWuW69r1BhRLy9PDLLLFdb5L/5gtv197/5XCkCi78DyMxzQZA0RduZZg4aPYlklbsA8vQZkHF16yp1aoS+1xLkSs9Ndfvz0QCQhkkfp1ruTY19NWsHh+thfiJpnZ2Zw4LiHBndfAc38cSnHVtVb07WFKwdz5Mq/4QqLl3EIRkRBm/z9/ifLa3JZbi88kvGK2lXLUFu3GcC3a20GAphFrQqUsv/G7yV4RpEDeIeZCmKqMwYHQN5Ihj9WLqLuSeL0EJxih+fo3/YPNXc3juqIfkJinUFLsCI98Vdw9+TOJ5VcumnJvUQnJZeTCj4iWBIu80zB3B8oO3wOPGu9keTc6m1VvNp/qXJ3CBXlnmUUUKWfYElhQ5hpvkuL2nGcTBgK5KPP/Oont6urROeLvqXiw==;5:b2aJPPg4n/92vroKcOT+toNhAfj6FX26b5NDooA0vXQ0dllfAMLMkug9lHf+shZOIcOe0WngRZx6mfCFtdvSPoWcyivoxQDuNds1Da+kjZPxnCqDV6TKOKeLPTZexkHWqCVE6sLIyMNssfSNW/zMFFtcgByBnGABjPyNhIBlBNU=;7:1Q8rRjzgGqimbvma9CT1Vib7Wj+MW4APe+pkfwwkf4z3TDnYYv9KfwW45vzH5RrL2cuEHBPvvL+O68foiP4OHAfxw8DKg/4zWGmTyQZ4pqMrp8S9q3Ts88bug6tZFWA/eD1Atle7NLu6bGJL+kKKzw==
x-ms-office365-filtering-correlation-id: 6b0bf5dd-ab50-4a6c-4108-08d64f8678bf
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1174;
x-ms-traffictypediagnostic: BY1PR0601MB1174:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-microsoft-antispam-prvs: <BY1PR0601MB1174A57A77F08FBE4B270DA7BBDA0@BY1PR0601MB1174.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(93006095)(93001095)(3231442)(944501410)(52105112)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(20161123560045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1174;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1174;
x-forefront-prvs: 08635C03D4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(376002)(396003)(346002)(189003)(199004)(107886003)(478600001)(36756003)(72206003)(97736004)(8676002)(81166006)(81156014)(186003)(68736007)(6916009)(8936002)(71190400001)(54906003)(2906002)(316002)(25786009)(2501003)(71200400001)(6116002)(3846002)(99286004)(6436002)(2351001)(256004)(305945005)(6486002)(76176011)(7736002)(105586002)(6506007)(4326008)(386003)(52116002)(5640700003)(102836004)(66066001)(2616005)(106356001)(476003)(14454004)(486006)(26005)(11346002)(86362001)(53936002)(2900100001)(446003)(6512007)(5660300001)(575784001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1174;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: HJ/ZSCrqhtc7VEdJu1jlUD72OlLcsLHQkaSKxPp0rg5KhV6yM+kCtFhgEuYc/3NBB8ACl220DrdEi61/5KR+BGoVheahZh3FeOui786GuRxfB62LHUYCZV5UVd0CUEosP0PkJ6Q0LXU/CbPX7VRyf7pPX22iVTVZth9EZ3Af8o7AfojKI/6+p37v63oUY5oV7nxOMHSbapmDAPcXw7yovphv1nr50E+7CapQ8IA8m7/oNpMpbEoID+8O+dEPQgOQmeWOqCHIGuG3qe4qg09WDHdZZhdkCtkWP2xi8KkAboEJkSuQwox7uumspo7uGt6UwG58cNS+tkeyGwD1cHmeImZJo/0GCkgONjmWwC71/J4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b0bf5dd-ab50-4a6c-4108-08d64f8678bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2018 07:53:49.5922
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1174
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Naveen Gupta <naveen.gupta@cypress.com>

The number of words that the read FIFO has to contain except
the end of frame before sends data back to the host.
Max watermark =3D (512B - 2* (BurstLength))/4 =3D
(512 - 128)/4 =3D 384/4 =3D 0x60
so if burst length (i.e. BurstLength =3D 64) is increased,
watermark has to be reduced. This is the optimal setting for this chip.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Naveen Gupta <naveen.gupta@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 73a034172c4c..fe0cb398ab44 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -52,6 +52,7 @@
 /* watermark expressed in number of words */
 #define DEFAULT_F2_WATERMARK    0x8
 #define CY_4373_F2_WATERMARK    0x40
+#define CY_43012_F2_WATERMARK    0x60
=20
 #ifdef DEBUG
=20
@@ -4173,6 +4174,17 @@ static void brcmf_sdio_firmware_callback(struct devi=
ce *dev, int err,
 					   CY_4373_F2_WATERMARK |
 					   SBSDIO_MESBUSYCTRL_ENAB, &err);
 			break;
+		case SDIO_DEVICE_ID_CYPRESS_43012:
+			brcmf_dbg(INFO, "set F2 watermark to 0x%x*4 bytes\n",
+				  CY_43012_F2_WATERMARK);
+			brcmf_sdiod_writeb(sdiod, SBSDIO_WATERMARK,
+					   CY_43012_F2_WATERMARK, &err);
+			devctl =3D brcmf_sdiod_readb(sdiod, SBSDIO_DEVICE_CTL,
+						   &err);
+			devctl |=3D SBSDIO_DEVCTL_F2WM_ENAB;
+			brcmf_sdiod_writeb(sdiod, SBSDIO_DEVICE_CTL, devctl,
+					   &err);
+			break;
 		default:
 			brcmf_sdiod_writeb(sdiod, SBSDIO_WATERMARK,
 					   DEFAULT_F2_WATERMARK, &err);
--=20
2.1.0

