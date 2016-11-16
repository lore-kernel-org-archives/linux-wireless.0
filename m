Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.eu1.fugro.com ([46.34.88.151]:37019 "EHLO
        smtp.eu1.fugro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751572AbcKPIy7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 03:54:59 -0500
From: "Stam, Michel [FINT]" <m.stam@fugro.com>
To: Adrian Chadd <adrian@freebsd.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Antonio Quartulli" <a@unstable.cc>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Antonio Quartulli <antonio@open-mesh.com>
Subject: RE: [ath9k-devel] [NOT FOR MERGE] ath9k: work around key cache
 corruption
Date: Wed, 16 Nov 2016 08:54:56 +0000
Message-ID: <9830b4f752fd4837ae0fbf9b0a32e1e9@nldataex02.ad.fugro.com> (sfid-20161116_095504_297277_973E2C8E)
References: <20161018083552.28592-1-a@unstable.cc>
 <87lgxbxl2d.fsf@purkki.adurom.net> <20161026141016.GB26376@prodigo.lan>
 <87bmy65nz8.fsf@kamboji.qca.qualcomm.com>
 <62a2dc74-4a7c-d3d4-4170-4d5759b07ab3@dd-wrt.com>
 <1477580802.4534.20.camel@sipsolutions.net>
 <4fd6af4b02474a3eb4acfbe421bd6a24@nldataex02.ad.fugro.com>
 <CAJ-VmonW7jR0vnnZmj8CsvY-6-O--L68LpBxcuXQ8Pk46AOQNQ@mail.gmail.com>
In-Reply-To: <CAJ-VmonW7jR0vnnZmj8CsvY-6-O--L68LpBxcuXQ8Pk46AOQNQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGV5IEFkcmlhbiwNCg0KU291bmRzIGxpa2UgYW4gaWRlYSwgYWx0aG91Z2ggdXAgdG8gdGhpcyBw
b2ludCBJIGhhdmUgbm90IGJlZW4gYWJsZSB0byBkZXRlY3Qgd2hldGhlciByZXBsdW1iaW5nIGlz
IG5lY2Vzc2FyeS4gZGVjcnlwdF9lcnJvcnMgZG9lcyBub3QgaW5jcmVtZW50IGV4cG9uZW50aWFs
bHkgb24gdGhlIHJlY2VpdmUgcGF0aCwgYXMgZmFyIGFzIEkgc2F3IG9ubHkgb25lIGRlY3J5cHRf
ZXJyb3IgY29tZXMgdGhyb3VnaCwgd2hpY2ggY291bGQganVzdCBhcyB3ZWxsIGJlIGEgY29ycnVw
dGVkIGZyYW1lLiBJIGhhdmUgbm90IHNlZW4gYW55IG90aGVyIGluZGljYXRvcnMgb2YgdGhpcyBp
c3N1ZSwgb3RoZXIgdGhhbiBhIGNvbXBsZXRlIGxhY2sgb2YgY29ubmVjdGl2aXR5IG9uIHVuaWNh
c3QgZnJhbWVzLg0KDQpTbyB0aGlzIGF0dGVtcHQgd2FzIHRvIHNlZSBpZiBJIGNvdWxkIGdldCB0
aGUgbGluayBzdGFibGUsIGluIGFueSB3YXkgcG9zc2libGUsIGJ5IGJsYW5rbHkgcmVwbHVtYmlu
ZyBvbiBldmVyeSByZWtleS4gVGhpcyBzaG91bGQsIGluIHRoZW9yeSAic29sdmUiIHRoZSBpc3N1
ZSwgYWx0aG91Z2ggYXQgdGhlIGNvc3Qgb2YgaHVnZSBwYWNrZXQgbG9zcy4gU28gZmFyLCBubyBn
by4NCg0KSSBhZ3JlZSB0aGF0IHNvbWUgZm9ybSBvZiBrZXkgY2FjaGluZyBtYXkgYmUgbmVjZXNz
YXJ5LiBJdCBpcyBhIHBpdHksIGJlY2F1c2UgdGhlIG1hYzgwMjExIGxheWVyIGRvZXMgaGF2ZSBh
biBpbnRlcmZhY2UgZm9yIGdyYWJiaW5nIHRoZSBrZXlzLCBhbHRob3VnaCBpdCByZXF1aXJlcyB0
aGUgcnRubF9sb2NrLiBBcyBmYXIgYXMgSSBzYXcsIG9ubHkgdGhlIEludGVsIHdpcmVsZXNzIGRy
aXZlciB1c2VzIGl0IHRvIHdyaXRlIHRoZSBrZXlzIGJhY2sgaW50byB0aGUgY2hpcCB1cG9uIHJl
c3VtaW5nIGZyb20gYSBsb3ctcG93ZXIgc3RhdGUuDQoNCktpbmQgcmVnYXJkcywNCkZ1Z3JvIElu
dGVyc2l0ZSBCLlYuDQoNCk1pY2hlbCBTdGFtDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0K
RnJvbTogYWRyaWFuLmNoYWRkQGdtYWlsLmNvbSBbbWFpbHRvOmFkcmlhbi5jaGFkZEBnbWFpbC5j
b21dIE9uIEJlaGFsZiBPZiBBZHJpYW4gQ2hhZGQNClNlbnQ6IFR1ZXNkYXksIE5vdmVtYmVyIDE1
LCAyMDE2IDA6MjUgQU0NClRvOiBTdGFtLCBNaWNoZWwgW0ZJTlRdDQpDYzogSm9oYW5uZXMgQmVy
ZzsgU2ViYXN0aWFuIEdvdHRzY2hhbGw7IEthbGxlIFZhbG87IEFudG9uaW8gUXVhcnR1bGxpOyBh
dGg5ay1kZXZlbEBsaXN0cy5hdGg5ay5vcmc7IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9y
ZzsgQW50b25pbyBRdWFydHVsbGkNClN1YmplY3Q6IFJlOiBbYXRoOWstZGV2ZWxdIFtOT1QgRk9S
IE1FUkdFXSBhdGg5azogd29yayBhcm91bmQga2V5IGNhY2hlIGNvcnJ1cHRpb24NCg0KSGl5YSwN
Cg0KbWF5YmUgdGhlIHJpZ2h0IHRoaW5nIHRvIGRvIGlzIHRvIHNldCBhIGZsYWcgdGhhdCBzYXlz
ICJwbGVhc2UNCnJlcGx1bWIiLCB0aGVuIGRvIGEgcmVzZXQsIGFuZCBoYXZlIHRoZSByZXNldCBw
YXRoIHNlZSBpZiB3ZSBuZWVkIHRvDQpyZXBsdW1iIGtleXMgYW5kIGRvIHNvPw0KDQpUbyBtYWtl
IGxvY2tpbmcgbGVzcyB0ZXJyaWJsZSwgbWF5YmUgd2UgbmVlZCB0byBjYWNoZSB0aGUga2V5cyBp
biB0aGUNCmF0aDlrIGRyaXZlciBzb21ld2hlcmUgc28gcmVwbHVtYmluZyBkb2Vzbid0IHJlcXVp
cmUgcmVhY2hpbmcgaW50bw0KbWFjODIwMTEuDQoNCg0KDQotYWRyaWFuDQoNCg==
