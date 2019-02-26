Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C4AEC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 12:31:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1862C217F5
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 12:31:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="JkImvFmY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbfBZMbs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 07:31:48 -0500
Received: from mail-eopbgr780084.outbound.protection.outlook.com ([40.107.78.84]:59479
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725954AbfBZMbr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 07:31:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=410m3Hhpn04+GfGAGt08hdYOLVWNgM4BhoN8bR9nTkQ=;
 b=JkImvFmY+WVt00UheC+TpwOT9wZhgJmdV5WLcq/Hioj2wrZyufC2PXsE8hHdCuz5baE1oVrXsGUfzGJbj0vrblzEhvGQSwi7b5EUvebUGyfLrSW08Pqosd0ZYYn9t9LhFI3jKvLrZePtUPQ8Q+HvWPg+wInAapkMAMy2czE663o=
Received: from MWHPR05MB3567.namprd05.prod.outlook.com (10.174.250.158) by
 MWHPR05MB2830.namprd05.prod.outlook.com (10.168.245.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.11; Tue, 26 Feb 2019 12:31:19 +0000
Received: from MWHPR05MB3567.namprd05.prod.outlook.com
 ([fe80::b8b9:d12a:c574:a4a1]) by MWHPR05MB3567.namprd05.prod.outlook.com
 ([fe80::b8b9:d12a:c574:a4a1%4]) with mapi id 15.20.1665.012; Tue, 26 Feb 2019
 12:31:18 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5599.namprd05.prod.outlook.com (52.135.111.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.6; Tue, 26 Feb 2019 12:31:04 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::d46a:6636:1ae8:3066]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::d46a:6636:1ae8:3066%2]) with mapi id 15.20.1665.012; Tue, 26 Feb 2019
 12:31:04 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 8/9] ath10k: Add new api to support TID specific
 configuration
Thread-Topic: [PATCHv2 8/9] ath10k: Add new api to support TID specific
 configuration
Thread-Index: AQHUynBUZ8Ip8VNafk6TVPkfikXb6KXyCWCA
Date:   Tue, 26 Feb 2019 12:31:04 +0000
Message-ID: <20190226123058.yu5brtbu4euwbzxx@bars>
References: <1550813554-11581-1-git-send-email-tamizhr@codeaurora.org>
 <1550813554-11581-9-git-send-email-tamizhr@codeaurora.org>
