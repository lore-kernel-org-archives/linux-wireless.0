Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0134.outbound.protection.outlook.com ([104.47.37.134]:40224
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751778AbdIANAj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 09:00:39 -0400
From: Eric Bentley <Eric.Bentley@lairdtech.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: Steve deRosier <derosier@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH v2] brcmfmac: Correctly fail to suspend when SDIO does not
 support power on suspend
Date: Fri, 1 Sep 2017 13:00:36 +0000
Message-ID: <AC37C967-209B-4BC3-9AF2-9CC4C27391C0@lairdtech.com> (sfid-20170901_150042_942250_8A9108F4)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

UmV0dXJuIGVycm9yIHdoZW4gZmFpbGluZyB0byBzZXQgcG93ZXIgbWFuYWdlbWVudCBjYXBhYmls
aXRpZXMgZmxhZy4gIFRoaXMgd2lsbA0KY2F1c2UgdGhlIHN1c3BlbmQgdG8gZmFpbCBidXQgdGhl
IHJhZGlvIHdpbGwgY29udGludWUgdG8gb3BlcmF0ZS4gIEFsbG93aW5nIHRoaXMNCnRvIGZhaWwg
d2l0aG91dCByZXBvcnRpbmcgZXJyb3Igd2lsbCBjYXVzZSB0aGUgcmFkaW8gdG8gYmUgbm9uLWZ1
bmN0aW9uYWwgb24gDQpyZXN1bWUgYXMgaXQgd2lsbCBoYXZlIGxvc3QgcG93ZXIuDQoNClNpZ25l
ZC1vZmYtYnk6IEVyaWMgQmVudGxleSBlcmljLmJlbnRsZXlAbGFpcmR0ZWNoLmNvbQ0KLS0tDQp2
MjogY29ycmVjdGVkIGVycmFudCAoIHdpdGggew0KLS0tDQpkcml2ZXJzL25ldC93aXJlbGVzcy9i
cm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvYmNtc2RoLmMgfCA0ICsrKy0NCjEgZmlsZSBjaGFu
Z2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9iY21zZGguYyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9iY21zZGguYw0K
aW5kZXggNzIxMzliNS4uMmY3ZDAzZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9iY21zZGguYw0KKysrIGIvZHJpdmVycy9uZXQv
d2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2JjbXNkaC5jDQpAQCAtMTI2NCw4
ICsxMjY0LDEwIEBAIHN0YXRpYyBpbnQgYnJjbWZfb3BzX3NkaW9fc3VzcGVuZChzdHJ1Y3QgZGV2
aWNlICpkZXYpDQogICAgICAgICAgICAgICAgIGVsc2UNCiAgICAgICAgICAgICAgICAgICAgICAg
ICBzZGlvX2ZsYWdzIHw9IE1NQ19QTV9XQUtFX1NESU9fSVJROw0KICAgICAgICAgfQ0KLSAgICAg
ICBpZiAoc2Rpb19zZXRfaG9zdF9wbV9mbGFncyhzZGlvZGV2LT5mdW5jWzFdLCBzZGlvX2ZsYWdz
KSkNCisgICAgICAgaWYgKHNkaW9fc2V0X2hvc3RfcG1fZmxhZ3Moc2Rpb2Rldi0+ZnVuY1sxXSwg
c2Rpb19mbGFncykpIHsNCiAgICAgICAgICAgICAgICAgYnJjbWZfZXJyKCJGYWlsZWQgdG8gc2V0
IHBtX2ZsYWdzICV4XG4iLCBzZGlvX2ZsYWdzKTsNCisgICAgICAgICAgICAgICByZXR1cm4gLUVJ
TlZBTDsNCisgICAgICAgfQ0KICAgICAgICAgcmV0dXJuIDA7DQp9DQotLQ0KMi42LjAuR0lUDQoN
Cg==
