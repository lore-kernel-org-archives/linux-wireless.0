Return-Path: <SRS0=CFp0=SD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FDAC43381
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 06:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 878132070B
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 06:17:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qti.qualcomm.com header.i=@qti.qualcomm.com header.b="K+Lio2xF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731621AbfDAGRt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Apr 2019 02:17:49 -0400
Received: from alexa-out-tai-02.qualcomm.com ([103.229.16.227]:35197 "EHLO
        alexa-out-tai-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725784AbfDAGRs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Apr 2019 02:17:48 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Apr 2019 02:17:47 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1554099467; x=1585635467;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=WyJqoioxhkk73Xnr7cBz3zQ89cUM+1QgbA7HWgKCvT8=;
  b=K+Lio2xFGDSfJN8b7HlS8eErKaz8sfzQGuH6U5RRiN+b4NVpLOxOLbqs
   dXXUq+cBlgklzrqBtR/6Ii8GQGsff58NAif32aKEbIoao1fZXyDHGL7Ss
   an5x1PAusWGueZZOWkKc05eeNFWhF4JfOU+vtaMeoKmBO8GK+84Qcw3Ln
   Y=;
X-IronPort-AV: E=Sophos;i="5.60,295,1549900800"; 
   d="scan'208";a="2122832"
Subject: RE: [PATCH] ath10k: Remove ATH10K_STATE_RESTARTED in simulate fw crash
Thread-Topic: [PATCH] ath10k: Remove ATH10K_STATE_RESTARTED in simulate fw crash
Received: from ironmsg01-tai.qualcomm.com ([10.249.140.6])
  by alexa-out-tai-02.qualcomm.com with ESMTP; 01 Apr 2019 14:11:33 +0800
X-IronPort-AV: E=McAfee;i="5900,7806,9213"; a="25947130"
Received: from aptaiexm02a.ap.qualcomm.com ([10.249.150.11])
  by ironmsg01-tai.qualcomm.com with ESMTP/TLS/AES256-SHA; 01 Apr 2019 14:11:33 +0800
Received: from aptaiexm02f.ap.qualcomm.com (10.249.150.16) by
 aptaiexm02a.ap.qualcomm.com (10.249.150.11) with Microsoft SMTP Server (TLS)
 id 15.0.1395.4; Mon, 1 Apr 2019 14:11:31 +0800
Received: from aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1]) by
 aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1%19]) with mapi id
 15.00.1395.000; Mon, 1 Apr 2019 14:11:31 +0800
From:   Wen Gong <wgong@qti.qualcomm.com>
To:     =?utf-8?B?TWljaGHFgiBLYXppb3I=?= <kazikcz@gmail.com>
CC:     Wen Gong <wgong@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Thread-Index: AQHUpmQJz5XVQIMvMUei5K703fyTnaYnTmZw
Date:   Mon, 1 Apr 2019 06:11:31 +0000
Message-ID: <02904ba8682441e1a89668c1345cbec9@aptaiexm02f.ap.qualcomm.com>
References: <1542163824-795-1-git-send-email-wgong@codeaurora.org>
 <CABvG-CWg-VXAtoN8HZumW-ZdP6dX9cO_8fWJ58C22kD2yDcXdw@mail.gmail.com>
 <195f3bb0c88c43a6b1ca0ad336f947c0@aptaiexm02f.ap.qualcomm.com>
 <CABvG-CWAfB8jjCDW4ggjJ8_YC++CjttJOMOt4s24F3mymvNR9A@mail.gmail.com>
