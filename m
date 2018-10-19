Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44026ECDE3D
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 08:34:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AEC12083E
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 08:34:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=SpaceSystemsFinland.onmicrosoft.com header.i=@SpaceSystemsFinland.onmicrosoft.com header.b="DZn5Kgvk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0AEC12083E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ssf.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbeJSQja (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 12:39:30 -0400
Received: from mail-eopbgr20068.outbound.protection.outlook.com ([40.107.2.68]:34009
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726609AbeJSQja (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 12:39:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=SpaceSystemsFinland.onmicrosoft.com; s=selector1-ssf-fi;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=heGHMuUUkHAhxDDHir+fRQvKN16WuWxxR7cD8OaLEjY=;
 b=DZn5KgvkuPuOohFHTxly27a8rT2RTfWTEMjiznPrEwy/8TcdO7i+l6GorSV41hBqpz0XikL2QV50sA6YWuyqKn4PNkFesq5+gPWiNYRHGdpkvQt6KiLBWT3qa42SOcp8lKpD6V8s37eAB5kzT4dkUT6le+hHKJpcIea1u61uyX0=
Received: from VI1PR0202MB2829.eurprd02.prod.outlook.com (10.171.102.18) by
 VI1PR0202MB3487.eurprd02.prod.outlook.com (52.134.17.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.26; Fri, 19 Oct 2018 08:34:22 +0000
Received: from VI1PR0202MB2829.eurprd02.prod.outlook.com
 ([fe80::8530:4836:9281:d30c]) by VI1PR0202MB2829.eurprd02.prod.outlook.com
 ([fe80::8530:4836:9281:d30c%8]) with mapi id 15.20.1228.033; Fri, 19 Oct 2018
 08:34:22 +0000
From:   Ondrej Daniel <Ondrej.Daniel@ssf.fi>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Hardware packet timestamping with Intel 8260 chipset?
Thread-Topic: Hardware packet timestamping with Intel 8260 chipset?
Thread-Index: AdRnhLAQmv57oL0ETBmLC7PkqlQxtg==
Date:   Fri, 19 Oct 2018 08:34:22 +0000
Message-ID: <VI1PR0202MB2829CA6F8F667AD6E016C68580F90@VI1PR0202MB2829.eurprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ondrej.Daniel@ssf.fi; 
x-originating-ip: [85.163.13.66]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;VI1PR0202MB3487;6:+zP5qXMikprZ5hN9yNEvGKyp6cvopk0s4wUkC8W+t7FyPzBpBiQCVh86dn325IlFjI8L3yXYJO05cBQfKCRGeWezCqOdiT6xaLRiB+w5cOvZxpk0M1OTiKyRC30om2DX1mYzOE7H7AbqQgWGEQQasO4frgwN5kZ2WGJC1vWprfLWUoGCfSj2Buc6YMHnOlw+rm5Ge0+hVp56A8wIM611NXt8wOrkoaPcV+HVY8aZeIimki0S0fZkSgAqsZXFzGXVVVGrN2mnNb+hkerHbjczKWwJOx+FRLWfi+DyChmajwLskTLFlJ+pBuuyQB/uonEqiqv15Hy4PxkV1YYPsqIWCm1yx5MzT2Nhp+NYIwlf8R5Q3TzSNIHiydw5SDC+dRAfpLqJncP9H4r79i2nd37Ci7oDF9Oz3cv17B910WcQK6mRGPQEo2RCRyjXrlGwk+0vVBQPIObXyZjgQuKT0x5QQg==;5:s/1qam6VByoYA6b3yhLxG7hb6bsbkUqDSMdVDOMVGlX+W1XyLD0p26dw1Ze7ZyvoVdr0/UL7dAPM7atQ4qXVPmIF9uc6MBrR+CfjVuwUYfI1MPr6Gco463dNWBbyxzlLK0JkeMA7B+/yKa9rWTXgWHlHJw6/6H7OyVwLFHllBAM=;7:SwN4b2oXhNAcfnAfVLkSVmn4aRqkYi/5KHixfwe4Ujed44WFE4cRaxHeBnkFkB6Usp9PvjnrQA5lvjNq4ZG72Djv4MwixCIBuoH4nCRlJ9yP8F0X34J1x35OCnIH31uGKOpOZdVQnYSbKt343LcOFjdLuUgF+TRlp4HWABFegEN5jtNCqPI+aEEbPf0Sgrd7+GGZEpQX+YewTkHzHjfthfKTAg5lnnLeeVnwtaaMByL7x/A9EGs1nNqCApWg0Nh8
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: cf07084f-839a-4107-f1af-08d6359dab96
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:VI1PR0202MB3487;
x-ms-traffictypediagnostic: VI1PR0202MB3487:
x-ld-processed: efad24b6-33d6-410d-acaa-d77e045ce782,ExtAddr
x-microsoft-antispam-prvs: <VI1PR0202MB34876D87DF59089C750EA4F480F90@VI1PR0202MB3487.eurprd02.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3002001)(3231355)(944501410)(52105095)(10201501046)(93006095)(93001095)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123562045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:VI1PR0202MB3487;BCL:0;PCL:0;RULEID:;SRVR:VI1PR0202MB3487;
x-forefront-prvs: 0830866D19
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(39830400003)(136003)(376002)(396003)(189003)(199004)(7696005)(66066001)(6506007)(99286004)(102836004)(86362001)(305945005)(14454004)(26005)(106356001)(7736002)(74316002)(2351001)(33656002)(105586002)(186003)(97736004)(5250100002)(316002)(256004)(71200400001)(71190400001)(2906002)(5660300001)(53936002)(25786009)(5640700003)(9686003)(3846002)(8676002)(6116002)(72206003)(2501003)(478600001)(55016002)(8936002)(68736007)(2900100001)(6436002)(6916009)(476003)(486006)(81156014)(81166006)(14444005)(74482002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0202MB3487;H:VI1PR0202MB2829.eurprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: ssf.fi does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: vRsS1Ssh0DGao/eO5ApySIOBlG0XS9NQvijWfRGskisTDko063OLCE8cCCPvzGa4mYsljegLSRC3n15JZCOXhrGLkleCeznMpPc9nI+jIAY9e94Fu+g88mMMRqlqe1GwiJpL5yI/17zhzk61NWU/Kuc/73UpofY+O8skFZmYIYf5nKuH3ypg9nUvnY/M/Rc07ZThEXywbajJheC1qVjrYgIxVos19FUyTHqaYGzkx1bjHT6yVTxX5jza+ZodELblOufnlAEKHUVQ2umU8PuAlCdnjPAmU3CnfWUUl721u387+Y3AXbi+oTEk1aqfgmwUc43lAa/cfXBJWDZSvSOV5qve0H8ovi7QJAikq8r7br0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ssf.fi
X-MS-Exchange-CrossTenant-Network-Message-Id: cf07084f-839a-4107-f1af-08d6359dab96
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2018 08:34:22.2718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: efad24b6-33d6-410d-acaa-d77e045ce782
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0202MB3487
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I assume that the FTM (Fine Time Measurement, 802.11mc) functionality, whic=
h is implemented in Intel 8260 chipset, relies on a dedicated hardware cloc=
k to perform an accurate timestamping of incoming and outgoing packets.

Is it possible to access this clock to get hardware timestamps of network t=
raffic in Linux?

When running "ethtool -T wlan0", in which wlan0 corresponds to the Intel 82=
60 chipset, only the software timestamping seems to be supported.

(Some system details: Ubuntu 18.04.1 with kernel 4.15.0-33-generic; iwlwifi=
 0000:01:00.0: loaded firmware version 34.0.1 op_mode iwlmvm; iwlwifi 0000:=
01:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=3D0x208)

Is it planned to add the hardware timestamping capability to the Intel 8260=
 Linux driver in the near future? If not, can you briefly suggest a way how=
 it can be implemented?

Would you find technically feasible to use this hardware clock as a clock s=
ource for PTP?

Are there any other wifi cards with FTM support available, which would allo=
w the hardware packet timestamping and which would be already supported by =
the Linux wifi driver?

Thank you very much!

Best regards,
Ondrej Daniel
