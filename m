Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554E9C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 07:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B5582080F
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 07:49:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="CS9shDTF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B5582080F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=ti.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbeLMHta (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 02:49:30 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:53860 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbeLMHt3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 02:49:29 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id wBD7nNhN092196;
        Thu, 13 Dec 2018 01:49:23 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1544687363;
        bh=jnr7uZ2j0DDrf55uCdtcDtvE8VC9vfCdL4rpK3lZ9as=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=CS9shDTFJlL3hHlxmiwXzMuHTVk4oahpZmsjenbD/UtE6QKx31b02vQ9h+utylzUh
         oWLjg7QTq2lPTGPFQRZ2k0XRh5rK8GeNypQj27fxrFJm6+JpD5dxoTzuzL9miioO9p
         sLoekp4TwBq8ec5LaJo0fGDNEVwgqRA5xq2+mTkU=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id wBD7nNgH115071
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Dec 2018 01:49:23 -0600
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Thu, 13
 Dec 2018 01:49:23 -0600
Received: from DFLE103.ent.ti.com ([fe80::7431:ea48:7659:dc14]) by
 DFLE103.ent.ti.com ([fe80::7431:ea48:7659:dc14%17]) with mapi id
 15.01.1591.008; Thu, 13 Dec 2018 01:49:23 -0600
From:   "Reizer, Eyal" <eyalr@ti.com>
To:     Ricardo Salveti <rsalveti@rsalveti.net>,
        Tony Lindgren <tony@atomide.com>
CC:     John Stultz <john.stultz@linaro.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "anders.roxell@linaro.org" <anders.roxell@linaro.org>
Subject: RE: [EXTERNAL] Re: wlcore getting stuck on hikey after the runtime PM
 autosuspend support change
Thread-Topic: [EXTERNAL] Re: wlcore getting stuck on hikey after the runtime
 PM autosuspend support change
Thread-Index: AQHUkbxvUowIl7JGdE2qw59YlHGbqKV6synggAEfrwCAAA7kAIAAaVEw
Date:   Thu, 13 Dec 2018 07:49:23 +0000
Message-ID: <9060b4655e064665a1812d9fae00f1ec@ti.com>
References: <20181211181944.GW39861@atomide.com>
 <CAHYQr0pk-WKM-aYR7ubM4GHx8PA82XP5ze9TW9WEJLzdO0f88A@mail.gmail.com>
 <20181211190128.GX39861@atomide.com>
 <CAHYQr0qc_Lav=1sEGcOmOykUftWRzd6+vis97eBpanEXzfUHaA@mail.gmail.com>
 <CALAqxLUVajBw_PkyhA0s=FhQQHWu1FBEMX+4oDTStRXr6L5Txw@mail.gmail.com>
 <20181211201221.GY39861@atomide.com>
 <CAHYQr0qffa_G2ZVnSsDfjqSgxuBBZB+8e6ZODpAWV_TMhqzFYg@mail.gmail.com>
 <CAHYQr0qhqce2QcwMLRMWnqhZTL4KzHKJLzt6tfCNLHUcEt9pyQ@mail.gmail.com>
 <20181212014556.GC39861@atomide.com>
 <c8625c42f04a4721b7efb7d7b6b3931c@ti.com>
 <20181212183116.GH39861@atomide.com>
 <CAHYQr0ojkf3CvFb_zuEK4Vuz1w-rm9Sb=+dk5BkqYkWoxy8+aQ@mail.gmail.com>
In-Reply-To: <CAHYQr0ojkf3CvFb_zuEK4Vuz1w-rm9Sb=+dk5BkqYkWoxy8+aQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.167.25.139]
x-exclaimer-md-config: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

