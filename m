Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55630 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751502AbeDJCTj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Apr 2018 22:19:39 -0400
From: Xinming Hu <huxm@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>
Subject: Re: [v2 PATCH] mwifiex: parse key management suite from RSN IE
Date: Tue, 10 Apr 2018 02:19:30 +0000
Message-ID: <c4107389ed724cfeb7bda632cea95c46@SC-EXCH02.marvell.com> (sfid-20180410_041943_130354_9B05FBE2)
References: <1523260191-29352-1-git-send-email-huxm@marvell.com>
 <87o9isr6v5.fsf@codeaurora.org>
In-Reply-To: <87o9isr6v5.fsf@codeaurora.org>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgS2FsbGUsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS2FsbGUg
VmFsbyBbbWFpbHRvOmt2YWxvQGNvZGVhdXJvcmEub3JnXQ0KPiBTZW50OiAyMDE4xOo01MI5yNUg
MTg6NTENCj4gVG86IFhpbm1pbmcgSHUgPGh1eG1AbWFydmVsbC5jb20+DQo+IENjOiBMaW51eCBX
aXJlbGVzcyA8bGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnPjsgQnJpYW4gTm9ycmlzDQo+
IDxicmlhbm5vcnJpc0BjaHJvbWl1bS5vcmc+OyBEbWl0cnkgVG9yb2tob3YgPGR0b3JAZ29vZ2xl
LmNvbT47DQo+IHJhamF0amFAZ29vZ2xlLmNvbTsgWmhpeXVhbiBZYW5nIDx5YW5nenlAbWFydmVs
bC5jb20+OyBUaW0gU29uZw0KPiA8c29uZ3Rhb0BtYXJ2ZWxsLmNvbT47IENhdGh5IEx1byA8Y2x1
b0BtYXJ2ZWxsLmNvbT47IEphbWVzIENhbw0KPiA8amNhb0BtYXJ2ZWxsLmNvbT47IEdhbmFwYXRo
aSBCaGF0IDxnYmhhdEBtYXJ2ZWxsLmNvbT47IEVsbGllIFJlZXZlcw0KPiA8ZWxsaWVyZXZ2ZXNA
Z21haWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW3YyIFBBVENIXSBtd2lmaWV4OiBwYXJzZSBrZXkg
bWFuYWdlbWVudCBzdWl0ZSBmcm9tIFJTTiBJRQ0KPiANCj4gWGlubWluZyBIdSA8aHV4bUBtYXJ2
ZWxsLmNvbT4gd3JpdGVzOg0KPiANCj4gPiBBc3NvY2lhdGlvbiBmYWlsZWQgd2hlbiB1c2luZyB3
cGFfc3VwcGxpY2FudCB3aXRoIGNvbmZpZ3VyYXRpb24NCj4gPiBrZXlfbWdtdD1XUEEtUFNLLVNI
QTI1NiwgYW5kIGl0IGlzIG5vdGljZWQgdGhhdCB3cGFfc3VwcGxpY2FudCBzZXQNCj4gPiBXTEFO
X0FLTV9TVUlURV9QU0tfU0hBMjU2IGluIFJTTiBJRSwgYnV0IG1pc3MgaXQgaW4gc3RhcnRfYXAN
Cj4gPiBwYXJhbWV0ZXJzLg0KPiA+DQo+ID4gVGhpcyBwYXRjaCBwYXJzZSBrZXkgbWFuYWdlbWVu
dCBzdWl0ZSBmcm9tIFJTTiBJRSwgaW4gY2FzZSBpdCBpcw0KPiA+IG1pc3NlZC4NCj4gPg0KPiA+
IFNpZ25lZC1vZmYtYnk6IFhpbm1pbmcgSHUgPGh1eG1AbWFydmVsbC5jb20+DQo+IA0KPiBTaG91
bGRuJ3QgeW91IGZpeCB3cGFfc3VwcGxpY2FudCBpbnN0ZWFkIG9mIGFkZGluZyBhIHdvcmthcm91
bmQgdG8gdGhlIGRyaXZlcj8NCj4gDQoNClllcywgSSBhbSBwcmVwYXJpbmcgYSB3cGFfc3VwcGxp
Y2FudCBmaXggb24gdGhpcy4NCkV2ZW4gc28sIGRyaXZlciBmaXggaXMgc3RpbGwgbmVlZCB0byBj
b21wYXRpYmxlIHdpdGggb2xkIHdwYV9zdXBwbGljYW50IHN0YWJsZSByZWxlYXNlDQoNClJlZ2Fy
ZHMsDQpTaW1vbg0KDQo+IC0tDQo+IEthbGxlIFZhbG8NCg==
