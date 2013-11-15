Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19851 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab3KOSx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 13:53:56 -0500
From: "Chauhan, Rajesh" <rajeshc@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"BAHINI, Henri" <hbahini@qca.qualcomm.com>,
	"Johnson, Jeff" <jjohnson@qca.qualcomm.com>,
	"Chang, Leo" <schang@qca.qualcomm.com>,
	"Luo, Xun" <xunl@qca.qualcomm.com>,
	"Thalappil, Sameer" <sameert@qca.qualcomm.com>,
	"Hussain, Arif" <c_arifh@qca.qualcomm.com>,
	"Chauhan, Rajesh" <rajeshc@qca.qualcomm.com>
Subject: RE: [PATCHv3] cfg80211: add support for frequency interference event
Date: Fri, 15 Nov 2013 18:53:53 +0000
Message-ID: <D19FD2B13A40CD4B8DA64DB9B8F112E936C4D635@nasanexd01a.na.qualcomm.com> (sfid-20131115_195359_673080_A367066D)
References: <1384198356-427-1-git-send-email-rajeshc@qca.qualcomm.com>
 <CAB=NE6V7NkXwmvqajqx4ATnCsT9vn=R0JQFkQE5mOdWHWuBsug@mail.gmail.com>
In-Reply-To: <CAB=NE6V7NkXwmvqajqx4ATnCsT9vn=R0JQFkQE5mOdWHWuBsug@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSm9oYW5uZXMsDQoNCkNvdWxkIHlvdSBwbC4gbGV0IHVzIGtub3cgb2YgYW55IGZ1cnRoZXIg
Y29tbWVudHMvZmVlZGJhY2sgb24gcGF0Y2ggc2V0IHYzPw0KDQpSZWdhcmRzLA0KUmFqZXNoIENo
YXVoYW4NCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IG1jZ3JvZkBnbWFpbC5j
b20gW21haWx0bzptY2dyb2ZAZ21haWwuY29tXSBPbiBCZWhhbGYgT2YgTHVpcyBSLiBSb2RyaWd1
ZXoNClNlbnQ6IFRodXJzZGF5LCBOb3ZlbWJlciAxNCwgMjAxMyAxOjU0IEFNDQpUbzogQ2hhdWhh
biwgUmFqZXNoDQpDYzogSm9oYW5uZXMgQmVyZzsgbGludXgtd2lyZWxlc3M7IE1hbGluZW4sIEpv
dW5pOyBCQUhJTkksIEhlbnJpOyBKb2huc29uLCBKZWZmOyBDaGFuZywgTGVvOyBMdW8sIFh1bjsg
VGhhbGFwcGlsLCBTYW1lZXI7IEh1c3NhaW4sIEFyaWYNClN1YmplY3Q6IFJlOiBbUEFUQ0h2M10g
Y2ZnODAyMTE6IGFkZCBzdXBwb3J0IGZvciBmcmVxdWVuY3kgaW50ZXJmZXJlbmNlIGV2ZW50DQoN
Ck9uIE1vbiwgTm92IDExLCAyMDEzIGF0IDg6MzIgUE0sIFJhamVzaCBDaGF1aGFuIDxyYWplc2hj
QHFjYS5xdWFsY29tbS5jb20+IHdyb3RlOg0KPiBBZGQgc3VwcG9ydCBmb3Igd2lyZWxlc3MgZHJp
dmVyIHRvIHJlcG9ydCBmcmVxdWVuY3kgcmFuZ2UocykgdG8gYmUgDQo+IGF2b2lkZWQgYmVjYXVz
ZSBvZiBpbnRlcmZlcmVuY2UuIFdpcmVsZXNzIGRyaXZlciBzcGVjaWZpZXMgc291cmNlIG9mIA0K
PiBpbnRlcmZlcmVuY2UgZm9yIGEgZ2l2ZW4gZnJlcXVlbmN5IHJhbmdlLiBGb3Igbm93LCBhcHBs
aWNhYmxlIHNvdXJjZSANCj4gb2YgaW50ZXJmZXJlbmNlIGlzICJjZWxsdWxhciIgb25seSBhbmQg
b3RoZXIgaW50ZXJmZXJlbmNlIHNvdXJjZSB0eXBlcyANCj4gY2FuIGJlIGFkZGVkIGxhdGVyLiBJ
ZiBTb2Z0QVAvUDJQLUdPIGlzIG9wZXJhdGluZyBvbiBpbnRlcmZlcmluZyANCj4gZnJlcXVlbmN5
IHRoZW4gdXNlciBzcGFjZSBzaG91bGQgc3RvcCBhbmQgcmVzdGFydCB0aGVtIGF2b2lkaW5nIA0K
PiBpbnRlcmZlcmluZyBmcmVxdWVuY3kgcmFuZ2UocykuIFVzZXIgc3BhY2UgbWF5IGRlY2lkZSB0
byBjb250aW51ZSANCj4gb3BlcmF0aW9uIG9uIGludGVyZmVyaW5nIGZyZXF1ZW5jeSwgYnV0IGlu
IHN1Y2ggY2FzZSwgdGhlcmUgbWlnaHQgYmUgDQo+IGltcGFjdCBvbiBwZXJmb3JtYW5jZS4NCj4N
Cj4gU2lnbmVkLW9mZi1ieTogUmFqZXNoIENoYXVoYW4gPHJhamVzaGNAcWNhLnF1YWxjb21tLmNv
bT4NCg0KUmV2aWV3ZWQtYnk6IEx1aXMgUi4gUm9kcmlndWV6IDxtY2dyb2ZAZG8tbm90LXBhbmlj
LmNvbT4NCg0KICBMdWlzDQo=
