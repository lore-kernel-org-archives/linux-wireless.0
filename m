Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C97F1C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 10:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82C7D223C8
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 10:29:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="ZQe+FeZA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82C7D223C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbeKLUW1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 15:22:27 -0500
Received: from mail-eopbgr710136.outbound.protection.outlook.com ([40.107.71.136]:36352
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725873AbeKLUW1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 15:22:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3YVmKmyWC2yFt/aqchZg69P3YEhWDwTJUoz+KjHSJA=;
 b=ZQe+FeZAOVjNeC9Hxk68Gfel8RzqRGx1IXrpmdoQZjIh28U4AOiv8gFnbzkusvOad0Mm9T9d61XUdDdr2shiG0+9nVaDZ/t7Cix2ZWjhtTzgG8r9CfmRcsLpMZHuUpwdbJEh0JL4rG3YA5Q87KX6jKuvrzbLB+9L9XzApPjnO+o=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1080.namprd06.prod.outlook.com (10.160.195.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.26; Mon, 12 Nov 2018 10:29:42 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.045; Mon, 12 Nov 2018
 10:29:42 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH V2 5/8] brcmfmac: allow GCI core enumuration
Thread-Topic: [PATCH V2 5/8] brcmfmac: allow GCI core enumuration
Thread-Index: AQHUell8qUxBrGET4EyJQkOGqtbdzqVL7O+AgAACEoCAAADJAIAAALEA
Date:   Mon, 12 Nov 2018 10:29:42 +0000
Message-ID: <34cf3f24-9500-4fa9-0805-79c82ac11e2f@cypress.com>
References: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
 <1542007730-47284-6-git-send-email-chi-hsien.lin@cypress.com>
 <e3dba747-2baa-e36a-dd66-1c788dc32288@broadcom.com>
 <d6e7a076-69fc-fda9-8d1b-d59d34609ec1@cypress.com>
 <96efe062-b5f2-ccfb-a062-2c426f459a7a@broadcom.com>
In-Reply-To: <96efe062-b5f2-ccfb-a062-2c426f459a7a@broadcom.com>
Reply-To: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.222.14.99]
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.0
x-clientproxiedby: OSAPR01CA0085.jpnprd01.prod.outlook.com
 (2603:1096:604:b::25) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1080;6:niL5tFL/mfCHa5s4i2Uv+KWLTTm17OIr1Z2i+eP2XqAD4n7sGV24e+y8kWj17Mtjn7tFXUUWXu8fcSIe2drj8ha5gGUWXsEuHObx6QMfRodhCLIhwyxvp+YGA/OOv8G8+5bt40roTVjI1NVpiVx44Llj6nzXnF+O6Y5OgVoapkOCHcX/ujSsCfdYqkBqN/5aXzow+/LojT2/dyhIQhB7VUd9+GcV5e87H/WrZE9PCfLOfINkuLo2S+yOiMhhRvmGCIyBKjXoic2znHRNk42IdBeZDyC2pLO4+UGih2tJzN5Tydr6Po1rGDbtSoYIWskBb/YAr1IgeBA/CqO7ZIiW3B3dvcSVfkfySHwqFAPabO1mPLZLzPsKXiO9wH9U/xQuxJ9oAzHrAfRcRx1HBv8aeANyNCt2jzigr0OhDYMsxKiYKRnVRB6rHqt+fuykjVgCogMgjjvlulj0yEmx+qEuww==;5:aKqh7OrwJVm1yc/D8jtoSABSbUDb1O1Qnp4Y3rFEcNwDfWsrHpZc5a6PvgY2dYK9xOtoQ1gECBsvf6UScWApuETo8iDvacJlHfWkdHRbV6U+pFMpCYcZjsSf3iJtmVrWyiRoIvPykzG9LjF2mFQwKfubPMynWbmozlQGfRkotwo=;7:hdOYtA5MbXViVa5U9qKq9WiSTsDA6vl0kT9e8q6kK3yf2rTLNC6b9kMfhxSgR3AKYhVsEwN5mFNT0ya5QCq1Rm+vOI6U5MCIyr2M1zmG5QSEq+yfFtKccqxGuWEayDI112TKn3065wqpSF4CXItbUg==
x-ms-office365-filtering-correlation-id: bd436908-108f-4694-8861-08d64889c1fb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1080;
x-ms-traffictypediagnostic: BY1PR0601MB1080:
x-microsoft-antispam-prvs: <BY1PR0601MB1080D4B334DD96D69F2CB693BBC10@BY1PR0601MB1080.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(10201501046)(93006095)(93001095)(3002001)(3231382)(944501410)(52105112)(6055026)(148016)(149066)(150057)(6041310)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123562045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1080;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1080;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(346002)(396003)(136003)(376002)(199004)(189003)(86362001)(25786009)(229853002)(102836004)(6116002)(14454004)(305945005)(8936002)(71190400001)(97736004)(81156014)(81166006)(71200400001)(6486002)(68736007)(2900100001)(3450700001)(4326008)(31696002)(54906003)(58126008)(3846002)(52116002)(2501003)(2906002)(99286004)(316002)(76176011)(8676002)(7736002)(110136005)(43066004)(6506007)(93886005)(386003)(11346002)(6512007)(105586002)(478600001)(53546011)(186003)(446003)(14444005)(106356001)(53936002)(486006)(2616005)(5660300001)(26005)(256004)(65826007)(65806001)(6246003)(65956001)(66066001)(6436002)(36756003)(476003)(31686004)(72206003)(64126003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1080;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: ykPEAbB+sCoEoEExVQic7xz8Fqj0K7bwdojbtjvINGb238VmVXSH/gO1FDpI1zIItGyr0wEggfP+j0s3Y3eF+BTQJsNBJoFlk//N8rpE23UkedItym1WR/5Ffh7aIqabMqb7J+hC1J9GLHR7u6IFaOrtJnavl1JoQ6SopaI+lnD2TLCADjdHfs+CH1gctBwNEVnBUhSQlG10nobMZn4ioNxkpewi3RbqzUztusCplySyOh1xuYaC4GpFfVzzOThBDSgOq5131ng4X1lOtqWoP4dwlAi3sXeHseVCq1BAQsRS4NsTduhXmBlBiLdgwcHz73UYWt+hwYefKn4yVdaQIkRP6KXJaFIBT3pFmMbT82A=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <B522379C591A66448B9E868F7355B9D0@namprd06.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd436908-108f-4694-8861-08d64889c1fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 10:29:42.5063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1080
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 11/12/2018 6:27, Arend van Spriel wrote:
> On 11/12/2018 11:24 AM, Chi-Hsien Lin wrote:
>>
>>
>> On 11/12/2018 6:16, Arend van Spriel wrote:
>>> On 11/12/2018 8:29 AM, Chi-Hsien Lin wrote:
>>>> GCI core is needed for ULP operation. Allow GCI core enumuration with
>>>> below changes:
>>>> =A0- Allow GCI to be added to core list even when it doesn't have a
>>>> wrapper.
>>>> =A0- Allow 8K address space size.
>>>> =A0- Don't overwrite the address value when an additional size descrip=
tor
>>>> =A0=A0 is in place.
>>>
>>> One question. This only assures the GCI core is listed. So does the
>>> driver need to access it for ULP operation?
>>
>> Yes, the GCI core registers are accessed when entering/exiting ULP sleep
>> modes. There will be other patches for the ULP support.
>=20
> Yeah. I suspected such. It would have been better to send this patch=20
> with that ULP series, but let's not make it an issue now. The patch is=20
> fine.

Thanks a lot.  :)

>=20
> Regards,
> Arend
>=20
> .
>=20
