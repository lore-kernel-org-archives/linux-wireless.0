Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3475C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 19:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B788A20851
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 19:31:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="ijQ+MT5f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfCHTbb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 14:31:31 -0500
Received: from mail-eopbgr700047.outbound.protection.outlook.com ([40.107.70.47]:16560
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726706AbfCHTbb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 14:31:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7d/kvrZQI/qMgvILeEiZ7B/e2W1h7vpfCjZfmhhT63M=;
 b=ijQ+MT5fZTEquP79e4M4DaIxSTtL6219RouHEGfQ4rd0TLWkVFcUymGpwjC/sAr64os2c0Jvlg0Ah/+Tj5MnFCT5S4gigb1DY4DWcm21oLAJqzq4rWnaUU84/3u7OuroWcC/muzUAeiAJD4xyb7/yZwq9wQqo351aAr4RTrx+UE=
Received: from BN7PR05MB5891.namprd05.prod.outlook.com (20.176.30.202) by
 BN7PR05MB4371.namprd05.prod.outlook.com (52.133.223.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.10; Fri, 8 Mar 2019 19:30:47 +0000
Received: from BN7PR05MB5891.namprd05.prod.outlook.com
 ([fe80::2d59:d6be:72a1:5a94]) by BN7PR05MB5891.namprd05.prod.outlook.com
 ([fe80::2d59:d6be:72a1:5a94%3]) with mapi id 15.20.1709.009; Fri, 8 Mar 2019
 19:30:47 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB4463.namprd05.prod.outlook.com (52.135.74.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.8; Fri, 8 Mar 2019 19:30:18 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::a0ce:bddb:4fc7:be02]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::a0ce:bddb:4fc7:be02%5]) with mapi id 15.20.1709.009; Fri, 8 Mar 2019
 19:30:18 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv3 0/9] cfg80211/mac80211: Add support for TID specific
 configuration
Thread-Topic: [PATCHv3 0/9] cfg80211/mac80211: Add support for TID specific
 configuration
Thread-Index: AQHU1EbXvk+or9rWPUehte2Jn/Qo6KYCIiQA
Date:   Fri, 8 Mar 2019 19:30:18 +0000
Message-ID: <20190308193011.g5ysgf3po3pazg32@bars>
References: <1551895251-22941-1-git-send-email-tamizhr@codeaurora.org>
In-Reply-To: <1551895251-22941-1-git-send-email-tamizhr@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR02CA0049.namprd02.prod.outlook.com
 (2603:10b6:a03:54::26) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5a146ae-9ba3-48df-be88-08d6a3fc7f0e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB4463;
