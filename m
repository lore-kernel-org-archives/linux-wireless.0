Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02634C43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 06:15:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAB1920821
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 06:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbfAIGPj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 01:15:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:51375 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728469AbfAIGPi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 01:15:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2019 22:15:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,456,1539673200"; 
   d="scan'208";a="124550719"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga002.jf.intel.com with ESMTP; 08 Jan 2019 22:15:37 -0800
Received: from bgsmsx151.gar.corp.intel.com (10.224.48.42) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 8 Jan 2019 22:15:37 -0800
Received: from bgsmsx106.gar.corp.intel.com ([169.254.1.41]) by
 BGSMSX151.gar.corp.intel.com ([169.254.3.74]) with mapi id 14.03.0415.000;
 Wed, 9 Jan 2019 11:45:34 +0530
From:   "Garnayak, Sarada Prasanna" <sarada.prasanna.garnayak@intel.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     "Berg, Johannes" <johannes.berg@intel.com>,
        Jouni Malinen <j@w1.fi>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC PATCH v1] cfg80211/nl80211: add support for AID assignment
 by driver : https://patchwork.kernel.org/patch/10726899/
Thread-Topic: [RFC PATCH v1] cfg80211/nl80211: add support for AID
 assignment by driver : https://patchwork.kernel.org/patch/10726899/
Thread-Index: AQHUp3Zo9Qbv3hcn4E20UENUpg1TcqWmdkcQ
Date:   Wed, 9 Jan 2019 06:15:33 +0000
Message-ID: <751CDD2CADF63344AAEAE35AACE235DCCD3488@BGSMSX106.gar.corp.intel.com>
References: <751CDD2CADF63344AAEAE35AACE235DCCC3BCD@BGSMSX106.gar.corp.intel.com>
 <87a7kbqd6s.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87a7kbqd6s.fsf@kamboji.qca.qualcomm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzk3MTI5MDMtN2E0Yi00MDM4LWIxYzktMmUyMmQ5MDlkNDIwIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiQW5mVVBTM28zaStpeXY1MlBiUVwvdnE2ZlNEV3NuRlBJbXdac1J0UkhyMkh2Uk15aXprXC9Lb3plVmRneUZET1BMIn0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

