Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:28373 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757400AbdJQJOT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 05:14:19 -0400
From: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [2/2] ath10k: handle tdls peer events
Date: Tue, 17 Oct 2017 09:14:11 +0000
Message-ID: <063342a953e840758e58b6ea40b5de8a@aphydexm01f.ap.qualcomm.com> (sfid-20171017_111426_896854_614D0E7E)
References: <1507618202-25473-3-git-send-email-mpubbise@qti.qualcomm.com>
 <e1bed0a347cf4ce0a1c538b99852398a@euamsexm01e.eu.qualcomm.com>
In-Reply-To: <e1bed0a347cf4ce0a1c538b99852398a@euamsexm01e.eu.qualcomm.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PlRoaXMgcGF0Y2ggaW50cm9kdWNlcyBuZXcgd2FybmluZ3M6DQo+DQo+JCBhdGgxMGstY2hlY2sN
Cj5kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBrL3dtaS5jOjQ0NzA6Mzk6IHdhcm5pbmc6
IGluY29ycmVjdCB0eXBlIGluDQo+YXJndW1lbnQgMiAoZGlmZmVyZW50IGJhc2UgdHlwZXMpDQo+
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDEway93bWkuYzo0NDcwOjM5OiAgICBleHBlY3Rl
ZCBpbnQgW3NpZ25lZF0NCj52ZGV2X2lkDQo+ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDEw
ay93bWkuYzo0NDcwOjM5OiAgICBnb3QgcmVzdHJpY3RlZCBfX2xlMzINCj5bdXNlcnR5cGVdIHZk
ZXZfaWQNCj5kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBrL3dtaS5jOjQ0ODE6Mjc6IHdh
cm5pbmc6IHJlc3RyaWN0ZWQgX19sZTMyDQo+ZGVncmFkZXMgdG8gaW50ZWdlcg0KPmRyaXZlcnMv
bmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvd21pLmM6NDQ4MToyNzogd2FybmluZzogcmVzdHJpY3Rl
ZCBfX2xlMzINCj5kZWdyYWRlcyB0byBpbnRlZ2VyDQo+ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRo
L2F0aDEway93bWkuYzo0NDgxOjI3OiB3YXJuaW5nOiByZXN0cmljdGVkIF9fbGUzMg0KPmRlZ3Jh
ZGVzIHRvIGludGVnZXINCj5kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBrL3dtaS5jOjQ0
OTI6NDg6IHdhcm5pbmc6IGluY29ycmVjdCB0eXBlIGluDQo+YXJndW1lbnQgMiAoZGlmZmVyZW50
IGJhc2UgdHlwZXMpDQo+ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDEway93bWkuYzo0NDky
OjQ4OiAgICBleHBlY3RlZCB1bnNpZ25lZCBpbnQNCj5bdW5zaWduZWRdIFt1c2VydHlwZV0gdmRl
dl9pZA0KPmRyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvd21pLmM6NDQ5Mjo0ODogICAg
Z290IHJlc3RyaWN0ZWQgX19sZTMyDQo+W3VzZXJ0eXBlXSB2ZGV2X2lkDQo+ZHJpdmVycy9uZXQv
d2lyZWxlc3MvYXRoL2F0aDEway93bWkuYzo0NDc5OjE5OiB3YXJuaW5nOiByZXN0cmljdGVkIF9f
bGUzMg0KPmRlZ3JhZGVzIHRvIGludGVnZXINCj5kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRo
MTBrL3dtaS5jOjQ0NjA6Njogd2FybmluZzogc3ltYm9sDQo+J2F0aDEwa193bWlfaGFuZGxlX3Rk
bHNfcGVlcl9ldmVudCcgd2FzIG5vdCBkZWNsYXJlZC4gU2hvdWxkIGl0IGJlIHN0YXRpYz8NCj4N
Cj4tLQ0KPmh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcGF0Y2gvOTk5NTEzMS8NCj4NCj5o
dHRwczovL3dpcmVsZXNzLndpa2kua2VybmVsLm9yZy9lbi9kZXZlbG9wZXJzL2RvY3VtZW50YXRp
b24vc3VibWl0dGluZ3BhDQo+dGNoZXMNCg0KTXkgYmFkISENClRoYW5rcyBrYWxsZSwgSSB3aWxs
IGZpeCB0aGlzIGFuZCBzZW5kIGEgZm9sbG93IHVwIHZlcnNpb24uDQoNCk1hbmlrYW50YSBQdWJi
aXNldHR5DQo=
