Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D3DC04EB8
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 02:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2867A2064D
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 02:31:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="akhqfa0V"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2867A2064D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729639AbeLKCbD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Dec 2018 21:31:03 -0500
Received: from mail-eopbgr750080.outbound.protection.outlook.com ([40.107.75.80]:11624
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727485AbeLKCbC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Dec 2018 21:31:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHKEjfLS3Aw2rcX3+IO1ewcW7WCpmVq+FuY7IiSpNIg=;
 b=akhqfa0V5VfCRMhA//3LBvm7OrHYTF5in+O3uJc3A5zuVrXxwfqS5sxA4F+lqjoVejwv4a5+tKpdMV9B+tHbS6K3Nt6lqKwn4bYKj0/10PoHWZ6L7Bijwxc4zr0+2LRggAZS3HeifvaQqypAP/+zAlD/ReAvTFtiVY5W8PP+BBs=
Received: from MWHPR05MB3326.namprd05.prod.outlook.com (10.174.174.165) by
 MWHPR05MB3277.namprd05.prod.outlook.com (10.173.230.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1425.11; Tue, 11 Dec 2018 02:30:59 +0000
Received: from MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::d042:7e53:9462:728f]) by MWHPR05MB3326.namprd05.prod.outlook.com
 ([fe80::d042:7e53:9462:728f%4]) with mapi id 15.20.1425.016; Tue, 11 Dec 2018
 02:30:58 +0000
From:   Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
To:     "wireless-regdb@lists.infradead.org" 
        <wireless-regdb@lists.infradead.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Tx power for slave devices in ETSI DFS region
Thread-Topic: Tx power for slave devices in ETSI DFS region
Thread-Index: AQHUkPmMGOyyQqBw8E+EVymYPKdnJw==
Date:   Tue, 11 Dec 2018 02:30:58 +0000
Message-ID: <423eaa39-fc06-6a5a-a8fd-5e15d503dff5@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR02CA0068.namprd02.prod.outlook.com
 (2603:10b6:a03:54::45) To MWHPR05MB3326.namprd05.prod.outlook.com
 (2603:10b6:301:3d::37)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.131.200.68]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;MWHPR05MB3277;6:dhPQADDkTWHt0+KqCChZTtd2qWNkWlPI38I154j75jArdTTClPT3xBqzSLt9q1Yu6jkND6ieua90O1PuPlRl0nKQhSua5TyslRqXobpQBMHi4dzeGbPUkufYcAp8QB2rnvbyyrbFSBlFvgHDjhb+unZ94JoDnAM5gLdEylgVqpwiL4LhjXcKAPG4cc0smxiHeOI6mx68Et9QaZ6J4nNwip7yNPN5zjxOMaZu5Rnk7XxPepPGut1UER+3EYHAu/1HawK/Hh/nZX7TSbyCWgVlhVVDdwbz/nO9QEhOQ9+uytwnYZRIIfVkTmLBtCLl1es1S9yKi8/5RDT0EdbXCtrPXZTKxtJQuVfvE2Ax2bTPPSlj3sZ1U4fWh+1ywNiAPXoCClFZ24dUIR/i/NAk1DcK6HA5nLmq5vn4qkkKHyMqXpNzxj4Slq2HkuMNXt5W1QbjPyW357fuYm+tmrtq/b0vzw==;5:fiG9wj8B4ZuzTT294JKikzKkLhcNC5im9NfLOmutA/zzz41lXdIHP3ahp2IU9Ut+idCj8cOU4MZOqoB8djw1pvGu76AYrSzGaTJgEJNqjaVPlPCXD0QZsfpvegnxfoUIRI3Z5xfHoNkC6hWXThxaLlgcXxstjVAJXTFfVbjM1J4=;7:bUnX3e0npigux5tLdW0NVFLPM1n+SwMfWTvXkrlQsRqYi3tlPICa8g9+WBFyocOxrG2Q3+XDuSauIIEWqPG/u/15B4UgtpmfNj80X1+nm1TDflhJFPbdyD8DoM+TTSKpOAtUUT6bLUn3VjOM9tkrJA==
