Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A64AC32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 07:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B941A20841
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 07:13:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="w08yYLE6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B941A20841
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbeJKOi4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 10:38:56 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:64359 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbeJKOi4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 10:38:56 -0400
X-IronPort-AV: E=Sophos;i="5.54,367,1534834800"; 
   d="scan'208";a="21506385"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 11 Oct 2018 00:12:59 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 11 Oct 2018 00:12:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EM5aiwFKVVUItHdcYNW67C9I2T67l8T2iRSmEA3ZRm4=;
 b=w08yYLE6DrNhjLXIMjvrarm/HrPYl4rMOaMW+qgzD35+YKOGimUi6lW79IAgGYbJ5GR8A2gcanqEg+uJIisE5rS3skOKKUDc6zqTzXRgDRaGyAscHmDA7qaGfB+GLgZ9qgwnjG/ux8xSOZrW05Bq3aNTteWQCq7ieUBq8b8YrCo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
Received: from [192.168.43.50] (27.59.68.54) by
 DM6PR11MB2569.namprd11.prod.outlook.com (2603:10b6:5:c6::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.28; Thu, 11 Oct 2018 07:12:51 +0000
Subject: Re: [PATCH 14/19] wilc: add linux_mon.c
To:     Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
 <1537957525-11467-15-git-send-email-ajay.kathat@microchip.com>
 <1539009873.3687.79.camel@sipsolutions.net>
From:   Ajay Singh <ajay.kathat@microchip.com>
Message-ID: <69cff0d4-735a-853d-5dd5-b3673c806a85@microchip.com>
Date:   Thu, 11 Oct 2018 12:42:28 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1539009873.3687.79.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [27.59.68.54]
X-ClientProxiedBy: MA1PR0101CA0037.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::23) To DM6PR11MB2569.namprd11.prod.outlook.com
 (2603:10b6:5:c6::11)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0008b15-7fdc-4e88-cdfe-08d62f48f82b
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DM6PR11MB2569;
X-Microsoft-Exchange-Diagnostics: 1;DM6PR11MB2569;3:WGmHrybeL9SY1L8QO4RthpXA4L6a8u5esim45TCzugQTVocMRv+3r0RCB1kJIoWOp5nRHSqqOHj8r79inDVyJStBPnXaHxmm2L47IP+G7GNqcczq1XHFZggTVI1tGh7eSFik6NpFjYiKChGURZNlnNDkSFzmZOdoIoedT1G6dKMY5klTi0N4scKMq+FSiwk95gY3pAnKeA+TM9qUZXxtp2KTzov+CIJh8eMMM/LrsMGYYJpKgvhZpSRTAcEOPvQz;25:STm4idc9l1bC+vnQlhCbA3NqTONXVE/FO4qHfDwRZ/s+uWjxCMkg22cFxaGc7CXkq2a1P5oOAa/9HtwyNHvEKtnAL1OkJ21NeQH45X5aq4Bl4aJyts6Aqqf3VFXLUiCCxNwjThK00tKZl+n44nTvE1pqJpLUs93UQaMDHVErwy3aBQKJHTk7b+J9WaHMMBe2oabLcNdcc6S0aMOai2z6XonFH/kYXL5JE9tnxHwEnEQqYOnEKdgXzUzydfjxhxqr9bcsQYg93+lDUhcxqjI2iKVLzDP0yKqXNBWvvZAm231s2vB9WCCUAbyQ+WaeXK9fDewH5RgJNkDEP0KoiyM9hw==;31:fOh5Ftg7hjfxbjV35vevIEQBQ3XAQ9yG1UWz8aJLLRBqLKV/gTtqUESjJ0VS/wo+AXzolwGmyU6yZH9Ew4dMyrwgg3j0KoSp3Mi0v7hHpgkozVKyrroVSRBesxf0GfsTPzO4P4nhbPEg5F1YceXShOoOdqIhEh++F1CIduYDYa7/ShHWrc9F4MFCDPuctFR1VH4KOJ3AuKufs5v9h+1yiUaEVriwBihhJCyxxmMVPq4=
X-MS-TrafficTypeDiagnostic: DM6PR11MB2569:
X-Microsoft-Exchange-Diagnostics: 1;DM6PR11MB2569;20:i9ZdHXfyVGPUHp8rMCbGzvCs2EX2TZ40du85FUE/ARJ1/mGbZFwPAxB3ugJZdSYttSEgSKrjeQSvLQ+slwbr7em4fbAQ2VcUJgS6BIvGUVar1s75jT2FEnRkfp4jUuymmPLOnQiEn11s2g15c7LYwmSFcGND6f8QSNz2uax+JhBdUkOnHNdcOJ6Z4EofhYm+ciwyCDY9b3Umgj6lwSkP0nuB6rEWxrssL3WHO0fiROq/m+xwco3clK/uEhJ/98OLaBONNU8rqK28O5uarQXaWGipgrQKkC1F9Rc3B+towYLoD7FAB9OpugiStKiKIgdqVOB+dxFjX8g6AhDg2cG1OYnGnu29uz5P1Y/A+6MvhhD7PkOO7rJ0kLcMtFEbsJ9LTKbj+9waoaoW2kv7EQozF52Uw4lNnO261jlTntZ1CAo=;4:KUiwY15ngYdN98wHZT/SqHUM1wgTA5FaLYMR0mPLLEenc/umXouFKEVtX69fxxshoWGhIHA+i++t5IulLPL33xzTkpIKoYdMtOYeAlzfezcL9k8Vf3VOPyZgXsKA90MeRH+cVXfQRJG0lTd6Cp/nlAp9Fd+xeNj1aTk5qwXcBx/Ge2+spT+cwtXYfY4FEi9BeaBpK0AMfbiQi3qj4kniZtVTzRnRdSpYGKPE3IrIbUZ2/LZdz8CQyFkpOjEUqJODgfzZALNIQcZ1zoUADSiUNg==
X-Microsoft-Antispam-PRVS: <DM6PR11MB2569D0C28B5FFA1543394746E3E10@DM6PR11MB2569.namprd11.prod.outlook.com>
X-Exchange-Antispam-Report-Test: UriScan:;
X-MS-Exchange-SenderADCheck: 1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(10201501046)(93006095)(93001095)(3002001)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(20161123558120)(20161123562045)(20161123560045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051);SRVR:DM6PR11MB2569;BCL:0;PCL:0;RULEID:;SRVR:DM6PR11MB2569;
X-Forefront-PRVS: 08220FA8D6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(396003)(366004)(346002)(136003)(39860400002)(376002)(199004)(189003)(72206003)(64126003)(5660300001)(16576012)(316002)(2906002)(65826007)(8676002)(478600001)(58126008)(14444005)(1006002)(8936002)(86362001)(31696002)(230700001)(81156014)(81166006)(3846002)(6116002)(486006)(50466002)(65806001)(36756003)(68736007)(229853002)(76176011)(2486003)(52146003)(23676004)(52116002)(11346002)(2616005)(97736004)(6486002)(956004)(476003)(65956001)(66066001)(3260700006)(305945005)(25786009)(47776003)(446003)(7736002)(117156002)(4326008)(186003)(77096007)(26005)(107886003)(53546011)(386003)(16526019)(53936002)(31686004)(105586002)(6246003)(6666004)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB2569;H:[192.168.43.50];FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtETTZQUjExTUIyNTY5OzIzOkZ6MzJ0MkVTbWpNV25EY2VqK3JtZkFWZHIz?=
 =?utf-8?B?eUo3UjFmLy9Ua1hFbzlnb0JGZjlSV1NBa2RZUWd5TmxGU1hIb0lxSDN0M0I1?=
 =?utf-8?B?SUZiZjBFSUdFTjFHTXZQUy82bTBxay9YRklNNVZISklYS1dXMk9lajVIcXFR?=
 =?utf-8?B?aVRVUklrYk02SGVIZXJVbXpXVldLaXRCZDNhOTd0bG9TZGppYU1NMWxzVVJ3?=
 =?utf-8?B?alUvMkx3S2tjdmF4TEJKOWttOTBGdk12TWsxMFo5QmZyR1IzNXBPSU5heFdt?=
 =?utf-8?B?d3RhK2gvQXZBTW0wY242bnZhKytVTHd6VDJYSTJsTTE2dmJTYkN1MnY2ZDFw?=
 =?utf-8?B?WEpUYzltMGxEWkJuVUtxTGtZY09nb3JUVVExTHptb1dRRlg3Y1RyL0lnMy9s?=
 =?utf-8?B?a2haTHpIT3FXU1ExS0VxSFcvazZJSTdZdTFXYkZocUU3bmdIbGUvWmthUzNT?=
 =?utf-8?B?MUtEcXRVcHpvNzBHRFROY0ZoaDVQaks3Yzlxa292dS9VSHRIOFVRTXdEZS8r?=
 =?utf-8?B?VEIwYnZ3a1dHZS9BbEhrcEdGS3RqS3hTUDZBNnE5ZTFoUjFjL25td1BpSTVp?=
 =?utf-8?B?Sm84UXZ4WnkrNUR2aFB1VFAwZ0xSNkxIcnJVb09FWU4yVHA1TmhtTm1GaVV1?=
 =?utf-8?B?NHV1N3dMSlZRYTd5NHBrVTE3Ymd6NVFtR2t5VXpUdGR5V05pcFpRVGMxZkxa?=
 =?utf-8?B?MU0xM2V1SENHQmdlNnVwVnZJeUdnd1IxN05ZRFNnN0x1Q2NSRU04L1BOSkJh?=
 =?utf-8?B?eVR0cWt2ajlDNHpBc09jK2ZIV2p6MzVmemRFcmVkUnRvdDRUQi9KNlJ3SzBD?=
 =?utf-8?B?aXdIOVU0emJjS0ZIdktXQksyaUZCYVdqWTBzQUtZQWsvM2VncS9SQ0lwcEtP?=
 =?utf-8?B?a2JTajcxQmhZN3NscTVVSnRhRzFpQ0psWUQ1WGpoNXVOZlZLS3RVSmJqZllW?=
 =?utf-8?B?WGJiU3JkdTZXWGZaNFdKNUV5RDlidVpvZmUwUk9QOEl6RXd6VjVDYUVpSlI3?=
 =?utf-8?B?Z1JmSlNzOFcwTXYyTmR6SUMzOXVmczlMbnZoVEh0NlRpbXBtMVQxVEQyTTJD?=
 =?utf-8?B?ek5BMElBRHd0RFlWdDM5eG9jNXJqSkx4ZzhtMkFreGl1c2dUL0gyNHN6ekQw?=
 =?utf-8?B?bkRPdDlBVzczZVJxTUhVaHZGdW5mM2xaNm9BQTlaY1BrWkhGa1YrWXRJVnhM?=
 =?utf-8?B?NnlDL1BsUkNzeFYyNy9sK2NuZlF0QnY4aWROY3U3T3diZzYyTG1hbVByYi9k?=
 =?utf-8?B?dEJzendJSVpJeSttdG1rK2s1WHIxc0RrRlBmVFdVYW9pSmtVUU5QVHM2WWpE?=
 =?utf-8?B?SVppMnpBaEMxWkNSSlhUcm9CSzRIRnE2Y241V3k3eXpxWmRwbTM1TE1XNXlk?=
 =?utf-8?B?d3F0bkFTZWhuNGpKZnpwOXFGNjlmdTBxczlQeXNaZnM3YklTRll1enh4YXY5?=
 =?utf-8?B?ZG9ucE1mWS9SRldCeFVNMFNJZVhTcEdLemJQaVpYZk13dUE4cW5pam9FOTEw?=
 =?utf-8?B?ZStsdTlQNFMrb05BclhYQXJHeE5PNVR4K3hDbXNXS3RkelNQREQ5cW1JeE53?=
 =?utf-8?B?dCszMTl6REtBL1RUcnhZTi9kSTdUZmV2Q3Y5eHdMMnBBalIrdWhmTWthNFJX?=
 =?utf-8?B?cm81cm9wbU1GL2hZcFg0dGJRYUs4KzJSVmZqbVVCaUoyS0lwcmpuV1NVbm9D?=
 =?utf-8?B?VVhrenZoQ2VUb0lmZzEyVXpVMGkzZXpIKysrazdBYWlrUHBNWFUrVElZQ0l3?=
 =?utf-8?B?ZG03K1V6Ym1XdFpkVEVwOVExd24rTXFGL0lrUXlpWjVTSFhCQzRjYUFPWXBZ?=
 =?utf-8?B?NE51aW5UUXlVekFSeW9LbU1ZTzBJU2pSZ2tmVit0cU9OQzZ3ZU1YSHpoYWpq?=
 =?utf-8?B?alBLbEc1bU5SOGsvOFY5QVBEUHdRZ0dMS1lHMkJyMDJrdldudU83YmswL3VP?=
 =?utf-8?B?YWh5Qm5kcUI4M2hiZUM5cjBIYUxoSjgvRmFnUlEzSktVQnZXbWJDUzVWWW44?=
 =?utf-8?B?enFMa1ErY2pncnE0bjlZZjQ4Wm1sV201VVF0N2o2Q1V3SWJzY1RpV3RLQy9P?=
 =?utf-8?Q?Xy88=3D?=
