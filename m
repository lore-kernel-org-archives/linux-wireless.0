Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A6AAC43143
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 19:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D428D20685
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 19:10:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=bowerswilkins.com header.i=@bowerswilkins.com header.b="jQwevELd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D428D20685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bowerswilkins.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbeI2Bff (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 21:35:35 -0400
Received: from mail-eopbgr30072.outbound.protection.outlook.com ([40.107.3.72]:58271
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726335AbeI2Bff (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 21:35:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bowerswilkins.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JMf8Tg9K9vXG5gURkgpZvZQbdrAxg5bUudL5ZUsobcA=;
 b=jQwevELdQTkgN9Y5EbBZRE47yTZVWaxDHbTCD3rILY1dY81ANfYCfqs/Mo8gQdFxHnzM5CwZJI8J6kc7KouSqaTcaXblSjdQ29RwLOoZ3vj23h18sW8FNHro7zvVrVw4yTmy+ZXecKcUjxRuEiUfVlwrnvNToDaKAY7Rk05inVE=
Received: from DB7PR04MB4154.eurprd04.prod.outlook.com (52.135.130.151) by
 DB7PR04MB4266.eurprd04.prod.outlook.com (52.135.131.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1185.20; Fri, 28 Sep 2018 19:10:21 +0000
Received: from DB7PR04MB4154.eurprd04.prod.outlook.com
 ([fe80::8c5:db28:1dc9:8ec2]) by DB7PR04MB4154.eurprd04.prod.outlook.com
 ([fe80::8c5:db28:1dc9:8ec2%2]) with mapi id 15.20.1164.024; Fri, 28 Sep 2018
 19:10:21 +0000
From:   Peter Oh <peter.oh@bowerswilkins.com>
To:     Anilkumar Kolli <akolli@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v4 2/2] ath10k: report tx rate using
 ieee80211_tx_rate_update()
Thread-Topic: [RFC v4 2/2] ath10k: report tx rate using
 ieee80211_tx_rate_update()
Thread-Index: AQHUU9VMrxQ2yQaQPkmpdQCnu/BzkKUGFhuA
Date:   Fri, 28 Sep 2018 19:10:21 +0000
Message-ID: <caada2d5-2e0e-8a5a-cab9-5078654ab5a4@bowerswilkins.com>
References: <1537773000-2587-1-git-send-email-akolli@codeaurora.org>
 <1537773000-2587-3-git-send-email-akolli@codeaurora.org>
In-Reply-To: <1537773000-2587-3-git-send-email-akolli@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM6PR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:5:80::14) To DB7PR04MB4154.eurprd04.prod.outlook.com
 (2603:10a6:5:26::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peter.oh@bowerswilkins.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2001:1900:2200:85:d6be:d9ff:fe0e:a5ac]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DB7PR04MB4266;6:qAiBp/U1eVau2MYcltDQxUGdEJvKsIhXO2/RXbKIT9E0ReTVDk3zfnvWmiQvxC8Sy8wbjRIM9OeaarE/iK8Aw/KOfODATKFlxnVumUeA2W2VBh6FDgLTUxi7CJzeMOKFewebgpoJWeJyYh0XV4Q5cbw0ksDimyaDCbXZpV+ruBu3he0/p5McDY9Zsa4UO5gN/07Gc8OspQKuFxSy4BZTSeq1IyNr8QpG1RsrQ2zjAUavoOu+pdrvQN9GrizpisTsHdHmPxwFYE44JuCDoGOtoQOPLG9uSGESWw3N6EY483ZshECmp1ItWzx96NQPmubG0NWvac7vqXCTbp8NbBMBP9VFuMmEZH7cg3uCtnlVgBvZh9+8iQ0Y8HFZrqwSPda8NIMigEFCJkdjqoTY3qPUJfsJ5QMkR0e0HiGUw9Lc6KSju5x/kTI4IU8XWx8SMZ2uk+LyQDtJoLRqljAAae9vDg==;5:6DsJlN6ZnnJWO/UhXUK8vP6BNVwf/El4rEjqXMDf3xLlP7RmhiQdISL0k9SJVOMhdspdOrilR/DFSoayL45uSKpVHyXSlS3ZnMirF2BlFEZ2HLXSeBH6XCrq55k9URhoEQyeWdeJiaRwWVEi8hl0n6p+NlPHt6gxhY9Ay9pwU7U=;7:WeiNYfG1b768qBvn9IBunwl20/Z5ny9dialLAknuZApNiB+yrCVWzDpZ4vCEQ2KCejPxJs7ajYFOMbwktkfUiaTMpLqsAhS068k+TPgIotYAlz7LQLY6TqnRIFBKelZ2ZD9Jt+iI2m4lHzZjN5xDpussOfe2zQgkbH/5W5RcNa27LLogfBySYkj+kMaeFVGntwMfP+fjHJG0ikoVMyJBtQ9U8wiNCmxodNm4IthFZds6fMP40NIhE1VG8w8pIjOJ
x-ms-office365-filtering-correlation-id: 69dd8301-23e5-4f16-0d6c-08d62576094a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DB7PR04MB4266;
x-ms-traffictypediagnostic: DB7PR04MB4266:
x-microsoft-antispam-prvs: <DB7PR04MB4266D5AE8BB6066670A0F76599EC0@DB7PR04MB4266.eurprd04.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(201708071742011)(7699051);SRVR:DB7PR04MB4266;BCL:0;PCL:0;RULEID:;SRVR:DB7PR04MB4266;
x-forefront-prvs: 0809C12563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(396003)(366004)(376002)(39850400004)(199004)(189003)(186003)(5660300001)(102836004)(106356001)(53936002)(52116002)(76176011)(53546011)(6506007)(386003)(476003)(25786009)(31696002)(6486002)(68736007)(99286004)(2616005)(15760500003)(44832011)(486006)(446003)(11346002)(478600001)(86362001)(229853002)(7736002)(6512007)(110136005)(105586002)(305945005)(316002)(46003)(8936002)(6436002)(36756003)(31686004)(81166006)(8676002)(81156014)(14454004)(6116002)(97736004)(71200400001)(6246003)(2900100001)(2906002)(2501003)(5250100002)(71190400001)(256004)(34290500001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4266;H:DB7PR04MB4154.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: bowerswilkins.com does not
 designate permitted sender hosts)
x-microsoft-antispam-message-info: 2mUvRwKvJzf46hxvdK4J2KBw8mA4yNZ+PCS4/o3tLW4OtyT9/kr6EHBb4DDTP8uLTkrculCeaW07sZUSKdrg1NW+PYyCC04HfYZUUGfOp5snUMLLHycBPjioYogwcXDXIZGqOLioUEkaWVAcP/IOpMYTHepN0M/s6e2a23BpNvD9OGecEqQk/Cmi6DewDnbZht7VpGQpbMvVNNm9VbkGmoUKuB8V5rVMkUhiEmGfg+Bd+GbQFiBYfoDl9CUDiBPHa1LggpC0uy/k5v8gHIPWi5hu0fT6jkEveUf2msScOmk4PU3NKOw0PyLppQZVA4Kv5bp7FTujEmM/8wDlQdLcq+KQZ0XqVys+mQgusZ/D/Cw=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <6B9653BB3E245D47BE0DB3CF46012025@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bowerswilkins.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69dd8301-23e5-4f16-0d6c-08d62576094a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2018 19:10:21.6095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a75a45bb-4772-448f-a2c6-9d2413d86410
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4266
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDA5LzI0LzIwMTggMTI6MTAgQU0sIEFuaWxrdW1hciBLb2xsaSB3cm90ZToNCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvaHR0X3J4LmMgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBrL2h0dF9yeC5jDQo+IGluZGV4IGYyNDA1MjU4YTZk
My4uMzU1YzM5YTA0ODZjIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgv
YXRoMTBrL2h0dF9yeC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsv
aHR0X3J4LmMNCj4gQEAgLTI3NTMsOCArMjc1MywxMSBAQCBzdGF0aWMgaW5saW5lIGludCBhdGgx
MGtfZ2V0X2xlZ2FjeV9yYXRlX2lkeChzdHJ1Y3QgYXRoMTBrICphciwgdTggcmF0ZSkNCj4gICAJ
CQkJc3RydWN0IGF0aDEwa19wZXJfcGVlcl90eF9zdGF0cyAqcGVlcl9zdGF0cykNCj4gICB7DQo+
ICAgCXN0cnVjdCBhdGgxMGtfc3RhICphcnN0YSA9IChzdHJ1Y3QgYXRoMTBrX3N0YSAqKXN0YS0+
ZHJ2X3ByaXY7DQo+IC0JdTggcmF0ZSA9IDAsIHJhdGVfaWR4ID0gMCwgc2dpOw0KPiArCXN0cnVj
dCBpZWVlODAyMTFfY2hhbmN0eF9jb25mICpjb25mID0gTlVMTDsNCj4gICAJc3RydWN0IHJhdGVf
aW5mbyB0eHJhdGU7DQo+ICsJdTggcmF0ZSA9IDAsIHNnaTsNCj4gKwlpbnQgcmF0ZV9pZHggPSAw
Ow0KdHlwZSBtaXNtYXRjaC4gYXRoMTBrX2FjY3VtdWxhdGVfcGVyX3BlZXJfdHhfc3RhdHMoKSB0
YWtlIHU4IHJhdGVfaWR4LCANCmJ1dCB5b3UncmUgcGFzc2luZyBpbnQuDQoNCg==
