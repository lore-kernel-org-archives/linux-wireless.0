Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645BFC32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 07:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F06520835
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 07:01:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="K3W/bpH9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F06520835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbeJKO1E (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 10:27:04 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:10009 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbeJKO1E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 10:27:04 -0400
X-IronPort-AV: E=Sophos;i="5.54,367,1534834800"; 
   d="scan'208";a="21068156"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 11 Oct 2018 00:01:09 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 11 Oct 2018 00:01:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8rmvEeUS9dAyZPZvZXSejx+bg7bNS8RH5qBVchgVFYA=;
 b=K3W/bpH9+Y1/QPhDHiacYmV2MWlkPtvvbu6tMQ9lHU5dO+OMTyHmuWAYZ/CqJdaGZ7qzhE98DZTohU+wYkkuMPZvzihnzPmEUrzZYsvBwbgAxzi/kwgiP+mloZ7c8f+1GHJHDfDqKnoWODgqNfe5b4y6R1ureFMgsW3n8mFXTJg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
Received: from [192.168.43.50] (27.59.68.54) by
 BYAPR11MB2567.namprd11.prod.outlook.com (2603:10b6:a02:c5::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.22; Thu, 11 Oct 2018 07:01:01 +0000
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
From:   Ajay Singh <ajay.kathat@microchip.com>
Message-ID: <45c17836-9362-d2ef-9647-514b5c75ec93@microchip.com>
Date:   Thu, 11 Oct 2018 12:30:41 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1539009674.3687.75.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [27.59.68.54]
X-ClientProxiedBy: BM1PR0101CA0070.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:19::32) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3461676a-e5f4-40ee-8c51-08d62f4750c9
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2567;
X-Microsoft-Exchange-Diagnostics: 1;BYAPR11MB2567;3:Vov/pF/AaiXbqN99+O2niMTMjyofd5qZhb+5/XHTm9ji1qg3wsTQl20wfyyLkKJslwwmUwbs1o0RK6j+I5DV//fnYpHqOLXJPay8f298HzfuR5F1g+6nuv6xzz+HlTEFpaUltb9LNAQdj95tc/xLUyoTbe3qBqzN5tyaO2sShGImpX6qLys8nAeSflW2sms7Kw7ToPOTC71fJB7LfLuY/hS0orPvVqN+prHiVugpldcDnBz3l/tqRDnLfpiADdpZ;25:ZL63R3Lin4z5WJNbdOphmvOoYcFDl/iWY6bj+ovyyR9iAWQgF5U23oqVXMqHeK0rOEmOj5zBHjWi4UzwOpER8sB/TrpmwW1+7IpA6DeKleVTGmVGRZH6H9Q8VdCltaKGrU0tjLRoafm2Je1uDb1MIVJwKbleOqlcB1Nw2K5oxBS91oIHKtaQ9pJeFpF1ysm+BNP9pyn7y6YYFnrY9f2zz++uDxQEi4D8ktZ6jSs1YAm/zETMzFsLvdwzIUgUNMzSglU0EgN8t7bYoUevDUmu6SVPpY/vspkiRRmaOEawyH3mYrNybMYl/iHubsM72etnNUs3kjb1wpfVl/TRkAM4rA==;31:rE328Pcu87uTR51uKaI4yt1uhqYQ4iAlEQz3T51D/2qXKwGfjrQBcyr99jhS9jodXUnCOOQaYNP0Uz02O/b8NGZZdGqM0w3JHOSBS8sqQyYolJzjjErqpQeeng5PcJnX5s4hu7Z1z+urYJXGbwATL5Nwo07qFFc4oVF2Zk8TV21IQGB9sPp5dHEyJTBSYZLmGRnuIbfuwPxJiMyJWte6MEEPhKP4TtwrLvoTSEHXzCo=
X-MS-TrafficTypeDiagnostic: BYAPR11MB2567:
X-Microsoft-Exchange-Diagnostics: 1;BYAPR11MB2567;20:Z+iATJAEH25OxTg7/p6w+cLZAdpUetkH40B/6OuHUw5eqjOnD70Y3xSO6db8dQF1lBnv0NH/FJviZVt9yeVNgiPH782302omSyz5B4wpPC+OIsuLKMurk7l0VDdJInR3zAwj5XpoBhnp4MYB+qcG9BQP06bKIVcob9dVMOkmWFlrVKrbKHKZnXRaoxj4JPY/TGgTBh8u71XHDkxBrazN/EHMexaGmS+wxo1Ua8wmwcjNoZCCjfFucwoeEXsbnKh2HLGK4yESpyr6aDrGEp3YhpxQtpa+CzY9+2YPW1R5Rhsmc89Di3Ggu6KEXyoYm2499htJ9BkjYTMHhLxZCvbr2p29pB7hY3qfCFnSMEtidXSwjE8bKZMWNRBIMUmX/3PULVJuc8X4ex7DBsaRf88lz1bbDUWZWevLN5gy4zNUqds=;4:7CWkrV+/CbzPCmLthuu0vSaoxh7CUxc4KXgBXuP4PVSNiyEZ6UhPTLGLN9SmnUTNMCROthEbvzCphd7d0JH6pIi3WWkcWwhOT7zxY8ZWUejyrENHOBB3krRvhn4sFF5X0RHaCbH7uFgU0j1XhjohJ5VGHAEKY10dr89HCEM4OLnKEo9oUa+CWPNSo8fdXm1v7Gt30cOoFdfEzRdgDbKuvrtqQ+LR2rpPAQqHxdWHvuiYSxmBQohOsJQPoY9N6xAIOgtkkAzBPxPz/Tw10DpBdQ==
X-Microsoft-Antispam-PRVS: <BYAPR11MB2567420B31DDDFC1A8799D88E3E10@BYAPR11MB2567.namprd11.prod.outlook.com>
X-Exchange-Antispam-Report-Test: UriScan:;
X-MS-Exchange-SenderADCheck: 1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(3002001)(10201501046)(93006095)(93001095)(149066)(150057)(6041310)(20161123560045)(20161123558120)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991055);SRVR:BYAPR11MB2567;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2567;
X-Forefront-PRVS: 08220FA8D6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(366004)(39860400002)(346002)(396003)(136003)(376002)(52314003)(199004)(189003)(478600001)(2906002)(52116002)(14444005)(76176011)(50466002)(3260700006)(25786009)(36756003)(2486003)(8936002)(23676004)(52146003)(31686004)(68736007)(230700001)(1006002)(3846002)(106356001)(6246003)(6666004)(105586002)(316002)(7736002)(81156014)(305945005)(72206003)(81166006)(107886003)(64126003)(4326008)(6116002)(16576012)(386003)(476003)(97736004)(58126008)(117156002)(2616005)(956004)(26005)(486006)(186003)(77096007)(446003)(86362001)(6486002)(47776003)(16526019)(65806001)(65826007)(65956001)(11346002)(229853002)(53936002)(8676002)(5660300001)(31696002)(66066001)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2567;H:[192.168.43.50];FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtCWUFQUjExTUIyNTY3OzIzOi8rU0tiK0tEWW8xL2VxTmRHNFUvenFqSmE3?=
 =?utf-8?B?eHpjL2xtSjBjWmhpN2hHdmNsNlZVZFkzNkp4TXI1QTFacTFRN1luYlFHWnUy?=
 =?utf-8?B?dVR2MEhOcTdzRFV6NXpOd1ZqTWt5RjNIYUVqRDRxZnFnK2gvK1IzWDVtbm9X?=
 =?utf-8?B?NTVmditlNGl3RHhjYldtVUFTazAvMkdhajJWdjNCckthQW4yWWNmKzRZdXJJ?=
 =?utf-8?B?Vmd6Yk8yYnhnTkp6YWlERW43N0s2MmhTR2FtYWFmVFVWTC9WaCticlVrWTlv?=
 =?utf-8?B?SUdkd3VTWW9CZFlwTFpCSXN1ay9SYlpKQ2doVit1VmFhNkRHb0YyZ0tRaFF5?=
 =?utf-8?B?clYyNmlrclpnMUt6UzZuWWVPeG0yd3BDdWJvbm5XNDY0NzlEOHlqK08yZUhs?=
 =?utf-8?B?SHJkckdUL2xaUlRMNEljVmZ2TjVIRnVleXd1TWk5ZWhVaUZlb0grT0xMRmlC?=
 =?utf-8?B?c1UrVkFERythTmFBeVVoQ2oyMlNSRGRDZ2JLNEg1blRVSnVQdE1paWNHcEs4?=
 =?utf-8?B?clNhZEJWK2Z1OUJ4Q1Y3anJDWmVjdHRpc0Y5SjB1Sm5MNFpBOUtLQ3JVS1dT?=
 =?utf-8?B?Y2lXdWRTbzlRRTFtR2hSemRpK3ZST2NlN1poL01IVGFEaHlNOE04VTJQUmM4?=
 =?utf-8?B?djZVRUVSTnliQnNabHhnRkV2Tm5JQUhZVnB6ZVhwSnVtVGFkZFZUKzh5WUxr?=
 =?utf-8?B?UjJ6M01IQWQzY1BFS1FZYXY4Z1JIVkYrMW5yMjRPMzlmNFRvcmhYcHlDRnN6?=
 =?utf-8?B?VGQ0emF4T3lLVHcvL2VIRXYwZDZFVld2dzZmWkx0WlY5OGVWWkhOUXpPRnpJ?=
 =?utf-8?B?NDhJM3RtOHhENjBOYy9QVDdVRDFkYUhIbEo2VG5ZR2QzNXJCejFIMU9kNS9F?=
 =?utf-8?B?WkVESE1paDVjNWlNalJueTNnODRCZTNDQXdDdWdKMXpPMGdROUFmRkJ4bDB0?=
 =?utf-8?B?VGhic0dYd2tpLzZJeTRYMjM2bWF5ZmtMTGVWRys3Rm9IRnNSWVpYUUhtZUh0?=
 =?utf-8?B?NVlhakN2RVhvY3FnNWx0czJLZmpGVll0VXV0clVodzJWQkpxNUg5dkpieWJW?=
 =?utf-8?B?dVpzZm1Zb1dkWi9EMEpkMnY0Y2Z1NHZMZE5jQkhmRWpGaTJsaWtLcGpmcnVo?=
 =?utf-8?B?QjNUQnNTNWRlM2FEZnNYYlJCemlQMFpjc3F5c3k0VWs4ZnRsVkRRSTZwcUNt?=
 =?utf-8?B?cFd3WVFLdzlZanpxNE9YQTNSeGdpL2NJcERZdWF0R3B3Sm0zWjEzRmV2YktW?=
 =?utf-8?B?dGoyWUdmNnhRRi9QRFU3cEpRVGNuMTlpa29WV2pYSDFoTnMycFNUbE9wdDJ1?=
 =?utf-8?B?TWhCd3QyNmc0R09sQVNlcnZmVzJGb1dqanRnamZFUmtGRnZSV2d1N1Z3d3Iw?=
 =?utf-8?B?Y3RnelBRdldqNndNeEN2b2Fjc2hsaDY1MnFCQy9lUlVvRXB6R0dlSEl3Sy9E?=
 =?utf-8?B?eGZ5NWY4VXNaU3RIWCtmbW5Da0ltRmtkZlByUFBkekdqRkpOc0x4cUJjakFO?=
 =?utf-8?B?UmpzQlRidFR0YlY3R2lRa2t6dDJSUVNwYVA2cXVkQ3M5KzJTMG8yYTNKSDY5?=
 =?utf-8?B?VWFSRERoMkZvQllJVUlDZkpXQUN5b3VScVdPVlpQZUUzWjJpZ2JaZGNlK081?=
 =?utf-8?B?SmR2NG9Oa3Y0MjRPcldGQS9UM2grZ2lYVFdnUnVlVnlBRjAxbVp0bjRuZ1pO?=
 =?utf-8?B?K01CL0VLdWoxMGZmVzRFUkdGZ2xSUkpxenpnNEdEd3ZVdGcyZE9YUmZBSHNm?=
 =?utf-8?B?Qzh0dlczcDdZVFBxUzZzWnZzVkgrMDlRdHFCYllUZDNiN0VSN0tCU05wNC9Z?=
 =?utf-8?B?ZjBlUFpyUWlJUURnWTQwM1NhLzljd2hxOEE1NWtvWTk5UFRyZ0RnbW5td3RM?=
 =?utf-8?B?Y2lCUVF6aXFLakV2cmVMOTFFUjFxdVJCSEV2VXErcVQ5bWxFVkV0MCtDV0hu?=
 =?utf-8?B?MXBzUmFvd1Z2Qm03L3cxY0JFL3NGUmVMQzBSKzI2d2swMzBpSU1mSjkwcWhq?=
 =?utf-8?B?aGpRWVRvYTRaNmZUOTZ4elZXa3B4d0g1YXdndURvbHlyZEwyS1lRK042Yy9y?=
 =?utf-8?Q?Mb4NpLZ8HqCHkWxukD4Q6wbG/?=