In-Reply-To: <CABvG-CWAfB8jjCDW4ggjJ8_YC++CjttJOMOt4s24F3mymvNR9A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.249.136.10]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNaWNoYcWCIEthemlvciA8a2F6
aWtjekBnbWFpbC5jb20+DQo+IFNlbnQ6IE1vbmRheSwgSmFudWFyeSA3LCAyMDE5IDQ6MzYgUE0N
Cj4gVG86IFdlbiBHb25nIDx3Z29uZ0BxdGkucXVhbGNvbW0uY29tPg0KPiBDYzogV2VuIEdvbmcg
PHdnb25nQGNvZGVhdXJvcmEub3JnPjsgbGludXgtd2lyZWxlc3MgPGxpbnV4LQ0KPiB3aXJlbGVz
c0B2Z2VyLmtlcm5lbC5vcmc+OyBhdGgxMGtAbGlzdHMuaW5mcmFkZWFkLm9yZw0KPiBTdWJqZWN0
OiBbRVhUXSBSZTogW1BBVENIXSBhdGgxMGs6IFJlbW92ZSBBVEgxMEtfU1RBVEVfUkVTVEFSVEVE
IGluDQo+IHNpbXVsYXRlIGZ3IGNyYXNoDQo+IFRoYXQncyBhY3R1YWxseSBhIGZlYXR1cmUsIG5v
dCBhIGJ1Zy4gSWYgZmlybXdhcmUgY3Jhc2hlcyB3aGlsZSBkcml2ZXINCj4gaXMgcmVzdGFydGlu
ZyBhZnRlciBhIGNyYXNoIHRoZW4gaXRzIGxpa2VseSBnb2luZyB0byBmYWlsIGFnYWluIGFuZA0K
PiBhZ2FpbiBjYXVzaW5nIGEgY3Jhc2gtcmVzdGFydCBsb29wIHdoaWNoIGNhbiBhZmZlY3Qgc3lz
dGVtIHBlcmZvcm1hbmNlDQo+IGFuZCByZXNwb25zaXZlbmVzcy4gSXQncyBiZXR0ZXIgdG8gZ2l2
ZSB1cCBhbmQgbGV0IHRoZSBzeXN0ZW0gYWRtaW4NCj4gdGFrZSBvdmVyLg0KPiANCj4gSWYgaXQn
cyBzdGlsbCBib3RoZXJpbmcgeW91IHRoZW4gcGxlYXNlIGNvbnNpZGVyIGEgY3Jhc2ggY291bnRl
cg0KPiB0aHJlc2hvbGQgc28gdGhhdCwgZS5nLiBhZnRlciA1IGNyYXNoLXdoaWxlLXJlc3RhcnRp
bmcgaXQncyBnb2luZyB0bw0KPiBnaXZlIHVwLiBIb3dldmVyIEkgZG91YnQgaXQncyB3b3J0aCB0
aGUgZWZmb3J0LiBNeSBleHBlcmllbmNlIHRlbGxzIG1lDQo+IGZpcm13YXJlIGNyYXNoZXMgZHVy
aW5nIHJlY292ZXJ5IGFyZSByYXJlbHksIGlmIGF0IGFsbCwgdHJhbnNpZW50Lg0KPiANCj4gVGhl
IHNpbXVsYXRlZCBmdyBjcmFzaCBpcyBub3QgcmVwcmVzZW50YXRpdmUgaGVyZS4gSXQncyBhIG1l
cmUgdG9vbCB0bw0KPiB0ZXN0IGRyaXZlciBjb2RlLg0KPiANCkhpIE1pY2hhbCwNClRoZXJlIGhh
dmUgYSBzdHJlc3MgdGVzdCBjYXNlIGZvciB0aGUgc2ltdWxhdGUgZncgY3Jhc2gsIGl0IHdpbGwg
c2ltdWxhdGUgZncgY3Jhc2gNCmluIGEgdmVyeSBzaG9ydCB0aW1lIGZvciBlYWNoIHRlc3QsIHRo
aXMgd2lsbCB0cmlnZ2VyIHRoZSBzdHJlc3MgdGVzdCBmYWlsLg0KVGhlIHNpbXVsYXRlIGZ3IGNy
YXNoIHByb2Nlc3Mgc2hvdWxkIG5vdCBiZSBydW4gcGFyYWxsZWwsIGFmdGVyIHRoaXMgcGF0Y2gs
IHRoZQ0KU3RyZXNzIHRlc3QgY2FzZSB3aWxsIHBhc3MuDQo+IA0KPiBNaWNoYcWCDQo=
