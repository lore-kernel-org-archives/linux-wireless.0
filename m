Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1501BC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 10:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFF642085B
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 10:21:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="JqzuUqk+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFF642085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387776AbeKFTph (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 14:45:37 -0500
Received: from mail-eopbgr710080.outbound.protection.outlook.com ([40.107.71.80]:6976
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387480AbeKFTph (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 14:45:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxr8p3hHucTB8dumvcRhipE5xajwTD7WrZGdYBqcWA4=;
 b=JqzuUqk+SH/kv4pgpr/r6Mm4/zeN5qWrowTrUxmXxCqcJBXxMvRbbbCjoJkf0L6JYlv5bHghbrmpqmIAx9rQa+df1elB2E+U2irJ30kmCpdmAYW0A0pk1IsJPY6Tx9aBeBtx17UWZ5KKZWGzzA/ofyKOLL/h6EABEhUWTS60ZfM=
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com (20.177.146.138) by
 BL0PR05MB5476.namprd05.prod.outlook.com (10.167.235.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.14; Tue, 6 Nov 2018 10:21:03 +0000
Received: from BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8]) by BL0SPR01MB0020.namprd05.prod.outlook.com
 ([fe80::fce8:69f:f659:27d8%3]) with mapi id 15.20.1294.034; Tue, 6 Nov 2018
 10:21:03 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
CC:     "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH 2/4] nl80211: Add netlink attribute for AMPDU aggregation
 enable/disable
Thread-Topic: [PATCH 2/4] nl80211: Add netlink attribute for AMPDU aggregation
 enable/disable
Thread-Index: AQHUajCP6K3okxrVR0WYihPkw5d66KVCoGeA
Date:   Tue, 6 Nov 2018 10:21:03 +0000
Message-ID: <20181106102051.7erib7owjms64knl@bars>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
 <1540230918-27712-3-git-send-email-tamizhr@codeaurora.org>
In-Reply-To: <1540230918-27712-3-git-send-email-tamizhr@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR04CA0011.eurprd04.prod.outlook.com
 (2603:10a6:206:1::24) To BL0SPR01MB0020.namprd05.prod.outlook.com
 (2603:10b6:208:72::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB5476;6:KpxrJ3s02m8cgvMid95dwiwF6m+gB7whvGO/r0JJtq6dgPwyVXCIzZc55OBN5u++5sqQbVsS81inTkyoH5B929ABtdhwkN2o008bW1AmSfFB5CRZsjO9lrf47s5jXQA2Pnz9m760DzxZV4+00zm/h5OBE4TIRywjPR6OFwQNrpXP2aeD86zMPw2d4WCFp4BfZQpGdgR8dJKsZ3CAbHCjrSQt/1gXz+D+9hBxJp53YpSu8oqNR0H5ZyHdOYpNyBGLIJOWcW6+/Zdbfj+gllRI6lxP/ZgORYeA0K3YiJUu7Kv+2/0rcmZxapb3Rf6/W/e0CHYvTBkAZK3bksH8cUxK1igNuN7LvPgGtnBs84UVgR+vetV0osC35ZXxhY5KU3mfTgMwJP6/qCj+PCGQqacnv8LckmxuFMth9klKVvPMNwOe+e9by0qfjDEIb+9IRPXTYbNYzZffNaszcP94JEVa3Q==;5:HCYDo1lX/hsJ8CKRSIMZJw5BKHk4m+stQYbRxgQ8pUpV4H+VtcR89uUsYuilFQhxPfHM/DOF/TBOY83Cyfzhggm3DxTi6hV1um4lI5MG3rmKDEfouWndrJ18gMu/Jsn7k3iwbISOFZ97ALAvRGG4JJO19AsojVUB+F4N3L4lzLE=;7:nude2OWKdHd+PvrSkuo1nuJt99lSnyC2G1vzablwK2GeCcitxjIKOiQsrdGxZ3u/aLfLU/jIgCKKkTTOk2sYjMy3fGuELoU0Ps2YJlVnyD1ZpI5xvMPDowWcknv40DNPKknwu1/l53vbPB11tEkmXQ==
x-ms-office365-filtering-correlation-id: fce2931d-3d9e-4a0d-8dac-08d643d18e23
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB5476;
x-ms-traffictypediagnostic: BL0PR05MB5476:
x-microsoft-antispam-prvs: <BL0PR05MB547602D6E6676C147D923321A3CB0@BL0PR05MB5476.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3231382)(944501410)(52105095)(93006095)(93001095)(3002001)(10201501046)(148016)(149066)(150057)(6041310)(20161123562045)(20161123560045)(20161123564045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BL0PR05MB5476;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB5476;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(396003)(39840400004)(136003)(366004)(346002)(376002)(199004)(189003)(8936002)(229853002)(66066001)(8676002)(33716001)(25786009)(81166006)(81156014)(6916009)(97736004)(386003)(6506007)(99286004)(33896004)(256004)(76176011)(68736007)(26005)(102836004)(71190400001)(52116002)(86362001)(575784001)(71200400001)(4326008)(478600001)(14454004)(3846002)(486006)(2900100001)(1076002)(5660300001)(476003)(11346002)(446003)(105586002)(106356001)(186003)(305945005)(2906002)(6246003)(316002)(6116002)(107886003)(6436002)(7736002)(53936002)(54906003)(6512007)(6486002)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB5476;H:BL0SPR01MB0020.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 5+HVQINhRZvsABmkMqRvJ7eEYWTCNq/0rBf1Ke/hrfqzGVth6Q8oD0HUvkbDQd7vKpq9ASlM9Ibc5UCe1x5n5Vc6mQkYHMsul1bVI4vPSm5WTCZthy20ZXxl3uQMgK+4VgI8/YxNJU+4lFXeuerJ6tzmh0ad+bg1Xrh+fiMzKJSndVvLwEHomp8Vh72HPRFCXw2ibPi9UheFLG8kWGEZApu8SqAgEm6iWBqkx8eBOx+7eXy4IuntPmzwdoNKZVsMLKP4AvSk6CSH7WXXmWtg2DuDzReqIKkckNi8YhTf+0r/QKrPlGGNaCh1j+vBpMm5ilY2AmbMSbYIxMXvAucv2XPLx+0s6jvPrqQx4yvEkHo=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <77A64B184F8CA043A2D3B11C9EEC4350@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fce2931d-3d9e-4a0d-8dac-08d643d18e23
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 10:21:03.6177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5476
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


Hello Tamizh,

> Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
> ---
>  include/net/cfg80211.h       |    6 ++++++
>  include/uapi/linux/nl80211.h |   21 +++++++++++++++++++++
>  net/wireless/nl80211.c       |   17 +++++++++++++++++
>  net/wireless/rdev-ops.h      |   15 +++++++++++++++
>  net/wireless/trace.h         |   23 +++++++++++++++++++++++
>  5 files changed, 82 insertions(+)
...

> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 9dfcf0a6..7ba0fb7 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -4449,6 +4449,20 @@ enum nl80211_ps_state {
>   *     the max value should be advertised by the driver through
>   *     max_data_retry_count. when this attribute is not present, the dri=
ver
>   *     would use the default configuration.
> + * @NL80211_ATTR_TID_AMPDU_AGGR_CTRL: Enable/Disable aggregation for the=
 TID
> + *     specified in %%NL80211_ATTR_TID. Its type is u8, if the peer MAC =
address
> + *     is passed in %NL80211_ATTR_MAC, the aggregation configuration is =
applied
> + *     to the data frame for the tid to that connected station.
> + *     Station specific aggregation configuration is valid only for STA'=
s
> + *     current connection. i.e. the configuration will be reset to defau=
lt when
> + *     the station connects back after disconnection/roaming.
> + *     when user-space does not include %NL80211_ATTR_MAC, this configur=
ation
> + *     should be treated as per-netdev configuration. This configuration=
 will
> + *     be cleared when the interface goes down and on the disconnection =
from a
> + *     BSS. Driver supporting this feature should advertise
> + *     NL80211_EXT_FEATURE_PER_STA_AMPDU_AGGR_CTRL and supporting per st=
ation

typo: should be NL80211_EXT_FEATURE_PER_TID_AMPDU_AGGR_CTRL

> + *     aggregation configuration should advertise
> + *     NL80211_EXT_FEATURE_PER_STA_AMPDU_AGGR_CTRL.
>   */

Regards,
Sergey
