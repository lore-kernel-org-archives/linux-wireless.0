Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51220 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753530AbcIIK2W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 06:28:22 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Subject: RE: mwifiex: PCIe8997 chip specific handling
Date: Fri, 9 Sep 2016 10:28:18 +0000
Message-ID: <5c381ec576c54a7fad54e7a23a060e29@SC-EXCH04.marvell.com> (sfid-20160909_122924_860321_8B19BEF1)
References: <1469788731-5361-1-git-send-email-akarwar@marvell.com>
 <20160909091449.A66606183E@smtp.codeaurora.org>
In-Reply-To: <20160909091449.A66606183E@smtp.codeaurora.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgS2FsbGUsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbGludXgt
d2lyZWxlc3Mtb3duZXJAdmdlci5rZXJuZWwub3JnIFttYWlsdG86bGludXgtd2lyZWxlc3MtDQo+
IG93bmVyQHZnZXIua2VybmVsLm9yZ10gT24gQmVoYWxmIE9mIEthbGxlIFZhbG8NCj4gU2VudDog
RnJpZGF5LCBTZXB0ZW1iZXIgMDksIDIwMTYgMjo0NSBQTQ0KPiBUbzogQW1pdGt1bWFyIEthcndh
cg0KPiBDYzogbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnOyBDYXRoeSBMdW87IE5pc2hh
bnQgU2FybXVrYWRhbTsNCj4gQW1pdGt1bWFyIEthcndhcg0KPiBTdWJqZWN0OiBSZTogbXdpZmll
eDogUENJZTg5OTcgY2hpcCBzcGVjaWZpYyBoYW5kbGluZw0KPiANCj4gQW1pdGt1bWFyIEthcndh
ciA8YWthcndhckBtYXJ2ZWxsLmNvbT4gd3JvdGU6DQo+ID4gVGhlIHBhdGNoIGNvcnJlY3RzIHRo
ZSByZXZpc2lvbiBpZCByZWdpc3RlciBhbmQgdXNlcyBpdCBhbG9uZyB3aXRoDQo+ID4gbWFnaWMg
dmFsdWUgYW5kIGNoaXAgdmVyc2lvbiByZWdpc3RlcnMgdG8gZG93bmxvYWQgYXBwcm9wcmlhdGUN
Cj4gPiBmaXJtd2FyZSBpbWFnZS4NCj4gPg0KPiA+IFBDSWU4OTk3IFogY2hpcHNldCB2YXJpYW50
IGNvZGUgaGFzIGJlZW4gcmVtb3ZlZCwgYXMgaXQgd29uJ3QgYmUgdXNlZA0KPiA+IGluIHByb2R1
Y3Rpb24uDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBBbWl0a3VtYXIgS2Fyd2FyIDxha2Fyd2Fy
QG1hcnZlbGwuY29tPg0KPiANCj4gRG9lcyBhcHBseSwgcGxlYXNlIHJlYmFzZToNCj4gDQo+IEFw
cGx5aW5nOiBtd2lmaWV4OiBQQ0llODk5NyBjaGlwIHNwZWNpZmljIGhhbmRsaW5nDQo+IGZhdGFs
OiBzaGExIGluZm9ybWF0aW9uIGlzIGxhY2tpbmcgb3IgdXNlbGVzcw0KPiAoZHJpdmVycy9uZXQv
d2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L3BjaWUuYykuDQo+IFJlcG9zaXRvcnkgbGFja3MgbmVj
ZXNzYXJ5IGJsb2JzIHRvIGZhbGwgYmFjayBvbiAzLXdheSBtZXJnZS4NCj4gQ2Fubm90IGZhbGwg
YmFjayB0byB0aHJlZS13YXkgbWVyZ2UuDQo+IFBhdGNoIGZhaWxlZCBhdCAwMDAxIG13aWZpZXg6
IFBDSWU4OTk3IGNoaXAgc3BlY2lmaWMgaGFuZGxpbmcNCj4gDQoNClRoZSBwYXRjaCBub3cgc21v
b3RobHkgYXBwbGllcyB0byB0b3Agb2YgdGhlIHRyZWUuIEl0IGhhZCBhIGRlcGVuZGVuY3kgd2l0
aCAibXdpZmlleDogYWRkIFBDSWUgZnVuY3Rpb24gbGV2ZWwgcmVzZXQgc3VwcG9ydCIgd2hpY2gg
aXMgbWVyZ2VkLg0KTGV0IG1lIGtub3cgaWYgdGhlcmUgaXMgc3RpbGwgYSBwcm9ibGVtLg0KDQpS
ZWdhcmRzLA0KQW1pdGt1bWFyDQo=
