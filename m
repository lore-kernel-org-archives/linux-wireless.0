Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0121.outbound.protection.outlook.com ([104.47.37.121]:12288
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752087AbcHVDz3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Aug 2016 23:55:29 -0400
From: Wright Feng <wefe@cypress.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Chi-Hsien Lin" <chln@cypress.com>
Subject: RE: [PATCH v2] brcmfmac: shut down AP and set IBSS mode only on
 primary interface
Date: Mon, 22 Aug 2016 03:40:01 +0000
Message-ID: <DM5PR06MB2825089C55692920E0432B31D9E80@DM5PR06MB2825.namprd06.prod.outlook.com> (sfid-20160822_055801_747412_8C4473EA)
References: <1470894260-18128-1-git-send-email-wright.feng@cypress.com>
 <CACna6rxLVkhzf0fea0ESbeBF4G-FK12JRBYNULosgVNRssyTiQ@mail.gmail.com>
In-Reply-To: <CACna6rxLVkhzf0fea0ESbeBF4G-FK12JRBYNULosgVNRssyTiQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DQoNCg0KRnJvbTogUmFmYcWCIE1pxYJlY2tpIFttYWlsdG86emFqZWM1QGdtYWlsLmNvbV0NCj4g
T24gMTEgQXVndXN0IDIwMTYgYXQgMDc6NDQsIFdyaWdodCBGZW5nIDx3cmlnaHQuZmVuZ0BjeXBy
ZXNzLmNvbT4gd3JvdGU6DQo+ID4gV2hlbiBzdG9wcGluZyBob3N0YXAgb24gdmlydHVhbCBpbnRl
cmZhY2UsIGRyaXZlciB3aWxsIHNldCBJTkZSQSBhbmQNCj4gPiBBUCBtb2RlIHRoYXQgbWF5IGFm
ZmVjdCB0aGUgZnVuY3Rpb25hbGl0eSBvbiBwcmltYXJ5IGludGVyZmFjZS4gRm9yDQo+ID4gZXhh
bXBsZSwgaWYgd2UgY3JlYXRlIGFuZCBzdG9wIGhvc3RhcGQgb24gdmlydHVhbCBpbnRlcmZhY2Ug
dGhlbg0KPiA+IGFzc29jaWF0aW9uIGNhbm5vdCB3b3JrIG9uIHByaW1hcnkgaW50ZXJmYWNlIGJl
Y2F1c2UgSU5GUkEgbW9kZSBoYXMNCj4gYmVlbiBzZXQgdG8gSUJTUy4NCj4gPiBIZW5jZSB3ZSBz
aHV0IGRvd24gQVAgYW5kIHNldCBJQlNTIG1vZGUgb25seSBvbiBwcmltYXJ5IGludGVyZmFjZS4N
Cj4NCj4gWW91IGFsc28gZXhjbHVkZWQgZnJvbSBleGVjdXRpb24gY29kZSBzZXR0aW5nIEJSQ01G
X0NfU0VUX0FQIHRvIDAuDQo+IERvZXMgaXQgZ2V0IGEgcmVzZXQgYXQgc29tZSBwb2ludD8gTWF5
YmUgd2l0aCBhICJic3MiIGNhbGw/IEknbSB3b25kZXJpbmcgaWYNCj4gaXQncyBwb3NzaWJsZSB0
byB1c2UgaW50ZXJmYWNlIGluIG1hbmFnZWQgbW9kZSBpZiBpdCB3YXMgdXNlZCBhcyBBUCBvbmNl
Lg0KSW4gdGhpcyBjYXNlLCB0aGUgdmlydHVhbCBpbnRlcmZhY2UgY2Fubm90IGJlIG1hbmFnZWQg
bW9kZSB1bmxlc3MgcmUtY3JlYXRpbmcgdGhlIGludGVyZmFjZS4NCkRyaXZlciBzaG91bGQganVz
dCBleGNsdWRlIGZyb20gc2V0dGluZyBJTkZSQSBtb2RlIHdoZW4gc3RvcHBpbmcgQVAgd2l0aCB2
aXJ0dWFsIGludGVyZmFjZSwgYW5kIEknbGwgdXBkYXRlIHRoaXMgY2hhbmdlIGluIFBBVENIIHYz
Lg0KVGhhbmtzIGZvciB5b3VyIHJldmlldy4NCj4NCj4gLS0NCj4gUmFmYcWCDQoNClJlZ2FyZHMs
DQpXcmlnaHQNCg0KVGhpcyBtZXNzYWdlIGFuZCBhbnkgYXR0YWNobWVudHMgbWF5IGNvbnRhaW4g
Q3lwcmVzcyAob3IgaXRzIHN1YnNpZGlhcmllcykgY29uZmlkZW50aWFsIGluZm9ybWF0aW9uLiBJ
ZiBpdCBoYXMgYmVlbiByZWNlaXZlZCBpbiBlcnJvciwgcGxlYXNlIGFkdmlzZSB0aGUgc2VuZGVy
IGFuZCBpbW1lZGlhdGVseSBkZWxldGUgdGhpcyBtZXNzYWdlLg0K
