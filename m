Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60715 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932206AbcJXOze (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 10:55:34 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@google.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Ganapathi Bhat" <gbhat@marvell.com>
Subject: RE: cfg80211: race problem between suspend and disconnect event
Date: Mon, 24 Oct 2016 14:54:07 +0000
Message-ID: <f554d10391094b2d810b5a63ae0c2c9d@SC-EXCH04.marvell.com> (sfid-20161024_165548_270617_ACF48013)
References: <67400d1c5c2141b3af75bdce9ec43840@SC-EXCH04.marvell.com>
         <1476989132.14078.12.camel@sipsolutions.net>
         <7af766c43f2f426b8db177f8d4e67031@SC-EXCH04.marvell.com>
 <1477085053.4068.65.camel@sipsolutions.net>
In-Reply-To: <1477085053.4068.65.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNCj4gRnJvbTogSm9oYW5uZXMgQmVyZyBbbWFpbHRvOmpvaGFubmVzQHNp
cHNvbHV0aW9ucy5uZXRdDQo+IFNlbnQ6IFNhdHVyZGF5LCBPY3RvYmVyIDIyLCAyMDE2IDI6NTQg
QU0NCj4gVG86IEFtaXRrdW1hciBLYXJ3YXINCj4gQ2M6IEthbGxlIFZhbG87IEJyaWFuIE5vcnJp
czsgTmlzaGFudCBTYXJtdWthZGFtOyBDYXRoeSBMdW87IGxpbnV4LQ0KPiB3aXJlbGVzc0B2Z2Vy
Lmtlcm5lbC5vcmc7IEdhbmFwYXRoaSBCaGF0DQo+IFN1YmplY3Q6IFJlOiBjZmc4MDIxMTogcmFj
ZSBwcm9ibGVtIGJldHdlZW4gc3VzcGVuZCBhbmQgZGlzY29ubmVjdCBldmVudA0KPiANCj4gDQo+
ID4gWWVzLiBJbiBvdXIgY2FzZSwgKjgwMl8xMV9ERUFVVEhFTlRJQ0FURSBjb21tYW5kIGRvd25s
b2FkZWQgdG8NCj4gPiBmaXJtd2FyZSB0YWtlcyBjYXJlIG9mIGZsdXNoaW5nIHRoZSBrZXlzLg0K
PiA+DQo+ID4gSSBjYW4gc2VlIGJlbG93IGNvZGUgaW4gY2ZnODAyMTEncyBkaXNjb25uZWN0IGhh
bmRsaW5nLiBJdCBzZWVtcyB0byBiZQ0KPiA+IHRoZXJlIGZvciBsb25nIHRpbWUuDQo+IA0KPiBZ
ZWFoLCBJIHNhdyBpdCwgYnV0IGl0J3Mgbm90IGNsZWFyIHRvIG1lIHRoYXQgdGhlcmUncyBtdWNo
IHBvaW50IGluIGl0Lg0KPiBJbiBhbnkgY2FzZSwgdGhhdCdzIGFuIHVucmVsYXRlZCBxdWVzdGlv
biBpbiBhIHdheSwgYmVjYXVzZSB0aGVyZQ0KPiBkZWZpbml0ZWx5IGFyZSB0aGluZ3MgaGFwcGVu
aW5nIGhlcmUgdGhhdCBzaG91bGQgYmUgIm1vcmUgc3luY2hyb25vdXMiLA0KPiByZWdhcmRsZXNz
IG9mIHdoZXRoZXIgb3Igbm90IHRoZSBrZXkgZGVsZXRpb24gbWFrZXMgc2Vuc2UuDQo+IA0KPiA+
IEkgdGhpbmssIHlvdXIgY2ZnODAyMTEgY2hhbmdlIHdpbGwgaGVscC4gV2UgZG8gZW5zdXJlIHRo
YXQNCj4gPiBjZmc4MDIxMV9kaXNjb25uZWN0ZWQoKSBpcyBjYWxsZWQgYmVmb3JlIGV4aXRpbmcN
Cj4gPiBtd2lmaWV4X2NmZzgwMjExX2Rpc2Nvbm5lY3QoKS4NCj4gPiBTZW5kaW5nIEhvc3RDbWRf
Q01EXzgwMl8xMV9ERUFVVEhFTlRJQ0FURSBjb21tYW5kIHRvIGZpcm13YXJlIGlzIGENCj4gPiBi
bG9ja2luZyBjYWxsLiBjZmc4MDIxMV9kaXNjb25uZWN0ZWQoKSBpcyBjYWxsZWQgd2hpbGUgaGFu
ZGxpbmcgdGhhdA0KPiA+IGNvbW1hbmQncyByZXNwb25zZS4NCj4gDQo+IEFoIG9rLCBJIG1pc3Nl
ZCB0aGF0IC0gSSB0aG91Z2h0IGl0IHdhcyBhc3luY2hyb25vdXMuDQo+IA0KPiA+ID4gU28gc29t
ZWhvdyB5b3UnZCBoYXZlIHRvIHN5bmNocm9uaXplIHdpdGggdGhlIGZpcm13YXJlIGFzIHdlbGws
IHRvDQo+ID4gPiBwcm9jZXNzIGFsbCB0aG9zZSB0aGluZ3MgYmVmb3JlIHN1c3BlbmQsIEkgZ3Vl
c3M/DQo+ID4gPg0KPiBbLi4uXQ0KPiA+IFRoaXMgd291bGQgbm90IGJlIG5lZWRlZC4NCj4gDQo+
IFJpZ2h0LiBDYXJlIHRvIHRlc3QgbXkgcGF0Y2ggYmVmb3JlIEkgcHJvcGVybHkgc3VibWl0IGl0
Pw0KDQpXZSByYW4gdGhlIHRlc3RzIGFuZCBjb25maXJtZWQgdGhhdCB5b3VyIHBhdGNoIGRvZXMg
c29sdmUgdGhlIHByb2JsZW0uIFlvdSBjYW4gc3VibWl0IGl0Lg0KDQpSZWdhcmRzLA0KQW1pdGt1
bWFyDQo=
