Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB280C46475
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:30:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76C2E20819
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:30:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="BnLPW1K4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 76C2E20819
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbeKEXuk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 18:50:40 -0500
Received: from mail-dm3nam03on0043.outbound.protection.outlook.com ([104.47.41.43]:12752
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726774AbeKEXuj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 18:50:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=apo12a22KIma6l5iFRtASuYNWMwrZi2UaKYhjOuUjAo=;
 b=BnLPW1K40XZ8nIScwbfiGC6QQ4gxi0bqFonSsVooqWqnA9CG2ymkrgxJ6Qbdf4UK1Z/WHClTicXsYaJ6vWHMwaYNNFmC/LnQ0IjM56lEpiqboyQw7UnKMIQRLttmj+M9tC5NINgV2AtpDjn3QZf1SvfXvPiewOra3QXwb2KHJHI=
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com (20.177.146.138) by
 BL0SPR01MB0022.namprd05.prod.outlook.com (20.177.146.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.12; Mon, 5 Nov 2018 14:30:37 +0000
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8]) by BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8%3]) with mapi id 15.20.1294.028; Mon, 5 Nov 2018
 14:30:37 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
CC:     Jouni Malinen <j@w1.fi>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [RFC 1/3] cfg80211/nl80211: add wiphy flags to control aggregation
Thread-Topic: [RFC 1/3] cfg80211/nl80211: add wiphy flags to control
 aggregation
