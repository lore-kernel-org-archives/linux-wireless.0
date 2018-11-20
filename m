Return-Path: <SRS0=1os+=N7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BA4C43610
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 09:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80C0F206BB
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 09:15:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="JVoHD6dh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80C0F206BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbeKTTnX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Nov 2018 14:43:23 -0500
Received: from mail-eopbgr700118.outbound.protection.outlook.com ([40.107.70.118]:16704
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725866AbeKTTnX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Nov 2018 14:43:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uwq3DBE7URRaPJFBK2EoR+CCn2rYZASr1ejr5vjAYBs=;
 b=JVoHD6dhQlAlvawbe/9xbnwulcUuiPh6wSO69W5IirhYRkfOiblqcfkyYA+iYilWEKy2uwZt+pskfBpembXOibIeWOK1cS02K6fJ9UF3nsBWi9sPe68J0LWVQlQKQRXC3vqZYQgDH2CXxmBqeERuGHWEOXRjHqwgneHo6q5T3Vc=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1062.namprd06.prod.outlook.com (10.160.194.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1339.25; Tue, 20 Nov 2018 09:15:14 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae%4]) with mapi id 15.20.1339.027; Tue, 20 Nov 2018
 09:15:14 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH V2 7/8] brcmfmac: 4373 save-restore support
Thread-Topic: [PATCH V2 7/8] brcmfmac: 4373 save-restore support
Thread-Index: AQHUelmCvSUU4MYki0WOXWO9KGq0h6VL8LeAgAx9owA=
Date:   Tue, 20 Nov 2018 09:15:14 +0000
Message-ID: <17a02459-d762-fe37-43d3-211347c404a2@cypress.com>
References: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
 <1542007730-47284-8-git-send-email-chi-hsien.lin@cypress.com>
 <0d024ae5-dc3e-a812-3afb-8b9fbd910444@broadcom.com>
In-Reply-To: <0d024ae5-dc3e-a812-3afb-8b9fbd910444@broadcom.com>
Reply-To: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.222.14.99]
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.0
x-clientproxiedby: KAXPR01CA0048.jpnprd01.prod.outlook.com
 (2603:1096:402:1a::34) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1062;6:apbUTC89Qwd3XjJQTrTAoasfp/rxlz4rTH1TLDyySi9BVR4zcacpeCTnN6ApTQVTiSXLOwVoG6woOdWVIFQdAQVD4vjc7g3uLGfPxntgwR4RNciMN6hJrgFVTQ5AVtvolpYfq1A5RfSCyoO9UanzfUn6Xqwt7I+KM4tceh5a69Kyk6SmBzIXn/AbwpcauJMutGbjEQRllGTiLlFSKyQ9Sw26KXsRY8iSwcg5yUrnZER+trDpiTT0/w7skiqSHENT66uEsPGnCl5Jm8hIgBT+w5EAx4SyHNvpyyM9eOY20bUtmLxvjXGb0gnGNp9zgjHiYYsN5lYdFzMYf+Nc57v2qIufjVEeA2fjGIR98qgznVL0EgA1OhPtMatuvSwk72oPhXDy4lhIilg/f59a2aWpKnMxdkz5s+XSyhiXBuD/5w6SgmhENVCJWXNy1IlNgWx8Qy9hE/tQqPb14FT74p27xg==;5:+CF6naZ6nJHNpSnU323VAZv9pbrN9EF1AXfpK6wPT8QfoUt2rQQpCy3C2RSUU2akGxUA1Lxuo8pcPffLfJ1PlDyFQLq4soS2nXaBIZ5FnMvt7RrA5mzVgLCmbEcA/q3W5ijOIe1wKmqZyft7blWkv88gCGWS4TJSq1cWCYLcZVA=;7:6g3nHNHQ82ZXYs5cVRPSujxnaoJi538Khal317fV8ZouMGSIx/nk3qfZdFtpf0TtSsgZbyxvHc8AazUbmAUgm1W1/ZE0ibQRlKwdvKzV5Q4R8iU8GU9o5T25JLVOD7qO4vpiIOx9eWb8rMhD1JjRcA==
