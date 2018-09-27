Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00546C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:00:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AE5121582
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:00:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="wSwCOBHn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9AE5121582
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbeI0VSm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 17:18:42 -0400
Received: from mail-eopbgr710132.outbound.protection.outlook.com ([40.107.71.132]:32480
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727199AbeI0VSm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 17:18:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UhdBa6U4bqo5XVQ38GjL88uffJ5IeKBtyFLtk3lcCIY=;
 b=wSwCOBHnd9yIFIiuepZ76Cwck7jlJzzBQyQ+7BJDxtJ1y8YR1zbfUr1Kz8Cg1ntAgzLhfsO8Zshabqh4pgRVi27Ie1utdrBbKQMi8A0XXNI5o5iejPaTcXVQHeR5zTKcEMAxXHaF39kA0Pq91RnSioldQhNWJlfefRIKYN7GZAo=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1388.namprd06.prod.outlook.com (10.162.111.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1143.18; Thu, 27 Sep 2018 14:59:49 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::ad59:f71e:ebcb:70ac]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::ad59:f71e:ebcb:70ac%5]) with mapi id 15.20.1164.024; Thu, 27 Sep 2018
 14:59:49 +0000
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
Subject: [PATCH v2 2/2] brcmfmac: fix full timeout waiting for action frame
 on-channel tx
Thread-Topic: [PATCH v2 2/2] brcmfmac: fix full timeout waiting for action
 frame on-channel tx
Thread-Index: AQHUVnK8yHAWcsBJFEKhy5NZp6MIEQ==
Date:   Thu, 27 Sep 2018 14:59:49 +0000
Message-ID: <1538060351-12827-3-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1388;6:g0e6rz/TuJGZmDPsD4ORmcEqPko4vYKbCJpOnKNMQosoPQ5qduYYz6OKCiTJ6NsA0MvMXKhSp6IoGWcFAWlzNe9f6RjNaHtTN12ZAroiT/OBz0AfK7ujwHNQY0cxJHe1Dfm8veZV8Q/tHZ/Weej93yvxn4IGFuQpkjT8RykrOPIfnHwJYIKOg1yx0+uYaSSqNs09rjOuh4aYHwgzQS3YLEaz8JVV0GB7FS4hODlB5YhxiXlCfIOhWLkMJlQoRQHrFd0fzU6ck+Vb5arNFDoMfFru74lAoqQSTogOaDU05PuZPJ723DaJKE/7swNBseroh1z0wZIzAnGhKrUGu1bU+yggABEar1HPgR5uQyxFvBlDCyITiZsAUQIf0Krn/j3+ubLsKS5raqqWKAHPnZvrWEPgcpqOy1UU06zRQhd8qwOCMKwi6hsjZgSIGJTwEZ0nr9IqGO53Ae5I+Xy29Wt1fg==;5:ptaG2eflh7tP/V3dF/1JIJViimh6+3toyiea8xLrZnSYSY3Pm+1bTexAn6wnJGUVocc8zP6jfWasS+XgAdLKmFqURsP2UIiXbXXU1kbXu97f7GMFBqhyMSNm8vKclAgeiTsg8uvLDxqWQY+XGcNoMmMPSXqrJIiFvlhReEtNQ00=;7:jt200llSOJ8UodgFwXGwKSs2CWJows2GOcK4wLls8/u9w0cwcvcVmpWprVi0P9jXy7/Px05bx0AmmhRGrw1RWHKotZzLAp+RQmhuuVTnqazOw3Z+T9irJD2cPRXN7d6VvpokLmYfuMQbV1VOSlkG/Zm3AY5XZIHHRRplv1jwrXf9cyqKD1AToPG6mAQtMAabgevYamXLxnn96pN493+Gd+/5dL3FRRsgtOkfgO4ia3JFzvNoIeocMZfjcPluI1U4
x-ms-office365-filtering-correlation-id: 857cb886-d11b-4414-45f6-08d62489de1a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1388;
x-ms-traffictypediagnostic: BY1PR0601MB1388:
x-microsoft-antispam-prvs: <BY1PR0601MB1388EF97C31617A7776F0443BB140@BY1PR0601MB1388.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(93006095)(93001095)(3231355)(944501410)(52105095)(6055026)(149066)(150057)(6041310)(20161123558120)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123560045)(201708071742011)(7699051);SRVR:BY1PR0601MB1388;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1388;
x-forefront-prvs: 0808323E97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(39860400002)(376002)(366004)(346002)(189003)(199004)(22813001)(107886003)(5660300001)(25786009)(4326008)(6916009)(2351001)(68736007)(2900100001)(102836004)(6506007)(54906003)(386003)(53936002)(5024004)(2501003)(256004)(14444005)(5250100002)(105586002)(26005)(106356001)(186003)(316002)(5640700003)(97736004)(6512007)(6486002)(6436002)(446003)(11346002)(2616005)(2906002)(478600001)(72206003)(575784001)(86362001)(36756003)(14454004)(7736002)(3846002)(6116002)(476003)(486006)(66066001)(305945005)(71190400001)(99286004)(71200400001)(52116002)(8936002)(76176011)(34290500001)(81156014)(81166006)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1388;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: gRBdvoU9oExAhpsmgUnEzJRTsBFTEnBHVmsQ0nIP7GZ/X8UJjVmMeCH9qH/SAhuxOCWtvbdz5bb8bjAc7iyotQT4oEVIrgqiDorm+XtiNGrpDgRANRsVNf3pEMkBlSeQWqecsw6G1x02O1sfaK7Do7FL7FaDbCLj5x6b9z/gmX6ILZWR91ryK9t9SCZWM5iB84eek5oMFgfz9GX3qA2KbWsvgwr21DGZOOIVdha/Ual8BAoKVNfdLNQ9EXoo/X+DsQtj1CtoiIOW3YZtDiV8zNEAF1Xem7OLAMFVhvKf9wrzd8vcV8HvQqzYYgiDVSrWISw71Zc2r4jcKqj1nr8M5Xlob/eJsfvKpd0bobupncQ=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 857cb886-d11b-4414-45f6-08d62489de1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2018 14:59:49.3950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1388
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Chung-Hsien Hsu <stanley.hsu@cypress.com>

