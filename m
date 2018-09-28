Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF18C43143
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 19:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD551206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 19:17:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=bowerswilkins.com header.i=@bowerswilkins.com header.b="ZENTaP/p"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD551206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bowerswilkins.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbeI2Bmj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 21:42:39 -0400
Received: from mail-eopbgr20042.outbound.protection.outlook.com ([40.107.2.42]:24785
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725906AbeI2Bmj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 21:42:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bowerswilkins.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+Uj9gKdCCb8GqCRxne1C+GjYFSf3rEbuY6OR2YC0B0=;
 b=ZENTaP/peUPYMy6Wa/malx1Q/RAQnd9idcnbhdVbJK9gsXcLIP87mG3r7EP/ri3ExIoYWIPoECSREn8k0qAMg6tuDBYFPn5gQya0MpeAP3RtrA7BElnNzd3Gf/vcQ8h8QdXh2A2FiKOc3nLcypX68Rn98XGlfKFtQNsEtesbknQ=
Received: from DB7PR04MB4154.eurprd04.prod.outlook.com (52.135.130.151) by
 DB7PR04MB4282.eurprd04.prod.outlook.com (52.135.131.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1143.18; Fri, 28 Sep 2018 19:17:23 +0000
Received: from DB7PR04MB4154.eurprd04.prod.outlook.com
 ([fe80::8c5:db28:1dc9:8ec2]) by DB7PR04MB4154.eurprd04.prod.outlook.com
 ([fe80::8c5:db28:1dc9:8ec2%2]) with mapi id 15.20.1164.024; Fri, 28 Sep 2018
 19:17:23 +0000
From:   Peter Oh <peter.oh@bowerswilkins.com>
To:     Anilkumar Kolli <akolli@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v4 2/2] ath10k: report tx rate using
 ieee80211_tx_rate_update()
Thread-Topic: [RFC v4 2/2] ath10k: report tx rate using
 ieee80211_tx_rate_update()
Thread-Index: AQHUU9VMrxQ2yQaQPkmpdQCnu/BzkKUGFhuAgAAB9gA=
Date:   Fri, 28 Sep 2018 19:17:22 +0000
Message-ID: <1024b679-3748-681d-e0d4-badbc4987704@bowerswilkins.com>
References: <1537773000-2587-1-git-send-email-akolli@codeaurora.org>
 <1537773000-2587-3-git-send-email-akolli@codeaurora.org>
 <caada2d5-2e0e-8a5a-cab9-5078654ab5a4@bowerswilkins.com>
In-Reply-To: <caada2d5-2e0e-8a5a-cab9-5078654ab5a4@bowerswilkins.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN6PR11CA0009.namprd11.prod.outlook.com
 (2603:10b6:405:2::19) To DB7PR04MB4154.eurprd04.prod.outlook.com
 (2603:10a6:5:26::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peter.oh@bowerswilkins.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2001:1900:2200:85:d6be:d9ff:fe0e:a5ac]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DB7PR04MB4282;6:RYxjCgzZw5HUb0W4m5QxovIMYKx9U0qDM7gWRhJ4U4dU8FoW/7PWOdpLxj8xN0GmtJb6f+ix8Sex5qpPwFGoHFpDlCs+sQxGbjMxkxEq1nUfKmtTEcqxPr4fBqBrJzArA31MXXt/HVrwzabQ4o39GKX/4LtnXtav2+eTuJo76uerFtFKXO0nf/dwNgsx3h+UzFSeLI8Oykj91HQoIK1BL1yPcvmSPMPTOZuEe7rcq8FFSm4pcF4yPLjZ0RyIc7tokm3mixiTbAT5ws05ByVQdb+VyxnXKYEJgVHWIl6D73RGlODRauE8lo+L5iADagwWpICAevr8uY0VHMC0KDnheYOgFIgleqe+1ntffnIbJiT/LES/EfRzDTvPSN+Jbq6sAxuL9zjwjwoQ3Sv2xjV7PT0Cb/AYXULj7pPEuJ+4zcIGAWAcpbGc6XbnmtOrkb7kNW587Qh8I/srXt9PrMJv+w==;5:PpfjU9lHlfKqEQLutIr7+7myf4n0Ld8yOURPM2sgCIxO+TCOXs/d0Qc6+GKrmm6t/1+OXbJBFPqDQBbIAx/CaNPJrTKESlOwD3jW2bf7I1g1YmXagdEqvkymCxaB7AFljxBLcXRLSgRWYQ+qc1SINYjPErQWZsSqsF5ELN6WFlI=;7:vTXxOKeh0i7hvwJ+gOcrkXdZoAglKAOqbXf1Ja1eNhiShv01NUvULAxUQBMzCC2HVETE0ME+UW5vUMr30RMyMQSb1+HR9AxI7qlsnBK/JjdJNQzVpjjOSuvH3clXzudY7dEl9iPviO9jMHb5VmxuuxNVkAPLttqj+591dgY0I5uO8A9/gAobsDb42efN2egbE2Bv8K+5RQ+T3bZ5uiBrnzSpdZnxieVKfEPzbOfa5DOlIb6W9c2A3nDdW1HpUVZx
x-ms-office365-filtering-correlation-id: b6cfbd0f-a3a0-4723-3f48-08d625770481
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DB7PR04MB4282;
x-ms-traffictypediagnostic: DB7PR04MB4282:
x-microsoft-antispam-prvs: <DB7PR04MB42823BA8D4A457E4F233FC6099EC0@DB7PR04MB4282.eurprd04.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(17755550239193);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(3231355)(944501410)(52105095)(3002001)(10201501046)(149066)(150057)(6041310)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(20161123560045)(201708071742011)(7699051);SRVR:DB7PR04MB4282;BCL:0;PCL:0;RULEID:;SRVR:DB7PR04MB4282;
x-forefront-prvs: 0809C12563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(396003)(39850400004)(366004)(346002)(189003)(199004)(25786009)(6116002)(386003)(46003)(53546011)(6506007)(446003)(11346002)(86362001)(8936002)(71200400001)(6512007)(305945005)(31696002)(71190400001)(81166006)(81156014)(8676002)(229853002)(14454004)(52116002)(76176011)(7736002)(97736004)(186003)(102836004)(99286004)(6486002)(486006)(256004)(2501003)(31686004)(68736007)(5250100002)(478600001)(2616005)(44832011)(2900100001)(476003)(15760500003)(5660300001)(316002)(6246003)(105586002)(53936002)(4326008)(34290500001)(36756003)(110136005)(106356001)(2906002)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4282;H:DB7PR04MB4154.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: bowerswilkins.com does not
 designate permitted sender hosts)
