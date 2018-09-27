Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E540CC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F04921546
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:45:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="ekkPht9O"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F04921546
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbeI0QDS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 12:03:18 -0400
Received: from mail-by2nam03on0103.outbound.protection.outlook.com ([104.47.42.103]:11780
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726952AbeI0QDS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 12:03:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2JIv3pmImwqCOr4iLiwoASnEEL6umGLZ2GeFEmav9E=;
 b=ekkPht9O1MGbHTyuGfSZt4qqrafpPqkCoOiSYYcgUGIv3LjomVXE6zyeTSJLojfrmiIijNw+N5L6sLrcGZYCFYXo5FYkrseNBWfc1U2osPSe4BEryFTsIX5rcwohWGYnn16nTLNOQlhGZ+DMqa6kgfGDmI5FdDMUSFKRvUXuZNY=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1110.namprd06.prod.outlook.com (10.160.196.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1164.20; Thu, 27 Sep 2018 09:44:27 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::ad59:f71e:ebcb:70ac]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::ad59:f71e:ebcb:70ac%5]) with mapi id 15.20.1164.024; Thu, 27 Sep 2018
 09:44:27 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Josh Boyer <jwboyer@kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Stanley Hsu <Stanley.Hsu@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH 1/2] brcmfmac: reduce timeout for action frame scan
Thread-Topic: [PATCH 1/2] brcmfmac: reduce timeout for action frame scan
Thread-Index: AQHUVkauC+1CtbdwG0W3m9pcdEKsWQ==
Date:   Thu, 27 Sep 2018 09:44:27 +0000
Message-ID: <1538041427-115758-2-git-send-email-chi-hsien.lin@cypress.com>
References: <1538041427-115758-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1538041427-115758-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: BYAPR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::19) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1110;6:kVQ23UWryV9FAA5GcCaAWWt1q9pqEmwib9zTpOB/cmdboTvgtdTtx7Gd5LWuG9h5wF3YYYIvftL5Xcg273VzXJoiaOKn0l5OPYF8xiiRtADCgHggkJV0AetS8zfsdNAJPKYzVj4TkR3c9RX3P4RsczSUX0XI+mOUt3y2L5lMgSqtTDOuRu6a+EgDuzeZbcK7bxnHVQq69bF/NJ4Ry/jCelHOa+khH2jjfc0JVtXSvGp5veoQjO/xC8TKg2Uq41DhAiw8zzn13Lcl0oN7exl8IqbfIWwqtTE4Jqm+gHwZZlQTrQM8Zy4E98GGu4tmiHcI6n4+5pOKKTWiDWbN6G15PtxOJYSSA5jhMOx4PPyWRyf1LHuvZjq3lqpHs6BkGzpTtaFWt6WadZvKEEoRbEtY/fWc08rcZO882kB2PpppInA7cKew0xQtKHYZCzjP4DS1NfyF1Bc8bgJ2qJMqhq6dtQ==;5:BsSoOrVAqqDyFB/Bb9WCpuexZmJRICJETJKkXX1yU/M2XT6fkgJyVIj9gByUBu/19s27IZLanOXgVc6MGb8sAP/8TILahnjlqvMZ5JHAv8+5eM0F9aTly5mz68bo7JHZIjXpzq5S3EAvk2Mv2OkDf7+tHmwvEBG70osg4eHN1DU=;7:OL52jKq6kvDKh/q5WyLsV1/TCVCL+x2ETOqG3RQsXPGj5uMVkIkAyfJLEdqRA0zCrz0QiRXVwlXDeP9woFmFINYxQCG0aqXj/jE6m5rUO7xgdnKdnn1n9PJ6+RJJxhAKDyguRK6TW2W4dET0mYo+q5VAUBukrvSh0II6s068TOhW8NQAum7MySyuOGG7UShTWYCxtf46MwDWbQX76to7HVKnjxLqqxjVfxsHF7NRlWXB71efRqCRwoYN1FdwD4QY
x-ms-office365-filtering-correlation-id: 53f16f77-a837-4858-4fb2-08d6245dd08d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1110;
x-ms-traffictypediagnostic: BY1PR0601MB1110:
x-microsoft-antispam-prvs: <BY1PR0601MB11107BF83253131EC20DBBF6BB140@BY1PR0601MB1110.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(93006095)(93001095)(3231355)(944501410)(52105095)(6055026)(149066)(150057)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123558120)(201708071742011)(7699051);SRVR:BY1PR0601MB1110;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1110;
x-forefront-prvs: 0808323E97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(39860400002)(376002)(396003)(366004)(199004)(189003)(8676002)(256004)(76176011)(54906003)(66066001)(4326008)(6436002)(2900100001)(2906002)(53936002)(5640700003)(3846002)(71200400001)(107886003)(6506007)(52116002)(386003)(102836004)(6512007)(5250100002)(97736004)(71190400001)(68736007)(6116002)(36756003)(14444005)(81156014)(99286004)(486006)(316002)(81166006)(25786009)(186003)(26005)(86362001)(6486002)(305945005)(6916009)(7736002)(478600001)(5660300001)(105586002)(2351001)(106356001)(72206003)(11346002)(8936002)(2616005)(14454004)(446003)(34290500001)(2501003)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1110;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: q158TbL683AeIY4FV2Hx1rz2kAK7JCa65w5a9M65GPcyFY3b5Lx9IsfrcoynNYpCrZXmxubIs4E5zkzWIqEQoJYEFLu9FqACU+FIhS+X0TdZAl+DoLuvmvpDMO6gtOpH0gByFDADSRgirbkMQUpQI9bXpaOTX+/R12M01AxFU0fPJP5OH2MC7S8JY/cmi0QF0IsdbJ4v4pprwZaFIzuctfkz4RmoFf3x0LbYnifUl6Tnii7Mpr9wlSCAHuvwt095mHyFVTJe6g4K9yasvISrWmWLLnck7wHV/rOw1DkbSuVx0KutAfZ59K+cWWP3Obd/bdS5lCVMSZ5VIMLrpzBf4V14Bj9CGvD7YW60OFaeyMI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53f16f77-a837-4858-4fb2-08d6245dd08d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2018 09:44:27.4765
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1110
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Chung-Hsien Hsu <stanley.hsu@cypress.com>

