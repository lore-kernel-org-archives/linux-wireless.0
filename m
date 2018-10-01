Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 772E8C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 09:24:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B5E92084C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 09:24:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B5E92084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbeJAQB3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 12:01:29 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:53810 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728978AbeJAQB3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 12:01:29 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w919OKOM007333, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w919OKOM007333
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 1 Oct 2018 17:24:20 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Mon, 1 Oct 2018
 17:24:20 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "joe@perches.com" <joe@perches.com>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "rickveens92@gmail.com" <rickveens92@gmail.com>
Subject: Re: [PATCH] rtlwifi: Removed unused define and code efuse_re_pg* from wifi.h
Thread-Topic: [PATCH] rtlwifi: Removed unused define and code efuse_re_pg*
 from wifi.h
Thread-Index: AQHUWWXarU23myNcokmQEftLXeOVpqUKGniB//99oAA=
Date:   Mon, 1 Oct 2018 09:24:19 +0000
Message-ID: <1538385846.14206.0.camel@realtek.com>
References: <20181001090424.13862-1-pkshih@realtek.com>
         <87r2ha2fsj.fsf@codeaurora.org>
In-Reply-To: <87r2ha2fsj.fsf@codeaurora.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
Content-Type: text/plain; charset="utf-8"
Content-ID: <06F7B28C165E3147A8933F2F509403B3@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gTW9uLCAyMDE4LTEwLTAxIGF0IDEyOjEwICswMzAwLCBLYWxsZSBWYWxvIHdyb3RlOg0KPiA8
cGtzaGloQHJlYWx0ZWsuY29tPiB3cml0ZXM6DQo+IA0KPiA+IEZyb206IFJpY2sgVmVlbnMgPHJp
Y2t2ZWVuczkyQGdtYWlsLmNvbT4NCj4gPg0KPiA+IFRoZSBmb2xsb3dpbmc6DQo+ID7CoMKgYm9v
bCBlZnVzZV9yZV9wZ19zZWMxZmxhZzsNCj4gPsKgwqB1OCBlZnVzZV9yZV9wZ19kYXRhWzhdOw0K
PiA+IGFyZSBub3QgcmVmZXJlbmNlZCBhbnl3aGVyZSBpbiB0aGUgcnRsd2lmaSBjb2RlLg0KPiA+
DQo+ID4gVGhpcyBwYXRjaCBpcyBvcmlnaW5hbGx5IGNyZWF0ZWQgYnkgUmljayBWZWVucyA8cmlj
a3ZlZW5zOTJAZ21haWwuY29tPiwNCj4gPiBhbmQgSm9lIFBlcmNoZXMgPGpvZUBwZXJjaGVzLmNv
bT4gcmVtaW5kZWQgdG8gYXBwbHkgaXQgdG8gcnRsd2lmaS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KPiANCj4gUmljaydzIFNpZ25l
ZC1vZmYtYnkgaXMgbWlzc2luZy4gUGluZywgZWl0aGVyIHlvdSBuZWVkIHRvIG1hcmsgeW91cnNl
bGYNCj4gYXMgYXV0aG9yICh3aGljaCBJTUhPIGlzIGNvcnJlY3QgYXMgeW91IHdyb3RlIHRoaXMg
cGF0Y2ggYW55d2F5LCBSaWNrDQo+IHdyb3RlIGl0IGZvciB0aGUgb3RoZXIgZHJpdmVyKSBvciBS
aWNrIG5lZWRzIHRvIGdpdmUgaGlzIHMtby1iLg0KPiANCg0KV2lsbCBzZW5kIHYyLg0KVGhhbmtz
DQoNCi0tDQpQSw0KDQo=
