Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05332C10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 05:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBA2420857
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 05:09:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qti.qualcomm.com header.i=@qti.qualcomm.com header.b="IVkgiN+m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfDIFJH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 01:09:07 -0400
Received: from alexa-out-tai-01.qualcomm.com ([103.229.16.226]:39781 "EHLO
        alexa-out-tai-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbfDIFJH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 01:09:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1554786545; x=1586322545;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=YBlKL3Xiz6rBhfY9qEh5kPd1RIJqwOpNkdzmgkvt1Gc=;
  b=IVkgiN+mJB9dfk7ybdA9rkB/7mzCuIzsmEPDYmGF77RHc+UTe0Vl+21w
   n0X7vgX1v+Mu/w85YpbHSsI2Ez7gDODGk3ZSUgpZAlmhN25CsetOgxvKi
   g7qMxCIV/wYDIOYqV25FUpmtmudvPtz2VboKZKJJ7cAgOQWDob+Br/Ty4
   M=;
X-IronPort-AV: E=Sophos;i="5.60,328,1549900800"; 
   d="scan'208";a="2150774"
Subject: RE: [PATCH] ath10k: Remove ATH10K_STATE_RESTARTED in simulate fw crash
Thread-Topic: [PATCH] ath10k: Remove ATH10K_STATE_RESTARTED in simulate fw crash
Received: from ironmsg01-tai.qualcomm.com ([10.249.140.6])
  by alexa-out-tai-01.qualcomm.com with ESMTP; 09 Apr 2019 13:09:04 +0800
X-IronPort-AV: E=McAfee;i="5900,7806,9221"; a="26527368"
Received: from aptaiexm02b.ap.qualcomm.com ([10.249.150.12])
  by ironmsg01-tai.qualcomm.com with ESMTP/TLS/AES256-SHA; 09 Apr 2019 13:09:04 +0800
Received: from aptaiexm02f.ap.qualcomm.com (10.249.150.16) by
 aptaiexm02b.ap.qualcomm.com (10.249.150.12) with Microsoft SMTP Server (TLS)
 id 15.0.1395.4; Tue, 9 Apr 2019 13:09:02 +0800
Received: from aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1]) by
 aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1%19]) with mapi id
 15.00.1395.000; Tue, 9 Apr 2019 13:09:02 +0800
From:   Wen Gong <wgong@qti.qualcomm.com>
To:     =?utf-8?B?TWljaGHFgiBLYXppb3I=?= <kazikcz@gmail.com>
CC:     Wen Gong <wgong@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Thread-Index: AQHUpmQJz5XVQIMvMUei5K703fyTnaYnTmZwgAtNzTD///F7AIABLCiA
Date:   Tue, 9 Apr 2019 05:09:02 +0000
Message-ID: <1fec49e1b6794860a1eff2330bcdea28@aptaiexm02f.ap.qualcomm.com>
References: <1542163824-795-1-git-send-email-wgong@codeaurora.org>
 <CABvG-CWg-VXAtoN8HZumW-ZdP6dX9cO_8fWJ58C22kD2yDcXdw@mail.gmail.com>
 <195f3bb0c88c43a6b1ca0ad336f947c0@aptaiexm02f.ap.qualcomm.com>
 <CABvG-CWAfB8jjCDW4ggjJ8_YC++CjttJOMOt4s24F3mymvNR9A@mail.gmail.com>
 <02904ba8682441e1a89668c1345cbec9@aptaiexm02f.ap.qualcomm.com>
 <54b4dab1191d41b8b329f3ceb7017626@aptaiexm02f.ap.qualcomm.com>
 <CABvG-CWz0rBCXfF7mX9L62=fmdcYhpOaO5JNLtvSE87o_XJFng@mail.gmail.com>
In-Reply-To: <CABvG-CWz0rBCXfF7mX9L62=fmdcYhpOaO5JNLtvSE87o_XJFng@mail.gmail.com>
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

