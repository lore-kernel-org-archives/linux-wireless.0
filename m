Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0309DC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 04:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEF112070D
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 04:59:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbfCME7c (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 00:59:32 -0400
Received: from mga04.intel.com ([192.55.52.120]:47667 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbfCME7c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 00:59:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2019 21:59:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,473,1544515200"; 
   d="scan'208";a="141556209"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by orsmga002.jf.intel.com with ESMTP; 12 Mar 2019 21:59:31 -0700
Received: from fmsmsx115.amr.corp.intel.com (10.18.116.19) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 12 Mar 2019 21:59:31 -0700
Received: from hasmsx113.ger.corp.intel.com (10.184.198.64) by
 fmsmsx115.amr.corp.intel.com (10.18.116.19) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 12 Mar 2019 21:59:30 -0700
Received: from hasmsx112.ger.corp.intel.com ([169.254.11.157]) by
 HASMSX113.ger.corp.intel.com ([169.254.13.155]) with mapi id 14.03.0415.000;
 Wed, 13 Mar 2019 06:58:55 +0200
From:   "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To:     "kevin@kevinlocke.name" <kevin@kevinlocke.name>
CC:     linuxwifi <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: Re: [linuxwifi] [RFC] iwlwifi: enable TX AMPDU for some iwldvm
Thread-Topic: [linuxwifi] [RFC] iwlwifi: enable TX AMPDU for some iwldvm
Thread-Index: AQHU2PbGwTd9hj9DNU+dTGwq4/G/q6YIQsCAgAACgACAAAxOgIAABOwAgAAProCAAHlHgA==
Date:   Wed, 13 Mar 2019 04:58:54 +0000
Message-ID: <cdd094bd29f1e20dc5577fcbad6a7b404e66407a.camel@intel.com>
References: <20190312171205.GA12792@kevinolos>
         <0f9132187a5567fa94e396ed317efbae1aa4de14.camel@intel.com>
         <1b6eaef941d3bc887a9fbedea47c2677e5511cdd.camel@intel.com>
         <20190312203101.GA19902@kevinolos>
         <58bd45ab11912eef5c809427449a31800ecdbf53.camel@intel.com>
         <20190312214445.GA20993@kevinolos>
In-Reply-To: <20190312214445.GA20993@kevinolos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.12.206]
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D0C40EF629D5B43BFD15B9A4B0F4BB2@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gVHVlLCAyMDE5LTAzLTEyIGF0IDE1OjQ0IC0wNjAwLCBLZXZpbiBMb2NrZSB3cm90ZToNCj4g
T24gVHVlLCAyMDE5LTAzLTEyIGF0IDIwOjQ4ICswMDAwLCBHcnVtYmFjaCwgRW1tYW51ZWwgd3Jv
dGU6DQo+ID4gT24gVHVlLCAyMDE5LTAzLTEyIGF0IDE0OjMxIC0wNjAwLCBLZXZpbiBMb2NrZSB3
cm90ZToNCj4gPiA+IE9uIFR1ZSwgMjAxOS0wMy0xMiBhdCAxOTo0NyArMDAwMCwgR3J1bWJhY2gs
IEVtbWFudWVsIHdyb3RlOg0KPiA+ID4gPiBXZSBoYWQgaXNzdWVzIHdpdGggcmVjbGFpbSBwYXRo
IHVwb24gQkFDSy4gVGhpcyBpcyBvZiBjb3Vyc2UgYQ0KPiA+ID4gPiBmaXJtd2FyZSBwcm9ibGVt
Li4uDQo+ID4gPiANCj4gPiA+IERvZXMgdGhhdCBzdWdnZXN0IHRoZSBpc3N1ZSBtYXkgaGF2ZSBi
ZWVuIGZpeGVkIGJ5IGEgZmlybXdhcmUNCj4gPiA+IHVwZGF0ZT8NCj4gPiA+IEZvciByZWZlcmVu
Y2UsIEknbSBjdXJyZW50bHkgdXNpbmcgImZpcm13YXJlIHZlcnNpb24gOS4yMjEuNC4xDQo+ID4g
PiBidWlsZA0KPiA+ID4gMjU1MzIiIGZyb20gdGhlIGZpcm13YXJlLWl3bHdpZmkgRGViaWFuIHBh
Y2thZ2UgKHZlcnNpb24NCj4gPiA+IDIwMTkwMTE0LTEpLg0KPiA+ID4gDQo+ID4gPiBJZiBpdCB3
b3VsZCBiZSBoZWxwZnVsLCBJIGNvdWxkIGF0dGVtcHQgdG8gYmlzZWN0IHRoZSBmaXJtd2FyZQ0K
PiA+ID4gcmV2aXNpb25zIHRvIGZpbmQgdGhlIG9uZSB0aGF0IGZpeGVkIGl0IChhc3N1bWluZyBJ
IGNhbiByZXByb2R1Y2UNCj4gPiA+IHRoZQ0KPiA+ID4gaXNzdWUgd2l0aCBhIHByZXZpb3VzIGZp
cm13YXJlIHZlcnNpb24pLg0KPiA+IA0KPiA+IFdlbGwuLiBTb3JyeSwgSSB3YXNuJ3QgdmVyeSAi
dGVjaG5pY2FsIi4NCj4gPiBTbyB0aGUgcHJvYmxlbSB3YXMgcmVhbGx5IHRoYXQgd2Ugc3RvcHBl
ZCBnZXR0aW5nIEJBQ0sNCj4gPiBub3RpZmljYXRpb25zDQo+ID4gZnJvbSB0aGUgZmlybXdhcmUg
YW5kIHRoYXQgY2F1c2VkIGEgcmVjbGFpbSBzdGFsbCB3aGljaCBpbiB0dXJuIHdhcw0KPiA+IGNh
dWdodCBieSBhIFR4IHF1ZXVlIHN0dWNrIHRpbWVyIGZpcmluZyBpbiB0aGUgZHJpdmVyLg0KPiA+
IEkgd2FzIG5ldmVyIGFibGUgdG8gcmVwcm9kdWNlIHRoaXMuIFdoYXQgSSBjYW4gZG8gaXMgdG8g
ZW5hYmxlIEEtDQo+ID4gTVBEVQ0KPiA+IG9uIG15IG9sZCBzeXN0ZW0gdGhhdCBoYXMgdGhpcyBz
YW1lIGRldmljZSwganVzdCB0byBzZWUgd2hhdA0KPiA+IGhhcHBlbnMuDQo+IA0KPiBUaGFua3Mg
Zm9yIHRoZSBhZGRpdGlvbmFsIGRldGFpbHMgYW5kIGZvciBvZmZlcmluZyB0byB0cnkgaXQgb3V0
LA0KPiB0aGF0DQo+IHdvdWxkIGJlIGdyZWF0IQ0KDQpKdXN0IHRvIGFsaWduIG9uIGV4cGVjdGF0
aW9ucywgSSBkb24ndCBmZWVsIGxpa2UgZW5hYmxlIEEtTVBEVSBieQ0KZGVmYXVsdCByZWdhcmRs
ZXNzIG9mIHdoYXQgd2lsbCBjb21lIG91dCBvZiB0aGlzLiBQZW9wbGUgc3RvcHBlZA0KY29tcGxh
aW5pbmcgYWZ0ZXIgd2UgZGlzYWJsZWQgQS1NUERVIGFuZCB0aGUgdmVyeSB2ZXJ5IHZlcnkgZmV3
IHBlb3BsZQ0KdGhhdCBkaWQgbmVlZCBtb3JlIHRocm91Z2hwdXQga25ldyBob3cgdG8gZW5hYmxl
IHRoZW0gd2l0aCB0aGUgbW9kdWxlDQpwYXJhbWV0ZXIuIFNvLCBJIGRvbid0IHBsYW4gdG8gcmUt
ZW5hYmxlIEEtTVBEVSBieSBkZWZhdWx0Lg0KDQo+IA0KPiA+IFdoaWxlIGNoYXNpbmcgdGhpcyBi
dWcsIEkgZXZlbiBmb3VuZCBhbm90aGVyIG9uZSB3aGljaCBib3VnaHQgbWUgYQ0KPiA+IGZldw0K
PiA+IG1vbWVudHMgb2YgZmFtZToNCj4gPiANCj4gPiBjb21taXQgZDZlZTI3ZWIxM2JlYWI5NDA1
NmUwZGU1MmQ4MTIyMDA1OGNhMjI5Nw0KPiA+IEF1dGhvcjogRW1tYW51ZWwgR3J1bWJhY2ggPGVt
bWFudWVsLmdydW1iYWNoQGludGVsLmNvbT4NCj4gPiBEYXRlOiAgIFdlZCBKdW4gNiAwOToxMzoz
NiAyMDEyICswMjAwDQo+ID4gDQo+ID4gICAgIGl3bHdpZmk6IGRvbid0IG1lc3MgdXAgdGhlIFND
RCB3aGVuIHJlbW92aW5nIGEga2V5DQo+ID4gDQo+ID4gYW5kIGluIHRoZSBjb21taXQgbWVzc2Fn
ZSBvZiB0aGF0IHZlcnkgY29tbWl0Og0KPiA+IA0KPiA+ICAgICBUaGlzIGRvZXNuJ3Qgc2VlbSB0
byBmaXggdGhlIGhpZ2hlciBxdWV1ZXMgdGhhdCBnZXQgc3R1Y2sNCj4gPiAgICAgZnJvbSB0aW1l
IHRvIHRpbWUuDQo+ID4gDQo+ID4gVGhlcmUgd2VyZSBubyBuZXcgdmVyc2lvbnMgb2YgdGhlIGZp
cm13YXJlIHJlbGVhc2VkIHNpbmNlIHRoZW4uDQo+ID4gSSB0cmllZCB0byBza2ltIHRocm91Z2gg
YnVnemlsbGEsIGJ1dCBjb3VsZG4ndCBmaW5kIHRoZSBidWdzIEkgd2FzDQo+ID4gaGFuZGxpbmcg
dGhlbi4NCj4gDQo+IEFoLiAgWW91IGFyZSByaWdodCBhYm91dCB0aGUgZmlybXdhcmUgdmVyc2lv
bi4gIEkgc2hvdWxkIGhhdmUNCj4gY2hlY2tlZC4NCj4gDQo+IEkgc2VlIHdoYXQgeW91IG1lYW4u
ICBJIGZvdW5kIHNldmVyYWwgcmVwb3J0cyBmb3IgVFggcXVldWUgc3R1Y2sNCj4gaXNzdWVzIGlu
IEJ1Z3ppbGxhLiAgUGVyaGFwcyB0aGlzIGlzIG9uZSAob3Igb25lIG9mIGl0cyBtYW55IGR1cHMp
Og0KPiBodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTU2NTgxDQo+
IA0KDQpBbmQgdGhvc2Ugd2VyZSB2ZXJ5IHZlcnkgdGltZSBjb25zdW1pbmcuIEkgZG9uJ3Qgd2Fu
dCB0byBnbyB0aGVyZQ0KYWdhaW4uIFRoZXNlIGFyZSB2ZXJ5IG9sZCBkZXZpY2VzICh0aGV5IHdl
cmUgZGVzY3JpYmVkIGFzIG9sZCBpbiAyMDE0DQphbHJlYWR5Li4uKS4NCg0KPiBMZXQgbWUga25v
dyBpZiB0aGVyZSBpcyBhbnl0aGluZyBJIGNhbiBkbyB0byBoZWxwIHNlYXJjaCBvciB0ZXN0Lg0K
PiANCj4gVGhhbmtzIGFnYWluLA0KPiBLZXZpbg0K