TXkgQmFkLCBPbndhcmRzIEkgd2lsbCBzdWJtaXQgYSBuZXcgdmVyc2lvbiBvZiB0aGUgUkZDIHBh
dGNoIHRvIGFkZHJlc3MgdGhlIHJldmlld2VyIGNvbW1lbnRzIG9uIHByZXZpb3VzIFJGQyBwYXRj
aCBhbmQgZm9yIHF1ZXJ5IG9yIHN1Z2dlc3Rpb25zLCBJIHdpbGwgZGVmaW5pdGVseSBjYyBMaW51
eC13aXJlbGVzcyBpbiBteSBtYWlsIHdpdGhvdXQgYW55IGV4dGVybmFsIGxpbmsgb3IgYXR0YWNo
bWVudC4NCg0KVGhhbmtzLA0KUHJhc2FubmENCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0N
CkZyb206IEthbGxlIFZhbG8gW21haWx0bzprdmFsb0Bjb2RlYXVyb3JhLm9yZ10gDQpTZW50OiBU
dWVzZGF5LCBKYW51YXJ5IDgsIDIwMTkgMTA6NTAgUE0NClRvOiBHYXJuYXlhaywgU2FyYWRhIFBy
YXNhbm5hIDxzYXJhZGEucHJhc2FubmEuZ2FybmF5YWtAaW50ZWwuY29tPg0KQ2M6IEJlcmcsIEpv
aGFubmVzIDxqb2hhbm5lcy5iZXJnQGludGVsLmNvbT47IEpvdW5pIE1hbGluZW4gPGpAdzEuZmk+
OyBTZXJnZXkgTWF0eXVrZXZpY2ggPHNlcmdleS5tYXR5dWtldmljaC5vc0BxdWFudGVubmEuY29t
PjsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtd2lyZWxlc3NAdmdlci5rZXJu
ZWwub3JnDQpTdWJqZWN0OiBSZTogW1JGQyBQQVRDSCB2MV0gY2ZnODAyMTEvbmw4MDIxMTogYWRk
IHN1cHBvcnQgZm9yIEFJRCBhc3NpZ25tZW50IGJ5IGRyaXZlciA6IGh0dHBzOi8vcGF0Y2h3b3Jr
Lmtlcm5lbC5vcmcvcGF0Y2gvMTA3MjY4OTkvDQoNCisgbGludXgtd2lyZWxlc3MNCg0KIkdhcm5h
eWFrLCBTYXJhZGEgUHJhc2FubmEiIDxzYXJhZGEucHJhc2FubmEuZ2FybmF5YWtAaW50ZWwuY29t
PiB3cml0ZXM6DQoNCj4gVGhhbmsgeW91IHNvIG11Y2ggZm9yIHJldmlld2luZyBteSBSRkMgcGF0
Y2ggYW5kIGhlcmUgSSB3b3VsZCBsaWtlIHRvIA0KPiBhZGRyZXNzIHRoZSBiaWcgY29uY2VybnMv
Y29tbWVudHMgYWJvdXQgdGhpcyBSRkMgcGF0Y2ggbGlrZQ0KPg0KPiDDmCBXaGF0IGFyZSB0aGUg
ZXhhY3QgdXNlIGNhc2UgYW5kIHBvdGVudGlhbCB1c2VyIG9mIHRoaXMgcGF0Y2guDQo+DQo+IMOY
IEhvdyB0aGUgSG9zdGFwZCB3aWxsIGhhbmRsZSB0aGlzIGdldCBhaWQgYW5kIGZyZWUgYWlkLg0K
Pg0KPiDDmCBldGMuDQo+DQo+IEluIHRoZSBjdXJyZW50IGltcGxlbWVudGF0aW9uIGluIFdMQU4g
U3RhY2ssIHRoZSBob3N0YXBkIGlzIGFzc2lnbmluZyANCj4gdGhlIEFJRCBmb3IgYSBzdGF0aW9u
IGR1cmluZyBhc3NvY2lhdGlvbi4NCj4NCj4gQnV0IHdlIGhhdmUgYSBmZXcgV0xBTiBoYXJkd2Fy
ZSB3aGljaCBpcyBtYWludGFpbmluZyB0aGUgQUlEIGluIHRoZSANCj4gV0xBTiBoYXJkd2FyZSBs
ZXZlbCBpdHNlbGYgYW5kIHRoZSBmaXJtd2FyZSBjaGVja2luZyB0aGlzIEFJRCBpbiB0aGUgDQo+
IGhhcmR3YXJlIGxldmVsIGFjY29yZGluZyB0byB0aGF0IHRoZSBmaXJtd2FyZSBpcyB0YWtpbmcg
YWN0aW9uIG9uIA0KPiBzdGF0aW9uIG1hbmFnZW1lbnQNCj4NCj4gbGlrZSAoU3RhdGlvbiBEQiBt
YW5hZ2VtZW50LCBCQSBhZ3JlZW1lbnQsIFNNUFMgYW5kIFRNIG1hbmFnZW1lbnQgDQo+IGZyYW1l
IGV0Yy4uLi4pLiBGb3IgdGhpcyByZWFzb24sIHdlIG5lZWQgdGhlc2UgZ2V0X2FpZC9mcmVlX2Fp
ZC4NCj4NCj4gQWxzbyBoZXJlIEkgYW0gYXR0YWNoaW5nIHRoZSBIb3N0YXBkIFJGQyBQYXRjaCBm
b3IgdGhlIHNhbWUuIFBGQSANCj4gKGhvc3RhcGQgcGF0Y2gsIGNhbGwgZmxvdyBkaWFncmFtIGFu
ZCBjb21tZW50cyBvbiB0aGlzIGtlcm5lbCBwYXRjaCkNCj4NCj4gUGxlYXNlIHJldmlldyB0aGUg
Y2FsbCBmbG93IGJlbG93Og0KDQpZb3UgbWFkZSBmZXcgY3J1Y2lhbCBtaXN0YWtlczoNCg0KMS4g
WW91IGRpZCBub3QgQ0MgbGludXgtd2lyZWxlc3MuDQoNCjIuIFlvdSBzdWJtaXR0ZWQgdGhlIG1l
c3NhZ2UgYXMgSFRNTCBhbmQgb3VyIGxpc3RzIGF1dG9tYXRpY2FsbHkgZmlsdGVyDQogICB0aG9z
ZS4NCg0KMy4gWW91IGF0dGFjaGVkIGEgcG93ZXJwb2ludCBmaWxlIGFuZCBJIHdvdWxkIGhvcGUg
dGhhdCBvdXIgbGlzdHMNCiAgIGF1dG9tYXRpY2FsbHkgZmlsdGVyIHRob3NlIGFzIHdlbGwuIEF0
IGxlYXN0IEknbSBub3QgZ29pbmcgdG8gb3Blbg0KICAgYW55IHJhbmRvbSBwb3dlcnBvaW50L3dv
cmQgZmlsZXMgSSByZWNlaXZlIHZpYSBlbWFpbC4NCg0KLS0NCkthbGxlIFZhbG8NCg==
