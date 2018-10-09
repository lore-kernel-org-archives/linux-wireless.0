Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0778C64EAD
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 11:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84C71214C5
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 11:44:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="qPZHMMx+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 84C71214C5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbeJITBY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 15:01:24 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:29150 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbeJITBY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 15:01:24 -0400
X-IronPort-AV: E=Sophos;i="5.54,360,1534834800"; 
   d="scan'208";a="20945387"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Oct 2018 04:44:48 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 9 Oct 2018 04:44:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9q+q1IrrIjh3WXKGgl5MuGh9/KJtf3P07VNr80AaXE=;
 b=qPZHMMx+b+dE1NhjIUaz0L2YZk5pe3loGwP6Fa/CDnBePqePv5uaP0sobvEySxLaYOyP6D/mtUxuEJejjz0NolCYwWLsfe5j0rX7WE9lSu2aJmeKIpvho7IOlSnccY1WGaGW6auVgftzQH1sXT+jyeUq1vwBGPPxxQpmFoTGyJ0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
Received: from [192.168.43.50] (27.59.68.54) by
 DM6PR11MB2570.namprd11.prod.outlook.com (2603:10b6:5:c6::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.28; Tue, 9 Oct 2018 11:44:43 +0000
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
 <f4ab9830-7892-a062-48c4-5c5c64b5caa0@microchip.com>
 <1539081379.3687.112.camel@sipsolutions.net>
From:   Ajay Singh <ajay.kathat@microchip.com>
Message-ID: <1d77cb4d-92c9-0ea4-bdd3-f16a2421406f@microchip.com>
Date:   Tue, 9 Oct 2018 17:14:23 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1539081379.3687.112.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [27.59.68.54]
X-ClientProxiedBy: PN1PR01CA0075.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:1::15) To DM6PR11MB2570.namprd11.prod.outlook.com
 (2603:10b6:5:c6::12)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 686398bb-0e22-4e67-992e-08d62ddc9cf1
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM6PR11MB2570;
X-Microsoft-Exchange-Diagnostics: 1;DM6PR11MB2570;3:lcRg+lVeSiy8I8byqdD8KppucEkj9VmD07eJUr11CH5vXLuQfxJScBIG0TQzMe69bnqmdoUrdeDVHoXZbMtuIPGj38ZhJsnpDlJtgVL9GcyuVB9b367u8FyAWkfhepUidMHIGl1qO3+DKvgJc45RWX0QoqCH/8TCDVcizQYrUrWIkgDlgwqOng0GJ93wxlsOHRRyyZ1idvkmMlqGvJ/l6jh7tV06KP+eCZFolIlt7CKyXyE8c2/NShAK4Vz2wpi5;25:65gBTIblVMHyxKuNKjG5BJBamwSrIDQAnLv4SPE3Kw1BQzZ+7w1IUBTY74eF5AR//IiRVyoywgqv5tyja3HKJ0CSOSxjO1cD7y9sa/XkTg4nthwPVPijST2z01ExCEicFUBA5jNo98XM5ax1erlbMH3yz4XVUq62ZjG1h/XR3/KIsK3I6uHWoTm5UuuNGs5pZ9Vd/Tlw9ClGOjPBgCpFQoe0PywoVBUBt65oLlI/HNVXfGopnAQQR9oFxEf++J5X1FNe/oqn7tkqdj9uHKgMUDrumH9xHlZzoIknC1c/sozuq4pCReqOyfBbvCzvXNKxbEIFcES3hm02g2eZW4dTtQ==;31:iawSx1RhoMteAz2AUQFfHq4r2YntdJDK8RsoE5am3VeKGss7qMHWl6oDPkfr3JbsZV0172/We/AOHvRXJKSlkHvzcXcYUvmNG5pkWFdCiL1oZ7PBlay1uKofL8y45TAF1UQQ++KnvQ5voUfCVj0pHZSf12FmgawJtDtiUrz8Mtjs9RGiPom0eigR4hsbKMT3UZaZS/S8C7Nbj8peYDfd9j2z/uO2mgmZ0/VSQXznb6Y=
X-MS-TrafficTypeDiagnostic: DM6PR11MB2570:
X-Microsoft-Exchange-Diagnostics: 1;DM6PR11MB2570;20:5Q/t3JN+d3q8ryjKkaD1EMau3DxeDQO/mx1EkCSkGQ3bVaXNQ9/yBuk3PptmtMiI6e2Jxp1a9v7LRzpc/Us4colHfMIOOSYITsfL0PM7kk43A3KjuFhosGhQff5yFFT/dPy1FmCidOlqC3v8O1VuoJ1pQsjsy11t7supzz/S9wUE0akohkjkO9DyAyLXW0AGevs8ZnYh5sMiPESdOAhcwQjcE3DG1dtHzKlMvA3JlfH0VtD7zl5C7Ay4qeW5DFd/kSdNODB4lzpDNRNuOgwbbheNdOnh9jk7Jk5RbT7uSh1QcNQa4kKHi2GKvqrRxmO+xnGaLcFJFih9kzaI4Bih5ncUHrytGbjMuvyjBjaoLdW/tz3t1flaMJ4MpjeugUGKAfBkJimXg+XY/OHrSSHRXYOIYZS++pADUJWcj+der1A=;4:3UO8SGTIgDagCI6kqc3KF+Kc+sFjWZk36EfRft3MgmT7V9pYVbOrIu6qRgI9GVqMH+vJuJKSPWrpVVkXNcNvMAs7SIIVokWAj9tsYs3yEcEPtq7++eCxiI/G7+iEn6kWdjEvFR2wz01F3zxYDX6t4O6UXG9klfjHv3khM6PBBDxdVexgow9rgrVKtzJ4DfIMN/z/r59q8TpoCsvs5DstOECkeh110WZnH55J6XKsGNnjBh5auCpiOF1BRFkAOr+hRR8i1P2BJvSDkHsuO4GWa3ptpu4Uil7/GbbbJ7Z0cJRA7rfqRgtMvac6vGzFEpaG+6x7DpHHLvhSJX0QikIGfUNgnvV0PqmdAzBnZyRvl/I=
X-Microsoft-Antispam-PRVS: <DM6PR11MB25707358584F8AAB25F783F6E3E70@DM6PR11MB2570.namprd11.prod.outlook.com>
X-Exchange-Antispam-Report-Test: UriScan:(163750095850)(17755550239193);
X-MS-Exchange-SenderADCheck: 1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3002001)(3231355)(944501410)(52105095)(93006095)(93001095)(10201501046)(149066)(150057)(6041310)(20161123560045)(20161123558120)(20161123562045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991055);SRVR:DM6PR11MB2570;BCL:0;PCL:0;RULEID:;SRVR:DM6PR11MB2570;
X-Forefront-PRVS: 08200063E9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(39860400002)(346002)(136003)(376002)(396003)(366004)(199004)(189003)(58126008)(64126003)(229853002)(23676004)(53936002)(106356001)(53546011)(230700001)(97736004)(3846002)(65826007)(478600001)(81166006)(81156014)(6666003)(50466002)(2486003)(52116002)(6116002)(105586002)(68736007)(5660300001)(186003)(386003)(8676002)(16526019)(26005)(76176011)(6246003)(8936002)(77096007)(6486002)(52146003)(31686004)(25786009)(117156002)(36756003)(486006)(72206003)(107886003)(3260700006)(4326008)(14444005)(5009440100003)(2906002)(47776003)(305945005)(2616005)(956004)(11346002)(31696002)(446003)(316002)(7736002)(476003)(86362001)(93886005)(65956001)(16576012)(66066001)(65806001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB2570;H:[192.168.43.50];FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtETTZQUjExTUIyNTcwOzIzOllVUW1xWk9uSGcrOHdsNGRJLzRuRTFpN1gz?=
 =?utf-8?B?UHU0ZXMwUWdzTkNpVWUxZ3B5eXZWb0oxMEd4aGM0cFg1MjVieVV4MnRXNjBK?=
 =?utf-8?B?NExMN08zTmZvNTcyZnhldDFTWDJ6YzB1NmR4SWM1TkVVdjBaVm1YeUhtY2tS?=
 =?utf-8?B?MDEybEIzZEdORlFHNDQ2anUvWURUZEo2TnBvYlZueEhIa1lOc2I2RnNPMEtJ?=
 =?utf-8?B?TUFEYkNQUGhvVEt3NWJNN09rajVlZ3MzVXZsRWlRa3p0VnpCMlJlTUMzVXlo?=
 =?utf-8?B?NDlZSE5waTJ4c1kyVHJnYWk0YUc3TW5KRFpQdkwvczc3YU1nbGU1bURsTWhh?=
 =?utf-8?B?K3M5V3FLd016Nk9mR2lpdVpZUkoydjVkc01OM1JqWEQybnRMQjBLU2FEL0Nl?=
 =?utf-8?B?ZW4xUlNXbU9kczBIcXZRdXdjMWg1WkE5Vm03SzIvZmp0THNYME1RZ2VXaGcy?=
 =?utf-8?B?bDdrWi9aWkdRNXFOOHlhS2M4K0M1WjVFVkFnZW52NXUrMXBLSHNSYWhOcXd5?=
 =?utf-8?B?K1lRSUk4LzBtVlJ2alZDT0Q5V3Naa3l6WFIrd0pFNm9uT0JuTHJSTElVcGhG?=
 =?utf-8?B?b2pyb0xSV1lHanZJV2VGa1N6YlFuUTlnemVVcVo0dWlVOE5MQURQTHFwaHd6?=
 =?utf-8?B?YmNXOU1LbmhLWXFRRGpxZW9GRUxqYWhBeDRUNXV1clVpLzFYUUM1RFk3SEk0?=
 =?utf-8?B?VXo1U2VsNzdNQnlhcXJ5TUNHLzdXNEd4VWNvYjJJRnZKcW1qeFBsZjBLbUtk?=
 =?utf-8?B?cHFSSnk3elhCeXNVTEZXbGNaVmNvWGJ0alNGdkZGdm81QVdNU2E0cks1Zklj?=
 =?utf-8?B?UlhkdGNiV1JNcUhpZERoOVVTTXQzdU5LMUJxYTZySGhneGRlOFlhYzMvYmZp?=
 =?utf-8?B?cm15Y3hjTTdDVThoM1R6bFhGWDQzTEViYUMyQ1dqUkd6cUU5NVZZTUVPZ1Ri?=
 =?utf-8?B?SVdIZ2t0c0FvTFMyNmpDL2J4SW9ZK3FibFpYbGttZTZxNXo2MUZ4NGZZakJw?=
 =?utf-8?B?amhENlhNT2o3TnI4ZFZkSmFmTDhXajl6S2wwbUZ5K0V1YjdoR2o5MzhJNUxy?=
 =?utf-8?B?cWpabThjeVA3RkVzdUJ4NjZ2NjVZM29vTHlDbG9vUitjbG5KSDRYWDRGV0o1?=
 =?utf-8?B?c1ZZQTVpbDBOSE83VGoxdGFwRlR1Nm9HV1d6UXVpUGd3Ym9pNVZ6TnpWMTZP?=
 =?utf-8?B?YkY4K1Q4S1pOaDBDQXBERk54dUlsaWlROWo1bTQrbEtybllvakVGeExxc2ZK?=
 =?utf-8?B?ZkFQcHNPMWpGazltRkY4WnhDWkVRbk5DZ0I2eDhmeDVHNUU0Z1VFQ1RDM1Ir?=
 =?utf-8?B?SGJSbWtHbWhUK244NHI4Y1B1RlkvTzY0dTF0R3cxOWFCWDNXQzZwK1VEb2J0?=
 =?utf-8?B?YUlxR3JOTk9oc1hobHUzWE9GZUdsMFk0aDQ2ZmFmMjA1V1htQXE1ZHlUWjlQ?=
 =?utf-8?B?a0NmNkh4bWE1Y29QZ0krUmp3ckZ0MXFZVmpnRlRGM24wV3NUUXpReEdNL0R1?=
 =?utf-8?B?Ym5ITWpNTU1LVUVmL0VnczdPQi8xNk85eEtXSzVIYUtHTHpaUE9JZ0tpb2Vx?=
 =?utf-8?B?am1ybHJldEhNZ0puSkwyZDRieHZIUTdhY3M5MnZLS204clBXT2JvclBkMG5m?=
 =?utf-8?B?K1I0VU1SaE9FWTgyME9lWUVCREVIVzF6YW5sbXdSWjVKdmdGelFUMXVQaWlo?=
 =?utf-8?B?ekF6eVVMM2Fwc2o2alY1RC9kb0p1aklUTUhhR2syRjU1V2lCYnVHcUpydVBi?=
 =?utf-8?B?LzAzUWhGOGdyNCtJQ2JDb3pGa2VYYmlyTVp2Z2FsdnN3TDJsMFZmWExZSkdV?=
 =?utf-8?B?RSt3b3JRR3dHOHhGQVhZWXJKeWlJeVg5dWFpaXZxbXR3OVgwWEtJRlA2VnUz?=
 =?utf-8?B?cFAyTWszWEJ0K0pvbE1TTEdjMGh4VWxLNWlydFZhOW1lQk1hMWNTNkVOSVh3?=
 =?utf-8?B?RnVZc2NYMUdrcURHNFhVRkFyUHI3M1V0VWtuc0NEOFpTeEU5NWlsY0lTTlZ5?=
 =?utf-8?B?VHdkVFFKdDNMdkFxVnlPbm5MVTBWRUdPbS9neE9TM1RzSUx2Mm9oQlNVb0tG?=
 =?utf-8?B?NEFMY2pialQzZ1R0dkdRY1N1ajE2RjFBU21KbVRveEpKVmpUbldWYlJLdEJQ?=
 =?utf-8?B?Y0E9PQ==?=
X-Microsoft-Antispam-Message-Info: skzhwrrp+qj5S5/I65ZhiHsz2NgSLniuQRNLxeH5rn4/nLkRLxxu++OIaaxykh1EnHvk8kGOzCO//ZH6mg3NIwaYc46+lxbq2rxkPap+xALKlxBY0FTROCkM71CypNKP3UcAUL6fCHz+K7oLRq3VBKzh1pUE4Pc2zJEc+Mz64u8IoaSTDQbTUy/MxGdyB9U/y8YP97UjIIq01B5nm8alN0EcL9MTH12c/5195+f/5kIXsoYh29J+3mSkGiYZIxubB4DehyC88pgUUM4iLokBcJTZFRoJnxZ3cj+Zv6qtCTbta2qda4/hbL8bt4hotRzA72KbH50Ih0T6cEzuF6JvTkOGMWwuxV5VeYQBUYY1dTo=
X-Microsoft-Exchange-Diagnostics: 1;DM6PR11MB2570;6:d1ZmKfDWs+uiQiwQUrw8x55/rstN9cRHagNfVHPFOO8mSy/EBhg7ldIzggRVtOBOOK7eB1YgFbpOR4jc0a+G1nymAs5v/HmtQDpOITbX9j8KRGjsTVBeqbzu9+g8kulwHDm3Dl6OgLLQy0k8MnSMbeli6KP29bgsMjhgnEY5E2S4tj1TXdUENN+RdSEJLurnB1J9VlEzxNeUTIlmF17moLbM21Re0Arn+iZS6UCZqNnovCeir4JlCkQE9Vy2GX/2x+yqTxRK7/aSui3LBJPJGmZLyB53xm9sYXtOCw4j7LudCy4SSEXkdmgcA8QC7IBWzkoW+SXYxp7tFezen/HPjKdmwJW3slz9TlMLgktv2MuqrSPxo9xDl0EqJmiycv5ZhF2maUtC2GIB5k/JyXBy2D/abwCmDxM88CSmI15rf1vaUFk75/CvZ4G25LL3kLi2tFM9BKu9pldVCYwFec0L9w==;5:BQFRO6oDVmt64vcQhgAAYM2eQcAWYFrdrvLcX1lUoFGB4uZCLJoaR+CuLJL6EmkJaxAhImiZrnm7pbHxAGDdQffe7Z0CmQUpE2Lc0p0iW/6XmmXmuKM0uayiBf8nwiDBkdLpCRSN01uwkTElkZXhirPS3+5iN0ScevNEABXolfw=;7:VLJAkxpAXX1Y2DYhkGI7SByrY37ym6ev7E8VJQZwxI7cTs2HSwlR98XKcjo6dUC/61tu4gSQR9X44AK/7r/4hCn4NNzptkKoToDLnSGYG/pTNBFpNxws+ceCExFpvCn6v1cCPEDy8WIIgkNNDZba7DjbrZncMm4zA5oRTPzzTn3E+VZKrOqXvGscWHoioTNdeQ9FEXF7tuw7jKSvFiSUjXWl5SzEvYVldK5bLHNdbk0DoageKeGsNUi+fVdOIPJo
SpamDiagnosticOutput: 1:99
SpamDiagnosticMetadata: NSPM
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2018 11:44:43.1762 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 686398bb-0e22-4e67-992e-08d62ddc9cf1
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2570
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 10/9/2018 4:06 PM, Johannes Berg wrote:
> On Tue, 2018-10-09 at 16:04 +0530, Ajay Singh wrote:
>
>>>> +typedef void (*wilc_remain_on_chan_expired)(void *, u32);
>>>> +typedef void (*wilc_remain_on_chan_ready)(void *);
>> I think as per coding style the typedef for function pointer are allowed.
> True, I guess, but why do you need them?

Actually these function pointer are used in multiple places i.e inside
the struct and also for passing as the argument for the function. So i
think its better to keep them as typedef to simplify and avoid any 'line
over 80 chars' checkpatch issue. But anyway if you suggest we can modify
to remove these typedefs .

>>>> +struct rcvd_net_info {
>>>> +	u8 *buffer;
>>>> +	u32 len;
>>>> +};
>>>> +
>>>> +struct hidden_net_info {
>>>> +	u8  *ssid;
>>>> +	u8 ssid_len;
>>>> +};
>>>> +
>>>> +struct hidden_network {
>>>> +	struct hidden_net_info *net_info;
>>>> +	u8 n_ssids;
>>>> +};
>>> This seems really odd - what part doesn't cfg80211 already handle?
>> If I understood your question correctly,  you meant what extra
>> functionality 'hidden_network' struct is providing.
> Pretty much. It seems like you're trying to handle hidden SSIDs in some
> way, but ... that's odd.
>
>> Actually this structure is just used to keeps list of SSID's requested
>> in cfg80211 'scan' callback which is passed to firmware. The values are
>> extracted from 'cfg80211_scan_request[struct cfg80211_ssid *ssids 
>> -----  int n_ssids] received during scan.
> So then this has nothing to do with hidden SSID?

Yes, its not related to hidden SSID. Suppose cfg80211 scan is called
with SSID information(active scan) then SSID info will be maintained in
this structure.

Regards,
Ajay