x-ms-traffictypediagnostic: SN6PR05MB4463:|BN7PR05MB4371:
x-moderation-data: 3/8/2019 7:30:45 PM
x-microsoft-antispam-prvs: <BN7PR05MB437179760B37FD4836C6F2BBA34D0@BN7PR05MB4371.namprd05.prod.outlook.com>
x-forefront-prvs: 0970508454
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(366004)(376002)(346002)(39850400004)(396003)(136003)(199004)(189003)(2906002)(26005)(256004)(14454004)(186003)(476003)(53936002)(5660300002)(68736007)(97736004)(76176011)(478600001)(52116002)(25786009)(99286004)(71200400001)(71190400001)(3846002)(6116002)(102836004)(11346002)(6346003)(446003)(386003)(6506007)(86362001)(54906003)(6436002)(105586002)(486006)(305945005)(436003)(6512007)(7736002)(81166006)(81156014)(9686003)(1076003)(6246003)(8676002)(106356001)(6916009)(229853002)(4326008)(316002)(66066001)(33716001)(8936002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR05MB4371;H:BN7PR05MB5891.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bfFYeuxo98yufeOekjf43DNeIwzwbTvFnDAVu9rPMKWfAt4zQX0EujI/URaOnneto4alX76/5ORb5eJaA0OIeKXq5RHYuWuM8BXxp/EI1tTWvX9M9pLPntCjqjW30HHl6hQkHeX8A4DlPyCsL6guvPrfUiy9ULjSIUMZ4DBJWPnC8i02j3PV9tzYWZ5JGOy2KTO6NlsaPSUf5hlu7GVXnNFdtTegqv44iqLfbk7iQurxK/Vo8XrvSU3cQ3xDI+qhjZkfi513dRSgVhUmKFXAe3j9IIf7xhw6luah3H4ZJgdlmTbls6l7bZ3kvDquz+bok0wvbSJkW08fBPLXJGy9cO56OYwHbtg6ydDf7d/U7Df7plkswfSBOw743FC+fWHIXciAs5nFfeJ+9tGgY1KzrWtS0RQSy83VihhWP4AvABU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <96A7331ECA664F4B8FF0B929E711D5AC@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5a146ae-9ba3-48df-be88-08d6a3fc7f0e
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2019 19:30:47.6655
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR05MB4371
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Tamizh,

> Add infrastructure to support per TID configurations like noack policy,
> retry count, AMPDU control(disable/enable), RTSCTS control(enable/disable=
)
> and TX rate mask configurations.
> This will be useful for the driver which can supports data TID
> specific configuration rather than phy level configurations.
> Here NL80211_CMD_SET_TID_CONFIG added to support this operation by
> accepting TID configuration.
> This command can accept STA mac addreess to make the configuration
> station specific rather than applying to all the connected stations
> to the netdev.
> And this nested command configuration can accept multiple number of
> data TID specific configuration in a single command,
> enum ieee80211_tid_conf_mask used to notify the driver that which
> configuration got modified for the TID.
>=20
> Tamizh chelvam (9):
>   nl80211: New netlink command for TID specific configuration
>   nl80211: Add new netlink attribute for TID speicific retry count
>   nl80211: Add netlink attribute for AMPDU aggregation enable/disable
>   nl80211: Add netlink attribute to enable/disable RTS_CTS
>   nl80211: Add netlink attribute to configure TID specific tx rate
>   mac80211: Add api to support configuring TID specific configuration
>   ath10k: Add wmi command support for station specific TID config
>   ath10k: Add new api to support TID specific configuration
>   ath10k: Add extended TID configuration support
>=20
> v3:
>   * Modified "nl80211: Add netlink attribute to configure TID specific tx=
 rate" patch
>     to accept multiple TX rate configuration at a time.
>   * Modified noack and ampdu variable data type to int in
>     "mac80211: Add api to support configuring TID specific configuration"=
 patch to store
>     default configuration.
>   * Modified "ath10k: Add new api to support TID specific configuration" =
patch to handle
>     default values for noack and ampdu. And added sta pointer sanity chec=
k in
>     ath10k_mac_tid_bitrate_config function.
>   * Fixed "ath10k: Add extended TID configuration support" wmi command pa=
rameters
>     assigned part.
>=20
> v2:
>   * Added support to accept multiple TID configuration
>   * Added support to configure TX rate and RTSCTS control
>=20
>  drivers/net/wireless/ath/ath10k/core.c    |   4 +
>  drivers/net/wireless/ath/ath10k/core.h    |   6 +
>  drivers/net/wireless/ath/ath10k/mac.c     | 679 ++++++++++++++++++++++++=
++----
>  drivers/net/wireless/ath/ath10k/wmi-ops.h |  19 +
>  drivers/net/wireless/ath/ath10k/wmi.c     |  35 ++
>  drivers/net/wireless/ath/ath10k/wmi.h     |  72 ++++
>  include/net/cfg80211.h                    |  57 +++
>  include/net/mac80211.h                    |  35 ++
>  include/uapi/linux/nl80211.h              | 182 ++++++++
>  net/mac80211/cfg.c                        |  28 ++
>  net/mac80211/driver-ops.h                 |  15 +
>  net/wireless/nl80211.c                    | 253 ++++++++++-
>  net/wireless/rdev-ops.h                   |  11 +
>  net/wireless/trace.h                      |  18 +
>  14 files changed, 1316 insertions(+), 98 deletions(-)

I am not familiar with ath10k driver internals. But for cfg80211/nl80211:
Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Regards,
Sergey