PiBGcm9tOiBNaWNoYcWCIEthemlvciA8a2F6aWtjekBnbWFpbC5jb20+DQo+IFNlbnQ6IFR1ZXNk
YXksIEFwcmlsIDksIDIwMTkgMToyNyBBTQ0KPiBUbzogV2VuIEdvbmcgPHdnb25nQHF0aS5xdWFs
Y29tbS5jb20+DQo+IENjOiBXZW4gR29uZyA8d2dvbmdAY29kZWF1cm9yYS5vcmc+OyBsaW51eC13
aXJlbGVzcyA8bGludXgtDQo+IHdpcmVsZXNzQHZnZXIua2VybmVsLm9yZz47IGF0aDEwa0BsaXN0
cy5pbmZyYWRlYWQub3JnDQo+IFN1YmplY3Q6IFtFWFRdIFJlOiBbUEFUQ0hdIGF0aDEwazogUmVt
b3ZlIEFUSDEwS19TVEFURV9SRVNUQVJURUQgaW4NCj4gc2ltdWxhdGUgZncgY3Jhc2gNCj4gDQo+
ID4gPiBIaSBNaWNoYWwsDQo+ID4gPiBUaGVyZSBoYXZlIGEgc3RyZXNzIHRlc3QgY2FzZSBmb3Ig
dGhlIHNpbXVsYXRlIGZ3IGNyYXNoLCBpdCB3aWxsIHNpbXVsYXRlIGZ3DQo+ID4gPiBjcmFzaA0K
PiA+ID4gaW4gYSB2ZXJ5IHNob3J0IHRpbWUgZm9yIGVhY2ggdGVzdCwgdGhpcyB3aWxsIHRyaWdn
ZXIgdGhlIHN0cmVzcyB0ZXN0IGZhaWwuDQo+ID4gPiBUaGUgc2ltdWxhdGUgZncgY3Jhc2ggcHJv
Y2VzcyBzaG91bGQgbm90IGJlIHJ1biBwYXJhbGxlbCwgYWZ0ZXIgdGhpcyBwYXRjaCwNCj4gdGhl
DQo+ID4gPiBTdHJlc3MgdGVzdCBjYXNlIHdpbGwgcGFzcy4NCj4gPiA+ID4NCj4gPg0KPiA+IEhp
IE1pY2hhxYIsDQo+ID4gRG8geW91IGhhdmUgc29tZSBuZXcgY29tbWVudHM/DQo+IA0KPiBNeSBv
cmlnaW5hbCB1c2UgY2FzZSB3YXMgdG8gYmUgYWJsZSB0byBleGVyY2lzZSB0aGUgZHJpdmVyJ3MN
Cj4gcm9idXN0bmVzcyBpbiBoYW5kbGluZyBuZXN0ZWQgZncgY3Jhc2hlcywgSU9XIGNyYXNoLXdp
dGhpbi1hLWNyYXNoLg0KPiANCj4gWW91ciB0ZXN0IGNhc2UsIGFzIGZhciBhcyBJIHVuZGVyc3Rh
bmQsIGludGVuZHMgdG8gcGVyZm9ybQ0KPiBjb25zZWN1dGl2ZSwgbm9uLW5lc3RlZCBmdyBjcmFz
aCBzaW11bGF0aW9uIHN0cmVzcyB0ZXN0Lg0KPiANCj4gQm90aCBvZiB0aGVzZSBhcmUgbXV0dWFs
bHkgZXhjbHVzaXZlIGFuZCB5b3VyIHBhdGNoIGZpeGVzIHlvdXIgdGVzdA0KPiBjYXNlIGF0IHRo
ZSBleHBlbnNlIG9mIGJyZWFraW5nIG15IG9yaWdpbmFsIGNhc2UuDQo+IA0KPiBUbyBzYXRpc2Z5
IGJvdGggSSB3b3VsZCBzdWdnZXN0IHlvdSBlaXRoZXIgZXhwb3NlIGFyLT5zdGF0ZSB2aWENCj4g
ZGVidWdmcyBhbmQgbWFrZSB5b3VyIHRlc3QgcHJvY2VkdXJlIHdhaXQgZm9yIHRoYXQgdG8gZ2V0
IGJhY2sgaW50byBPTg0KPiBzdGF0ZSBiZWZvcmUgc2ltdWxhdGluZyBhIGNyYXNoIGFnYWluLCBv
ciB0byBleHRlbmQgdGhlIHNldCBvZiBjdXJyZW50DQo+IHNpbXVsYXRlX2Z3X2NyYXNoIGNvbW1h
bmRzIChjdXJyZW50bHkganVzdDogc29mdCwgaGFyZCwgYXNzZXJ0LA0KPiBody1yZXN0YXJ0KSB0
byBzb21ldGhpbmcgdGhhdCBhbGxvd3MgZXhwcmVzc2luZyB0aGUgaW50ZW50IHdoZXRoZXINCj4g
Y3Jhc2gtaW4tY3Jhc2ggcHJldmVudGlvbiBpcyBpbnRlbmRlZCAoeW91ciBjYXNlKSBvciBub3Qg
KG15IG9yaWdpbmFsDQo+IGNhc2UpLg0KPiANCj4gVGhpcyBjb3VsZCBiZSBmb3IgZXhhbXBsZSBz
b21ldGhpbmcgbGlrZSB0aGlzOg0KPiAgIGVjaG8gc29mdCB3YWl0LXJlYWR5ID4gc2ltdWxhdGVf
ZndfY3Jhc2gNCj4gDQo+IFRoZSAid2FpdC1yZWFkeSIgZXh0cmEga2V5d29yZCB3b3VsZCBpbXBs
eSBjcmFzaC1pbi1jcmFzaCBwcmV2ZW50aW9uLg0KPiBUaGlzIHdvdWxkIGtlZXAgZXhpc3Rpbmcg
dG9vbHMgd29ya2luZyAoYm90aCBiZWhhdmlvciBhbmQgc3ludGF4KSBhbmQNCj4gd291bGQgYWxs
b3cgeW91ciB0ZXN0IGNhc2UgdG8gYmUgaW1wbGVtZW50ZWQuDQo+IA0KSXMgaXQgZWFzeSB0byBj
aGFuZ2UgeW91ciBleGlzdGluZyB0b29scz8NCkkgd2FudCB0byBjaGFuZ2UgaXQgdG86IGVjaG8g
c29mdCBza2lwLXJlYWR5ID4gc2ltdWxhdGVfZndfY3Jhc2gNClRoZSAic2tpcC1yZWFkeSIgZXh0
cmEga2V5d29yZCB3b3VsZCBpbXBseSBjcmFzaC1pbi1jcmFzaCwgKm5vdCogcHJldmVudGlvbi4N
Ck15IHRlc3QgdG9vbHMgaXMgaGFyZCB0byBjaGFuZ2UuDQoNCj4gDQo+IE1pY2hhxYINCg==
