Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:53750 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754235Ab2FLVWe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 17:22:34 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Jouni Malinen <j@w1.fi>
Date: Tue, 12 Jun 2012 14:18:17 -0700
Subject: RE: [PATCH 3/4] mwifiex: add 11n support for AP mode
Message-ID: <477F20668A386D41ADCC57781B1F7043083A7F1203@SC-VEXCH1.marvell.com> (sfid-20120612_232237_613537_4FACAC41)
References: <1339463659-10736-1-git-send-email-bzhao@marvell.com>
	 <1339463659-10736-3-git-send-email-bzhao@marvell.com>
	 (sfid-20120612_031449_661395_EE5E9722)
 <1339502065.4531.3.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F7043083A7F11AD@SC-VEXCH1.marvell.com>
 <1339528302.4531.14.camel@jlt3.sipsolutions.net>
In-Reply-To: <1339528302.4531.14.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNCj4gPiA+ID4gUGFyc2UgSFQgSUUgZnJvbSBjZmc4MDIxMSBhbmQgc2V0
IEhUIGNhcGFiaWxpdGllcyBhY2NvcmRpbmdseQ0KPiA+ID4gPiB0byBGVy4gSWYgSFQgSUUgaXMg
bWlzc2luZywgMTFuIHdvdWxkIGJlIGRpc2FibGVkIGluIEZXLg0KPiA+ID4NCj4gPiA+IE5vIG9i
amVjdGlvbnMsIGJ1dCBpdCBtaWdodCBiZSB3b3J0aHdoaWxlIHRvIGV4dGVuZCB0aGUgQVBJcyB0
byBub3QNCj4gPiBoYXZlDQo+ID4gPiB0byBwYXJzZSB0aGlzPw0KPiA+DQo+ID4gSWYgSSB1bmRl
cnN0YW5kIGl0IGNvcnJlY3RseSwgd2UgY2FuIHByb2JhYmx5IGRvIHNvbWV0aGluZyBsaWtlIHRo
aXM6DQo+ID4NCj4gPiAxKSBhZGQgbmV3IHZhcmlhYmxlcyAiY29uc3QgdTggKmh0X2NhcCIgYW5k
ICJzaXplX3QgaHRfY2FwX2xlbiIgdG8NCj4gPiBzdHJ1Y3QgY2ZnODAyMTFfYXBfc2V0dGluZ3MN
Cj4gPiAyKSBwYXJzZSBXTEFOX0VJRF9IVF9DQVBBQklMSVRZIGluIG5sODAyMTFfc3RhcnRfYXAo
KSBhbmQgdXBkYXRlDQo+ID4gaHRfY2FwL2h0X2NhcF9sZW4gYWNjb3JkaW5nbHkNCj4gPiAzKSBk
cml2ZXJzIChtd2lmaWV4LCBldGMuKSBtYWtlIHVzZSBvZiBodF9jYXAvaHRfY2FwX2xlbiBkaXJl
Y3RseSBpbg0KPiA+IHN0YXJ0X2FwKCkgaGFuZGxlcg0KPiA+DQo+ID4gUmVnYXJkbGVzcyB3ZSBo
YXZlIHRvIHBhcnNlIEhUX0NBUCBJRSBmcm9tIGJlYWNvbi50YWlsLCBlaXRoZXIgaW4NCj4gPiBk
cml2ZXIgc3RhcnRfdXAgaGFuZGxlciwgb3IgaW5zaWRlIG9mIGNmZzgwMjExL25sODAyMTEuIFBs
ZWFzZSBsZXQgbWUNCj4gPiBrbm93IGlmIGFib3ZlIGNoYW5nZSBpcyBPSyBmb3IgeW91Lg0KPiAN
Cj4gSSBkb24ndCB0aGluayBJJ2QgYm90aGVyIGRvaW5nIHRoZSBhYm92ZSBjaGFuZ2UuIEkgd2Fz
IHRoaW5raW5nIHRoYXQgdGhlDQo+IHN1cHBsaWNhbnQvaG9zdGFwZCB3b3VsZCBnaXZlIGl0IGlu
IHNlcGFyYXRlIGF0dHJpYnV0ZXMsIGJ1dCBJIGd1ZXNzIGl0DQo+IGRvZXNuJ3QuDQoNCk9LLiBJ
IHdpbGwgc3RpY2sgdG8gb3JpZ2luYWwgYXBwcm9hY2ggdGhlbi4NCg0KQnkgdGhlIHdheSwgSSB3
aWxsIHJlc3VibWl0IHRoaXMgcGF0Y2ggdG8gYWRkcmVzcyBzb21lIHNwYXJzZSB3YXJuaW5ncy4N
Cg0KVGhhbmtzLA0KQmluZw0KDQo=