The driver sends an action frame down and waits for a completion signal
triggered by the received BRCMF_E_ACTION_FRAME_OFF_CHAN_COMPLETE event
to continue the process. However, the action frame could be transmitted
either on the current channel or on an off channel. For the on-channel
case, only BRCMF_E_ACTION_FRAME_COMPLETE event will be received when
the frame is transmitted, which make the driver always wait a full
timeout duration. This patch has the completion signal be triggered by
receiving the BRCMF_E_ACTION_FRAME_COMPLETE event for the on-channel
case.

This change fixes WFA p2p certification 5.1.19 failure.

Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 17 ++++++++++++++=
+--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.h |  2 ++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drive=
rs/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 7822740a8cb4..456a1bf008b3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -1457,10 +1457,12 @@ int brcmf_p2p_notify_action_tx_complete(struct brcm=
f_if *ifp,
 		return 0;
=20
 	if (e->event_code =3D=3D BRCMF_E_ACTION_FRAME_COMPLETE) {
-		if (e->status =3D=3D BRCMF_E_STATUS_SUCCESS)
+		if (e->status =3D=3D BRCMF_E_STATUS_SUCCESS) {
 			set_bit(BRCMF_P2P_STATUS_ACTION_TX_COMPLETED,
 				&p2p->status);
-		else {
+			if (!p2p->wait_for_offchan_complete)
+				complete(&p2p->send_af_done);
+		} else {
 			set_bit(BRCMF_P2P_STATUS_ACTION_TX_NOACK, &p2p->status);
 			/* If there is no ack, we don't need to wait for
 			 * WLC_E_ACTION_FRAME_OFFCHAN_COMPLETE event
@@ -1511,6 +1513,17 @@ static s32 brcmf_p2p_tx_action_frame(struct brcmf_p2=
p_info *p2p,
 	p2p->af_sent_channel =3D le32_to_cpu(af_params->channel);
 	p2p->af_tx_sent_jiffies =3D jiffies;
=20
+	if (test_bit(BRCMF_P2P_STATUS_DISCOVER_LISTEN, &p2p->status) &&
+	    p2p->af_sent_channel =3D=3D
+	    ieee80211_frequency_to_channel(p2p->remain_on_channel.center_freq))
+		p2p->wait_for_offchan_complete =3D false;
+	else
+		p2p->wait_for_offchan_complete =3D true;
+
+	brcmf_dbg(TRACE, "Waiting for %s tx completion event\n",
+		  (p2p->wait_for_offchan_complete) ?
+		   "off-channel" : "on-channel");
+
 	timeout =3D wait_for_completion_timeout(&p2p->send_af_done,
 					      P2P_AF_MAX_WAIT_TIME);
=20
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.h b/drive=
rs/net/wireless/broadcom/brcm80211/brcmfmac/p2p.h
index 0e8b34d2d85c..39f0d0218088 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.h
@@ -124,6 +124,7 @@ struct afx_hdl {
  * @gon_req_action: about to send go negotiation requets frame.
  * @block_gon_req_tx: drop tx go negotiation requets frame.
  * @p2pdev_dynamically: is p2p device if created by module param or suppli=
cant.
+ * @wait_for_offchan_complete: wait for off-channel tx completion event.
  */
 struct brcmf_p2p_info {
 	struct brcmf_cfg80211_info *cfg;
@@ -144,6 +145,7 @@ struct brcmf_p2p_info {
 	bool gon_req_action;
 	bool block_gon_req_tx;
 	bool p2pdev_dynamically;
+	bool wait_for_offchan_complete;
 };
=20
 s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg, bool p2pdev_forced);
--=20
2.1.0

