Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA8E5ECDE32
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 14:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 911852151D
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 14:02:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="hNdRi2Sw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 911852151D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbeJQV6n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 17:58:43 -0400
Received: from mail-cys01nam02on0076.outbound.protection.outlook.com ([104.47.37.76]:49952
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726727AbeJQV6n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 17:58:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YIcPrbvkPP+sJDq0jVxHDW4wWO0dCE4LtYzrilm7F24=;
 b=hNdRi2SwHIY80pPLWgsrBzVnTji9tFnWyuM/PxHdlbh2bXdGEaOpsTZxJLGkvFUNXIOxaNyHlM5jKYrM5weR99KaerdNEIv6XeLzSyTOkxujOH4vMxa/LVpeRjVX/xkuBPi926uyaqmNF28KBT3xfPuG8Gxz2lZNBWtxxWBIbO8=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB5027.namprd05.prod.outlook.com (20.177.241.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.19; Wed, 17 Oct 2018 14:02:47 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::d16b:3a5b:aa09:b156]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::d16b:3a5b:aa09:b156%2]) with mapi id 15.20.1250.020; Wed, 17 Oct 2018
 14:02:47 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH] qtnfmac: fix error handling in control path
Thread-Topic: [PATCH] qtnfmac: fix error handling in control path
Thread-Index: AQHUZiIVLkg5m9YJo0ahc2JQ52VmpA==
Date:   Wed, 17 Oct 2018 14:02:47 +0000
Message-ID: <20181017140231.27353-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P193CA0033.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:3e::46) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5027;6:i/XHk+YKhSTdSKmoaE69FOBztYX7I6Wm+L7XIeLO7UM0XoXG2zQvdNm2LWhWJZJ0NocpkNhms3O5bsrwwpjjixVhbfclj5zfx5Hi77OTlpbYt9gaTmdj1aMm2J0QXgzsWyL+8YzJMkKp3SlmiUYogTrF5Vi/7oC/RbFZ9WpsNHELtsNgUsuZagda4w8sz/4d0Kedw7+3T/eZm87avwvnIuUuQrZa5U7WcpXUY/UdxlXiJSCo7nRZZsV27Yj3AKpoJxfPkcZ+V6vcOaBhDIJhu2i41xRg/ix9Xh2d9eaaoq6AIhMWon96sJdLl3acEtxulh9ufTIDsLX4IrSXtPzlBlp2a1fCVWzxmlHozufu8ZzAyCWSbmsnv4Uq5cLTUXJN+DQlBkCziPUdw9QhYjjj6TrVG3faNyMMXGh7GYFT3khZrrQzQIoTgVK2NZ1HSRp2INI8080SZXypD8tqVr3mlw==;5:0XX42kGz9zA6tRF5frcsfAcM3jXKTnp0ha0z82u5A3gZ6Uf/KymWJYP3EfO5uF8Kt53bgMY6cO/OrZdguoHtjDGz752NPTkT4nNH/LX3lhUnwJrM+Vnaw0xCPNadHtpqUbRJbytTQN64UciA7CUTCcgYgzQPL4Naxcnw5q1FHy8=;7:1fvnnpZD3GByfYr53UUunWcqtjoxDjIBH4yL3fB+9QtRV48zdYBoQ1t9jPWZbvtbiZ76GynjBPzfop2zhRhnx81vpwVaEDt+lhvVJ4TWS19iho2W4h9eMlhCSKz+lOvoO77rkDKt0irZwHPWz9XJXtXRq0MrEKVucxPD7kEzaLT8aScPLhS6GQR71zO3+FiEhqWpgo0DaIFHTm126/QnGo9ezmP1MgGH2eS0os7R8N1DKN7dVb1T4h/cHQKuY13I
x-ms-office365-filtering-correlation-id: ac77eb1e-5087-462f-bea9-08d634393730
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5027;
x-ms-traffictypediagnostic: BL0PR05MB5027:
x-microsoft-antispam-prvs: <BL0PR05MB50275D23DAEFA411B2020DAAA3FF0@BL0PR05MB5027.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(146099531331640);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123558120)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:BL0PR05MB5027;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5027;
x-forefront-prvs: 08286A0BE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(39850400004)(396003)(346002)(136003)(189003)(199004)(86362001)(52116002)(71200400001)(81166006)(103116003)(107886003)(71190400001)(2616005)(1857600001)(26005)(36756003)(68736007)(476003)(8676002)(478600001)(81156014)(256004)(2501003)(106356001)(6506007)(8936002)(102836004)(2351001)(3846002)(5660300001)(14454004)(6116002)(5640700003)(66066001)(386003)(6916009)(6346003)(105586002)(6486002)(4326008)(97736004)(316002)(7736002)(486006)(99286004)(54906003)(2906002)(6436002)(1076002)(53936002)(305945005)(6512007)(25786009)(2900100001)(5250100002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5027;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:3;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-message-info: Ow44mj1+Zimrk9qclR9i+5sIOHOWqBC4uDh8RnxHvuO908lOdzxgmVJ7uKMS+DdWGE9Qec9LN/uIUcmc7YDwTB5CJY5d7dNE5obPpWd1r8hbj0QypJ7M5UTyjKeSHLcQoXK3DLRgEV3fA3dPta0Ueay2ldcVheMzbTozSxzYxpdB2GwdSmpc2aKL53c5rNXb6jj4lkea+hcgdfvdEBUG3rLpx5JHY4lcWq/PUzhlMUPSdN804289B4hnsJIIyyDkbBNQMT1Dx7R6mPdOpt6UI3mf/CClcookOHWLcAk7PFCOl2+PCifkhPpbQ3hkZg3GHJOQQ8mD8ZfCinUuUUMS5++n+VQENnvhC5Qyuw/N3pc=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac77eb1e-5087-462f-bea9-08d634393730
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2018 14:02:47.1663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5027
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch fixes the following warnings:

- smatch
drivers/net/wireless/quantenna/qtnfmac/commands.c:132 qtnf_cmd_send_with_re=
ply() warn: variable dereferenced before check 'resp' (see line 117)
drivers/net/wireless/quantenna/qtnfmac/commands.c:716  qtnf_cmd_get_sta_inf=
o() error: uninitialized symbol 'var_resp_len'.
drivers/net/wireless/quantenna/qtnfmac/commands.c:1668 qtnf_cmd_get_mac_inf=
o() error: uninitialized symbol 'var_data_len'.
drivers/net/wireless/quantenna/qtnfmac/commands.c:1697 qtnf_cmd_get_hw_info=
() error: uninitialized symbol 'info_len'.
drivers/net/wireless/quantenna/qtnfmac/commands.c:1753 qtnf_cmd_band_info_g=
et() error: uninitialized symbol 'info_len'.
drivers/net/wireless/quantenna/qtnfmac/commands.c:1782 qtnf_cmd_send_get_ph=
y_params() error: uninitialized symbol 'response_size'.
drivers/net/wireless/quantenna/qtnfmac/commands.c:2438 qtnf_cmd_get_chan_st=
ats() error: uninitialized symbol 'var_data_len'.

- gcc-8.2.1
drivers/net/wireless/quantenna/qtnfmac/commands.c: In function 'qtnf_cmd_se=
nd_with_reply':
drivers/net/wireless/quantenna/qtnfmac/commands.c:133:54: error: 'resp' may=
 be used uninitialized in this function [-Werror=3Dmaybe-uninitialized]

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 21 +++++++++++++------=
--
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index bfdc1ad30c13..659e7649fe22 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -84,7 +84,7 @@ static int qtnf_cmd_send_with_reply(struct qtnf_bus *bus,
 				    size_t *var_resp_size)
 {
 	struct qlink_cmd *cmd;
-	const struct qlink_resp *resp;
+	struct qlink_resp *resp =3D NULL;
 	struct sk_buff *resp_skb =3D NULL;
 	u16 cmd_id;
 	u8 mac_id;
@@ -113,7 +113,12 @@ static int qtnf_cmd_send_with_reply(struct qtnf_bus *b=
us,
 	if (ret)
 		goto out;
=20
-	resp =3D (const struct qlink_resp *)resp_skb->data;
+	if (WARN_ON(!resp_skb || !resp_skb->data)) {
+		ret =3D -EFAULT;
+		goto out;
+	}
+
+	resp =3D (struct qlink_resp *)resp_skb->data;
 	ret =3D qtnf_cmd_check_reply_header(resp, cmd_id, mac_id, vif_id,
 					  const_resp_size);
 	if (ret)
@@ -686,7 +691,7 @@ int qtnf_cmd_get_sta_info(struct qtnf_vif *vif, const u=
8 *sta_mac,
 	struct sk_buff *cmd_skb, *resp_skb =3D NULL;
 	struct qlink_cmd_get_sta_info *cmd;
 	const struct qlink_resp_get_sta_info *resp;
-	size_t var_resp_len;
+	size_t var_resp_len =3D 0;
 	int ret =3D 0;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
@@ -1650,7 +1655,7 @@ int qtnf_cmd_get_mac_info(struct qtnf_wmac *mac)
 {
 	struct sk_buff *cmd_skb, *resp_skb =3D NULL;
 	const struct qlink_resp_get_mac_info *resp;
-	size_t var_data_len;
+	size_t var_data_len =3D 0;
 	int ret =3D 0;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(mac->macid, QLINK_VIFID_RSVD,
@@ -1680,8 +1685,8 @@ int qtnf_cmd_get_hw_info(struct qtnf_bus *bus)
 {
 	struct sk_buff *cmd_skb, *resp_skb =3D NULL;
 	const struct qlink_resp_get_hw_info *resp;
+	size_t info_len =3D 0;
 	int ret =3D 0;
-	size_t info_len;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(QLINK_MACID_RSVD, QLINK_VIFID_RSVD,
 					    QLINK_CMD_GET_HW_INFO,
@@ -1709,9 +1714,9 @@ int qtnf_cmd_band_info_get(struct qtnf_wmac *mac,
 			   struct ieee80211_supported_band *band)
 {
 	struct sk_buff *cmd_skb, *resp_skb =3D NULL;
-	size_t info_len;
 	struct qlink_cmd_band_info_get *cmd;
 	struct qlink_resp_band_info_get *resp;
+	size_t info_len =3D 0;
 	int ret =3D 0;
 	u8 qband;
=20
@@ -1764,8 +1769,8 @@ int qtnf_cmd_band_info_get(struct qtnf_wmac *mac,
 int qtnf_cmd_send_get_phy_params(struct qtnf_wmac *mac)
 {
 	struct sk_buff *cmd_skb, *resp_skb =3D NULL;
-	size_t response_size;
 	struct qlink_resp_phy_params *resp;
+	size_t response_size =3D 0;
 	int ret =3D 0;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(mac->macid, 0,
@@ -2431,7 +2436,7 @@ int qtnf_cmd_get_chan_stats(struct qtnf_wmac *mac, u1=
6 channel,
 	struct sk_buff *cmd_skb, *resp_skb =3D NULL;
 	struct qlink_cmd_get_chan_stats *cmd;
 	struct qlink_resp_get_chan_stats *resp;
-	size_t var_data_len;
+	size_t var_data_len =3D 0;
 	int ret =3D 0;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(mac->macid, QLINK_VIFID_RSVD,
--=20
2.11.0

