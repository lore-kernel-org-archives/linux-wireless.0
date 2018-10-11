Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A21EC32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 07:26:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B64102077C
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 07:26:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="YBr9A/l5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B64102077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbeJKOwo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 10:52:44 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:51706 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbeJKOwn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 10:52:43 -0400
X-IronPort-AV: E=Sophos;i="5.54,367,1534834800"; 
   d="scan'208";a="21506943"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 11 Oct 2018 00:26:44 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 11 Oct 2018 00:26:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NHsLLM2nVcFebNhOCgdRkDZSxeMGRHsElVRojHtYE8=;
 b=YBr9A/l5GqY0fpkHAQHw4TbV262ku5x5+YgJkmwgKq2Gf5cIjVcsBzpoJ/14rqXwGr9Hffrwy7nD1bjIXZ5A7j7cdxA05vfrwM0kC4kWFhouvMEkupf7A2i+C4/WdS/ldKnEvxlDzxjimZh/BHqvl9Lx9Wuto/bvJwoMg8NIlYc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
Received: from [192.168.43.50] (27.59.68.54) by
 BN7PR11MB2562.namprd11.prod.outlook.com (2603:10b6:406:b0::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.26; Thu, 11 Oct 2018 07:26:37 +0000
Subject: Re: [PATCH 13/19] wilc: add linux_wlan.c
To:     Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
 <1537957525-11467-14-git-send-email-ajay.kathat@microchip.com>
 <1539009674.3687.75.camel@sipsolutions.net>
 <45c17836-9362-d2ef-9647-514b5c75ec93@microchip.com>
 <1539241383.3687.191.camel@sipsolutions.net>
From:   Ajay Singh <ajay.kathat@microchip.com>
Message-ID: <da79a9d9-f3bc-9571-e05b-0cc88db287c2@microchip.com>
Date:   Thu, 11 Oct 2018 12:56:18 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1539241383.3687.191.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [27.59.68.54]
X-ClientProxiedBy: MAXPR0101CA0033.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::19) To BN7PR11MB2562.namprd11.prod.outlook.com
 (2603:10b6:406:b0::32)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d7cdaed-e5e6-40f9-aeeb-08d62f4ae3a5
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BN7PR11MB2562;
X-Microsoft-Exchange-Diagnostics: 1;BN7PR11MB2562;3:5BPNsXFfgg5EPNmRTh4mG8K5vo5BHk6A5Dii4fEQ7omdn8ACYm5WxpKUl6smqOHqS6CMrb1WAL0ASgZ5omLgxAZENHcQP1n5TvbmHVUyPE/RGliF7mm6md5HhQfGnnyUDpF++5FjV42MWP1WYwNHbYqpgzZ0eJy+Raq8WfZ9K4LTZdiQNIZwsucYwRUcQaXBn9J4+u+hyHgzlXX8UuTefXgYtazCGHhpG8/cq4bYsoSzSKDUo9xusI5yUVaXlrmx;25:uzfQ9+9q2GaBXmltJhFKLjZmoBBLaBhos1jmkw9w56gIDamLyDncbZoyU1llk+jY6WyQKMFH6SCo6oKoSXxtJzLEpuGJ4NBBwX51xuNUmdXDKkWJ6QJSNikkWAz4ltt8PAqG1u13T73x0quC3LMRC5xf2+/dqGjyxTZTPAEen/2i3e62c75SA5auj5iJDSpmzV3pzoBMTi5TmA1wIWRo/ViZ53ONZwI4RHZ5Vk/aqK4aJQiQwn3Wm/xpxlR23gkfGVWgONz/KmDuvOG4X30huSefTgm1PAplXXEPyrnv/jdWYLzxFwV6L99Lky29lwASysarII1zAscsaCjy+QafPg==;31:WhIWJSk5y/ngYaYU3+G6Owp/H3mItF/RY09DpnQZxNEfec1J05AQs0i4LfWNTOh/KFMItNH9rxX7Sy8nFLti2rNbl8ojtdx4TvbmhtTo6ApxRKOoltbIq9f/Vp0mnXR27gRzrVTN12SQP1IKgadSF8qea1BpScK8/zJWZW9JgCIzp4o52pyRM19SbgxxT4p34ngUyfPrZ88Zb1L7QQwJRXksUXXENU9x28y/vGntlHc=
X-MS-TrafficTypeDiagnostic: BN7PR11MB2562:
X-Microsoft-Exchange-Diagnostics: 1;BN7PR11MB2562;20:kxVqYd7PpA0/gjj8CjBzRMdou/S362ml0znZwQ4EbJbMHYYnhR539BOQq8/+HdSdKPjmuX2gC+BRENJQQ5w4hAr74ay+Qc0l2EP8PLbypw2qlRugnSL12Nj93yOtZbMk46yR+gi9g5m/WZiCB5yYyEhfDEHHc61n7Fr22otGPv/esjptt+TNzzPrsZeGJva4rWvVJlutUu3HgbwsNhYFZaQr0+l66EAu4PRiRkKmcoTSqqJVfV6IuNHfy6p4Gpxb2bTPpb1RtYCOINyUeY/clLEG9sl6ayikbLn4Igbn6M19nt0GUlr/IsxYpMX0FojWz8XfKFUVpM68PRJ2cCZFKeU/BOAL+SHQmgVPGeYwi5c3uvfWZoTjVsdfklFWqQDbUswqcATFf5RWO4lsD3XXMznvwsLwsnKfIeH1gbRW+mM=;4:84jjMp5xG+tWoZ/+lzFuYpJFyhK6YANuJaD2Lpq0+n8OkIO3yPNGiyLEqB2T1LO+Z3nfU84eEP0xjp69qE7BEf80DEktm5pOFczcxoF8pCBeh6GYw48lsv0mRLeS7ojQqiphic3ko6wvELdKQ/383GyEnY0TR3CF1ikGQ5IsOnokxbqDIvu162KNMsaX6QH7Zy3reAk17TMBaS4C87PkNxWno7YlLO3PRY8My3xzqCfaFGnoOBN8jZrVMGl3GSX8ykRJUJKOYgHZXbnoj5+E9w==
X-Microsoft-Antispam-PRVS: <BN7PR11MB25620CB37FC256F4946AA193E3E10@BN7PR11MB2562.namprd11.prod.outlook.com>
X-Exchange-Antispam-Report-Test: UriScan:;
X-MS-Exchange-SenderADCheck: 1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(10201501046)(93006095)(93001095)(3002001)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123560045)(201708071742011)(7699051);SRVR:BN7PR11MB2562;BCL:0;PCL:0;RULEID:;SRVR:BN7PR11MB2562;
X-Forefront-PRVS: 08220FA8D6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(39860400002)(136003)(396003)(346002)(376002)(366004)(199004)(189003)(65806001)(65956001)(66066001)(186003)(16526019)(68736007)(6666004)(47776003)(1006002)(11346002)(478600001)(446003)(2616005)(476003)(956004)(3846002)(26005)(77096007)(53936002)(486006)(76176011)(53546011)(386003)(117156002)(50466002)(97736004)(4001150100001)(230700001)(4326008)(36756003)(72206003)(31696002)(58126008)(316002)(25786009)(3260700006)(107886003)(93886005)(305945005)(7736002)(65826007)(106356001)(2486003)(16576012)(86362001)(229853002)(6486002)(52146003)(105586002)(23676004)(52116002)(5660300001)(6246003)(6116002)(64126003)(31686004)(2906002)(8676002)(81156014)(81166006)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR11MB2562;H:[192.168.43.50];FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtCTjdQUjExTUIyNTYyOzIzOlhFRjVWK3RsYVljQUVuOGNUU0crL2JvY25o?=
 =?utf-8?B?QUhmRXN1VDZiejVUME5TVndRWGlhaFpEL2YrSmNiaHNXYVltR3NLbGVveDcy?=
 =?utf-8?B?VG5naTRJcTlIT1ZGU00zRFpoOU5qdkFEWldwdGNQWFlRd0F0RzZzajV0Ylg0?=
 =?utf-8?B?Wk41RnFOSGxZMVQwdjZXRkxpbkgySnB4WUNheUpreTA2eXBaVHJ5bWhjdXln?=
 =?utf-8?B?TkRJT2ZnWGs2OEl6U0FMeWJ6ZnVEYnZSbjR1YVQzWmdackRpTnNlMStjK2hZ?=
 =?utf-8?B?SVlxTWZTcDd2d3hkNnBNRURQSHdleUNJeHl0azdoWHk5YzB2WVEzYjRiUmxz?=
 =?utf-8?B?dGQ3bnh4QnpFNk03Nk5VMFFneGRKeUdzN0xFandwanBBYUltRkw4aWtrOEx4?=
 =?utf-8?B?bUs0YmxSM1BjMU1xV1lSSi8vU0l3NmxvSGpyK0RLRi85YmdOT3FSWmVOdlgv?=
 =?utf-8?B?bkNZRnpSN29wMEhvMUdwSElCYjduTDJZalRwbXVDVFF0Z0JZRmI0QXplTG1m?=
 =?utf-8?B?MEZ5RW1HajlWQTVPZVRNZlRHRjVyWENFNGh1NEtmM3hQZW1PMHRmZXd5ZlQy?=
 =?utf-8?B?VURsZmthbnBEMDRQWnN5d0FlMnd3K0ZrWERQRkNmeW40OHg2WFkzZVcyTDI1?=
 =?utf-8?B?MjZMVUpFREtMZHJpSm1aeElkYXNqNnMwMm5GRWpzRlBYNlUvbHBDSHdKbEZU?=
 =?utf-8?B?RkhUMnpnUHo5R2cvZUk2MHV2WnY5MmJiRDd0VWY2K1B1VTRFWkcyL09uK0pP?=
 =?utf-8?B?VFpzSjMyc0MxL24vV2NTKzVXY0FWdHdjd1VnTkE3U0tMM0NpZU5FankwdjJl?=
 =?utf-8?B?ZGkyN254T05HL1NVcVhwM2VFMXBjWE02azVsM2Q4Zk1tSzZXa0RNQkF5a2FS?=
 =?utf-8?B?dXRyZnJHSWpkaUI2ZnJWQjNTNDhVTzN4STluMUs4bjhrSXNNcktYaW8yR1hE?=
 =?utf-8?B?ckZEdHZsREhtdjhZUjlDNlZrMWNYUnZEY0N2d0NHaDZEeXRuVm1NYk1FTnlU?=
 =?utf-8?B?cUhhTHU4UWZ5bzMzbnFOZXJNMUM1ZTVLbmZrU3Nodit6bWpaTUQ2bGVIckJJ?=
 =?utf-8?B?VDRWT2svMVkycmFLbjYxVE1rYnZCd0tLWHlCZlJ5UXA4R1E3MGVkRnpqejFa?=
 =?utf-8?B?MVR2aG1xMFV2V2xrdFhmMnRoNFBKNTZZOEhxNUtvRUluR1RubTBCaWNmcDVs?=
 =?utf-8?B?MC9MZXdmNkdvSmp2dGtCTVlTVG9RUzJnbnMxVFhyWWdubDc3aGc0UWdRbnhC?=
 =?utf-8?B?dVJxOUtJSHJoaEtnWitPWVNQYnFsQ21acFVHdlNBV05QWE16Y2owTWhFaC9R?=
 =?utf-8?B?WHMwajVMUGRKcmUwb2pNekUxQmZhYjdkQ2ExSTdndm5wYVpZWVhiWUNrR3V6?=
 =?utf-8?B?ZzhkWjcrN2FsNzIrS2h2YUpsUVFIUHlmUGs3UjhzaXRKQmdJanJzeTlRVnkx?=
 =?utf-8?B?bVRXNjdGYTBoWGFQQlBTSXFCdVBVelh5RFhHYmhQWklRQmQrMjcwSHlVMWFs?=
 =?utf-8?B?RU9sazU4c2gxamc4UmVCU2liUUJIcW5hUThmcER5OXpuYnRHbDN5S3lxK3R5?=
 =?utf-8?B?UysrdjNxQmR6ckkzLzl3bHlkMlA4Y1RkVVJkM0Zia0VwQW9FS280ZnBIWmhE?=
 =?utf-8?B?SldOWGo3QlZyWldjOWdiV3N2ZzE0NzlRUlZQY09wN0txOU1reFVjaTcycmdF?=
 =?utf-8?B?ekZPOU96R3JEejlwbWtkVHh3NXhxZEtxTkp3SnlDOEoxd1k0eEY1bEt5Zk1T?=
 =?utf-8?B?WHZabC9UREpJUDYrNURsRmlQOCtuMzQ2SFBadFVUL0E1SDhkNTZkakZzeVcy?=
 =?utf-8?B?bGR2MjFjYVcreWdMcDh5cTVjbWZNeFkySUJ4TDRydkxQRVVRWkJZdUFLTnV1?=
 =?utf-8?B?V2Z3dGQ5TDRYRzQxT0x0N0R5Z0RMNG03VkR4RW9WWjRyOWQzUi81WkpvR1FI?=
 =?utf-8?B?ZTQyZTNaQ0VKSmdXVFJadDNVUE9DenRDVjZhUGZ3Si9Ka0tGbG5POU9yVlQy?=
 =?utf-8?B?MlBtdHZTaENFZjFRQm1XVGQxcm9PTDhaSHJxbnlqNzFrallvaklDYnpSOFJV?=
 =?utf-8?B?ODEwdVJUZUluNC9xbXZUQmNjbmYycUNhWFdhVWpyaHlUQzYyUjlEWWlQZFpz?=
 =?utf-8?B?SEE9PQ==?=
