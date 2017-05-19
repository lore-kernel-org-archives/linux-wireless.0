Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38076 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755711AbdESJF4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 05:05:56 -0400
From: Xinming Hu <huxm@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Xinming Hu <huxinming820@gmail.com>
CC: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: RE: [PATCH v2 5/6] mwifiex: do not aggregate tcp ack in usb tx
 aggregation queue
Date: Fri, 19 May 2017 09:05:46 +0000
Message-ID: <64c6cdbc1ff64deaa42b76ce8ab181cd@SC-EXCH02.marvell.com> (sfid-20170519_110615_011746_0DC7BBBE)
References: <1493986100-24509-1-git-send-email-huxinming820@gmail.com>
        <1493986100-24509-5-git-send-email-huxinming820@gmail.com>
 <87lgpu5j61.fsf@purkki.adurom.net>
In-Reply-To: <87lgpu5j61.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgS2FsbGUsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS2FsbGUg
VmFsbyBbbWFpbHRvOmt2YWxvQGNvZGVhdXJvcmEub3JnXQ0KPiBTZW50OiAyMDE3xOo11MIxOMjV
IDIyOjMzDQo+IFRvOiBYaW5taW5nIEh1DQo+IENjOiBMaW51eCBXaXJlbGVzczsgQnJpYW4gTm9y
cmlzOyBEbWl0cnkgVG9yb2tob3Y7IHJhamF0amFAZ29vZ2xlLmNvbTsNCj4gWmhpeXVhbiBZYW5n
OyBDYXRoeSBMdW87IFhpbm1pbmcgSHU7IEdhbmFwYXRoaSBCaGF0DQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggdjIgNS82XSBtd2lmaWV4OiBkbyBub3QgYWdncmVnYXRlIHRjcCBhY2sgaW4gdXNiIHR4
DQo+IGFnZ3JlZ2F0aW9uIHF1ZXVlDQo+IA0KPiBYaW5taW5nIEh1IDxodXhpbm1pbmc4MjBAZ21h
aWwuY29tPiB3cml0ZXM6DQo+IA0KPiA+IEZyb206IFhpbm1pbmcgSHUgPGh1eG1AbWFydmVsbC5j
b20+DQo+ID4NCj4gPiBUY3AgYWNrIHNob3VsZCBiZSBzZW5kIGFzIHNvb24gdG8gYXZvaWQgdGhy
b3VwdXQgZHJvcCBkdXJpbmcgcmVjZWl2ZQ0KPiA+IHRjcCB0cmFmZmljLg0KPiA+DQo+ID4gU2ln
bmVkLW9mZi1ieTogWGlubWluZyBIdSA8aHV4bUBtYXJ2ZWxsLmNvbT4NCj4gPiBTaWduZWQtb2Zm
LWJ5OiBDYXRoeSBMdW8gPGNsdW9AbWFydmVsbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogR2Fu
YXBhdGhpIEJoYXQgPGdiaGF0QG1hcnZlbGwuY29tPg0KPiANCj4gWy4uLl0NCj4gDQo+ID4gK3N0
YXRpYyBib29sIGlzX3BpZ2d5YmFja190Y3BfYWNrKHN0cnVjdCBza19idWZmICpza2IpIHsNCj4g
PiArCXN0cnVjdCBldGhoZHIgKmV0aGggPSBOVUxMOw0KPiA+ICsJc3RydWN0IGlwaGRyICAqaXBo
ID0gTlVMTDsNCj4gPiArCXN0cnVjdCB0Y3BoZHIgKnRjcGggPSBOVUxMOw0KPiA+ICsNCj4gPiAr
CWV0aGggPSAoc3RydWN0IGV0aGhkciAqKXNrYi0+ZGF0YTsNCj4gPiArCWlmIChudG9ocyhldGho
LT5oX3Byb3RvKSAhPSBFVEhfUF9JUCkNCj4gPiArCQlyZXR1cm4gZmFsc2U7DQo+ID4gKw0KPiA+
ICsJaXBoID0gKHN0cnVjdCBpcGhkciAqKSgodTggKilldGhoICsgc2l6ZW9mKHN0cnVjdCBldGho
ZHIpKTsNCj4gPiArCWlmIChpcGgtPnByb3RvY29sICE9IElQUFJPVE9fVENQKQ0KPiA+ICsJCXJl
dHVybiBmYWxzZTsNCj4gPiArDQo+ID4gKwl0Y3BoID0gKHN0cnVjdCB0Y3BoZHIgKikoKHU4ICop
aXBoICsgaXBoLT5paGwgKiA0KTsNCj4gPiArCS8qIFBpZ2d5YmFjayBhY2sgd2l0aG91dCBwYXls
b2FkKi8NCj4gPiArCWlmICgqKCh1OCAqKXRjcGggKyAxMykgPT0gMHgxMCAmJg0KPiA+ICsJICAg
IG50b2hzKGlwaC0+dG90X2xlbikgPD0gKGlwaC0+aWhsICsgdGNwaC0+ZG9mZikgKiA0KSB7DQo+
ID4gKwkJcmV0dXJuIHRydWU7DQo+ID4gKwl9DQo+IA0KPiBJdCdzIHJhdGhlciB1Z2x5IHRvIHVz
ZSBtYWdpYyB2YWx1ZXMgKDEzIGFuZCAweDEwKSBsaWtlIHRoYXQuIENhbid0IHlvdSB1c2Ugc29t
ZQ0KPiBvZiB0aGUgZXhpc3RpbmcgZGVmaW5lcz8gQXQgbGVhc3QgSSBzZWUgVENQX0ZMQUdfQUNL
IGFuZCBzdHJ1Y3QgdGNwaGRyOjphY2sNCj4gYmVpbmcgYXZhaWxhYmxlLCBzbyB5b3Ugc2hvdWxk
IGV2ZW4gaGF2ZSBjaG9pc2VzIHdoYXQgdG8gdXNlLg0KPiANCg0KTXkgd3JvbmcuIFdpbGwgcmVz
ZW5kIFYzIHNlcmlhbHMuDQpUaGFua3MgZm9yIHRoZSByZXZpZXcuDQoNClJlZ2FyZHMsDQpTaW1v
bg0KPiAtLQ0KPiBLYWxsZSBWYWxvDQo=
