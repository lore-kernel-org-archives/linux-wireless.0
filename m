Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2992DC43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCA6E20659
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:41:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="qSShFGjk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfANJlN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 04:41:13 -0500
Received: from mail-eopbgr810055.outbound.protection.outlook.com ([40.107.81.55]:63923
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726534AbfANJlN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 04:41:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ymfHPKhfkLQnWXEmJ88Gdnm5lSqSTVa3HVbGyJuuJfo=;
 b=qSShFGjkmBl/lZJRp7gkL41Zs1IJlRb54hqsVVIqS8sdP/mhBoCrabtAWl/gnfzhAtZJ6gH/ZOiTlG6U+aecczCREkXM2pTIY8EISAxq7yy/O9yBSAKO4Y6QNTSvAaj3npjje0EtsgGJk3klB+An/dg84LjTIuaPAxTA0iKCMzU=
Received: from BL0PR05MB4818.namprd05.prod.outlook.com (52.132.15.24) by
 BL0PR05MB5665.namprd05.prod.outlook.com (10.167.240.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.10; Mon, 14 Jan 2019 09:41:00 +0000
Received: from BL0PR05MB4818.namprd05.prod.outlook.com
 ([fe80::147c:e119:a8da:4046]) by BL0PR05MB4818.namprd05.prod.outlook.com
 ([fe80::147c:e119:a8da:4046%2]) with mapi id 15.20.1537.018; Mon, 14 Jan 2019
 09:41:00 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4719.namprd05.prod.outlook.com (52.135.114.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.17; Mon, 14 Jan 2019 09:39:47 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::6d1c:886b:bd14:71c5%6]) with mapi id 15.20.1537.018; Mon, 14 Jan 2019
 09:39:47 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 7/9] qtnfmac: add missing bss record to host scan cache
Thread-Topic: [PATCH v2 7/9] qtnfmac: add missing bss record to host scan
 cache
Thread-Index: AQHUq+0WYjocHjPXg0e7QZCT6+876g==
Date:   Mon, 14 Jan 2019 09:39:47 +0000
Message-ID: <20190114093925.9061-8-sergey.matyukevich.os@quantenna.com>
References: <20190114093925.9061-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190114093925.9061-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0070.namprd05.prod.outlook.com
 (2603:10b6:a03:74::47) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5665;6:HAwhnHKGlNWQmzf64a3FLNSuBruuvYVSZBzIHonZ6FEczWAwo7bmT1ASwSZsULtobJjpB00yk95kBYkYfXAC36lZngqJ0geipvW0J3XjmS+q+8XfYGPiWCGqm5SmC7/282BIOvaRjJR44e4Z06A26yLWVJ1EBn+8dj5Mcu7DBF+FCFCO6auoIeIr/R+UON8sFFO1T2AVl9X+7b+bOGFWRxwGoD6elZXvFQEw/YEEhD/VBh3NaQAWvonoX0cTqWPE2a5y4ekmIlhoUJ4fQQOIlxoZB0iAqxpEXvXWCo5iYCkFw3WeEVWYI+zj3f02oB1EsCDVwfu7plsxGEaQLKoU832PxjOt8stQZKAM9iQ7wpnduVYkvyeF9Kh3N1d4kjA46pWeX/b+le+NurLYPYlFQaDXEpS3gtRkeDG5Ia7C2h27t9oZkPBoe7BPLlAb1mGxLa8jJuKfXnWDD/fyqhpSQA==;5:stW5++sOdAV45HM4D89uLVHzDH3kTz3M/6aKKQ10nMSxYv8FGXxBAWagcfsdFxcTZN4vIlPDJjPAydIcrnYlbQ7pffjpJ9NVHSglQDe7olX5j4ogRAe6jXZMhzrMMkFhD61rFO1/3b/74kbW9LmG1ZqzPLp4rQSG0IduXYib903L3ckPbkHDpeZ1QWqIeMSP8QKKIxRkpiAfslNpxWC7bA==;7:2leMLZBS9rjZRGWNwr3HaOjs+WzLjLWiVd8du94WB9EavZjTiTLxejGFzKHz0M6G5cdiSrzxsEu9Eu4co/nyaGplEAOPGF8qUYVsUJgIZ06EQLl44TCq3I8b3h7loZwuEP60TT/n7bkABlycMlik2g==
x-ms-office365-filtering-correlation-id: 2cd05929-5dae-4cd9-ce93-08d67a0438b4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600109)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4719;
x-ms-traffictypediagnostic: SN6PR05MB4719:|BL0PR05MB5665:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-moderation-data: 1/14/2019 9:40:57 AM
x-microsoft-antispam-prvs: <BL0PR05MB5665010EDCC7AA1D437E8BC9A3800@BL0PR05MB5665.namprd05.prod.outlook.com>
x-forefront-prvs: 0917DFAC67
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(346002)(39840400004)(396003)(366004)(189003)(199004)(5640700003)(6916009)(2906002)(3846002)(386003)(26005)(99286004)(36756003)(14444005)(52116002)(2501003)(76176011)(186003)(71190400001)(6116002)(5660300001)(486006)(102836004)(71200400001)(446003)(436003)(256004)(2616005)(53936002)(6506007)(11346002)(1076003)(476003)(316002)(106356001)(14454004)(6512007)(4326008)(81166006)(66066001)(8676002)(81156014)(8936002)(103116003)(107886003)(25786009)(105586002)(305945005)(68736007)(7736002)(2351001)(6436002)(86362001)(575784001)(54906003)(478600001)(6486002)(97736004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5665;H:BL0PR05MB4818.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QY4aM2TpctdzgdMuwveSGNehKKckbCJzsL5zCxNr97WdSUl6WTPKc4Ftsha/wFzHO13hdd+HvCCSFxDl4v+Y/AbptXMCy9/5X7H1nfaJs7EUDp4AuhenvKc26Rl4Vbcnf/o+LxsvFpJ8Nv88cGt9JThvzyfrCl6tHNrepQEx5DUB4rebEP6YjvN7A3KPgVWutr5DS6OnQ2OnABft4E2/NsGPwxGQ4mI2tRX9KFHSA7yS/1SsSu2ds1cNYPhoVBb4yWkMhgCGQm3oQL9Qo4e1IgXvmRt9w9famciXAF2JkC3dMmu9Hj5Z6A4Mm0bNdi0ec/Fgxq7P0mXpbTRmKY4lGdtKE8xDsHHhyFGyz1kePNzd58HCWxL5/Tx8G1YQPxwD7x/eLfi/zfrrCrkSNpZRqwTDsywfjigUQ4AQZVl4jak=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cd05929-5dae-4cd9-ce93-08d67a0438b4
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2019 09:41:00.4618
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5665
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Make sure that valid BSS entry exists in wireless core record
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

