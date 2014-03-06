Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:34612 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbaCFKZj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 05:25:39 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Karl Beldan <karl.beldan@gmail.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Bondar, Alexander" <alexander.bondar@intel.com>
Subject: RE: [PATCH 08/36] iwlwifi: mvm: Change power management dependency
 on multi MAC
Date: Thu, 6 Mar 2014 10:25:34 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D796A6@HASMSX103.ger.corp.intel.com> (sfid-20140306_112616_251824_1F4041F6)
References: <52B0B72A.5070704@gmail.com>
 <1387313079-28123-8-git-send-email-egrumbach@gmail.com>
 <20140113111357.GA4611@magnum.frso.rivierawaves.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D3C4A5@HASMSX103.ger.corp.intel.com>
 <20140113124049.GA5796@magnum.frso.rivierawaves.com>
 <52D83C56.5010706@gmail.com> <20140116214357.GA10376@gobelin>
 <CANUX_P25Oi=_5RBHKyuWQEZe6DXVyMOFS2xfGfa45HyyJSz=ug@mail.gmail.com>
 <20140306102102.GA15185@magnum.frso.rivierawaves.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiA+DQo+ID4gSGksDQo+ID4NCj4gPiBUaGFua3MgZm9yIHRoZSB1cGRhdGUsIGluZGVlZCBtb25p
dG9yIGlzIGluIGJldHRlciBzaGFwZSwgaG93ZXZlciBJIGFtDQo+ID4gc3RpbGwgc2VlaW5nIHNv
bWUgaXNzdWVzLg0KPiA+IEUuZy4gc2hvcnQtZ3VhcmQgb3IgPiAyME1IeiBidyBmcmFtZXMgYXJl
IG5vdCB2aXNpYmxlIHdoZW4gbm90DQo+ID4gYWdncmVnYXRlZCwgSSBzdGlsbCBzZWUgIk1pY3Jv
Y29kZSBTVyBlcnJvciBkZXRlY3RlZC4iIGJ1dCBpbiBhDQo+ID4gZGlmZmVyZW50IHNjZW5hcmlv
IChtb25pdG9yaW5nIHdpdGggbWFpbiBtYW5hZ2VkIGlmYWNlIGRvd24sIHRoZW4NCj4gPiB1cHBp
bmcgdGhlIG1haW4gbWFuYWdlZCBpZmFjZSB1cCksIGl0IGFsc28gc2VlbXMgdGhhdCB3ZSBmaWx0
ZXIgb3V0DQo+ID4gbWFueSBmcmFtZXMgd2hlbiB0aGUgbWFpbiBtYW5hZ2VkIGlmYWNlIGlzIHVw
IGFuZC9vcj8gYXNzb2NpYXRlZC4NCj4gPiBBbHNvLCBJIHN0YXJ0ZWQgd29ya2luZyBvbiBBTVNE
VXMgdGhpcyB3ZWVrIGFuZCB5ZXN0ZXJkYXkgbXkgbGFwdG9wDQo+ID4gY3Jhc2hlZCBpbW1lZGlh
dGVseSB3aGVuIG1vbml0b3JpbmcuIFRoaXMgbW9ybmluZyBJIHNlZSB0aGF0IHRoaXMNCj4gPiBo
YXBwZW5zIHdoZW4gbXkgYWdncmVnYXRlcyBzdGFydCBnZXR0aW5nIGFib3ZlIHRoZSB+NGsgbGlt
aXQgYW5kDQo+ID4gbW9kcHJvYmluZyB3aXRoIGFtc2R1X3NpemVfOEs9MSBzZWVtcyB0byAnZml4
JyB0aGUgaXNzdWUsIEkgZ3Vlc3Mgc29tZQ0KPiA+IHBsYWNlcyBuZWVkIHNvbWUgb2Zsb3dzIGNo
ZWNrcy4NCg0KSG1tLi4uIFRoYW5rcyBmb3IgdGhlIGhlYWRzIC0gdXAuIERvIHlvdSBoYXZlIHRo
ZSBjcmFzaCBkYXRhPw0KDQo+ID4gQWxsIHRoaXMgd2l0aCB3aXJlbGVzcy1uZXh0QDcwNDQ0NWQ5
IChpLmUuIGNpcmNhIHRoZSB0aW1lIEkgZ290IHlvdXINCj4gPiBlbWFpbCkgYW5kIGZ3IDIyLjE1
LjguMC4NCj4gPg0KPiANCj4gUGxlYXNlIHBhc3RlIHRoZSBkYXRhIGZvciB0aGUgZmlybXdhcmUg
YXNzZXJ0LiBBbHNvLCB0YWtlDQo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvY2dpdC9saW51eC9r
ZXJuZWwvZ2l0L2piZXJnL21hYzgwMjExLmdpdC9jb21taXQvP2lkPQ0KPiAxYzM3YTcyYzFiZDBi
ODNiZThiOTVjZmY3ZjFiYzliMWYzMmJkNDMzIGludG8gYWNjb3VudC4NCg==
