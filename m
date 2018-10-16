Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 195B0C04EBD
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 11:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB87B20881
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 11:29:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="qG8yUgm/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB87B20881
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbeJPTTW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 15:19:22 -0400
Received: from mail-by2nam01on0075.outbound.protection.outlook.com ([104.47.34.75]:46791
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726595AbeJPTTW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 15:19:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1HXAM5MZyZnBCM0R9bPw8N9/GmrXU92QmTCEJtB8jro=;
 b=qG8yUgm/OETVd6BMFTXshCRmjsqSTp3a5/79zNmruz64b0WGQqZ8Uw7pq/Fta05/fZ8jIYf6ar0FVIi8JuDZE+pw6lqAUAZL5zKHjwhIvrZagSzVypfmNnoOGN6Np9bkl5kEyZvoe+xsR69oNVOPahY86M5O4ETSac1rAeJfdIs=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB4849.namprd05.prod.outlook.com (52.132.15.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1250.18; Tue, 16 Oct 2018 11:28:39 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::d16b:3a5b:aa09:b156]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::d16b:3a5b:aa09:b156%2]) with mapi id 15.20.1250.020; Tue, 16 Oct 2018
 11:28:39 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] cfg80211: Add support to configure station specific
 RSSI threshold for AP mode
Thread-Topic: [PATCH 1/3] cfg80211: Add support to configure station specific
 RSSI threshold for AP mode
Thread-Index: AQHUZLDIKOGz6fZmKkqGg1CcncsGBqUhvVsA
Date:   Tue, 16 Oct 2018 11:28:38 +0000
Message-ID: <20181016112831.bglm53ydrktjy7i5@bars>
References: <1539626250-769-1-git-send-email-tamizhr@codeaurora.org>
 <1539626250-769-2-git-send-email-tamizhr@codeaurora.org>
In-Reply-To: <1539626250-769-2-git-send-email-tamizhr@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR0102CA0008.eurprd01.prod.exchangelabs.com
 (2603:10a6:209:14::21) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB4849;6:jWs6NV2RSaOSQjcU0J2BtVKGHfvh8Nd/fZkAo7LnTM5nR0y1omrmpi2mpqKUvDc9LDCHoXFlXT86OjyJGKoXk3nzUJhP51Mbze68BjwPYWD2Mvqc8IEnGU/nJb7+y1ZOKSOfEYXQRdr7ZRIR78g7YRMpL7y02xHDfbMfzjjplUjhI6wb6nyx7ZQ+2B9Jts4frrI8F5z10T+i1nXFwBOIZG0lpaVG7n3YlKqJx44C0udMOcMibOOG4thlGxmWltLv+jXbpW8PTQqJxCmajX82YFvYBbcCcPn5gxLNLFoah8tpVrQb7WxOEgLAHheNCBfG0VZHVbPOeg+dcN7BUIIJKBudQak/3rbrT38iGKOlvBiLPNbAYcI3AbifoY2n+N9nhj7f+Ir279/wKSkw3aCsdCkiecjPlSlv58I7NoHf+HLdRvqHazrNdUrgAe3CNGLeaJBm5iG0VTqBwWjueAEm/A==;5:Ym2DDQ8Yp2/eyoXoH85KzPpxT6wRoZOhyKMm8rVne3+UPB31sv8uskTiJGNuaThq3IqpjYlpHn4AaeG2NNvoyxOV+4hIcBruYrzuCkJRcneAXV7UtBV30f0tvfVI2uPRuN1pSSkcwD+jFSvSseLOIaDgtZtNybkKo5fLVP5mkEk=;7:j+qy2Q5GTbG3YsHwMJwwVUsB36ahTH/5nH8r7lho5rXWvZggwJlFT0aX97BSURSGVvMnJtBPPIOIKxH/oEFtfCRgo/CmVTqgnWaubbL+Cf0F7aA6Tw0YlVj5Y9nB6DTBrIP/vecnlgpipSWsPUm3+J4LeVfaNx5/IHcmmej2+E6KhiINCw4iBOGSC9P1ZP4wMcjLzRQcz0mJewUUv2Pj2vn9PMa3buuKVLGA2PfdCQREXR8NlBEMufgHLAXEUd0h
