Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE20C5ACC6
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 16:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 825AE21470
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 16:50:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=appriver3651002525.onmicrosoft.com header.i=@appriver3651002525.onmicrosoft.com header.b="RKdwY9eS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 825AE21470
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=veea.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbeJQAlv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 20:41:51 -0400
Received: from mail-by2nam01on0044.outbound.protection.outlook.com ([104.47.34.44]:22848
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727272AbeJQAlu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 20:41:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=appriver3651002525.onmicrosoft.com; s=selector1-veea-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5BXm9HzlEAqbi9urGXkZJysYwtSk6kZSDKQM+MabTj0=;
 b=RKdwY9eSO2mTugw+6T553bODfeGaSoxh4RNE43y3bXq+vI7SzwrDSlgwJKp1t1hi/zJbzGEF7WWUdDr6y4WHQF3AkXMikBw24cDyfbBAc2gP/nFHDWxhYvtSfyw6EmQrpti1ma2V32FcIsVUtiWCJK25AtX0NtgRjTyQq00EmFI=
Received: from DM6PR04MB4059.namprd04.prod.outlook.com (20.176.87.148) by
 DM6PR04MB5003.namprd04.prod.outlook.com (20.176.109.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1250.20; Tue, 16 Oct 2018 16:50:32 +0000
Received: from DM6PR04MB4059.namprd04.prod.outlook.com
 ([fe80::e50f:8171:cba0:82e0]) by DM6PR04MB4059.namprd04.prod.outlook.com
 ([fe80::e50f:8171:cba0:82e0%5]) with mapi id 15.20.1228.027; Tue, 16 Oct 2018
 16:50:32 +0000
From:   Adam Cottrel <adam.cottrel@veea.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Large number of crda failures
Thread-Topic: Large number of crda failures
Thread-Index: AdRlb5iQur/SKVJqRLukugrqJU4hCQAAJuMw
Date:   Tue, 16 Oct 2018 16:50:32 +0000
Message-ID: <DM6PR04MB40596FE840A2426E81FB22A2F2FE0@DM6PR04MB4059.namprd04.prod.outlook.com>
References: <DM6PR04MB40597C0C909A0EA209361F75F2FE0@DM6PR04MB4059.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB40597C0C909A0EA209361F75F2FE0@DM6PR04MB4059.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=adam.cottrel@veea.com; 
x-originating-ip: [217.138.78.198]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR04MB5003;6:FKt1gCbHRS04XnmRNFKSFGJybrEx7JnkxBmnt8B3BWeJS/7wneV2WoiHZLIf3mFYzUi+10IvPAjhjCli4hiuVupbbSMVHMayMXNdRYTIV41Nl9u9evBbElNlEaDvKR/s7fbrN0rRta6YZb3xQ4AGBaqPWg+tGNOT2ubrGO9EQShUCWQznQTrRmOjugXJowhwAKFTDc+QVa+MRVaXy4QzuKLFTES6kWlpiuRN7SohyIDOGVFjd6zUz5FHvJ+0IZDOU/NjjL12lZHBOevihll3CGFQ8DnKXazJG/2dLuCv9lwtv0BIjfPpmMNngW7AmZpXQR/wBhSv2RlnYkAFO9avqiXg+fmHa84HXt0O7//woRgN7Rft5uIxLZMjGpvx0UjfBIgh69XmyelSuXFoM9sRO2g0PwWph1+HnKOiUZNzwBfVk9PWkoPTPwsXNrsRuUZirk9pgOslxoO8bDoa201uZQ==;5:J7C2wtFzJasOgq5twFnB519+6xjC60FzC1y8VsyD74QPwT2/EBaSMee+BeYW2o+yNbhy73Q2gIAE4pmVLXmGdGqVErJXGNXVoHz5VMdIQrqHHvKsp6tGQlg8mdFHqMpyD+dIhDTq6NX0RRR4P4ENlcUGJ6VGyjiRoPC9mvlca+I=;7:o1iDtjDxlrGLt8fw/G3gPJITDgy8g+IToauMVlNTp4jGs44j6RPkezyZf3cxuPPgHSSuND7py9vbWvc+JPekV/5yd/Wp4VuXMSY2Rnl5atVms4Y6vQ7iL681iXicy0qKfV1oDtW2yFHmqfwq7woIo1EzsxwFTqSGqs9kjYFqXqDtp0WwuyHnYXPMf0MniebcMxa7OzmLEPSWYOJHAI29rImthbdINcDaF/3hYRJSgmLsty6PG5bSO57HiNsrklJN
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 0cb5f3fd-a607-4fe5-a58f-08d633877cd4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(7021145)(8989299)(5600074)(711020)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(2017052603328)(7153060)(7193020);SRVR:DM6PR04MB5003;
x-ms-traffictypediagnostic: DM6PR04MB5003:
x-microsoft-antispam-prvs: <DM6PR04MB50036C0CC30D5DD9FFE572C6F2FE0@DM6PR04MB5003.namprd04.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(3002001)(10201501046)(93006095)(93001095)(149066)(150057)(6041310)(20161123560045)(2016111802025)(20161123558120)(20161123564045)(20161123562045)(6043046)(201708071742011)(7699051)(76991067);SRVR:DM6PR04MB5003;BCL:0;PCL:0;RULEID:;SRVR:DM6PR04MB5003;
x-forefront-prvs: 0827D7ACB9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(366004)(376002)(39840400004)(136003)(189003)(199004)(93156006)(81156014)(6916009)(81166006)(8676002)(2900100001)(97736004)(305945005)(7736002)(2501003)(33656002)(74316002)(76176011)(5660300001)(256004)(99286004)(7696005)(66066001)(68736007)(71190400001)(71200400001)(446003)(5250100002)(102836004)(11346002)(44832011)(25786009)(486006)(476003)(106356001)(105586002)(2940100002)(3846002)(6116002)(86362001)(9686003)(53936002)(508600001)(6436002)(8936002)(26005)(14454004)(186003)(2351001)(6506007)(2906002)(316002)(55016002)(5640700003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR04MB5003;H:DM6PR04MB4059.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: veea.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: HC3SIe0R9Y8kG8lwYQjXz6wjsqIlc3R5cxorYLUk5cnRmVXekRpbg5O+Ut0DsGx9BSfU4o6Tlc3kWHGgD2ZnkzNqLz1lGMntHUejplLtdJmvMfQTPj1Sl1sLvgNEk9hpX1v4PvzU63lCYXbMHTP5jGjwwshm5ynfzOpHxBP03/jgm3kf5rcRsqPxWQZH9wZsvOY9BNvSLmN/zFfqSBIBvYyzwidLuT3X+PCZR0DCjVjtrHkRpWOO7b9wXE+l+Lp5Law6Perf/+AvlqOD2hkh1mHE26B+QsJAAN0uN0KjKECzm5Z2ncChprbdKKnw5ZJJp7dzjvFbdHozM8PfaZvGLv2vXya3VHKFJN2L7eu1OTA=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: veea.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cb5f3fd-a607-4fe5-a58f-08d633877cd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2018 16:50:32.6275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c2b413f9-36a4-4dff-917c-a42674ced891
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5003
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGksDQoNCk9uIHN0YXJ0IHVwIEkgYW0gZ2V0dGluZyBhIGxhcmdlIG51bWJlciBvZiBlcnJvciBm
YXVsdHMgcmVwb3J0ZWQgd2l0aCBDUkRBOi0NCuKeoiBpZXMwNjAwMTMzIHN5c3RlbWQtdWRldmRb
Mzk0OV06IFByb2Nlc3MgJy9zYmluL2NyZGEnIGZhaWxlZCB3aXRoIGV4aXQgY29kZSAyMzQNClR5
cGljYWxseSwgb3ZlciA1MCBsaW5lcyBhcmUgcmVwb3J0ZWQgdG8gdGhlIHN5c2xvZ3MNCg0KSG93
ZXZlciwgb25jZSB0aGUgc3lzdGVtIGhhcyBmdWxseSBzdGFydGVkLCBJIGRvIG5vdCBnZXQgYW55
IGlzc3VlcyB3aXRoIHJ1bm5pbmc6LQ0K4p6iIGl3IHJlZyBzZXQgWFgNCg0KVGhlc2UgZXJyb3Jz
IGFyZSBkb3VibGluZyB0aGUgYm9vdCB0aW1lIGZvciBMaW51eC4gTXkga2VybmVsIGlzIDQuMTQu
NCBhbmQgSSBhbSBydW5uaW5nIGEgRGViaWFuIGJhc2UuDQoNClBsZWFzZSBjYW4gc29tZW9uZSBh
ZHZpc2Ugd2hhdCBpcyBnb2luZyB3cm9uZz8NCg0KQmVzdCwNCkFkYW0NCg==
