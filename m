Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3265C64EB8
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 10:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7504C21479
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 10:35:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="xIe8xuGu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7504C21479
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbeJIRvY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 13:51:24 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:51166 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbeJIRvY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 13:51:24 -0400
X-IronPort-AV: E=Sophos;i="5.54,360,1534834800"; 
   d="scan'208";a="19201006"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Oct 2018 03:35:07 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 9 Oct 2018 03:35:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dhSwWKifyc/elV82UIcnoLRRulj//aC5hYzTzYX56s=;
 b=xIe8xuGu5qOisZkIduA/970odbtVp6xTbi6sPAWeht8C5T+12z1Vh+rDHy+T8biFjCCpTq/BKvtHEZz9jERIdiI/mv7XSzcvi5YoOD+AqJtqG1Q4UvkXG0xcLFR05Kt5jQXMYjpH3e92f/qEmH0ZsC4Gv5XOgkiAfdNz9EVJEVc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
Received: from [192.168.43.50] (27.59.42.105) by
 SN6PR11MB2575.namprd11.prod.outlook.com (2603:10b6:805:57::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.28; Tue, 9 Oct 2018 10:34:59 +0000
Subject: Re: [PATCH 03/19] wilc: add host_interface.h
To:     Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
 <1537957525-11467-4-git-send-email-ajay.kathat@microchip.com>
 <1539008417.3687.57.camel@sipsolutions.net>
From:   Ajay Singh <ajay.kathat@microchip.com>
Message-ID: <f4ab9830-7892-a062-48c4-5c5c64b5caa0@microchip.com>
Date:   Tue, 9 Oct 2018 16:04:38 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1539008417.3687.57.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [27.59.42.105]
X-ClientProxiedBy: BM1PR01CA0110.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00::26)
 To SN6PR11MB2575.namprd11.prod.outlook.com (2603:10b6:805:57::20)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e11c046-9fac-4162-4691-08d62dd2dfcf
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR11MB2575;
X-Microsoft-Exchange-Diagnostics: 1;SN6PR11MB2575;3:3yfuMyIzXbyFO0vDC332ExxsfKdUjMXNwxgf9gJ2/kiej2cfAN0hAUl5JP/xPaIGwC/GzH27YKxIEhM3zqi+2XxrW/EQZgRMvPmcQOVeneLDhThG4Tbfuf++EDdZOJkUn+Z7tOXooiEvGa3rgSwSAjoniE0/A/rW+FGHJH3M8QxzNNaqL7TbEqXwv0KyoNYa+gygWhYsMaPGEjWZgUwKGXMAkf4nqk4KcYK2gMiSdmlBj2P0gxIL64UOMrxBAK2L;25:9zaUnIXnMkZ3amDw/GHz/USuNRfBuHM86YO1cylrNoDPd5FWiHUhDM6ijdeFsCQewL8FXKqtFwiVhKVcHMW7q7LBWp4LX7/SDf/N/ggkRgTUhB95EVswWWJEwkNpHWk8SwxN40zJiHqXDSqie9267WSAKsneSq5xJ+aD1noZpqRPcE+vy0NVlCZ8NF/RqaSgS6+ykBrllINMundYewdUinvJbBc2sVqqwsy1dsJ5Jf6b3HGogj3toRz9feAq7gsBEn9nP7ejLvcrczfGaWr7CWoSEOSaMLmSteJCbe6Cxh9uQ7u8WgSqM+VIQ2TASBp/iXXMA1VlfBhymEmAcrpOzg==;31:yk8yqEUiYP4sGuLIFdi6YYSQo4EQickUr7wPzKZjJRlT4/GLXAyGRc1D1ZYcn9apN/iHUdXoF01s5o0w+qRHeL2fQph/n2AQt0ruDPEGpCZpi1FMozhBBK2ieXbzwUOt6E4Dm+r3h/LlxfyYKIZsf2M+mwxN/Qu45hLte6qVK/h72D38NEs6fF98W1xhGPc+Z/JTjFkxKqfPnGf6yMEzrbqZYRy4Lt51QBsFQv76whU=
X-MS-TrafficTypeDiagnostic: SN6PR11MB2575:
X-Microsoft-Exchange-Diagnostics: 1;SN6PR11MB2575;20:s6d1YnFCWRBEp0p8/3sYaMpPk1SiZUP37vV2S9QcWI8ii30APAI00Iqi/lt5GRkxOSdwrDkvfNwx+tV/F3rZZird203vr7bWDjh94dfOqU+jkVlQrpLVVN6JryOYYlcD1N/J3Vjxgm/ffvKJUT3GpViVadxwVzCigt4exkuPqx8kkvMVLEU10l9lOZTVOfLYaXKXOiDh8uBd7zgaZvu9omZUwwPmbSZWr5r2gN+lX7jjwCZ0PF+Gc/7slwccz3gvDe3rkDZ3sPR9CZRMokBCY4zwgjmzJIjJghG8XnGAoI7jOmdsNre7V/K5HTXaq5VOrkBtDmPO3rF5yJvMtTt0JHTgyKb6efvWk+ceVbv/BsNqVwpvDP7W3tPN8yuIA8HCU3awNJ8rYI+Crt0oBluhL7oJXsCL4CNzlmBZrbxjq/M=;4:qaSQJzwFCW+3CrRn/SlnBmQMFTSZJt63i/A8+wUFI24zCyO30wnGw2g/l5YqDaDeNJOZBzOZ3MA7Lv4Fu+kSpwVJd/6bk3c9mQMa2lgJMYGU26R67V74dZy6a6FeQFt8d6a7izL9n5V7YF6SPlclxXjqUvZs7ohrAMRXJb8hu2KmwS1VjtR9eBjoHT5CdQyCyZ37Mm55mMQ9PrLAK+h0LALpuwPwj12Oyk2+5Ixe76/RsRs6s+hCBgca3iAOk2xNIQ9ogKNOxKvtxRQxXjUOmg==
X-Microsoft-Antispam-PRVS: <SN6PR11MB25754232A4BA1A0C0518907FE3E70@SN6PR11MB2575.namprd11.prod.outlook.com>
X-Exchange-Antispam-Report-Test: UriScan:;
X-MS-Exchange-SenderADCheck: 1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123560045)(20161123562045)(201708071742011)(7699051)(76991055);SRVR:SN6PR11MB2575;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB2575;
X-Forefront-PRVS: 08200063E9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(136003)(396003)(346002)(39860400002)(376002)(366004)(199004)(189003)(76176011)(4326008)(65956001)(14444005)(47776003)(6246003)(66066001)(305945005)(107886003)(68736007)(5009440100003)(7736002)(106356001)(105586002)(50466002)(5660300001)(72206003)(65826007)(478600001)(316002)(65806001)(6666003)(81156014)(8676002)(2870700001)(81166006)(31686004)(2906002)(8936002)(58126008)(229853002)(16576012)(6116002)(64126003)(97736004)(53936002)(3846002)(36756003)(26005)(117156002)(486006)(86362001)(77096007)(23676004)(16526019)(6486002)(52116002)(3260700006)(25786009)(11346002)(186003)(956004)(386003)(476003)(2616005)(52146003)(2486003)(446003)(53546011)(31696002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB2575;H:[192.168.43.50];FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtTTjZQUjExTUIyNTc1OzIzOklaSm5jMXFGdEhDb2JuOWRVZktTSVJ3blhD?=
 =?utf-8?B?NjFyS2l4SU9IODFFSGk0SE5nc256VzFMSDJxNTFzLzRpVmZ2bXorcHBkL0M2?=
 =?utf-8?B?RUZ3NUxya1JRRk14WUV4bjJIaWpGM1RTMmRBb0pqNEJDNW45K1N4SjZOaE56?=
 =?utf-8?B?UWtpRHpMRzErVUlFVzZldTFYU2wxY2RZSXQ3cTRTSnpsaStLTmdxQ0FnbWF5?=
 =?utf-8?B?WEhiTVIwN05lcnlOTEoxejUzcTZHT3M3ZjRUeDBYK2plelBSNUR2R2xxVVVp?=
 =?utf-8?B?WlRqNFFRbVJYblhnWCtQZ0VEbVZXQ3JZbFpUSDMxd0tXSUdZYmF2ZGRSRVdC?=
 =?utf-8?B?aktVNVpaRWhaRVBqblJsUHBVQzdyUldYTzJRQ1lMZzJBUis0aEg5NXZEZTZo?=
 =?utf-8?B?cDlaOVdFUVBrWGZFSGlra1FUS3ErTjZDTmNnUlhkSkoycnlGaS9waWVHazVh?=
 =?utf-8?B?L0paZzlVUWZ3UGgrWnJXYTdDOW5jTGh2U1hiODZwdEt2UDhMcFVkY0E1WWdB?=
 =?utf-8?B?c0NuRlpVb3p4blBacG5DR3p0T3pCcWJva0xpNmVhUFBiY2puRVBmTWprYlc3?=
 =?utf-8?B?cXNJL1lUc2tROUhpdzc4djViRlp3L1lYQ3JHa1pDRVZaNTBRZUl1ZzJ6TE44?=
 =?utf-8?B?L1dYSVdjR0JqSFdMZUpsTTgwSlhteE9OaG93U083bFFRRHRIZjFza2NzdHJr?=
 =?utf-8?B?TjJ0VHE1NG05THI2Z1c0UjZndVVLOCs2akZKU21IcXVRc2dGSmx1ZjZoaGZx?=
 =?utf-8?B?TDRZcjJYeGd3QmxIemtBTTFWV1JIRExRc1E3Y2FWMG1CTlJGdy96dERnV2Jk?=
 =?utf-8?B?Y20yeURtUU5QUko1cTFYYmhSamRPOUZQZFIxaXJDR0tUVTFrWHhLVWxSMS9U?=
 =?utf-8?B?WVJ4MG1uemxkTUhyOGNrN2x5NFpac3JBaFVvVURpR1djUFhlek41NG8wM1NF?=
 =?utf-8?B?MU5kVnZIWVBNdllEc21YUzJjYTFxN0FwUmVsOFpjdndleG1MbWlCcmo4RmRM?=
 =?utf-8?B?RG11dm1sMWN4bUl6aGJDWE03eHNTRVQ3SHoxYWkxR3hLZUI4NTBXVytZSUR4?=
 =?utf-8?B?VytyK0dOWWVmRmpEMml3QWJxYXpmVU5YU0lGT3Vta2hta2s5QjJWcy85NXNx?=
 =?utf-8?B?K0l1VC83d29uL2V1NkpQQlFnckhubEFTYjlFR3BsTWJPRmdwcTVGZmpBQUds?=
 =?utf-8?B?RnJpdG8wS2VhYWpwL2ZFVjhyQlRZL09JZ2lkb3hBVXJReXJqOUUxdGpOSFNz?=
 =?utf-8?B?Y3ZuekcwNTZWSWxxazlMa3R5L0ZvRTQwSmIyYkQySFVzZjlSczJYelZuT1Nn?=
 =?utf-8?B?ZUgrekFQSitzWlNtQXJKaGJ3d3FhVHBnSjhvM0ZoNG5pSEpQWFdHajdWS1Ex?=
 =?utf-8?B?cXBWMmREQ3VqSCtLZnp0ZTBIWnp1TnlpZFlSOVc2RjFaUVBZNFpoZk82Q1p1?=
 =?utf-8?B?NVFiZGhRdkNBMVI3dmpEWUJRWWQ0cjY3VFlza1F5eEhUQlpRRytMc3RjenNy?=
 =?utf-8?B?UFFxZmY2RkxvNThkNmM4cThIVjU5SlBWTHBVaFBZTjVIZjYzWThDdEV4QWw2?=
 =?utf-8?B?citwWWRuSjBZZ1I3elBKR1diRFIrZTB5bERJQkZKZzZyS2NMalM0VkRzQ0Rx?=
 =?utf-8?B?Sk5kd0J0K2UrTm5BTUJaMVNnMzUvZ0RnK2piSS9CQ2hwdkVHRlRsODBuamdo?=
 =?utf-8?B?VjlnMHRuMFBEd25EREdzZmZSeEYxdHkwbllDNy9MNjZiMnlGL0V0UUtYRk9C?=
 =?utf-8?B?WDZoaTRNQkUyTTl5R2czMitBczl3L1crbHVwV0luQ1NPSmMwN0czTWtPN3J1?=
 =?utf-8?B?REhTbTcxNmk1MHovcHhZU3FLTjNrSS8yYnR3SWJXalprLzBGNE44RkFmTFNl?=
 =?utf-8?B?emtDTGIwTTF2S1MwR3FQSEdzN3p4QWZNeVM5azhrWUUxSGd0Z0N2cFhkTm5F?=
 =?utf-8?B?Rm45UG0zMVhtMUxVUEFlNURmdUNEdGJhbHBIQU5sY1pJazB5Q2hhdmVFOXlp?=
 =?utf-8?B?dzUySjlPb28yK3N0K2NtTlh5eEdLSFNhRythWXV3TktYQ0FXUjIrak5HcjlP?=
 =?utf-8?Q?AVG/eEA3zOMPf2jD1eW1fxFBb?=
X-Microsoft-Antispam-Message-Info: iUid+KNY1x27ctb38NGYLavrqY8O8mOj9nsUCQf7uD4B/3ZmmdPo8uJnYKxiG4rjQzQqlRFsLwkJKr7EC8EFx8ovPAKZb+QYdHx6/1IqrSn/wrTLSfeRHYUSi+vyz8d21g58FWlyBi0RUucEhDC8qsneREGmOOmTyRaWHE/nmkxSEEWNjfSvZNZO47BlmNiGTBo+AA/w4xNzZyX4Vs6z0lbjuOl9nKXwk3hAXNSDZmX4rraw/VAI8Hedu5pQ5YWVrutNATC7IToAnMJqWSYmpIWfoOoaFW3IkhDYsX4OuGHu6+giRMSe1iVoHPyt6EeQMdQnogGRfEBT6ly9EtW3q7hJFBIrV4WtrozH8MOKAKE=
X-Microsoft-Exchange-Diagnostics: 1;SN6PR11MB2575;6:v00YSnhpKq7d6Z/WEV3kSKnVp49vG94CFyJUs7EMDDrx4bucF6HnnXoEdny7gW5F9NmooJglcwzRnCv/qvCLbpIaf72TSSZvdrXSAwigB4YYutwaXnRQPaFgqabf+sZXuYFLgh+BkafQAWDwI4FG4PAYTLzGJOeDcrrr+i9zEyLUEWOAojVv7rnGY22aRuneGu9XN+zKPEQNsOZvcB66BlCIBbZ4vJ+Ue5h9bbhHXaGzqhstmIxMEenmwQlSmmXtfPOCblPoW1Eso1hj2CuH9f1H7GDSivFjun3SOp5Nudf0pL7XIrl4jbfsD+WkeJqt8F81inarCjfILSTPMLR02YAExnlAMA9I6K/REDYhZ5f3i4zW9Bab2i5BtSBRHd3SaQNjmEqe75rGwbYxfN4jeCddqYtMJsa+r2/yn/rxjq7H/N0nyIGisH7msTLwjTaDRO8bKh4g1Hg5xcWQxZXsSA==;5:aZNXZMjFvQ5+sDOxo/XrmASW59tqA4Tf6RJLrqTrr6pRTSwjfkQS+DLvPuLQjBWXNB9Q3bBlQhDsb2S2ge4DNLMMN1flB1RnGX2Oe2NvvTrGVye7Wg6onVWAbMkv5rvqfMnUPIgWQZ0lUJEIXCtNjaTR1CbAFUH7E4jdp9VaW4Y=;7:+Fz+c0LPlV9TxMYDrv3RBIIKMMJoOKWuM2iFx2Lu53tK+eV3w+VBVTmZnQVRfcc/8uGWlQJTH/YI/lnap6FQEEooUryD6kLsFxYjmeB/AFAMjb6LdDbaMCeQeBv0mKFRW6RS1TnhrYlAb0MWXe8NG5U46EjDtcD3U5flST3HY4wp65UteKB1WQlrRu4AcRYi58AQm4As0qZfnDYyp2vQpm+ymLx/gNjklcO1FRB9QbObfOnEMQ44tr3bdFWuAg55
SpamDiagnosticOutput: 1:99
SpamDiagnosticMetadata: NSPM
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2018 10:34:59.8038 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e11c046-9fac-4162-4691-08d62dd2dfcf
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2575
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 10/8/2018 7:50 PM, Johannes Berg wrote:
> On Wed, 2018-09-26 at 15:55 +0530, Ajay Singh wrote:
>
>> +#include <linux/ieee80211.h>
> you include it
>
>> +#include "coreconfigurator.h"
>> +
>> +#define IDLE_MODE	0x00
>> +#define AP_MODE		0x01
>> +#define STATION_MODE	0x02
>> +#define GO_MODE		0x03
>> +#define CLIENT_MODE	0x04
>> +#define ACTION		0xD0
>> +#define PROBE_REQ	0x40
>> +#define PROBE_RESP	0x50
> please use it too.
>
Ack.

>> +#define ACTION_FRM_IDX				0
>> +#define PROBE_REQ_IDX				1
>> +#define MAX_NUM_STA				9
>> +#define ACTIVE_SCAN_TIME			10
>> +#define PASSIVE_SCAN_TIME			1200
>> +#define MIN_SCAN_TIME				10
>> +#define MAX_SCAN_TIME				1200
>> +#define DEFAULT_SCAN				0
>> +#define USER_SCAN				BIT(0)
>> +#define OBSS_PERIODIC_SCAN			BIT(1)
>> +#define OBSS_ONETIME_SCAN			BIT(2)
>> +#define GTK_RX_KEY_BUFF_LEN			24
>> +#define ADDKEY					0x1
>> +#define REMOVEKEY				0x2
>> +#define DEFAULTKEY				0x4
>> +#define ADDKEY_AP				0x8
>> +#define MAX_NUM_SCANNED_NETWORKS		100
>> +#define MAX_NUM_SCANNED_NETWORKS_SHADOW		130
>> +#define MAX_NUM_PROBED_SSID			10
>> +#define CHANNEL_SCAN_TIME			250
>> +
>> +#define TX_MIC_KEY_LEN				8
>> +#define RX_MIC_KEY_LEN				8
>> +#define PTK_KEY_LEN				16
>> +
>> +#define TX_MIC_KEY_MSG_LEN			26
>> +#define RX_MIC_KEY_MSG_LEN			48
>> +#define PTK_KEY_MSG_LEN				39
>> +
>> +#define PMKSA_KEY_LEN				22
>> +#define ETH_ALEN				6
> umm?
>
>> +#define PMKID_LEN				16
> ??
>
>> +#define WILC_MAX_NUM_PMKIDS			16
>> +#define WILC_ADD_STA_LENGTH			40
>> +#define NUM_CONCURRENT_IFC			2
>> +#define DRV_HANDLER_SIZE			5
>> +#define DRV_HANDLER_MASK			0x000000FF
> Also this file is strangely mixing
>  * 802.11 constants (that you shouldn't have anyway)
>  * driver constants/structs
>  * hardware/firmware-related things (at least it seems like - e.g. the
>    "REMOVEKEY" constant)
>
> Please clean that up, separate the things, and pick a better
> namespace... just having "REMOVEKEY" is probably not a good idea.
>
Will work on this to clean it up.
>> +typedef void (*wilc_remain_on_chan_expired)(void *, u32);
>> +typedef void (*wilc_remain_on_chan_ready)(void *);
> Please no typedefs.
>
I think as per coding style the typedef for function pointer are allowed.

>> +struct rcvd_net_info {
>> +	u8 *buffer;
>> +	u32 len;
>> +};
>> +
>> +struct hidden_net_info {
>> +	u8  *ssid;
>> +	u8 ssid_len;
>> +};
>> +
>> +struct hidden_network {
>> +	struct hidden_net_info *net_info;
>> +	u8 n_ssids;
>> +};
> This seems really odd - what part doesn't cfg80211 already handle?

If I understood your question correctly,  you meant what extra
functionality 'hidden_network' struct is providing.
Actually this structure is just used to keeps list of SSID's requested
in cfg80211 'scan' callback which is passed to firmware. The values are
extracted from 'cfg80211_scan_request[struct cfg80211_ssid *ssids 
-----  int n_ssids] received during scan.

Regards,
Ajay

