Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F83C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0261D20645
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:12:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="iE2JyTRa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0261D20645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbeJERKf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 13:10:35 -0400
Received: from mail-eopbgr730044.outbound.protection.outlook.com ([40.107.73.44]:44960
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727616AbeJERKf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 13:10:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T1F0TlLn2H9HbN2VKELFtZRc8OrpRs/JOxS8pban2oE=;
 b=iE2JyTRak5ehX1uFhZNJTaz4gctr2mxQ8kH+eErkhpZRIN2gEDD2E7oDrHL0GpZsqaJRo4yNf8FAdxmOvlF5TnlMdfJyC45lh5hKiV+gMKxu8rqJHhW447vDW8TUG+9jShqqA8T3wdQ9gKiH2FiGtps/lj2Mpms9oHq/Kl6yBeo=
Received: from BYAPR05MB4597.namprd05.prod.outlook.com (52.135.233.18) by
 BYAPR05MB4439.namprd05.prod.outlook.com (52.135.203.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.13; Fri, 5 Oct 2018 10:11:43 +0000
Received: from BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373]) by BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373%4]) with mapi id 15.20.1207.021; Fri, 5 Oct 2018
 10:11:43 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 11/13] qtnfmac: add support for scan dwell time
 configuration
Thread-Topic: [PATCH v2 11/13] qtnfmac: add support for scan dwell time
 configuration
Thread-Index: AQHUXJPQzn6p77khMkWBr5XA3foRSw==
Date:   Fri, 5 Oct 2018 10:11:43 +0000
Message-ID: <20181005101114.3013-12-sergey.matyukevich.os@quantenna.com>
References: <20181005101114.3013-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181005101114.3013-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5P194CA0013.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:203:8f::23) To BYAPR05MB4597.namprd05.prod.outlook.com
 (2603:10b6:a03:4c::18)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR05MB4439;6:IR5tyjQyk1kIFVFpw9C3w39MqifREfsi6EMMCwXKyDwYPU1krpp1nDY5gIydUyD9ckqOf107C+8dSKiDhqPBDmPRn06LT6NwM+Cf7R8C2f0fK1Ry1rRz3EDtHW3/c9cL7u12QACtgJUPVmgf1qhq2bQCBD8Wy1w0LAjQj8C+9ARliqdOcepdSr4K/BnyTmlS7UdgTk5hi9UsbO7Y4SSPLcgkqd/eAX+TH2Fp3paH1V7INf5GYDFrlbQQNAAncFSGpbnpgfS2Nzn4oz6Q5acmYbJpfDqYTNsBo6qYpwat4MMWJ/RGJUEyZOow5jLXc5GoyvLMqRnGymZjSEiMHpb/TVpeQiSbVHVQZLe7w0nDKnENA0H0+xum8omj9bsYP7X8PKEctVDWVxAGpXTtMGUPnM6WqBtLmlx6Y56/2xAsV5z7zUgBX+Mjzt08CuH/mZsNQIKYDvhw4MmeXD6/Ul1NIg==;5:d21z9cSJz2dxwefkeUtXBkUHrKxtVEon/rJ3LDzugIs30dreZTMyAj3P5JglXdMPD4ds9JnFSSVkFL5MOWAvu+FNjb4mJoU5OOBcGwXxdHOll97uNJA0Le3ARFQ9rct6subeMXd7bLaPLU+SOEGHbThmFzVjHwuu1ZqqgYYq/F0=;7:8veG8LBKOKtA8YjB4r0poXCGnsGqZAa23ZsMEs6g1XkqdeTn3I1qs820MDiwBXDCP16YQo15aaipC7d6FHcbqhSFLbl4eR3HNtVbyHuuv/2Arynkn+3473b3xdgKAEm4Lh7TiRFGlH1+ZKSf9RGge9vlrFEeilade5w/Nq/YsFRWunEfm3UBb+eaITtegHWwbtTeqvVcAnOMkzFDpguutE+fD0AjVriYz7bfzYYhXk2XigjdA4mwSKJECDYmcMJn
