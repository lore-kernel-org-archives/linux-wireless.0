Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38990C43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 16:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFA4F206BB
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 16:19:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="dW4J176w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732681AbfAIQTg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 11:19:36 -0500
Received: from mail-eopbgr800054.outbound.protection.outlook.com ([40.107.80.54]:59254
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732280AbfAIQTf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 11:19:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CvieQQ2uUCWiUcFrKE1pSqJODEWSaWnnWfidk9qwJoA=;
 b=dW4J176w5LA7FclgSqa0XTmM13aH0Amv1qGKHFCA36egfTScD1Zi0d0aKL6lGxYqTbqhy3shIH56HywdReIodMWGIdV3F9pJ5xlqUPo4K5UDqvcFXgcsxmreTvtsFalOd0SWrK6fHN/wTQ2TDmp06++emJnhkn/iOABeN4+twAM=
Received: from BN6PR05MB3282.namprd05.prod.outlook.com (10.174.95.29) by
 BN6PR05MB3043.namprd05.prod.outlook.com (10.172.145.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.4; Wed, 9 Jan 2019 16:19:33 +0000
Received: from BN6PR05MB3282.namprd05.prod.outlook.com
 ([fe80::93c:653a:fcac:74fe]) by BN6PR05MB3282.namprd05.prod.outlook.com
 ([fe80::93c:653a:fcac:74fe%3]) with mapi id 15.20.1516.010; Wed, 9 Jan 2019
 16:19:33 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5264.namprd05.prod.outlook.com (20.177.252.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.6; Wed, 9 Jan 2019 16:09:06 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1516.010; Wed, 9 Jan 2019
 16:09:06 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 7/7] qtnfmac: add missing bss record to host scan cache
Thread-Topic: [PATCH 7/7] qtnfmac: add missing bss record to host scan cache
Thread-Index: AQHUqDWlaHaynq2W1kmDqK6lVuPHZQ==
Date:   Wed, 9 Jan 2019 16:09:06 +0000
Message-ID: <20190109160843.14832-8-sergey.matyukevich.os@quantenna.com>
References: <20190109160843.14832-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190109160843.14832-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0087.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::28) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BN6PR05MB3043;6:KjyX7BChhRhNQgcdaYJMZ01vBgDrzABwNYzDDompszzUI4cztraamVcOXApbfKO9B2oQmDNaHgJ/FvGcUkgEoQ75wPYZQ1PgDR4tNr95TVweOZP85gxu08gw0oSnvv9da9S9xVT5O6+j1WWst5n10RVOl5pKoH1JCvXxOgElliQ4/nHXF2JgyDVAQw6XNwBiIygcAKv0sAh8c6u7Iugl/vyJx9knS3H4KHKPQW13+Ok8Elyxt2Ed0mi6RBU/U42LikgfUUMl7TkNaY9Bp9/tIpAuTYeF1K4Mfz6k0/3MmES4dFwUYnSRV0aJLJE1aSijn4gG0PcTpKlPRFxuDsU+OAi04yNISeAY3NdvRoCP+XfTdbKWqtamjMk0dZNnwdfA0OmhhGM8LZNvsvj/HtyHTu/UaAlwxbQkW5ecS/hIxUqjbsBYHAcGmpTk+34OBBAHG6rlOODjuYIgveFwg2doIg==;5:Tk06YDp2t8mH6Zvf+TuQs1tGt5T+2lOYaTb18BYMN52CHTgzbcsKMoJtBjRWgvf0u6X2KmgpluL3UfHd5s08/9ylwWfRM/1JVHzz9kyQj3ngfKzx3HOl0eVOFi6MW4dzHSj2FSNOULci93TN8zPD04QccWKfCJabcNhX6aNG6zQ31zTlx8Sc+Dl/YMBGNaoQsDyjOAY5Q+C66AQ9KDCeuA==;7:uf7qFbfrrMVRBpf4pDK4XQVHIyhZ/ZHQD+Vk5W9zFFMGXaIcu4fHG2hCKthrfkVwXnttC/aJiGUzBAi8R75ViRxWoaJfiRl9Y3o5M5ojfhrvgcGiFoDGpKXMWS8vHLV/P0oo2qdXpV6cmRn/AGbGPA==
x-ms-office365-filtering-correlation-id: 436bc513-0528-498a-aa73-08d6764cc7dd
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5264;
x-ms-traffictypediagnostic: SN6PR05MB5264:|BN6PR05MB3043:
x-moderation-data: 1/9/2019 4:19:32 PM
x-microsoft-antispam-prvs: <BN6PR05MB30436B8D7B2E9D42898FF452A38B0@BN6PR05MB3043.namprd05.prod.outlook.com>
x-forefront-prvs: 0912297777
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(376002)(136003)(39850400004)(346002)(189003)(199004)(486006)(7736002)(66066001)(6486002)(14454004)(103116003)(2906002)(26005)(305945005)(6346003)(436003)(97736004)(6916009)(186003)(102836004)(99286004)(6506007)(8676002)(386003)(81156014)(52116002)(2351001)(8936002)(81166006)(105586002)(478600001)(76176011)(107886003)(14444005)(5640700003)(71190400001)(54906003)(4326008)(256004)(476003)(68736007)(25786009)(316002)(5660300001)(2616005)(6512007)(1076003)(53936002)(446003)(36756003)(6436002)(3846002)(11346002)(6116002)(575784001)(86362001)(71200400001)(106356001)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR05MB3043;H:BN6PR05MB3282.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Os0R1d4w9ZDsf1+2UdDEiJ5NrwTXQNR/X5ayV4leQrXdPVto6Xuu68vj/kEycfKtDEaYR58inQzRWt9CteBIR8CB4HLYz+xt7L4tgjjjFkQoBvXeB8uelNmgKcquuW4Q8fgGqWA6zsn/Jar/LnHmsTe5nwHUXPiau7PKohiL7JpOtTawKbF0acB4AQX9uC1oIp3iuBJEo0vxi6uGn8jqePd0/mlebwi1FkmYQ05duA6eiOu+DzRgccqkVp09bCa6wvwMBIuiLMYJvBtYWlwK45YO3BRDh08l9Qbu6u2QJzKPKkmNKymu1LUQ8YfE/EDI
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 436bc513-0528-498a-aa73-08d6764cc7dd
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2019 16:19:33.6493
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR05MB3043
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Make sure that valid BSS entry exists in wireless core scan records
even in the case of successful connect reported by firmware.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/event.c | 79 ++++++++++++++++++++++=
++--
 drivers/net/wireless/quantenna/qtnfmac/qlink.h |  4 +-
 2 files changed, 78 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/w=
ireless/quantenna/qtnfmac/event.c
index 3038a000c287..3fd1a9217737 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -145,6 +145,12 @@ qtnf_event_handle_bss_join(struct qtnf_vif *vif,
 			   const struct qlink_event_bss_join *join_info,
 			   u16 len)
 {
+	struct wiphy *wiphy =3D priv_to_wiphy(vif->mac);
+	enum ieee80211_statuscode status =3D le16_to_cpu(join_info->status);
+	struct cfg80211_chan_def chandef;
+	struct cfg80211_bss *bss =3D NULL;
+	u8 *ie =3D NULL;
+
 	if (unlikely(len < sizeof(*join_info))) {
 		pr_err("VIF%u.%u: payload is too short (%u < %zu)\n",
 		       vif->mac->macid, vif->vifid, len,
@@ -158,15 +164,80 @@ qtnf_event_handle_bss_join(struct qtnf_vif *vif,
 		return -EPROTO;
 	}
=20
-	pr_debug("VIF%u.%u: BSSID:%pM\n", vif->mac->macid, vif->vifid,
-		 join_info->bssid);
+	pr_debug("VIF%u.%u: BSSID:%pM status:%u\n",
+		 vif->mac->macid, vif->vifid, join_info->bssid, status);
+
+	if (status =3D=3D WLAN_STATUS_SUCCESS) {
+		qlink_chandef_q2cfg(wiphy, &join_info->chan, &chandef);
+		if (!cfg80211_chandef_valid(&chandef)) {
+			pr_warn("MAC%u.%u: bad channel freq=3D%u cf1=3D%u cf2=3D%u bw=3D%u\n",
+				vif->mac->macid, vif->vifid,
+				chandef.chan->center_freq,
+				chandef.center_freq1,
+				chandef.center_freq2,
+				chandef.width);
+			status =3D WLAN_STATUS_UNSPECIFIED_FAILURE;
+			goto done;
+		}
=20
+		bss =3D cfg80211_get_bss(wiphy, chandef.chan, join_info->bssid,
+				       NULL, 0, IEEE80211_BSS_TYPE_ESS,
+				       IEEE80211_PRIVACY_ANY);
+		if (!bss) {
+			pr_warn("VIF%u.%u: add missing BSS:%pM chan:%u\n",
+				vif->mac->macid, vif->vifid,
+				join_info->bssid, chandef.chan->hw_value);
+
+			if (!vif->wdev.ssid_len) {
+				pr_warn("VIF%u.%u: SSID unknown for BSS:%pM\n",
+					vif->mac->macid, vif->vifid,
+					join_info->bssid);
+				status =3D WLAN_STATUS_UNSPECIFIED_FAILURE;
+				goto done;
+			}
+
+			ie =3D kzalloc(2 + vif->wdev.ssid_len, GFP_KERNEL);
+			if (!ie) {
+				pr_warn("VIF%u.%u: IE alloc failed for BSS:%pM\n",
+					vif->mac->macid, vif->vifid,
+					join_info->bssid);
+				status =3D WLAN_STATUS_UNSPECIFIED_FAILURE;
+				goto done;
+			}
+
+			ie[0] =3D WLAN_EID_SSID;
+			ie[1] =3D vif->wdev.ssid_len;
+			memcpy(ie + 2, vif->wdev.ssid, vif->wdev.ssid_len);
+
+			bss =3D cfg80211_inform_bss(wiphy, chandef.chan,
+						  CFG80211_BSS_FTYPE_UNKNOWN,
+						  join_info->bssid, 0,
+						  WLAN_CAPABILITY_ESS, 100,
+						  ie, 2 + vif->wdev.ssid_len,
+						  0, GFP_KERNEL);
+			if (!bss) {
+				pr_warn("VIF%u.%u: can't connect to unknown BSS: %pM\n",
+					vif->mac->macid, vif->vifid,
+					join_info->bssid);
+				status =3D WLAN_STATUS_UNSPECIFIED_FAILURE;
+				goto done;
+			}
+		}
+	}
+
+done:
 	cfg80211_connect_result(vif->netdev, join_info->bssid, NULL, 0, NULL,
-				0, le16_to_cpu(join_info->status), GFP_KERNEL);
+				0, status, GFP_KERNEL);
+	if (bss) {
+		if (!ether_addr_equal(vif->bssid, join_info->bssid))
+			ether_addr_copy(vif->bssid, join_info->bssid);
+		cfg80211_put_bss(wiphy, bss);
+	}
=20
-	if (le16_to_cpu(join_info->status) =3D=3D WLAN_STATUS_SUCCESS)
+	if (status =3D=3D WLAN_STATUS_SUCCESS)
 		netif_carrier_on(vif->netdev);
=20
+	kfree(ie);
 	return 0;
 }
=20
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/w=
ireless/quantenna/qtnfmac/qlink.h
index d958b268de02..27fdb5b01ee3 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -6,7 +6,7 @@
=20
 #include <linux/ieee80211.h>
=20
-#define QLINK_PROTO_VER		12
+#define QLINK_PROTO_VER		13
=20
 #define QLINK_MACID_RSVD		0xFF
 #define QLINK_VIFID_RSVD		0xFF
@@ -975,11 +975,13 @@ struct qlink_event_sta_deauth {
 /**
  * struct qlink_event_bss_join - data for QLINK_EVENT_BSS_JOIN event
  *
+ * @chan: new operating channel definition
  * @bssid: BSSID of a BSS which interface tried to joined.
  * @status: status of joining attempt, see &enum ieee80211_statuscode.
  */
 struct qlink_event_bss_join {
 	struct qlink_event ehdr;
+	struct qlink_chandef chan;
 	u8 bssid[ETH_ALEN];
 	__le16 status;
 } __packed;
--=20
2.11.0

