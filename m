Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF272ECDE43
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 16:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A2BD2145D
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 16:01:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=Virtuosys.onmicrosoft.com header.i=@Virtuosys.onmicrosoft.com header.b="iWgOAg36"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A2BD2145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=virtuosys.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbeJSACi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 20:02:38 -0400
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:3835
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728422AbeJSACi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 20:02:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Virtuosys.onmicrosoft.com; s=selector1-virtuosys-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Izb53J1DfdfNPHDlDGR8NiyFy0HPT+U/79VLZnP2Kk=;
 b=iWgOAg36RPA5374HB+kNDYD9iXgd08ydlzUHU0BRFMN4JsY5Qo1kh+Svi/2hfAsIHhL4LnkUiKswU1XCSgRH5dSEH5CJXvSeFP7eqJaK4F+cDVqkYhLGpJ9fMf/ohTee/2e9GMOJEJrC5lBkZ7quOIBLJp5C4SrGSHHactmS5Pk=
Received: from DB7PR07MB4665.eurprd07.prod.outlook.com (52.135.141.24) by
 DB7PR07MB4025.eurprd07.prod.outlook.com (52.134.100.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1250.18; Thu, 18 Oct 2018 16:00:56 +0000
Received: from DB7PR07MB4665.eurprd07.prod.outlook.com
 ([fe80::29e4:d377:6651:799d]) by DB7PR07MB4665.eurprd07.prod.outlook.com
 ([fe80::29e4:d377:6651:799d%4]) with mapi id 15.20.1273.008; Thu, 18 Oct 2018
 16:00:56 +0000
From:   Arthur Watt <arthur.watt@virtuosys.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "pradeepc@codeaurora.org" <pradeepc@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: FTM support on ath10k
Thread-Topic: FTM support on ath10k
Thread-Index: AdRm+F2Eiyfpah+3QO62N4n9o+a8pA==
Date:   Thu, 18 Oct 2018 16:00:56 +0000
Message-ID: <DB7PR07MB4665D6F6B47475B1F7AFD1B4FFF80@DB7PR07MB4665.eurprd07.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=arthur.watt@virtuosys.com; 
x-originating-ip: [217.138.78.198]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DB7PR07MB4025;6:7Rw4TZmxKjBWy9r3HHjj60cmIuFXsRUxmZSvAAsAkQ28BTH45cSUlsq2G7Q4fEOI671yjYhQR76d9nL1+Xc3mXCBjAFHr65j1qAOS+UhV8qRIHbNg8y3TMZ67NFvdbb7e1mXuipwzV3+3GTZAqhGxNRgqfcqcgabe3NTVU/U52vXqon6oQvHSqmx8TV3vASW/cgQwbdHV6KFZwxrjTPeIONihNGUSHLmL/NH12uqm+FJp4WmRcwTxdOvmgNJnHESMF9Hq0NUf6RARyUz6uYUvFD7TbIraVXSnSIP91wHdxQV/JbqAfj3a5Howf1gphbAfntJxvQ+2koQmodRAlVXzIYUoiqc8fH7A7CrEUONcCVzRnvv1/yGZ9Dig/PJXGHoqmL3iEDJhPJPQQwC2MpYBuQlRsSw+u20VNHAUw/6BSDv7qbUkbAtih5sDF8czIS97WAhh1IvJaa9p09wM3o0cw==;5:nvmxinqEjMNymhDn322Y3KsAT48wCuSyjzqdKzxA872IZ9Td4HDDNE1irBauIJ5al3xvKD0d4EHsAgor9kI1owziWW2OQl2yLHyQSzK3lIhTSUhsnGZLKvkWEPJwAq14ei9xlKRw3LxUWsC9Otm5L4W0BZHrJ79Dplk25wtK+bU=;7:JIA+RYm2orrrf0n4ZD8kuDwuxmPY1IxTp/qu0bM8BF5ZSdr1bjOQ3aNBmpd/nUSdZK9/KMz+o3i8bgpogpKXfBPni37t29LWGBS5I32JKnaLB7LY0COox9rB6ANO6cxaUW6g4Wd+aBVMzD2FzSkX2IaHrqq+9Z27vtWXtzjyuk2rBOai2McoPiHqaR83WoZhy4o1V1hJgCe2WQmxXqqlucHMNAgDdbPPtX86pK0HXlHWnP4kCKwDOdRz/hdBqQQF
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: e8123eb2-f9e1-48ec-07f6-08d63512e3db
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DB7PR07MB4025;
x-ms-traffictypediagnostic: DB7PR07MB4025:
x-microsoft-antispam-prvs: <DB7PR07MB4025B7DA79466A7D2879FA05FFF80@DB7PR07MB4025.eurprd07.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(3002001)(10201501046)(93006095)(93001095)(149066)(150057)(6041310)(20161123560045)(2016111802025)(20161123558120)(20161123564045)(20161123562045)(6043046)(201708071742011)(7699051)(76991095);SRVR:DB7PR07MB4025;BCL:0;PCL:0;RULEID:;SRVR:DB7PR07MB4025;
x-forefront-prvs: 08296C9B35
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(376002)(136003)(346002)(39830400003)(189003)(199004)(74316002)(6436002)(86362001)(33656002)(186003)(316002)(26005)(14444005)(256004)(25786009)(476003)(14454004)(4326008)(105586002)(486006)(44832011)(102836004)(106356001)(305945005)(68736007)(2906002)(5640700003)(2900100001)(66066001)(7736002)(2501003)(508600001)(6916009)(71200400001)(5250100002)(99286004)(53936002)(6116002)(97736004)(6506007)(8936002)(3846002)(54906003)(2351001)(5660300001)(8676002)(81166006)(9686003)(81156014)(7696005)(55016002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR07MB4025;H:DB7PR07MB4665.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: virtuosys.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: UKkYIj4I2GETrPG6l9ErGlf8JXAzutWiXMoei/O6l7LdbV0z0V5IsI7VZwhrzXFTypnK4PZ7NqKUlIFbVR5Xa6kQLhmJTfI/WsFdtoLcWUxBxQZ+JZOn54up/U0ff2ILIbpxP2JrHfAK7DxllEpdsboFx535HvqYmM2iACskGhIZj2SuoaHRCWN8cAKqwQs2fcoF08MKNV/8+uLMQBT5mwJ0rqpI9qIeBcKCWzFW7kIJg7eshe0RTXgGEAzhCckQfPH45FQI/W1HqXAlYEZ7J0zhWIROA9JFbafmeN6eE2sqytZaE/LUoyiA01hsRxsZMpF8eiENiD8JQji4inMmx9BYLjo4R6hnorRLyADNPPk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuosys.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8123eb2-f9e1-48ec-07f6-08d63512e3db
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2018 16:00:56.6338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7b6123fa-46d6-43d5-8ae7-6aa4717110ba
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR07MB4025
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Good afternoon

I am interested in contributing to the development and testing of FTM using=
 ath10k devices.
Currently I am running a standard 4.14 kernel and have QCA988X (WLE600VX) a=
nd QCA9984 (WLE1216V5) devices.
My QCA9984 is running 10.4.3 firmware and the QCA988X is using 10.2.4.70.66=
.

Would it be possible for me to build/test some of the FTM changes, or is th=
is very much a work in progress and not useable by other people.
I can see that FTM spans a number of components:
  Userpace (hostapd, wpa_supplicant)
  cfg80211 (nl80211)
  mac80211
  ath10k driver.
I would also be interested if it was possible to test FTM from a test harne=
ss around the ath10k?

Pradeep, Johannes, apologies for e-mailing you directly but from the e-mail=
 exchanges it looks like you are experts on this subject matter.

Regards
Arthur


