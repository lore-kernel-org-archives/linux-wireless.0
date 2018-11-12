Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77BD1C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 10:24:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32F03223C8
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 10:24:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="DRsyLEJI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32F03223C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbeKLURE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 15:17:04 -0500
Received: from mail-eopbgr690092.outbound.protection.outlook.com ([40.107.69.92]:40992
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726161AbeKLURD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 15:17:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DquNNfIyZExz0D7J/J2rb7C1nma4WIu8UEzLbROJrk=;
 b=DRsyLEJIGhsdyuACblEPKcFynUkHjJJYL6r0vUmNFB+EYHz4yq0zDQgG3VOD1VowiMCpFuZ+iVQsS6uFgZBkAP+mxhyeTNV68eHwy6G6ZJRn7w9Zz6Wit/TAIm8w0qlGLvsV34G8ty2WT5FSTXJ6Ju3lsOh4LLpAryzhLTxFbdg=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1385.namprd06.prod.outlook.com (10.162.111.151) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.27; Mon, 12 Nov 2018 10:24:21 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.045; Mon, 12 Nov 2018
 10:24:21 +0000
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
Thread-Index: AQHUell8qUxBrGET4EyJQkOGqtbdzqVL7O+AgAACEoA=
Date:   Mon, 12 Nov 2018 10:24:21 +0000
Message-ID: <d6e7a076-69fc-fda9-8d1b-d59d34609ec1@cypress.com>
References: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
 <1542007730-47284-6-git-send-email-chi-hsien.lin@cypress.com>
 <e3dba747-2baa-e36a-dd66-1c788dc32288@broadcom.com>
In-Reply-To: <e3dba747-2baa-e36a-dd66-1c788dc32288@broadcom.com>
Reply-To: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.222.14.99]
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.0
x-clientproxiedby: TY2PR06CA0048.apcprd06.prod.outlook.com
 (2603:1096:404:2e::36) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1385;6:PmZkVYPCIvMs5HMHrz7k3jJjsdUfivxAxzEp/oC6WDpzPCpg5IXIZkrpbaVJO6/AUeUr/syLSos33JE4XGt73xhAsaCxr3+1+vodDIxWWQpA1PWjOwsFIvKpmVO0Ofzhk4GM3GMT9EvyyO6P6jViZ2FZwpw60M8fqOls8FresqF0FKu11yXLY0/JJw+S/CtYDxNddbJpfQ+LrQp7oc25iuhoO99Bgw8QZeJW0TXAmMPL1KPndUdG2vjxelPAloeKmp2/XoGydjEqPDyObmlrYhTuovwCHgCb8HFZme/aTXz1fc+1DX5qT5g39K86Ek3CSqvLRWbbdBi8RggC9niKOgAj3+sVA9MBRAeOKoqPtcm5xUCVx9nOLOAb9HU+4AkVvrzLBoOanoEPwgHczEo9SHbCRcs8u2WcBLsXnrlhwdyz2mh3XroiBP7wYGVd6WKBT91F8zjXbiYkTOm0g/OOaajBK7X3wp8Ma6VlBBt3dcc=;5:CLNNk5ufWiMnSpK3J/j+x03gS4IZW8ouu+QToIbw49gRaCY/mz33AobY3np6gDk4oX68kTx5gNLJ8QZ9jUP6+2jLyr7ep0JF9TFkm6r16jpIUZbZDIQSsNZNxZZIegytEq+xs03FGes5fJZyKk5AyUIb8smjhIgzjK4/HCqeTAk=;7:gOld0QS5wHaVfwAIG6bIo+Lc38iGgzs584PD5FvCrGcbX3WpH52/hwGLAACqQ7aFFjGuEKfzFjLdLoAnWAxFqoPNi3kZxL6+XtQiuNQuWft+fm6SG911+HSMQz/kaSp+lS1o9KN9jEratlVGgUZr7g==
