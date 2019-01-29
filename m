Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F0F2C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 07:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBDDB2177E
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 07:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfA2HFQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 02:05:16 -0500
Received: from mga06.intel.com ([134.134.136.31]:31008 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbfA2HFP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 02:05:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jan 2019 23:05:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,536,1539673200"; 
   d="scan'208";a="111915101"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga006.jf.intel.com with ESMTP; 28 Jan 2019 23:05:13 -0800
Received: from lcsmsx154.ger.corp.intel.com (10.186.165.229) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 28 Jan 2019 23:05:13 -0800
Received: from hasmsx112.ger.corp.intel.com ([169.254.11.50]) by
 LCSMSX154.ger.corp.intel.com ([169.254.7.125]) with mapi id 14.03.0415.000;
 Tue, 29 Jan 2019 09:05:09 +0200
From:   "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bjorn@helgaas.com" <bjorn@helgaas.com>,
        "russianneuromancer@ya.ru" <russianneuromancer@ya.ru>,
        "david.ward@ll.mit.edu" <david.ward@ll.mit.edu>,
        "Shaish, Dor" <dor.shaish@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Subject: PCI LTR - ASPM handling upon suspend / resume cycle. Regression
 since 4.18
Thread-Topic: PCI LTR - ASPM handling upon suspend / resume cycle.
 Regression since 4.18
Thread-Index: AQHUt6D4tPDQsP0qY0yqvfxnU9YYfQ==
Date:   Tue, 29 Jan 2019 07:05:09 +0000
Message-ID: <487786e702b8418b43c7f799c58d1948efd3d85c.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.204.136]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4A0549358B2AE46BDB056E3377161A2@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGksDQoNCkxhdGVseSB3ZSAoSW50ZWwpIGhhdmUgZ290IGEgZmV3IGJ1Z3Mgb24gc3VzcGVuZCAv
IHJlc3VtZS4gVGhlDQpjb21wbGFpbnQgaXMgdGhhdCBvdXIgZGV2aWNlIGJlY29tZXMgdW5hdmFp
bGFibGUgYWZ0ZXIgc3VzcGVuZCAvIHJlc3VtZQ0KY3ljbGUuIFRoZSBidWcgb24gd2hpY2ggd2Ug
aGF2ZSBtb3N0IGRhdGEgaXMgWzFdLg0KDQpUaGUgb3JpZ2luYWwgc3VibWl0dGVyIHJlcG9ydGVk
IGEgcmVncmVzc2lvbiBzaW5jZSBjb21taXQNCjlhYjEwNWRlYjYwZmE3NmQ2NmNhZTU1NDg4MTli
NGU4NzAzZDIwNTY6DQoNCiAgIFBDSS9BU1BNOiBEaXNhYmxlIEFTUE0gTDEuMiBTdWJzdGF0ZSBp
ZiB3ZSBkb24ndCBoYXZlIExUUg0KDQogICBXaGVuIGluIHRoZSBBU1BNIEwxLjAgc3RhdGUgKGJ1
dCBub3QgdGhlIFBDSS1QTSBMMS4wIHN0YXRlKSwgdGhlDQogICBtb3N0DQogICByZWNlbnQgTFRS
IHZhbHVlIGFuZCB0aGUgTFRSX0wxLjJfVEhSRVNIT0xEIGRldGVybWluZXMgd2hldGhlciB0aGUN
CiAgIGxpbmsNCiAgIGVudGVycyB0aGUgTDEuMiBzdWJzdGF0ZS4NCg0KICAgSWYgd2UgZG9uJ3Qg
aGF2ZSBMVFIgZW5hYmxlZCwgcHJldmVudCB0aGUgdXNlIG9mIEFTUE0gTDEuMi4NCg0KICAgUENJ
LVBNIEwxLjIgbWF5IHN0aWxsIGJlIHVzZWQgYmVjYXVzZSBpdCBkb2Vzbid0IGRlcGVuZCBvbg0K
ICAgTFRSX0wxLjJfVEhSRVNIT0xEIChzZWUgUENJZSByNC4wLCBzZWMgNS41LjEpLg0KDQoNCkFm
dGVyIHRoaXMgY29tbWl0LCBMMS4yIGlzIGRpc2FibGVkIHVwb24gcmVzdW1lOg0KCUwxU3ViQ3Rs
MTogUENJLVBNX0wxLjIrIFBDSS1QTV9MMS4xKyBBU1BNX0wxLjItIEFTUE1fTDEuMSsNCgkNCgkg
ICBUX0NvbW1vbk1vZGU9MHVzIExUUjEuMl9UaHJlc2hvbGQ9MTYzODQwbnMNCg0KV2hlcmVhcyBp
dCB3YXNuJ3QgYmVmb3JlIHRoaXMgY29tbWl0Og0KCUwxU3ViQ3RsMTogUENJLVBNX0wxLjIrIFBD
SS1QTV9MMS4xKyBBU1BNX0wxLjIrIEFTUE1fTDEuMSsNCgkJICAgVF9Db21tb25Nb2RlPTB1cyBM
VFIxLjJfVGhyZXNob2xkPTE2Mzg0MG5zDQoNCkkgYW0gY29weWluZyBoZXJlIGFuIGluaXRpYWwg
YW5hbHlzaXMgYnkgQmpvcm4gKGZyb20gWzJdKToNCg0KMSkgTGludXggaGFzIG5vIHN1cHBvcnQg
Zm9yIHNhdmluZy9yZXN0b3JpbmcgdGhlIE1heCBMYXRlbmN5IHZhbHVlcyBpbg0KdGhlIExUUiBD
YXBhYmlsaXR5LiAgVGhpcyByZXN1bHRzIGluIHRoZSBsYXRlbmNpZXMgYmVpbmcgemVybyBhZnRl
ciB5b3UNCnJlc3VtZSwgYXMgeW91IHNlZSBpbiB0aGUgbHNwY2kgb3V0cHV0LiAgVGhlIGRldmlj
ZSBzdGlsbCAqd29ya3MqIGFmdGVyDQpyZXN1bWUsIGJ1dCBwb3dlciBjb25zdW1wdGlvbiBzaG91
bGQgaW5jcmVhc2UgYmVjYXVzZSB0aGUgZGV2aWNlIGlzDQplZmZlY3RpdmVseSByZXF1ZXN0aW5n
IHRoZSBiZXN0IHBvc3NpYmxlIHNlcnZpY2UsIHNvIHdlIHByb2JhYmx5IGRvbid0DQp1c2UgdGhl
IEwxLjIgc3RhdGUgYXQgYWxsLg0KDQoyKSBMaW51eCBoYXMgbm8gc3VwcG9ydCBmb3IgcHJvZ3Jh
bW1pbmcgdGhlIE1heCBMYXRlbmN5IHZhbHVlcyBmb3IgaG90LQ0KYWRkZWQgZGV2aWNlcy4gIFdo
ZW4gdXNpbmcgQUNQSSBob3RwbHVnLCBmaXJtd2FyZSBtYXkgZG8gdGhpcywgYnV0IGZvcg0KbmF0
aXZlIFBDSWUgaG90cGx1ZyAocGNpZWhwKSwgdGhlIG5ldyBkZXZpY2Ugc2hvdWxkIGFnYWluIGJl
IHJlcXVlc3RpbmcNCnRoZSBiZXN0IHBvc3NpYmxlIHNlcnZpY2UsIHJlc3VsdGluZyBpbiBtb3Jl
IHBvd2VyIGNvbnN1bXB0aW9uIHRoYW4NCm5lY2Vzc2FyeS4gIFRoZSBwbGF0Zm9ybSBpcyBzdXBw
b3NlZCB0byBzdXBwbHkgYSBfRFNNIG1ldGhvZCB3aXRoDQppbmZvcm1hdGlvbiByZXF1aXJlZCB0
byBwcm9ncmFtIHRoZXNlIHZhbHVlcw0KDQoNCkFub3RoZXIgdXNlciBmb3VuZCBhbm90aGVyIGNv
bW1pdCBpbXBhY3RpbmcgaGlzIGRldmljZSBhZnRlciBzdXNwZW5kIC8NCnJlc3VtZToNCmNvbW1p
dCA2ZjlkYjY5YWQ5M2NkNmFiNzdkNTU3MWNmNzQ4ZmY3Y2RjZmIwMjg1DQoNCiAgICBBQ1BJIC8g
UE06IERlZmF1bHQgdG8gczJpZGxlIGluIGFsbCBtYWNoaW5lcyBzdXBwb3J0aW5nIExQIFMwDQog
ICAgDQogICAgVGhlIERlbGwgVmVudWUgUHJvIDcxNDAgc3VwcG9ydHMgdGhlIExvdyBQb3dlciBT
MCBJZGxlIHN0YXRlLCBidXQNCiAgICBkb2VzIG5vdCBzdXBwb3J0IGFueSBvZiB0aGUgX0RTTSBm
dW5jdGlvbnMgdGhhdCB0aGUgY3VycmVudA0KaGV1cmlzdGljDQogICAgY2hlY2tzIGZvci4NCiAg
ICANCiAgICBTaW5jZSBzdXNwZW5kLXRvLW1lbSBjYW4gbm90IGJlIHNhZmVseSBwZXJmb3JtZWQg
b24gdGhpcyBtYWNoaW5lLA0KICAgIGFuZCBzaW5jZSB0aGUgYml0ZmllbGQgY2hlY2sgY2FuJ3Qg
Y292ZXIgdGhpcyBjYXNlLCBpdCBpcyBzYWZlcg0KICAgIHRvIGVuYWJsZSBzMmlkbGUgYnkgZGVm
YXVsdCBieSBjaGVja2luZyBmb3IgdGhlIHByZXNlbmNlIG9mIHRoZQ0KICAgIF9EU00gYWxvbmUg
YW5kIHJlbW92aW5nIHRoZSBiaXRmaWVsZCBjaGVjay4NCg0KVGhpcyB1c2VyIGNvbmZpcm1lZCB0
aGF0IHVzaW5nIHN1c3BlbmQtdG8tbWVtIGluc3RlYWQgb2Ygc3VzcGVuZC10by0NCmlkbGUgd29y
a3MgZm9yIGhpbS4NCg0KQSB1c2VyIGNvbnRhY3RlZCBteSBwcml2YXRlbHkgdG8gbGV0IG1lIGtu
b3cgdGhhdCBoZSBoYXMgaXNzdWVzIHdpdGgNCmRldmljZXMgZnJvbSBvdGhlciB2ZW5kb3JzIGFs
dGhvdWdoIEkgY2FuJ3QgdGVsbCBpZiB0aGUgcHJvYmxlbSBpcyB0aGUNCnNhbWUgb3Igbm90Lg0K
DQpOb3RlIHRoYXQgdGhpcyBwcm9ibGVtIHN0YXJ0ZWQgZnJvbSBrZXJuZWwgNC4xOC4NCg0KVGhh
bmsgeW91Lg0KDQpbMV0gLSBodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dp
P2lkPTIwMTQ2OQ0KWzJdIC0gaHR0cHM6Ly9idWd6aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVnLmNn
aT9pZD0yMDE0NjkjYzI2DQo=
