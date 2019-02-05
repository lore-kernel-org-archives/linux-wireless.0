Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BA4C282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 09:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D18842073D
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 09:50:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="wCvMiXT5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfBEJuJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 04:50:09 -0500
Received: from mail-eopbgr690086.outbound.protection.outlook.com ([40.107.69.86]:27968
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725893AbfBEJuJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 04:50:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSebRMln27rcS0smQvMdCY2ilGDk2Q1rQL+dfGEZ/00=;
 b=wCvMiXT5xYaPvL9/jRzWD/9IdQogUb1HYJG0Q6bRtTCECEEW6gK4iA8I3jxa4b1TnmS27bboHD8vb4QJ9N6NFFBuInAvhE74r0ZSWDx+CKYZ0AGSgs/B4RQMX9rD/frWZwyQ3HQjdhcAlEh/Q+gCcfBqIHbTt9slRt0VvPkF9Qs=
Received: from DM6PR05MB4620.namprd05.prod.outlook.com (20.176.109.153) by
 DM6PR05MB4266.namprd05.prod.outlook.com (20.176.78.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.14; Tue, 5 Feb 2019 09:49:17 +0000
Received: from DM6PR05MB4620.namprd05.prod.outlook.com
 ([fe80::dc24:2038:a5ca:2dab]) by DM6PR05MB4620.namprd05.prod.outlook.com
 ([fe80::dc24:2038:a5ca:2dab%4]) with mapi id 15.20.1601.016; Tue, 5 Feb 2019
 09:49:17 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5616.namprd05.prod.outlook.com (52.135.111.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.16; Tue, 5 Feb 2019 09:48:55 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::e8c2:9d66:4fd2:b620]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::e8c2:9d66:4fd2:b620%4]) with mapi id 15.20.1601.016; Tue, 5 Feb 2019
 09:48:55 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 1/2] qtnfmac: enable WPA3 OWE support