x-ms-office365-filtering-correlation-id: 6786be7a-e477-446f-4dad-08d6488902a0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1385;
x-ms-traffictypediagnostic: BY1PR0601MB1385:
x-microsoft-antispam-prvs: <BY1PR0601MB13851499D525494519199125BBC10@BY1PR0601MB1385.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(208715162771679)(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3231382)(944501410)(52105112)(3002001)(6055026)(148016)(149066)(150057)(6041310)(20161123558120)(20161123562045)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1385;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1385;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(346002)(366004)(39860400002)(396003)(199004)(189003)(5660300001)(476003)(2616005)(8936002)(72206003)(14444005)(65826007)(256004)(446003)(105586002)(6486002)(229853002)(11346002)(71200400001)(8676002)(478600001)(81156014)(71190400001)(14454004)(7736002)(81166006)(106356001)(2501003)(486006)(2900100001)(31686004)(305945005)(65806001)(53936002)(68736007)(36756003)(86362001)(64126003)(97736004)(43066004)(2906002)(99286004)(6512007)(65956001)(66066001)(4326008)(6436002)(52116002)(6246003)(31696002)(186003)(110136005)(6506007)(54906003)(58126008)(386003)(26005)(3450700001)(102836004)(316002)(6116002)(53546011)(3846002)(25786009)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1385;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: eUcZhHZzodsR1LOa3xCh3fbQDo4Ygm7uJ9X14QBDLF7En9g1nYlgHRGEqSGWtzRE8eNTS68aG/iZWgsoJQ+SxMnO2tEivL8zjm28fczaFL4iiKXQ/jYkxbNw1SZGLh4NsaBwP5Sa9dcqvkaFLVsM5x0LoJRDWpn1gNiYmabmQmEHncSyfmkO7/4t4I8wT262cl6VHhyEVPvoObk7hScRGXK7/8ltT8Pf4IfrZSAp5isunqLOJGb9ctZMwaNQoW+qF1ObK9msg6ZaKFD1XVBEIztlkpZ2Vwbo76rAP+juV+u9xqnSO3bLq1O8nSVC77uZlm9gthuDiwBxvWB6dBIbk2JuQNWXYJtWAeFpX57oxrE=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <632115BB1F8C3E46A899207C099F24DB@namprd06.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6786be7a-e477-446f-4dad-08d6488902a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 10:24:21.6617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1385
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 11/12/2018 6:16, Arend van Spriel wrote:
> On 11/12/2018 8:29 AM, Chi-Hsien Lin wrote:
>> GCI core is needed for ULP operation. Allow GCI core enumuration with
>> below changes:
>> =A0- Allow GCI to be added to core list even when it doesn't have a=20
>> wrapper.
>> =A0- Allow 8K address space size.
>> =A0- Don't overwrite the address value when an additional size descripto=
r
>> =A0=A0 is in place.
>=20
> One question. This only assures the GCI core is listed. So does the
> driver need to access it for ULP operation?

Yes, the GCI core registers are accessed when entering/exiting ULP sleep=20
modes. There will be other patches for the ULP support.

Regards,
Chi-hsien Lin

>=20
> Regards,
> Arend
>=20
>> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
>> ---
>> =A0drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 14=20
>> ++++++++------
>> =A01 file changed, 8 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c=20
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
>> index a3c857721446..a8d3b96b727f 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
>> @@ -786,7 +786,7 @@ static int brcmf_chip_dmp_get_regaddr(struct=20
>> brcmf_chip_priv *ci, u32 *eromaddr,
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u32 *regbase, u32 *wrapbase)
>> =A0{
>> =A0=A0=A0=A0=A0 u8 desc;
>> -=A0=A0=A0=A0 u32 val;
>> +=A0=A0=A0=A0 u32 val, szdesc;
>> =A0=A0=A0=A0=A0 u8 mpnum =3D 0;
>> =A0=A0=A0=A0=A0 u8 stype, sztype, wraptype;
>>
>> @@ -832,14 +832,15 @@ static int brcmf_chip_dmp_get_regaddr(struct=20
>> brcmf_chip_priv *ci, u32 *eromaddr,
>>
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* next size descriptor can be s=
kipped */
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (sztype =3D=3D DMP_SLAVE_SIZE=
_DESC) {
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 val =3D br=
cmf_chip_dmp_get_desc(ci, eromaddr, NULL);
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 szdesc =3D=
 brcmf_chip_dmp_get_desc(ci, eromaddr,=20
>> NULL);
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* skip =
upper size descriptor if present */
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (val & =
DMP_DESC_ADDRSIZE_GT32)
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (szdesc=
 & DMP_DESC_ADDRSIZE_GT32)
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 brcmf_chip_dmp_get_desc(ci, eromaddr,=20
>> NULL);
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
>>
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* only look for 4K register regio=
ns */
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (sztype !=3D DMP_SLAVE_SIZE_4K)
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* look for 4K or 8K register regi=
ons */
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (sztype !=3D DMP_SLAVE_SIZE_4K =
&&
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sztype !=3D DMP_SLAVE_=
SIZE_8K)
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue=
;
>>
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 stype =3D (val & DMP_SLAVE_TYPE)=
 >> DMP_SLAVE_TYPE_S;
>> @@ -896,7 +897,8 @@ int brcmf_chip_dmp_erom_scan(struct=20
>> brcmf_chip_priv *ci)
>>
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* need core with ports */
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (nmw + nsw =3D=3D 0 &&
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 id !=3D BCMA_CORE_PMU)
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 id !=3D BCMA_CORE_PMU =
&&
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 id !=3D BCMA_CORE_GCI)
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue=
;
>>
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* try to obtain register addres=
s info */
>>
>=20
>=20
>=20
> ----------
>=20
> You're receiving this message because you're a member of the=20
> brcm80211-dev-list group.
> .
>=20
