Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A84D7C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:20:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DAE3218A5
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:20:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="qAzQaV1W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbfCUPUA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:20:00 -0400
Received: from mail-eopbgr800044.outbound.protection.outlook.com ([40.107.80.44]:61696
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728450AbfCUPUA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 11:20:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OEWWG+0vDWf/W9ghICwFT4HrgYCM42b/438R60tl24=;
 b=qAzQaV1W4mpRYBDXyeBqpTy9zWgxMZzLmWa8VAWRk3B5kMmg0vke1dztfNUoIP96wNsSpZu8kiNM7RPUO6Cy06Qv2KOKq1DYn32sT6dGH1CAKB97+Dx7Kd6KVZ3K+9kuqn3S+rzA8PGlQKmDqFKet2EyKXKxpZjf8EiGwK9ylec=
Received: from SN6PR05MB4829.namprd05.prod.outlook.com (52.135.116.223) by
 SN6PR05MB4576.namprd05.prod.outlook.com (52.135.75.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.13; Thu, 21 Mar 2019 15:19:55 +0000
Received: from SN6PR05MB4829.namprd05.prod.outlook.com
 ([fe80::2122:4a42:1c47:af8a]) by SN6PR05MB4829.namprd05.prod.outlook.com
 ([fe80::2122:4a42:1c47:af8a%4]) with mapi id 15.20.1709.017; Thu, 21 Mar 2019
 15:19:55 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4608.namprd05.prod.outlook.com (52.135.114.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.16; Thu, 21 Mar 2019 15:19:23 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1709.015; Thu, 21 Mar 2019
 15:19:23 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [RFC PATCH] mac80211/cfg80211: update bss channel on channel switch
Thread-Topic: [RFC PATCH] mac80211/cfg80211: update bss channel on channel
 switch
Thread-Index: AQHU3/l2XQWEB+dp8EKEtVdAAxdJ3A==
Date:   Thu, 21 Mar 2019 15:19:22 +0000
Message-ID: <20190321151915.16826-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0089.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::30) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.11.0
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65413dbf-afe3-49a7-d33d-08d6ae1098a4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4608;
x-ms-traffictypediagnostic: SN6PR05MB4608:|SN6PR05MB4576:
x-moderation-data: 3/21/2019 3:19:49 PM
x-microsoft-antispam-prvs: <SN6PR05MB4576E91FBEF57E9310A4B2D4A3420@SN6PR05MB4576.namprd05.prod.outlook.com>
x-forefront-prvs: 0983EAD6B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(346002)(39850400004)(376002)(136003)(199004)(189003)(68736007)(2501003)(14444005)(316002)(99286004)(256004)(54906003)(305945005)(86362001)(6116002)(3846002)(97736004)(486006)(2616005)(436003)(1076003)(5660300002)(476003)(81156014)(26005)(8936002)(50226002)(386003)(71190400001)(6506007)(102836004)(14454004)(186003)(5640700003)(52116002)(15650500001)(478600001)(8676002)(103116003)(2906002)(53936002)(6512007)(66066001)(4326008)(7736002)(107886003)(25786009)(6916009)(36756003)(2351001)(6436002)(71200400001)(105586002)(6486002)(106356001)(81166006)(21314003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB4576;H:SN6PR05MB4829.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:3;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PAbMH/UGCT3pF/yPqjt56INAQfezoekXQsHvsbY4PFMa2b4kvEjZexUoNFW7ySb2A8tX6jTE3ioihvrnczLGVW5DlJvKlQeBXYFueuD7Yh2nn0Dw9tk6tkzoipqCNrJMlNyKt/Gd5gxVYT1g7Y5FtuLNGOHuGXkPOq+JPvLpMuWpK6c8tLTIqbWGyzcYLy/ySwkBlTMMmuul3NgAQu5qEkJtUPoC4fLTO2riuAhiu0gJOL9/hfdV7OxQYFBB/RNKRxXecVwK3BFUzvzzxOEtmn6yxD9QSmHeWpByNv3NDyAdcgP3SZAGDN5eVA+nGHJ7SQW/FhJMxep4gN1SrhHQsjn2e8F2ghNxicrNdl89DwDNf7qr5RMt9QY7ZhHLON3h8uNc8TUhJDeeQ0J9Wy/tnxEQJ+2eJHXWig+NwZ3SNqA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65413dbf-afe3-49a7-d33d-08d6ae1098a4
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2019 15:19:55.5794
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB4576
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

This patch suggests to convert mac80211 workaround to cfg80211 behavior
and to update current bss channel in cfg80211_ch_switch_notify.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

---

This issue has been observed for both qtnfmac and brcmfmac. Fix tested
for qtnfmac and iwlwifi, to make sure there is no regression for mac80211.
However this is not going to be enough to fix brcmfmac behavior as it
does not use cfg80211_ch_switch_notify. This issue may also affect
ath6kl and mwifiex, but I have no hardware to check.

---
 net/mac80211/mlme.c    | 3 ---
 net/wireless/nl80211.c | 6 ++++++
 2 files changed, 6 insertions(+), 3 deletions(-)

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
index 25a9e3b5c154..1ca6930ddac0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -15721,6 +15721,12 @@ void cfg80211_ch_switch_notify(struct net_device *=
dev,
=20
 	wdev->chandef =3D *chandef;
 	wdev->preset_chandef =3D *chandef;
+
+	if (wdev->iftype =3D=3D NL80211_IFTYPE_STATION) {
+		if (wdev->current_bss)
+			wdev->current_bss->pub.channel =3D chandef->chan;
+	}
+
 	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL,
 				 NL80211_CMD_CH_SWITCH_NOTIFY, 0);
 }
--=20
2.11.0

