Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47249C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 05:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED24520819
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 05:52:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="eV5CA6oM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED24520819
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbeKEPKG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 10:10:06 -0500
Received: from mail-eopbgr820111.outbound.protection.outlook.com ([40.107.82.111]:46336
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728985AbeKEPKG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 10:10:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jo18AbLCjWEoOh8z8a9lwqIkJVaVYNXZeKa/4V+v7Gw=;
 b=eV5CA6oMGg5yWudxZSVGeyqJf4fLYtIyoTycyu81m0R3U1XOX+gtFZPih++0e8JK7O71hXF8MF0OtZGhy4Md9h7usZCcD/ZW3gWpNmdZeKWm4/lmM7qLRRJz5aagDQVYUEm5cNgezF+w9hKEDJ/m8w6z1HbBk6NJAdfabrA69x0=
Received: from BYAPR06MB3992.namprd06.prod.outlook.com (52.135.200.22) by
 BYAPR06MB4231.namprd06.prod.outlook.com (52.135.238.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.26; Mon, 5 Nov 2018 05:52:05 +0000
Received: from BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986]) by BYAPR06MB3992.namprd06.prod.outlook.com
 ([fe80::2147:2944:5ff:e986%3]) with mapi id 15.20.1294.032; Mon, 5 Nov 2018
 05:52:05 +0000
