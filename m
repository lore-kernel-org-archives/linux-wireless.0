Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE87C43612
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 08:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3A9C2070B
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 08:45:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qti.qualcomm.com header.i=@qti.qualcomm.com header.b="DOcDPFhk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727748AbfAHIpc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 03:45:32 -0500
Received: from alexa-out-tai-02.qualcomm.com ([103.229.16.227]:12024 "EHLO
        alexa-out-tai-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727446AbfAHIpb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 03:45:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1546937129; x=1578473129;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=Sgqpy+vfBEWi0fjdcVCZY+h+Scf7gVqyeCCxy1zQxpA=;
  b=DOcDPFhkkyMjidMTIzq5+m2oSua8olTeNCdulelzk6iNhfBgNNXrtoNb
   kILYpc8FY5elpdRabgaH2aKubo7RneDZmIAAj3hBkFko0YAJDkZSFgwV5
   96thzMik6jZin7dTmyS69NEfLitpIPEaUNBDBBQfhgnalWnFS4leufnbb
   4=;
X-IronPort-AV: E=Sophos;i="5.56,453,1539619200"; 
   d="scan'208";a="1761880"
Subject: RE: [PATCH] ath10k: Remove ATH10K_STATE_RESTARTED in simulate fw crash
Thread-Topic: [PATCH] ath10k: Remove ATH10K_STATE_RESTARTED in simulate fw crash
Received: from ironmsg01-tai.qualcomm.com ([10.249.140.6])
  by alexa-out-tai-02.qualcomm.com with ESMTP; 08 Jan 2019 16:45:28 +0800
X-IronPort-AV: E=McAfee;i="5900,7806,9129"; a="21685980"
Received: from aptaiexm02b.ap.qualcomm.com ([10.249.150.12])
  by ironmsg01-tai.qualcomm.com with ESMTP/TLS/AES256-SHA; 08 Jan 2019 16:45:28 +0800
Received: from aptaiexm02f.ap.qualcomm.com (10.249.150.16) by
 aptaiexm02b.ap.qualcomm.com (10.249.150.12) with Microsoft SMTP Server (TLS)
 id 15.0.1395.4; Tue, 8 Jan 2019 16:45:26 +0800
Received: from aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1]) by
 aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1%19]) with mapi id
 15.00.1395.000; Tue, 8 Jan 2019 16:45:26 +0800
From:   Wen Gong <wgong@qti.qualcomm.com>
To:     =?utf-8?B?TWljaGHFgiBLYXppb3I=?= <kazikcz@gmail.com>
CC:     Wen Gong <wgong@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Thread-Index: AQHUpmQJz5XVQIMvMUei5K703fyTnaWlDqiA
Date:   Tue, 8 Jan 2019 08:45:26 +0000
Message-ID: <e18e50cae69e44f4b9e4abb1fa110193@aptaiexm02f.ap.qualcomm.com>
References: <1542163824-795-1-git-send-email-wgong@codeaurora.org>
 <CABvG-CWg-VXAtoN8HZumW-ZdP6dX9cO_8fWJ58C22kD2yDcXdw@mail.gmail.com>
 <195f3bb0c88c43a6b1ca0ad336f947c0@aptaiexm02f.ap.qualcomm.com>
 <CABvG-CWAfB8jjCDW4ggjJ8_YC++CjttJOMOt4s24F3mymvNR9A@mail.gmail.com>
In-Reply-To: <CABvG-CWAfB8jjCDW4ggjJ8_YC++CjttJOMOt4s24F3mymvNR9A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.249.136.10]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

