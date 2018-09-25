Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D0BC43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 11:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 568B020843
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 11:10:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 568B020843
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbeIYRRr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 13:17:47 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:58930 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728619AbeIYRRr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 13:17:47 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w8PBAZLV006857, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w8PBAZLV006857
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 25 Sep 2018 19:10:35 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Tue, 25 Sep
 2018 19:10:34 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>
Subject: RE: [RFC 00/12] rtwlan: mac80211 driver for Realtek 802.11ac wireless network chips
Thread-Topic: [RFC 00/12] rtwlan: mac80211 driver for Realtek 802.11ac
 wireless network chips
Thread-Index: AQHUVClmfShZef+yIU+HHwSs/fcbMKUA2DbA
Date:   Tue, 25 Sep 2018 11:10:33 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D08D7FB8@RTITMBSVM01.realtek.com.tw>
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
 <052723dc-c8b9-1a40-90a4-7c8ae2b29299@lwfinger.net>
In-Reply-To: <052723dc-c8b9-1a40-90a4-7c8ae2b29299@lwfinger.net>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.123]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IExhcnJ5IEZpbmdlciBbbWFp
bHRvOmxhcnJ5LmZpbmdlckBnbWFpbC5jb21dIE9uIEJlaGFsZiBPZiBMYXJyeSBGaW5nZXINCj4g
U2VudDogVHVlc2RheSwgU2VwdGVtYmVyIDI1LCAyMDE4IDE6MTAgQU0NCj4gVG86IFRvbnkgQ2h1
YW5nOyBrdmFsb0Bjb2RlYXVyb3JhLm9yZw0KPiBDYzogbGludXgtd2lyZWxlc3NAdmdlci5rZXJu
ZWwub3JnOyBQa3NoaWg7IEFuZHkgSHVhbmcNCj4gU3ViamVjdDogUmU6IFtSRkMgMDAvMTJdIHJ0
d2xhbjogbWFjODAyMTEgZHJpdmVyIGZvciBSZWFsdGVrIDgwMi4xMWFjDQo+IHdpcmVsZXNzIG5l
dHdvcmsgY2hpcHMNCj4gDQo+IE9uIDkvMjEvMTggMTowMyBBTSwgeWhjaHVhbmdAcmVhbHRlay5j
b20gd3JvdGU6DQo+ID4gRnJvbTogWWFuLUhzdWFuIENodWFuZyA8eWhjaHVhbmdAcmVhbHRlay5j
b20+DQo+ID4NCj4gPiBUaGlzIGlzIGEgbmV3IG1hYzgwMjExIGRyaXZlciBmb3IgUmVhbHRlayA4
MDIuMTFhYyB3aXJlbGVzcyBuZXR3b3JrIGNoaXBzLg0KPiA+IHJ0d2xhbiBzdXBwb3J0cyA4ODIy
QkUgYW5kIDg4MjJDRSBjaGlwcywgYW5kIHdpbGwgYmUgYWJsZSB0byBzdXBwb3J0DQo+ID4gbXVs
dGktdmlmIGNvbWJpbmF0aW9ucyBpbiBydW4tdGltZS4NCj4gPg0KPiA+IEZvciBub3csIG9ubHkg
UENJIGJ1cyBpcyBzdXBwb3J0ZWQsIGJ1dCBydHdsYW4gd2FzIG9yaWdpbmFsbHkgZGVzaWduZWQN
Cj4gPiB0byBvcHRpb25hbGx5IHN1cHBvcnQgdGhyZWUgYnVzZXMgaW5jbHVkZXMgVVNCICYgU0RJ
Ty4gVVNCICYgU0RJTyBtb2R1bGVzDQo+ID4gd2lsbCBzb29uIGJlIHN1cHBvcnRlZCBieSBydHds
YW4sIHdpdGggY29uZmlndXJhYmxlIGNvcmUgbW9kdWxlIHRvIGZpdA0KPiA+IHdpdGggZGlmZmVy
ZW50IGJ1cyBtb2R1bGVzIGluIHRoZSBzYW1lIHRpbWUuDQo+ID4NCj4gPiBGb3IgZXhhbXBsZSwg
aWYgd2UgY2hvb3NlIDg4MjJCRSBhbmQgODgyMkNVLCBvbmx5IFBDSSAmIFVTQiBtb2R1bGVzIHdp
bGwNCj4gPiBiZSBzZWxlY3RlZCwgYnVpbHQsIGxvYWRlZCBpbnRvIGtlcm5lbC4gVGhpcyBpcyBv
bmUgb2YgdGhlIG1ham9yDQo+ID4gZGlmZmVyZW5jZSBmcm9tIHJ0bHdpZmksIHdoaWNoIGNhbiBv
bmx5IHN1cHBvcnQgc3BlY2lmaWMgY29tYmluYXRpb25zLg0KPiA+DQo+ID4gQW5vdGhlciBkaWZm
ZXJlbmNlIGZyb20gcnRsd2lmaSBpcyB0aGF0IHJ0d2xhbiBpcyBkZXNpZ25lZCB0byBzdXBwb3J0
DQo+ID4gdGhlIGxhdGVzdCBSZWFsdGVrIDgwMi4xMWFjIHdpcmVsZXNzIG5ldHdvcmsgY2hpcHMg
bGlrZSA4ODIyQiBhbmQNCj4gPiA4ODIyQyBzZXJpZXMuIENvbXBhcmVkIHRvIHRoZSBlYXJsaWVy
IGNoaXBzIHN1cHBvcnRlZCBieSBydGx3aWZpIGxpa2UNCj4gPiB0aGUgODAyLjExbiA4MTkyRUUg
Y2hpcHNldCBvciA4MDIuMTFhYyA4ODIxQUUvODgxMkFFIGNoaXBzLCBuZXdlciBJQ3MNCj4gPiBo
YXZlIGRpZmZlcmVudCBNQUMgJiBQSFkgc2V0dGluZ3MsIHN1Y2ggYXMgbmV3IG11bHRpLXBvcnQg
ZmVhdHVyZSBmb3IgdGhlDQo+ID4gTUFDIGxheWVyIGRlc2lnbiBhbmQgSmFndWFyMi9KYWd1YXIz
IFBIWSBsYXllciBJUHMuDQo+ID4NCj4gPiBNdWx0aS1Qb3J0IGZlYXR1cmUgaXMgYWxzbyBzdXBw
b3J0ZWQgdW5kZXIgcnR3bGFuJ3Mgc29mdHdhcmUgYXJjaGl0ZWN0dXJlLg0KPiA+IHJ0bHdpZmkg
Y2FuIG9ubHkgc3VwcG9ydCBvbmUgdmlmIGluIHRoZSBzYW1lIHRpbWUsIG1vc3QgYmVjYXVzZSBv
ZiB0aGUNCj4gPiBoYXJkd2FyZSBsaW1pdGF0aW9ucyBmb3IgZWFybHkgY2hpcHMsIGhlbmNlIHRo
ZSBvcmlnaW5hbCBkZXNpZ24gb2YgaXQNCj4gPiBhbHNvIHJlc3RyaWN0cyB0aGUgdXNhZ2Ugb2Yg
bXVsdGktdmlmIHN1cHBvcnQsIHNvIGxhdGVzdCBjaGlwc2V0IHNlZW1zIG5vdA0KPiA+IHRha2Ug
YWR2YW50YWdlcyBmcm9tIGl0cyBuZXcgTUFDIGVuZ2luZS4NCj4gPg0KPiA+IEhvd2V2ZXIsIHJ0
d2xhbiBjYW4gcnVuIG11bHRpcGxlIHZpZnMgY29uY3VycmVudGx5IGJ5IGhvbGRpbmcgdGhlbSBv
bg0KPiA+IGhhcmR3YXJlIHBvcnRzIHByb3ZpZGVkIGJ5IE1BQyBlbmdpbmUsIHNvIHdlIGNhbiBl
YXNpbHkgc3RhcnQgZGlmZmVyZW50DQo+ID4gcm9sZXMgb24gYSBzaW5nbGUgZGV2aWNlLg0KPiA+
DQo+ID4gQmFzZWQgb24gdGhlIHJlYXNvbnMgbWVudGlvbmVkIGJlZm9yZSwgd2UgaW1wbGVtZW50
ZWQgcnR3bGFuLiBJdCBoYWQNCj4gbWFueQ0KPiA+IGF1dGhvcnMsIHRoZXkgYXJlIGxpc3RlZCBo
ZXJlIGFscGhhYmV0aWNhbGx5Og0KPiANCj4gSSBoYXZlIGZvdW5kIHR3byBwcm9ibGVtcyB3aXRo
IHRoZSBpbml0aWFsIGNvZGU6DQo+IA0KPiAxLiBUaGVyZSBpcyBhIG1pc3NpbmcgemVybyBlbnRy
eSBhdCB0aGUgZW5kIG9mIHRoZSBzdHJ1Y3QgcGNpX2RldmljZV9pZC4NCj4gMi4gWW91IGhhdmUg
bm8gTU9EVUxFX0RFVklDRV9UQUJMRSBtYWNybyBjYWxsLg0KPiANCj4gVGhlIGVmZmVjdCBpcyB0
aGF0IHRoZSBkZXZpY2UgaXMgbm90IGF1dG9sb2FkZWQgb24gYm9vdC4gVGhlIGZpeCBpcw0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3bGFuL3BjaS5j
DQo+IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHdsYW4vcGNpLmMNCj4gaW5kZXgg
MmZmNWExNTJkNzdiLi5mOGIxMjY3NTIwYTcgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL3JlYWx0ZWsvcnR3bGFuL3BjaS5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L3JlYWx0ZWsvcnR3bGFuL3BjaS5jDQo+IEBAIC0xMTg0LDYgKzExODQsNyBAQCBzdGF0aWMgY29u
c3Qgc3RydWN0IHBjaV9kZXZpY2VfaWQgcnR3X3BjaV9pZF90YWJsZVtdDQo+ID0gew0KPiAgICNp
ZmRlZiBDT05GSUdfUlRXTEFOXzg4MjJDRQ0KPiAgICAgICAgICB7IFJUS19QQ0lfREVWSUNFKFBD
SV9WRU5ET1JfSURfUkVBTFRFSywgMHhDODIyLA0KPiBydHc4ODIyY19od19zcGVjKSB9LA0KPiAg
ICNlbmRpZg0KPiArICAgICAgIHt9LA0KPiAgIH07DQo+IA0KPiAgIHN0YXRpYyBzdHJ1Y3QgcGNp
X2RyaXZlciBydHdfcGNpX2RyaXZlciA9IHsNCj4gQEAgLTEyMTAsNiArMTIxMSw4IEBAIHN0cnVj
dCBydHdfaGNpX29wcyBydHdfcGNpX29wcyA9IHsNCj4gICAgICAgICAgLmNoZWNrX2F2YWlsX2Rl
c2MgPSBydHdfcGNpX2NoZWNrX2F2YWlsX2Rlc2MsDQo+ICAgfTsNCj4gDQo+ICtNT0RVTEVfREVW
SUNFX1RBQkxFKHBjaSwgcnR3X3BjaV9pZF90YWJsZSk7DQo+ICsNCj4gICBtb2R1bGVfcGNpX2Ry
aXZlcihydHdfcGNpX2RyaXZlcik7DQo+IA0KPiAgIE1PRFVMRV9BVVRIT1IoIlJlYWx0ZWsgQ29y
cG9yYXRpb24iKTsNCj4gDQo+IExhcnJ5DQo+IA0KDQpUaGFua3MsIHdpbGwgYWRkIHRoZW0gaW50
byB0aGUgbmV4dCBSRkMuDQoNCllhbi1Ic3VhbiwgQ2h1YW5nDQo=
