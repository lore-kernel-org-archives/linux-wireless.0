Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A65EDC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AC062184E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="PlzUKxBs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfCTKFC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:05:02 -0400
Received: from mail-eopbgr800051.outbound.protection.outlook.com ([40.107.80.51]:23808
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725905AbfCTKFC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 06:05:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EnmU0swGWMmTcB3t4+V2cgRCObLqtRGv4JEl0JeBAxY=;
 b=PlzUKxBsi6V6xszHFhZntpe02Vn79bFJ3Ipz4yIiz4GoehzxfuiNQuuY8YXuKyGQKWCx2m3NY5P9TzTXehwuIXLXdq9NlmPh1i+B4uvr66UFFUVGpOgkm+uWPSor9Tf/B5omuy3y68YCtAkwifOwB5ooQm8DjL1EAOyP3w2eTCg=
Received: from DM6PR05MB5690.namprd05.prod.outlook.com (20.178.24.91) by
 DM6PR05MB6092.namprd05.prod.outlook.com (20.178.30.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.16; Wed, 20 Mar 2019 10:04:47 +0000
Received: from DM6PR05MB5690.namprd05.prod.outlook.com
 ([fe80::f17f:2b4d:68eb:5e70]) by DM6PR05MB5690.namprd05.prod.outlook.com
 ([fe80::f17f:2b4d:68eb:5e70%5]) with mapi id 15.20.1709.011; Wed, 20 Mar 2019
 10:04:47 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4672.namprd05.prod.outlook.com (52.135.114.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.15; Wed, 20 Mar 2019 10:03:53 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:03:53 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 04/14] qtnfmac: pass complete channel info in regulatory
 notifier
Thread-Topic: [PATCH 04/14] qtnfmac: pass complete channel info in regulatory
 notifier
Thread-Index: AQHU3wQ5cpX1zttHOE6u3MISQnXKjw==
Date:   Wed, 20 Mar 2019 10:03:53 +0000
Message-ID: <20190320100340.14168-5-sergey.matyukevich.os@quantenna.com>
References: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0106.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::47) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.11.0
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94fdf8a4-0d34-401d-37b3-08d6ad1b5b7c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4672;
x-ms-traffictypediagnostic: SN6PR05MB4672:|DM6PR05MB6092:
x-moderation-data: 3/20/2019 10:04:46 AM
x-microsoft-antispam-prvs: <DM6PR05MB6092534AD71ECC46250443FEA3410@DM6PR05MB6092.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(136003)(396003)(376002)(346002)(366004)(189003)(199004)(53936002)(86362001)(14444005)(256004)(71200400001)(1076003)(5640700003)(6512007)(25786009)(7736002)(316002)(66066001)(305945005)(8676002)(386003)(6506007)(54906003)(14454004)(52116002)(99286004)(76176011)(6116002)(103116003)(3846002)(102836004)(6916009)(36756003)(478600001)(97736004)(2906002)(5660300002)(8936002)(68736007)(2351001)(186003)(50226002)(2501003)(26005)(4326008)(486006)(81156014)(81166006)(2616005)(71190400001)(107886003)(6436002)(11346002)(446003)(106356001)(105586002)(6486002)(476003)(436003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB6092;H:DM6PR05MB5690.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JrVbuYHm1lRWPvxOeWnD+QNcsTGLH6zxswAd3L3HOqPmT2SZIzUNJ4UJHuGPgXej03B03xuWDHKblb+pkDzTB11CoeKb0oqTwPxnznZI+DcGw/L7QsR2nfJBX+a4Q+OXW/17Hj+p/bZ4QBvC6yz/FevM5PgDnDfLJL5fgcebI68H2y1FMzAuKB6QoyIyqIPV1XBeSw1XWJ/VKUbRDunR7ZnAlqertioeuxJxuPXyX3FrVA74BQhFVfIVjbZ7U43bpc+yiJl6rKkxIcqJVKyic1x3pyREkuOjSkHRAA8hgxw3iqe48awQEadwAJnoIbjmF41MOs8vf17D4KnEPkBNMuKEa8cfD2WksXkH6mxhBaCfjgoBPipB7c87qXrr+Z6r/iif8vptefdMMJGAye+TZmoJ671KbRTj0xwAg0ADySs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94fdf8a4-0d34-401d-37b3-08d6ad1b5b7c
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 10:04:47.8629
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB6092
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Currently only a portion of per-channel information is passed to
firmware. Extend logic to pass all useful per-channel data.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 49 +++++++-----------=
-
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    | 55 ++++++++++++++++++=
++++
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    |  3 ++
 3 files changed, 76 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index b1b622019f12..e61bec7c5d8a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -1709,21 +1709,7 @@ int qtnf_cmd_band_info_get(struct qtnf_wmac *mac,
 	struct qlink_resp_band_info_get *resp;
 	size_t info_len =3D 0;
 	int ret =3D 0;
-	u8 qband;
-
-	switch (band->band) {
-	case NL80211_BAND_2GHZ:
-		qband =3D QLINK_BAND_2GHZ;
-		break;
-	case NL80211_BAND_5GHZ:
-		qband =3D QLINK_BAND_5GHZ;
-		break;
-	case NL80211_BAND_60GHZ:
-		qband =3D QLINK_BAND_60GHZ;
-		break;
-	default:
-		return -EINVAL;
-	}
+	u8 qband =3D qlink_utils_band_cfg2q(band->band);
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(mac->macid, 0,
 					    QLINK_CMD_BAND_INFO_GET,
@@ -2107,22 +2093,23 @@ int qtnf_cmd_send_del_sta(struct qtnf_vif *vif,
 static void qtnf_cmd_channel_tlv_add(struct sk_buff *cmd_skb,
 				     const struct ieee80211_channel *sc)
 {
-	struct qlink_tlv_channel *qchan;
-	u32 flags =3D 0;
-
-	qchan =3D skb_put_zero(cmd_skb, sizeof(*qchan));
-	qchan->hdr.type =3D cpu_to_le16(QTN_TLV_ID_CHANNEL);
-	qchan->hdr.len =3D cpu_to_le16(sizeof(*qchan) - sizeof(qchan->hdr));
-	qchan->chan.center_freq =3D cpu_to_le16(sc->center_freq);
-	qchan->chan.hw_value =3D cpu_to_le16(sc->hw_value);
-
-	if (sc->flags & IEEE80211_CHAN_NO_IR)
-		flags |=3D QLINK_CHAN_NO_IR;
-
-	if (sc->flags & IEEE80211_CHAN_RADAR)
-		flags |=3D QLINK_CHAN_RADAR;
-
-	qchan->chan.flags =3D cpu_to_le32(flags);
+	struct qlink_tlv_channel *tlv;
+	struct qlink_channel *qch;
+
+	tlv =3D skb_put_zero(cmd_skb, sizeof(*tlv));
+	qch =3D &tlv->chan;
+	tlv->hdr.type =3D cpu_to_le16(QTN_TLV_ID_CHANNEL);
+	tlv->hdr.len =3D cpu_to_le16(sizeof(*qch));
+
+	qch->center_freq =3D cpu_to_le16(sc->center_freq);
+	qch->hw_value =3D cpu_to_le16(sc->hw_value);
+	qch->band =3D qlink_utils_band_cfg2q(sc->band);
+	qch->max_power =3D sc->max_power;
+	qch->max_reg_power =3D sc->max_reg_power;
+	qch->max_antenna_gain =3D sc->max_antenna_gain;
+	qch->beacon_found =3D sc->beacon_found;
+	qch->dfs_state =3D qlink_utils_dfs_state_cfg2q(sc->dfs_state);
+	qch->flags =3D cpu_to_le32(qlink_utils_chflags_cfg2q(sc->flags));
 }
=20
 static void qtnf_cmd_randmac_tlv_add(struct sk_buff *cmd_skb,
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c b/drivers/=
net/wireless/quantenna/qtnfmac/qlink_util.c
index 72bfd17cb687..8cae9d8d1ab6 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
@@ -182,3 +182,58 @@ void qlink_acl_data_cfg2q(const struct cfg80211_acl_da=
ta *acl,
 	memcpy(qacl->mac_addrs, acl->mac_addrs,
 	       acl->n_acl_entries * sizeof(*qacl->mac_addrs));
 }
+
+enum qlink_band qlink_utils_band_cfg2q(enum nl80211_band band)
+{
+	switch (band) {
+	case NL80211_BAND_2GHZ:
+		return QLINK_BAND_2GHZ;
+	case NL80211_BAND_5GHZ:
+		return QLINK_BAND_5GHZ;
+	case NL80211_BAND_60GHZ:
+		return QLINK_BAND_60GHZ;
+	default:
+		return -EINVAL;
+	}
+}
+
+enum qlink_dfs_state qlink_utils_dfs_state_cfg2q(enum nl80211_dfs_state st=
ate)
+{
+	switch (state) {
+	case NL80211_DFS_USABLE:
+		return QLINK_DFS_USABLE;
+	case NL80211_DFS_AVAILABLE:
+		return QLINK_DFS_AVAILABLE;
+	case NL80211_DFS_UNAVAILABLE:
+	default:
+		return QLINK_DFS_UNAVAILABLE;
+	}
+}
+
+u32 qlink_utils_chflags_cfg2q(u32 cfgflags)
+{
+	u32 flags =3D 0;
+
+	if (cfgflags & IEEE80211_CHAN_DISABLED)
+		flags |=3D QLINK_CHAN_DISABLED;
+
+	if (cfgflags & IEEE80211_CHAN_NO_IR)
+		flags |=3D QLINK_CHAN_NO_IR;
+
+	if (cfgflags & IEEE80211_CHAN_RADAR)
+		flags |=3D QLINK_CHAN_RADAR;
+
+	if (cfgflags & IEEE80211_CHAN_NO_HT40PLUS)
+		flags |=3D QLINK_CHAN_NO_HT40PLUS;
+
+	if (cfgflags & IEEE80211_CHAN_NO_HT40MINUS)
+		flags |=3D QLINK_CHAN_NO_HT40MINUS;
+
+	if (cfgflags & IEEE80211_CHAN_NO_80MHZ)
+		flags |=3D QLINK_CHAN_NO_80MHZ;
+
+	if (cfgflags & IEEE80211_CHAN_NO_160MHZ)
+		flags |=3D QLINK_CHAN_NO_160MHZ;
+
+	return flags;
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h b/drivers/=
net/wireless/quantenna/qtnfmac/qlink_util.h
index 781ea7fe79f2..9d10a2098ca7 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
@@ -79,5 +79,8 @@ bool qtnf_utils_is_bit_set(const u8 *arr, unsigned int bi=
t,
 			   unsigned int arr_max_len);
 void qlink_acl_data_cfg2q(const struct cfg80211_acl_data *acl,
 			  struct qlink_acl_data *qacl);
+enum qlink_band qlink_utils_band_cfg2q(enum nl80211_band band);
+enum qlink_dfs_state qlink_utils_dfs_state_cfg2q(enum nl80211_dfs_state st=
ate);
+u32 qlink_utils_chflags_cfg2q(u32 cfgflags);
=20
 #endif /* _QTN_FMAC_QLINK_UTIL_H_ */
--=20
2.11.0

