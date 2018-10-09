Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13CEBC00449
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 02:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3D8C213A2
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 02:43:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A3D8C213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbeJIJ5m (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 05:57:42 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:53838 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbeJIJ5m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 05:57:42 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w992gW7t011914, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w992gW7t011914
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 9 Oct 2018 10:42:32 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Tue, 9 Oct 2018
 10:42:32 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC v3 08/12] rtw88: debug files
Thread-Topic: [RFC v3 08/12] rtw88: debug files
Thread-Index: AQHUXwroUCwuva2cvE+MjaIlByUtB6UWNShQ
Date:   Tue, 9 Oct 2018 02:42:31 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D172C6EE@RTITMBSVM01.realtek.com.tw>
References: <1538565659-29530-1-git-send-email-yhchuang@realtek.com>
         <1538565659-29530-9-git-send-email-yhchuang@realtek.com>
         (sfid-20181003_132144_335644_0E0FC8A8)
 <201810081446.w98EkN0r017815@rtits1.realtek.com.tw>
In-Reply-To: <201810081446.w98EkN0r017815@rtits1.realtek.com.tw>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.123]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9oYW5uZXMgQmVyZyBb
bWFpbHRvOmpvaGFubmVzQHNpcHNvbHV0aW9ucy5uZXRdDQo+IFNlbnQ6IE1vbmRheSwgT2N0b2Jl
ciAwOCwgMjAxOCA5OjI5IFBNDQo+IFRvOiBUb255IENodWFuZzsga3ZhbG9AY29kZWF1cm9yYS5v
cmcNCj4gQ2M6IExhcnJ5LkZpbmdlckBsd2Zpbmdlci5uZXQ7IFBrc2hpaDsgQW5keSBIdWFuZzsg
c2dydXN6a2FAcmVkaGF0LmNvbTsNCj4gbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnDQo+
IFN1YmplY3Q6IFJlOiBbUkZDIHYzIDA4LzEyXSBydHc4ODogZGVidWcgZmlsZXMNCj4gDQo+IE9u
IFdlZCwgMjAxOC0xMC0wMyBhdCAxOToyMCArMDgwMCwgeWhjaHVhbmdAcmVhbHRlay5jb20gd3Jv
dGU6DQo+ID4NCj4gPiArc3RhdGljIHN0cnVjdCBkZW50cnkgKmRlYnVnZnNfdG9wZGlyOw0KPiA+
ICsNCj4gPiArdm9pZCBydHdfZGVidWdmc19pbml0KHN0cnVjdCBydHdfZGV2ICpydHdkZXYpDQo+
ID4gK3sNCj4gPiArCWRlYnVnZnNfdG9wZGlyID0gZGVidWdmc19jcmVhdGVfZGlyKCJydHc4OCIs
IE5VTEwpOw0KPiANCj4gWW91IHJlYWxseSBjYW4ndCBkbyB0aGlzLCBhbGwgaGVsbCB3aWxsIGJy
ZWFrIGxvc2UgaWYgeW91IGV2ZXIgcGx1ZyB0d28NCj4gZGV2aWNlcyBpbnRvIHRoZSBzYW1lIHN5
c3RlbS4NCj4gDQo+IGpvaGFubmVzDQo+IA0KDQpSaWdodCwgc2hvdWxkIHB1dCBpdCB1bmRlciBy
dHdkZXYuDQoNCllhbi1Ic3VhbiBDaHVhbmcNCg==
