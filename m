Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EDACC10F0E
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 02:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B97C20857
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 02:45:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qti.qualcomm.com header.i=@qti.qualcomm.com header.b="Ft3jG0Wa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfDJCpe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 22:45:34 -0400
Received: from alexa-out-tai-02.qualcomm.com ([103.229.16.227]:50669 "EHLO
        alexa-out-tai-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726670AbfDJCpe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 22:45:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1554864332; x=1586400332;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=KcI7brU//tiAxQ5ZPZ9AGlkqVIvJMsRAnbJLPv8BMH8=;
  b=Ft3jG0Wa8mYKlHE2lqy7mB9BmrHi405arH468HDU4fYfS4LpCMjDuI8S
   sk6H1h6XjWzza1uPXBLcw0yMa8tVtyCxLUa376YQMZvVmvTIMJ0N4cvoL
   sv+BGo+uLiy2S69qxDf6dPsVqedUyV2NTECYp3qrJ84AymL3WVsh2Dwep
   4=;
X-IronPort-AV: E=Sophos;i="5.60,331,1549900800"; 
   d="scan'208";a="2163019"
Subject: RE: [PATCH] ath10k: Remove ATH10K_STATE_RESTARTED in simulate fw crash
Thread-Topic: [PATCH] ath10k: Remove ATH10K_STATE_RESTARTED in simulate fw crash
Received: from ironmsg01-tai.qualcomm.com ([10.249.140.6])
  by alexa-out-tai-02.qualcomm.com with ESMTP; 10 Apr 2019 10:45:31 +0800
X-IronPort-AV: E=McAfee;i="5900,7806,9222"; a="26596159"
Received: from aptaiexm02b.ap.qualcomm.com ([10.249.150.12])
  by ironmsg01-tai.qualcomm.com with ESMTP/TLS/AES256-SHA; 10 Apr 2019 10:45:31 +0800
Received: from aptaiexm02f.ap.qualcomm.com (10.249.150.16) by
 aptaiexm02b.ap.qualcomm.com (10.249.150.12) with Microsoft SMTP Server (TLS)
 id 15.0.1395.4; Wed, 10 Apr 2019 10:45:29 +0800
Received: from aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1]) by
 aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1%19]) with mapi id
 15.00.1395.000; Wed, 10 Apr 2019 10:45:29 +0800
From:   Wen Gong <wgong@qti.qualcomm.com>
To:     Brian Norris <briannorris@chromium.org>
CC:     =?utf-8?B?TWljaGHFgiBLYXppb3I=?= <kazikcz@gmail.com>,
        Wen Gong <wgong@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Thread-Index: AQHUpmQJz5XVQIMvMUei5K703fyTnaYnTmZwgAtNzTD///F7AIABLCiAgADKTICAAL2CYA==
Date:   Wed, 10 Apr 2019 02:45:29 +0000
Message-ID: <b073fa90e9a3437c9846ce2d22fab15f@aptaiexm02f.ap.qualcomm.com>
References: <1542163824-795-1-git-send-email-wgong@codeaurora.org>
 <CABvG-CWg-VXAtoN8HZumW-ZdP6dX9cO_8fWJ58C22kD2yDcXdw@mail.gmail.com>
 <195f3bb0c88c43a6b1ca0ad336f947c0@aptaiexm02f.ap.qualcomm.com>
 <CABvG-CWAfB8jjCDW4ggjJ8_YC++CjttJOMOt4s24F3mymvNR9A@mail.gmail.com>
 <02904ba8682441e1a89668c1345cbec9@aptaiexm02f.ap.qualcomm.com>
 <54b4dab1191d41b8b329f3ceb7017626@aptaiexm02f.ap.qualcomm.com>
 <CABvG-CWz0rBCXfF7mX9L62=fmdcYhpOaO5JNLtvSE87o_XJFng@mail.gmail.com>
 <1fec49e1b6794860a1eff2330bcdea28@aptaiexm02f.ap.qualcomm.com>
 <CA+ASDXP1Ftpi93p=Bp2w1rRd3xVtNn_+diwkKTMXbTqK0B3ahA@mail.gmail.com>
