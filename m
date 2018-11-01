Return-Path: <SRS0=HAyh=NM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F914C0044C
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 08:26:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F37F62081B
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 08:26:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="s3ZC2lAx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F37F62081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbeKAR2m (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Nov 2018 13:28:42 -0400
Received: from mail-eopbgr690102.outbound.protection.outlook.com ([40.107.69.102]:4352
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727874AbeKAR2m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Nov 2018 13:28:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HB0QwNxHrJli7knTvhO3dT7yJOOsXZPjV5XcwDRRZWI=;
 b=s3ZC2lAx4bCyf76QRWiQS/3Ofapi772qWCekRywzjGMwv6WjZS0DBarQ5ORK9pgs8tcQl1QmBx+ifU8c0QLsdxLcXJmMhVQAGFbVcX9Pc/KPPblV1IEWbOxo/9t+ifZxmRZNt2nNgZrwALTEgCFIUv5IMzHOO+v7knX8+4cra88=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1317.namprd06.prod.outlook.com (10.161.206.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.26; Thu, 1 Nov 2018 08:26:36 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.023; Thu, 1 Nov 2018
 08:26:36 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanley Hsu <Stanley.Hsu@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH] brcmfmac: handle compressed tx status signal
Thread-Topic: [PATCH] brcmfmac: handle compressed tx status signal
Thread-Index: AQHUcbya2Nh/3UUziU2JKt9a9Mj1/g==
Date:   Thu, 1 Nov 2018 08:26:36 +0000
Message-ID: <1541060770-80533-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: MWHPR15CA0051.namprd15.prod.outlook.com
 (2603:10b6:301:4c::13) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1317;6:rirICAzwERz6PNdd1dSeQ1ixhdSFOHJX9K6U64GziwvGzGIxgWtczVKBOP+BeJi/6aHkAqDUiNJYYZsLXPupjaF2tvWH6GHUwX0Qs+ewzFqFdH95Fcb115Xwwnbv9iOeizw5mt+wfhPh+eHaarW2gpYwEmgkuH25+uTkVFZJ3xYEkCeZGk5sryv3kdUyA+aSBqOhi/BADO0N6vSjqwA372Gc74bRweKMVR2uTP54c/DNxR3FpEJL519/2IGeuHuOQmAAWUUP7F050Gsf6V1VqTKJJqC1mRi+m5Ccl1O5X/vLRQeygk06h0BJ9+jbPPGzGiTi6qSqlucd3pSu/SD/2d/S13zvNwFZIc9E1vBtvOSfz86BSpKZrWFVh8tKigH8Z84175f1rFqVE1Ikau3//8wkYX7B21zJWQnF54rUjGdrUOjGmLDayYFjpJaT/G88XqVv2w/TiKOEMv2lPn1+qg==;5:hHS0OCQdGQXofyLTbonWd8H0VMqvGDHpdH5jI4IY/M9ZLyOZU3McTqIUHotV6QSwkrUe3oRNj+y8vdIL/6d03W/9mOMXoklIA6t+DVYLREaNqqGHALw8viQyCOoAY7JUbET8wKk23ysxPWYJwTNoX0Kn+B7X5EKWO5IB6r5+kcc=;7:0TdKpzJ8Iyqqq0RTgza+TVU9SADLVY6lWTZKlAccZBIsvCqhYr48VAxuboSyWeCtSzqUWhoml6EZonpe01TOK8qfXqVgN6oKuI2DK9tFnTJLZ3sVwBxqzDFwRxFV7E6IhRYw03X9Eac8+JobVwwg0Q==
x-ms-office365-filtering-correlation-id: c9879702-762e-4954-dd71-08d63fd3bceb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1317;
x-ms-traffictypediagnostic: BY1PR0601MB1317:
x-microsoft-antispam-prvs: <BY1PR0601MB1317F789FA1EBA0E53D9023FBBCE0@BY1PR0601MB1317.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3231382)(944501410)(52105095)(93006095)(93001095)(3002001)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123564045)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1317;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1317;
x-forefront-prvs: 0843C17679
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(396003)(136003)(39860400002)(199004)(189003)(4326008)(107886003)(6512007)(53936002)(5640700003)(478600001)(36756003)(72206003)(25786009)(14454004)(86362001)(6436002)(106356001)(105586002)(6486002)(2351001)(2900100001)(66066001)(6916009)(26005)(102836004)(2501003)(52116002)(5250100002)(386003)(6116002)(3846002)(305945005)(8676002)(68736007)(97736004)(316002)(81166006)(81156014)(8936002)(7736002)(54906003)(2906002)(99286004)(486006)(71200400001)(14444005)(2616005)(5660300001)(256004)(71190400001)(476003)(186003)(6506007)(1857600001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1317;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 6ie2EcPjm4DhSzWpw8UV4JKkI2pCUKLJ3rHk1q+cdOzsQBW8dH0uAUpfTrMk+Vy3eIREdY0QbwNSwair9G83ubnHrwXZW2tfhjeWLVjdwGQ/pImdGUr8cBrCMuh0K6tvq8Mwry9AB+ETqv0JVZqcPCYvHBMDdoQxwYeyTi6baA6+rew6WJNhFMq1V56Rz4QZPinjQM7WooRpf87m9ZSd6qez03qGwqa4jex7IjH1UJ01pY6i2pAVxldCvbOrzrIeTFge3v5UwdV91oBvEhfD19fYrgfsdWsYRgarh25pFFIl0x7YWstgMkPED7s8VIDRvvQW/XqduLSZxdrN75miSNwmxfuD6j1oKh7JCP54buk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9879702-762e-4954-dd71-08d63fd3bceb
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2018 08:26:36.4931
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1317
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Chung-Hsien Hsu <stanley.hsu@cypress.com>

Firmware inform the driver about tx status by normal tx status signal
or compressed tx status signal. This patch adds support to handle the
compressed tx status signal.

Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         | 121 ++++++++++++-----=
----
 1 file changed, 71 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index f3cbf78c8899..33d8dcf257c0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -1451,9 +1451,10 @@ static int brcmf_fws_txstatus_suppressed(struct brcm=
f_fws_info *fws, int fifo,
=20
 static int
 brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
-		      u32 genbit, u16 seq)
+		      u32 genbit, u16 seq, u8 compcnt)
 {
 	u32 fifo;
+	u8 cnt =3D 0;
 	int ret;
 	bool remove_from_hanger =3D true;
 	struct sk_buff *skb;
@@ -1464,60 +1465,71 @@ brcmf_fws_txs_process(struct brcmf_fws_info *fws, u=
8 flags, u32 hslot,
 	brcmf_dbg(DATA, "flags %d\n", flags);
=20
 	if (flags =3D=3D BRCMF_FWS_TXSTATUS_DISCARD)
-		fws->stats.txs_discard++;
+		fws->stats.txs_discard +=3D compcnt;
 	else if (flags =3D=3D BRCMF_FWS_TXSTATUS_CORE_SUPPRESS) {
-		fws->stats.txs_supp_core++;
+		fws->stats.txs_supp_core +=3D compcnt;
 		remove_from_hanger =3D false;
 	} else if (flags =3D=3D BRCMF_FWS_TXSTATUS_FW_PS_SUPPRESS) {
-		fws->stats.txs_supp_ps++;
+		fws->stats.txs_supp_ps +=3D compcnt;
 		remove_from_hanger =3D false;
 	} else if (flags =3D=3D BRCMF_FWS_TXSTATUS_FW_TOSSED)
-		fws->stats.txs_tossed++;
+		fws->stats.txs_tossed +=3D compcnt;
 	else if (flags =3D=3D BRCMF_FWS_TXSTATUS_HOST_TOSSED)
-		fws->stats.txs_host_tossed++;
+		fws->stats.txs_host_tossed +=3D compcnt;
 	else
 		brcmf_err("unexpected txstatus\n");
=20
-	ret =3D brcmf_fws_hanger_poppkt(&fws->hanger, hslot, &skb,
-				      remove_from_hanger);
-	if (ret !=3D 0) {
-		brcmf_err("no packet in hanger slot: hslot=3D%d\n", hslot);
-		return ret;
-	}
+	while (cnt < compcnt) {
+		ret =3D brcmf_fws_hanger_poppkt(&fws->hanger, hslot, &skb,
+					      remove_from_hanger);
+		if (ret !=3D 0) {
+			brcmf_err("no packet in hanger slot: hslot=3D%d\n",
+				  hslot);
+			goto cont;
+		}
=20
-	skcb =3D brcmf_skbcb(skb);
-	entry =3D skcb->mac;
-	if (WARN_ON(!entry)) {
-		brcmu_pkt_buf_free_skb(skb);
-		return -EINVAL;
-	}
-	entry->transit_count--;
-	if (entry->suppressed && entry->suppr_transit_count)
-		entry->suppr_transit_count--;
+		skcb =3D brcmf_skbcb(skb);
+		entry =3D skcb->mac;
+		if (WARN_ON(!entry)) {
+			brcmu_pkt_buf_free_skb(skb);
+			goto cont;
+		}
+		entry->transit_count--;
+		if (entry->suppressed && entry->suppr_transit_count)
+			entry->suppr_transit_count--;
=20
-	brcmf_dbg(DATA, "%s flags %d htod %X seq %X\n", entry->name, flags,
-		  skcb->htod, seq);
+		brcmf_dbg(DATA, "%s flags %d htod %X seq %X\n", entry->name,
+			  flags, skcb->htod, seq);
=20
-	/* pick up the implicit credit from this packet */
-	fifo =3D brcmf_skb_htod_tag_get_field(skb, FIFO);
-	if ((fws->fcmode =3D=3D BRCMF_FWS_FCMODE_IMPLIED_CREDIT) ||
-	    (brcmf_skb_if_flags_get_field(skb, REQ_CREDIT)) ||
-	    (flags =3D=3D BRCMF_FWS_TXSTATUS_HOST_TOSSED)) {
-		brcmf_fws_return_credits(fws, fifo, 1);
-		brcmf_fws_schedule_deq(fws);
-	}
-	brcmf_fws_macdesc_return_req_credit(skb);
+		/* pick up the implicit credit from this packet */
+		fifo =3D brcmf_skb_htod_tag_get_field(skb, FIFO);
+		if (fws->fcmode =3D=3D BRCMF_FWS_FCMODE_IMPLIED_CREDIT ||
+		    brcmf_skb_if_flags_get_field(skb, REQ_CREDIT) ||
+		    flags =3D=3D BRCMF_FWS_TXSTATUS_HOST_TOSSED) {
+			brcmf_fws_return_credits(fws, fifo, 1);
+			brcmf_fws_schedule_deq(fws);
+		}
+		brcmf_fws_macdesc_return_req_credit(skb);
=20
-	ret =3D brcmf_proto_hdrpull(fws->drvr, false, skb, &ifp);
-	if (ret) {
-		brcmu_pkt_buf_free_skb(skb);
-		return -EINVAL;
+		ret =3D brcmf_proto_hdrpull(fws->drvr, false, skb, &ifp);
+		if (ret) {
+			brcmu_pkt_buf_free_skb(skb);
+			goto cont;
+		}
+		if (!remove_from_hanger)
+			ret =3D brcmf_fws_txstatus_suppressed(fws, fifo, skb,
+							    genbit, seq);
+		if (remove_from_hanger || ret)
+			brcmf_txfinalize(ifp, skb, true);
+
+cont:
+		hslot =3D (hslot + 1) & (BRCMF_FWS_TXSTAT_HSLOT_MASK >>
+				       BRCMF_FWS_TXSTAT_HSLOT_SHIFT);
+		if (BRCMF_FWS_MODE_GET_REUSESEQ(fws->mode))
+			seq =3D (seq + 1) & BRCMF_SKB_HTOD_SEQ_NR_MASK;
+
+		cnt++;
 	}
-	if (!remove_from_hanger)
-		ret =3D brcmf_fws_txstatus_suppressed(fws, fifo, skb,
-						    genbit, seq);
-	if (remove_from_hanger || ret)
-		brcmf_txfinalize(ifp, skb, true);
=20
 	return 0;
 }
@@ -1543,7 +1555,8 @@ static int brcmf_fws_fifocreditback_indicate(struct b=
rcmf_fws_info *fws,
 	return BRCMF_FWS_RET_OK_SCHEDULE;
 }
=20
-static int brcmf_fws_txstatus_indicate(struct brcmf_fws_info *fws, u8 *dat=
a)
+static int brcmf_fws_txstatus_indicate(struct brcmf_fws_info *fws, u8 type=
,
+				       u8 *data)
 {
 	__le32 status_le;
 	__le16 seq_le;
@@ -1552,23 +1565,31 @@ static int brcmf_fws_txstatus_indicate(struct brcmf=
_fws_info *fws, u8 *data)
 	u32 genbit;
 	u8 flags;
 	u16 seq;
+	u8 compcnt;
+	u8 compcnt_offset =3D BRCMF_FWS_TYPE_TXSTATUS_LEN;
=20
-	fws->stats.txs_indicate++;
 	memcpy(&status_le, data, sizeof(status_le));
 	status =3D le32_to_cpu(status_le);
 	flags =3D brcmf_txstatus_get_field(status, FLAGS);
 	hslot =3D brcmf_txstatus_get_field(status, HSLOT);
 	genbit =3D brcmf_txstatus_get_field(status, GENERATION);
 	if (BRCMF_FWS_MODE_GET_REUSESEQ(fws->mode)) {
-		memcpy(&seq_le, &data[BRCMF_FWS_TYPE_PKTTAG_LEN],
+		memcpy(&seq_le, &data[BRCMF_FWS_TYPE_TXSTATUS_LEN],
 		       sizeof(seq_le));
 		seq =3D le16_to_cpu(seq_le);
+		compcnt_offset +=3D BRCMF_FWS_TYPE_SEQ_LEN;
 	} else {
 		seq =3D 0;
 	}
=20
+	if (type =3D=3D BRCMF_FWS_TYPE_COMP_TXSTATUS)
+		compcnt =3D data[compcnt_offset];
+	else
+		compcnt =3D 1;
+	fws->stats.txs_indicate +=3D compcnt;
+
 	brcmf_fws_lock(fws);
-	brcmf_fws_txs_process(fws, flags, hslot, genbit, seq);
+	brcmf_fws_txs_process(fws, flags, hslot, genbit, seq, compcnt);
 	brcmf_fws_unlock(fws);
 	return BRCMF_FWS_RET_OK_NOSCHEDULE;
 }
@@ -1882,8 +1903,6 @@ void brcmf_fws_hdrpull(struct brcmf_if *ifp, s16 sigl=
en, struct sk_buff *skb)
=20
 		err =3D BRCMF_FWS_RET_OK_NOSCHEDULE;
 		switch (type) {
-		case BRCMF_FWS_TYPE_COMP_TXSTATUS:
-			break;
 		case BRCMF_FWS_TYPE_HOST_REORDER_RXPKTS:
 			rd =3D (struct brcmf_skb_reorder_data *)skb->cb;
 			rd->reorder =3D data;
@@ -1906,7 +1925,8 @@ void brcmf_fws_hdrpull(struct brcmf_if *ifp, s16 sigl=
en, struct sk_buff *skb)
 			err =3D brcmf_fws_request_indicate(fws, type, data);
 			break;
 		case BRCMF_FWS_TYPE_TXSTATUS:
-			brcmf_fws_txstatus_indicate(fws, data);
+		case BRCMF_FWS_TYPE_COMP_TXSTATUS:
+			brcmf_fws_txstatus_indicate(fws, type, data);
 			break;
 		case BRCMF_FWS_TYPE_FIFO_CREDITBACK:
 			err =3D brcmf_fws_fifocreditback_indicate(fws, data);
@@ -1995,7 +2015,7 @@ static void brcmf_fws_rollback_toq(struct brcmf_fws_i=
nfo *fws,
 		fws->stats.rollback_failed++;
 		hslot =3D brcmf_skb_htod_tag_get_field(skb, HSLOT);
 		brcmf_fws_txs_process(fws, BRCMF_FWS_TXSTATUS_HOST_TOSSED,
-				      hslot, 0, 0);
+				      hslot, 0, 0, 1);
 	} else {
 		fws->stats.rollback_success++;
 		brcmf_fws_return_credits(fws, fifo, 1);
@@ -2455,7 +2475,8 @@ void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, =
struct sk_buff *skb)
 	}
 	brcmf_fws_lock(fws);
 	hslot =3D brcmf_skb_htod_tag_get_field(skb, HSLOT);
-	brcmf_fws_txs_process(fws, BRCMF_FWS_TXSTATUS_HOST_TOSSED, hslot, 0, 0);
+	brcmf_fws_txs_process(fws, BRCMF_FWS_TXSTATUS_HOST_TOSSED, hslot, 0, 0,
+			      1);
 	brcmf_fws_unlock(fws);
 }
=20
--=20
2.1.0

