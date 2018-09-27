Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86FFDC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2221721582
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:04:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="BfOx2O6h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2221721582
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbeI0VWs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 17:22:48 -0400
Received: from mail-eopbgr700126.outbound.protection.outlook.com ([40.107.70.126]:49887
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727334AbeI0VWs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 17:22:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2JIv3pmImwqCOr4iLiwoASnEEL6umGLZ2GeFEmav9E=;
 b=BfOx2O6h0MyInfsavzL4zAX8pschcauklVRV8ZwkpGNVK3tz7I6oupmg/WlFo0g/DmC6bjmSvCRiGlMrGzkZjHtVZ6pzUOEW/ZtTIAV7ivQ4Z2HFPyJChPPwfKtioVmdXAo+jdsFZn3p9LY+AHU3rGRtNCVkzFbXfnnQ2DZTIgA=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1481.namprd06.prod.outlook.com (10.162.112.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1164.25; Thu, 27 Sep 2018 14:59:45 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::ad59:f71e:ebcb:70ac]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::ad59:f71e:ebcb:70ac%5]) with mapi id 15.20.1164.024; Thu, 27 Sep 2018
 14:59:45 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanley Hsu <Stanley.Hsu@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH v2 1/2] brcmfmac: reduce timeout for action frame scan
Thread-Topic: [PATCH v2 1/2] brcmfmac: reduce timeout for action frame scan
Thread-Index: AQHUVnK5G6gVJT3oP0+VjlZtKfhCaQ==
Date:   Thu, 27 Sep 2018 14:59:44 +0000
Message-ID: <1538060351-12827-2-git-send-email-chi-hsien.lin@cypress.com>
References: <1538060351-12827-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1538060351-12827-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: MWHPR19CA0095.namprd19.prod.outlook.com
 (2603:10b6:320:1f::33) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1481;6:dpPQfvkf4Z1phd85gIGcSzl5pjuZ/UgMJzxBVSVzsBXWasusGtQ2eVqR9pZ2i62npi19cnxMtvN0lO8ghtB+5kbvoa2CffaINVVw2K7momLLbpeeiqBMBr2NXWGCRt1xtAVCOtj/8WWImEJxfAYuyp6vLDyA7xq0dPkyAXDZ/e0XcoAXCn3oJCo5G3Gk3UPLYfy6w+fMkOJkLlJQBlbCvNtBrM9YyhD479QiiMz+PG4BpbSkDei58bVhIfaZRVaI4ub6fiKYI10sg25C/IJvwYETjdTkOXXVFj7K4JONuoCkr+wn7AwvXZ11e0DPZlcSh8ctGundr2DWaS0iQhvcIfJxlMFRJ8Baq5LrPvr4EZvglEo8AroKOigumrQQf+OXZiaA566xBoOI+UsrBDJKQ7tEk4DT+CVUwzyweYkkTtjtBOsusLe1oUy8nO2cHyEGISjYn9eqYibGRIVyYOubtg==;5:+hkpxFJJl4jv2dvu08OzLKl9Xc0pMlL/YvQGcECwRDAB4fhac1p83sY2xkteZm576IX80Vya1DvEixAegJaMKwo26kHlA2vrUW7lm5r/+im17wLxFLNthVOr1yveO+/RjTL3/vtOrrHic2xTZbpd/2IJCuA2SZ1FjHVC5GBdfTc=;7:4auLB0qZGbEfXZwrbmyicPPXMeBqFthzoD/HNoG5F5V3CYLX4FQqeZnaC81G8KY0ER15uRAxinSwFn+zaubnr7HVqJ8kXxzFhee7bc5oh7/Uot7SdIeLKy/PYLTbrb1OZ6b4NweDCjHjvyjoP8D0EV4Sr3AzGKDkaLP26xvhLUN8X+uYo3l2M7fLxjboKnZKS+rLTXxwmoAqrzMKLu3SGzTk0Yjt1lhakuKeelw7aTfPuxGYyG/bJIhNxJr9PUWS
x-ms-office365-filtering-correlation-id: 895dd35e-796d-4a33-f7db-08d62489dbe9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1481;
x-ms-traffictypediagnostic: BY1PR0601MB1481:
x-microsoft-antispam-prvs: <BY1PR0601MB1481FE00242D0DB6C6078BF4BB140@BY1PR0601MB1481.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3231355)(944501410)(52105095)(93006095)(93001095)(10201501046)(3002001)(6055026)(149066)(150057)(6041310)(20161123560045)(20161123558120)(20161123564045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051);SRVR:BY1PR0601MB1481;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1481;
x-forefront-prvs: 0808323E97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(366004)(346002)(136003)(376002)(189003)(199004)(53936002)(99286004)(6116002)(5250100002)(446003)(3846002)(26005)(6512007)(2501003)(5640700003)(68736007)(6436002)(8936002)(8676002)(6486002)(186003)(316002)(6506007)(102836004)(6916009)(386003)(5660300001)(81156014)(105586002)(106356001)(2351001)(81166006)(2906002)(97736004)(54906003)(25786009)(72206003)(36756003)(486006)(2616005)(14454004)(4326008)(107886003)(478600001)(7736002)(71200400001)(52116002)(2900100001)(256004)(14444005)(476003)(34290500001)(71190400001)(11346002)(86362001)(66066001)(305945005)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1481;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: kT41E9iDLz5npBs1CrsErkV6LKVljQAIGoSEGjP2Mn7Hw5mnGXWEpF+fqeAYf8cxb6cPB4Ah0CgH2app9JICwqDr/EiGd/dYKToDgdoL9Flsjc2JHlvDx3Rgd58W9ufwVoPrrTtrLvMKPxeI/qIlPlaSgdQ2QUnLDapLFkJp8M50SsUB4OxLxeKhBXkWe+AVHMwQthAGRGWEEvjqslfcGQJLxkhl318EYg3yUgyTzR/Gt5+sQhmwIOVCDLKNovUx+z4ZZORXiCC3XpvTSuUGS2B4ORXXGdBf06kqCfivYrkNo8V2KffvJvsxxNDypOhtWczlsXNfvlB3UBM+jnrTvoyqL73Hh8M2IFkZGyPVNIs=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 895dd35e-796d-4a33-f7db-08d62489dbe9
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2018 14:59:44.9886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1481
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