X-Microsoft-Antispam-Message-Info: biziMpmGb3d0lbeu7pj35+mi2eW03d8G88NRh788SSJDN3zqtnYqVdAv3NRAS5BdvVw/ebuerv/1sYxz/WMj7/BQ8XTrBlEkzFNMcne5+uk1oeGHUnYppOHIEpR0yyKpP48ceF1stlZW3UT49cvkJVL5iHmRAqatiw6/HeK63fL4WFvTxPOaGy30YQprvtUOUJmaqC20G4hvXzxdvQJaHXbn9Jsazw/40JhxJUSU26SkclwgBm9JRUQ7yoUhTBVBhH42KwnKBRFy6oTjuheT/cwxW1AtXQE1XwAReDCOU9fsorrBO8DYlCMBaKqn8l1l+HieatuHrTPfk6Xz2zArzrVxSiu3yfZFprRzyC/UgCo=
X-Microsoft-Exchange-Diagnostics: 1;BN7PR11MB2562;6:E9Qed68iw0mCMVPnQDVneLE/Jfu/bMPhwOLqUhXzRMkj+t0oqi5N1Un8tzlbyZaTu9eW8aaDhTxLAGODQGXiD7Im5XFOU8MEutIO9anPVLDvzOKs9X6htbvMz+rERDbcsrnVlOdS3iju3n6GbCyGqPdd+83Vl05T9BSDD2BLSbExnDs1D+YthZ8mc19aLNRYM7YIG3s3OUPYgi3/YOrXTipEAUwqM7tvJ86g7QMBX0C4JK9wM6tvL2hmpWQjYxMkE0mL0NVeRgjoosc+pktKG4yv12UhrxGnJwdvp6uCnl1i1xOwoL1J+ZZ1r5cbRk4x9aB0QlYfSp8esLh1DWmYlA9h+V2cciyDv2jpvdvC9TlTmuRPIsRqf18niDbc6yHt/s+C2po7Vil+3/D3pTSFI3h1gPUxE64az9obE4Ay03BpvD2qIE8GFYZyUkJhTR52HvhUQHGUG3dRiLgj7Icpdw==;5:dybE+MvRCxTU8SW0zmymoSSWYjkVtQN6WfHSrPCnmk5k1+Dh/etqt+PEgpXLaIziUL6PpCTInjUUZs5I9ZIB7XrgG5zFPXii1t43DV8y2HHD8hdLCPOD5xuEGZuUy8O8m1SBzOKjPnAvGDBgpoGNPoe9gKXRatik16yl+H/Bah4=;7:qX4JGErXOfczfif+fTociAdsZOXb48P1d6PUq4oeEttVMaak4DmyiC3fkaoTpVb3+RJmPO0aetm1rf02D/qwcmTc7lW4u736iqfdWuF+pFY57NXoxjw/lwwD3OmYNL5uyLJgDd5zSAbvNzvnsfpvHOJ0KhJT7LL9+biLOkMzd11qdqH+A2+MO/1udipcnkhzn85TymUCzDcobDCS8bnd4dwYOgToYifSGBpKLvmBy01LS+5c7SSneSjltSPmOxou
SpamDiagnosticOutput: 1:99
SpamDiagnosticMetadata: NSPM
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2018 07:26:37.2667 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d7cdaed-e5e6-40f9-aeeb-08d62f4ae3a5
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2562
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 10/11/2018 12:33 PM, Johannes Berg wrote:
> On Thu, 2018-10-11 at 12:30 +0530, Ajay Singh wrote:
>>>> +	if (queue_count > FLOW_CONTROL_UPPER_THRESHOLD) {
>>>> +		netif_stop_queue(wilc->vif[0]->ndev);
>>>> +		netif_stop_queue(wilc->vif[1]->ndev);
>>>> +	}
>>> It seems like a pretty bad idea to hard-code two interfaces, we do
>>> dynamic addition/removal these days, in *particular* for P2P.
>>>
>> Did you mean it not good to call stop queue for both the interfaces.
>> Can you please provide some more details about this comments.
> No, I mean you should be more dynamic and have e.g. a list of interfaces
> (actually, you can use cfg80211's list, I believe!), instead of hard-
> coding that you have "wlan0" and "p2p0".


I got your point now. I will check on this to add the support.

Regards,
Ajay

