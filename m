Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 425E9C64EAD
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 09:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4B5A21479
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 09:42:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="ycbv+GN+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4B5A21479
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbeJIQ6o (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 12:58:44 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:5251 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbeJIQ6o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 12:58:44 -0400
X-IronPort-AV: E=Sophos;i="5.54,359,1534834800"; 
   d="scan'208";a="21251752"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Oct 2018 02:42:40 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 9 Oct 2018 02:42:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3PkgrdVDV2Mb/5YZoCc9HQ7E0ZUaAExsMlXUia/YXc=;
 b=ycbv+GN+duVv8B4gYrnk/JYXH1UhypfMoTHI/a25Ji/uEgeaAWRQCUxeMJ7z1HE+uHlDc/x0fTQUm1kV9d87NUMDTRRjx23iv8hLSqpsEYsGwk0IXgnJ4GP+0UPv1PYxSHaCVNon5Rjws5fyY2iSi3/4y8IwhzV8yoURkgMxNVk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
Received: from [192.168.43.50] (27.59.42.105) by
 DM6PR11MB2569.namprd11.prod.outlook.com (2603:10b6:5:c6::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.28; Tue, 9 Oct 2018 09:42:35 +0000
Subject: Re: [PATCH 02/19] wilc: add coreconfigurator.c
To:     Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
 <1537957525-11467-3-git-send-email-ajay.kathat@microchip.com>
 <1539008207.3687.53.camel@sipsolutions.net>
From:   Ajay Singh <ajay.kathat@microchip.com>
Message-ID: <99c3417a-7e7b-ed55-6ab4-66bf56b4c449@microchip.com>
Date:   Tue, 9 Oct 2018 15:12:06 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1539008207.3687.53.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [27.59.42.105]
X-ClientProxiedBy: BM1PR01CA0112.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00::28)
 To DM6PR11MB2569.namprd11.prod.outlook.com (2603:10b6:5:c6::11)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a739528-e61d-4bb0-8563-08d62dcb8ce9
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM6PR11MB2569;
X-Microsoft-Exchange-Diagnostics: 1;DM6PR11MB2569;3:FpCJYMIVzmS1MqhqMWNLaQc1Svxl6XFde4xHNMeS86hX7qb1iSri/7sN+AOp2MUG71lJ+Na8FVXs3+oTNcKM6XAglu/jLKTcpCWj3Hg8oZekt+PUscv9xhyDF6TO7+EOGIvR3pDQ5jqYdkDF8QkU/0G5xdGC4XL+p+fZzLa2SkjcHNgEIHWdsreOffM9yPuU5RdNPDQ1amPyvjYqruna/A1h2LDfHERUTJyl+T+PWX8779Ryh0sZwUjl/NDKm0YO;25:a+ucvMiLGawQMck3CREGgc6nG8w3MTwFVXPEmw/qvugNAklvwbscA2N25AI0I5RYQX0Xcl7+W+1hEePegHIESYl2+G2b8cnKKcuYnFN4m9z/N+6FCSmkCn8t27IIGYRqeFenj0Ulpx+XnWJPHHflyXtdQrQW3txJVRCKx1Ecm/GShMeIziMhEotmJzxy/CWl/XzVMlZEDyb4eaLXNxiB0ikoT2iJXvD0LwN2zU2sN0yTEZdKx/cFCAL2KnYBa80VTB6zi9jPkyzrFSDf3YEOsodoPrRH83jz4Twor4GEIntQwBNlaJmmizxLkj4Cw4tqGp2Si7uhZzhAe3ZwkHLtKQ==;31:gF6TkgxIHBRH0C2Ud9eX/qBy05lttxFz9DTzwL1Rn/ZHNbyLI1U2UZOXpR2sy1cnvD7tapKfUE/yrAxXFutdWLiEXdACclwYCYyvSJPbCcp6BzYfDUNaH+yydIkNDcHAnrYx5JZQvydiN7VjNSxubq1rzDXlfqYbqwkEBiQTDg26j3jFdoc9ZW5y5xngznGy7PlP8Ed/evmZ4NqYY1UCcCPtxH83HphrcT1hp2mZj7Y=
X-MS-TrafficTypeDiagnostic: DM6PR11MB2569:
X-Microsoft-Exchange-Diagnostics: 1;DM6PR11MB2569;20:RMg3SXih9i0DSYn1Sf1mx2xJHdj17Ki+5d2QY6ikgbO1AmGN1TjBcZ/JLWxKST7Z74dmtmbewU5FnFyx9NZ0jM2+xtasDgKyXY2GCm63KxwtljrGhc9aZm90exiYAl8ks/TYHJ7VwSlPT7uC3hEs8UGgmUtXWMC6K9PZHRLrGxfWLgE54U/vY4ZKvggeo9ks9tFjiocRqGbpAbV+S6Q1hgKmwXOz44jMmmFGhhNOo9OWiEiSKisc7r682tTXsSjhkkE2QQR5RqVrnAKjUBqE14FD239IEy4ORY5czbtw1O7jRLSreMUVSqkKTPQqc/hQkEs/GcTaJzP5CrP/hoJgCAoxayDX6mZg6JNHJDohFMiNzofAsH+RcaKt5P127TOkzu5FevLh4cp/Yh+aabdHnuYEli9xJw9GnfaZUwu7etU=;4:M00LqMZsY1s9Ncie8tDXG4RUKKyGcbBZrXxJPoDc/end9Q+N1PxP/6pNxWFdZuczk0QZ/MYx0GJY3/z1UbTunslHf454mVdmp176cfQw0/kFRodojB6+nbpn1xZ2MFBjrZEmwduj2578xTtuzKAxitMV9vyPKxWbkZUmeL50IrGRg3P2Qjavw9QzgfXvSKe0tHuO/Xn7QBliOiyaPc+Jaydd8C6HFkN4dYjY6mUTc9Eovh2y/vQOEBOZZ/Eey6nu+LHDYp8ASXguCWaNd1lAzq6ndB1bZ14DF7csT9xod5Ui3khRFH1M+DqFajLFFtUb
X-Microsoft-Antispam-PRVS: <DM6PR11MB256937E5DEB1251D4AF26098E3E70@DM6PR11MB2569.namprd11.prod.outlook.com>
X-Exchange-Antispam-Report-Test: UriScan:(788757137089);
X-MS-Exchange-SenderADCheck: 1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(3002001)(93006095)(93001095)(10201501046)(149066)(150057)(6041310)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123560045)(20161123558120)(201708071742011)(7699051);SRVR:DM6PR11MB2569;BCL:0;PCL:0;RULEID:;SRVR:DM6PR11MB2569;
X-Forefront-PRVS: 08200063E9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(39860400002)(396003)(376002)(136003)(346002)(366004)(199004)(189003)(11346002)(446003)(5660300001)(3846002)(68736007)(956004)(65826007)(52116002)(2486003)(86362001)(31696002)(76176011)(36756003)(23676004)(229853002)(52146003)(8936002)(65956001)(478600001)(486006)(2616005)(64126003)(476003)(6116002)(8676002)(81156014)(81166006)(50466002)(105586002)(66066001)(16526019)(5009440100003)(97736004)(186003)(53936002)(2870700001)(26005)(77096007)(58126008)(72206003)(6666003)(53546011)(6246003)(386003)(316002)(305945005)(16576012)(3260700006)(2906002)(6486002)(107886003)(47776003)(25786009)(7736002)(31686004)(106356001)(117156002)(4326008)(65806001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB2569;H:[192.168.43.50];FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtETTZQUjExTUIyNTY5OzIzOmdCNCtIQlluWkpyd2lQVjVOdFo2RUVTNUgw?=
 =?utf-8?B?bk1FZFdkSEROa29XNDlQd0FxZjgyVXhBN1BBYWhvcHVpY1RhdDN6bEVSVGti?=
 =?utf-8?B?cUkyMzlyMXlqS05sdHVjMnRxaThvSFYydlg5Y3lvWjZuZ0FqTDZ0STRFdlhQ?=
 =?utf-8?B?VS9kcS95bXFvSS9WUEI5N2FSS3RYUHN0aVh0SzNpNDJLSEZyRjlkWmFoM2hh?=
 =?utf-8?B?SjFGcVhBdE5xSGFVL2llekFOQWRGemIrZGY0MENrS2VzVXpLRldKZUgxajY5?=
 =?utf-8?B?VGEvTEV5ZEJKVEtmQkZvcGd4N0ZDRksxRGZCNjIrUEpxbHEyNjRMa1ZZSkFU?=
 =?utf-8?B?cmFUcUFrdS96Q2RZYytLVkFWa0paN2o4S2N5bkFSOG9nbEdzampmY2YzSmRy?=
 =?utf-8?B?ay9ub25pcXk0RFhRZHBQaDQ4NGxpaDFOR0hjQjhTT1hVRytSVnlzdG1vRkVy?=
 =?utf-8?B?a1R4WTNwLytIME1jRGg2UDVFbzkrcktKdVpXeDBEOU9NSjcvSXBESDVxaHhK?=
 =?utf-8?B?K2ZOREVJNW43aFJhdTY4cVNvcFl2Q0h6VW9SQ1F3SUpFYk9yb1R0M0V6SFRz?=
 =?utf-8?B?TWpzd3ZDWStiM0gweStaRzhLd3J3eWpNbnEyT29JVGhzc1ZVbU5JR0hVQTJ0?=
 =?utf-8?B?MWlwSkJaTGhNcVlnOG5KZjUyRFZCWVlZblNwUkRGd01kTmlsUjJnRFNwZ2Vt?=
 =?utf-8?B?VWZraGRkUjl2SlIwSWFIbDhmcVYyRUR1bUFlUkl1K0ZBeFVHNUdWV0VEMjJW?=
 =?utf-8?B?Q1lNQmg4WW1sbmdBOFVId3hOcEdFeUFYTkN1U09KN0xhc2EyZU80azdxcGJo?=
 =?utf-8?B?ZnZaODBXQ0FCV0VMOFRDRVJxQmJWSUxqMFhWVXVsZUVwaWxHU1JCM2Q4U0FX?=
 =?utf-8?B?K29KZElVWER5WVNFT3RzSnZJREdnS0JoNHptbHA5SnRRdU9kYmpmQ21vSmtz?=
 =?utf-8?B?K1BzRERLMzVBT3VnU0puUlNDNG40a1lqK0pWRlNJb3p2ZEZTeTJXNWpvOFkv?=
 =?utf-8?B?Y2NONW9weVQ4SEY1YTllZzNYZVRwc3NhZjQyRklPUm4rWTFISHkvK0x3KzRJ?=
 =?utf-8?B?dUlvSElXN3JFaHlHekxaV1JWRFFERXNidUNRdFRESzMzN0VjTzBmcnhDcUZZ?=
 =?utf-8?B?NWNxdlcva2pTTktzUXVrQXNCc2tCa1hKVk1vb3gxYWwxaXVuQ215bDdjbjBT?=
 =?utf-8?B?VzlqUG02Tm9oek1MV2hJWk5uWDJSNEs2OXlRc0RzRjVyZ3luNUVXdVF3VFhk?=
 =?utf-8?B?dzZSTzVtMExWSnZoU2hjNUFBcGRCZUhscmRJYU10UDdHcXhva2VFTzF1YTN2?=
 =?utf-8?B?UDRDSkhKMlozRWY1bmFxcXpZNkJqNzExa3hES25ocjdibzJyb1FXRUpxTHVK?=
 =?utf-8?B?Q2V2eFNySlcxQ0U2SDZMVmtRRU14Y21zc3Zkd3hOY2NMMlZFRG9nN2M1bXFy?=
 =?utf-8?B?ZVBKNnNBMjk5cGNZdWFOb3JnQ3M2WlBBRTgvSmF2V2xXZ3JVRlZMRGFXOUhJ?=
 =?utf-8?B?OXFTWVBrcXlFOWpoaVNSMlRSOHU2Q0VaS3gvNVhFdzlKL3ZnZHJaanltRnBp?=
 =?utf-8?B?SjJaOWRSdytWZEdnUFpRdERjaHN5TitDalNWTFNuaFd2eEI0ZDNTN3BBVHFh?=
 =?utf-8?B?amtZZTFkLzJyMlF0anZoZUdBN3hlazdPZGhTY3NyK1JVTDY4UGZvbHFoOWZv?=
 =?utf-8?B?YmRKVW1aQTl3d2Y3WUlYQWg1Wll4U1VJYThKaVpwTk92cnpWb05aZHRCdU9T?=
 =?utf-8?B?TFJiRHhpb3ZKVHUwRjcwcGZLaUhLOXF5QXMxQ3JobDNhOEFhZzUzQUFNQTVD?=
 =?utf-8?B?OW14d0VMa0svNzBxbWNmWjE2SjdhbFBrbG1idzFVUmpxRW8vNS9aR3NualYv?=
 =?utf-8?B?TWR6aXByc1VaMjNEcE15cldVclhoT2sxdEw3QW16R29VYlhhSXdCM29Va2hT?=
 =?utf-8?B?aGI5TXhNYkJnOG41VFNMZ0hxRTlaUVVMNU1sYXlIbllkZ1VJelhMb3Byb3d5?=
 =?utf-8?B?TzF5SFVSajVnTVVNQ29LL3JSQ3FaOWNMaDBMRjdDSGdOVUV1SFMraXhrZXdT?=
 =?utf-8?Q?IKZM=3D?=
X-Microsoft-Antispam-Message-Info: l5hshPNna5x2MEm9OUUoDA9hD9Ah+fMg5EdslY+VGwyOVDxS5Gqp1TVvp9ef32zQUfUqPzGxecXqfGPe0f7jfUEaIpAB+hK0qXtOv4jvzIn4W9zjuQroOqih1ywVZq2TsFSW+Q4uUagD4hNbe569vUtE4gW0emPMXMbhf46bZ5alJbqTcca+1iiaXfWKg7iOzx9zXzmI9jyzxd2dir6jdZrsG/vmOyG4PC2c3Z0+Oafup97V028ovGpbiQnCUqzFpczan9wTiai2qgiFtP5k1fAWM4YM1rOw4rcEbce8dyLVuUGMaUrIv3SlGYQR1OzsEMu9OTq9R5iMwHppsGTeiyyFilv3nJNM2ldYk3mVY7A=
X-Microsoft-Exchange-Diagnostics: 1;DM6PR11MB2569;6:OawNLssIZbWSMmtC+HwmaOLETEV9+jUlcgNs/vIrsDah+OII6J/QoEPBfbusLhWw+9EwDQoyjpZgPRGlNePZzTfaqkoMnm6I9yIqjPzR9mK9HEt0sFQybcXX6OYX9Tq9VrOo866FQDv7v0TrqgXuifh4rpbmdQvawrZ2Y2SshCubZZSl718D/XzzoH2VblK2t3NVLBFjNYG9d731NVF8EQ7PrJ3PERyoOu7+KWRvC1Qyke/hhuyncuwehuCj2KrAj+yluTGnJTGwdPuInk//IgnGOLAAi6nU/QyRUrbhO9oFl3+xB3Afa/TE6bG/7SrjqGG3/oFPn5bdly77iSyovD4sMREdPnvWtIsYENzpkNvwtalX8axwcdbOxTCNL5jPtolwDBIUMHQNWtwtln76ryrXnCTrAtPqo6Qgeya2xgfs7L28GnNEfFbEkRJmmxSmLpXqLPbPDXhw+xUdvE/yXw==;5:KOwhQ5l7BaH4Skj5cHiFnQUt3b58VY8GjmdBggV3skBTx2tM+JD/nIfLYF3TB1aOqAYEDNNH6q67T0+u6LYnDNOT8lLXebJ5XTSCmvyf7HTrUTIhN6WK5yqw9oB6IQP4hPuZlivBPaCkgzUtezE8NbojcS+JlLGWbTY1KBUNivU=;7:VOue/A7O+KX26DLa9+wdWjtPE4fRXsndvXJxLHqWSusAwT8I8XP85Cl6CBb4FTXo1zOT49qzGrlYeDmMCqtTtLVSKPgWp2eKKqzeaGXsJkiahmsk8sJe1UNnwjRyHHylsq4F2m7B45LANVjsgoqINraNRPY8Z+urmc2GZU8Mk3MJwo6HtwkXdBMnnGrfh/mN1KAtPTufPR5vWua+X64Cftz926XfIY7egVsSQKEW7kvRcWt3ub79NZau4YoxHo/V
SpamDiagnosticOutput: 1:99
SpamDiagnosticMetadata: NSPM
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2018 09:42:35.1166 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a739528-e61d-4bb0-8563-08d62dcb8ce9
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2569
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Firstly, thanks alot for taking out time and reviewing our driver.
I will work on review comment and submit the updated code changes.

On 10/8/2018 7:46 PM, Johannes Berg wrote:
>> +static inline u16 get_beacon_period(u8 *data)
>> +{
>> +	u16 bcn_per;
>> +
>> +	bcn_per  = data[0];
>> +	bcn_per |= (data[1] << 8);
>> +
>> +	return bcn_per;
>> +}
> Remove and use get_unaligned_le16().
>
Sure, I will change these to make use of get_unalinged_le16() API.
>> +static inline u32 get_beacon_timestamp_lo(u8 *data)
>> +{
>> +	u32 time_stamp = 0;
>> +	u32 index    = MAC_HDR_LEN;
>> +
>> +	time_stamp |= data[index++];
>> +	time_stamp |= (data[index++] << 8);
>> +	time_stamp |= (data[index++] << 16);
>> +	time_stamp |= (data[index]   << 24);
>> +
>> +	return time_stamp;
>> +}
> get_unaligned_le32()
>
Ack.
>> +static inline u32 get_beacon_timestamp_hi(u8 *data)
>> +{
>> +	u32 time_stamp = 0;
>> +	u32 index    = (MAC_HDR_LEN + 4);
>> +
>> +	time_stamp |= data[index++];
>> +	time_stamp |= (data[index++] << 8);
>> +	time_stamp |= (data[index++] << 16);
>> +	time_stamp |= (data[index]   << 24);
>> +
>> +	return time_stamp;
>> +}
> get_unaligned_le32()
>
Ack
>> +static inline enum sub_frame_type get_sub_type(u8 *header)
>> +{
>> +	return ((enum sub_frame_type)(header[0] & 0xFC));
>> +}
> remove, use include/linux/ieee80211.h.
>
Did you mean to use '& IEEE80211_FCTL_STYPE' to get the frame sub type,
instead of adding this API.
>> +static inline u8 get_to_ds(u8 *header)
>> +{
>> +	return (header[1] & 0x01);
>> +}
>> +
>> +static inline u8 get_from_ds(u8 *header)
>> +{
>> +	return ((header[1] & 0x02) >> 1);
>> +}
> dito
>
Ack.  
>> +static inline void get_address1(u8 *msa, u8 *addr)
>> +{
>> +	memcpy(addr, msa + 4, 6);
>> +}
>> +
>> +static inline void get_address2(u8 *msa, u8 *addr)
>> +{
>> +	memcpy(addr, msa + 10, 6);
>> +}
>> +
>> +static inline void get_address3(u8 *msa, u8 *addr)
> you probably shouldn't memcpy() here, that's expensive.
>
Got your point but currently  a copy of 'network_info' is maintained for
the shadow buffer. As we have to work on removing the use of shadow
buffer so after those changes this extra memcpy can be avoided.

>> +static inline void get_bssid(u8 *data, u8 *bssid)
>> +{
>> +	if (get_from_ds(data) == 1)
>> +		get_address2(data, bssid);
>> +	else if (get_to_ds(data) == 1)
>> +		get_address1(data, bssid);
>> +	else
>> +		get_address3(data, bssid);
>> +}
> I just noticed we don't have this in ieee80211.h, but perhaps we should.
>
> I think you should just return a pointer though, there's no point in
> memcpy().
>
Same as above.
>> +static inline void get_ssid(u8 *data, u8 *ssid, u8 *p_ssid_len)
>> +{
>> +	u8 i, j, len;
>> +
>> +	len = data[TAG_PARAM_OFFSET + 1];
>> +	j   = TAG_PARAM_OFFSET + 2;
>> +
>> +	if (len >= MAX_SSID_LEN)
>> +		len = 0;
>> +
>> +	for (i = 0; i < len; i++, j++)
>> +		ssid[i] = data[j];
>> +
>> +	ssid[len] = '\0';
> SSIDs are *NOT* strings, don't pretend they are.
>
Will check and modify to make use of ssid_len instead of using '\0' as
terminator.
>> +	*p_ssid_len = len;
>> +}
> Uh, no, we have helper functions for finding elements.
>
> Again, return something, don't just fill out parameters.
>
>> +static inline u16 get_cap_info(u8 *data)
>> +{
>> +	u16 cap_info = 0;
>> +	u16 index    = MAC_HDR_LEN;
>> +	enum sub_frame_type st;
>> +
>> +	st = get_sub_type(data);
>> +
>> +	if (st == BEACON || st == PROBE_RSP)
>> +		index += TIME_STAMP_LEN + BEACON_INTERVAL_LEN;
>> +
>> +	cap_info  = data[index];
>> +	cap_info |= (data[index + 1] << 8);
>> +
>> +	return cap_info;
>> +}
> Umm, no, ieee80211.h.
>
Ack.
>> +static inline u16 get_asoc_status(u8 *data)
>> +{
>> +	u16 asoc_status;
>> +
>> +	asoc_status = data[3];
>> +	return (asoc_status << 8) | data[2];
>> +}
> I'll just stop here - you need to replace almost all of this file with
> ieee80211.h stuff instead.

As suggested, will modify this code to make use of ieee80211.h header.

Regards,
Ajay

