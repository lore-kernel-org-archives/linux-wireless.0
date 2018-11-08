Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870DFC32789
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 03:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44EB420684
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 03:48:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="b1YuO08B"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44EB420684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbeKHNV4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 08:21:56 -0500
Received: from mail-eopbgr700128.outbound.protection.outlook.com ([40.107.70.128]:28160
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728621AbeKHNV4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 08:21:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nGfy/RHN+eTqgGOQnCKVx9UjPpN/xpv0l8g4XVwPGkI=;
 b=b1YuO08B7DbxrTf9Rp/Gzi5iW1diKbnf60CN9wkQnpShrIBKcyMXRTK+VQ8eJtVDiqGIkW4oYuspRpowjeSO40NC77Y5HxpDWS8EUBBIqMTyawo+zMREaADPKwaw3jt6dH1hoRq5yMWiXRMV7mG8JWmpIF45ryLeo5Lr13NrBvA=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1387.namprd06.prod.outlook.com (10.162.111.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.28; Thu, 8 Nov 2018 03:48:12 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.034; Thu, 8 Nov 2018
 03:48:12 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ryohei Kondo <Ryohei.Kondo@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH 5/5] brcmfmac: add vendor ie for association responses
Thread-Topic: [PATCH 5/5] brcmfmac: add vendor ie for association responses
Thread-Index: AQHUdxXedRJ/h2Hgzkac5itXjkj7Lg==
Date:   Thu, 8 Nov 2018 03:48:11 +0000
Message-ID: <1541648845-194984-6-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1387;6:80SirHeRqWo+8k9EL5okKXCJtxFlZ2pGnCRWt9yEklW3bwb92hLtIXaovG8IDHn9ArbTKzDo5lyNqGsoY3Ofgyf/hoKht1aUtLIpQ9phikOtUHWhPIw850xwbodXuhWLvuItGXAa2AxgPU1IJDGiZoAv8ArnUujW1FT75lslCT0Id3KjmPT7ieA8inNG+AcuEhce8897dVwBYNMmMuGMWwfAJISDyCx3AIYUfUzDcrnJlbPOPumkCk8eGcUQEW6/lvJTGSlxqdMO188Ao2McqeTkVFpCOEA/TQDYICutKvmfXdRvdkTqKrojj5qiS4i9Np2o4Ph3/7Q8OEaI88imyZYemHORvvcmmS+XHKtrq80qtEgDDZvhSYy6Q+dD7aSj/nGsXPF19jFMrFEV1FvFPgEGn7tazwTZd7I1H63eqbx35Zvs9nEDX+m4uIiF3yf+GGSsd/+f+M3IrzxiZBKWtA==;5:xKdU6eJRfDCdZTwLHYWJhK5w07amOr3ZiqOrkMcUV1Z8rbI5e4n8uX+gVQnejgz5F1gh0wsWK4856mzn7MIT/O5Nq2+DyDj1RCXs78s0ZBIv2WbmVYlVM+2tqlqGMphdvSNF2TSEPi9IjtSo423Em6TbZwZPXa79dqY7yLyeoBk=;7:WoJDRdUeGau+WPEvEdvyvWNRYdMQc/G/8FZLUqrRsMooI9gkqUqSYUc3Qdf2dgQJNMeX3ph1AKmcYafNvDybbYEImTxRP1qK+JzLd8QX+eW11MsSOCyk6DbmX4TWQy5jmkRbf/u6IifQawCGdtIpQQ==
x-ms-office365-filtering-correlation-id: 6e691bf5-6b84-46ed-618f-08d6452d0119
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1387;
x-ms-traffictypediagnostic: BY1PR0601MB1387:
x-microsoft-antispam-prvs: <BY1PR0601MB1387C06A589C14EE2BBA11D5BBC50@BY1PR0601MB1387.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1387;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1387;
x-forefront-prvs: 0850800A29
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(136003)(396003)(376002)(39860400002)(199004)(189003)(68736007)(6116002)(3846002)(256004)(6916009)(316002)(72206003)(66066001)(7736002)(305945005)(71200400001)(14444005)(71190400001)(2351001)(186003)(2616005)(36756003)(476003)(105586002)(446003)(11346002)(26005)(97736004)(486006)(106356001)(386003)(81156014)(76176011)(81166006)(4326008)(6436002)(2906002)(25786009)(6506007)(52116002)(8936002)(53936002)(102836004)(6512007)(14454004)(478600001)(99286004)(5660300001)(54906003)(8676002)(107886003)(6486002)(5640700003)(2501003)(2900100001)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1387;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: dN7LZL8FLM/cQJAz2p/Qjduc2FmaZTctbb9NjpmNdcDKiBaSQ3v1bstZbQDNdwdlE++9LpD9dqoHhZuPWqbfId3Jl2gjHH1arS+IlBy73r7v+Vx78axFXcULcIDMCnYsRh+PsBin8XO7msENrvlBLB3FQQY62gzkI39t2Kc0oTx5V4aBGrbt300MPJcMladNZ5QcV/gXtl5Sj16PIAe/h4rJ9YtnVKri6ItCwbwFdt+NIpcVltWPWVILOTtIYLGNopJKE5B4CKn3NY2tFmkYkhZcJTUOwKxq7jO3YTTbYaQk+sgm7h7JuLI/kRMpny0MTbEDW/wwPw6umU9NGqxr0XiXG12p5CQ9VHUuTTqitIY=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e691bf5-6b84-46ed-618f-08d6452d0119
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2018 03:48:12.0544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1387
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ryohei Kondo <ryohei.kondo@cypress.com>

Miracast Certification clause 6.1.2 may fail if there is no WFD IE in
p2p assoc response. This change allows WFD IE to be added to p2p assoc
response.

Related WFA certification:
6.1.2 P-SnUT operating as a Group Owner accepts a WFD Session with a
Reference Source

Signed-off-by: Ryohei Kondo <ryohei.kondo@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 14 ++++++++++=
++++
 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h    |  4 ++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 165ab1a3f943..8cb02befcf81 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -4237,6 +4237,11 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif =
*vif, s32 pktflag,
 		mgmt_ie_len =3D &saved_ie->assoc_req_ie_len;
 		mgmt_ie_buf_len =3D sizeof(saved_ie->assoc_req_ie);
 		break;
+	case BRCMF_VNDR_IE_ASSOCRSP_FLAG:
+		mgmt_ie_buf =3D saved_ie->assoc_res_ie;
+		mgmt_ie_len =3D &saved_ie->assoc_res_ie_len;
+		mgmt_ie_buf_len =3D sizeof(saved_ie->assoc_res_ie);
+		break;
 	default:
 		err =3D -EPERM;
 		brcmf_err("not suitable type\n");
@@ -4386,6 +4391,15 @@ brcmf_config_ap_mgmt_ie(struct brcmf_cfg80211_vif *v=
if,
 	else
 		brcmf_dbg(TRACE, "Applied Vndr IEs for Probe Resp\n");
=20
+	/* Set Assoc Response IEs to FW */
+	err =3D brcmf_vif_set_mgmt_ie(vif, BRCMF_VNDR_IE_ASSOCRSP_FLAG,
+				    beacon->assocresp_ies,
+				    beacon->assocresp_ies_len);
+	if (err)
+		brcmf_err("Set Assoc Resp IE Failed\n");
+	else
+		brcmf_dbg(TRACE, "Applied Vndr IEs for Assoc Resp\n");
+
 	return err;
 }
=20
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index a4aec0004e4f..6a2a3b276cda 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -162,19 +162,23 @@ enum brcmf_vif_status {
  * @probe_req_ie: IE info for probe request.
  * @probe_res_ie: IE info for probe response.
  * @beacon_ie: IE info for beacon frame.
+ * @assoc_res_ie: IE info for association response frame.
  * @probe_req_ie_len: IE info length for probe request.
  * @probe_res_ie_len: IE info length for probe response.
  * @beacon_ie_len: IE info length for beacon frame.
+ * @assoc_res_ie_len: IE info length for association response frame.
  */
 struct vif_saved_ie {
 	u8  probe_req_ie[IE_MAX_LEN];
 	u8  probe_res_ie[IE_MAX_LEN];
 	u8  beacon_ie[IE_MAX_LEN];
 	u8  assoc_req_ie[IE_MAX_LEN];
+	u8  assoc_res_ie[IE_MAX_LEN];
 	u32 probe_req_ie_len;
 	u32 probe_res_ie_len;
 	u32 beacon_ie_len;
 	u32 assoc_req_ie_len;
+	u32 assoc_res_ie_len;
 };
=20
 /**
--=20
2.1.0