x-ms-office365-filtering-correlation-id: e4bceabd-58f8-4613-e4c1-08d62aaaf348
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB4439;
x-ms-traffictypediagnostic: BYAPR05MB4439:
x-microsoft-antispam-prvs: <BYAPR05MB4439EF3FE54125CFAB1E704DA3EB0@BYAPR05MB4439.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(10201501046)(93006095)(93001095)(3002001)(149066)(150057)(6041310)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123564045)(201708071742011)(7699051);SRVR:BYAPR05MB4439;BCL:0;PCL:0;RULEID:;SRVR:BYAPR05MB4439;
x-forefront-prvs: 0816F1D86E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39850400004)(396003)(366004)(136003)(189003)(199004)(305945005)(7736002)(26005)(1076002)(186003)(103116003)(2906002)(36756003)(2616005)(54906003)(256004)(14444005)(86362001)(476003)(11346002)(446003)(14454004)(486006)(6512007)(2351001)(316002)(106356001)(105586002)(8936002)(81156014)(81166006)(97736004)(8676002)(478600001)(53936002)(66066001)(5250100002)(5640700003)(6436002)(2900100001)(68736007)(2501003)(4326008)(71190400001)(6486002)(76176011)(71200400001)(102836004)(6506007)(386003)(5660300001)(6916009)(3846002)(99286004)(52116002)(6116002)(107886003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4439;H:BYAPR05MB4597.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: RLS9mDMzx7c/ZkgpTJES0qjk5dK8L7uQ0GEbZQ9UFTgzkmUvk565YSRCsP+ZjYI2IsRNwc5OQm7u7B4VxdPV0Jzvuvyn4gGZd3WlVTvXwDnIVYgr/RgoZiJKcpP/ZdF3VMZEWa+jbw1FAE6He4jCvls1vUfZyfF//Ltn3raZZxy+lR/9YOeESnk4FMyWWOJqraNLAMPmHelfHXrOo0HCj9IajDx/F66J3nzfzxYdDveEb4PbWA7PcdHnfW4ROlUD4l8j3aKvwvIDIJDFEX7nOdV+3cegbbYtATeUlRHRzCR0OqYlpv2rw5gZJU2qpiDNzdsx04WKl5rsMsN0jkayQPzmycAPQkKkbH038jTUzvQ=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4bceabd-58f8-4613-e4c1-08d62aaaf348
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2018 10:11:43.6923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4439
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Firmware supports scan dwell time tuning for various types of scans.
Enable support for this feature:
- advertise capability to configure channel dwell time to host
- pass scan dwell parameters to wireless card in scan request

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 4 ++++
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 9 +++++++++
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 2 ++
 3 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index 9845cf287118..18179965bd38 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -1101,6 +1101,10 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info=
, struct qtnf_wmac *mac)
 	if (hw_info->hw_capab & QLINK_HW_CAPAB_DFS_OFFLOAD)
 		wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_DFS_OFFLOAD);
=20
+	if (hw_info->hw_capab & QLINK_HW_CAPAB_SCAN_DWELL)
+		wiphy_ext_feature_set(wiphy,
+				      NL80211_EXT_FEATURE_SET_SCAN_DWELL);
+
 	wiphy->probe_resp_offload =3D NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
 				    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2;
=20
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index 8fb15cbf5005..bfdc1ad30c13 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2203,6 +2203,15 @@ int qtnf_cmd_send_scan(struct qtnf_wmac *mac)
 		qtnf_cmd_skb_put_tlv_tag(cmd_skb, QTN_TLV_ID_SCAN_FLUSH);
 	}
=20
+	if (scan_req->duration) {
+		pr_debug("MAC%u: %s scan duration %u\n", mac->macid,
+			 scan_req->duration_mandatory ? "mandatory" : "max",
+			 scan_req->duration);
+
+		qtnf_cmd_skb_put_tlv_u16(cmd_skb, QTN_TLV_ID_SCAN_DWELL,
+					 scan_req->duration);
+	}
+
 	ret =3D qtnf_cmd_send(mac->bus, cmd_skb);
 	if (ret)
 		goto out;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/w=
ireless/quantenna/qtnfmac/qlink.h
index 699157100309..8d62addea895 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -80,6 +80,7 @@ enum qlink_hw_capab {
 	QLINK_HW_CAPAB_SCAN_RANDOM_MAC_ADDR	=3D BIT(3),
 	QLINK_HW_CAPAB_PWR_MGMT			=3D BIT(4),
 	QLINK_HW_CAPAB_OBSS_SCAN		=3D BIT(5),
+	QLINK_HW_CAPAB_SCAN_DWELL		=3D BIT(6),
 };
=20
 enum qlink_iface_type {
@@ -1152,6 +1153,7 @@ enum qlink_tlv_id {
 	QTN_TLV_ID_WOWLAN_CAPAB		=3D 0x0410,
 	QTN_TLV_ID_WOWLAN_PATTERN	=3D 0x0411,
 	QTN_TLV_ID_SCAN_FLUSH		=3D 0x0412,
+	QTN_TLV_ID_SCAN_DWELL		=3D 0x0413,
 };
=20
 struct qlink_tlv_hdr {
--=20
2.11.0