In-Reply-To: <1550813554-11581-9-git-send-email-tamizhr@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0014.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::27) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dad44096-c7dd-4870-c7db-08d69be6461a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5599;
x-ms-traffictypediagnostic: SN6PR05MB5599:|MWHPR05MB2830:
x-moderation-data: 2/26/2019 12:31:16 PM
x-microsoft-antispam-prvs: <MWHPR05MB28308DF45363D6BA2795B4A3A37B0@MWHPR05MB2830.namprd05.prod.outlook.com>
x-forefront-prvs: 096029FF66
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(366004)(396003)(136003)(376002)(346002)(39850400004)(199004)(189003)(14444005)(102836004)(5660300002)(3846002)(8936002)(6116002)(256004)(6506007)(386003)(14454004)(229853002)(6512007)(6246003)(9686003)(81156014)(71200400001)(1076003)(71190400001)(6436002)(26005)(81166006)(6916009)(86362001)(2906002)(99286004)(486006)(11346002)(33716001)(446003)(4326008)(66066001)(316002)(476003)(54906003)(53936002)(305945005)(478600001)(68736007)(7736002)(105586002)(6486002)(8676002)(52116002)(106356001)(25786009)(186003)(436003)(76176011)(97736004);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB2830;H:MWHPR05MB3567.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;MWHPR05MB2830;23:mEOqalArYDH1RIbwrtYGlHy88k3xCcoNy63rWGSfH?=
 =?us-ascii?Q?AfhiPVr4DQw+Ut0A+AxxmATCaWac06JkGGkeEtGMCZHkknCF2JdMbW8f2Esy?=
 =?us-ascii?Q?UAk23pIs0Z+L+c50jWGgytxsWCcpGNiqH+OdLx8eSYoHyMQJ04yfe/AJb6Qg?=
 =?us-ascii?Q?DI7/7YgiC5LyzXA+vCx5t7qUkQAebUMI3EX9hbIhGB9KISOmnYQQNCBEpRXD?=
 =?us-ascii?Q?qk2Puz6grCKBfVLJdgf3feB5Z4ElwWNfC1xjYt64nWDoNB2zdwLfxbjHkLf6?=
 =?us-ascii?Q?MODe/wF3+bBo44RWGVVSacWi8XwPYeUzHxqt4ZZQVIzzUqo9ycUisn0JOYUG?=
 =?us-ascii?Q?/bKsVFeTtWpBUtn9TbTQ9bE/xrCsrtg6EwqkS1FHrpI2rCRRE45LGlVgjqGF?=
 =?us-ascii?Q?2ILvzEvIMKKfQOORS0doJ1x2j9MqioVy9W4IX6FrlrsuaEo3JmfuSm0EhDf0?=
 =?us-ascii?Q?RP8OVRnxGNNkCk7FnWsAna3xEne1Okb62lXU6kfO28OVioMSfHyTeU5eYuHR?=
 =?us-ascii?Q?rWH32HVJe0h3KlqZ/9XJYw6Yd6mucbhTtve8CXvTCCRsKa94m27SyWFEQm1v?=
 =?us-ascii?Q?3Rxiv7rtpY7VOOfn29Xxl4imC3rkli4cqUV9LYJIK0PclsKk4n+/hXV7vdoB?=
 =?us-ascii?Q?Cx/PCTef8s9YZX0OFFRYjZTudKUGU2wKkuVjq36y9RDyzRTOS7MhZ4BShSnM?=
 =?us-ascii?Q?UNZQjUg2bsPfpgr+IiPt4M0jdalBoHJlfc6u38Ph0djulgnWR5ERrQKfi5/5?=
 =?us-ascii?Q?7TCofu890HYeoBCENf46pFbHFVtUexiJjo95OZ735M0WLNJlysvlckSGj+yn?=
 =?us-ascii?Q?mcdCg9hng7aT0sfUARjcqGp0oeoFlNF0CjyOw095jlVmtMeLKXmk7uz1Cf4r?=
 =?us-ascii?Q?LLMlA/yG7fhJPgJLYi5vFdYLz/QGdOiyXSF+JOpCQt3U49u8gS68Jo6CLDIz?=
 =?us-ascii?Q?xhpoBJ1C+VamIhCIy5rHHXTqs1H0AZpROPvRpXyd4+qXH2Sf1Q3DqP63ePPu?=
 =?us-ascii?Q?OjRS3JbmVNCYAkuIbCtYOKQhMJ/7jn0OYjRC6ZVcc6A3ix2AcpjsLKOYk28j?=
 =?us-ascii?Q?S+LyF2Bymr2eHO/otP1yJE43om2Fk7L2WnW26oQ+rYD64XzQPmwwVf+0I3aG?=
 =?us-ascii?Q?36OP3nRJAw6LU0Dnf9s6k1nknW/AISln4bugM7ph2WqbDrOLqkGEXSGdEsSa?=
 =?us-ascii?Q?7V/QgUFOICaSY5xi8ba2TEmSq054vTtdaWrQzL2Y891qrHxRKH+vJ7h8On+Y?=
 =?us-ascii?Q?aiXVjBasWXRU5cwastX8i49tBaSD53miK0dfLvI?=
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: t42CPkeQtXmSJia7l7tx/w/lj1JdKv++qYoZ/Yv2MRv6Ifcik5GlQemOj47PWcbiO0+Qgci6nIamylVaOpqRXrJiCdNuE+/FYdxMlnIgI6NI7Omu0HQtpVu1bEM2p8HPI4Ws5g9pft5JeEilDqAWgNR36qYDOOUhjrWWx7cIGt+sovWK+7ZD1CWV9YmPRc+3ZG9/+8Z90Jv0PQIJYNjvUaU4Ts7UyvdwFyKkeCUNVkG46PNLlTupwwxvKJNunU+flnoSb42837hna+IIpobUGbJe1qkmTxM3I4Gq78vTYGwxKRWdy4OKDSI+0FafHLPwi4JTJzVL8ZlLj/wEhJE2WAi5yG3W7sqGk602AR/pnIj3PqnS6w4NkZ/3ZgKas+Mwzcscg+ovUVuM8GR84zHPy7MSQM7UkHL9ZqHZenne2ck=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1AE0BBBBCC6BCA4E929F1E9F0675BCFD@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dad44096-c7dd-4870-c7db-08d69be6461a
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2019 12:31:18.8667
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2830
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Tamizh,

> This patch add ops for set_tid_config to support TID
> specific configuration. STA information along with the
> TID config change mask to notify driver that which configuration
> needs to be applied for this current command.
> If the STA info not available in the command then the
> configuration will be applied for all connected stations
> in the vif. TID specific noack configuration requires
> aggregation disabled and rate for the data TID packets
> should be basic rates. So, if the TID already configured
> with noack policy then driver will ignore the aggregation
> or TX rate related configuration for the same data TID.
> In TX rate configuration should be applied with highest
> preamble configuration(HT rates should not be applied
> for the station which supports vht rates).
>=20
> Vif specific TID configuration will be applied for all
> the connected stations except for the station which
> already applied with the same configuration for the TID
> through station specific command. Newly connecting stations
> will be applied with vif TID configuration which will be stored
> in ieee80211_vif.
>=20
> Testing:
>         * Tested HW: QCA9888
>         * Tested FW: 10.4-3.5.1-00052
>=20
> Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/core.h |   7 +
>  drivers/net/wireless/ath/ath10k/mac.c  | 602 +++++++++++++++++++++++++++=
+-----
>  2 files changed, 529 insertions(+), 80 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireles=
s/ath/ath10k/core.h
> index 27ec555..c25c426 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -82,6 +82,9 @@
>  /* Default Airtime weight multipler (Tuned for multiclient performance) =
*/
>  #define ATH10K_AIRTIME_WEIGHT_MULTIPLIER  4
>=20
> +#define ATH10K_MAX_RETRY_COUNT 30
> +#define ATH10K_MAX_TIDS        8

Is there any reason why you don't use IEEE80211_TID_MAX here ?

Regards,
Sergey
