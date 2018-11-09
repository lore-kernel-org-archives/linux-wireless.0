Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BECC3C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 07:34:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AC1D2086C
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 07:34:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="iad30BXp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AC1D2086C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbeKIRNl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 12:13:41 -0500
Received: from mail-by2nam03on0092.outbound.protection.outlook.com ([104.47.42.92]:21845
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727845AbeKIRNk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 12:13:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U3GK4kjdtjk8S/F9wlUrZRWuhB/NZQb4WUWxQIZEywM=;
 b=iad30BXpET5nc/4ev/k7VqBTNQDf4o2pzLNJ3oKFgTNdv2wGl7/b70XlpwR9t1ny+KIcbPotywO+j4ycqoTz0/cN/+YwljRi8fXi35HuGqQ6RpxRYcVw76o3bntJpc7zMXYtmhlgsSCa8KyZTMBczaydMv4oGsRy9d81Vlkwrpc=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1467.namprd06.prod.outlook.com (10.162.111.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.25; Fri, 9 Nov 2018 07:34:15 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.034; Fri, 9 Nov 2018
 07:34:15 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Madhan Mohan R <MadhanMohan.R@cypress.com>
Subject: Re: [PATCH 03/11] brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373
Thread-Topic: [PATCH 03/11] brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373
Thread-Index: AQHUdYPVn+i9i21xekCPH9fEAxhKOaVFyEgAgAFJ3gA=
Date:   Fri, 9 Nov 2018 07:34:14 +0000
Message-ID: <ad6f6a88-86c6-58eb-ed54-782cdfd53641@cypress.com>
References: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
 <1541476188-75475-4-git-send-email-chi-hsien.lin@cypress.com>
 <62e88e38-b4d9-957d-12c9-60469687a4be@broadcom.com>
In-Reply-To: <62e88e38-b4d9-957d-12c9-60469687a4be@broadcom.com>
Reply-To: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.222.14.99]
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.0
x-clientproxiedby: OSAPR01CA0061.jpnprd01.prod.outlook.com
 (2603:1096:604:a::25) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1467;6:bgrZobxICBkwlKc7+UGJdUAqxZgHn4WAFHaV8ibA4tXUDztmMIM5TakijFYJTDYmFhJWP4ERZZTaHIaIyauDflSEgO8JyV2OJuUEoXWNfbQhlnaU9IL8TXULwg271LzItz1D2R3E51f3aymsFss3pakrOd/chZHmPN/rQ5/ExaX7GEC57yMTjrxqplq4FqN3WDShOBWQIzb9FFvVexSseAsZuZgZDgBUq7EnBwSTxp37fsC6bPzTOHwPd6JpF30MZfIZdqvDaSYdQRADLaxPo89oEnxRXWoc6TihVOVndofrRDlp7uHZKYEWXFFkrlhNlP1qDb2Lidzl4UlmjqCcxcPFahrtq4jhTJ3+VTbPpo0oFxoIRQe7j+Q8rOMByowYu4Zx7TENer2tJC5fxv92Zs65Yn+6/TfeqPZbfbdsvhTnZVhzQwLMLyD6DBuOMJeSqVzG3ZJf4Hz7+DL6rkABJQ==;5:O/m+TuaWhfEURdxmcN+FE9kov9ZvLJ/hO1JOzvMYY7JVt3V2RVosiw0W2MRxOb82pyVkuGsIxQaE1C7756sfKhs9n2/LwJleiK7v2TFf6FR6Rd1jJhgItxDqHq1fCV4FlB7mxletLzV0JOwnju/wcyDXx1DE/peoZrn8gkCIGZA=;7:UgYaFM+fCv705ja8uJk6oXQDuA8prK83mz0Lllh8TQ6t4NnBy7yjjeTnLdlQCE+7RRMszMTKM0OJaZlaHqD2g/flaNrCKJbwUYA3rNlR3DxpIUdJA2AM6lOzGAy6lgaFttri3ci30tnqfaFQ0KAHEg==
x-ms-office365-filtering-correlation-id: 8a9912af-6c2b-402c-b7a7-08d64615bf94
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1467;
x-ms-traffictypediagnostic: BY1PR0601MB1467:
x-microsoft-antispam-prvs: <BY1PR0601MB1467794661D1D9A484AF7F08BBC60@BY1PR0601MB1467.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985)(208715162771679);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3231382)(944501410)(52105095)(93006095)(93001095)(10201501046)(3002001)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1467;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1467;
x-forefront-prvs: 08512C5403
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(39860400002)(346002)(136003)(366004)(189003)(199004)(51914003)(54906003)(52116002)(8676002)(65956001)(65806001)(305945005)(72206003)(107886003)(102836004)(3846002)(31696002)(386003)(65826007)(6506007)(68736007)(6116002)(6246003)(53546011)(229853002)(3450700001)(446003)(2616005)(186003)(76176011)(110136005)(86362001)(11346002)(256004)(99286004)(66066001)(476003)(43066004)(5660300001)(486006)(478600001)(4326008)(6486002)(64126003)(2501003)(36756003)(97736004)(2906002)(53936002)(71190400001)(58126008)(31686004)(25786009)(8936002)(106356001)(2900100001)(7736002)(105586002)(26005)(316002)(6436002)(81166006)(81156014)(6512007)(71200400001)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1467;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: Cy3DeXUeHLoW623Zq1qaa1f6O+b41z4YKR26uj+a4FC4C9rwwH82mchLARxObu1Pf35BlVP4ORUByWgl0nvJVKLJeU5iadH2wLJeput+fU6ZBAfMuG7PTR7Ckcg3FvsT88uc5TE/rPqDA6L+OJRTwSRihA4QnikQNPOltM5aZjFJGLtZKLSCKgNvMCkTp1K1JoCzn4/QIOsUkizB7KweJaY4bzbEvCnUyFBnUZ3oE9WCPnBJyU+cSdnrJ1rB7RGSJSi+pyOiH4xfGrcFpE6uW8TXltP0hOkA8PdU7HYwcKbFBru48r1wnX2MqwLbmT13tElBRQpMjU3mSw+fe3jDi0Op1pPXOcWdUW9L2HeV/DA=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <AC84CAB8A6F1B44E991316CE78C697FD@namprd06.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a9912af-6c2b-402c-b7a7-08d64615bf94
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2018 07:34:14.8841
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1467
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 11/08/2018 7:53, Arend van Spriel wrote:
> On 11/6/2018 4:50 AM, Chi-Hsien Lin wrote:
>> From: Madhan Mohan R <MadhanMohan.R@cypress.com>
>>
>> Along with F2 watermark (existing) configuration, F1 MesBusyCtrl
>> should be enabled & configured to avoid overflow errors.
>=20
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Madhan Mohan R <madhanmohan.r@cypress.com>
>> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
>> ---
>> =A0drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 3 +++
>> =A0drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h | 3 +++
>> =A02 files changed, 6 insertions(+)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c=20
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> index 541d54661c9e..34a838fcc319 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> @@ -51,6 +51,7 @@
>>
>> =A0#define DEFAULT_F2_WATERMARK=A0=A0=A0 0x8
>> =A0#define CY_4373_F2_WATERMARK=A0=A0=A0 0x40
>> +#define CY_4373_F1_MESBUSYCTRL=A0 (CY_4373_F2_WATERMARK |=20
>> SBSDIO_MESBUSYCTRL_ENAB)
>=20
> I don't see much value for this define. It is use once below so just or=20
> it there. That way you can "directly" see what is written to the register=
.
>=20
>> =A0#ifdef DEBUG
>>
>> @@ -4118,6 +4119,8 @@ static void brcmf_sdio_firmware_callback(struct=20
>> device *dev, int err,
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devctl |=3D SBSDIO_DEVCTL_F2WM_ENAB=
;
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 brcmf_sdiod_writeb(sdiod, SBSDIO_DE=
VICE_CTL, devctl,
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &e=
rr);
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 brcmf_sdiod_writeb(sdiod, SBSDIO_FUNC=
1_MESBUSYCTRL,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 CY_4=
373_F1_MESBUSYCTRL, &err);
>=20
> just use 'CY_4373_F2_WATERMARK | SBSDIO_MESBUSYCTRL_ENAB' here. No=20
> braces needed.

Thanks for the input. The biggest difference is to prevent a 4-line=20
function call like below so it's more readable. I'll make this change in=20
V2. Please let me know if below looks too messy then I'll move back to V1:

                         brcmf_sdiod_writeb(sdiod, CY_4373_F2_WATERMARK |
                                            SBSDIO_MESBUSYCTRL_ENAB,
                                            CY_4373_F2_WATERMARK |
                                            SBSDIO_MESBUSYCTRL_ENAB, &err);

>=20
> .
>=20
