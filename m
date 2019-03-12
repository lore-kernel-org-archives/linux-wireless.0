Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43DD4C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 19:47:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19B682087C
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 19:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfCLTrG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 15:47:06 -0400
Received: from mga05.intel.com ([192.55.52.43]:61957 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726372AbfCLTrG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 15:47:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2019 12:47:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,471,1544515200"; 
   d="scan'208";a="126368221"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga006.jf.intel.com with ESMTP; 12 Mar 2019 12:47:05 -0700
Received: from fmsmsx155.amr.corp.intel.com (10.18.116.71) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 12 Mar 2019 12:47:05 -0700
Received: from lcsmsx155.ger.corp.intel.com (10.186.165.233) by
 FMSMSX155.amr.corp.intel.com (10.18.116.71) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 12 Mar 2019 12:47:04 -0700
Received: from hasmsx112.ger.corp.intel.com ([169.254.11.157]) by
 LCSMSX155.ger.corp.intel.com ([169.254.12.205]) with mapi id 14.03.0415.000;
 Tue, 12 Mar 2019 21:47:02 +0200
From:   "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To:     linuxwifi <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kevin@kevinlocke.name" <kevin@kevinlocke.name>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: Re: [linuxwifi] [RFC] iwlwifi: enable TX AMPDU for some iwldvm
Thread-Topic: [linuxwifi] [RFC] iwlwifi: enable TX AMPDU for some iwldvm
Thread-Index: AQHU2PbGwTd9hj9DNU+dTGwq4/G/q6YIQsCAgAACgAA=
Date:   Tue, 12 Mar 2019 19:47:00 +0000
Message-ID: <1b6eaef941d3bc887a9fbedea47c2677e5511cdd.camel@intel.com>
References: <20190312171205.GA12792@kevinolos>
         <0f9132187a5567fa94e396ed317efbae1aa4de14.camel@intel.com>
In-Reply-To: <0f9132187a5567fa94e396ed317efbae1aa4de14.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.11.171]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A515323E0D4965468BD86A8A8AF02E02@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gVHVlLCAyMDE5LTAzLTEyIGF0IDIxOjM4ICswMjAwLCBMdWNpYW5vIENvZWxobyB3cm90ZToN
Cj4gSGkgS2V2aW4sDQo+IA0KPiBKb2hhbm5lcyAoam9oaWxsKSBpcyBhbHNvIGluIHRoaXMgbGlz
dC4gOikNCj4gDQo+IElmIHRoaXMgZmVhdHVyZSB3YXMgZXhwbGljaXRseSBkaXNhYmxlZCwgaXQg
Y2VydGFpbmx5IG1lYW5zIHRoYXQNCj4gc29tZXRoaW5nIHdhcyBjYXVzaW5nIHByb2JsZW1zIHdp
dGggaXQsIHNvIEknZCBiZSB3YXJ5IHRvIGVuYWJsZSBpdA0KPiBmb3INCj4gYWxsIERWTSBkZXZp
Y2VzLg0KPiANCj4gSSBndWVzcyB3ZSBjb3VsZCBlbmFibGUgaXQgYnkgZGVmYXVsdCBmb3IgZGV2
aWNlcyB0aGF0IHdvcmsgZmluZSwgYnV0DQo+IHdlIHdvdWxkIGhhdmUgdG8gcnVuIGl0IGluIHJl
YWwgbGlmZSBmb3IgYSBsb3QgbG9uZ2VyIHdpdGggYSBsb3QgbW9yZQ0KPiBkaWZmZXJlbnQgQVBz
IHRvIGJlIHN1cmUgaXQgd29uJ3QgY2F1c2UgYW55IHByb2JsZW1zLg0KPiANCj4gRW1tYW51ZWws
IGRvIHlvdSBoYXBwZW4gdG8gcmVtZW1iZXIgd2hhdCB3YXMgdGhlIGlzc3VlLCBzbyBLZXZpbg0K
PiBjb3VsZA0KPiB0ZXN0IHRoYXQgc3BlY2lmaWMgc2NlbmFyaW8gd2l0aCB0aGlzIHNwZWNpZmlj
IE5JQz8NCg0KbG9uZyBsb25nIG5pZ2h0cyBvZiBkZXNwYWlyLg0KDQpXZSBoYWQgaXNzdWVzIHdp
dGggcmVjbGFpbSBwYXRoIHVwb24gQkFDSy4gVGhpcyBpcyBvZiBjb3Vyc2UgYSBmaXJtd2FyZQ0K
cHJvYmxlbS4uLg0KDQo+IA0KPiBLZXZpbiwgbWVhbndoaWxlIHlvdSBjb3VsZCBhZGQgdGhlIG9w
dGlvbiB0byB5b3VyIGRlZmF1bHQgbW9kdWxlDQo+IGNvbmZpZ3VyYXRpb24gc28gaXQgd291bGQg
YmUgdXNlZCBieSBkZWZhdWx0IG9uIHlvdXIgbWFjaGluZS4NCj4gDQo+IC0tDQo+IENoZWVycywN
Cj4gTHVjYS4NCj4gDQo+IA0KPiBPbiBUdWUsIDIwMTktMDMtMTIgYXQgMTE6MTIgLTA2MDAsIEtl
dmluIExvY2tlIHdyb3RlOg0KPiA+IEhpIFdpcmVsZXNzIERldmVsb3BlcnMsDQo+ID4gDQo+ID4g
SSBoYXZlIGEgTGVub3ZvIFRoaW5rUGFkIFQ0MzAgKDIzNDItQ1RPKSB3aXRoIGFuIEludGVsIENl
bnRyaW5vDQo+ID4gVWx0aW1hdGUtTiA2MzAwICg4MDg2OjQyMzgpIHdpcmVsZXNzIGNhcmQuICBX
aXRoIHRoZSBoZWxwIG9mDQo+ID4gUmV2ZW50bG92DQo+ID4gYW5kIGpvaGlsbCBvbiAjbGludXgt
d2lyZWxlc3MsIHdlIGRpc2NvdmVyZWQgdGhhdCBlbmFibGluZyBUWA0KPiA+IEFNUERVLA0KPiA+
IGJ5IHBhc3NpbmcgbW9kdWxlIG9wdGlvbiAxMW5fZGlzYWJsZT04IChJV0xfRU5BQkxFX0hUX1RY
QUdHKSB0bw0KPiA+IGl3bHdpZmksIGluY3JlYXNlZCBUQ1AgdGhyb3VnaHB1dCBzaWduaWZpY2Fu
dGx5Og0KPiA+IA0KPiA+IFdpdGggYW4gQVNVUyBSVC1BQ1JIMTMgQVAgYW5kIGBpcGVyZjMgLXNg
IHJ1bm5pbmcgb24gYSBzZXJ2ZXIgd2l0aA0KPiA+IGENCj4gPiAxR2JwcyB3aXJlZCBjb25uZWN0
aW9uLCBgaXBlcmYzIC1SIC1jYCBvbiB0aGUgVGhpbmtQYWQgaW5jcmVhc2VkDQo+ID4gZnJvbQ0K
PiA+IDYzLjIgdG8gMTA0IE1iaXRzL3NlYyAodXNpbmcgTUNTIDE1IDQwTUh6IHNob3J0IEdJKS4g
IFdpdGggYQ0KPiA+IEJ1ZmZhbG8NCj4gPiBXWlItNjAwREhQIHJ1bm5pbmcgT3BlbldSVCwgYGlw
ZXJmMyAtUiAtY2AgaW5jcmVhc2VkIGZyb20gNjMuMiB0bw0KPiA+IDc2LjkuDQo+ID4gDQo+ID4g
VFggQU1QRFUgd2FzIGRpc2FibGVkIGJ5IGRlZmF1bHQgZm9yIGFsbCBpd2xkdm0gY2FyZHMgaW4N
Cj4gPiAyMDVlMjIxMGRhYTkNCj4gPiBiZWNhdXNlICJpd2xkdm0gZG9uJ3QgaGFuZGxlIHdlbGwg
VFggQU1QRFUiLiAgSG93ZXZlciwgSSBoYXZlIGJlZW4NCj4gPiB1c2luZyB0aGlzIGNvbmZpZ3Vy
YXRpb24gZm9yID4yIHdlZWtzIHdpdGhvdXQgYW55IGlzc3VlcyBvcg0KPiA+IG1lYXN1cmFibGUN
Cj4gPiBjaGFuZ2UgaW4gcGluZyB0aW1lcyB0byB0aGUgQVAuICBBcmUgdGhlcmUgYW55IG90aGVy
IHBvdGVudGlhbA0KPiA+IHNpZGUtZWZmZWN0cyBJIGNhbiBjaGVjaz8NCj4gPiANCj4gPiBXb3Vs
ZCBpdCBiZSBwb3NzaWJsZSB0byBlbmFibGUgVFggQU1QRFUgYnkgZGVmYXVsdCBmb3IgYXQgbGVh
c3QNCj4gPiBzb21lDQo+ID4gb2YgdGhlc2UgY2FyZHM/ICBJZiBzbywgd2hhdCBhZGRpdGlvbmFs
IGluZm9ybWF0aW9uIHdvdWxkIGJlDQo+ID4gcmVxdWlyZWQ/DQo+ID4gDQo+ID4gVGhhbmtzIGZv
ciBjb25zaWRlcmluZywNCj4gPiBLZXZpbg0KPiA+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0NCj4gPiBsaW51eHdpZmlAZWNsaXN0cy5pbnRlbC5jb20NCj4gPiBodHRwczov
L2VjbGlzdHMuaW50ZWwuY29tL3N5bXBhL2luZm8vbGludXh3aWZpDQo+ID4gVW5zdWJzY3JpYmUg
Ynkgc2VuZGluZyBlbWFpbCB0byBzeW1wYUBlY2xpc3RzLmludGVsLmNvbSB3aXRoDQo+ID4gc3Vi
amVjdA0KPiA+ICJVbnN1YnNjcmliZSBsaW51eHdpZmkiDQo+IA0KPiANCg==