x-microsoft-antispam-message-info: xGAJMQqLoCDhqMF21dSEZav6lK/Q5FGGCF7JtKsFpgyYXb/4gJo2eb+f1CztkhHs7OWmcfnHWtT3TErHrVMmBuf5jtBOvX0hagIoiVnPHh1VQoLyKeGTfFOFdIHlW3vlsxBuwIRhb7w1vjo2C8EqdNq5sMdwG577Oldt78DBb2u5nAcPCLI7jv38MmXBxvHHfbRiD8tSaeU6+L/yljO93juL+ElZgPGMia/CM04nzfYdPs4tECXdxgSLchGlQkZ6LmtgttdOoLZG1G2/aJRuFg8hXqZsfUIFCB9ocrktpGm/ArpUtGQddIm28oyk/uLUVOHvOMzU2vwxumKoc1FcTljFckUqsFWRlTAcCoJBsWk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <DFB9023582C9A74C813A42EF816FC6FB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bowerswilkins.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6cfbd0f-a3a0-4723-3f48-08d625770481
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2018 19:17:22.9856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a75a45bb-4772-448f-a2c6-9d2413d86410
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4282
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCk9uIDA5LzI4LzIwMTggMTI6MTAgUE0sIFBldGVyIE9oIHdyb3RlOg0KPg0KPiBPbiAwOS8y
NC8yMDE4IDEyOjEwIEFNLCBBbmlsa3VtYXIgS29sbGkgd3JvdGU6DQo+PiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDEway9odHRfcnguYyBiL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2F0aC9hdGgxMGsvaHR0X3J4LmMNCj4+IGluZGV4IGYyNDA1MjU4YTZkMy4uMzU1YzM5
YTA0ODZjIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDEway9o
dHRfcnguYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDEway9odHRfcngu
Yw0KPj4gQEAgLTI3NTMsOCArMjc1MywxMSBAQCBzdGF0aWMgaW5saW5lIGludCBhdGgxMGtfZ2V0
X2xlZ2FjeV9yYXRlX2lkeChzdHJ1Y3QgYXRoMTBrICphciwgdTggcmF0ZSkNCj4+ICAgIAkJCQlz
dHJ1Y3QgYXRoMTBrX3Blcl9wZWVyX3R4X3N0YXRzICpwZWVyX3N0YXRzKQ0KPj4gICAgew0KPj4g
ICAgCXN0cnVjdCBhdGgxMGtfc3RhICphcnN0YSA9IChzdHJ1Y3QgYXRoMTBrX3N0YSAqKXN0YS0+
ZHJ2X3ByaXY7DQo+PiAtCXU4IHJhdGUgPSAwLCByYXRlX2lkeCA9IDAsIHNnaTsNCj4+ICsJc3Ry
dWN0IGllZWU4MDIxMV9jaGFuY3R4X2NvbmYgKmNvbmYgPSBOVUxMOw0KPj4gICAgCXN0cnVjdCBy
YXRlX2luZm8gdHhyYXRlOw0KPj4gKwl1OCByYXRlID0gMCwgc2dpOw0KPj4gKwlpbnQgcmF0ZV9p
ZHggPSAwOw0KPiB0eXBlIG1pc21hdGNoLiBhdGgxMGtfYWNjdW11bGF0ZV9wZXJfcGVlcl90eF9z
dGF0cygpIHRha2UgdTggcmF0ZV9pZHgsDQo+IGJ1dCB5b3UncmUgcGFzc2luZyBpbnQuDQpJdCBs
b29rcyBsaWtlIHlvdSBiZXR0ZXIgY2hhbmdlIHJldHVybiB0eXBlIG9mIA0KYXRoMTBrX2dldF9s
ZWdhY3lfcmF0ZV9pZHgoKSBmcm9tIGludCB0byB1OCBieSB1c2luZyB1OCBpOyBpbnN0ZWFkIG9m
IA0KaW50IGkgaW5zaWRlIG9mIGF0aDEwa19nZXRfbGVnYWN5X3JhdGVfaWR4KCkgYW5kIGtlZXAg
dXNpbmcgcmF0ZV9pZHggYXMgDQp1OCBoZXJlLg0KDQpQZXRlcg0K
