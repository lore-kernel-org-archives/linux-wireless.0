Return-Path: <SRS0=1os+=N7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6DB6C43610
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 09:14:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62EA5206BB
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 09:14:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="vy/86eSn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62EA5206BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbeKTTmq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Nov 2018 14:42:46 -0500
Received: from mail-eopbgr780138.outbound.protection.outlook.com ([40.107.78.138]:48928
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725866AbeKTTmq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Nov 2018 14:42:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dy3W2kp4JZx6xp0KPxln0bduAY9xXfyliaKsHBfePDI=;
 b=vy/86eSnCdYfHLqxBbPBSwOb7wQ3bTTtG8Mk92hLlAlTyzKINKGl1h3bbzI3jh6sGfJHhtcHEzp79tRy2SiyX8cHVvY4Mxf706YHhg5Eq1IHcZHqsyFM8MCMx0vvvjHFYrdIc+MizHxCnVn5mloyGBXm9I+qLrT7LOdDRJfqXMc=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1333.namprd06.prod.outlook.com (10.161.206.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1339.21; Tue, 20 Nov 2018 09:13:56 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae%4]) with mapi id 15.20.1339.027; Tue, 20 Nov 2018
 09:13:56 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Naveen Gupta <Naveen.Gupta@cypress.com>,
        Madhan Mohan R <MadhanMohan.R@cypress.com>
Subject: Re: [PATCH V2 6/8] brcmfmac: update 43012 F2 watermark setting to fix
 DMA Error during UDP RX Traffic
Thread-Topic: [PATCH V2 6/8] brcmfmac: update 43012 F2 watermark setting to
 fix DMA Error during UDP RX Traffic
Thread-Index: AQHUell/i2NozFkudUaxpNpPaeE67aVL3r0AgAyPP4A=
Date:   Tue, 20 Nov 2018 09:13:56 +0000
Message-ID: <2e1ff7c9-bf1a-ea35-083f-96ef0fece863@cypress.com>
References: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
 <1542007730-47284-7-git-send-email-chi-hsien.lin@cypress.com>
 <5ed63f80-c599-3b34-05bc-b721b4af2a1d@broadcom.com>
In-Reply-To: <5ed63f80-c599-3b34-05bc-b721b4af2a1d@broadcom.com>
Reply-To: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.222.14.99]
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.0
x-clientproxiedby: TY2PR06CA0003.apcprd06.prod.outlook.com
 (2603:1096:404:42::15) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1333;6:4J/RfpKKrWEZng5g5HrzFaE2iVKGWRJXzxGr2zU27TbVu4Z79sjlB6A5i4gBUkUnbk/v6V7MJqhQQJIG+uXDzX2lJBqT1XNhGEkmL6QW+u9SW6SXC6AhE3aXcT84/XNI4rTqjpSoHInfxa9R6Zv+vgx4fkzXaL/RgNVsX47yRbMKNG8nAY9Ig5hJdWCd6uHGkDfOam4QlHgG6qRz9CImvRVhaEsvnOyAAvky5SEAEHLv+VtKGuLB32DebEdZsxCTEHnhELZt3DZwBS4jf36YLEDzuPMK8uOpmlGkjGyxJBtQePVvKVDJ9uLZtdEJRRaYYCr6VH+ITHWnJj8Ts1lndU7RaZ1jXRCeVa4Slt10ZTC13k+sbYSHGUp25FoSztAvrJ8AC3NuCQeyyaPcR0H71Obt9ZzekWw5lVm7b8jrDK+G9OrAtTcWBsWklfjmV7KIKTGTQyY0D8JCPnUpVtNVSw==;5:RTWBZB1HFoiQYJssR9OIb8HRCvEjZDLFKU9tC7iw2PTVGthiruq+ne67rYpo9RLnZGqTd3Yf8g7cORpJBswvnw0knsrlBZldrWo8knY6nnn0eA+jj7AM3i0OPj/nPiCtsW/3X/ykHsORWzJtXPNhhq1+Kc4ybYJ1Qfv/VolJj40=;7:bf7N957jF/NvvqlQKpTgDN4V0TWnUo/I4jnTs3bi92ok8XMEVOU2RnCPBCZTAPjBgfk1auMf0xMoimsLeH3UtjIUnC/iiST0PEwKHYMLPRc4FCRmy1FmiVLesvcLr5HnnWpErWB0iq1muIPIXAgUrg==