PiA+DQo+ID4gPiA+IEl0IGlzIGJlY2F1c2UgdGhlIHN0YXRlIGhhcyBub3QgY2hhbmdlZCB0byBB
VEgxMEtfU1RBVEVfT04NCj4gPiA+ID4gaW1tZWRpYXRlbHksIHRoZW4gaXQgd2lsbCBoYXZlIG1v
cmUgdGhhbiB0d28gc2ltdWxhdGUgY3Jhc2gNCj4gPiA+ID4gcHJvY2VzcyBydW5uaW5nIG1lYW53
aGlsZSwgYW5kIGNvbXBsZXRlL3dha2V1cCBzb21lIGZpZWxkIHR3aWNlLA0KPiA+ID4gPiBpdCBk
ZXN0cm95IHRoZSBub3JtYWwgcmVjb3ZlcnkgcHJvY2Vzcy4NCj4gPiA+DQo+ID4gPiBUaGlzIHdh
cyBpbnRlbmRlZCB0byBhbGxvdyB0ZXN0aW5nIG5vdCBvbmx5IGZpcm13YXJlIGNyYXNoIHBhdGgg
KGFuZA0KPiA+ID4gcmVjb3ZlcnkpIGJ1dCBhbHNvIGZpcm13YXJlIGNyYXNoIHdoaWxlIHJlY292
ZXJpbmcgZnJvbSBhIGZpcm13YXJlIGNyYXNoLg0KPiA+ID4NCj4gPiBJZiBmaXJtd2FyZSBpcyBy
ZWNvdmVyaW5nIGZyb20gY3Jhc2gsIHRoZW4gc2ltdWxhdGUgYSBuZXcgY3Jhc2ggd2lsbCB0cmln
Z2VyDQo+IGVycm9yLg0KPiA+IFNvIHJlbW92ZSBpdC4NCj4gDQo+IFRoYXQncyBhY3R1YWxseSBh
IGZlYXR1cmUsIG5vdCBhIGJ1Zy4gSWYgZmlybXdhcmUgY3Jhc2hlcyB3aGlsZSBkcml2ZXIgaXMN
Cj4gcmVzdGFydGluZyBhZnRlciBhIGNyYXNoIHRoZW4gaXRzIGxpa2VseSBnb2luZyB0byBmYWls
IGFnYWluIGFuZCBhZ2FpbiBjYXVzaW5nIGENCj4gY3Jhc2gtcmVzdGFydCBsb29wIHdoaWNoIGNh
biBhZmZlY3Qgc3lzdGVtIHBlcmZvcm1hbmNlIGFuZCByZXNwb25zaXZlbmVzcy4NCj4gSXQncyBi
ZXR0ZXIgdG8gZ2l2ZSB1cCBhbmQgbGV0IHRoZSBzeXN0ZW0gYWRtaW4gdGFrZSBvdmVyLg0KPiAN
Cj4gSWYgaXQncyBzdGlsbCBib3RoZXJpbmcgeW91IHRoZW4gcGxlYXNlIGNvbnNpZGVyIGEgY3Jh
c2ggY291bnRlciB0aHJlc2hvbGQgc28NCj4gdGhhdCwgZS5nLiBhZnRlciA1IGNyYXNoLXdoaWxl
LXJlc3RhcnRpbmcgaXQncyBnb2luZyB0byBnaXZlIHVwLiBIb3dldmVyIEkgZG91YnQNCj4gaXQn
cyB3b3J0aCB0aGUgZWZmb3J0LiBNeSBleHBlcmllbmNlIHRlbGxzIG1lIGZpcm13YXJlIGNyYXNo
ZXMgZHVyaW5nDQo+IHJlY292ZXJ5IGFyZSByYXJlbHksIGlmIGF0IGFsbCwgdHJhbnNpZW50Lg0K
PiANCj4gVGhlIHNpbXVsYXRlZCBmdyBjcmFzaCBpcyBub3QgcmVwcmVzZW50YXRpdmUgaGVyZS4g
SXQncyBhIG1lcmUgdG9vbCB0byB0ZXN0DQo+IGRyaXZlciBjb2RlLg0KDQpUaGUgc2ltdWxhdGVk
IGZ3IGNyYXNoIGlzIG9ubHkgYSB0b29sIGZvciB1c2VyIHRvIHRyaWdnZXIgZncgY3Jhc2ggd2l0
aCBjb21tYW5kLA0KVGhpcyBjaGFuZ2UncyBwdXJwb3NlIGlzIHRvIGRpc2FsbG93IHVzZXIgdG8g
dHJpZ2dlciBmdyBjcmFzaCBpZiB0aGUgZncgaXMgbm90IGluIGENCk5vcm1hbCBzdGF0ZS4NCg0K
SWYgdGhlIGZ3IGlzIGluIHJlY292ZXJpbmcgc3RhdGUgdHJpZ2dlcmVkIGJ5IHVzZXIncyBjb21t
YW5kIG9yIGJ5IGZ3LCB0aGVuIGl0IHdpbGwNCmRpc2FsbG93IHVzZXIgdG8gcnVuIGNvbW1hbmQg
dG8gdHJpZ2dlciBmdyBjcmFzaCBhZ2FpbiB1bnRpbCBmdyBiZWNvbWUgdG8gYSBub3JtYWwNClN0
YXRlLg0KDQo+IA0KPiANCj4gTWljaGHFgg0K
