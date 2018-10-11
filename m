Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 638F1C32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 06:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11C042085B
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 06:57:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="KKNnq8tO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11C042085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbeJKOXW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 10:23:22 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:9883 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbeJKOXW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 10:23:22 -0400
X-IronPort-AV: E=Sophos;i="5.54,367,1534834800"; 
   d="scan'208";a="21067939"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 10 Oct 2018 23:57:28 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Wed, 10 Oct 2018 23:57:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DkZLZuOYhnZu3+uCekGZmREvUBQpqgzWBzWes/tUSRg=;
 b=KKNnq8tO3BuNWYSJCKqZ07M1sHj0FHJy795hBE0Q+6Jk8EVBuiXLnlTGZO+dkpei4B8WXgktTS13UsEm9SVbix+xSBzyrxdwkswgohPcmyPQ9t4oNr/15zXT3OT+G1HW8AKdIeVX3W3mtOMPwIgxdx9yL/ejOP6atvXYegYSemM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
Received: from [192.168.43.50] (27.59.68.54) by
 SN6PR11MB2575.namprd11.prod.outlook.com (2603:10b6:805:57::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.24; Thu, 11 Oct 2018 06:57:22 +0000
Subject: Re: [PATCH 04/19] wilc: add host_interface.c
To:     Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
 <1537957525-11467-5-git-send-email-ajay.kathat@microchip.com>
 <1539009076.3687.64.camel@sipsolutions.net>
From:   Ajay Singh <ajay.kathat@microchip.com>
Message-ID: <0b8ac9dd-395a-9c49-0f46-283ef0818e4e@microchip.com>
Date:   Thu, 11 Oct 2018 12:27:01 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1539009076.3687.64.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [27.59.68.54]
X-ClientProxiedBy: BM1PR0101CA0054.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:19::16) To SN6PR11MB2575.namprd11.prod.outlook.com
 (2603:10b6:805:57::20)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74023f56-4c41-4452-70e8-08d62f46cd51
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:SN6PR11MB2575;
X-Microsoft-Exchange-Diagnostics: 1;SN6PR11MB2575;3:kBU8QMoFLC64qytEbE2/TOpjpvNUkMN2vTFo63txL6AvIhmMtBXzyYX+c/5wfJN5DGmwyzBt7lUi6H7VXrQ52gcz7wZY7pbZj18ygVdVgeMpwiH0NCLvl9oCPC1FXhEaWzOAK88gtWQ+IthMUeCg5WA2x0WB+b9dXs+gwEKTZfML8iWHXmWRfKWDQdu04L/xWanIC2wN9Nf6PbnKzTS8vao9ZIiswUm7+AZ3edm8Ju/+r3JIZ1bG3JtFrMXF613z;25:x/Ik3036jsk3YnevxqeB3uc8btuK78geJwDy/6/DLHjqPDvghK961f1+wZJVdmpBAwRrc72iHpyToN5MCODl+MYwQzXvTqwPoXrK6Ekr41QHptk3ChmQz7AM3vJqaPlc9mNufZVmXePOGSglkQfAZImFwNR2MtX3BQSuyiaSKfLNc8d08aCX9O5PeOb1G3pYP+4B4QQ1KyQ3UOcM6EL4lCJ+fYR4yNTeVhASUQEdSNhv1O4CtftOERoK4qJJtBlkvCKzA6Y3lgHXXM5szEM0ep7Y+thWv5tUK0DreQ4GAEw96cCSb6RTW8DRzPbzQgJFyTNBt2sfKdtNe8W8d5zOyA==;31:3IaGvtTmutfc4ZKFvPrxrjEwf1QVxKBhgD6Hm0gA9lg6QpyYFXMDiGiMN1yIYqO7IOFsG3FuQNka5anatqXRJi2HRlwpKJCHY0+mEPZN2V8IpkDTlBe2p9Qtrv2KeFHPFZBvnbenZzVP4OeGdnuN/F2k2HTRl5+pf5gIW4Wp7S0nstdFJYqdA8OWSwYVVKSV3w19yDEwXLJC//dxiQLG3bDg8LHTdh8h53LGtrhymqg=
X-MS-TrafficTypeDiagnostic: SN6PR11MB2575:
X-Microsoft-Exchange-Diagnostics: 1;SN6PR11MB2575;20:TUCiYaKSMrL5RwN0VTu5pPB/CuOTLIpbwvX5BA22dOKmXC/vplM3nUb40nXYRg92fTscT2GHz4LCr3Ui7Oh/mXyhubnhfovdv6ooVM5CF3sM2BtirQcKEBt1rq1VwLDPO55qwt5mAMmLTew/nMSk3cjQv7f1HW/1Fy6wCJ8Lgjs9FaT1hfGjz/YarKX8zZ//ZFdb8UiH2XS9ZFi2wgHtp/1LyEY5hfVrusRt6IzThBiWrHDZm5ePlBqSnvfl7mbnamumcYiNo2lTzpKFyNPMUyDAmILI2RY8Rxiz/KGsExBduTuPmT6ch14SydUjKR4hk8qPwE8fxX7MyAzlaLrT0bpuIpQwz0F8Kl5w7vcHhA0ivjBLELFDA8bB1mWFD+TuDyrsWNddRZfZQrC1+EajgU3xby+XSQyDUdxvhBYkfHI=;4:6zXSvsLldGubmV1Nb06rWDHtqBiwXpxzbMT4ZNkBv9r6nZD3OgDw/YlYaxw+cZ02BLVR9lZEbJViZmgBhriDVeknOtBUdOSoYGrYZUXCjDf2qlxonfSXDo8VVuG2+l4q35Peyhf4kkViQXYLx0ZsqPJKM+xbd7l/S60reIJOsEj1vMToI/VfLT+xmoGAf5ohfmA3jb+aePGkTi0qVEpLWnpDzgvAiD1irGXY9ro7D+eVb+RJuxCLW7RObdxlLmsOeW0HF2Bk4zsgHTVoS88s2w==
X-Microsoft-Antispam-PRVS: <SN6PR11MB2575BD4673334A2259945742E3E10@SN6PR11MB2575.namprd11.prod.outlook.com>
X-Exchange-Antispam-Report-Test: UriScan:;
X-MS-Exchange-SenderADCheck: 1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(3002001)(10201501046)(93006095)(93001095)(149066)(150057)(6041310)(20161123564045)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(201708071742011)(7699051)(76991055);SRVR:SN6PR11MB2575;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB2575;
X-Forefront-PRVS: 08220FA8D6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(979002)(6049001)(39860400002)(376002)(136003)(396003)(366004)(346002)(189003)(199004)(2616005)(66066001)(65956001)(72206003)(31686004)(76176011)(105586002)(316002)(2486003)(23676004)(52146003)(65806001)(16576012)(52116002)(106356001)(5660300001)(58126008)(47776003)(16526019)(26005)(77096007)(1006002)(6666004)(50466002)(186003)(386003)(65826007)(53546011)(68736007)(230700001)(8936002)(3846002)(107886003)(64126003)(6486002)(53936002)(8676002)(36756003)(229853002)(6116002)(86362001)(81166006)(81156014)(97736004)(117156002)(956004)(478600001)(7736002)(31696002)(3260700006)(476003)(4326008)(25786009)(305945005)(486006)(6246003)(446003)(2906002)(11346002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB2575;H:[192.168.43.50];FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtTTjZQUjExTUIyNTc1OzIzOlg5bldScCtuV0ZHVnZYbGY3TmJWQWpBNXN5?=
 =?utf-8?B?Q1ljaHdVb1lsSzA2WTFSaFJWamJ5ckVNYTk2SjEzR0hSUjBRYWkvRi9NR1pU?=
 =?utf-8?B?M1BkYmZ5ckVGK2NuZ0ZtaTdtUkxaNU0vMGtMUnB2cGsvRENOVnIrUkdTd1Az?=
 =?utf-8?B?VzY0T1hSalp1VWNmck8yMU5CRndGMm5TdVE4YUVBN3JOMUJyTkJpK2V3VlRJ?=
 =?utf-8?B?Z3owdEVnREVUWEcrci9weXNEZ05UUStGbUU1dkk0ZHkzTUVZdHpNRjFkdTV4?=
 =?utf-8?B?QS92Zmg2ZFNFUWkrVC96NFFTUWdKVWFUNHFETExwZTJDTEdHdHhkOEdtZW55?=
 =?utf-8?B?SWF6WklHdnBna3o5eWQrL3lNRkQrU3REc05DWEZzYlR3YTJ5TndlZlFiZVdz?=
 =?utf-8?B?blIyMGlueksyRzlETEQrUjJXMFltOEhXeGtmUWJ4WHNvNUtqN1VmbHpsTlFC?=
 =?utf-8?B?ekxiUmNndXZJV1MzSUdPNE5BR1hjRytCTmsvWEFmbmtJYlBmektLMUVLSEhz?=
 =?utf-8?B?QWU5YlJrYWJFaHBMNnFhY3BKcUliRVZISDVwYUw5bHQ1TGJrSDVYaEVmanlH?=
 =?utf-8?B?STNZNDZPSVNWUHZlL0hIcEprWWhEMk9ZQ1JteDJHRWZTSHMyL2NTVkJjWk11?=
 =?utf-8?B?NTFGalNGVFhleHE4MTBaRUl3UXlXR3g3OHpvZXgwK3NKUTVrbGdBL0lJVHZW?=
 =?utf-8?B?WmIxV2srZUNGYUZZcXU5c1dBU0lzclJRWCtsNzVZNmZha1NIUTZlTC93ejBn?=
 =?utf-8?B?U3hVUWt5Z2tORVBzNEhuL1ozQXN6TUIvUjZNQ3h3VEx2ZzVBYTg5N2g5RVRn?=
 =?utf-8?B?YjlUMzI4a3dQMUhjZ2FEMlNTc3Y4ay9lYmtGY0V3NEEvamIzRE84cTByUm9D?=
 =?utf-8?B?T2lDbVRRK1M5RGxYc2UySHR6TnpKSVF6SCtjRkJ1MGJqTU1yejhjRk9adVpK?=
 =?utf-8?B?RlRNK3d5QnFxVDlXMVU1UjJVVFo5MUEwVXljNmhZTkswYk94dG5xRm1GUCt2?=
 =?utf-8?B?RkNWYTk4U2JWR3p4UmNuK1k1cmhpeGVLZEJrVGtpVGJIUVp5VWNpTTNxajYv?=
 =?utf-8?B?WDFpVVdxWUhCVkp1aDMwZ0tIMW5iNHFwK0tPRHBaUDJrWk1mdWZkSE43Vnc2?=
 =?utf-8?B?Q2pTd2l0YnFoVDViR0RDMmJRbGlKUDFGRklYdmhXMUtwMng1a2d3TENWNHVt?=
 =?utf-8?B?UUNUc1JOT2luUThsTjlBL2ZTdUdXTlhtUEkzZXFDcEFlT0cvNmovVFk5SDNx?=
 =?utf-8?B?TytoTHlOeURaQUh2dHdkN1BNV1Q1VmsxZzd0VnR5QkRNbXc5UW9Cc0xYVGxJ?=
 =?utf-8?B?UUF2MW5vTy8wcy9EOUJ2V00zL0Y3b3Z4NzA5alFlTXVRaCtIR2wrYzViOSt2?=
 =?utf-8?B?T3MvQ0xIaDRjREM3cTlFSlhYbzVOd2dPeDU1alk2dktIUFlhclVsNTJKR3Br?=
 =?utf-8?B?VGhzZ0ZsblEvWnduUmVtTWROQmhQR3ppWlZNRy83RjFYamlJTzNncTRCRXdN?=
 =?utf-8?B?dStsVmF1VS9qdXZmazBQMWhKMFNucC9XSnErZGNXUEV6UkpPc3RiMVJURm1m?=
 =?utf-8?B?YVlzSkNMTlJSY3ZjVEpjRkZ4dEpmNW1ZSFV2anhUY1dyR244VVN5eEtZdENu?=
 =?utf-8?B?bGRBV3AxcWIyREJTdHdaNml2R1NFV2RXNDRtZ0IyYnVnYXBMVnF0ckJ5YVZ4?=
 =?utf-8?B?eFQ0MFl3ano0d0NGM1RObk9NbDJCd1FaMTFwdWU4a0JWRVp2c0VHbkVaVTkz?=
 =?utf-8?B?L1RWYnQzdnVwMXdLdGlvZEZFbTZZNDh4VDlISEZxdjFmQmRjSDRHUTZGcHNN?=
 =?utf-8?B?L3ZsbDg1dWJ6SnJBQ0RtYm02SkYwSTgxUCsvS0VaMXh4dk0weHJRcU5rOURl?=
 =?utf-8?B?ek5sWDVLUkpyNEU0akIyWVV0Vy82QkxPSm9NWVFCRzQraFUwT1pCbGFJZFl2?=
 =?utf-8?B?Q3dBcFRFVGlIbEtGcndUYmwxdmdXTWRTMDRFV0wrZ0E2SUZqSmdHazRueWNX?=
 =?utf-8?B?WkE1TWZtMnZITjJxaWl0TWFRcjhubngvcDgrT21YR2p6Wk9aWGh6SXE5anc0?=
 =?utf-8?B?LzlMb3dMbDZQN3pHSzRWOGxiYVBZZ3Azd1hlNmNjU0dLWTd1SURBMlpHeTN5?=
 =?utf-8?Q?ZyfX/ExRNcKVN+GCNAmK2UnD1eqTN67zXqn23goCQkQ5?=
X-Microsoft-Antispam-Message-Info: m3E1TgaBRo9DlWB17xZMhinGi9eF5ca8dhEr0d8UJPkHsgAa64hvDb1qekJEtbK1wnr7uJWtPDkHVTN3R+EHe/FyI9hkamsy4+A7rLv2Iqew1AaLNR4MhMJdfK/5S2nGHt4E06cSrRvxxPsUjhNY9l7CLlcKH1Vl5rqFUxvJD3q2Sj31355wKC2iaxXWZClyGbNflFlOTRapdMLUCG/219A/t6yRUs/BND+bmaUPeaoHsjkOCDeSL/nqbmqhFlNf88OtSJdo1KMNp4avRK1np4Ez8gmWJNhyiRyt34OL0MdHHO/YEKfLTHowg3gkJ2eHz5ZhNar1Glb9t+JslXqh77B+/uxIWd4vJRPza1T2lo4=
X-Microsoft-Exchange-Diagnostics: 1;SN6PR11MB2575;6:GbM3YIASnHjRVlvdueUN99CuWnscm2RtyJX2Y3ugE+DSF+JsTEkFSNCUAFRqx2CStmCKQUij+CD9lZ1Z4nwb+VQFt7mdSufAI2Lw7V0QoEc7LtBsUCdf5Ln9vMAYVwJLvOYP+MpHvzHfUkBIHt2isCfciEqeazeS85sdLFd+99ilvIY3Yixg2Of5/IuL88379uHYhZEjh2JViQiiRLg4WxREI3TEukKdlFF1BptKUclzfpwwTsyov5Sc7NDBC9SMD/JcTKOCX03vj0MELpfbpiL92Ci700IUQdU+1qmxQG73MhcJY+Gl4Jk4AiRdAcc70VbOCEGmS7djJpR6tVQw8Wjjxqw7B/p+59qsjZLV5Uw48D4CXtS/6PoaRgvqIE8pEWDyuO1o5+P3fnP5t4v6jXuS9pxwPJ44P01IIQrIDFKduXbQRIqTlSRfBwCtSFhYL4B4lL7ikMiHn+jq6p3Fww==;5:895FOviI9Uco1Ardjp5BS4tzp8HgeBaZKK9GgMcFAtd9Wm+lnlIarlLABRv79vX/KCssgbNsnqUxJ+xenfza4ok3GEJaU5Mh1Gh+i3ixkcCNV0M8iWS44zsunq9GXcWYdsLAKIZ0cqYdtFpXiSMFOZhUq+51VVKy2RwP+BoyN38=;7:oC7amyto0Zy+ChLLtRiYOeHD04CefmI/HbMr+98j1xCm3LyWVjgaW+czqi32PqSDnLNQhmmcFpNvXmF6AMjslPpxWFyQCSboCvBdIz+CTwJObJoRh2vyKgSZ3zEWg6SUucONFA4QnSL1FbhG2ENu9hpuOOy3qBjX8ZtDIvUBkQrstv7WZBIhhAOJbdAoqrsLgiWWlohQECkRan3pfFTPnmXSw6il8Y80RO6G/WvOjYDyYU5PPe1OKUFQ5Ypn20aa
SpamDiagnosticOutput: 1:99
SpamDiagnosticMetadata: NSPM
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2018 06:57:22.3230 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74023f56-4c41-4452-70e8-08d62f46cd51
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2575
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On 10/8/2018 8:01 PM, Johannes Berg wrote:
>> +	*currbyte = (u32)0 & DRV_HANDLER_MASK;
> You do this a few times, not sure what it's supposed to achieve?
>
Agree, the bitwise operation is useless here and this logic should be
modified.
>
> So far I guess I'd say:
>  * use more kernel infra, in particular {get,put}_unaligned_le{16,32}
>  * name your device/driver-specific constants better, rather than things
>    like "SET_CFG" which leave everyone wondering if it's specific to
>    this driver or something from elsewhere
>
Thanks for your inputs.
I will use your suggestion while submitting the refactor code.

Regards,
Ajay

