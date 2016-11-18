Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37845 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751685AbcKRN76 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 08:59:58 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        "briannorris@google.com" <briannorris@google.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        Shengzhen Li <szli@marvell.com>
Subject: RE: [v3, 01/11] mwifiex: check tx_hw_pending before downloading sleep
 confirm
Date: Fri, 18 Nov 2016 13:59:53 +0000
Message-ID: <031be625ec9543429c2f1629987846d3@SC-EXCH04.marvell.com> (sfid-20161118_150002_247618_8CE3B82A)
References: <1478869818-4340-1-git-send-email-akarwar@marvell.com>
 <20161118113049.AFC0862669@smtp.codeaurora.org>
In-Reply-To: <20161118113049.AFC0862669@smtp.codeaurora.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgS2FsbGUsDQoNCj4gRnJvbTogbGludXgtd2lyZWxlc3Mtb3duZXJAdmdlci5rZXJuZWwub3Jn
IFttYWlsdG86bGludXgtd2lyZWxlc3MtDQo+IG93bmVyQHZnZXIua2VybmVsLm9yZ10gT24gQmVo
YWxmIE9mIEthbGxlIFZhbG8NCj4gU2VudDogRnJpZGF5LCBOb3ZlbWJlciAxOCwgMjAxNiA1OjAx
IFBNDQo+IFRvOiBBbWl0a3VtYXIgS2Fyd2FyDQo+IENjOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtl
cm5lbC5vcmc7IENhdGh5IEx1bzsgTmlzaGFudCBTYXJtdWthZGFtOw0KPiByYWphdGphQGdvb2ds
ZS5jb207IGJyaWFubm9ycmlzQGdvb2dsZS5jb207IGRtaXRyeS50b3Jva2hvdkBnbWFpbC5jb207
DQo+IFNoZW5nemhlbiBMaTsgQW1pdGt1bWFyIEthcndhcg0KPiBTdWJqZWN0OiBSZTogW3YzLCAw
MS8xMV0gbXdpZmlleDogY2hlY2sgdHhfaHdfcGVuZGluZyBiZWZvcmUNCj4gZG93bmxvYWRpbmcg
c2xlZXAgY29uZmlybQ0KPiANCj4gQW1pdGt1bWFyIEthcndhciA8YWthcndhckBtYXJ2ZWxsLmNv
bT4gd3JvdGU6DQo+ID4gRnJvbTogU2hlbmd6aGVuIExpIDxzemxpQG1hcnZlbGwuY29tPg0KPiA+
DQo+ID4gV2UgbWF5IGdldCBTTEVFUCBldmVudCBmcm9tIGZpcm13YXJlIGV2ZW4gaWYgVFhEb25l
IGludGVycnVwdCBmb3INCj4gbGFzdA0KPiA+IFR4IHBhY2tldCBpcyBzdGlsbCBwZW5kaW5nLiBJ
biB0aGlzIGNhc2UsIHdlIG1heSBlbmQgdXAgYWNjZXNzaW5nDQo+IFBDSWUNCj4gPiBtZW1vcnkg
Zm9yIGhhbmRsaW5nIFRYRG9uZSBhZnRlciBwb3dlciBzYXZlIGhhbmRzaGFrZSBpcyBjb21wbGV0
ZWQuDQo+ID4gVGhpcyBjYXVzZXMga2VybmVsIGNyYXNoIHdpdGggZXh0ZXJuYWwgYWJvcnQuDQo+
ID4NCj4gPiBUaGlzIHBhdGNoIHdpbGwgb25seSBhbGxvdyBkb3dubG9hZGluZyBzbGVlcCBjb25m
aXJtIHdoZW4gbm8gdHggZG9uZQ0KPiA+IGludGVycnVwdCBpcyBwZW5kaW5nIGluIHRoZSBoYXJk
d2FyZS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IENhdGh5IEx1byA8Y2x1b0BtYXJ2ZWxsLmNv
bT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTaGVuZ3poZW4gTGkgPHN6bGlAbWFydmVsbC5jb20+DQo+
ID4gVGVzdGVkLWJ5OiBYaW5taW5nIEh1IDxodXhtQG1hcnZlbGwuY29tPg0KPiA+IFNpZ25lZC1v
ZmYtYnk6IEFtaXRrdW1hciBLYXJ3YXIgPGFrYXJ3YXJAbWFydmVsbC5jb20+DQo+ID4gUmV2aWV3
ZWQtYnk6IEJyaWFuIE5vcnJpcyA8YnJpYW5ub3JyaXNAY2hyb21pdW0ub3JnPg0KPiANCj4gKEEg
bm90ZSB0byBteXNlbGYpDQo+IA0KPiBEZXBlbmRzIG9uIHRoaXMgcGF0Y2hzZXQ6DQo+IA0KPiBb
IDEyXSBbdjQsMS8zXSBtd2lmaWV4OiBBbGxvdyBtd2lmaWV4IGVhcmx5IGFjY2VzcyB0byBkZXZp
Y2Ugc3QuLi4NCj4gMjAxNi0xMS0xNSBBbWl0a3VtYXIgS2EgQXdhaXRpbmcgVXBzdHJlYW0gWyAx
M10gW3Y0LDIvM10gbXdpZmlleDoNCj4gSW50cm9kdWNlIG13aWZpZXhfcHJvYmVfb2YoKSB0byBw
YXJzZSBjLi4uIDIwMTYtMTEtMTUgQW1pdGt1bWFyIEthDQo+IEF3YWl0aW5nIFVwc3RyZWFtDQo+
IFsgMTRdIFt2NCwzLzNdIG13aWZpZXg6IEVuYWJsZSBXb1dMQU4gZm9yIGJvdGggc2RpbyBhbmQg
cGNpZQ0KPiAyMDE2LTExLTE1IEFtaXRrdW1hciBLYSBBd2FpdGluZyBVcHN0cmVhbQ0KPiANCg0K
VGhlcmUgaXMgYSBtaW5vciBjb25mbGljdCB3aGlsZSBhcHBseWluZyBbdjMsIDMvMTFdIG9uIHRv
cCBvZiBhYm92ZSBwYXRjaCBzZXJpZXMuDQpJIHdpbGwgc3VibWl0IHY0IHBhdGNoIHNlcmllcygx
MSBwYXRjaGVzKSB3aXRoIGNvcnJlY3Rpb24uDQoNClJlZ2FyZHMsDQpBbWl0a3VtYXINCg==