Finding a common channel to send an action frame out is required for
some action types. Since a loop with several scan retry is used to find
the channel, a short wait time could be considered for each attempt.
This patch reduces the wait time from 1500 to 450 msec for each action
frame scan.

This patch fixes the WFA p2p certification 5.1.20 failure caused by the
long action frame send time.

Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drive=
rs/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 3e9c4f2f5dd1..7822740a8cb4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -74,7 +74,7 @@
 #define P2P_AF_MAX_WAIT_TIME		msecs_to_jiffies(2000)
 #define P2P_INVALID_CHANNEL		-1
 #define P2P_CHANNEL_SYNC_RETRY		5
-#define P2P_AF_FRM_SCAN_MAX_WAIT	msecs_to_jiffies(1500)
+#define P2P_AF_FRM_SCAN_MAX_WAIT	msecs_to_jiffies(450)
 #define P2P_DEFAULT_SLEEP_TIME_VSDB	200
=20
 /* WiFi P2P Public Action Frame OUI Subtypes */
@@ -1134,7 +1134,6 @@ static s32 brcmf_p2p_af_searching_channel(struct brcm=
f_p2p_info *p2p)
 {
 	struct afx_hdl *afx_hdl =3D &p2p->afx_hdl;
 	struct brcmf_cfg80211_vif *pri_vif;
-	unsigned long duration;
 	s32 retry;
=20
 	brcmf_dbg(TRACE, "Enter\n");
@@ -1150,7 +1149,6 @@ static s32 brcmf_p2p_af_searching_channel(struct brcm=
f_p2p_info *p2p)
 	 * pending action frame tx is cancelled.
 	 */
 	retry =3D 0;
-	duration =3D msecs_to_jiffies(P2P_AF_FRM_SCAN_MAX_WAIT);
 	while ((retry < P2P_CHANNEL_SYNC_RETRY) &&
 	       (afx_hdl->peer_chan =3D=3D P2P_INVALID_CHANNEL)) {
 		afx_hdl->is_listen =3D false;
@@ -1158,7 +1156,8 @@ static s32 brcmf_p2p_af_searching_channel(struct brcm=
f_p2p_info *p2p)
 			  retry);
 		/* search peer on peer's listen channel */
 		schedule_work(&afx_hdl->afx_work);
-		wait_for_completion_timeout(&afx_hdl->act_frm_scan, duration);
+		wait_for_completion_timeout(&afx_hdl->act_frm_scan,
+					    P2P_AF_FRM_SCAN_MAX_WAIT);
 		if ((afx_hdl->peer_chan !=3D P2P_INVALID_CHANNEL) ||
 		    (!test_bit(BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL,
 			       &p2p->status)))
@@ -1171,7 +1170,7 @@ static s32 brcmf_p2p_af_searching_channel(struct brcm=
f_p2p_info *p2p)
 			afx_hdl->is_listen =3D true;
 			schedule_work(&afx_hdl->afx_work);
 			wait_for_completion_timeout(&afx_hdl->act_frm_scan,
-						    duration);
+						    P2P_AF_FRM_SCAN_MAX_WAIT);
 		}
 		if ((afx_hdl->peer_chan !=3D P2P_INVALID_CHANNEL) ||
 		    (!test_bit(BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL,
--=20
2.1.0