Thread-Index: AQHUdRQezeKXmhfygk2dUrkbNZGWyQ==
Date:   Mon, 5 Nov 2018 14:30:37 +0000
Message-ID: <20181105143027.17570-2-sergey.matyukevich.os@quantenna.com>
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
x-microsoft-exchange-diagnostics: 1;BL0SPR01MB0022;6:qtylVwMZadsIK8wnWupJXkLTrPExclfb3902v7ZV94NOCUPgmZK8U7ikkuW4Mrqc9GgP+4+CHNY4fuD62yfrymd1HNYcPyZ2NGiE9ZPI/proLwl5HGna8tvLNFUJF8PNKMr/KYPS4/YB6PGNKHguFGWqnqBwkmpjcPcn54mV1bBaQIK7wC+DatUWNInlelXhyj//u+7NpeCzIfrxTC/Wkbj7QnrDHmkLgff70/845rmbg4aMD5yg7dqNMomltkEmyqmNoPH5FMQreznhgNTguMfYz+Gi93Jju/B+4QOsOXmcGW4G2THc1mzKG7koNEhZ0+ZKXRpcUxzaS7eyijIA3xfOOs9X0fq6S1X2XOg2+wI1iO1ahyBMeRV09x+GIZXwBEKI2GbB46b3h6DmquDMI+jwcdcL7wlYuF8C2RQfIEMEdCfjN19u8cDsGkBhaWV8Hu3MzlgSDmN8fFVmXmkvbQ==;5:zDqFAwC2K8IxvvD1Znjf9QrITQh1XYEp1hjdykWLXRdRRYorTfHA+qu70KkT+FEpw4YGkWGcPvJvb6at7BNXWxdDS8HpAv+9yzJIBKJ8FgRiHl/SfEfEj0R4vYMgosfs1IROYivvdRWwmOYOSK4nJ0gvFL6+iD3KWGfXPeu9pik=;7:heWrWM14Pz2HeqYQmvIcr69AE+7Cw08wEXJV8Jj7tTb6h/hYCr0yzcWoPO8uXn1V2A7sV/HT/J192JdwnA54Cqf9bczCMli9kvsjjLTvTJ0Ib3U+X+W1U+tVKDYA4fAeGwqwHCxl6GdVnm/RMZsfCg==
x-ms-office365-filtering-correlation-id: 7e5a8a1e-bfd2-47a1-aafc-08d6432b410a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0SPR01MB0022;
x-ms-traffictypediagnostic: BL0SPR01MB0022:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-prvs: <BL0SPR01MB0022478549A0D443932ABBC5A3CA0@BL0SPR01MB0022.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231382)(944501410)(52105095)(3002001)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(20161123560045)(20161123558120)(20161123562045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BL0SPR01MB0022;BCL:0;PCL:0;RULEID:;SRVR:BL0SPR01MB0022;
x-forefront-prvs: 08476BC6EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(39840400004)(396003)(376002)(136003)(199004)(189003)(1076002)(99286004)(4326008)(68736007)(6116002)(3846002)(7736002)(76176011)(305945005)(53936002)(256004)(6486002)(14444005)(52116002)(478600001)(25786009)(71200400001)(2900100001)(66066001)(71190400001)(107886003)(86362001)(316002)(2501003)(110136005)(103116003)(8936002)(54906003)(6506007)(386003)(5660300001)(36756003)(14454004)(186003)(102836004)(2906002)(11346002)(106356001)(105586002)(446003)(97736004)(6436002)(6512007)(26005)(81166006)(476003)(81156014)(8676002)(2616005)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0SPR01MB0022;H:BL0SPR01MB0020.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: jmgvIn7rV2IHqaC/TGS7UaLChLTZeKu5SWv8XcRcNLHlr9VNZMlIuTBzsoxFxifbtYb/76nZ4EwqgxWioDb4dUfvMtObg9j8wLaUeINPJ1FXCUqxzk/3a6K5MyqeliE2cRQLqRmDFXGy1GfSmiE9pcUIGkCqQxcKQ663g1AwCsmJhT2PKg4QWG0Ye1SdpbRszb7rIyUdn8o4oc9hsLzKcw+AsDD9IQmzJRGOUgLdRVN00ueGbmt/cVCyrSY56kv9X6LtDUJTrR/F3lT/H3SSAY1gn70oYeSU/xPSPE8DqInZ94aV/N5zmf3aa2EVXITcXCUDDZjXxFPK4Zj2muyLhBXNJwqZQTdk5az5vaHtFA4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e5a8a1e-bfd2-47a1-aafc-08d6432b410a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2018 14:30:37.7329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0SPR01MB0022
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add two top-level switches to wiphy structure to control AMSDU and AMPDU
aggregation. Enable read/update of AMSDU and AMPDU aggregation from
the userspace using set_wiphy/get_wiphy commands.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 include/net/cfg80211.h       |  7 +++++++
 include/uapi/linux/nl80211.h |  6 ++++++
 net/wireless/core.c          |  3 +++
 net/wireless/nl80211.c       | 31 +++++++++++++++++++++++++++++++
 4 files changed, 47 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1fa41b7a1be3..fbf01d156069 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2368,6 +2368,8 @@ enum cfg80211_connect_params_changed {
  * @WIPHY_PARAM_TXQ_LIMIT: TXQ packet limit has been changed
  * @WIPHY_PARAM_TXQ_MEMORY_LIMIT: TXQ memory limit has been changed
  * @WIPHY_PARAM_TXQ_QUANTUM: TXQ scheduler quantum
+ * @WIPHY_PARAM_AMPDU_ENABLED: wiphy->ampdu_enabled has changed
+ * @WIPHY_PARAM_AMSDU_ENABLED: wiphy->amsdu_enabled has changed
  */
 enum wiphy_params_flags {
 	WIPHY_PARAM_RETRY_SHORT		=3D 1 << 0,
@@ -2379,6 +2381,8 @@ enum wiphy_params_flags {
 	WIPHY_PARAM_TXQ_LIMIT		=3D 1 << 6,
 	WIPHY_PARAM_TXQ_MEMORY_LIMIT	=3D 1 << 7,
 	WIPHY_PARAM_TXQ_QUANTUM		=3D 1 << 8,
+	WIPHY_PARAM_AMPDU_ENABLED	=3D 1 << 9,
+	WIPHY_PARAM_AMSDU_ENABLED	=3D 1 << 10,
 };
=20
 /**
@@ -4163,6 +4167,9 @@ struct wiphy {
 	u32 txq_memory_limit;
 	u32 txq_quantum;
=20
+	u8 ampdu_enabled;
+	u8 amsdu_enabled;
+
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
=20
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 6d610bae30a9..a9f8fa814ecd 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2254,6 +2254,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_FTM_RESPONDER_STATS: Nested attribute with FTM responder
  *	statistics, see &enum nl80211_ftm_responder_stats.
  *
+ * @NL80211_ATTR_WIPHY_AMPDU_ENABLED: enable/disable AMPDU aggregation.
+ * @NL80211_ATTR_WIPHY_AMSDU_ENABLED: enable/disable AMSDU aggregation.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2699,6 +2702,9 @@ enum nl80211_attrs {
=20
 	NL80211_ATTR_FTM_RESPONDER_STATS,
=20
+	NL80211_ATTR_WIPHY_AMPDU_ENABLED,
+	NL80211_ATTR_WIPHY_AMSDU_ENABLED,
+
 	/* add attributes here, update the policy in nl80211.c */
=20
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5bd01058b9e6..182f8f04166d 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -524,6 +524,9 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *o=
ps, int sizeof_priv,
 	rdev->wiphy.max_sched_scan_plans =3D 1;
 	rdev->wiphy.max_sched_scan_plan_interval =3D U32_MAX;
=20
+	rdev->wiphy.ampdu_enabled =3D 1;
+	rdev->wiphy.amsdu_enabled =3D 1;
+
 	return &rdev->wiphy;
 }
 EXPORT_SYMBOL(wiphy_new_nm);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 744b5851bbf9..5c04b6996e64 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -497,6 +497,9 @@ static const struct nla_policy nl80211_policy[NUM_NL802=
11_ATTR] =3D {
 		.type =3D NLA_NESTED,
 		.validation_data =3D nl80211_ftm_responder_policy,
 	},
+
+	[NL80211_ATTR_WIPHY_AMPDU_ENABLED] =3D { .type =3D NLA_U8 },
+	[NL80211_ATTR_WIPHY_AMSDU_ENABLED] =3D { .type =3D NLA_U8 },
 };
=20
 /* policy for the key attributes */
@@ -2118,6 +2121,14 @@ static int nl80211_send_wiphy(struct cfg80211_regist=
ered_device *rdev,
 				goto nla_put_failure;
 		}
=20
+		if (nla_put_u8(msg, NL80211_ATTR_WIPHY_AMPDU_ENABLED,
+			       rdev->wiphy.ampdu_enabled))
+			goto nla_put_failure;
+
+		if (nla_put_u8(msg, NL80211_ATTR_WIPHY_AMSDU_ENABLED,
+			       rdev->wiphy.amsdu_enabled))
+			goto nla_put_failure;
+
 		/* done */
 		state->split_start =3D 0;
 		break;
@@ -2514,6 +2525,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, str=
uct genl_info *info)
 	u32 frag_threshold =3D 0, rts_threshold =3D 0;
 	u8 coverage_class =3D 0;
 	u32 txq_limit =3D 0, txq_memory_limit =3D 0, txq_quantum =3D 0;
