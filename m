Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60783C282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 12:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24F3F2146E
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 12:39:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="RtpG1b1V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbfAYMjm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 07:39:42 -0500
Received: from mail-eopbgr790058.outbound.protection.outlook.com ([40.107.79.58]:51440
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726122AbfAYMjm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 07:39:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dWWZ2Z0do7Upi4OG89U/jIdnIjn6hehZPDOULUURuGQ=;
 b=RtpG1b1VxrYjuQPzFgobmHOhDFn1oF3mQs551daxbckCn996aUux7CmyizKJtrfGRz5qf+xJvMMAlziKyFpXRh6P+EBEZaUp0ZlyCBKG5iundYa8s3c/mVCVEwlP/R5B5hhaArzWB8xJ/IQhZYhzASR0muRNdaSYk+fD/ve/ixQ=
Received: from BYAPR02CA0009.namprd02.prod.outlook.com (2603:10b6:a02:ee::22)
 by BYAPR02MB4326.namprd02.prod.outlook.com (2603:10b6:a03:56::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1537.31; Fri, 25 Jan
 2019 12:38:56 +0000
Received: from SN1NAM02FT057.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::205) by BYAPR02CA0009.outlook.office365.com
 (2603:10b6:a02:ee::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1558.16 via Frontend
 Transport; Fri, 25 Jan 2019 12:38:56 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; web.de; dkim=none (message not signed)
 header.d=none;web.de; dmarc=bestguesspass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 SN1NAM02FT057.mail.protection.outlook.com (10.152.73.105) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1558.11
 via Frontend Transport; Fri, 25 Jan 2019 12:38:54 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:42881 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1gn0l3-0005Dy-OL; Fri, 25 Jan 2019 04:38:53 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1gn0ky-000432-KQ; Fri, 25 Jan 2019 04:38:48 -0800
Received: from xsj-pvapsmtp01 (xsj-smtp.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x0PCcbHm019896;
        Fri, 25 Jan 2019 04:38:38 -0800
Received: from [172.30.17.111]
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <michals@xilinx.com>)
        id 1gn0kn-00041p-HW; Fri, 25 Jan 2019 04:38:37 -0800
Subject: Re: [PATCH v2] arm64: dts: zcu100-revC: Give wifi some time after
 power-on
To:     Jan Kiszka <jan.kiszka@web.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Wei Xu <xuwei5@hisilicon.com>
CC:     Ryan Grachek <ryan@edited.us>,
        John Stultz <john.stultz@linaro.org>,
        <linux-wireless@vger.kernel.org>, "Reizer, Eyal" <eyalr@ti.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Michal Simek <michal.simek@xilinx.com>
References: <efc793c8-da17-e267-851e-f08f097843ee@web.de>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <bf8ed343-d9af-c7d3-0836-6dda2b3e8243@xilinx.com>
Date:   Fri, 25 Jan 2019 13:38:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <efc793c8-da17-e267-851e-f08f097843ee@web.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(136003)(376002)(39860400002)(396003)(2980300002)(189003)(199004)(54534003)(8936002)(77096007)(186003)(31696002)(26005)(336012)(305945005)(9786002)(4326008)(36386004)(446003)(426003)(47776003)(2486003)(23676004)(106002)(65956001)(50466002)(2906002)(65806001)(110136005)(316002)(65826007)(58126008)(54906003)(230700001)(7416002)(6666004)(356004)(36756003)(126002)(6246003)(107886003)(11346002)(44832011)(106466001)(76176011)(8676002)(81166006)(81156014)(486006)(63266004)(2616005)(31686004)(476003)(229853002)(478600001)(64126003)(107986001)(5001870100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR02MB4326;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:xapps1.xilinx.com,unknown-60-100.xilinx.com;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;SN1NAM02FT057;1:SZMmH2eqIq5csuiMZNNv3i+JX7sIAbxPqLZ2RS8NGnLVYcvufLAP4FPTheKlDT201sSkPEZege/PEnLpVkDFyNp3prcz5YWPOUyra3FtTUz61UjrQLzgRzQc+TEwJTivY55R292kJuiaKQY5A0KvWg==
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bdabf3de-1752-4067-8087-08d682c2122b
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:BYAPR02MB4326;
X-Microsoft-Exchange-Diagnostics: 1;BYAPR02MB4326;3:5uNJ0KYUKn72osJydvi+4CVMuxyEVG2xWYpXVNv5ay5axTStuudbsnUAWyd1q/4wDOfY2ZnJtuh7t8EeZpVeofFtpAl50eIzKcT1A8hk90BmPzKXa8wbybHYR1qdvrpc2SvpLvO7N/RoS0UCxJRoXek7KXIVJ2UOG+ujCmGoUinSCvvIi3nkLU6sS/jyD3XNUkQAgNhI3duevsdf8tqiZl5avGUApMDUA5zt2LLrRUcDKKzY00ZAeVFSzXMlLaSWntqPvp+8AXM31yhEKTsy2iljLex8vK3xc5W1X4CKcQjoMSgUpRJbFHo5mDrGFa5/W1LOWz0E83gIqeO+ZczuuB6gbz1QZEZ97X2vDTFTByWaUX76YT+NqFNO3DTW+jtp;25:awe3PMVAKpK5wER7rQe2uZ0U3gbNaAW/zsiP4umFEEjKcDBlERpZ0sj3+uB/hNaP15Ja7i1puGT1L1WdGLVLSWu2JOAILVi3Y0RQRRUJDiGoP2CxVIKct6VsNJ0ornUHEU6Oxx077b24kZOzyszAXA1SQEVC5QO4Fx6gP5Zsy9Va9SBXL/naJi6YOmcvSghpaZkPnc7Zpe771JquDlVo9rbzUsjIy87qx7jfmcBxNKL0GfNHri8VCWZFjr48enk+NmW/cKt/rfe77A77tSBrpDJuZIPwADkCHy5oVfWNrIsHMEkddKqIcwJWzjr2HLruRbfW0nhqfsqT4XXQnczG4Q==
X-MS-TrafficTypeDiagnostic: BYAPR02MB4326:
X-Microsoft-Exchange-Diagnostics: 1;BYAPR02MB4326;31:us+eu2ULmRC5+hY6O8XS8IOwLO5D1UYZNQDjDt+MRee+2NFSzEZb7zUPPGfm/Y6EzX/iSBH2vIUVlzkazubLCXOR3FQogYB7UhMhjegxOIAN67THTR8ceLQ91P2qM9tqt8f32O/NhCeX3B3vR43oQltm6F19f3DdhCzLXgMJnj8kAi8hnHAtnvOiTjLn4J+pO9PfdksP1NkQVxk4VeQJ08HmoxQt26YcV9NGBgM7t6o=;20:HbFKLkaTo9+ayT3XOKYsxxHp2tRm6qSl6Aj9e8c8es+luv7i0t/p86niOlqYDLd8waH1rH/Nu2KbIcMUpp/O5lqF4noIuKhhodQ+uHqmUsiJvfudSLvVyk7wAA/SgHX1DrYKOv+XreXPo3uEUbfALEjGkKF0f4ay03HRVM2d8gG8M0l4XGc6hY7psqSg3m6wbGdkDEtTht6r7lzIp3VzAXDOSyySUTu8f3XLZg5aT0Kh30Vblk7Dyp6srJGu+PaA5Uc2BTlfzjIC2M2AotrvF4RdV6Qg9qW/4K6hI4GQl7VcYg3i4DlEW4agWF+tE+QxwCNdAR9gjpOWqKK2gf/A5Z91X1xFxpavztGKsk1KNgpFBl6tJBqVDKeZe8JttKSfcEbUNCmCgvzJ2vlNIfgZ/V72xqf9GBnteru1Y+uwOoHptSjXpbzCeneIdOS1iDhcBOkk3sHYVFfDr0bvEyEsEIURNHgvzNISTXQNhAEw65fpeI8JbDCCR2eZZb6PtK68
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-Microsoft-Antispam-PRVS: <BYAPR02MB43267F03BAA208C46A17A122C69B0@BYAPR02MB4326.namprd02.prod.outlook.com>
X-Microsoft-Exchange-Diagnostics: 1;BYAPR02MB4326;4:/73Vgtu2vY8F+mamz1iYhnykZjqh8pxaQOJaIEkiBB1VC9KeiYKq1ukj/84jM/XzaAr3SUELc/yr0sZUbF97e955upeciKid1coQF7SQjN/kXKMbzcPCoosogwPVubDDXxGb8+KjiTT0eBGqUf37c/JJTMWRqRi5HckyADgnprWsQkmjff9BPh2y13RO/6ZddP+T9kcKvlNjztchFAd+THmeKSL3/pqxf8MrwYcFbaHF8ecJ8oyKis0b8KLExc53gUZonqf+YHHHmfGkoidKxg9S5dftEJL45PTtBMx09lVC9PwPn8mVGaBbIkhZnvZl
X-Forefront-PRVS: 0928072091
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtCWUFQUjAyTUI0MzI2OzIzOitVY0xmOHd5L3FwaGZxU0ZnaWpWZnZkQWJI?=
 =?utf-8?B?RjFXTmMxUTZGSU1RZVNxa0djQ0NCV3pmb253aTRibW9jOFNsQVJESWtIbWtk?=
 =?utf-8?B?VVcwNmxoUGNFQkQwU3R1Sml3REZUUXVtVVBneVFTZXdOcmhzVlR0MzRQWEFr?=
 =?utf-8?B?NzgwOTJwMnRta0l6Q0UxNGM2cC9CZkZpcWtvaVhLTktBSnpaYjZqcFVoOVph?=
 =?utf-8?B?YUxOcWZxT29OQWlWbzJMak5Oc0hRdDVPRE9nQ0NBbXZXNTFQaVgwazVsd3M2?=
 =?utf-8?B?VzZkVlhyUFlUTkFTcy91YlZYYVVCVWRWcDl1am1xZjZpVUxvU09zQmIra3di?=
 =?utf-8?B?QlAvVVFtc1FEVVRwWDl2Q2NTSk5BcktCaGZwTjY3ekg3bHE1OGd4ZzRWR0ZQ?=
 =?utf-8?B?WWRnRkZ3MFBFNmVwc0RGYmhQVTdJdE5UZjdFWWNSWlEwU1JrRnlzZXNNZU40?=
 =?utf-8?B?RjdWUzR1RGZ5dkZtdHFjT3pORlFyb3NwekQvaFlrZEtSZGlHOEVMbUlTVGxF?=
 =?utf-8?B?clRDRjcvWkNwNlNOQkFUT1ZUbVZmTjJVd0VVUkloZXcyU2pNWC83RERFQnVH?=
 =?utf-8?B?ZkdOdE1ZWXZtNFh6bTN0QW9rdjg4Q2gwRVpTWVZOVmRLM254U1RSVE4xNnZm?=
 =?utf-8?B?SkJoSThtVGNJaDBaQzZqQTZkSVZOcFpKRFUvTVlMRXBHNmNxSHVjM0pKNHhJ?=
 =?utf-8?B?NWNIYjVxMW1DTXlqQzhHakE2dGpuQ1RvaUNQQU1BYlYzTXFKbUE5RnVTSjF5?=
 =?utf-8?B?MzRHRnFaQlplazRTVmdqa1kvVWM4S1BPOVE1V3hwMTBZYUhlYUk2TGNXQ3E2?=
 =?utf-8?B?Q2hpM3FyYmw3OTNxdkttdGtLbnVvMTkxb2swVTZ0RENxbHFUV1EzVDhjR1Vk?=
 =?utf-8?B?enZTbmMrZFdmYkFZcUFQdjEzd2V1dVFiTkNheEhFOGMzb1BoZTBQZlNuQTc5?=
 =?utf-8?B?RlNEaW1FQTBzOHgzdHJFa2FuSWk4dkpJUFJnNWs4QW5NUXhxZmdtUS9YaWFl?=
 =?utf-8?B?Z08vZFFoSHhieUN6ZjRQSlh0MG5zQkZ0RnlRbWF5WHVOQ0gvQnYxUlBsZVZ5?=
 =?utf-8?B?dUpvcVI2dTFkWGtlWWZpWm40U056cnNHVXRCTTJzckZSeTk0TnlGRjBicWRx?=
 =?utf-8?B?K3YvU0dOTkhzcWVRTTBIanluU0tXQlZRbVBGZjhESzdJdlJVSnZCMk5LYzBX?=
 =?utf-8?B?YUNES1Z3L2RvMm9FbmdDQ1d5aUlnM0R4bVRhaEEwcEFlY3JHSkFRcnkza3k2?=
 =?utf-8?B?MEd3Tnk0QkFSZnlmTDU2N2RqNDJTWlIzYVhhNVF2ZDd1T0NJMk83WnAzMXJB?=
 =?utf-8?B?MGZNMUVJVkE0a2FJRlF3V1QrRmFzRVFSSkhYTlNzVldxNVp4M3hsWmZQZ3g4?=
 =?utf-8?B?Y0FXTlFIek8zQm50aGlWdUppNTcrakNBSWN2UWFsQVlNWTZ4YTJCUUFBS0RJ?=
 =?utf-8?B?Y05mbks5YW95TzNtWnA3ZnU3SVc5Nkp0Z1BYM0djdUVLNE5VS081RHBuNmlZ?=
 =?utf-8?B?TDFoYjNKaE5WTHdmaGdHblpTRXp4Q05ScXFHOHRqMDZ5SnBhbFFsTHE1STE1?=
 =?utf-8?B?REVrdjFDOE9uSDRHM0E0QUVjdFY5amJlSUVqVTlvdWpXbDlnbk1OTDZ0MlJN?=
 =?utf-8?B?Y1VQT3pnQ1VPOXZ5aEpJK083RU1pdnlBcWl3ZXR0Sm9pT2orQ3JacHAyb0hi?=
 =?utf-8?B?c3ZtSWFSK3pGYzEyVUN3dEtma0J1dzdKZ1RCYXZibGRYMFQvNGhSTTRLc0lO?=
 =?utf-8?Q?NNdaDEEXTshJVd6Jnq2riZ02YD//AT+cWIOWk=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: M7Rql3j4peueuEId2UaH7f8Xh+qwHyQMbyLzm0WAt560opVzJ8VRq4DA0NRiLqFJtAuFHNvST2l9kLBsrlbyg8tCrCaGC0IsB1vl1oxGDQBTBaL6yWncv8RMB+rscfcnhhX9K+oEfQL+KEg2tMQHPLGqPRkYC1i96/FnRm9EM8EfQNND1F03kgvIfohgZvOXf3rLNBcQ6rNSZQqZ6VrhsBjQKfJoIbY7iKPELmn6T5lKZ4kyGaoNQiaee0rRXCWJulPAE9YYb7gZTVftV6HW5FkWrVrc5P1GECPlLPPwQFGglRCV394RYZTZEWnROh/qyCkZ0VfrXOtj0nJfYE+px+Z3BRGUDdkciE24fKf5WERDCAnxP06ATzWdiu4AwgOvBVOCY5qPOzsr9Cdbb2N/8Bh9WbTw8tj09Il9Z6oju6s=
X-Microsoft-Exchange-Diagnostics: 1;BYAPR02MB4326;6:XOmL1MQSNfo0uMAEF9jeiAQVVQ/9u1WT05CVZjdcBJ8+x09m9XOz8vokmsfZ8N3VYdaC5dFsqmh2pOnBhc6c4iTSoKUgQn9QTFd9Y06C3lX5zea0Z94zNR0tx8kLLX0nu6uLONSiiHUzgqUSWCFUZnifBZrpSRUVP49ROePFiuJclTJEdGdvHROvN/2jWyQ/ZIfcECbFM1VsFmUr9T9+BcPz0/EUQp5lxjU3qFcHgS0VVP6qVoRBkF4Owtu7OoxqCiN1HTsxIMYnzCqvFiY4WeKQuRPp10MBPoG9kCQVLYeYBp37yGyY17xpMcAzI6pAa6iOmb6bewDxbJCQgJ1DT1RZGJhwOXI4P3xdiill5+l2VVEoxbUdnhwJyFA8YFIEkYwuaXbEoU13kcsNvEJYjU6vTgBa7P3+U3D4UY9z7O+v5bmFfJPhSnF5iVMqCEeVA+oVkvRhmBAkI/3RBQgsyg==;5:cPNvmYnw+OJRCisAGZZZXVLwP+eb4fPjC2X8oWCNCDqXsIodEhpog7aOJvfpZJt5MOB4LcgMCkwjBBJbQ99hv+onk7SFP829hCwQzAznZOH9DvKPdjCFOi7SKd/RnNBuwTjwqzl5WGkDaAz79ccD7RVNASQrccW3QO5RjqB7E+/tjwE8b/zGRJfROdfFyuy6uSMnJBQtqoT68cvLwAsSNQ==;7:VCAP7pqr0yPGa/nMrV4ONHcESKsgEAApX6wLRm0Jk3Rpw+dwTH82hTRZST9QjozgTwv3sAIb347boAXrOaeh3K04HrPqURYo/ouOBCl1/uSyjuPIbq/Rvh8w90CfVoBm6AYyAPvGTReLfiwmw9pWwg==
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2019 12:38:54.4923
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bdabf3de-1752-4067-8087-08d682c2122b
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4326
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 24. 01. 19 9:28, Jan Kiszka wrote:
> From: Jan Kiszka <jan.kiszka@siemens.com>
> 
> Somewhere along recent changes to power control of the wl1831, power-on
> became very unreliable on the Ultra96, failing like this:
> 
> wl1271_sdio: probe of mmc2:0001:1 failed with error -16
> wl1271_sdio: probe of mmc2:0001:2 failed with error -16
> 
> After playing with some dt parameters and comparing to other users of
> this chip, it turned out we need some power-on delay to make things
> stable again. In contrast to those other users which define 200 ms,
> Ultra96 is already happy with 10 ms.
> 
> Fixes: 5869ba0653b9 ("arm64: zynqmp: Add support for Xilinx zcu100-revC")
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
> 
> Changes in v2:
>  - fix changelog
> 
>  arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dts | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dts b/arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dts
> index 13a0a028df98..e5699d0d91e4 100644
> --- a/arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dts
> +++ b/arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dts
> @@ -101,6 +101,7 @@
>  	sdio_pwrseq: sdio-pwrseq {
>  		compatible = "mmc-pwrseq-simple";
>  		reset-gpios = <&gpio 7 GPIO_ACTIVE_LOW>; /* WIFI_EN */
> +		post-power-on-delay-ms = <10>;
>  	};
>  };
> 
> --
> 2.16.4
> 

Applied.

Thanks,
Michal
