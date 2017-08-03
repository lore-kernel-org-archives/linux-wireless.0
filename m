Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:31911 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752151AbdHCL2u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 07:28:50 -0400
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "jikos@kernel.org" <jikos@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        "edubezval@gmail.com" <edubezval@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Weinehall, David" <david.weinehall@intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Sharon, Sara" <sara.sharon@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: Re: [linuxwifi] x86/thermal: AB-BA dependency between mvm->mutex
 and tz->lock
Date: Thu, 3 Aug 2017 11:28:45 +0000
Message-ID: <1501759724.15969.49.camel@intel.com> (sfid-20170803_133119_045521_83F37BDE)
References: <alpine.LSU.2.20.1707311300440.4705@cbobk.fhfr.pm>
         <alpine.LSU.2.20.1708031107230.30597@cbobk.fhfr.pm>
         <1501753405.15969.43.camel@intel.com>
         <87vam5nf4w.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87vam5nf4w.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVGh1LCAyMDE3LTA4LTAzIGF0IDEzOjAyICswMzAwLCBLYWxsZSBWYWxvIHdyb3RlOg0KPiAi
Q29lbGhvLCBMdWNpYW5vIiA8bHVjaWFuby5jb2VsaG9AaW50ZWwuY29tPiB3cml0ZXM6DQo+IA0K
PiA+IE9uIFRodSwgMjAxNy0wOC0wMyBhdCAxMToxMCArMDIwMCwgSmlyaSBLb3NpbmEgd3JvdGU6
DQo+ID4gPiBPbiBNb24sIDMxIEp1bCAyMDE3LCBKaXJpIEtvc2luYSB3cm90ZToNCj4gPiA+IA0K
PiA+ID4gPiBIaSwNCj4gPiA+ID4gDQo+ID4gPiA+IGJvb3RpbmcgY3VycmVudCBMaW51cycgdHJl
ZSwgSSdtIHNlZWluZyBsb2NrZGVwIHNwbGF0IChzZWUgdGhlIGVuZCBvZiB0aGlzIA0KPiA+ID4g
PiBtYWlsKS4NCj4gPiA+ID4gDQo+ID4gPiA+IEFwcGFyZW50bHksIHRoZXJlIGlzIEFCLUJBIGJl
dHdlZW4gdHotPmxvY2sgYW5kIG12bS0+bXV0ZXggdGhyb3VnaCB0aGUgQ1BVIA0KPiA+ID4gPiBo
b3RwbHVnIGxvY2suDQo+ID4gPiA+IA0KPiA+ID4gPiBUaGUgb2Jpdm91cyBkZXBlbmN5IGlzOiB0
aGVybWFsX3pvbmVfZ2V0X3RlbXAoKSBhY3F1aXJlcyB0ei0+bG9jaywgYW5kIA0KPiA+ID4gPiB0
aGVuIGNhbGxzIGl3bF9tdm1fdHpvbmVfZ2V0X3RlbXAoKSAodGhyb3VnaCB0ei0+b3BzLT5nZXRf
dGVtcCgpIA0KPiA+ID4gPiBjYWxsYmFjayksIHdoaWNoIGFjcXVpcmVzIG12bS0+bXV0ZXgNCj4g
PiA+ID4gDQo+ID4gPiA+IFRoZSBsZXNzIG9idmlvdXMgZGVwZW5kZW5jeSBpcyBwcmltYXJpbHkg
Y2F1c2VkIGJ5IGl3bF9vcF9tb2RlX212bV9zdGFydCgpIA0KPiA+ID4gPiBhbGxvY2F0aW5nIHdv
cmtxdWV1ZSAoIzIgc3RhY2t0cmFjZSkgd2hpbGUgaG9sZGluZyBtdm0tPm11dGV4ICh3aGljaCBp
cyANCj4gPiA+ID4gYnJva2VuLCBiZWNhdXNlIHRoYXQgbXV0ZXggaXMgYmVpbmcgdGFrZW4gYWxz
byBmcm9tIENQVSBob3RwbHVnIGNhbGxiYWNrIA0KPiA+ID4gPiBwYXRoLCBoZW5jZSB0aGUgQUIt
QkEpLg0KPiA+ID4gDQo+ID4gPiBBcyB0aGUgImNlbnRyYWwiIHBhcnQgb2YgdGhlIGRlcGVuZGVu
Y3kgaXMgYmVpbmcgYWRkZWQgYnkgaXdsd2lmaSBkcml2ZXIgDQo+ID4gPiAoX2l3bF9wY2llX3J4
X2luaXQoKSBhbGxvY2F0aW5nIHdvcmtxdWV1ZSB3aGlsZSBob2xkaW5nIA0KPiA+ID4gdHJhbnNf
cGNpZS0+bXV0ZXgpLCBJJ20gYWRkaW5nIGl3bHdpZmkgZm9sa3MgYXMgd2VsbCB0byBDQy4NCg0K
Wy4uLl0NCg0KPiA+ID4gPiAgLT4gIzIgKGNwdV9ob3RwbHVnX2xvY2sucndfc2VtKXsrKysrKyt9
Og0KPiA+ID4gPiAgICAgICAgIGxvY2tfYWNxdWlyZSsweGJkLzB4MjIwDQo+ID4gPiA+ICAgICAg
ICAgY3B1c19yZWFkX2xvY2srMHg0Ni8weDkwDQo+ID4gPiA+ICAgICAgICAgYXBwbHlfd29ya3F1
ZXVlX2F0dHJzKzB4MTcvMHg1MA0KPiA+ID4gPiAgICAgICAgIF9fYWxsb2Nfd29ya3F1ZXVlX2tl
eSsweDE5NS8weDRkMA0KPiA+ID4gPiAgICAgICAgIF9pd2xfcGNpZV9yeF9pbml0KzB4Mzg0LzB4
MzkwIFtpd2x3aWZpXQ0KPiA+ID4gPiAgICAgICAgIGl3bF9wY2llX3J4X2luaXQrMHgxZS8weDM4
MCBbaXdsd2lmaV0NCj4gPiA+ID4gICAgICAgICBpd2xfdHJhbnNfcGNpZV9zdGFydF9mdysweDI5
NS8weDZmMCBbaXdsd2lmaV0NCj4gPiA+ID4gICAgICAgICBpd2xfbXZtX2xvYWRfdWNvZGVfd2Fp
dF9hbGl2ZSsweGU3LzB4MzkwIFtpd2xtdm1dDQo+ID4gPiA+ICAgICAgICAgaXdsX3J1bl9pbml0
X212bV91Y29kZSsweDg0LzB4MzIwIFtpd2xtdm1dDQo+ID4gPiA+ICAgICAgICAgaXdsX29wX21v
ZGVfbXZtX3N0YXJ0KzB4OTY0LzB4ZDMwIFtpd2xtdm1dDQo+ID4gPiA+ICAgICAgICAgX2l3bF9v
cF9tb2RlX3N0YXJ0LmlzcmEuOSsweDQ3LzB4YTAgW2l3bHdpZmldDQo+ID4gPiA+ICAgICAgICAg
aXdsX29wbW9kZV9yZWdpc3RlcisweGFhLzB4ZDAgW2l3bHdpZmldDQo+ID4gPiA+ICAgICAgICAg
aXdsX212bV9pbml0KzB4MzcvMHgxMDAwIFtpd2xtdm1dDQo+ID4gPiA+ICAgICAgICAgZG9fb25l
X2luaXRjYWxsKzB4NTEvMHgxYTkNCj4gPiA+ID4gICAgICAgICBkb19pbml0X21vZHVsZSsweDYw
LzB4MjBlDQo+ID4gPiA+ICAgICAgICAgbG9hZF9tb2R1bGUrMHgyMDNmLzB4MmI1MA0KPiA+ID4g
PiAgICAgICAgIFNZU0NfZmluaXRfbW9kdWxlKzB4OTYvMHhkMA0KPiA+ID4gPiAgICAgICAgIFN5
U19maW5pdF9tb2R1bGUrMHhlLzB4MTANCj4gPiA+ID4gICAgICAgICBlbnRyeV9TWVNDQUxMXzY0
X2Zhc3RwYXRoKzB4MjMvMHhjMg0KDQpPa2F5LCBzbyBhcyBJIHVuZGVyc3RhbmQgaXQgdGhlIHBy
b2JsZW0gaGFzIGJlZW4gdGhlcmUgZm9yIGEgbG9uZyB0aW1lLA0KYnV0IHRoZSBzcGxhdCBpcyBv
bmx5IGNvbWluZyB1cCBub3cgYmVjYXVzZSBvZiBUaG9tYXMnIHBhdGNoIHRoYXQgYWRkcw0KdGhl
IGxvY2tkZXAgbWFwWzFdLCByaWdodD8NCg0KSSBzZWUgdGhlIHdvcmtxdWV1ZSBhbGxvY2F0aW9u
IHlvdSBtZW50aW9uZWQuICBJJ2xsIHRyeSB0byBtb3ZlIHRoaXMNCmFsbG9jYXRpb24gb3V0IG9m
IHRoZSBtdXRleCBhbmQgc2VlIGhvdyBpdCBnb2VzLg0KDQpbMV0gaHR0cDovL2xrbWwua2VybmVs
Lm9yZy9yLzIwMTcwNTI0MDgxNTQ5LjcwOTM3NTg0NUBsaW51dHJvbml4LmRlDQoNCi0tDQpDaGVl
cnMsDQpMdWNhLg==
