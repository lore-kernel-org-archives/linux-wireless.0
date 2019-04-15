Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F0EC10F12
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 11:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C54420880
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 11:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfDOLCw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 07:02:52 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:22311 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727025AbfDOLCw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 07:02:52 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-58-z_q1LfrPMCqB2waVm49X5w-1; Mon, 15 Apr 2019 12:02:48 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 15 Apr 2019 12:03:57 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 15 Apr 2019 12:03:57 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alastair D'Silva' <alastair@d-silva.org>,
        'Petr Mladek' <pmladek@suse.com>
CC:     'Alastair D'Silva' <alastair@au1.ibm.com>,
        'Jani Nikula' <jani.nikula@linux.intel.com>,
        'Joonas Lahtinen' <joonas.lahtinen@linux.intel.com>,
        'Rodrigo Vivi' <rodrigo.vivi@intel.com>,
        'David Airlie' <airlied@linux.ie>,
        'Daniel Vetter' <daniel@ffwll.ch>,
        'Karsten Keil' <isdn@linux-pingi.de>,
        'Jassi Brar' <jassisinghbrar@gmail.com>,
        'Tom Lendacky' <thomas.lendacky@amd.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jose Abreu' <Jose.Abreu@synopsys.com>,
        'Kalle Valo' <kvalo@codeaurora.org>,
        'Stanislaw Gruszka' <sgruszka@redhat.com>,
        'Benson Leung' <bleung@chromium.org>,
        "'Enric Balletbo i Serra'" <enric.balletbo@collabora.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
        'Alexander Viro' <viro@zeniv.linux.org.uk>,
        'Sergey Senozhatsky' <sergey.senozhatsky@gmail.com>,
        'Steven Rostedt' <rostedt@goodmis.org>,
        'Andrew Morton' <akpm@linux-foundation.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: RE: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in
 hex_dump_to_buffer with flags
Thread-Topic: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in
 hex_dump_to_buffer with flags
Thread-Index: AQMagew30YCVD5mEhyHx4HPts9xr1ALvlgN3AdorRAgCCza9VAHVj+h+o2yMYSCAAAOL8P//96yAgAAUgpA=
Date:   Mon, 15 Apr 2019 11:03:57 +0000
Message-ID: <42fb90eb9c8f4ede8a56a09be90218e3@AcuMS.aculab.com>
References: <20190410031720.11067-1-alastair@au1.ibm.com>
 <20190410031720.11067-4-alastair@au1.ibm.com>
 <20190412141211.lvnz6wb7mwkykmxf@pathway.suse.cz>
 <093301d4f187$da0756a0$8e1603e0$@d-silva.org>
 <20190415092424.qos7d54nbyr5hphu@pathway.suse.cz>
 <0da301d4f373$01d5bb80$05813280$@d-silva.org>
 <10c791893f034c26b4fee1a4659133e5@AcuMS.aculab.com>
 <0db501d4f378$3bd50bb0$b37f2310$@d-silva.org>
In-Reply-To: <0db501d4f378$3bd50bb0$b37f2310$@d-silva.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: z_q1LfrPMCqB2waVm49X5w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

RnJvbTogQWxhc3RhaXIgRCdTaWx2YQ0KPiBTZW50OiAxNSBBcHJpbCAyMDE5IDExOjQ1DQouLi4N
Cj4gPiBBbHRob3VnaCBJIHRoaW5rIHlvdSdkIHdhbnQgYSAnbm8gaGV4JyBmbGFnIHRvIHN1cHBy
ZXNzIHRoZSBoZXguDQo+ID4NCj4gPiBQcm9iYWJseSBtb3JlIHVzZWZ1bCBmbGFncyBhcmUgb25l
cyB0byBzdXBwcmVzcyB0aGUgYWRkcmVzcyBjb2x1bW4uDQo+IA0KPiBUaGlzIGlzIGFscmVhZHkg
c3VwcG9ydGVkIGJ5IHRoZSBwcmVmaXhfdHlwZSBwYXJhbWV0ZXIgLSBhcmUgeW91IHByb3Bvc2lu
ZyB0aGF0IHdlIGVsaW1pbmF0ZSB0aGUNCj4gcGFyYW1ldGVyICYgY29tYmluZSBpdCB3aXRoIGZs
YWdzPw0KDQpJIHdhcyBsb29raW5nIGF0IHRoZSBmbGFncyBvbiBvbmUgb2YgbXkgaGV4ZHVtcCgp
IGZ1bmN0aW9ucy4uLg0KDQo+ID4gSSd2ZSBhbHNvIHVzZWQgZmxhZ3MgdG8gZW5hYmxlIChvciBk
aXNhYmxlKSBzdXBwcmVzc2lvbiBvZiBtdWx0aXBsZSBsaW5lcyBvZg0KPiA+IHplcm9zIG9mIGNv
bnN0YW50IGJ5dGVzLg0KPiA+IEluIHRoYXQgY2FzZSB5b3UgbWF5IHdhbnQgaGV4ZHVtcCB0byBy
ZXR1cm4gdGhlIGZsYWdzIGZvciB0aGUgbmV4dCBjYWxsIHdoZW4NCj4gPiBhIGxhcmdlIGJ1ZmZl
ciBpcyBiZWluZyBkdW1wZWQgaW4gZnJhZ21lbnRzLg0KPiANCj4gSSdtIGFmcmFpZCBJIGRvbid0
IHF1aXRlIGZvbGxvdyBoZXJlLCBoZXhfZHVtcF90b19idWZmZXIgZG9lc24ndCBhbHRlciB0aGUg
ZmxhZ3MsDQo+IHNvIHRoZSBjYWxsZXIgYWxyZWFkeSBrbm93cyBpdC4NCg0KSWYgeW91IGFyZSBz
dXBwcmVzc2luZyBsaW5lcyBvZiB6ZXJvcyBhbmQgZHVtcGluZyBhIGJ1ZmZlciBpbiBzZXZlcmFs
IGJsb2Nrcw0KdGhlbiBzdWJzZXF1ZW50IGNhbGxzIG5lZWQgdG8ga25vdyB0aGF0IHRoZSBsYXN0
IGxpbmUgb2YgdGhlIHByZXZpb3VzIGNhbGwNCndhcyBzdXBwcmVzc2VkIHplcm9zIC0gYW5kIGNh
cnJ5IG9uIHdpdGggdGhlIHNhbWUgc3VwcHJlc3NlZCBibG9jay4NCg0KSSd2ZSBub3QgbG9va2Vk
IHRvIHNlZSBpZiBpdCBkb2VzIHN1cHBvcnQgc3VwcHJlc3NpbmcgbGluZXMgb2YgemVyb3MvMHhm
Zi4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBS
b2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9u
IE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

