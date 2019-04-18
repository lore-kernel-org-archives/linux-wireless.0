Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1E9C10F0E
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 13:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EB5E217D7
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 13:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389016AbfDRNZI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:25:08 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:41921 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733192AbfDRNZI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 09:25:08 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-17-B7dANWa6PEWHAhN1ybAteA-1; Thu, 18 Apr 2019 14:25:05 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 18 Apr 2019 14:26:15 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 18 Apr 2019 14:26:15 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Thomas Gleixner' <tglx@linutronix.de>
CC:     'Fenghua Yu' <fenghua.yu@intel.com>,
        'Ingo Molnar' <mingo@redhat.com>,
        'Borislav Petkov' <bp@alien8.de>,
        'H Peter Anvin' <hpa@zytor.com>,
        "'Paolo Bonzini'" <pbonzini@redhat.com>,
        'Dave Hansen' <dave.hansen@intel.com>,
        'Ashok Raj' <ashok.raj@intel.com>,
        'Peter Zijlstra' <peterz@infradead.org>,
        'Ravi V Shankar' <ravi.v.shankar@intel.com>,
        'Xiaoyao Li ' <xiaoyao.li@intel.com>,
        'Christopherson Sean J' <sean.j.christopherson@intel.com>,
        'Kalle Valo' <kvalo@codeaurora.org>,
        'Michael Chan' <michael.chan@broadcom.com>,
        'linux-kernel' <linux-kernel@vger.kernel.org>,
        'x86' <x86@kernel.org>,
        "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v7 04/21] x86/split_lock: Align x86_capability to unsigned
 long to avoid split locked access
Thread-Topic: [PATCH v7 04/21] x86/split_lock: Align x86_capability to
 unsigned long to avoid split locked access
Thread-Index: AQHU9Wc8cfw3/6sx9k22vKHnyDMwNqZBowBwgAAfOzD///urAIAAIrYggAAIWHA=
Date:   Thu, 18 Apr 2019 13:26:15 +0000
Message-ID: <43db378b84c54908bd2fbf305dd9f8ec@AcuMS.aculab.com>
References: <1555536851-17462-1-git-send-email-fenghua.yu@intel.com>
 <1555536851-17462-5-git-send-email-fenghua.yu@intel.com>
 <c8ca959a4bc549b59baca563660d42d6@AcuMS.aculab.com>
 <698b9419c81b443fb9c180d2b27fd34a@AcuMS.aculab.com>
 <alpine.DEB.2.21.1904181347210.3174@nanos.tec.linutronix.de>
 <aceeddaa107a4aed9add47945acaa129@AcuMS.aculab.com>
In-Reply-To: <aceeddaa107a4aed9add47945acaa129@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: B7dANWa6PEWHAhN1ybAteA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

RnJvbTogRGF2aWQgTGFpZ2h0DQo+IFNlbnQ6IDE4IEFwcmlsIDIwMTkgMTQ6MTUNCi4uLg0KPiBS
dW5uaW5nDQo+IGdyZXAgLXIgLS1pbmNsdWRlICcqLltjaF0nICdfYml0KFteKF0qLCAqKFteKV0q
ICcgLg0KPiBvdmVyIHRoZSBlbnRpcmUga2VybmVsIHNvdXJjZSB0cmVlIHNob3dzIHF1aXRlIGEg
ZmV3ICdkdWJpb3VzJyBjYXN0cy4NCj4gDQo+IFRoZXknbGwgYmUgZG91Ymx5IGR1YmlvdXMgb24g
QkUgc3lzdGVtcy4NCg0KVGhlIGFsdGVybmF0ZSBwYXR0ZXJuOg0KZ3JlcCAtciAtLWluY2x1ZGUg
JyouW2NoXScgJ19iaXQoW14oXSosICooW14pXSpcKiknIC4NCmhhcyBhIGZldyBsZXNzIGZhbHNl
IHBvc2l0aXZlcyBhbmQgZGV0ZWN0cyBzb21lIGV4dHJhcyB3aXRoICh2b2lkKikmZm9vLT5iYXIu
DQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9h
ZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBO
bzogMTM5NzM4NiAoV2FsZXMpDQo=