X-Microsoft-Antispam-Message-Info: UNRnZcHh2Ula0M00Pj3cJZ/83VdRsjPcI/O2DW3wPYzcd8ysi9Aqx2pRp6AHqsVivJSsIXScpbGjvweR/GZ8IwWJLZbCEObdH6YOSOWu9AQA1y5TCSlJ7lVC+jDbEki+Hq07btKzjQPkEc9s+RHoRHBNiG5E8OjW9ITbBDeOM5ITbXc6TuZolo40TU4mU3dTpHTE5NWVfUNH1yEzA79s4bMNLL/Hmq05yceRMEIzoX6i3m8vvzw77h6qOaVXVrD8uib9K/g2hLHMXtHKRv5IIS9C0lkToH07oJBbifpbQdw0shECrh3qxWPjVPobu3K7mUfxtQu7GokThjYlOOk+8khBZH0m2coZkY8UgeF4els=
X-Microsoft-Exchange-Diagnostics: 1;DM6PR11MB2569;6:w8guazFAd9AnR8ZGWNmaGE2Eiwvaz4X8rtES1UYMgt7logjvyflnR6J/4xnfRm16sbr8FJzePF/4L+Yd7LGXmimHS0iZTcIk7ZEPykLhoYv3cMbTVHy2N9GuAMoplQPuUU0zj26IVIAe3zPrRwdWXcnPTJJjj9vhBvdtsR5bgeW1RgRhxOjnXhY3VFoyxM4Vh8UTvKQjAbDkbjbsLu8QveUwg1ZlZHLQjia0fON4iIM809I3QRg/SGs7z0go7QGALDd7/mqFku0a4FMRwGr28IXB5PuiP9Nw2RAAUpR0ms1MdoHj5XoB0GJw7XGRbDqk/znT4kVdUuBDCmU8BUhSnTyxcCrgcgt0qKsEjpzizjDVN1XT55gZ60sG0Bzn7rWRtnwV7jDaGAgzjNMKxCzOo5z2bNTWPeNUDgHKrIObyl7lgV4EjxnlBgeBZrvnFO/bMARKHUJAw3NpUt3itpwnJg==;5:upJXx04Wi7HH1dSPCdpDbwZsOOuQ3xejFFxNmN0H18bsrT3IsfMvjYKzlGNH89n11sTAvTsTL10aaS04gKS1+Ekpk/NtkZ1vU/yeg2wpcpStybkFzF9avfTrjubBSUlZdMfRvhPKV+fJFcveBYaMEn/gtEzw4P/+/btiNaOx21I=;7:Jus+Gs527FkDtT0vPQJEbHSxx2sV+9ITqRxm7f1vqEGmwJiYGZdHmJ/MsjKfnVmXDXBLaHSxE5LVNFoa3wsF4qWsqgPJ1Z8m7ME685UOFD+L5eHfXNvCtq3sWnGd7OA6m8jOGWm7dJp7n1ePlqLcvY/wqpBxklNg8F8grKEmU3ifsHWYga68A3Qf0pyfWkPw0UQycFv0x9PU0tCPU2zxuf7Vi/MhooRGNRQm42DkHu/uwphU0yqYz13vRTgEfmyK
SpamDiagnosticOutput: 1:99
SpamDiagnosticMetadata: NSPM
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2018 07:12:51.5087 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0008b15-7fdc-4e88-cdfe-08d62f48f82b
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2569
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 10/8/2018 8:14 PM, Johannes Berg wrote:
> On Wed, 2018-09-26 at 15:55 +0530, Ajay Singh wrote:
>> +static struct net_device *wilc_wfi_mon; /* global monitor netdev */
> There might not exist platforms with multiple devices (yet), but it's
> really bad practice to do this anyway.
>
Sure, will work on to avoid the use of this static variable here.
>> +static u8 srcadd[6];
>> +static u8 bssid[6];
>> +
>> +#define IEEE80211_RADIOTAP_F_TX_RTS	0x0004  /* used rts/cts handshake */
>> +#define IEEE80211_RADIOTAP_F_TX_FAIL	0x0001  /* failed due to excessive*/
> Uh.. we have a radiotap include file and you already use it, why?
>
Right, will remove these macro as header is already included.
>> +void wilc_wfi_deinit_mon_interface(void)
>> +{
>> +	bool rollback_lock = false;
>> +
>> +	if (wilc_wfi_mon) {
>> +		if (rtnl_is_locked()) {
>> +			rtnl_unlock();
>> +			rollback_lock = true;
>> +		}
>> +		unregister_netdev(wilc_wfi_mon);
>> +
>> +		if (rollback_lock) {
>> +			rtnl_lock();
>> +			rollback_lock = false;
>> +		}
>> +		wilc_wfi_mon = NULL;
>> +	}
>> +}
> Uh, no, you really cannot do conditional locking like this.
>
> But seeing things like this pretty much destroys all of the confidence I
> might have had of the code, so I'd say we cannot merge this until you
> can demonstrate somebody more familiar with Linux has reviewed it, I'm
> just doing a drive-by review for the stack integration aspects (and
> haven't even found where that happens yet).

I will refactor wilc_wfi_deinit_mon_interface() and submit more cleaner
version of this function.
Currently, I am not clear about which stack integration part is missing
. Can you please provide some more details about it.

Regards,
Ajay

