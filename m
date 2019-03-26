Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF1FC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 09:28:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E8B120856
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 09:28:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="bzfwRRAC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbfCZJ2b (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 05:28:31 -0400
Received: from mail-eopbgr770041.outbound.protection.outlook.com ([40.107.77.41]:20345
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726178AbfCZJ2b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 05:28:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=blsgRJeJzA7v4POqZ/4kqpwp3Z+4SDpGw/9V+Q04+jY=;
 b=bzfwRRACRe3JzBOWNwtmtoTt3En3RDmKcPTfVbUeNVNqkZZTw6HyVx40ep4YGjvxif8NTqowfgRR7OpQS2wjqthT/zSEeIL6Ox91Ylf0H+9ETSMak82asBjD9iAJw5SduyhxgsPhwJj54cvt4F2qYT1GELOq0dm2jWTEbDSIghI=
Received: from DM6PR05MB5787.namprd05.prod.outlook.com (20.178.25.96) by
 DM6PR05MB6539.namprd05.prod.outlook.com (20.178.226.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.13; Tue, 26 Mar 2019 09:28:15 +0000
Received: from DM6PR05MB5787.namprd05.prod.outlook.com
 ([fe80::8c80:7be5:eb8f:a653]) by DM6PR05MB5787.namprd05.prod.outlook.com
 ([fe80::8c80:7be5:eb8f:a653%3]) with mapi id 15.20.1750.010; Tue, 26 Mar 2019
 09:28:15 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5181.namprd05.prod.outlook.com (20.177.249.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.14; Tue, 26 Mar 2019 09:27:37 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1750.014; Tue, 26 Mar 2019
 09:27:37 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2] mac80211/cfg80211: update bss channel on channel switch
Thread-Topic: [PATCH v2] mac80211/cfg80211: update bss channel on channel
 switch
Thread-Index: AQHU47YmKyfRpWtdvESokLuefZkwqQ==
Date:   Tue, 26 Mar 2019 09:27:37 +0000
Message-ID: <20190326092730.32511-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:a03:74::22) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.11.0
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84918f2b-7552-4f9f-2631-08d6b1cd48b7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5181;
x-ms-traffictypediagnostic: SN6PR05MB5181:|DM6PR05MB6539:
x-moderation-data: 3/26/2019 9:28:14 AM
x-microsoft-antispam-prvs: <DM6PR05MB6539C84A57376322AD865B40A35F0@DM6PR05MB6539.namprd05.prod.outlook.com>
x-forefront-prvs: 09888BC01D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(366004)(39850400004)(376002)(136003)(199004)(189003)(53936002)(25786009)(6486002)(66066001)(2351001)(6916009)(8676002)(305945005)(2906002)(81156014)(186003)(26005)(386003)(6506007)(103116003)(1076003)(71200400001)(3846002)(6116002)(8936002)(107886003)(71190400001)(15650500001)(5640700003)(5660300002)(99286004)(4326008)(102836004)(68736007)(81166006)(6436002)(52116002)(54906003)(50226002)(316002)(486006)(478600001)(2616005)(14454004)(97736004)(6512007)(476003)(7736002)(106356001)(256004)(14444005)(105586002)(2501003)(36756003)(86362001)(6346003)(436003)(21314003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB6539;H:DM6PR05MB5787.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: otoylp1QTDzNhwkH/JScn+6wtCCbqAWwIwiBTVaXoehiyGfCEcVdf3BG8jj0odkD6CohGgNXt1Q1NWml8Td3LseM+1ABUBs9whmxeFbLmxWUH3ZDirt41MwFkcpfFJM/126b+wi2w9pXDnKHY0XortR3LfJUuMbA4rfKi4Z8A5t0QXQBei0PlwUCS6Ecgos8baTQJCs73e0u4AAM6z2IcScyLdkpdQ29H8UK8Dq2Yc2/AhAIHvI7L4b9qQ/SdfFUJvOhg6ykGPoTA5iJs7CFPeet9lGMMnPhPyBr3BVM7A45eoeqFUZ4l3w2gys6TMdTNrUnTbYBq0MqRgSR4uOjaD5ZTEI8Ng6VTbuJerjmEA7os6vmvV5fGTJv2+DBBZ4EukQ99Qw37OvSU/JQI03126fd9ZBCu1yK6R7eLF1aTak=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84918f2b-7552-4f9f-2631-08d6b1cd48b7
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2019 09:28:15.6249
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB6539
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

FullMAC STAs have no way to update bss channel after CSA channel switch
completion. As a result, user-space tools may provide inconsistent
channel info. For instance, consider the following two commands:
$ sudo iw dev wlan0 link
$ sudo iw dev wlan0 info
The latter command gets channel info from the hardware, so most probably
its output will be correct. However the former command gets channel info
from scan cache, so its output will contain outdated channel info.
In fact, current bss channel info will not be updated until the
next [re-]connect.

Note that mac80211 STAs have a workaround for this, but it requires
access to internal cfg80211 data, see ieee80211_chswitch_work:

	/* XXX: shouldn't really modify cfg80211-owned data! */
	ifmgd->associated->channel =3D sdata->csa_chandef.chan;

This patch suggests to convert mac80211 workaround into cfg80211 behavior
and to update current bss channel in cfg80211_ch_switch_notify.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

---
v1 -> v2:
- as per suggestion by Johannes, use !WARN_ON(!wdev->current_bss)


---
 net/mac80211/mlme.c    | 3 ---
 net/wireless/nl80211.c | 5 +++++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2dbcf5d5512e..b7a9fe3d5fcb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1188,9 +1188,6 @@ static void ieee80211_chswitch_work(struct work_struc=
t *work)
 		goto out;
 	}
=20
-	/* XXX: shouldn't really modify cfg80211-owned data! */
-	ifmgd->associated->channel =3D sdata->csa_chandef.chan;
-
 	ifmgd->csa_waiting_bcn =3D true;
=20
 	ieee80211_sta_reset_beacon_monitor(sdata);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 25a9e3b5c154..b108b635e2f3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -15721,6 +15721,11 @@ void cfg80211_ch_switch_notify(struct net_device *=
dev,
=20
 	wdev->chandef =3D *chandef;
 	wdev->preset_chandef =3D *chandef;
+
+	if (wdev->iftype =3D=3D NL80211_IFTYPE_STATION &&
+	    !WARN_ON(!wdev->current_bss))
+		wdev->current_bss->pub.channel =3D chandef->chan;
+
 	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL,
 				 NL80211_CMD_CH_SWITCH_NOTIFY, 0);
 }
--=20
2.11.0

