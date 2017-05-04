Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1966 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751136AbdEDNNt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 May 2017 09:13:49 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
        "k.eugene.e@gmail.com" <k.eugene.e@gmail.com>,
        Andy Gross <andy.gross@linaro.org>,
        David Brown <david.brown@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-soc@vger.kernel.org" <linux-soc@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "wcn36xx@lists.infradead.org" <wcn36xx@lists.infradead.org>,
        "nicolas.dechesne@linaro.org" <nicolas.dechesne@linaro.org>
Subject: Re: [PATCH 1/2] wcn36xx: Pass used skb to ieee80211_tx_status()
Date: Thu, 4 May 2017 13:13:43 +0000
Message-ID: <87fugkrchl.fsf@kamboji.qca.qualcomm.com> (sfid-20170504_151518_358821_FAFEB77C)
References: <20170426220444.10539-1-bjorn.andersson@linaro.org>
        <1493281332.2529.1.camel@sipsolutions.net>      <20170428234247.GQ15143@minitux>
In-Reply-To: <20170428234247.GQ15143@minitux> (Bjorn Andersson's message of
        "Fri, 28 Apr 2017 16:42:47 -0700")
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Qmpvcm4gQW5kZXJzc29uIDxiam9ybi5hbmRlcnNzb25AbGluYXJvLm9yZz4gd3JpdGVzOg0KDQo+
IE9uIFRodSAyNyBBcHIgMDE6MjIgUERUIDIwMTcsIEpvaGFubmVzIEJlcmcgd3JvdGU6DQo+DQo+
PiANCj4+ID4gQEAgLTM3MSw3ICszNzEsNyBAQCBzdGF0aWMgdm9pZCByZWFwX3R4X2R4ZXMoc3Ry
dWN0IHdjbjM2eHggKndjbiwNCj4+ID4gc3RydWN0IHdjbjM2eHhfZHhlX2NoICpjaCkNCj4+ID4g
wqAJCQlpbmZvID0gSUVFRTgwMjExX1NLQl9DQihjdGwtPnNrYik7DQo+PiA+IMKgCQkJaWYgKCEo
aW5mby0+ZmxhZ3MgJg0KPj4gPiBJRUVFODAyMTFfVFhfQ1RMX1JFUV9UWF9TVEFUVVMpKSB7DQo+
PiA+IMKgCQkJCS8qIEtlZXAgZnJhbWUgdW50aWwgVFggc3RhdHVzIGNvbWVzDQo+PiA+ICovDQo+
PiA+IC0JCQkJaWVlZTgwMjExX2ZyZWVfdHhza2Iod2NuLT5odywgY3RsLQ0KPj4gPiA+c2tiKTsN
Cj4+ID4gKwkJCQlpZWVlODAyMTFfdHhfc3RhdHVzKHdjbi0+aHcsIGN0bC0NCj4+ID4gPnNrYik7
DQo+PiA+IA0KPj4gDQo+PiBJIGRvbid0IHRoaW5rIHRoaXMgaXMgYSBnb29kIGlkZWEuDQo+DQo+
IFRoYW5rcyBmb3IgbGV0dGluZyBtZSBrbm93IDopDQo+DQo+PiBUaGlzIGNvZGUgaW50ZW50aW9u
YWxseSBjaGVja2VkIGlmIFRYIHN0YXR1cyB3YXMgcmVxdWVzdGVkLCBhbmQgaWYgbm90DQo+PiB0
aGVuIGl0IGRvZXNuJ3QgZ28gdG8gdGhlIGVmZm9ydCBvZiBidWlsZGluZyBpdC4NCj4+IA0KPg0K
PiBXaGF0IEknbSBmaW5kaW5nIHB1enpsaW5nIGlzIHRoZSBmYWN0IHRoYXQgdGhlIG9ubHkgY2Fs
bGVyIG9mDQo+IGllZWU4MDIxMV9sZWRfdHgoKSBpcyBpZWVlODAyMTFfdHhfc3RhdHVzKCkgYW5k
IGl0IHNlZW1zIGxpa2UgZHJpdmVycywNCj4gc3VjaCBhcyBhdGgxMGssIGNhbGwgdGhpcyBmb3Ig
ZWFjaCBwYWNrZXQgaGFuZGxlZCAtIGJ1dCBJJ20gbGlrZWx5DQo+IG1pc3Npbmcgc29tZXRoaW5n
Lg0KPg0KPj4gQXMgaXQgaXMgd2l0aCB5b3VyIHBhdGNoLCBpdCdsbCBnbyBhbmQgcmVwb3J0IHRo
ZSBUWCBzdGF0dXMgd2l0aG91dCBhbnkNCj4+IFRYIHN0YXR1cyBpbmZvcm1hdGlvbiAtIHdoaWNo
IGlzIGhhbmRsZWQgaW4gd2NuMzZ4eF9keGVfdHhfYWNrX2luZCgpDQo+PiBmb3IgdGhvc2UgZnJh
bWVzIG5lZWRpbmcgaXQuDQo+PiANCj4NCj4gUmlnaHQsIGl0IGRvZXNuJ3Qgc291bmQgZGVzaXJl
ZC4gSG93ZXZlciwgZHVyaW5nIG5vcm1hbCBvcGVyYXRpb24gSSdtDQo+IG5vdCBzZWVpbmcgSUVF
RTgwMjExX1RYX0NUTF9SRVFfVFhfU1RBVFVTIGJlaW5nIHNldCBhbmQgYXMgc3VjaA0KPiBpZWVl
ODAyMTFfbGVkX3R4KCkgaXMgbmV2ZXIgY2FsbGVkLg0KDQpTbyB3aGF0J3MgdGhlIGNvbmNsdXNp
b24/IEhvdyBkbyB3ZSBnZXQgbGVkcyB3b3JraW5nPw0KDQotLSANCkthbGxlIFZhbG8=