In-Reply-To: <CA+ASDXP1Ftpi93p=Bp2w1rRd3xVtNn_+diwkKTMXbTqK0B3ahA@mail.gmail.com>
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

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCcmlhbiBOb3JyaXMgPGJyaWFu
bm9ycmlzQGNocm9taXVtLm9yZz4NCj4gU2VudDogV2VkbmVzZGF5LCBBcHJpbCAxMCwgMjAxOSA3
OjI1IEFNDQo+IFRvOiBXZW4gR29uZyA8d2dvbmdAcXRpLnF1YWxjb21tLmNvbT4NCj4gQ2M6IE1p
Y2hhxYIgS2F6aW9yIDxrYXppa2N6QGdtYWlsLmNvbT47IFdlbiBHb25nDQo+IDx3Z29uZ0Bjb2Rl
YXVyb3JhLm9yZz47IGxpbnV4LXdpcmVsZXNzIDxsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5v
cmc+Ow0KPiBhdGgxMGtAbGlzdHMuaW5mcmFkZWFkLm9yZw0KPiBTdWJqZWN0OiBbRVhUXSBSZTog
W1BBVENIXSBhdGgxMGs6IFJlbW92ZSBBVEgxMEtfU1RBVEVfUkVTVEFSVEVEIGluDQo+IHNpbXVs
YXRlIGZ3IGNyYXNoDQo+IA0KPiBPbiBNb24sIEFwciA4LCAyMDE5IGF0IDEwOjA5IFBNIFdlbiBH
b25nIDx3Z29uZ0BxdGkucXVhbGNvbW0uY29tPg0KPiB3cm90ZToNCj4gPiA+IEZyb206IE1pY2hh
xYIgS2F6aW9yIDxrYXppa2N6QGdtYWlsLmNvbT4NCj4gPiA+IFRvIHNhdGlzZnkgYm90aCBJIHdv
dWxkIHN1Z2dlc3QgeW91IGVpdGhlciBleHBvc2UgYXItPnN0YXRlIHZpYQ0KPiA+ID4gZGVidWdm
cyBhbmQgbWFrZSB5b3VyIHRlc3QgcHJvY2VkdXJlIHdhaXQgZm9yIHRoYXQgdG8gZ2V0IGJhY2sg
aW50byBPTg0KPiA+ID4gc3RhdGUgYmVmb3JlIHNpbXVsYXRpbmcgYSBjcmFzaCBhZ2Fpbiwgb3Ig
dG8gZXh0ZW5kIHRoZSBzZXQgb2YgY3VycmVudA0KPiA+ID4gc2ltdWxhdGVfZndfY3Jhc2ggY29t
bWFuZHMgKGN1cnJlbnRseSBqdXN0OiBzb2Z0LCBoYXJkLCBhc3NlcnQsDQo+ID4gPiBody1yZXN0
YXJ0KSB0byBzb21ldGhpbmcgdGhhdCBhbGxvd3MgZXhwcmVzc2luZyB0aGUgaW50ZW50IHdoZXRo
ZXINCj4gPiA+IGNyYXNoLWluLWNyYXNoIHByZXZlbnRpb24gaXMgaW50ZW5kZWQgKHlvdXIgY2Fz
ZSkgb3Igbm90IChteSBvcmlnaW5hbA0KPiA+ID4gY2FzZSkuDQo+ID4gPg0KPiA+ID4gVGhpcyBj
b3VsZCBiZSBmb3IgZXhhbXBsZSBzb21ldGhpbmcgbGlrZSB0aGlzOg0KPiA+ID4gICBlY2hvIHNv
ZnQgd2FpdC1yZWFkeSA+IHNpbXVsYXRlX2Z3X2NyYXNoDQo+ID4gPg0KPiA+ID4gVGhlICJ3YWl0
LXJlYWR5IiBleHRyYSBrZXl3b3JkIHdvdWxkIGltcGx5IGNyYXNoLWluLWNyYXNoIHByZXZlbnRp
b24uDQo+ID4gPiBUaGlzIHdvdWxkIGtlZXAgZXhpc3RpbmcgdG9vbHMgd29ya2luZyAoYm90aCBi
ZWhhdmlvciBhbmQgc3ludGF4KSBhbmQNCj4gPiA+IHdvdWxkIGFsbG93IHlvdXIgdGVzdCBjYXNl
IHRvIGJlIGltcGxlbWVudGVkLg0KPiA+ID4NCj4gPiBJcyBpdCBlYXN5IHRvIGNoYW5nZSB5b3Vy
IGV4aXN0aW5nIHRvb2xzPw0KPiA+IEkgd2FudCB0byBjaGFuZ2UgaXQgdG86IGVjaG8gc29mdCBz
a2lwLXJlYWR5ID4gc2ltdWxhdGVfZndfY3Jhc2gNCj4gPiBUaGUgInNraXAtcmVhZHkiIGV4dHJh
IGtleXdvcmQgd291bGQgaW1wbHkgY3Jhc2gtaW4tY3Jhc2gsICpub3QqDQo+IHByZXZlbnRpb24u
DQo+ID4gTXkgdGVzdCB0b29scyBpcyBoYXJkIHRvIGNoYW5nZS4NCj4gDQo+IEluIGNhc2UgeW91
J3JlIHRhbGtpbmcgYWJvdXQgdGhlIHRlc3QgZnJhbWV3b3JrIHdlIHJ1biBmb3IgQ2hyb21lT1MN
Cj4gdmFsaWRhdGlvbiwgbm8sIGl0J3Mgbm90IGhhcmQgYXQgYWxsIHRvIGNoYW5nZS4gQXMgbG9u
ZyBhcyB0aGVyZSdzIGENCj4gZ29vZCByZWFzb24uDQo+IA0KPiBJIGhhdmVuJ3QgY2xvc2VseSBm
b2xsb3dlZCB0aGlzLCBidXQganVkZ2luZyBieSB0aGUgYWJvdmUgc3VtbWFyeSwNCj4gaXQncyBw
cm9iYWJseSBtb3JlIHJlYXNvbmFibGUgZm9yIG91ciB0ZXN0IGZyYW1ld29yayB0byBvbmx5IHNp
bXVsYXRlDQo+IEZXIGNyYXNoZXMgYWZ0ZXIgdGhlIGRyaXZlciByZXR1cm5zIHRvICJyZWFkeSIg
KG9yIGF0IGxlYXN0LCBpZiB3ZSBkbw0KPiBjcmFzaC1pbi1jcmFzaCwgZG9uJ3QgZXhwZWN0IHRo
ZSBkcml2ZXIgdG8gcmVjb3Zlcj8pLiBJIGV4cGVjdCB3ZSBjYW4NCj4gd29yayB3aXRoIHdoYXRl
dmVyIG1lY2hhbmlzbSB5b3UgaW1wbGVtZW50IGZvciB0aGF0IChleHBvc2luZyB0aGUNCj4gInN0
YXRlIiwgb3IgcHJvdmlkaW5nIGEgbmV3IHNpbXVsYXRlX2Z3X2NyYXNoIG1vZGUpLg0KPiANCg0K
SWYgQ2hyb21lT1MgaXMgZWFzeSB0byBjaGFuZ2UgdG9vbCwgDQpJIHRoaW5rIEkgd2lsbCBjaGFu
Z2UgdGhlIG1lY2hhbmlzbSBvZiB0aGUgc2ltdWxhdGVfZndfY3Jhc2guDQpUaGVuIGFsbCB0b29s
cyB3aWxsIHdvcmsgbm9ybWFsbHkuDQoNCj4gQnJpYW4NCg==
