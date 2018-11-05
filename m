Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D0A5C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DFEA2085A
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:31:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="eyghkq3h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DFEA2085A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbeKEXvV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 18:51:21 -0500
Received: from mail-eopbgr720089.outbound.protection.outlook.com ([40.107.72.89]:63104
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729072AbeKEXvU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 18:51:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ouRIuH0Qk1GlofU9A1cKcGXntw31SVwyNx1Ximyiv48=;
 b=eyghkq3hBvPmSIEfgmnBklbWnK5lt/U9AMr+b5WpmnSRbP35DPPcehkd3IqxSZ/V3SkTYQKzKdjYJF3q2dDub+DNqZz/KffJk/VyTW4nClHTX9aOLgCdkUrsSNSipAK9WDdb3n+pEVn4EC6CzdVR3bX7OKZvvRnOEVBX9IE/BYE=
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com (20.177.146.138) by
 BL0PR05MB5364.namprd05.prod.outlook.com (10.167.233.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.9; Mon, 5 Nov 2018 14:30:39 +0000
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8]) by BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8%3]) with mapi id 15.20.1294.028; Mon, 5 Nov 2018
 14:30:39 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
CC:     Jouni Malinen <j@w1.fi>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [RFC 2/3] iw: add phy subcommands to configure aggregation
Thread-Topic: [RFC 2/3] iw: add phy subcommands to configure aggregation
Thread-Index: AQHUdRQfn//pssnBGkemKzXFUo2h1Q==
Date:   Mon, 5 Nov 2018 14:30:39 +0000
Message-ID: <20181105143027.17570-3-sergey.matyukevich.os@quantenna.com>
References: <20181105143027.17570-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181105143027.17570-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P194CA0090.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::31) To BL0SPR01MB0020.namprd05.prod.outlook.com
 (2603:10b6:208:72::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5364;6:pLre6wUv2ettZ3mEhrc9sedrPThpPZKf232e3Eo3Do2R4y2I/w2YOYJtzUwBoP9QdTRgwakiTOa0J5qi/syKfxaPp8RWmL0zKM1M+mLfnFIyvwlBaYncNON1RzkODprltfJrtjdHOStKpQSFbw6QukVAjIEjt70pFI/nMkta1B8BIALOaDAffjyog4YUmJwPAErBwx5rO/K0Fhfbs2ho6VHCnExSqDldCxEckyJSfK54NCjjBbrcYo7FkyUFZzLyFcyElrCfMUeFIQIRIBdoFxXp1YruYUuBLisEt8tZpZ4myTPeAl0UizwTh+7jviUX/jiozLTYKphHuvxT1iWovfs1ASbYfIv4OqwJ2rfMEqeLBzVuXeXBKGlV9fmgHxMdphX3PPdLNEnltT47nNtR3ZpoyugSAdS2SAKtmFdft7AC65/edflm2wxWOxKMop3g6w+4AWERr3Oe379OWCCYmw==;5:CrBxTVvp9vD2UvLbOsARhaSj8ctYlFkFQat5HAvLbPESkvTA5gcMZXUPGqhBaeqfWyG54X4e3t8R46WISmnHTN4lBw01+wfGAfANgvYgiAn+/cJHVrGPccxM2IfzvuNDQK7SXFtN6+t1ZBX/+1KPuo1Krj2z/5Ky0vWkqPYtaSk=;7:WOKKdFJ/ogYBg/x0jvsngT7WKC3gL450ppFFkdYQn+1syPmM4GR4qH22ibqpXujWohXVbgVbWItvAJDd55alVHiHTxQwqDSjkMyk6xV//LwuEQ//6c0jXPHAnpnQ3FZfNkOni1gSom8xkZaabMqEkw==
x-ms-office365-filtering-correlation-id: d35a411f-c660-4ac3-8205-08d6432b41ec
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5364;
x-ms-traffictypediagnostic: BL0PR05MB5364:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-prvs: <BL0PR05MB5364DFA6A1DE88BF8BBB8758A3CA0@BL0PR05MB5364.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231382)(944501410)(52105095)(93006095)(93001095)(10201501046)(3002001)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123562045)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:BL0PR05MB5364;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5364;
x-forefront-prvs: 08476BC6EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(396003)(39840400004)(366004)(346002)(189003)(199004)(14454004)(386003)(6506007)(36756003)(5660300001)(102836004)(186003)(2906002)(8936002)(54906003)(110136005)(103116003)(476003)(26005)(81156014)(8676002)(486006)(2616005)(105586002)(446003)(97736004)(11346002)(81166006)(106356001)(6436002)(6512007)(1076002)(6486002)(256004)(14444005)(68736007)(7736002)(6116002)(3846002)(99286004)(4326008)(53936002)(76176011)(305945005)(66066001)(86362001)(316002)(2501003)(107886003)(71190400001)(71200400001)(478600001)(25786009)(52116002)(2900100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5364;H:BL0SPR01MB0020.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: FY6TjrmI81e290lTgNI3IM20uqnVmPMWacsu/x4xGBtcYlS52xekhEecra739G2BnHPwPRI0b8lpF1RQfCNRb9Y/8NqAQIPvfYhRzZ58fnOabvOddvJE2R0cIkxeL+GHmlMUfVVPSyQwrC8nj4ToVqrsAMAWxLmh3XzGgMHyLY9PyBYV1c3ZYBluSeGQQ0hyuxeVMqybfELJ3mCnfu77jyh0W/7Z8HqnPMCleyDldaTmzjAEx26OvFeCmlmpPAg5DcPZMUXH2JyO9RziQcpXInlOV7H5YdDlb3EKgg8ApPCHG1fAed+ACuy79qpcJgz8LRHCj+quft3vHadjEDkt3eLqaL4/MlZd8SgmivFrWh4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d35a411f-c660-4ac3-8205-08d6432b41ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2018 14:30:39.0979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5364
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add phy subcommands to enable/disable AMPDU/AMSDU aggregation.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 nl80211.h |  6 ++++++
 phy.c     | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+
 2 files changed, 66 insertions(+)

diff --git a/nl80211.h b/nl80211.h
index 1766a12..41eec4a 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -2241,6 +2241,9 @@ enum nl80211_commands {
  *	association request when used with NL80211_CMD_NEW_STATION). Can be set
  *	only if %NL80211_STA_FLAG_WME is set.
  *
+ * @NL80211_ATTR_WIPHY_AMPDU_ENABLED: enable/disable AMPDU aggregation.
+ * @NL80211_ATTR_WIPHY_AMSDU_ENABLED: enable/disable AMSDU aggregation.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2682,6 +2685,9 @@ enum nl80211_attrs {
=20
 	NL80211_ATTR_HE_CAPABILITY,
=20
+	NL80211_ATTR_WIPHY_AMPDU_ENABLED,
+	NL80211_ATTR_WIPHY_AMSDU_ENABLED,
+
 	/* add attributes here, update the policy in nl80211.c */
=20
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/phy.c b/phy.c
index 77df7a7..be949e7 100644
--- a/phy.c
+++ b/phy.c
@@ -843,3 +843,63 @@ static int handle_get_txq(struct nl80211_state *state,
 COMMAND(get, txq, "",
 	NL80211_CMD_GET_WIPHY, 0, CIB_PHY, handle_get_txq,
 	"Get TXQ parameters.");
+
+static int handle_ampdu(struct nl80211_state *state,
+			struct nl_msg *msg,
+			int argc, char **argv,
+			enum id_input id)
+{
+	unsigned int ampdu;
+
+	if (argc !=3D 1)
+		return 1;
+
+	if (strcmp(argv[0], "on") =3D=3D 0)
+		ampdu =3D 1;
+	else if (strcmp(argv[0], "off") =3D=3D 0)
+		ampdu =3D 0;
+	else {
+		printf("Invalid parameter: %s\n", argv[0]);
+		return 2;
+	}
+
+	NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_AMPDU_ENABLED, ampdu);
+
+	return 0;
+
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(set, ampdu, "<on|off>",
+	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_ampdu,
+	"Enable/disable AMPDU aggregation.");
+
+static int handle_amsdu(struct nl80211_state *state,
+			struct nl_msg *msg,
+			int argc, char **argv,
+			enum id_input id)
+{
+	unsigned int amsdu;
+
+	if (argc !=3D 1)
+		return 1;
+
+	if (strcmp(argv[0], "on") =3D=3D 0)
+		amsdu =3D 1;
+	else if (strcmp(argv[0], "off") =3D=3D 0)
+		amsdu =3D 0;
+	else {
+		printf("Invalid parameter: %s\n", argv[0]);
+		return 2;
+	}
+
+	NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_AMSDU_ENABLED, amsdu);
+
+	return 0;
+
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(set, amsdu, "<on|off>",
+	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_amsdu,
+	"Enable/disable AMSDU aggregation.");
--=20
2.11.0