x-ms-office365-filtering-correlation-id: 4b10814f-61b6-4e0b-578d-08d6335a848b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB4849;
x-ms-traffictypediagnostic: BL0PR05MB4849:
x-microsoft-antispam-prvs: <BL0PR05MB484995BECEFDE560D3EAA0FBA3FE0@BL0PR05MB4849.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(72170088055959);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(3002001)(10201501046)(93006095)(93001095)(149066)(150057)(6041310)(20161123560045)(20161123558120)(20161123562045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991067);SRVR:BL0PR05MB4849;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB4849;
x-forefront-prvs: 0827D7ACB9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(346002)(136003)(376002)(366004)(396003)(39850400004)(189003)(199004)(446003)(2900100001)(9686003)(54906003)(229853002)(6486002)(6436002)(11346002)(6512007)(478600001)(486006)(476003)(6246003)(53936002)(316002)(5660300001)(1076002)(105586002)(106356001)(102836004)(3846002)(6916009)(68736007)(305945005)(6116002)(8676002)(6346003)(26005)(186003)(81156014)(81166006)(86362001)(7736002)(8936002)(14454004)(5250100002)(66066001)(33716001)(76176011)(99286004)(52116002)(71190400001)(386003)(71200400001)(6506007)(4326008)(97736004)(33896004)(25786009)(2906002)(14444005)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB4849;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-message-info: T/xiQu+FzjLEvoeEx5S3irHJ97EZlD8YVGtPWtvsbJYBnpXCNfIBwzLOjRK1VkKOyikehTo+YsqcXUgypliKO7WP8LJhkVdGnpKWA1nKaw2GPOtTo4kcGpemq5dcHrTf+D6c/Iyns1iA8IoUO0S3qXBAx+WQgBIqCH74OkJUl+9jxctR0bCJOsb4kaPt9Q3yvxrjlNeX7nqKDPlQBrtcXyXoklYB3R/hDEqvz/XOrfB9lEazKC9w+Hm2xddfrA3fPbDOKPPc3W0SZ8qnBSHfJ7uH7fjyVock7OoNMuUNAfKbb5JUdv4F6nZz8SJycYAz4Bw9FoLaHHfOWo/MHIioeyP8o4iA2vUZ+zbi2TtLsSM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <923EB9376397D0429B25018C4F5B6B12@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b10814f-61b6-4e0b-578d-08d6335a848b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2018 11:28:38.9239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB4849
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
> ---
>  include/net/cfg80211.h       |   28 +++++++++
>  include/uapi/linux/nl80211.h |   18 ++++++
>  net/wireless/nl80211.c       |  131 ++++++++++++++++++++++++++++++++++++=
+-----
>  net/wireless/rdev-ops.h      |   18 ++++++
>  4 files changed, 181 insertions(+), 14 deletions(-)

...

> +static int nl80211_set_sta_mon(struct sk_buff *skb, struct genl_info *in=
fo)
> +{
> +       struct cfg80211_registered_device *rdev =3D info->user_ptr[0];
> +       struct net_device *dev =3D info->user_ptr[1];
> +       struct nlattr *attrs[NL80211_ATTR_CQM_MAX + 1];
> +       bool fixed_thold =3D false;
> +       struct nlattr *sta_mon;
> +       u8 *addr =3D NULL;
> +       int err;
> +
> +       if (!wiphy_ext_feature_isset(&rdev->wiphy,
> +                                    NL80211_EXT_FEATURE_STA_MON_RSSI_CON=
FIG))
> +               return -EOPNOTSUPP;
> +
> +       sta_mon =3D info->attrs[NL80211_ATTR_CQM];
> +       if (!sta_mon || !(info->attrs[NL80211_ATTR_MAC]))
> +               return -EINVAL;
> +
> +       err =3D nla_parse_nested(attrs, NL80211_ATTR_CQM_MAX, sta_mon,
> +                              nl80211_attr_cqm_policy, info->extack);
> +       if (err)
> +               return err;
> +
> +       addr =3D nla_data(info->attrs[NL80211_ATTR_MAC]);
> +       fixed_thold =3D
> +               nla_get_flag(info->attrs[NL80211_ATTR_STA_MON_FIXED_THOLD=
]);
> +
> +       if (attrs[NL80211_ATTR_CQM_RSSI_THOLD] &&
> +           attrs[NL80211_ATTR_CQM_RSSI_HYST]) {
> +               const s32 *thresholds =3D
> +                       nla_data(attrs[NL80211_ATTR_CQM_RSSI_THOLD]);
> +               int len =3D nla_len(attrs[NL80211_ATTR_CQM_RSSI_THOLD]);
> +               u32 hysteresis =3D nla_get_u32(attrs[NL80211_ATTR_CQM_RSS=
I_HYST]);
> +
> +               if (len % 4)
> +                       return -EINVAL;
> +
> +               err =3D nl80211_validate_rssi_tholds(thresholds, len / 4)=
;
> +               if (err)
> +                       return err;
> +
> +               return rdev_set_sta_mon_rssi_config(rdev, dev, addr, thre=
sholds,
> +                                                   hysteresis, len / 4,
> +                                                   fixed_thold);
> +       }
> +
> +       return -EINVAL;
> +}

IIUC there is a noticeable overlap between this new command and
existing nl80211_set_cqm_rssi command. Is there any reason why
nl80211_set_cqm_rss can not be adapted for AP case ?

If there is a reason to handle AP case separately, then it looks
like it makes sense to add explicit check for supported iftype
in this new command. Besides, it looks like there is no generic
way to handle disabling of RSSI monitoring in the new command.
As a result, we may end up in multiple driver
specific implementations.

Regards,
Sergey
