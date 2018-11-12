Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81514C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 07:30:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A52121722
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 07:30:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="aTWvWhk1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A52121722
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbeKLRV6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 12:21:58 -0500
Received: from mail-eopbgr760133.outbound.protection.outlook.com ([40.107.76.133]:54833
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727063AbeKLRV5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 12:21:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w70NKXnt9GJ9/b4qQ6KTrV3vkQH8rlh70UyNt8KXKjg=;
 b=aTWvWhk1bsEVFEEZxO2hA63gmSxB/jnPKDMNbpWgJ44bBVQSmFkTVlW9lvXNpBe1e6FRZ2uZLTvCjpWZTWnNOx3PkBP8a/TWFDmARBE+LEncHBCus/9U3PJxvH1SjYbGvPb0hs9MwYWLb8Zblwg29+0uPzm9QaVYpwZlo63HXpk=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1126.namprd06.prod.outlook.com (10.160.196.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.29; Mon, 12 Nov 2018 07:29:56 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 07:29:56 +0000
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
Subject: [PATCH V2 7/8] brcmfmac: 4373 save-restore support
Thread-Topic: [PATCH V2 7/8] brcmfmac: 4373 save-restore support
Thread-Index: AQHUelmCvSUU4MYki0WOXWO9KGq0hw==
Date:   Mon, 12 Nov 2018 07:29:55 +0000
Message-ID: <1542007730-47284-8-git-send-email-chi-hsien.lin@cypress.com>
References: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: HK0PR03CA0084.apcprd03.prod.outlook.com
 (2603:1096:203:72::24) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1126;6:XiJriCEGw4P/8g+SEC2yRqvx5xAzUMeuEXzTDv0kE57wi6B8i4McbbAr1tukFIyZO2K/LJ3edxIkK0zKS+o2aZ0t0bY94SSuE7fnKVshf9xKEoTQI3hsx+6QR4yk6LhDChB9V5LIxEJxmxIE+QUhd5TxAedj7Vf5frCNDd2Pq/L0CtkXx3X/8PuGz73gTx2Awje8b1dtVXPyNaf4UUi7zcce0/+sRl5p4wgCFkP1qlshQyVyJ9olOCEc2v/zzAi/s0ZnQfYOtSoW+T9mG4YtfslhBBJlB9QAUYbGpihfUG+2nyzLwp4e4su3r2cN/6ghD0kxr3P+/Fc0SZ3oNV5vX7wk+5xbD5poBFmmnlv3uwfNjDaalzqNOLe0unyDSzyWR/1ZocDS+CQpEXQtw/fmTsUqEi5Fi5Un+mWkG6Xh02kbtgDo2Dzrk5seEyTTiXGjXPFi5Zm6+iP61q5BDcrXlw==;5:P+6vkFqkQz9VSDktF4bAToT5J/Rxk+6znDLLYBcn7LwX/1B6mSCfEMALyyFS2sT5+k7GVKWqCD3T2Kmv4n0wt6QbtA9JVAOEtEK+ylbMt1OFMh1oga/OvfXTWxEJqPYf6E/r2GXoYY/B4sRvJbgzRnoZ/uDLmKuoTLidW4DVfPI=;7:At/lQP9PI7qrYdm1eVWZ3XgRoQsvRRxBwaKTDQW8kr/agJoGGOI3USzqxzuVrtacdgAqSzvgKjJc4XHBg+jxLucMChgHTU2gy8NHWHwtRjVrL1ls+HnSzeXRSl8CjI9gyNmglI8Dv8QOHg8LY85GtQ==
x-ms-office365-filtering-correlation-id: d64485d0-12b2-42d4-c546-08d64870a48d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1126;
x-ms-traffictypediagnostic: BY1PR0601MB1126:
x-microsoft-antispam-prvs: <BY1PR0601MB11264B93D22403241506E58BBBC10@BY1PR0601MB1126.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(208715162771679)(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(3231382)(944501410)(52105112)(93006095)(93001095)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1126;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1126;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(396003)(376002)(39850400004)(136003)(189003)(199004)(25786009)(4326008)(2906002)(76176011)(3846002)(6116002)(99286004)(52116002)(81156014)(81166006)(478600001)(68736007)(8676002)(6486002)(14454004)(66066001)(5640700003)(6436002)(72206003)(8936002)(256004)(386003)(102836004)(6506007)(106356001)(105586002)(54906003)(6916009)(2351001)(86362001)(305945005)(2616005)(5660300001)(36756003)(7736002)(316002)(2900100001)(186003)(71200400001)(446003)(11346002)(476003)(486006)(71190400001)(53936002)(6512007)(2501003)(97736004)(26005)(107886003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1126;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 7zMD0iqOqSQEdlqLcUuHqqXZbs0KBz66FHaSR5Ao5wcW1zvSp+4/58gbAkCRjR4piIdZENEyCtA6oq39YFWGNlWaGdPuUQGWQ+lOnP61GZk8mSiEZ7697SK+xXMRYkktEN2+zE6QDw56TnEyAd5pkdyscNY5GtdnIO4UubIhMCGUxqjFrgBrdEtadb12upuqREnUXjva/4dPXC/7R/9+GbSKKd+h/M3sDNLRCuRlLqqzFHFadT/+xcLUqHF153DMiJ7Z3YvDJsA018/or7iG8xw0Ad3z62Y07bcFsbxns8JrGYQU6BSwIRTwngSo584z9aYpOMhLwnWXLRgEeTtgekTdTP2WHhyljIQOGKngcXk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d64485d0-12b2-42d4-c546-08d64870a48d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 07:29:55.9780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1126
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use sr_eng_en bit to check 4373 sr support.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index a8d3b96b727f..08d5173d000c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -1365,6 +1365,11 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
 		addr =3D CORE_CC_REG(base, sr_control1);
 		reg =3D chip->ops->read32(chip->ctx, addr);
 		return reg !=3D 0;
+	case CY_CC_4373_CHIP_ID:
+		/* explicitly check SR engine enable bit */
+		addr =3D CORE_CC_REG(base, sr_control0);
+		reg =3D chip->ops->read32(chip->ctx, addr);
+		return (reg & BIT(0)) !=3D 0;
 	case CY_CC_43012_CHIP_ID:
 		addr =3D CORE_CC_REG(pmu->base, retention_ctl);
 		reg =3D chip->ops->read32(chip->ctx, addr);
--=20
2.1.0