x-ms-office365-filtering-correlation-id: 73f8361b-4ab3-46cc-fec5-08d64ec87f51
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1333;
x-ms-traffictypediagnostic: BY1PR0601MB1333:
x-microsoft-antispam-prvs: <BY1PR0601MB1333BE45D9314EB78D25C849BBD90@BY1PR0601MB1333.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231442)(944501410)(52105112)(3002001)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(20161123564045)(20161123560045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1333;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1333;
x-forefront-prvs: 08626BE3A5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(39860400002)(136003)(366004)(376002)(199004)(189003)(58126008)(8936002)(81166006)(8676002)(2906002)(81156014)(478600001)(229853002)(3450700001)(72206003)(6486002)(99286004)(25786009)(6436002)(6116002)(52116002)(31686004)(3846002)(6506007)(26005)(76176011)(53546011)(102836004)(2900100001)(186003)(97736004)(68736007)(105586002)(106356001)(14454004)(71200400001)(71190400001)(6246003)(2501003)(66066001)(65956001)(65806001)(446003)(316002)(31696002)(86362001)(43066004)(386003)(36756003)(107886003)(256004)(4326008)(54906003)(64126003)(65826007)(110136005)(6512007)(476003)(2616005)(486006)(53936002)(5660300001)(11346002)(7736002)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1333;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: ng0Jq+fjh9c4UoW6ExqUV8X9C0qrKD4wzehgKQj/Xg38vSFr7m/d2zW0rBR0e4OUzHNrbXqIC4f6K6BY3BDM5XalnjyhnFgoyl8+j3PuU8+iraWvS4FVjqJrxSeSp8qYk1PmgVmynXCd7aek32FgZTD1JngodLYGTn8u75K7+e5vmW0wRAPkaRqrkOkErxOXb4Q5ePwShC9gp/JbK585rDAuPPe0mYdWiYOxBsQ+jUuVdPYEnMQmaS8VLjGvH28wtNbYZQM8n+5U/Y66BA9jxrpZ+IlCqpmi+2VpIuzRgRLCCIyieaY7rP+KMr5WpflGgfiN3jRIWnpB3cMG8plnNqhmJA/oeYgYYVW7CDYn4V4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <D547242AC5B6F146AB4817FD6D127D03@namprd06.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73f8361b-4ab3-46cc-fec5-08d64ec87f51
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2018 09:13:56.2260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1333
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

(+Madhan)

On 11/12/2018 5:25, Arend van Spriel wrote:
> On 11/12/2018 8:29 AM, Chi-Hsien Lin wrote:
>> From: Naveen Gupta <naveen.gupta@cypress.com>
>>
>> The number of words that the read FIFO has to contain except
>> the end of frame before sends data back to the host.
>> Max watermark =3D (512B - 2* (BurstLength))/4 =3D
>> (512 - 128)/4 =3D 384/4 =3D 0x60
>> so if burst length (i.e. BurstLength =3D 64) is increased,
>> watermark has to be reduced. This is the optimal setting for this chip.
>>
>> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Naveen Gupta <naveen.gupta@cypress.com>
>> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
>> ---
>> =A0drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 12=20
>> ++++++++++++
>> =A01 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c=20
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> index 7707b0169c21..e1708e297d07 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> @@ -52,6 +52,7 @@
>> =A0/* watermark expressed in number of words */
>> =A0#define DEFAULT_F2_WATERMARK=A0=A0=A0 0x8
>> =A0#define CY_4373_F2_WATERMARK=A0=A0=A0 0x40
>> +#define CY_43012_F2_WATERMARK=A0=A0=A0 0x60
>=20
> So basically you increase queuing in firmware rx path. How does this
> affect TCP latency. The DMA error obviously needs fixing, but why go
> from a watermark of 32 bytes to the maximum of 384 bytes. Same question
> for 4373.

This is to answer 2/8 and 6/8 -

For current chips like 4373 and 43012, we are configuring F2 block size=20
as 256 and it is recommended to program the F2 watermark (SDIO TX path -=20
SDIO Device to host traffic) to at least equal or greater than the block=20
size to make sure that at least >=3D 1 Block size of data is in FIFO=20
before sending on the SDIO bus to avoid underflow. We haven't observed=20
excess TCP latency with this setting.

Regards,
Chi-hsien Lin

>=20
> Regards,
> Arend