From:   Wright Feng <Wright.Feng@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Wright Feng <Wright.Feng@cypress.com>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        Stanley Hsu <Stanley.Hsu@cypress.com>
Subject: [PATCH v3 3/3] brcmfmac: handle compressed tx status signal
Thread-Topic: [PATCH v3 3/3] brcmfmac: handle compressed tx status signal
Thread-Index: AQHUdMuuFZyzWrRZE0KeXOeKGw3W5Q==
Date:   Mon, 5 Nov 2018 05:52:05 +0000
Message-ID: <20181105055137.13333-4-wright.feng@cypress.com>
References: <20181105055137.13333-1-wright.feng@cypress.com>
In-Reply-To: <20181105055137.13333-1-wright.feng@cypress.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: OSAPR01CA0164.jpnprd01.prod.outlook.com
 (2603:1096:604:d::32) To BYAPR06MB3992.namprd06.prod.outlook.com
 (2603:10b6:a02:90::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Wright.Feng@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [61.222.14.99]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR06MB4231;6:A5bS0Yzln+aRYrX+o9jX+dj0LQ3TxKw6jJc6A5WkpnL76TzOnK1D5z32XuxFQVGAeP4uxKT4lLkh7erTzV/+qx4q1QkqEJzNOeHONNbJXqMR6XW+UeNetvdme3grIP0ba1BQUj480zrO0GR4o0I6R7E2beZuCb9CbFyznZV3yC94PFzgb1cJMdXgtG0Dn3MTJdkP+lNAupitcC8Ba8FUMpH2i47ViAZzuLdSC5JkQVpJsi/mjg2VKizmH6Ii19c+GQL2w/KRTpbrqeEROrgN+7tNhwufuHCb3ydufAjmzs5TqI8ro/0ppDP6UF/wbSJJgiosRi2gMzLpJp+ewHrHnYVbD8zQ1FneffDQhDWh+Yy+WjZ24dM8wrQSv4mg66nX7ZG5aoUEoMRlHoGkIb0KOVXMGKODN0qIbQ/IxnPxUmaeJ9p5wfHIhUuxExTkV+ZpEBmn7wW96I87N3FwtcmH+Q==;5:/cD3qJdtMg/DSP75wrEUFBYCHjW4ghBs3LP6A0wnnkGiljIPioDqOUV1BcHEGKfnE+I59s7GvIrkww8GJzM1G473EA9lGqoclqOaaZNBzVGK8ewnV64SHj1Fu06/igIsyFm42IAY56VzBda5M460A9AY34xcdacENsOIQAy6fls=;7:i3ZhrHpxWqdGeXFnrVMZd/nVoctGdA7sLbu+ByUGz4Tpllm+/5/KuoQJctE9kli2lR0LSMlY7JsAHC9xGYCESSraIpq44U+9xWwq+KruDmH3lLtEIWR7naqB70LvieRN7EQOXC6QzzHXOSbZWTsiYQ==
x-ms-office365-filtering-correlation-id: 897b892d-fac7-42ff-f65d-08d642e2d0eb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BYAPR06MB4231;
x-ms-traffictypediagnostic: BYAPR06MB4231:
x-microsoft-antispam-prvs: <BYAPR06MB42315B185AFB7CAFC13A913FFBCA0@BYAPR06MB4231.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(10201501046)(3002001)(93006095)(93001095)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123564045)(20161123560045)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BYAPR06MB4231;BCL:0;PCL:0;RULEID:;SRVR:BYAPR06MB4231;
x-forefront-prvs: 08476BC6EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(136003)(346002)(39860400002)(366004)(199004)(189003)(107886003)(6116002)(3846002)(97736004)(99286004)(1076002)(4326008)(102836004)(71190400001)(71200400001)(76176011)(68736007)(6506007)(386003)(106356001)(36756003)(105586002)(2351001)(6436002)(5640700003)(5660300001)(2906002)(2900100001)(2501003)(53936002)(6486002)(6512007)(72206003)(478600001)(14454004)(6916009)(54906003)(186003)(52116002)(26005)(7736002)(316002)(476003)(11346002)(8936002)(81156014)(81166006)(305945005)(66066001)(256004)(2616005)(446003)(14444005)(25786009)(44832011)(486006)(8676002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR06MB4231;H:BYAPR06MB3992.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: q8LZX7VRPRPgFxqj0/HQq46QyPAn4oty+Ucz6pRFgspjTOnOLu+1TDiieBBtCkZgVa8NfEixQmdxn4Y18+VwgIJMXoKM+wiH/yP0vBEX+oagXcJjSaSLIpUvOGNn7zk3pXjmBpENf4vdL335lTA7N6JJ12L3qRrK2EOp3Qw/gPlbZ15MacaR1Q8T8t2TYVGPSbE48bbh8HuohdMHFhBtL9NMh7MpEt360swR9nhCJrfoGXNt1JFtk5NKl7+JFwk5LUJiHu7ZYeBPIIyy++InwCIC/KNMIgiwz+KNJPXLEYr+DmKtxs7pbvwUn5ymPv1MrMZk59BBA3Z5UcqL4SsLtNPwLh7kdurpcdzQTc5E2RM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 897b892d-fac7-42ff-f65d-08d642e2d0eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2018 05:52:05.8420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB4231
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
Signed-off-by: Wright Feng <wright.feng@cypress.com>
---
v3: Add this patch into this series
---
 .../broadcom/brcm80211/brcmfmac/fwsignal.c    | 121 ++++++++++--------
 1 file changed, 71 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index c75be2703b3e..02759ebd207c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -1455,9 +1455,10 @@ static int brcmf_fws_txstatus_suppressed(struct brcm=
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
@@ -1468,60 +1469,71 @@ brcmf_fws_txs_process(struct brcmf_fws_info *fws, u=
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
+		    (brcmf_skb_if_flags_get_field(skb, REQ_CREDIT)) ||
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
@@ -1547,7 +1559,8 @@ static int brcmf_fws_fifocreditback_indicate(struct b=
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
@@ -1556,23 +1569,31 @@ static int brcmf_fws_txstatus_indicate(struct brcmf=
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
@@ -1888,8 +1909,6 @@ void brcmf_fws_hdrpull(struct brcmf_if *ifp, s16 sigl=
en, struct sk_buff *skb)
=20
 		err =3D BRCMF_FWS_RET_OK_NOSCHEDULE;
 		switch (type) {
-		case BRCMF_FWS_TYPE_COMP_TXSTATUS:
-			break;
 		case BRCMF_FWS_TYPE_HOST_REORDER_RXPKTS:
 			rd =3D (struct brcmf_skb_reorder_data *)skb->cb;
 			rd->reorder =3D data;
@@ -1912,7 +1931,8 @@ void brcmf_fws_hdrpull(struct brcmf_if *ifp, s16 sigl=
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
@@ -2001,7 +2021,7 @@ static void brcmf_fws_rollback_toq(struct brcmf_fws_i=
nfo *fws,
 		fws->stats.rollback_failed++;
 		hslot =3D brcmf_skb_htod_tag_get_field(skb, HSLOT);
 		brcmf_fws_txs_process(fws, BRCMF_FWS_TXSTATUS_HOST_TOSSED,
-				      hslot, 0, 0);
+				      hslot, 0, 0, 1);
 	} else {
 		fws->stats.rollback_success++;
 		brcmf_fws_return_credits(fws, fifo, 1);
@@ -2462,7 +2482,8 @@ void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, =
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
2.19.1

