Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:47622 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286AbcGKQHq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 12:07:46 -0400
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"prarit@redhat.com" <prarit@redhat.com>
CC: linuxwifi <linuxwifi@intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"Ivgi, Chaya Rachel" <chaya.rachel.ivgi@intel.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Sharon, Sara" <sara.sharon@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH RESEND] iwlwifi, Do not implement thermal zone unless
 ucode is loaded
Date: Mon, 11 Jul 2016 16:07:42 +0000
Message-ID: <1468253261.25088.126.camel@intel.com> (sfid-20160711_180809_690462_9C467C6E)
References: <1468250301-10357-1-git-send-email-prarit@redhat.com>
In-Reply-To: <1468250301-10357-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gTW9uLCAyMDE2LTA3LTExIGF0IDExOjE4IC0wNDAwLCBQcmFyaXQgQmhhcmdhdmEgd3JvdGU6
DQo+IERpZG4ndCBnZXQgYW55IGZlZWRiYWNrIG9yIHJldmlldyBjb21tZW50cyBvbiB0aGlzIHBh
dGNoLsKgwqBSZXNlbmRpbmcNCj4gLi4uDQo+IA0KPiBQLg0KDQpTb3JyeSwgdGhpcyBnb3QgZmxv
b2RlZCBkb3duIG15IGluYm94Lg0KDQoNCj4gLS0tODwtLS0NCj4gDQo+IFRoZSBpd2x3aWZpIGRy
aXZlciBpbXBsZW1lbnRzIGEgdGhlcm1hbCB6b25lIGFuZCBod21vbiBkZXZpY2UsIGJ1dA0KPiBy
ZXR1cm5zIC1FSU8gb24gdGVtcGVyYXR1cmUgcmVhZHMgaWYgdGhlIGZpcm13YXJlIGlzbid0IGxv
YWRlZC7CoMKgVGhpcw0KPiByZXN1bHRzIGluIHRoZSBlcnJvcg0KPiANCj4gaXdsd2lmaS12aXJ0
dWFsLTANCj4gQWRhcHRlcjogVmlydHVhbCBkZXZpY2UNCj4gRVJST1I6IENhbid0IGdldCB2YWx1
ZSBvZiBzdWJmZWF0dXJlIHRlbXAxX2lucHV0OiBJL08gZXJyb3INCj4gdGVtcDE6wqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgTi9BDQo+IA0KPiBiZWluZyBvdXRwdXQgd2hlbiB1c2luZyBzZW5zb3Jz
IGZyb20gdGhlIGxtLXNlbnNvcnMgcGFja2FnZS7CoMKgU2luY2UNCj4gdGhlIHRlbXBlcmF0dXJl
IGNhbm5vdCBiZSByZWFkIHVubGVzcyB0aGUgdWNvZGUgaXMgbG9hZGVkIHRoZXJlIGlzIG5vDQo+
IHJlYXNvbiB0byBhZGQgdGhlIGludGVyZmFjZSBvbmx5IHRvIGhhdmUgaXQgcmV0dXJuIGFuIGVy
cm9yIDEwMCUgb2YNCj4gdGhlIHRpbWUuDQo+IA0KPiBUaGlzIHBhdGNoIG1vdmVzIHRoZSBmaXJt
d2FyZSBjaGVjayB0bw0KPiBpd2xfbXZtX3RoZXJtYWxfem9uZV9yZWdpc3RlcigpIGFuZA0KPiBz
dG9wcyB0aGUgdGhlcm1hbCB6b25lIGZyb20gYmVpbmcgY3JlYXRlZCBpZiB0aGUgdWNvZGUgaGFz
bid0IGJlZW4NCj4gbG9hZGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogUHJhcml0IEJoYXJnYXZh
IDxwcmFyaXRAcmVkaGF0LmNvbT4NCj4gQ2M6IEpvaGFubmVzIEJlcmcgPGpvaGFubmVzLmJlcmdA
aW50ZWwuY29tPg0KPiBDYzogRW1tYW51ZWwgR3J1bWJhY2ggPGVtbWFudWVsLmdydW1iYWNoQGlu
dGVsLmNvbT4NCj4gQ2M6IEx1Y2EgQ29lbGhvIDxsdWNpYW5vLmNvZWxob0BpbnRlbC5jb20+DQo+
IENjOiBJbnRlbCBMaW51eCBXaXJlbGVzcyA8bGludXh3aWZpQGludGVsLmNvbT4NCj4gQ2M6IEth
bGxlIFZhbG8gPGt2YWxvQGNvZGVhdXJvcmEub3JnPg0KPiBDYzogQ2hheWEgUmFjaGVsIEl2Z2kg
PGNoYXlhLnJhY2hlbC5pdmdpQGludGVsLmNvbT4NCj4gQ2M6IFNhcmEgU2hhcm9uIDxzYXJhLnNo
YXJvbkBpbnRlbC5jb20+DQo+IENjOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmcNCj4g
Q2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gLS0tDQoNCkkgaGF2ZSBub3cgc2VudCBpdCBm
b3IgcmV2aWV3IG9uIG91ciBpbnRlcm5hbCB0cmVlLg0KDQotLQ0KTHVjYS4=
