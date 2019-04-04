Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84AF1C10F0C
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 16:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DB45206BA
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 16:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbfDDQXM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 12:23:12 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:35535 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727489AbfDDQXL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 12:23:11 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-152-tcrawFhSMySPDwlHVrKWFw-1; Thu, 04 Apr 2019 17:23:09 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Thu,
 4 Apr 2019 17:24:15 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 4 Apr 2019 17:24:15 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Fenghua Yu' <fenghua.yu@intel.com>,
        'Thomas Gleixner' <tglx@linutronix.de>,
        'Ingo Molnar' <mingo@redhat.com>,
        'Borislav Petkov' <bp@alien8.de>,
        'H Peter Anvin' <hpa@zytor.com>,
        'Dave Hansen' <dave.hansen@intel.com>,
        'Paolo Bonzini' <pbonzini@redhat.com>,
        'Ashok Raj' <ashok.raj@intel.com>,
        'Peter Zijlstra' <peterz@infradead.org>,
        'Kalle Valo' <kvalo@codeaurora.org>,
        'Xiaoyao Li ' <xiaoyao.li@intel.com>,
        'Michael Chan' <michael.chan@broadcom.com>,
        "'Ravi V Shankar'" <ravi.v.shankar@intel.com>
CC:     'linux-kernel' <linux-kernel@vger.kernel.org>,
        'x86' <x86@kernel.org>,
        "'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>
Subject: RE: [PATCH v6 04/20] x86/split_lock: Align x86_capability to unsigned
 long to avoid split locked access
Thread-Topic: [PATCH v6 04/20] x86/split_lock: Align x86_capability to
 unsigned long to avoid split locked access
Thread-Index: AQHU6mTrt6127B4KeUCFmArv0ksdfKYsEdZAgAAdv4A=
Date:   Thu, 4 Apr 2019 16:24:15 +0000
Message-ID: <c0d43317cce34389ac4a1e91e97d909b@AcuMS.aculab.com>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
 <1554326526-172295-5-git-send-email-fenghua.yu@intel.com>
 <73ecc9de54c3424da3cddd1a34cb8701@AcuMS.aculab.com>
In-Reply-To: <73ecc9de54c3424da3cddd1a34cb8701@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: tcrawFhSMySPDwlHVrKWFw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

RnJvbTogRGF2aWQgTGFpZ2h0DQo+IFNlbnQ6IDA0IEFwcmlsIDIwMTkgMTU6NDUNCj4gDQo+IEZy
b206IEZlbmdodWEgWXUNCj4gPiBTZW50OiAwMyBBcHJpbCAyMDE5IDIyOjIyDQo+ID4gc2V0X2Nw
dV9jYXAoKSBjYWxscyBsb2NrZWQgQlRTIGFuZCBjbGVhcl9jcHVfY2FwKCkgY2FsbHMgbG9ja2Vk
IEJUUiB0bw0KPiA+IG9wZXJhdGUgb24gYml0bWFwIGRlZmluZWQgaW4geDg2X2NhcGFiaWxpdHku
DQo+ID4NCj4gPiBMb2NrZWQgQlRTL0JUUiBhY2Nlc3NlcyBhIHNpbmdsZSB1bnNpZ25lZCBsb25n
IGxvY2F0aW9uLiBJbiA2NC1iaXQgbW9kZSwNCj4gPiB0aGUgbG9jYXRpb24gaXMgYXQ6DQo+ID4g
YmFzZSBhZGRyZXNzIG9mIHg4Nl9jYXBhYmlsaXR5ICsgKGJpdCBvZmZzZXQgaW4geDg2X2NhcGFi
aWxpdHkgLyA2NCkgKiA4DQo+ID4NCj4gPiBTaW5jZSBiYXNlIGFkZHJlc3Mgb2YgeDg2X2NhcGFi
aWxpdHkgbWF5IG5vdCBiZSBhbGlnbmVkIHRvIHVuc2lnbmVkIGxvbmcsDQo+ID4gdGhlIHNpbmds
ZSB1bnNpZ25lZCBsb25nIGxvY2F0aW9uIG1heSBjcm9zcyB0d28gY2FjaGUgbGluZXMgYW5kDQo+
ID4gYWNjZXNzaW5nIHRoZSBsb2NhdGlvbiBieSBsb2NrZWQgQlRTL0JUUiBpbnRyb2R1Y3Rpb25z
IHdpbGwgdHJpZ2dlciAjQUMuDQo+IA0KPiBUaGF0IGlzIG5vdCB0cnVlLg0KPiBUaGUgQlRTL0JU
UiBpbnN0cnVjdGlvbnMgYWNjZXNzIHRoZSBtZW1vcnkgd29yZCB0aGF0IGNvbnRhaW5zIHRoZQ0K
PiBleHBlY3RlZCBiaXQuDQo+IFRoZSAnb3BlcmFuZCBzaXplJyBvbmx5IGFmZmVjdHMgdGhlIHNp
emUgb2YgdGhlIHJlZ2lzdGVyIHVzZSBmb3IgdGhlDQo+IGJpdCBvZmZzZXQuDQo+IElmIHRoZSAn
b3BlcmFuZCBzaXplJyBpcyAxNiBiaXRzIHdpZGUgKCsvLSAzMmsgYml0IG9mZnNldCkgdGhlIGNw
dSBtaWdodA0KPiBkbyBhbiBhbGlnbmVkIDE2Yml0IG1lbW9yeSBhY2Nlc3MsIG90aGVyd2lzZSAo
MzIgb3IgNjRiaXQgYml0IG9mZnNldCkgaXQNCj4gbWlnaHQgZG8gYW4gYWxpZ25lZCAzMiBiaXQg
YWNjZXNzLg0KPiBJdCBzaG91bGQgbmV2ZXIgZG8gYW4gNjRiaXQgYWNjZXNzIGFuZCBuZXZlciBh
IG1pc2FsaWduZWQgb25lIChldmVuIGlmDQo+IHRoZSBiYXNlIGFkZHJlc3MgaXMgbWlzYWxpZ25l
ZCkuDQoNCkhtbW0uLi4gSSBtYXkgaGF2ZSBtaXNyZWFkIHRoaW5ncyBzbGlnaHRseS4NClRoZSBh
Y2Nlc3NlZCBhZGRyZXNzIGlzICdFZmZlY3RpdmUgQWRkcmVzcyArICg0IOKIlyAoQml0T2Zmc2V0
IERJViAzMikpJy4NCkhvd2V2ZXIgbm90aGluZyBzdWdnZXN0cyB0aGF0IGl0IGV2ZXIgZG9lcyA2
NGJpdCBhY2Nlc3Nlcy4NCg0KSWYgaXQgZG9lcyBkbyA2NGJpdCBhY2Nlc3NlcyB3aGVuIHRoZSBv
cGVyYW5kIHNpemUgaXMgNjQgYml0cyB0aGVuIHRoZQ0KYXNtIHN0dWJzIG91Z2h0IHRvIGJlIGNo
YW5nZWQgdG8gb25seSBzcGVjaWZ5IDMyYml0IG9wZXJhbmQgc2l6ZS4NCg0KCURhdmlkDQoNCi0N
ClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBN
aWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxl
cykNCg==

