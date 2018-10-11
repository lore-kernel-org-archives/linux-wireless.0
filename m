Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F3DAC32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 06:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEB4820835
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 06:59:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="3jykF02U"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CEB4820835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbeJKOZj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 10:25:39 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:9955 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbeJKOZi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 10:25:38 -0400
X-IronPort-AV: E=Sophos;i="5.54,367,1534834800"; 
   d="scan'208";a="21068057"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 10 Oct 2018 23:59:44 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Wed, 10 Oct 2018 23:59:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=39twZ1hPba9INmqE1ZU8D04ONjX8Nz04D6WaQRZpzac=;
 b=3jykF02UPtw5cBWcAsKti3sWWeJSlEo8kwlb0VbwuuCTRRjyizuEaA/6doHzJonMtfFXoSrjoRodAEBqad6eJzzFVvernjlTArahxOpl5WeAzHqUf62+RdbuIXBLs5lzI/t6JtKU1nLZlTXOGe+ZkwD5EjW4Wk6BwgvRAupj5gQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
Received: from [192.168.43.50] (27.59.68.54) by
 BYAPR11MB2566.namprd11.prod.outlook.com (2603:10b6:a02:c5::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.21; Thu, 11 Oct 2018 06:59:38 +0000
Subject: Re: [PATCH 05/19] wilc: add wilc_wlan_if.h
To:     Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
 <1537957525-11467-6-git-send-email-ajay.kathat@microchip.com>
 <1539009224.3687.68.camel@sipsolutions.net>
From:   Ajay Singh <ajay.kathat@microchip.com>
Message-ID: <c48810b4-11ed-4df4-2bb6-d9725406667f@microchip.com>
Date:   Thu, 11 Oct 2018 12:29:17 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1539009224.3687.68.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [27.59.68.54]
X-ClientProxiedBy: BM1PR0101CA0066.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:19::28) To BYAPR11MB2566.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::31)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da2f03ad-9e2d-4d15-9d79-08d62f471e6c
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB2566;
X-Microsoft-Exchange-Diagnostics: 1;BYAPR11MB2566;3:tW4iRmtoTiUjYdsqUIugQ9jgzN9zCxgyzDRwdoRRq0iL1e2B7ajfeLenj5ehmEGMvWpuaSugrbCxqiAZ7zs9MS87mtQS+e5UQikfU7r+Ccbb7/KbRLX6gtUOFqqMupTfYAogl3HFEr+5tUBQvVR3AH7FzGAS7o3YVMoZGlXVGW8qeKt4B/6KERjcHN+9YIY/qDYRV4GAghPhb2f+ZuHUDz/RxV/ccWCLl+MEmmwkuRiBUV+yO0SqZ/TpXQQu+QHe;25:j1HNQVYHR2Hzsmq9RJPGxuOLJHjwFdmNT565lIq8jRPZSkyRQRyFfH7q25YXP5dUxh+IXt4sdio0qob+w8yhFbT/rLf7dcQ/ygjfr4I8AkiL/S1Svexd8rvC6Vo6WWBP8X57vXXLRgPqWu7NNIVsh+Zl5/mVSGlQfDAxzrmslpeU5eYyiG7I1QKl/PeCDe2ftykPIpNRhIKDnBGgEb6Dy0I8RbOeNyZM1PC7m6dB63iaf6BkAPhZ9/jbAJC16oIczkuzBcS7HKpx2hB7OCsVM5K/bH7DjqhzlTvCB4Ld5n3LnqoiA5mq2gGyw2IuHAsURZ3FQZx/GxBBKf1wUCdenA==;31:jbsiPnFRPzaQubCp9Vh7jOq8gnl5M45tV36YaHY2In62vOVfVFN+gegMbKfuAhY6ZpAJOnLj9EziQNycYFWZKinp4D2jAf0PLuwyCVUyLLYQwH3mr/TWWVQ6aOp0JaV4BI6gVKl1bzraXiAv+LxkUBLMxApUuz7QtAvutN8SSo8bBau0EOOZGZcKVqneCd3q1wYH56Wli+eweW0NqGbo6CLnGHVUKqVAuTFtyMoDbZs=
X-MS-TrafficTypeDiagnostic: BYAPR11MB2566:
X-Microsoft-Exchange-Diagnostics: 1;BYAPR11MB2566;20:8fOcdezLnYBWlDxUDVBGHTFphJMGrVjUK77P7Dq4UM8Etpri8pJ97lmh1AAH1d2k5HtHFlhixYC26s2YSGtmhh3MgpOoQARot6ahAqK9wVnCaZQPw3VDI02T39r5Ri8ezVW6qWK1bE002ad8xx9iyDyXISmsc569T9vnAFRx8S02SYWDikPYtjksrdB2zG3xsa7rRpxHXDwYHqDQd2kkdtriiqMfJ0IzGYJMzdr7CgO6s/pMQHoGaL2r2kvIfGCklqiHYJmK77kymlSKNgDLKjvXXC+veKBq/6YoIoS3MccOXwgKu1q7+gbsWNPeQ3ycJdXmAvHGzJBHqfbaKRUEDnigebpDCh2aXxpWEss/sH10FJQa20H1YaBnTeM9HKlqLwx+MbRRXPJ5L7zW3u9+9OByj13A0aSW7AQpEkcPdSA=;4:P/xlILDvNubWk/NucSM4f4BSLivaviNd9utrhIotKL6B4Thr7Drt+jkglrSHAZY9x9qORxsX5Dn1UzbRumMUhKMJA1U9BVtl5Yf/tjfruHRelKRlJQ7fn1QSwFAXqueY9oL1/OAn7uTzIVhvarxdm+YNOvRDVgW/bTxXUkQVVyTkZUr1gdk3uA1xmtwQojZi8cO2kxUcmuNmgFPP8qLJRruhjuB8UO0InaE2jydhsbfcWbWHlr/cEu1pQy5ohNgH45KQbLkfJ4mcx3OYwSMMxQ==
X-Microsoft-Antispam-PRVS: <BYAPR11MB2566CB04E877C97EF5725CE6E3E10@BYAPR11MB2566.namprd11.prod.outlook.com>
X-Exchange-Antispam-Report-Test: UriScan:;
X-MS-Exchange-SenderADCheck: 1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051);SRVR:BYAPR11MB2566;BCL:0;PCL:0;RULEID:;SRVR:BYAPR11MB2566;
X-Forefront-PRVS: 08220FA8D6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(39860400002)(346002)(366004)(396003)(376002)(136003)(199004)(189003)(7736002)(53546011)(52116002)(36756003)(2906002)(6246003)(229853002)(386003)(58126008)(53936002)(106356001)(52146003)(23676004)(8676002)(76176011)(2870700001)(26005)(72206003)(305945005)(478600001)(65826007)(81166006)(2486003)(31686004)(65956001)(65806001)(66066001)(476003)(8936002)(50466002)(117156002)(86362001)(5660300001)(4326008)(3260700006)(25786009)(486006)(64126003)(105586002)(68736007)(107886003)(2616005)(956004)(16576012)(11346002)(47776003)(6486002)(316002)(6116002)(81156014)(3846002)(77096007)(31696002)(446003)(16526019)(186003)(97736004)(1006002)(6666004);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2566;H:[192.168.43.50];FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtCWUFQUjExTUIyNTY2OzIzOjJyVEpyeG00QUM0dFpXdFJvRlJzeERDYk1M?=
 =?utf-8?B?SGN6TTRHTHNxWTJGYlJ5YzE1WmQ4SG1OTHJOTTdpKzlQcUJLdU8ydk1xdktw?=
 =?utf-8?B?T3VETyswM2RKREtXYjcraVBVRXl3bktuaENlOTZ6TFlGU0wyWlg2NE5IS2FC?=
 =?utf-8?B?bG40K3UxNlFENlZXWU92cUZTWm9SOXhRQzloSDVMSXhRS2tDa2taZTF5RTVs?=
 =?utf-8?B?elRFeEx6WHJ2ZGUwT0k1RmNmMTVHNEowU0FJellhdmMxZHNtQm1MZURraHNG?=
 =?utf-8?B?MnR1WWhRVmd1R0VnS0QzODY1L1NibzEvNjhXSno5WHpoVXd2TXRlS1pSeEU2?=
 =?utf-8?B?L0tTRHEvKzlFTGMxdFFGZm1sbnZKQmVZcE9IVVlKTGVzbk1RS3k3NVR1TzVR?=
 =?utf-8?B?UVBaMTB4dGxHQlhZQk9Jb0I1WDl0bEFlWldWdFVtWGI2MjluNHRUQVBmU1Jj?=
 =?utf-8?B?ajgrQlNDWVB4dlFpbEhoUFdIbGJmUEpnYUdYTG9lZ0NLdnBRMisvMnVtUGlN?=
 =?utf-8?B?RGhqZlZ0UE9DWjJHSnpqcUhoMmJSampoRkVJWVQ3VU5raDBOazhCWVhpb2RC?=
 =?utf-8?B?L0JFU1FYWUlvZElnWEg0YitPOFpEaG1LN2pha2FTbzJFSWVZbGY4RzRpaFg4?=
 =?utf-8?B?NGtpd2x5RDRHdnBqVUZxbmVOWjA1cEtET25nUyswZDl6ZmFNSm9uU3dKa0dl?=
 =?utf-8?B?aTBocHBYdXBjRytkSnozNFFQNmVCa2Mvb1hmWFhJek54Z2ErZHBEMzU0ZDkr?=
 =?utf-8?B?WXVQdWJnNjAycStXTmQvZ0ZSNElzSXRwUlB1eEpsUEZOdHMzOG0rS1FscHkw?=
 =?utf-8?B?MUFPSTIyVEwxcmFyYVcxb2F1ZVYybURLTDY3VnVsVytmQzBUeDNWcmtIZjMr?=
 =?utf-8?B?akJnem5Hc20ycy94cS8yZHlpaTN2bHIvS3h1cldUWGNNS2czTTRvNXh5ZWg3?=
 =?utf-8?B?T0pzZlhMT1lSUGt4VERQZHNZVGI5WVlCQ3JKYjQ0ZURNR09qYXVpM0E0TzVz?=
 =?utf-8?B?ZmFac0NMelV3VEJtRVdUL0JpYjNxeVBFMDF3YjB1M2RIeGRpS052bjc1RUdP?=
 =?utf-8?B?eDNSbXh4dElKWmpJQkc2WGFCTkhuSllueUh4YW5lcWd1TUZkYm04Rjk5Ky83?=
 =?utf-8?B?YWxUaVd1YU03VEU4SlFsTjlZbWdBUVQvcWpHWWc3QnVyay9VSHRGN2xMbENE?=
 =?utf-8?B?eGxnMVF6K2FZZytXSUlIWlBjZGhqRStNVnBLaG10dmNIc2x4bklwdkNGY0lR?=
 =?utf-8?B?NnhFRjRuVFMrL0RUNDFBeWFtTGRibzFQU2ZTZ0doUW9nditUcTJSMHdVZHF4?=
 =?utf-8?B?blhpdlpNd2NJTUpjU2ZQU2kvczdBY0tCSTNwdExhcVpReTNSZ1VNUmpsVHNp?=
 =?utf-8?B?dm1wWFNwblUyelRjMlhtRGlrMXBzeTJOaW5CVVI2S1QxNDB6bUZUKzVsdXNF?=
 =?utf-8?B?S3ZtcWVmRGR5Sng1RWkzVXVGOHZIcHFLaVRONlZNLzc1Y2xJVFJraFJZbjBC?=
 =?utf-8?B?REVGcFR1YitobDZJQ0srWnZoc0p5VDF0YzltU1ExTWh2d0NMMWhjZTVjQ3FK?=
 =?utf-8?B?bU4zWXVWK3E1T0ZRV3dxTVplVTMrTjN5cnJVYWMrM2lyeWZ1MkpoblpsWkE1?=
 =?utf-8?B?OTd0S2dkZWM5UUU3aWZGSGxadURneXRZeXozWGpFKzZ0blJYZVdyWUY3Wm40?=
 =?utf-8?B?QjRUa2VuOTF3WGtKNHo3OXJudVVzSXNyQW1UL0NoTnppWDJFMGYvNEorV28y?=
 =?utf-8?B?bC9JZmdqWWtrZ25oTUJxZTlCMStWL1JkM1hCQWJ6bHZMQUxYMFMyQU01QjIx?=
 =?utf-8?B?ME5yVVgwNDZZZDc4ZzJDb1h3SFJFekNERElta2FGeWhFcFIxODZ4cXZxYTFx?=
 =?utf-8?B?Z2NVSm03VHY3WXc4SjV4RUJkTjdrdEo0ZndzRmdxbmZreERMeWpza1dDTjh5?=
 =?utf-8?B?TXFXMHJTdy85NXAzYk9wV2xiZzZTWnp1M0lsMmYrSEx4QWlsUUxtMTNheXRo?=
 =?utf-8?B?aW5OZzArZm40V0FVRjV6NmlVUFlUcXBrRGlDZz09?=