x-ms-office365-filtering-correlation-id: 2b0f6636-c64a-4509-75d9-08d65f10af41
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:MWHPR05MB3277;
x-ms-traffictypediagnostic: MWHPR05MB3277:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=igor.mitsyanko.os@quantenna.com; 
x-microsoft-antispam-prvs: <MWHPR05MB32775446729F264676595D24B0A60@MWHPR05MB3277.namprd05.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(3230017)(999002)(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231472)(944501520)(52105112)(148016)(149066)(150057)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123564045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:MWHPR05MB3277;BCL:0;PCL:0;RULEID:;SRVR:MWHPR05MB3277;
x-forefront-prvs: 08831F51DC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(136003)(396003)(39850400004)(376002)(189003)(199004)(4326008)(102836004)(256004)(14444005)(6506007)(386003)(26005)(186003)(105586002)(217873002)(53936002)(7736002)(106356001)(305945005)(68736007)(31686004)(2351001)(966005)(25786009)(36756003)(478600001)(5660300001)(86362001)(52116002)(31696002)(99286004)(66066001)(2906002)(6916009)(2501003)(14454004)(6486002)(71200400001)(71190400001)(6436002)(97736004)(3846002)(6116002)(316002)(5640700003)(6512007)(486006)(8676002)(81156014)(6306002)(476003)(8936002)(2616005)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3277;H:MWHPR05MB3326.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: Fv8Qrj46bWN9OUCNKxsCyw7rOhE/JVI9GhN0baaDmxxGZ8pYbV60bbEcBHjLLCAECB5j0vHNngsqKBvfXpHBQbd6sL4CblEbm0SihcdpzxZ6zFbIf4ScuFQwhGB4t4WjUWO7fxBNDxpIJcGW3/BaVp5qY+zDB3HN5fWnzzNHi9Ed0enlqn4fp8RrwWrWklhGEMWzAjLYy7ovCZj+mQH+M+OHE89VukCsjilkK8oSto/9gTsqHY1HEmEwryKNHDuGs30m4rJrJyMg+pwApykFn4tMn/UPcVBEkZByDAHD6DMFBm/NmQu+9rr9USOo5F8R
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <C1AB080D174B3C4BA18BDD7A1616AB46@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b0f6636-c64a-4509-75d9-08d65f10af41
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2018 02:30:58.7334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3277
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGVsbG8sDQoNCmFjY29yZGluZyB0byBFVFNJIA0KaHR0cHM6Ly93d3cuZXRzaS5vcmcvZGVsaXZl
ci9ldHNpX2VuLzMwMTgwMF8zMDE4OTkvMzAxODkzLzAyLjAxLjAxXzYwL2VuXzMwMTg5M3YwMjAx
MDFwLnBkZg0Kc2VjdGlvbiA0LjIuMy4yLjIsIHRhYmxlIDINCk5vdGUgMyBzdGF0ZXM6DQogPlNs
YXZlIGRldmljZXMgd2l0aG91dCBhIFJhZGFyIEludGVyZmVyZW5jZSBEZXRlY3Rpb24gZnVuY3Rp
b24gc2hhbGwgDQogPmNvbXBseSB3aXRoIHRoZSBsaW1pdHMgZm9yIHRoZSBmcmVxdWVuY3kgcmFu
Z2UgNSAyNTAgTUh6IHRvIDUgMzUwIE1Iei4NCg0KQW5kIFR4IHBvd2VyIGxpbWl0cyBhcmUgZGVm
aW5lZCBhcyBmb2xsb3dpbmc6DQo1MTUwIHRvIDUzNTA6IDIwIGRibQ0KNTQ3MCB0byA1NzI1OiAy
NyBkYm0NCg0KV2hpY2ggbWVhbnMgdGhhdCBpZiBTVEEgZGV2aWNlIGNhbiBub3QgZG8gcmFkYXIg
ZGV0ZWN0aW9uLCBpdCBtdXN0IHVzZSANCjIwZGJtIFR4IHBvd2VycyBvbiBhbGwgY2hhbm5lbHMg
KGNhbiBub3QgdXNlIDI3IGRibSBsaW1pdCkuDQoNCg0KTG9va2luZyBhdCByZWdkYiANCmh0dHBz
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3Nmb3JzaGVlL3dpcmVs
ZXNzLXJlZ2RiLmdpdC90cmVlL2RiLnR4dCwgDQpwb3dlciBsaW1pdCBmb3IgZnJlcXVlbmN5IHJh
bmdlIDU0NzAgdG8gNTcyNSBpcyBkZWZpbmVkIGF0IDI3IGRibS4NCg0KDQpRdWVzdGlvbiBpczog
ZG9lcyB3aXJlbGVzcyBjb3JlIGFzc3VtZXMgdGhhdCBlYWNoIGRldmljZSBjYW4gZG8gcmFkYXIg
DQpkZXRlY3Rpb24gaW4gc2xhdmUgbW9kZXMgKGVnIGFjdGluZyBhcyBhIFNUQSkgYW5kIGl0IGlz
IGVuYWJsZWQgYnkgDQpkZWZhdWx0PyBJIGNvdWxkbid0IGZpbmQgYW55IGxvZ2ljIGluIGtlcm5l
bCB3aGljaCB3b3VsZCBsaW1pdCAyNyBkYm0gDQpwb3dlciB0byAyMCBmb3IgU1RBIGRldmljZXMu
DQo=
