Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C8FC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 20:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1C74206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 20:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfCLUss (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 16:48:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:16848 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbfCLUss (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 16:48:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2019 13:48:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,471,1544515200"; 
   d="scan'208";a="124909403"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga008.jf.intel.com with ESMTP; 12 Mar 2019 13:48:46 -0700
Received: from fmsmsx154.amr.corp.intel.com (10.18.116.70) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 12 Mar 2019 13:48:46 -0700
Received: from hasmsx107.ger.corp.intel.com (10.184.198.27) by
 FMSMSX154.amr.corp.intel.com (10.18.116.70) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 12 Mar 2019 13:48:46 -0700
Received: from hasmsx112.ger.corp.intel.com ([169.254.11.157]) by
 hasmsx107.ger.corp.intel.com ([169.254.2.23]) with mapi id 14.03.0415.000;
 Tue, 12 Mar 2019 22:48:42 +0200
From:   "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To:     "kevin@kevinlocke.name" <kevin@kevinlocke.name>
CC:     linuxwifi <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: Re: [linuxwifi] [RFC] iwlwifi: enable TX AMPDU for some iwldvm
Thread-Topic: [linuxwifi] [RFC] iwlwifi: enable TX AMPDU for some iwldvm
Thread-Index: AQHU2PbGwTd9hj9DNU+dTGwq4/G/q6YIQsCAgAACgACAAAxOgIAABOwA
Date:   Tue, 12 Mar 2019 20:48:42 +0000
Message-ID: <58bd45ab11912eef5c809427449a31800ecdbf53.camel@intel.com>
References: <20190312171205.GA12792@kevinolos>
         <0f9132187a5567fa94e396ed317efbae1aa4de14.camel@intel.com>
         <1b6eaef941d3bc887a9fbedea47c2677e5511cdd.camel@intel.com>
         <20190312203101.GA19902@kevinolos>
In-Reply-To: <20190312203101.GA19902@kevinolos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.25.57]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0AD6A98CA44EC647B88AAD5263E28486@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gVHVlLCAyMDE5LTAzLTEyIGF0IDE0OjMxIC0wNjAwLCBLZXZpbiBMb2NrZSB3cm90ZToNCj4g
VGhhbmtzIEx1Y2EgYW5kIEVtbWFudWVsLA0KPiANCj4gT24gVHVlLCAyMDE5LTAzLTEyIGF0IDE5
OjQ3ICswMDAwLCBHcnVtYmFjaCwgRW1tYW51ZWwgd3JvdGU6DQo+ID4gT24gVHVlLCAyMDE5LTAz
LTEyIGF0IDIxOjM4ICswMjAwLCBMdWNpYW5vIENvZWxobyB3cm90ZToNCj4gPiA+IElmIHRoaXMg
ZmVhdHVyZSB3YXMgZXhwbGljaXRseSBkaXNhYmxlZCwgaXQgY2VydGFpbmx5IG1lYW5zIHRoYXQN
Cj4gPiA+IHNvbWV0aGluZyB3YXMgY2F1c2luZyBwcm9ibGVtcyB3aXRoIGl0LCBzbyBJJ2QgYmUg
d2FyeSB0byBlbmFibGUNCj4gPiA+IGl0DQo+ID4gPiBmb3IgYWxsIERWTSBkZXZpY2VzLg0KPiA+
ID4gDQo+ID4gPiBJIGd1ZXNzIHdlIGNvdWxkIGVuYWJsZSBpdCBieSBkZWZhdWx0IGZvciBkZXZp
Y2VzIHRoYXQgd29yayBmaW5lLA0KPiA+ID4gYnV0DQo+ID4gPiB3ZSB3b3VsZCBoYXZlIHRvIHJ1
biBpdCBpbiByZWFsIGxpZmUgZm9yIGEgbG90IGxvbmdlciB3aXRoIGEgbG90DQo+ID4gPiBtb3Jl
DQo+ID4gPiBkaWZmZXJlbnQgQVBzIHRvIGJlIHN1cmUgaXQgd29uJ3QgY2F1c2UgYW55IHByb2Js
ZW1zLg0KPiANCj4gTWFrZXMgc2Vuc2UgdG8gbWUuICBJIGNhbiBzdGFydCB0ZXN0aW5nIHdpdGgg
YXZhaWxhYmxlIEFQcy4gIExldCBtZQ0KPiBrbm93IGlmIHRoZXJlIGlzIGFueXRoaW5nIHNwZWNp
ZmljIEkgc2hvdWxkIGxvb2sgZm9yIG9yIGNhdGFsb2cNCj4gYmV5b25kDQo+IGxhdGVuY3ksIHBh
Y2tldCBkcm9wIHJhdGVzLCBhbmQgYmFuZHdpZHRoLg0KPiANCj4gPiA+IEVtbWFudWVsLCBkbyB5
b3UgaGFwcGVuIHRvIHJlbWVtYmVyIHdoYXQgd2FzIHRoZSBpc3N1ZSwgc28gS2V2aW4NCj4gPiA+
IGNvdWxkIHRlc3QgdGhhdCBzcGVjaWZpYyBzY2VuYXJpbyB3aXRoIHRoaXMgc3BlY2lmaWMgTklD
Pw0KPiA+IA0KPiA+IGxvbmcgbG9uZyBuaWdodHMgb2YgZGVzcGFpci4NCj4gPiANCj4gPiBXZSBo
YWQgaXNzdWVzIHdpdGggcmVjbGFpbSBwYXRoIHVwb24gQkFDSy4gVGhpcyBpcyBvZiBjb3Vyc2Ug
YQ0KPiA+IGZpcm13YXJlDQo+ID4gcHJvYmxlbS4uLg0KPiANCj4gRG9lcyB0aGF0IHN1Z2dlc3Qg
dGhlIGlzc3VlIG1heSBoYXZlIGJlZW4gZml4ZWQgYnkgYSBmaXJtd2FyZSB1cGRhdGU/DQo+IEZv
ciByZWZlcmVuY2UsIEknbSBjdXJyZW50bHkgdXNpbmcgImZpcm13YXJlIHZlcnNpb24gOS4yMjEu
NC4xIGJ1aWxkDQo+IDI1NTMyIiBmcm9tIHRoZSBmaXJtd2FyZS1pd2x3aWZpIERlYmlhbiBwYWNr
YWdlICh2ZXJzaW9uIDIwMTkwMTE0LTEpLg0KPiANCj4gSWYgaXQgd291bGQgYmUgaGVscGZ1bCwg
SSBjb3VsZCBhdHRlbXB0IHRvIGJpc2VjdCB0aGUgZmlybXdhcmUNCj4gcmV2aXNpb25zIHRvIGZp
bmQgdGhlIG9uZSB0aGF0IGZpeGVkIGl0IChhc3N1bWluZyBJIGNhbiByZXByb2R1Y2UgdGhlDQo+
IGlzc3VlIHdpdGggYSBwcmV2aW91cyBmaXJtd2FyZSB2ZXJzaW9uKS4NCg0KV2VsbC4uIFNvcnJ5
LCBJIHdhc24ndCB2ZXJ5ICJ0ZWNobmljYWwiLg0KU28gdGhlIHByb2JsZW0gd2FzIHJlYWxseSB0
aGF0IHdlIHN0b3BwZWQgZ2V0dGluZyBCQUNLIG5vdGlmaWNhdGlvbnMNCmZyb20gdGhlIGZpcm13
YXJlIGFuZCB0aGF0IGNhdXNlZCBhIHJlY2xhaW0gc3RhbGwgd2hpY2ggaW4gdHVybiB3YXMNCmNh
dWdodCBieSBhIFR4IHF1ZXVlIHN0dWNrIHRpbWVyIGZpcmluZyBpbiB0aGUgZHJpdmVyLg0KSSB3
YXMgbmV2ZXIgYWJsZSB0byByZXByb2R1Y2UgdGhpcy4gV2hhdCBJIGNhbiBkbyBpcyB0byBlbmFi
bGUgQS1NUERVDQpvbiBteSBvbGQgc3lzdGVtIHRoYXQgaGFzIHRoaXMgc2FtZSBkZXZpY2UsIGp1
c3QgdG8gc2VlIHdoYXQgaGFwcGVucy4NCldoaWxlIGNoYXNpbmcgdGhpcyBidWcsIEkgZXZlbiBm
b3VuZCBhbm90aGVyIG9uZSB3aGljaCBib3VnaHQgbWUgYSBmZXcNCm1vbWVudHMgb2YgZmFtZToN
Cg0KY29tbWl0IGQ2ZWUyN2ViMTNiZWFiOTQwNTZlMGRlNTJkODEyMjAwNThjYTIyOTcNCkF1dGhv
cjogRW1tYW51ZWwgR3J1bWJhY2ggPGVtbWFudWVsLmdydW1iYWNoQGludGVsLmNvbT4NCkRhdGU6
ICAgV2VkIEp1biA2IDA5OjEzOjM2IDIwMTIgKzAyMDANCg0KICAgIGl3bHdpZmk6IGRvbid0IG1l
c3MgdXAgdGhlIFNDRCB3aGVuIHJlbW92aW5nIGEga2V5DQoNCmFuZCBpbiB0aGUgY29tbWl0IG1l
c3NhZ2Ugb2YgdGhhdCB2ZXJ5IGNvbW1pdDoNCg0KICAgIFRoaXMgZG9lc24ndCBzZWVtIHRvIGZp
eCB0aGUgaGlnaGVyIHF1ZXVlcyB0aGF0IGdldCBzdHVjaw0KICAgIGZyb20gdGltZSB0byB0aW1l
Lg0KDQpUaGVyZSB3ZXJlIG5vIG5ldyB2ZXJzaW9ucyBvZiB0aGUgZmlybXdhcmUgcmVsZWFzZWQg
c2luY2UgdGhlbi4NCkkgdHJpZWQgdG8gc2tpbSB0aHJvdWdoIGJ1Z3ppbGxhLCBidXQgY291bGRu
J3QgZmluZCB0aGUgYnVncyBJIHdhcw0KaGFuZGxpbmcgdGhlbi4NCg0KPiANCj4gVGhhbmtzIGFn
YWluLA0KPiBLZXZpbg0K
