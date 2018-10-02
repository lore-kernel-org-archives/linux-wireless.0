Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 327BEC004D2
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC1DE20878
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="ycPFzqvl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC1DE20878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbeJBQIc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 12:08:32 -0400
Received: from mail-by2nam01on0054.outbound.protection.outlook.com ([104.47.34.54]:16160
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726691AbeJBQIb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 12:08:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zt/lgleD8/5SijlzkJyFoeSzS1Tc7zK72G9fiWAOQoY=;
 b=ycPFzqvlw29+Fz5CBQWM5ghQjGwQEaK/jvsz2dcB4Rv/BNKpGwXJ1PyGo4+Z/6jf42JAW9Jc/6fnl6UBbicqksIuG4pySL79wdCau/sLZHHxS2jFfAoD7XBLxWdj2otWlJT4vwuaWHFBgOSzstjQbjnV1be9MALAzsWlX/rPC8U=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB5266.namprd05.prod.outlook.com (20.177.242.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.11; Tue, 2 Oct 2018 09:26:05 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a%3]) with mapi id 15.20.1185.024; Tue, 2 Oct 2018
 09:26:05 +0000
From:   Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko OS <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 09/13] qtnfmac: drop error reports for out-of-bounds key
 indexes
Thread-Topic: [PATCH 09/13] qtnfmac: drop error reports for out-of-bounds key
 indexes
Thread-Index: AQHUWjHx6tCrsuhTlkm5jgQ845x/yA==
Date:   Tue, 2 Oct 2018 09:26:05 +0000
Message-ID: <20181002092542.18966-10-sergey.matyukevich.os@quantenna.com>
References: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR06CA0023.eurprd06.prod.outlook.com
 (2603:10a6:206:2::36) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5266;6:poqpKyqx0IcOrvDXiDflLrtVwU63+L96pR06PhTn2LFXOGSHPA6Z47N8EvnEGExcJWWVaPOvec2PyiW3ChpsmOHalj5xy3IQZKCdo8Ds/c4WlZHy9d+1ThDi4U8QfOu1qyVJVG/PYUmzn2oZLh5SRW99stPKkjmvxFMNcZQDqlWgiKcVTedU3+scIWBdXB3G7+sLvQ0ps3rzql9AeJyqx/quPG+XxqbpUVV+S3T6F5q4Bcm4vq+sp8/WIALo/RPWoaeaZaOK92AsH/dzXdeWONDTOhLkrShZJjUHL5HJGWJFUUWtw9cEuoEtAWFMIY/voHtTThCuNpiiX2VQapSh6LXHkduyDBDiNMLDreWox38HYHfFmZSVAszH87ydTLPJwdY1AcBkoMe/L2SicOAEEAOUhwvBVvoI7xLV2thNPGJ3tXP9Ds3PK2IoixcV86UcM7qbpW9nzl7iIf5UrSm9hg==;5:KJxGxqNO5xk2BKBDRQHgaiJwa8sDctSeDnrRrnEYronGDtRNvy88Aj2sRAJQfRPn/1u98pBGNOHfvi7k+jAz9LijwJvH+AciNeRL0dQ18uZ2SZBWVUJpaMpWQVXrRywBdef+eW+VW4Xxh3l1LoFYhPPXduZPver0SXbEkgGIVvg=;7:Am9f54qupl/zcka3UlrD9fsFE2vN9azJ5/GKsU0b9IsVjX+1wrGtFuYXP322lajdkDyEC4TsMl5qGs+uqCFZOMeV1Roz9fWE3uoTrqIYUYQQrLGp+rUfunY01FSRN7Qp+bniAWWDOBYKJW0o+qB0nqs+8l5z8I7mnNOauybQIjvPlrAdN7FmII7WyNgW7VCHuiFviQldvbbrPs7+3nWJ2auuynVj+0Gth4HGjGzlMWieUUbHcWxoNHWrcYgZPMYz
x-ms-office365-filtering-correlation-id: 1d8cbb31-0c80-4da9-0500-08d6284913d2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5266;
x-ms-traffictypediagnostic: BL0PR05MB5266:
x-microsoft-antispam-prvs: <BL0PR05MB5266095C2A005550B935DED7A3E80@BL0PR05MB5266.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(20558992708506);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231355)(944501410)(52105095)(3002001)(10201501046)(149066)(150057)(6041310)(20161123564045)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051);SRVR:BL0PR05MB5266;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5266;
x-forefront-prvs: 0813C68E65
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(376002)(39850400004)(136003)(396003)(199004)(189003)(1076002)(316002)(105586002)(186003)(305945005)(11346002)(3846002)(486006)(5640700003)(256004)(6512007)(6436002)(8936002)(14454004)(476003)(36756003)(2351001)(106356001)(2616005)(81156014)(14444005)(66066001)(81166006)(86362001)(54906003)(446003)(575784001)(68736007)(6116002)(5250100002)(107886003)(5660300001)(25786009)(71190400001)(6916009)(99286004)(2906002)(71200400001)(26005)(102836004)(2501003)(6506007)(386003)(52116002)(76176011)(478600001)(97736004)(103116003)(8676002)(6486002)(2900100001)(7736002)(4326008)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5266;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 8UOK6CetEU4E42Yued87RzeoV38ldU0WF4ZjhArnaf6K5TSRBsHSpvhIoho+OK943kgJGJJd6OJbTuwS25aUfOvVgcpmEsihHmgbeI1EjsUSJyLLtoKy8KB56Rst3jA3zPqlvzDMVKKPwbV+nPiSWvSpQoOGAHEIWTNT9K5LjWxk1AoDlzndZ+Id1VHIEM3QuTwuMwkFTWwpdVYgSzAZeb8NPsBFnHddYRO02YP8/ufchB7wO1RpLy1J4hZqJMqMxJZu9Qkdw9BCXQQ/C1nFWnI7pcgZBpb+9ouLktZK1nAu/GvyisagGnxeDPYY3QCIWWgtdu+ARr3asyYqXDq6m5SpWWKdFjW84e6nINHT2qY=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d8cbb31-0c80-4da9-0500-08d6284913d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2018 09:26:05.4121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5266
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On disconnect wireless core attempts to remove all the supported keys.
Following cfg80211_ops conventions, firmware returns -ENOENT code
for the out-of-bound key indexes. This is a normal behavior,
so no need to report errors for this case.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index 8ecd37ddc0f9..9845cf287118 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -523,9 +523,16 @@ static int qtnf_del_key(struct wiphy *wiphy, struct ne=
t_device *dev,
 	int ret;
=20
 	ret =3D qtnf_cmd_send_del_key(vif, key_index, pairwise, mac_addr);
-	if (ret)
-		pr_err("VIF%u.%u: failed to delete key: idx=3D%u pw=3D%u\n",
-		       vif->mac->macid, vif->vifid, key_index, pairwise);
+	if (ret) {
+		if (ret =3D=3D -ENOENT) {
+			pr_debug("VIF%u.%u: key index %d out of bounds\n",
+				 vif->mac->macid, vif->vifid, key_index);
+		} else {
+			pr_err("VIF%u.%u: failed to delete key: idx=3D%u pw=3D%u\n",
+			       vif->mac->macid, vif->vifid,
+			       key_index, pairwise);
+		}
+	}
=20
 	return ret;
 }
--=20
2.11.0