+	u8 amsdu =3D 0, ampdu =3D 0;
=20
 	ASSERT_RTNL();
=20
@@ -2743,11 +2755,22 @@ static int nl80211_set_wiphy(struct sk_buff *skb, s=
truct genl_info *info)
 		changed |=3D WIPHY_PARAM_TXQ_QUANTUM;
 	}
=20
+	if (info->attrs[NL80211_ATTR_WIPHY_AMPDU_ENABLED]) {
+		ampdu =3D nla_get_u8(info->attrs[NL80211_ATTR_WIPHY_AMPDU_ENABLED]);
+		changed |=3D WIPHY_PARAM_AMPDU_ENABLED;
+	}
+
+	if (info->attrs[NL80211_ATTR_WIPHY_AMSDU_ENABLED]) {
+		amsdu =3D nla_get_u8(info->attrs[NL80211_ATTR_WIPHY_AMSDU_ENABLED]);
+		changed |=3D WIPHY_PARAM_AMSDU_ENABLED;
+	}
+
 	if (changed) {
 		u8 old_retry_short, old_retry_long;
 		u32 old_frag_threshold, old_rts_threshold;
 		u8 old_coverage_class;
 		u32 old_txq_limit, old_txq_memory_limit, old_txq_quantum;
+		u8 old_amsdu, old_ampdu;
=20
 		if (!rdev->ops->set_wiphy_params)
 			return -EOPNOTSUPP;
@@ -2760,6 +2783,8 @@ static int nl80211_set_wiphy(struct sk_buff *skb, str=
uct genl_info *info)
 		old_txq_limit =3D rdev->wiphy.txq_limit;
 		old_txq_memory_limit =3D rdev->wiphy.txq_memory_limit;
 		old_txq_quantum =3D rdev->wiphy.txq_quantum;
+		old_ampdu =3D rdev->wiphy.ampdu_enabled;
+		old_amsdu =3D rdev->wiphy.amsdu_enabled;
=20
 		if (changed & WIPHY_PARAM_RETRY_SHORT)
 			rdev->wiphy.retry_short =3D retry_short;
@@ -2777,6 +2802,10 @@ static int nl80211_set_wiphy(struct sk_buff *skb, st=
ruct genl_info *info)
 			rdev->wiphy.txq_memory_limit =3D txq_memory_limit;
 		if (changed & WIPHY_PARAM_TXQ_QUANTUM)
 			rdev->wiphy.txq_quantum =3D txq_quantum;
+		if (changed & WIPHY_PARAM_AMPDU_ENABLED)
+			rdev->wiphy.ampdu_enabled =3D ampdu;
+		if (changed & WIPHY_PARAM_AMSDU_ENABLED)
+			rdev->wiphy.amsdu_enabled =3D amsdu;
=20
 		result =3D rdev_set_wiphy_params(rdev, changed);
 		if (result) {
@@ -2788,6 +2817,8 @@ static int nl80211_set_wiphy(struct sk_buff *skb, str=
uct genl_info *info)
 			rdev->wiphy.txq_limit =3D old_txq_limit;
 			rdev->wiphy.txq_memory_limit =3D old_txq_memory_limit;
 			rdev->wiphy.txq_quantum =3D old_txq_quantum;
+			rdev->wiphy.ampdu_enabled =3D old_ampdu;
+			rdev->wiphy.amsdu_enabled =3D old_amsdu;
 			return result;
 		}
 	}
--=20
2.11.0

