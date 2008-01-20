Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:58583 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492AbYATSeK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2008 13:34:10 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1122442fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jan 2008 10:34:06 -0800 (PST)
Message-ID: <4793935F.2000102@gmail.com> (sfid-20080120_183429_961619_E602F024)
Date: Sun, 20 Jan 2008 20:30:55 +0200
From: "Volodymyr G. Lukiianyk" <volodymyrgl@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH] WEXT: Correct the size of the buffer to be copied to user-space
 in standard GET WE ioctls.
Content-Type: multipart/mixed;
 boundary="------------050604070809070509040500"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050604070809070509040500
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

For the most of standard WE GET ioctls the size of the buffer to store driver's
response is calculated on base of the call's descriptor (.token_size and
.max_tokens fields) without taking into consideration the size of the buffer
provided by application in struct iwreq. But when the response is being copied to
userspace, its size is calculated from the length provided by application. This
can lead to kernel internal data leak into userspace, and oopses when the buffer
is located near the end of the available memory. To prevent these situations the
size used during copying is set to the same one used during allocation.


Signed-off-by: Volodymyr G Lukiianyk <volodymyrgl@gmail.com>
---

I've actually seen those oopses on the system with 32MB of memory, when 1k
object at address c1fffc00 was returned by the SLAB while handling request for
allocating 568 bytes buffer (struct iw_range). Later, copy_to_user() (instructed
to copy 1136 bytes, since iwlist uses 2x buffer) crashed trying to access
c2000000, which is beyond the bounds of available 32MB.

The patch attached is against the Linus's tree.


--------------050604070809070509040500
Content-Type: text/plain;
 name="fix_copied_buffer_size.diff"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="fix_copied_buffer_size.diff"

ZGlmZiAtLWdpdCBhL25ldC93aXJlbGVzcy93ZXh0LmMgYi9uZXQvd2lyZWxlc3Mvd2V4dC5j
CmluZGV4IDQ3ZTgwY2MuLmM2Y2U1OWIgMTAwNjQ0Ci0tLSBhL25ldC93aXJlbGVzcy93ZXh0
LmMKKysrIGIvbmV0L3dpcmVsZXNzL3dleHQuYwpAQCAtODY2LDggKzg2Niw3IEBAIHN0YXRp
YyBpbnQgaW9jdGxfc3RhbmRhcmRfY2FsbChzdHJ1Y3QgbmV0X2RldmljZSAqCWRldiwKIAkJ
CX0KIAogCQkJZXJyID0gY29weV90b191c2VyKGl3ci0+dS5kYXRhLnBvaW50ZXIsIGV4dHJh
LAotCQkJCQkgICBpd3ItPnUuZGF0YS5sZW5ndGggKgotCQkJCQkgICBkZXNjci0+dG9rZW5f
c2l6ZSk7CisJCQkJCSAgIGV4dHJhX3NpemUpOwogCQkJaWYgKGVycikKIAkJCQlyZXQgPSAg
LUVGQVVMVDsKIAkJfQo=
--------------050604070809070509040500--
