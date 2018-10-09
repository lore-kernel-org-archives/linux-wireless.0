Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B34C64EAD
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 12:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8F6B204FD
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 12:18:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Mi2vy3Wu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8F6B204FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbeJITfi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 15:35:38 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:32808 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbeJITfi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 15:35:38 -0400
X-IronPort-AV: E=Sophos;i="5.54,360,1534834800"; 
   d="scan'208";a="21258300"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Oct 2018 05:18:56 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 9 Oct 2018 05:18:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPpNA8mWtOEB9A/GUJQV2jYlTaoP/cCVAZ/BBTAMXOo=;
 b=Mi2vy3Wu8uI5pnlfolCo/vP02ncwRAVuPSzhMI6IWfz+V5HJvfeXkF7pbVvl6NJBM+7jh1TYI6ckrZUQl2yiF3aKTXKlF5iYTCaKVmK1tYwxn7mJuP1YG/7Gwb7M092vKRUXBlRvMv9CrDitgSFKsRALWJRuhOyB8O/3wYGxaGI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
Received: from [192.168.0.101] (49.205.217.41) by
 BN7PR11MB2562.namprd11.prod.outlook.com (2603:10b6:406:b0::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.26; Tue, 9 Oct 2018 12:18:51 +0000
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
 <1d77cb4d-92c9-0ea4-bdd3-f16a2421406f@microchip.com>
 <1539085569.3687.115.camel@sipsolutions.net>
From:   Ajay Singh <ajay.kathat@microchip.com>
Message-ID: <092b38f4-8153-9abd-890a-a42454f22154@microchip.com>
Date:   Tue, 9 Oct 2018 17:48:32 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1539085569.3687.115.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [49.205.217.41]
X-ClientProxiedBy: MA1PR01CA0073.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::13)
 To BN7PR11MB2562.namprd11.prod.outlook.com (2603:10b6:406:b0::32)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01f9e980-514e-424d-b45c-08d62de161e2
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BN7PR11MB2562;
X-Microsoft-Exchange-Diagnostics: 1;BN7PR11MB2562;3:8hoLX1Ijyb48x1SJQBObz0e4HeI+4updhM28smrCUrrFzRzMWbJAPhWBu3bYf22n2K63odhiHDczrjMKgmf+iO2k081key2qxSWcLPihxH9QKqk2/4H8xbLJJ4R2ZorBybcDZIoH2t51GrjWiLGfcc9Lkse5X/yAOkbdPiWXHX7VUpn6jI1FCky9UkjJ35LbawdKX/KtN9MDAFQ0CxZGfUAiqIUumxaGwUfr6eW3Tghg6lDjQPID2w2gyw82lWrF;25:+5KStqlc5Qrrfb0WARL1KrFgE8vFL9o8U9Upg/v5BLP5BJsMuQlfosR6CnK60nwtbQplNt1TzRSGKpLiB+NQqK/3bS+bqVlHpPQwqDnmHKSS+A9IHxbXL0Acbu3DUx19U2PjPaZwfzgBh/0Pb+SS3mwAP2BN9iSAGuW0nDd4zhy4oABhXXNiRIJoz4EX5Mdh35IAM4777l8djkuozcKRM4gLP0y2NzGTWrzGXyt96W+xb0mAnLj+RWMXZ7jsMAl9DYMBwceA1r2YtzFixR838CsoZ4jzXspA6OmlQ/x0u2HQfeb2v5d+tU/naIDHkRpj5mneRO2DqAnx7SnXWWxwOg==;31:9kLp2r31yrUQ33T4G8YJRakjtla7CyYJdfxurlOxvqgOaNezilz8hzt72icjpClyJiilYvAIsuf2CF/kVymi3uGIkEy5qK+goLrCBkir7znmrvSLds43nnaT1MjV+fP0l+c2h6LjjkFeoX+kC0NwBbQgy4FjBPpHscDwMvRJoXRHIFOmsKQtd+7LVdhOCQyFqK9Rtb4gfjCxqBcZfqV4Pl4XdUtHPWMyX0SwREtBE+0=
X-MS-TrafficTypeDiagnostic: BN7PR11MB2562:
X-Microsoft-Exchange-Diagnostics: 1;BN7PR11MB2562;20:s7ftJJUYXnQP23JMSWWMUP8CtlTkvT0E3fKrK6xCeOktCm8SY0NzvyxWTr7i/Pt4o+FZu3gGpwcCtQqOpC/hk9QrxRnn9GUVtGLwALz5r8NNAaFZAfixFOVnjNvImaj3VTLht6Q6xdZM6A9VSE1fFBu1Ij9d/9lLMr5GfUgRT0HI5/Jf2v6NJRWA/Anqzyjw1/2WphuzVvvmQPL+//aLI6eqlJH9qgWh1PIwZXm1ATGDv2xQc0f4HATSJK8W67omGavjCTIXB21EFV8aWqxWQel5qhpWMAAOKXaQbXniXKE0TA4TjEmRZW2N8P5HDLiVH5bH+2ti5Yd7u+QWoFx7I8BLFP4B7XY+YQSS2lTIEg3RV/LMP3gTQa2TmdVlKCRGHJ0pAP5iXFGdsUJHKD2NAs65Fdp18dQ8+e9J6nzvmu8=;4:ZOfxswMz+PXINN9apqWmV2xSKs8PDv2v8ytUXfjIQ/Ybz2TZ2aaQhSkB5uWh/P8ffAOnvzvEnE9uqMthrqtGnOOTVUMPDYolBsEMiL9xAitpDRTg2Y3lj/mrXGtE96DS24q75LlaVlPFlaWZ4Tt5WAvR2MaaaJU04MEoSZRQMapRFf1fkr0h1WeHacssGjJcUiMmBHbZ9nNKHzW/LwLyuwf1OEawMynVR7Ito9pyXlnCXG4CiR2eiH+Z3KO0BbDLxszVQJhPvxGvy/PWbRfgqsQjMIU/YWAWiJOp3bZJVhLW6jYo32uPSbBI5wX6W6nEUBGgQTgMsFm2UN5Czghxjrfb7y5SDFVONY8dqL0bteM=
X-Microsoft-Antispam-PRVS: <BN7PR11MB25620E2E4FC80A829E4584CCE3E70@BN7PR11MB2562.namprd11.prod.outlook.com>
X-Exchange-Antispam-Report-Test: UriScan:(163750095850)(17755550239193);
X-MS-Exchange-SenderADCheck: 1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(20161123558120)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123560045)(201708071742011)(7699051);SRVR:BN7PR11MB2562;BCL:0;PCL:0;RULEID:;SRVR:BN7PR11MB2562;
X-Forefront-PRVS: 08200063E9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(396003)(366004)(39860400002)(136003)(376002)(346002)(189003)(199004)(86362001)(2616005)(8936002)(106356001)(486006)(14444005)(5009440100003)(446003)(105586002)(53936002)(229853002)(2906002)(4326008)(68736007)(31686004)(476003)(72206003)(31696002)(11346002)(478600001)(956004)(230700001)(65826007)(97736004)(16576012)(50466002)(316002)(5660300001)(117156002)(47776003)(65806001)(77096007)(66066001)(65956001)(26005)(107886003)(36756003)(6486002)(16526019)(186003)(25786009)(305945005)(7736002)(6246003)(58126008)(93886005)(53546011)(76176011)(81166006)(3846002)(81156014)(8676002)(6666003)(52116002)(2486003)(3260700006)(23676004)(6116002)(64126003)(386003)(52146003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR11MB2562;H:[192.168.0.101];FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtCTjdQUjExTUIyNTYyOzIzOjdYU2FpZWt0YVQxZUJIUTA2ektPbjlaNkFx?=
 =?utf-8?B?elBoK0lpaFRvSWhBaEFPN0FMUENBWnZ6aEQ4eCtPclV4VnVsdVpPdXZWMTRJ?=
 =?utf-8?B?TEdhQTNaUXk2dWs1ZzVRRm1Md25sZTd5Ym1Qb3VmTE9oRnA2bmJUdDFlQTJj?=
 =?utf-8?B?amNGaUdmM1BaSDFzUkZyUHVZRGFvdVpFWHR5OXE5bldDejhZZE5yb0lIZTFx?=
 =?utf-8?B?aDMrWi9SK2daRHB0bHU0ZlVZMTFveEtoY2pIWHhoNzM4VCt3VndNb0RXK1Y0?=
 =?utf-8?B?NnhIOG5UemxyOGNjNG5pTzI4UzQ4djAwWFNzd0E3UGpKbnNhNFEzUTV0anpD?=
 =?utf-8?B?bjV0MTJHWC82dUx1YXc4R3lTSFBldE4rN3pQaHByaGNNQjVmQWxLNjI1VXl2?=
 =?utf-8?B?OUs1emtOc0p3U2lNRWZKSDdUdXNna3pLZS9LNVNrejdQb1dlMXRMUnhIWlUx?=
 =?utf-8?B?YXNDbCthYllEZkozYTByaGxEdE5SUzIwcCtYZGNKWTU4RUhJc0tGOXp2NGJ2?=
 =?utf-8?B?ZVBoY3k2a29td3puWVROV0xyTmNiWklONVhUYlBrRFU1dzNCT0pkZkxwdEZu?=
 =?utf-8?B?M21adkQ2eitMT1NuTFNUdllFR0NsY2tVdFdIYy9iODVOTnpZYkNsem9GdFhq?=
 =?utf-8?B?b0h6Y3V5N2ZlVUdvdzAwVU91aGFQNEV2TUpQZ296NWJYR0xkRnVvTGlsZUQz?=
 =?utf-8?B?SzdJR21HQ21PT0JpbkVBSG5DNGp2NjI2ZTRkbzFMRTdNNWRtTXNxYmo3Q0J2?=
 =?utf-8?B?elBHVzRyVWRxWEJvYzRSNXVCNlNxZWNhdG1ocjR4RWp4VmQ0RllPektrczZD?=
 =?utf-8?B?VWpWMXk3NzRyTHNNdDdBSk9xS1NRUnJZalpHWmV6Q0Q2bWhjdDl1QTFoMVE5?=
 =?utf-8?B?dlFqbDhpeEh6TmkrU1VTcityekRIS0lUK1VYeXNkNEVGY3FTVTBOR3AyN0NJ?=
 =?utf-8?B?YjhVYmVqenRySk41MXczVU85R1NqZ1hla2hObmo0WWRYK3NCVEtDK004NVhW?=
 =?utf-8?B?TWFJblFTL2phbGVVYmEwVVhRSGlQYTd3R2RaMjByYXBUWXR4WFN6Wm1PeU1k?=
 =?utf-8?B?c2l2WkhlcEdWd1VaU2s5NTVIQllKNDdDQS85dTEwVzBtNjF3enRYL0UvRDJs?=
 =?utf-8?B?eHd3WmxycDdzNU82OE82WExGZ3hQNDVUV2FMbWwxVjJTSFZDQWV2N00rOHZn?=
 =?utf-8?B?WmFNMnZCOTRCTHA2OXJxb3AweEJ2YzV0V3lBRXRCSnk2SW1yckJIU0pWSjY3?=
 =?utf-8?B?eWlOMXFqNW5nZ2VBVVJTblhGNEVEak9kYW8wMkNzam1CTVhyYURmeFRZckJx?=
 =?utf-8?B?UFJCVjFuVXJHL0RPVDBua1ptMUlnNzdmTTFSQWc4amU2Z1ozbkp2OVB6UUZS?=
 =?utf-8?B?a09xenZneXVRNnNVanhjOEd2cG4rMzJobW04bjFZRTR3Z1k1NGVuTytVTWcy?=
 =?utf-8?B?SVVtc3N1Ymt4V25VcCs0clBoVWVpSEpPaHR5V3VwdCt2ck11OFNVaThKMDFq?=
 =?utf-8?B?akZmN2I3bmc0em5pRWlYVFhDN0taYVNGUEVxL0ZwZWNKNFpTL09FMGNZQXF1?=
 =?utf-8?B?Z3dBb0FZWlV1NWJJMEVwZTlQWkhtS0NtcXpWSm9TVkJvTkxTMExmRDNCUTF2?=
 =?utf-8?B?YzJpZ1dVZG80elg0SWtYSlNlcDVUSGpRaDlyVWpZekk1N2Z2Wnc1b0d2Tzcz?=
 =?utf-8?B?M0dNOWtCSXozdmJRYXRrTlhZcWlWcmNtMnJUYmFRaDdSM09VZ3J4RGVFK3Bu?=
 =?utf-8?B?VnNtMXdoU1ZtMTMxRXhSRmJKemZaa2t6aUZLZmZOSW12cUtueDBPMmxhZUVm?=
 =?utf-8?B?akNnMFZhOEZlQ08reTRuV0p1RFZyS0pFVUIwVVZlR1JBM0ZUbHBmbXZMQkNZ?=
 =?utf-8?B?OHoxY0xvQW9OS2E1UVJxeCs3anB6RWZqNWRaVGpRekZYQ0ZUOW44dUlpVWor?=
 =?utf-8?B?WlNIdHJGVkRORHlaQi9UV0d2eHBwZTVqUXRKazVsd2puMkFQWWZFaytTYnJv?=
 =?utf-8?B?Uml0c1IremxiL3dPbzBmdUZsZlE3UXdycGRodlRlVjBQa1VFbTNFeVQvWWw5?=
 =?utf-8?B?a0UwYVFsOHphNEk0TWFzcWNKWHVHOFA4SGQrYUpPK0xoNExUQ2V2THU3OW9n?=
 =?utf-8?B?d2c9PQ==?=
X-Microsoft-Antispam-Message-Info: PC7oHu3E59TG2GZo+c7veC4WtZfMYb5TR6XH5uJ0ZPHHUgjrV+LaXmc0o4Dl9RMdYjvNbsMtZdQNAkUH7cEpQg5k6yjHqEXntcSsZfl6usRY/vxzK4TMZAbL69M3aWNrkzP9bOlNX+7ucBgxCrOjhcLG2xvS2xKow4mDCJ7o+ge91vdnQxzTqndPwqLwutD2QMC+m3Blm79wSLvb/up/J8oDjDg3Cf0ACCnpVU4NKZpwpcs5kxSkXw73y1vVrS/tdwbdRtjWhdilPP9yEyC2Zab2hppiP0BJeCdqoxLXtdTLCobfNYYJ0UDd4gbBtZuR1lHNxiIdEo/Godk+ZjRvEaanGZH3EvXzJWi3IonZkU0=
X-Microsoft-Exchange-Diagnostics: 1;BN7PR11MB2562;6:H7licLMbeGnlp+izD9NfpxTlVaHDXwCWETk1Wf3JQFbRtaUEqCgDINNr+2EwLXkijnAKUlsTbwsysKyEv36Q+mnXx5XkgFNJOfc9hCZiOnYGdfJ3jIfHIsWXIgBGMEJpivu2PGtpJIAAUCuz7AlOOoZeG+DZf1pFp8IGQH3i6ux6DwlWf6ccUZEnU+cPFVXtvOWINQM7Q3ipv948yhOsMeQZdBgV8gj8xld44mYWSrnHOSBPI5plEzN+RHNoQVK4BmPhevXlBzUP/xmcK6KCu5yuTGTESZ0Vq/AVGr4VWkK5BWzsz+YX9cfVUD2VCRsKXbTDPx+tplLWdG/tTVIpfzjOBM665fbOAKNcDFZK6zYC5wTutD6AwA3qxjH87TWLGkA1IoqAqZ/EOLxeJWYd1XNpjTDUw6umBTSl/zpg0StLq9/kS9DlMPY2fhL3eovTLAk/qK4EaThHTj/3Znbp3A==;5:rJXvkI/zeJCiMHt1CxTTsyWc89yX2xUJ1E6UpVdJpNbSBUEYECBfqnDreaQx0DcZ2smuoo7F/JdFh1yglKijY2r8dZTyFR22hn85w71cnQhDxhPLfBqo+9g0fsG+uO6yMUH0zuMdWlJ92+KHWBB/fexsdAUT8CtPULAVuSi5Gqw=;7:bxJfBQOLCkr11L5ZTNXvuuuni86vV7v0dYlbZRNk1iHUNwCcZFCP5Z+D/QtTXYNNwjsbwEQzf5SAWOxyI/eoCcEIT4lC7H+m6irwqPKZ6d85ZcJq7hsfl55/5kpEfs4ChVArWy3XHER8P97sj2RDNlEqZuy5rfgKTT6GaUCPxE2mFecFoG0PS47HiKL1bhnT9Dm3FvYURbA0R5E5s0pOgSAV82kCMzbnDeqv47xW1gZp0FCFZugupMcfsdSY9rnk
SpamDiagnosticOutput: 1:99
SpamDiagnosticMetadata: NSPM
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2018 12:18:51.9799 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01f9e980-514e-424d-b45c-08d62de161e2
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2562
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 10/9/2018 5:16 PM, Johannes Berg wrote:
> On Tue, 2018-10-09 at 17:14 +0530, Ajay Singh wrote:
>> On 10/9/2018 4:06 PM, Johannes Berg wrote:
>>> On Tue, 2018-10-09 at 16:04 +0530, Ajay Singh wrote:
>>>
>>>>>> +typedef void (*wilc_remain_on_chan_expired)(void *, u32);
>>>>>> +typedef void (*wilc_remain_on_chan_ready)(void *);
>>>> I think as per coding style the typedef for function pointer are allowed.
>>> True, I guess, but why do you need them?
>> Actually these function pointer are used in multiple places i.e inside
>> the struct and also for passing as the argument for the function. So i
>> think its better to keep them as typedef to simplify and avoid any 'line
>> over 80 chars' checkpatch issue. But anyway if you suggest we can modify
>> to remove these typedefs .
> I guess that must be part of the internal bounce buffer mechanism? I
> guess leave them for now and see what falls out.
>
>>>>>> +struct hidden_network {
>>>>>>
>> Yes, its not related to hidden SSID. Suppose cfg80211 scan is called
>> with SSID information(active scan) then SSID info will be maintained in
>> this structure.
> so maybe rename this?
>
Yes, sure I will rename this struct.

Regards,
Ajay