x-ms-office365-filtering-correlation-id: 04f0a54e-c8f4-470a-c989-08d64ec8add7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1062;
x-ms-traffictypediagnostic: BY1PR0601MB1062:
x-microsoft-antispam-prvs: <BY1PR0601MB106270C8091688D855421F7EBBD90@BY1PR0601MB1062.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(10201501046)(3231442)(944501410)(52105112)(3002001)(93006095)(93001095)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123562045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1062;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1062;
x-forefront-prvs: 08626BE3A5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(396003)(346002)(366004)(39860400002)(199004)(189003)(65956001)(65826007)(66066001)(6512007)(7736002)(53936002)(6246003)(3450700001)(3846002)(6116002)(106356001)(4326008)(2906002)(105586002)(31686004)(68736007)(31696002)(54906003)(86362001)(316002)(386003)(229853002)(58126008)(110136005)(65806001)(305945005)(102836004)(53546011)(6506007)(8676002)(26005)(186003)(43066004)(99286004)(81166006)(81156014)(25786009)(52116002)(72206003)(6436002)(478600001)(2900100001)(36756003)(76176011)(6486002)(2616005)(486006)(476003)(97736004)(256004)(71200400001)(71190400001)(64126003)(14454004)(11346002)(2501003)(5660300001)(8936002)(446003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1062;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: cT7qL05/sXaNeq15Zp4+mngRNhT7QqCDs2XkW1BwccDfM7cEA3QyWFGCef9T1SSu4oFihUlV6JhSiT72MkXUlQtXD5GUv8pfKkeZ9EByuGe9bxXeNOYDzSwc0tbYg5I4vAg5wqLCxwTrxE86Q1mNGVcIyAaNNHc/gPoNuGYzMENUPJw5zFftqA9ghKZ/eC6WJ4u4xKhhKPffAQ3PL9M1RQx7NTW65T4FDUfAjPpBCFVgApCTf7/EKkDifYrO5w6wCghYHlj+8wr0mtcHSsvpVLqC3sPW3v8DFgyNsw4fVsgguVtefR2mjrUPJwzBqJ13+SOErOdqgG398cIOx73USsbIROBprl+bSU69Y/btiC4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <24C30AE4FBE25D418826F1FC9D8D7724@namprd06.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04f0a54e-c8f4-470a-c989-08d64ec8add7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2018 09:15:14.0748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1062
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 11/12/2018 6:30, Arend van Spriel wrote:
> On 11/12/2018 8:29 AM, Chi-Hsien Lin wrote:
>> Use sr_eng_en bit to check 4373 sr support.
>>
>> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
>> ---
>> =A0drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 5 +++++
>> =A01 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c=20
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
>> index a8d3b96b727f..08d5173d000c 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
>> @@ -1365,6 +1365,11 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub=
)
>> =A0=A0=A0=A0=A0=A0=A0=A0 addr =3D CORE_CC_REG(base, sr_control1);
>> =A0=A0=A0=A0=A0=A0=A0=A0 reg =3D chip->ops->read32(chip->ctx, addr);
>> =A0=A0=A0=A0=A0=A0=A0=A0 return reg !=3D 0;
>> +=A0=A0=A0 case CY_CC_4373_CHIP_ID:
>> +=A0=A0=A0=A0=A0=A0=A0 /* explicitly check SR engine enable bit */
>> +=A0=A0=A0=A0=A0=A0=A0 addr =3D CORE_CC_REG(base, sr_control0);
>> +=A0=A0=A0=A0=A0=A0=A0 reg =3D chip->ops->read32(chip->ctx, addr);
>> +=A0=A0=A0=A0=A0=A0=A0 return (reg & BIT(0)) !=3D 0;
>=20
> Sorry for not saying it earlier, but maybe it is good to add define of=20
> SR engine enable bit in brcm80211/include/chipcommon.h.

No problem. I'll make this change and submit V3 shortly.

>=20
> Regards,
> Arend
> .
>=20
