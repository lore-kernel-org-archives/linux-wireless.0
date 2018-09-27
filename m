Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E000DC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 814FB21546
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:45:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="wyRUaaDZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 814FB21546
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbeI0QDQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 12:03:16 -0400
Received: from mail-by2nam03on0103.outbound.protection.outlook.com ([104.47.42.103]:11780
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726931AbeI0QDQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 12:03:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UhdBa6U4bqo5XVQ38GjL88uffJ5IeKBtyFLtk3lcCIY=;
 b=wyRUaaDZzATbPGRCBW2mhAqyEf6UXXLRlWpGn9aPd51dwjbZG2jO25d0UyR5g29LAeRL4rkzMpTOMJvOtiQBvhvKemlkgLMwBqax/wlqjQBrfI/G8T3nUD5b6bpTguYEYJBXfAq2Vkj0t9ELjkrlmhPhXbE4qFd/KhTumvWRoXQ=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1110.namprd06.prod.outlook.com (10.160.196.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1164.20; Thu, 27 Sep 2018 09:44:29 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::ad59:f71e:ebcb:70ac]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::ad59:f71e:ebcb:70ac%5]) with mapi id 15.20.1164.024; Thu, 27 Sep 2018
 09:44:28 +0000
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
Subject: [PATCH 2/2] brcmfmac: fix full timeout waiting for action frame
 on-channel tx
Thread-Topic: [PATCH 2/2] brcmfmac: fix full timeout waiting for action frame
 on-channel tx
Thread-Index: AQHUVkavNklCf7PtyEiLcOia8gF9Ow==
Date:   Thu, 27 Sep 2018 09:44:28 +0000
Message-ID: <1538041427-115758-3-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1110;6:A9ZVc8eqrFQoS0wh1gk0yN4VmHW75+KDOM+Kv8NU2nnmOeXgdMmNjCIj6Xca7Rd+2R9MP/Skyp5jvDnbSSJqfu/YHj5UoTHpzi7KJXU1cRBtm337OVzR82U9Czbxkl97BzzHBKbvHCh2nxHaJxVhAwvXyW8wzS67HYhrgExvEuLANZ793LSbspJ6+Fxft/fwK+7tq1o9tGge5CQQjsVWzLRo2cCLEnFUNSqGuyDPkObsiiWBjk8fiPx8Ix39+7dtokusFyy3paJjirwGSbw7m9JqvbQvsooz2QbytLpbb6HPkb7+rlcReUC+1VmhmdpsTRXu4QH9FtkSxj3rWdmYUoB3PzDV3TApi5q+2Sku8eYc2Nrah1x7E4SF2IFNbpXYrGnQfjkYXGPx8MpLfRq0swXgnZjOvrdwYYhBNbzFC9qZBinbW9Vz9GzW+xXncsOzki9QRnHB70OP7/Z2O2tUPA==;5:dVBvBh9wlzEoVeqLii0t8m/U3nxu11ow/LvM9wsazpt1sS3nRLeP2c5L1CsoFzaAaksyST4CeIZXjDRfIG0ZWHSe73PQVvWLs4fwRxoLYTlHcFoCWk77Yz1+9UI76/i1L10005nRii7r/m0CLV73fK7uqm0WmPfzr3RvQ/GVdqU=;7:6Iz4jJdVHQ55Pb2OBjyJDxs0adwhd4jDYWoTg5RBHwHCZc+7jgLAelIGw1PoGj/bdSOkbkGfDP87TAPtrmN8bamu7PmgNPObJkrAymTnm8hbltqWuKny85hdAAGaCjgQZCKOgA0FZTCfagSm+lRNvaY3gS+5Qm1DtMqmPA3CUIym9/Eed055K8hmjogxnDNGkvuB81R3XPEE4SfY0p1sYl7/HSQe94QadybyB803WP59obIXpKELPJP/LOgWVqXq
x-ms-office365-filtering-correlation-id: e92667f8-9154-4bb1-2054-08d6245dd15f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1110;
x-ms-traffictypediagnostic: BY1PR0601MB1110:
x-microsoft-antispam-prvs: <BY1PR0601MB1110E1B89098E1A6EC6B2081BB140@BY1PR0601MB1110.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(10201501046)(3002001)(93006095)(93001095)(3231355)(944501410)(52105095)(6055026)(149066)(150057)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123558120)(201708071742011)(7699051);SRVR:BY1PR0601MB1110;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1110;
x-forefront-prvs: 0808323E97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(39860400002)(376002)(396003)(366004)(22813001)(199004)(189003)(8676002)(256004)(76176011)(54906003)(66066001)(4326008)(6436002)(2900100001)(2906002)(53936002)(5640700003)(3846002)(71200400001)(107886003)(575784001)(6506007)(52116002)(386003)(102836004)(6512007)(5250100002)(97736004)(71190400001)(68736007)(6116002)(36756003)(14444005)(81156014)(99286004)(5024004)(486006)(316002)(81166006)(25786009)(186003)(26005)(86362001)(6486002)(305945005)(6916009)(7736002)(478600001)(5660300001)(105586002)(2351001)(106356001)(72206003)(11346002)(8936002)(2616005)(14454004)(446003)(34290500001)(2501003)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1110;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: qF/JWBozVZX1N/lVT1VlXA1uDIf4NqDTxhylslMfQgXZ7TqDIj3v773oHj9hBpfQ/+je8LCOeaNM7Sf3tiMQ72q8vdlXTZIYkFQCzVwavk3YZYbQJ20rddUuJetBtr2Q67ee5gznk2DQEqQ4z/FwdlxaPN9UvveextxSxYkA1bVspinLuHA/rOUaOK2XRA7ikTSlKfWE39+fC+x6V3sEL2OVEvJUoerRQ+V1Efl+yQvukdyLCX7WtU8LkPEQW6bi1cg225AgZb4jQAoOnAl228JtNa04HwDNJjFPuV7bZofqe38tiTZi8BmF1C80bskKACC2jDOGYX76DHEKVwp3GljQ1ZpdQf+IHDbqMT6Z8BA=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e92667f8-9154-4bb1-2054-08d6245dd15f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2018 09:44:28.8828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1110
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

