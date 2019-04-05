Return-Path: <SRS0=iN42=SH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C39DC4360F
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 09:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77EB5217D4
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 09:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730516AbfDEJWz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Apr 2019 05:22:55 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:32816 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729792AbfDEJWz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Apr 2019 05:22:55 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-46-Dt0vwYpzMOC1c-bTu-iR7Q-1; Fri, 05 Apr 2019 10:22:52 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 5 Apr 2019 10:23:59 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 5 Apr 2019 10:23:59 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Thomas Gleixner' <tglx@linutronix.de>
CC:     'Fenghua Yu' <fenghua.yu@intel.com>,
        'Ingo Molnar' <mingo@redhat.com>,
        'Borislav Petkov' <bp@alien8.de>,
        'H Peter Anvin' <hpa@zytor.com>,
        "'Dave Hansen'" <dave.hansen@intel.com>,
        'Paolo Bonzini' <pbonzini@redhat.com>,
        'Ashok Raj' <ashok.raj@intel.com>,
        'Peter Zijlstra' <peterz@infradead.org>,
        'Kalle Valo' <kvalo@codeaurora.org>,
        'Xiaoyao Li ' <xiaoyao.li@intel.com>,
        'Michael Chan' <michael.chan@broadcom.com>,
        'Ravi V Shankar' <ravi.v.shankar@intel.com>,
        'linux-kernel' <linux-kernel@vger.kernel.org>,
        'x86' <x86@kernel.org>,
        "'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>
Subject: RE: [PATCH v6 04/20] x86/split_lock: Align x86_capability to unsigned
 long to avoid split locked access
Thread-Topic: [PATCH v6 04/20] x86/split_lock: Align x86_capability to
 unsigned long to avoid split locked access
Thread-Index: AQHU6mTrt6127B4KeUCFmArv0ksdfKYsEdZAgAAdv4D///hjgIABIu0A
Date:   Fri, 5 Apr 2019 09:23:59 +0000
Message-ID: <4eb8949c2351479993027459644e0446@AcuMS.aculab.com>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
 <1554326526-172295-5-git-send-email-fenghua.yu@intel.com>
 <73ecc9de54c3424da3cddd1a34cb8701@AcuMS.aculab.com>
 <c0d43317cce34389ac4a1e91e97d909b@AcuMS.aculab.com>
 <alpine.DEB.2.21.1904041833480.1802@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1904041833480.1802@nanos.tec.linutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: Dt0vwYpzMOC1c-bTu-iR7Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

RnJvbTogVGhvbWFzIEdsZWl4bmVyIFttYWlsdG86dGdseEBsaW51dHJvbml4LmRlXQ0KPiANCj4g
T24gVGh1LCA0IEFwciAyMDE5LCBEYXZpZCBMYWlnaHQgd3JvdGU6DQouLi4NCj4gYml0b3BzIG9w
ZXJhdGUgb24gdW5zaWduZWQgbG9uZyBhcnJheXMsIHNvIHRoZSBSTVcgb24gdGhlIGFmZmVjdGVk
IGFycmF5DQo+IG1lbWJlciBoYXMgdG8gYmUgYXRvbWljIHZzLiBvdGhlciBSTVcgb3BlcmF0aW9u
cyBvbiB0aGUgc2FtZSBhcnJheQ0KPiBtZW1iZXIuIElmIHdlIG1ha2UgdGhlIGJpdG9wcyAzMmJp
dCB3aWRlIG9uIHg4Ni82NCB3ZSBicmVhayB0aGF0Lg0KPiANCj4gU28gc2VsZWN0aW5nIDY0Yml0
IGFjY2VzcyAoUkVYLlcgcHJlZml4KSBpcyBjb3JyZWN0IGFuZCBoYXMgdG8gc3RheS4NCg0KRXZl
biBpZiB0aGUgbG9jayBoYWQgYSBmaW5lIGdyYW51bGFyaXR5IGl0IHNob3VsZG4ndCBtYXR0ZXIg
d2hldGhlcg0KdHdvIFJNVyBvcGVyYXRpb25zIG9uIGRpZmZlcmVudCBwYXJ0cyBvZiB0aGUgc2Ft
ZSAnbG9uZycgaGFwcGVuZWQNCmF0IHRoZSBzYW1lIHRpbWUuDQpJU1RSIHNvbWUgb2YgdGhlICdj
b25zdGFudCBiaXQgb2Zmc2V0JyBhcmUgZG9uZSB3aXRoIGJ5dGUgc2l6ZWQNCmxvY2tlZCB0cmFu
c2ZlcnMuDQoNClRoZSBwcm9ibGVtIGhlcmUgaXMgdGhhdCB0aGUgYml0bWFwIGlzIGRlZmluZWQg
YXMgX191MzJbXSBub3QNCnVuc2lnbmVkIGxvbmdbXS4NCg0KLQlfX3UzMgkJCXg4Nl9jYXBhYmls
aXR5W05DQVBJTlRTICsgTkJVR0lOVFNdOw0KKwkvKiBVbnNpZ25lZCBsb25nIGFsaWdubWVudCB0
byBhdm9pZCBzcGxpdCBsb2NrIGluIGF0b21pYyBiaXRtYXAgb3BzICovDQorCV9fdTMyCQkJeDg2
X2NhcGFiaWxpdHlbTkNBUElOVFMgKyBOQlVHSU5UU10NCisJCQkJX19hbGlnbmVkKHNpemVvZih1
bnNpZ25lZCBsb25nKSk7DQoNClNvbWV3aGVyZSB0aGVyZSBpcyBhIGNhc3QuLi4uLg0KDQoJRGF2
aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50
IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTcz
ODYgKFdhbGVzKQ0K