Thread-Topic: [PATCH 1/2] qtnfmac: enable WPA3 OWE support
Thread-Index: AQHUvTgCr9cld7okt0uFpuc973ANlg==
Date:   Tue, 5 Feb 2019 09:48:55 +0000
Message-ID: <20190205094842.31568-2-sergey.matyukevich.os@quantenna.com>
References: <20190205094842.31568-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190205094842.31568-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0056.namprd07.prod.outlook.com
 (2603:10b6:a03:60::33) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.11.0
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR05MB4266;6:W09NH+k7C6L2rCKli7MB5Erz8+wgVw1mRnwBqt9JzgwPYF4dgSEahSk+Elqkxe5dkZvjcxpRFVNfUP1NMTX3yXO57GVp+ZpTwgRE0i7YmVD9FRU1kXSN8qXMEbMR6CG7oJMls5am7Kns381skRFmqViDdp6apze8n9sGID7Oy1oQ+OzO8Lj5T4ftZljxOjMTW/lYd2JT1cwqM1qUq7qfh/umtnFsOSs/xYm4bljcUEib9zuEABWXJRiJs2IfOuFSgr0cipYIwMcaSkpQ75ThSd2EaBW2NbjWyYgYoTCyrgyWRgIqN/se1oln8E0hrNK5Xjp0cIxjK4WVaI6nxh3cqmtyOUr7grsKMIhfzTgRWNDOlaeE8JWlvLpEt+0mTz9P4g6LeFtV99rG8wIefTOp/lgysGhW4Z25iRCQzmE5mF31WA3CQGM7/0U+9n/OJxc0v5y0Oz+AMPeCtyKe88SdAQ==;5:pibQ9BhuyHysivvQn6+XKMNHfFwHF09BZezcJGFN4IFwlyHYXrqIW3s6pW6LwMh4A/67SaD+DePUIT/gmmbeAugwclUaVHPQxKnNGJqG8QiHPgDdb4oglzn5b8UJogGag7rAp029rk6caouZzGUuhFoml0cpTjI2UEMb9Hjiph9gyPqQi4Pwy1xSJtfMOSIls36Za2kw80t6Yjq7LJxpqQ==;7:ucRK36cha4PJa5wGMW8YLmeBwOKGnrCQk59aAdNx2ggdsTFVz/0AIFACv8R/gQ9SKXkM1VfFWBavWrUuQi1Y/2vYCgs4KDYerAC8kb1nwtNjG0YudJCdSklQI4feD9ruil+LZgTAe0cq3BhxjWKewQ==
x-ms-office365-filtering-correlation-id: c19c08eb-0c1e-4805-8aab-08d68b4f246d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5616;
x-ms-traffictypediagnostic: SN6PR05MB5616:|DM6PR05MB4266:
x-moderation-data: 2/5/2019 9:49:14 AM
x-microsoft-antispam-prvs: <DM6PR05MB42665421B56EBE7F52E6C26FA36E0@DM6PR05MB4266.namprd05.prod.outlook.com>
x-forefront-prvs: 0939529DE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(366004)(136003)(39840400004)(376002)(189003)(199004)(7736002)(8936002)(81166006)(68736007)(8676002)(71200400001)(81156014)(14454004)(478600001)(305945005)(6916009)(436003)(50226002)(36756003)(53936002)(6436002)(3846002)(316002)(26005)(486006)(6116002)(386003)(6506007)(11346002)(446003)(102836004)(106356001)(86362001)(2616005)(256004)(2351001)(2906002)(14444005)(105586002)(52116002)(99286004)(76176011)(186003)(25786009)(1076003)(66066001)(103116003)(5640700003)(97736004)(6486002)(6512007)(54906003)(107886003)(71190400001)(2501003)(476003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB4266;H:DM6PR05MB4620.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /P33ZMyYsWDBHGP6IqAUGmQDhkL6C8luH6AivWjvm/g2XP9s6HSIoc9TC/VmGSTAw2gKFSc90LrgkBxltIk+shgnEaJnBQsvl59VLukUMNGeeev/9+cyVfdQu3ZkXURXViq6HYbLKhwoQ/X1f6t4DDgVDif25suymQKbZRJoNBhBrifWI/3A9NVRpq+xXS6nOEitU7etX9KhvZG8PY00bAdkuzL+S+tNZHhhf4iFHk5kWSn7V/ebUDuEtb9+MGp3ISifwMXzW4URTmrPEOPNr6HVJUO6ESBCiOSJRMUQjUYYAFPc2wk75HAQYp+BqEXISAQkyunBmYo+flWqgQh52c9Q070dkDipN0rDuXootfTgYhJHWeDOnggtaN4znn3Jz0WefhgO5dos2Dgh+vj+sEGPYGPudZ/UZSoTpRwzQZk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c19c08eb-0c1e-4805-8aab-08d68b4f246d
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2019 09:49:17.4751
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB4266
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In the case of OWE, STA should be able to pass DH IEs from AP assoc
responses to wpa_s for processing. For this purpose DH IEs are
received from firmware in BSS_JOIN events and passed to wireless
core and then to wpa_s as additional optional rsp_ies parameter
for cfg80211_connect_result.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/event.c | 144 +++++++++++++++++----=
----
 drivers/net/wireless/quantenna/qtnfmac/qlink.h |   1 +
 2 files changed, 102 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/w=
ireless/quantenna/qtnfmac/event.c
index 3fd1a9217737..944729b74f17 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -150,6 +150,13 @@ qtnf_event_handle_bss_join(struct qtnf_vif *vif,
 	struct cfg80211_chan_def chandef;
 	struct cfg80211_bss *bss =3D NULL;
 	u8 *ie =3D NULL;
+	size_t payload_len;
+	u16 tlv_type;
+	u16 tlv_value_len;
+	size_t tlv_full_len;
+	const struct qlink_tlv_hdr *tlv;
+	const u8 *rsp_ies =3D NULL;
+	size_t rsp_ies_len =3D 0;
=20
 	if (unlikely(len < sizeof(*join_info))) {
 		pr_err("VIF%u.%u: payload is too short (%u < %zu)\n",
@@ -167,67 +174,118 @@ qtnf_event_handle_bss_join(struct qtnf_vif *vif,
 	pr_debug("VIF%u.%u: BSSID:%pM status:%u\n",
 		 vif->mac->macid, vif->vifid, join_info->bssid, status);
=20
-	if (status =3D=3D WLAN_STATUS_SUCCESS) {
-		qlink_chandef_q2cfg(wiphy, &join_info->chan, &chandef);
-		if (!cfg80211_chandef_valid(&chandef)) {
-			pr_warn("MAC%u.%u: bad channel freq=3D%u cf1=3D%u cf2=3D%u bw=3D%u\n",
+	if (status !=3D WLAN_STATUS_SUCCESS)
+		goto done;
+
+	qlink_chandef_q2cfg(wiphy, &join_info->chan, &chandef);
+	if (!cfg80211_chandef_valid(&chandef)) {
+		pr_warn("MAC%u.%u: bad channel freq=3D%u cf1=3D%u cf2=3D%u bw=3D%u\n",
+			vif->mac->macid, vif->vifid,
+			chandef.chan->center_freq,
+			chandef.center_freq1,
+			chandef.center_freq2,
+			chandef.width);
+		status =3D WLAN_STATUS_UNSPECIFIED_FAILURE;
+		goto done;
+	}
+
+	bss =3D cfg80211_get_bss(wiphy, chandef.chan, join_info->bssid,
+			       NULL, 0, IEEE80211_BSS_TYPE_ESS,
+			       IEEE80211_PRIVACY_ANY);
+	if (!bss) {
+		pr_warn("VIF%u.%u: add missing BSS:%pM chan:%u\n",
+			vif->mac->macid, vif->vifid,
+			join_info->bssid, chandef.chan->hw_value);
+
+		if (!vif->wdev.ssid_len) {
+			pr_warn("VIF%u.%u: SSID unknown for BSS:%pM\n",
+				vif->mac->macid, vif->vifid,
+				join_info->bssid);
+			status =3D WLAN_STATUS_UNSPECIFIED_FAILURE;
+			goto done;
+		}
+
+		ie =3D kzalloc(2 + vif->wdev.ssid_len, GFP_KERNEL);
+		if (!ie) {
+			pr_warn("VIF%u.%u: IE alloc failed for BSS:%pM\n",
 				vif->mac->macid, vif->vifid,
-				chandef.chan->center_freq,
-				chandef.center_freq1,
-				chandef.center_freq2,
-				chandef.width);
+				join_info->bssid);
 			status =3D WLAN_STATUS_UNSPECIFIED_FAILURE;
 			goto done;
 		}
=20
-		bss =3D cfg80211_get_bss(wiphy, chandef.chan, join_info->bssid,
-				       NULL, 0, IEEE80211_BSS_TYPE_ESS,
-				       IEEE80211_PRIVACY_ANY);
+		ie[0] =3D WLAN_EID_SSID;
+		ie[1] =3D vif->wdev.ssid_len;
+		memcpy(ie + 2, vif->wdev.ssid, vif->wdev.ssid_len);
+
+		bss =3D cfg80211_inform_bss(wiphy, chandef.chan,
+					  CFG80211_BSS_FTYPE_UNKNOWN,
+					  join_info->bssid, 0,
+					  WLAN_CAPABILITY_ESS, 100,
+					  ie, 2 + vif->wdev.ssid_len,
+					  0, GFP_KERNEL);
 		if (!bss) {
-			pr_warn("VIF%u.%u: add missing BSS:%pM chan:%u\n",
+			pr_warn("VIF%u.%u: can't connect to unknown BSS: %pM\n",
 				vif->mac->macid, vif->vifid,
-				join_info->bssid, chandef.chan->hw_value);
+				join_info->bssid);
+			status =3D WLAN_STATUS_UNSPECIFIED_FAILURE;
+			goto done;
+		}
+	}
=20
-			if (!vif->wdev.ssid_len) {
-				pr_warn("VIF%u.%u: SSID unknown for BSS:%pM\n",
-					vif->mac->macid, vif->vifid,
-					join_info->bssid);
-				status =3D WLAN_STATUS_UNSPECIFIED_FAILURE;
-				goto done;
-			}
+	payload_len =3D len - sizeof(*join_info);
+	tlv =3D (struct qlink_tlv_hdr *)join_info->ies;
+
+	while (payload_len >=3D sizeof(struct qlink_tlv_hdr)) {
+		tlv_type =3D le16_to_cpu(tlv->type);
+		tlv_value_len =3D le16_to_cpu(tlv->len);
+		tlv_full_len =3D tlv_value_len + sizeof(struct qlink_tlv_hdr);
=20
-			ie =3D kzalloc(2 + vif->wdev.ssid_len, GFP_KERNEL);
-			if (!ie) {
-				pr_warn("VIF%u.%u: IE alloc failed for BSS:%pM\n",
-					vif->mac->macid, vif->vifid,
-					join_info->bssid);
+		if (payload_len < tlv_full_len) {
+			pr_warn("invalid %u TLV\n", tlv_type);
+			status =3D WLAN_STATUS_UNSPECIFIED_FAILURE;
+			goto done;
+		}
+
+		if (tlv_type =3D=3D QTN_TLV_ID_IE_SET) {
+			const struct qlink_tlv_ie_set *ie_set;
+			unsigned int ie_len;
+
+			if (payload_len < sizeof(*ie_set)) {
+				pr_warn("invalid IE_SET TLV\n");
 				status =3D WLAN_STATUS_UNSPECIFIED_FAILURE;
 				goto done;
 			}
=20
-			ie[0] =3D WLAN_EID_SSID;
-			ie[1] =3D vif->wdev.ssid_len;
-			memcpy(ie + 2, vif->wdev.ssid, vif->wdev.ssid_len);
-
-			bss =3D cfg80211_inform_bss(wiphy, chandef.chan,
-						  CFG80211_BSS_FTYPE_UNKNOWN,
-						  join_info->bssid, 0,
-						  WLAN_CAPABILITY_ESS, 100,
-						  ie, 2 + vif->wdev.ssid_len,
-						  0, GFP_KERNEL);
-			if (!bss) {
-				pr_warn("VIF%u.%u: can't connect to unknown BSS: %pM\n",
-					vif->mac->macid, vif->vifid,
-					join_info->bssid);
-				status =3D WLAN_STATUS_UNSPECIFIED_FAILURE;
-				goto done;
+			ie_set =3D (const struct qlink_tlv_ie_set *)tlv;
+			ie_len =3D tlv_value_len -
+				(sizeof(*ie_set) - sizeof(ie_set->hdr));
+
+			switch (ie_set->type) {
+			case QLINK_IE_SET_ASSOC_RESP:
+				if (ie_len) {
+					rsp_ies =3D ie_set->ie_data;
+					rsp_ies_len =3D ie_len;
+				}
+				break;
+			default:
+				pr_warn("unexpected IE type: %u\n",
+					ie_set->type);
+				break;
 			}
 		}
+
+		payload_len -=3D tlv_full_len;
+		tlv =3D (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
 	}
=20
+	if (payload_len)
+		pr_warn("VIF%u.%u: unexpected remaining payload: %zu\n",
+			vif->mac->macid, vif->vifid, payload_len);
+
 done:
-	cfg80211_connect_result(vif->netdev, join_info->bssid, NULL, 0, NULL,
-				0, status, GFP_KERNEL);
+	cfg80211_connect_result(vif->netdev, join_info->bssid, NULL, 0, rsp_ies,
+				rsp_ies_len, status, GFP_KERNEL);
 	if (bss) {
 		if (!ether_addr_equal(vif->bssid, join_info->bssid))
 			ether_addr_copy(vif->bssid, join_info->bssid);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/w=
ireless/quantenna/qtnfmac/qlink.h
index 27fdb5b01ee3..1f7ced21cb39 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -984,6 +984,7 @@ struct qlink_event_bss_join {
 	struct qlink_chandef chan;
 	u8 bssid[ETH_ALEN];
 	__le16 status;
+	u8 ies[0];
 } __packed;
=20
 /**
--=20
2.11.0