X-Microsoft-Antispam-Message-Info: f6k1gwd+wOwpGhppLw6HAnkjiXp+cOB3+HyaI2dhzu+tCVSL5xZnl+bpI64dhf9VQ7VYDb8QPvekh9z5RvxhT/fKjb2o5EPEJuyFgYlUiTngiuI3/JRqBIGacc/d8FuA9X6CuqsZiSDkPTFWhCmfdoGGEhCfbcvLnOQQ2DX+4594LkFBiZg7fT/hPmELmPo4bPUyug1dCHer0pkHjU8mAeXAVpJ+iUHvTV+51z/4OWnKk6bj6+6E0sp3a7nhuqOlKtpHbEk8RiDlfniiiTJ+SSWRriR36DJHq+QjdmvmTbre2wSUZj5X7vySF0lTMuqpkBpczi3l7ous6daRL7ejf/RTLgdnS+F7dkurN1ezI5g=
X-Microsoft-Exchange-Diagnostics: 1;BYAPR11MB2566;6:63VBtJ5kNuczJhCBm66Tn5CWv7IRDJhcki0hpOdWm+hZpWsgKh22f4X6yyFx0hvkzHNkFdYlByinxkcoM1vv8VG8lIErq8Bq9NRzoN/EaqtOnMFxeThuumeOEXbJAjQec212F0P9uWslC9G7+oCNRGLXgxMVjAo9KeW2o/0iUWeXT+dL4Tv0frRMNI/gJz1buoMK7tZVOxMRnHd1j5yk+8NgVRbWeNXzzoKsmNX1IQfahEc9Ux6SMv5hXOKwQqeSWf5rpsws0N4U98aTlsA9lurteIG9cEMFDCqiRLyx2KWO67R8j8rVVXOHWP2s5iaZxhk4H+fztAKGb1Jx2p9pBCCFZv0et1kqPx6VkjMh2CWffrCPTe6G6lF0wyijPE+d00bWFtEhs5TH5gSCzHiFfvMRw5YoiMGc+ZIx7ikujCokfVZNFwki8lbBsWgISdaOszmh/51Qy2WOGRrV8uExLw==;5:WD0V6n4q7lrORUgMoc9/tnBmG25F0jwBVmzbRjyun2vq7yZfyxa7bgH4N+vZHtsMF2vbrKRvbgF7xIMBOSoBpziFPtrbpeQHysHnhbaZItAvqrtItBoqkSPNnWo8eiuzwPn/M4NzzfdqJ3a9IqmX6Vig3apetQzp4sReP7+kcfk=;7:zUlW5IxKBzwrP5A7KZ5NagH5X5WFqXQJHJ99NtUZegQCDeTjBOVdSSMwvFVktKK/PEd4KCeKtTknrMWLh31X2Oa0eTkdTUiRszS/4SKkdDLZ7irUzghExMbltcCvgozLwu+61/63YTwecE0XR2gJtRFWdfzr1Amx8YhiSueX/f8tPiktkJhOuZch8/Bs9/j2joLmDRZdGTEHK8IxC5DW14EKjHBgp79YsH1rSqnH8HQhbS2XS9EL1NoTYNkvIEtU
SpamDiagnosticOutput: 1:99
SpamDiagnosticMetadata: NSPM
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2018 06:59:38.1777 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da2f03ad-9e2d-4d15-9d79-08d62f471e6c
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2566
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 10/8/2018 8:03 PM, Johannes Berg wrote:
>> +#define WILC_TX_ERR_NO_BUF	(-2)
> Hmm? what's wrong with just e.g. -ENOBUFS? If it doesn't go to userspace
> it doesn't matter, and if it does you can't use this anyway? This would
> be -ENOENT which is a bad idea.
>
Actually this value doesn't return to userspace and its used locally for
the error status.
But anyway we can make use of (-ENOBUFS) instead of adding this new macro.
>> +
>> +/********************************************
>> + *
>> + *      Wlan Configuration ID
>> + *
>> + ********************************************/
>> +#define WILC_MULTICAST_TABLE_SIZE	8
>> +#define MAX_SSID_LEN            33
> Err, it's 32?
>
>> +#define MAX_RATES_SUPPORTED     12
>> +
>> +enum bss_types {
>> +	INFRASTRUCTURE		= 0,
>> +	INDEPENDENT,
>> +	AP,
>> +};
>> +
>> +enum {
>> +	B_ONLY_MODE		= 0,    /* 1, 2 M, otherwise 5, 11 M */
>> +	G_ONLY_MODE,			/* 6,12,24 otherwise 9,18,36,48,54 */
>> +	G_MIXED_11B_1_MODE,		/* 1,2,5.5,11 otherwise all on */
>> +	G_MIXED_11B_2_MODE,		/* 1,2,5,11,6,12,24 otherwise all on */
>> +};
>> +
>> +enum {
>> +	G_SHORT_PREAMBLE	= 0,	/* Short Preamble */
>> +	G_LONG_PREAMBLE		= 1,	/* Long Preamble */
>> +	G_AUTO_PREAMBLE		= 2,	/* Auto Preamble Selection */
>> +};
> here we have a lot of those "constants should have some sort of prefix"
> things ... it's not even clear if they're spec or not:
>
>> +enum authtype {
>> +	OPEN_SYSTEM		= 1,
>> +	SHARED_KEY		= 2,
>> +	ANY			= 3,
>> +	IEEE8021		= 5
>> +};
> These look like they're spec but aren't ... not a good idea.
>
Yes,  these are not part of any spec . We will  add the prefix for
better understanding.

Regards,
Ajay

