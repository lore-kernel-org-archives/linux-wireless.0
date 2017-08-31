Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0093.outbound.protection.outlook.com ([104.47.42.93]:25785
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751307AbdHaXh2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 19:37:28 -0400
From: Eric Bentley <Eric.Bentley@lairdtech.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>
Subject: [PATCH] Correctly fail to suspend when SDIO does not support power on
 suspend
Date: Thu, 31 Aug 2017 23:37:25 +0000
Message-ID: <B63CA48C-C400-4657-834E-23467705FEE3@lairdtech.com> (sfid-20170901_013738_339346_DDB17431)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DQpSZXR1cm4gZXJyb3Igd2hlbiBmYWlsaW5nIHRvIHNldCBwb3dlciBtYW5hZ2VtZW50IGNhcGFi
aWxpdGllcyBmbGFnLiAgVGhpcyB3aWxsIGNhdXNlIHRoZSBzdXNwZW5kIHRvIGZhaWwgYnV0IHRo
ZSByYWRpbw0Kd2lsbCBjb250aW51ZSB0byBvcGVyYXRlLiAgQWxsb3dpbmcgdGhpcyB0byBmYWls
IHdpdGhvdXQgcmVwb3J0aW5nIGVycm9yIHdpbGwgY2F1c2UgdGhlIHJhZGlvIHRvIGJlIG5vbi1m
dW5jdGlvbmFsIG9uIA0KcmVzdW1lIGFzIGl0IHdpbGwgaGF2ZSBsb3N0IHBvd2VyLg0KDQpTaWdu
ZWQtb2ZmLWJ5OiBFcmljIEJlbnRsZXkgPGVyaWMuYmVudGxleUBsYWlyZHRlY2guY29tPg0KDQot
LS0NCiBkcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvYmNt
c2RoLmMgfCA0ICsrKy0NCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0
aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNt
ODAyMTEvYnJjbWZtYWMvYmNtc2RoLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9i
cmNtODAyMTEvYnJjbWZtYWMvYmNtc2RoLmMNCmluZGV4IDcyMTM5YjUuLjJmN2QwM2YgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMv
YmNtc2RoLmMNCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9i
cmNtZm1hYy9iY21zZGguYw0KQEAgLTEyNjQsOCArMTI2NCwxMCBAQCBzdGF0aWMgaW50IGJyY21m
X29wc19zZGlvX3N1c3BlbmQoc3RydWN0IGRldmljZSAqZGV2KQ0KIAkJZWxzZQ0KIAkJCXNkaW9f
ZmxhZ3MgfD0gTU1DX1BNX1dBS0VfU0RJT19JUlE7DQogCX0NCi0JaWYgKHNkaW9fc2V0X2hvc3Rf
cG1fZmxhZ3Moc2Rpb2Rldi0+ZnVuY1sxXSwgc2Rpb19mbGFncykpDQorCWlmIChzZGlvX3NldF9o
b3N0X3BtX2ZsYWdzKHNkaW9kZXYtPmZ1bmNbMV0sIHNkaW9fZmxhZ3MpKSAoDQogCQlicmNtZl9l
cnIoIkZhaWxlZCB0byBzZXQgcG1fZmxhZ3MgJXhcbiIsIHNkaW9fZmxhZ3MpOw0KKwkJcmV0dXJu
IC1FSU5WQUw7DQorCX0NCiAJcmV0dXJuIDA7DQogfQ0KIA0KLS0gDQoyLjYuMC5HSVQNCg0KDQoN
Cg==