X-Microsoft-Antispam-Message-Info: fEG5KIC11+YCK6RV9CtdURgkfw743U4OIvm8lX7DVzC2+DV5TTppFQ1uDtyoPGm2jcv5NZa4Fv32NJv38CikL5ELU/AyVRuvcDskTQwg/NdcLLJWkN/ggzQ60k4jEd9PcSLqZaRKlT/SDg6wd6p3PoahK4RWJbQ2MFGK59eJw1DoTFjoO34tH0Ol6P0XQlYgJjwPTEuC1X5BIwPKAZuUVTdxk8hX6Sj8lVcaZyujuwVOpeMv1VtuvHnaQAVBWAWMUdbFGUPp1TwXmN0QZ2xryYhjk4I+/RvAaMckKdCpen0lsDyq2od0IvLePwvkSKU5ag8x06b7/QqT/WbQXX0CdADhlFA0jusDboUib0lxhm8=
X-Microsoft-Exchange-Diagnostics: 1;BYAPR11MB2567;6:q5PuyUBtUPBKGZt1EMkDAD6NcZ84kZIa0B5DjGAlmrUEbrAGkP1ZjcUKcGnt7zXdszMFNq1iQ6CkCmiR1Zv8jol+R0F918cK2xQAgxftE/AqAacofn4ozh3BMpch/FHYN+5nKx88xSHIgMzfE5DYblKPvLbAq+mrpMHb6o4z++DmJF6huQdJh7GLUi97tRAlgAM6/biAy82ZWszrfAXUqHyUyODqzQsguYMe1eVFRro+Y+pcyEV35eK+Qm4+pymDf9ql1VVm78Ku6QFfDnNQw2/6hi9wZ/18oLFwitknhZiuMDt7YiY2EDkXz/XhbPLfa6Kf35/LDSz8fpVqyAxpwOuzPwuNjYS2vGPDxZ2TmDZkoNem0plapvvSrzoJopj0eRrMOgECzv891Z/W6R9zydEv7HP1tivkG5bZpsqiDFaFN1mGYyns/R565m69kmPyyLxt9KLYaqHAksRebgho9g==;5:TcFC3hcgY0nrLXBy6NtHgU80p20GqLgQPogNIR8LpUb3aIUF7Vhr4P0f7VesTfO2EUYSFKGTk72f/cMuD5iadS/0c+74Hv8YhQ7BML9IPQXIj0CGOm+m76BsX9t27EZK6aERySYQHDLZHMg5pJa/0ObqUZWTHljPVXocZsxM73E=;7:jvA+NnsIRvgRX91vSZ8c/cAXelml83QyPjkeCs/IP3ruHr+HlIdyC2VeYIDMd+0fRkF+z3/HVmLzm85E943adew8mD4vqf+RZs7L1YLh2fSLWI14eapAdwNUnHd3kpS2sxh/RZIcCi5lRVUPSlCA7KdJKCuoUpQNB7YPTG2sIbBFrFQ4hiAMZ691VEFq7cF9oO9/lFgDm4GL7Ecs5FrQJAtFFgaxMcONpGE1SoK2V+TNpVbt+eUjxwwx0nioeRvY
SpamDiagnosticOutput: 1:99
SpamDiagnosticMetadata: NSPM
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2018 07:01:01.9842 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3461676a-e5f4-40ee-8c51-08d62f4750c9
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2567
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 10/8/2018 8:11 PM, Johannes Berg wrote:
> On Wed, 2018-09-26 at 15:55 +0530, Ajay Singh wrote:
>> Moved '/driver/staging/wilc1000/linux_wlan.c' to
>> 'drivers/net/wireless/microchip/wilc/'.
>>
>> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
>> ---
>>  drivers/net/wireless/microchip/wilc/linux_wlan.c | 1161 ++++++++++++++++++++++
>>  1 file changed, 1161 insertions(+)
>>  create mode 100644 drivers/net/wireless/microchip/wilc/linux_wlan.c
> Hmm. It's pretty obviously a linux driver, what's the point?
>
Agree, will rename by avoiding the 'linux' prefix.
>> diff --git a/drivers/net/wireless/microchip/wilc/linux_wlan.c b/drivers/net/wireless/microchip/wilc/linux_wlan.c
>> new file mode 100644
>> index 0000000..76c9012
>> --- /dev/null
>> +++ b/drivers/net/wireless/microchip/wilc/linux_wlan.c
>> @@ -0,0 +1,1161 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
>> + * All rights reserved.
>> + */
>> +
>> +#include <linux/irq.h>
>> +#include <linux/kthread.h>
>> +#include <linux/firmware.h>
>> +#include <linux/netdevice.h>
>> +#include <linux/inetdevice.h>
>> +
>> +#include "wilc_wfi_cfgoperations.h"
>> +
>> +static int dev_state_ev_handler(struct notifier_block *this,
>> +				unsigned long event, void *ptr)
>> +{
>> +	struct in_ifaddr *dev_iface = ptr;
>> +	struct wilc_priv *priv;
>> +	struct host_if_drv *hif_drv;
>> +	struct net_device *dev;
>> +	u8 *ip_addr_buf;
>> +	struct wilc_vif *vif;
>> +	u8 null_ip[4] = {0};
>> +	char wlan_dev_name[5] = "wlan0";
> Regardless of what you're trying to do, thta seems like a bad idea.
>
>> +	if (!dev_iface || !dev_iface->ifa_dev || !dev_iface->ifa_dev->dev)
>> +		return NOTIFY_DONE;
>> +
>> +	if (memcmp(dev_iface->ifa_label, "wlan0", 5) &&
>> +	    memcmp(dev_iface->ifa_label, "p2p0", 4))
>> +		return NOTIFY_DONE;
> That too. What???
Purpose of this function is to deferred going into powsersave till the
IP address is acquired by the interfaces. This is to avoid any issue in
acquiring the IP address(due to power save mode).
We will investigate and check the better to handle this condition.
>> +	dev  = (struct net_device *)dev_iface->ifa_dev->dev;
>> +	if (!dev->ieee80211_ptr || !dev->ieee80211_ptr->wiphy)
>> +		return NOTIFY_DONE;
>> +
>> +	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
>> +	if (!priv)
>> +		return NOTIFY_DONE;
>> +
>> +	hif_drv = (struct host_if_drv *)priv->hif_drv;
>> +	vif = netdev_priv(dev);
>> +	if (!vif || !hif_drv)
>> +		return NOTIFY_DONE;
>> +
>> +	switch (event) {
>> +	case NETDEV_UP:
>> +		if (vif->iftype == STATION_MODE || vif->iftype == CLIENT_MODE) {
>> +			hif_drv->ifc_up = 1;
>> +			vif->obtaining_ip = false;
>> +			del_timer(&vif->during_ip_timer);
>> +		}
>> +
>> +		if (vif->wilc->enable_ps)
>> +			wilc_set_power_mgmt(vif, 1, 0);
>> +
>> +		netdev_dbg(dev, "[%s] Up IP\n", dev_iface->ifa_label);
>> +
>> +		ip_addr_buf = (char *)&dev_iface->ifa_address;
>> +		netdev_dbg(dev, "IP add=%d:%d:%d:%d\n",
>> +			   ip_addr_buf[0], ip_addr_buf[1],
>> +			   ip_addr_buf[2], ip_addr_buf[3]);
> %pI4, I believe, but I think you should just remove it, it likely won't
> have an IP address anyway, and you might have multiple, and so this is
> just broken.
>
>> +	eth_h = (struct ethhdr *)(skb->data);
>> +	if (eth_h->h_proto == cpu_to_be16(0x8e88))
>> +		netdev_dbg(ndev, "EAPOL transmitted\n");
> Err, no, just remove that.
Ok.
>> +	ih = (struct iphdr *)(skb->data + sizeof(struct ethhdr));
> Sure, everything is IP. You just checked that it wasn't EAPOL?
>
>> +	udp_buf = (char *)ih + sizeof(struct iphdr);
>> +	if ((udp_buf[1] == 68 && udp_buf[3] == 67) ||
>> +	    (udp_buf[1] == 67 && udp_buf[3] == 68))
>> +		netdev_dbg(ndev, "DHCP Message transmitted, type:%x %x %x\n",
>> +			   udp_buf[248], udp_buf[249], udp_buf[250]);
> Umm... no. Just remove that too.
>
Ok
>> +	vif->netstats.tx_packets++;
>> +	vif->netstats.tx_bytes += tx_data->size;
>> +	tx_data->bssid = wilc->vif[vif->idx]->bssid;
>> +	queue_count = wilc_wlan_txq_add_net_pkt(ndev, (void *)tx_data,
>> +						tx_data->buff, tx_data->size,
>> +						linux_wlan_tx_complete);
>> +
>> +	if (queue_count > FLOW_CONTROL_UPPER_THRESHOLD) {
>> +		netif_stop_queue(wilc->vif[0]->ndev);
>> +		netif_stop_queue(wilc->vif[1]->ndev);
>> +	}
> It seems like a pretty bad idea to hard-code two interfaces, we do
> dynamic addition/removal these days, in *particular* for P2P.
>
Did you mean it not good to call stop queue for both the interfaces.
Can you please provide some more details about this comments.
>> +static int wilc_mac_close(struct net_device *ndev)
>> +{
>> +	struct wilc_priv *priv;
>> +	struct wilc_vif *vif = netdev_priv(ndev);
>> +	struct host_if_drv *hif_drv;
>> +	struct wilc *wl;
>> +
>> +	if (!vif || !vif->ndev || !vif->ndev->ieee80211_ptr ||
>> +	    !vif->ndev->ieee80211_ptr->wiphy)
>> +		return 0;
> I'm not really sure why you're so paranoid, none of that can possibly
> happen.
>
>> +	priv = wiphy_priv(vif->ndev->ieee80211_ptr->wiphy);
>> +	wl = vif->wilc;
>> +
>> +	if (!priv)
>> +		return 0;
> Nor can this.
>
>> +	hif_drv = (struct host_if_drv *)priv->hif_drv;
>> +
>> +	netdev_dbg(ndev, "Mac close\n");
>> +
>> +	if (!wl)
>> +		return 0;
>> +
>> +	if (!hif_drv)
>> +		return 0;
> Nor these.

Sure, will remove the unnecessary check in this function.

Regards,
Ajay