PiA+ID4gSSBKdXN0IHRyaWVkIG9uIGFuIGF2YWlsYWJsZSBhbTMzNXgtZXZtIHVzaW5nIDQuMjAu
MC1yYzEgd2hpY2ggSSBiZWxpZXZlDQo+IGhhcyBhbGwgdGhlIHBhdGNoZXMgbWVyZ2VkIGFscmVh
ZHkuDQo+ID4gPiBJIGFtIHVzaW5nIHRoZSBzYW1lIHNjcmlwdCAgYW5kIG5vdCBzZWVpbmcgYW55
IGZhaWx1cmUgeWV0Lg0KPiA+ID4gU2VlIGJlbG93Og0KPiA+ID4NCj4gPiA+IHJvb3RAYW0zMzV4
LWV2bTovdXNyL3NoYXJlL3dsMTh4eCMgdW5hbWUgLXINCj4gPiA+IDQuMjAuMC1yYzEtMTEyODct
Z2Y0ODdjMDANCj4gPiA+IHJvb3RAYW0zMzV4LWV2bTovdXNyL3NoYXJlL3dsMTh4eCMNCj4gPiA+
IHJvb3RAYW0zMzV4LWV2bTovdXNyL3NoYXJlL3dsMTh4eCMNCj4gPiA+IHJvb3RAYW0zMzV4LWV2
bTovdXNyL3NoYXJlL3dsMTh4eCMNCj4gPiA+IHJvb3RAYW0zMzV4LWV2bTovdXNyL3NoYXJlL3ds
MTh4eCMNCj4gPiA+IHJvb3RAYW0zMzV4LWV2bTovdXNyL3NoYXJlL3dsMTh4eCMgd2hpbGUgdHJ1
ZTsgZG8gaWZjb25maWcgd2xhbjANCj4gZG93bjsgaWZjb25maWcgd2xhbjAgdXA7IGRvbmU7DQo+
ID4gPiBbMTM3ODc4Ni40OTExMDFdIHdsY29yZTogZG93bg0KPiA+ID4gWzEzNzg3ODcuMDkzMDA2
XSB3bGNvcmU6IFBIWSBmaXJtd2FyZSB2ZXJzaW9uOiBSZXYgOC4yLjAuMC4yNDINCj4gPiA+IFsx
Mzc4Nzg3LjE2ODUyM10gd2xjb3JlOiBmaXJtd2FyZSBib290ZWQgKFJldiA4LjkuMC4xLjc5KQ0K
PiA+ID4gWzEzNzg3ODcuMjE1ODk3XSBJUHY2OiBBRERSQ09ORihORVRERVZfVVApOiB3bGFuMDog
bGluayBpcyBub3QNCj4gcmVhZHkNCj4gPiAuLi4NCj4gPg0KPiA+IFllYWggSSB3YXMgc2VlaW5n
IHRoZSBzYW1lIHllc3RlcmRheSB3aGVuIEkgdHJpZWQgaXQuDQo+ID4NCj4gPiBDb3VsZCBpdCBi
ZSB0aGF0IHRoZXJlIG5lZWRzIHRvIGJlIGEgbGl0dGxlIG1zbGVlcCgpIGFmdGVyDQo+ID4gbG9h
ZGluZyB0aGUgZmlybXdhcmUgb24gc29tZSBwbGF0Zm9ybXMgYW5kIGJlZm9yZSBlbmFibGluZw0K
PiA+IFBNIHJ1bnRpbWU/DQo+IA0KPiBUaGUgaXNzdWUgSSdtIGhhdmluZyBzZWVtcyB0byBoYXBw
ZW4gd2hlbiB0cnlpbmcgdG8gbG9hZCB0aGUgZmlybXdhcmUsDQo+IGdldHRpbmcgc3R1Y2sgaW4g
bW1jX3dhaXRfZm9yX3JlcV9kb25lIC0+IHdhaXRfZm9yX2NvbXBsZXRpb24sIHNvIHRoZQ0KPiBm
aXJtd2FyZSBpcyBuZXZlciByZWFsbHkgZnVsbHkgbG9hZGVkIHdoZW4gdGhlIGhhbmcgaGFwcGVu
cy4NCj4gDQpXaGVuIHRoZSBpbnRlcmZhY2UgaXMgYnJvdWdodCB1cCB0aGUgd2xhbl9yZW5hYmxl
IGdwaW8gY29tZXMgdXAgKGVuYWJsZWQpIGFuZCB0dXJuaW5nIHRoZSB3bDE4eHggZGV2aWNlIG9u
Lg0KSXQgbWlnaHQgYmUgdGhhdCB3aGF0IGhhcHBlbnMgaGVyZSBpcyB0aGF0IHRoZSBjaGlwIGlz
IG5vdCB5ZXQgZW5hYmxlZCB3aGVuIHRoZSBmaXJzdCBzZGlvIGNvbW1hbmQgaXMgc3RhcnRlZCBj
YXVzaW5nIGEgdGltZW91dC4NClRoZXJlIGlzIG5vcm1hbGx5IGEgZGVsYXkgYXNzb2NpYXRlZCB3
aXRoIHRoZSBmaXhlZCB2b2x0YWdlIHJlZ3VsYXRvciB0aGF0IGlzIHRpZWQgdG8gdGhpcyBncGlv
IGFuZCB1c2VkIGZvciBkaXNhYmxlL2VuYWJsZSAoc3RhcnR1cC1kZWxheS11cykuDQoNClNpbWls
YXIgdG8gdGhpczoNCi8gew0KCW1vZGVsID0gIlRJIEFNMzM1eCBCZWFnbGVCb25lIEJsYWNrIFdp
cmVsZXNzIjsNCgljb21wYXRpYmxlID0gInRpLGFtMzM1eC1ib25lLWJsYWNrLXdpcmVsZXNzIiwg
InRpLGFtMzM1eC1ib25lLWJsYWNrIiwgInRpLGFtMzM1eC1ib25lIiwgInRpLGFtMzN4eCI7DQoN
Cgl3bGFuX2VuX3JlZzogZml4ZWRyZWd1bGF0b3JAMiB7DQouLi4NCi4uLg0KCQlzdGFydHVwLWRl
bGF5LXVzPSA8NzAwMDA+Ow0KDQoJCS8qIFdMX0VOICovDQoJCWdwaW8gPSA8JmdwaW8zIDkgMD47
DQoJCWVuYWJsZS1hY3RpdmUtaGlnaDsNCgl9Ow0KfTsNCg0KUGVyaGFwcywgYXMgYSBkZWJ1ZyBz
dGVwLCB0cnkgdG8gYWRkIGEgZGVsYXkgaW4gIndsMTJ4eF9zZGlvX3Bvd2VyX29uIjoNCmh0dHBz
Oi8vZ2l0aHViLmNvbS90b3J2YWxkcy9saW51eC9ibG9iL21hc3Rlci9kcml2ZXJzL25ldC93aXJl
bGVzcy90aS93bGNvcmUvc2Rpby5jDQoNCmFuZCBzZWUgaWYgaXQgbWFrZXMgYSBjaGFuZ2U/DQoN
CkJlc3QgUmVnYXJkcywNCkV5YWwNCg0K
