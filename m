Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:35505 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbeBEWjN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Feb 2018 17:39:13 -0500
Received: by mail-qt0-f171.google.com with SMTP id g14so41779106qti.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Feb 2018 14:39:12 -0800 (PST)
MIME-Version: 1.0
From: Mike Lothian <mike@fireburn.co.uk>
Date: Mon, 5 Feb 2018 22:38:51 +0000
Message-ID: <CAHbf0-Eb3=OgpDLhgacYP4hcffh_9Y-iUj0GQAbzj2O9ag=z0A@mail.gmail.com> (sfid-20180205_233916_983540_42CB364A)
Subject: Regression in ath10k
To: linux-wireless@vger.kernel.org, yanhsu@codeaurora.org,
        valo@codeaurora.org
Content-Type: multipart/mixed; boundary="f403043af58829455305647ebbbe"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--f403043af58829455305647ebbbe
Content-Type: text/plain; charset="UTF-8"

Hi

Since the merge window opened I've been unable to see any wireless
networks or join my usual access point

I bisected this to:

9ed4f91628737c820af6a1815b65bc06bd31518f is the first bad commit
commit 9ed4f91628737c820af6a1815b65bc06bd31518f
Author: Ryan Hsu <ryanhsu@codeaurora.org>
Date:   Tue Jan 16 11:43:49 2018 +0200

   ath10k: add sanity check to ie_len before parsing fw/board ie

   Validate ie_len after the alignment padding before access the buffer
   to avoid potential overflow.

   Signed-off-by: Ryan Hsu <ryanhsu@codeaurora.org>
   Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

And I can confirm that reverting the patch makes things work again (attached)

Device:

3c:00.0 Network controller [0280]: Qualcomm Atheros QCA6174 802.11ac
Wireless Network Adapter [168c:003e] (rev 32)

Firmware:

https://github.com/kvalo/ath10k-firmware

ath10k-firmware/QCA6174/hw3.0/4.4.1.c1

There was nothing obvious in the dmesg

Regards

Mike

--f403043af58829455305647ebbbe
Content-Type: text/x-patch; charset="US-ASCII"; name="06-ath10k-revert.patch"
Content-Disposition: attachment; filename="06-ath10k-revert.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jdasodho0

Y29tbWl0IDk1ZjIxMWI4N2IyM2EyNTg2ZWE1Y2IwMWY2MWU4Zjc5NDViNzgwNGUKQXV0aG9yOiBN
aWtlIExvdGhpYW4gPG1pa2VAZmlyZWJ1cm4uY28udWs+CkRhdGU6ICAgTW9uIEZlYiA1IDIyOjE2
OjQxIDIwMTggKzAwMDAKCiAgICBSZXZlcnQgImF0aDEwazogYWRkIHNhbml0eSBjaGVjayB0byBp
ZV9sZW4gYmVmb3JlIHBhcnNpbmcgZncvYm9hcmQgaWUiCiAgICAKICAgIFRoaXMgcmV2ZXJ0cyBj
b21taXQgOWVkNGY5MTYyODczN2M4MjBhZjZhMTgxNWI2NWJjMDZiZDMxNTE4Zi4KCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBrL2NvcmUuYyBiL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2F0aC9hdGgxMGsvY29yZS5jCmluZGV4IGIwZmRjMTAyMzYxOS4uZTg5YTc4NDZk
ZGRiIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBrL2NvcmUuYwor
KysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBrL2NvcmUuYwpAQCAtMTI3NiwxMCAr
MTI3Niw3IEBAIHN0YXRpYyBpbnQgYXRoMTBrX2NvcmVfZmV0Y2hfYm9hcmRfZGF0YV9hcGlfbihz
dHJ1Y3QgYXRoMTBrICphciwKIAkJbGVuIC09IHNpemVvZigqaGRyKTsKIAkJZGF0YSA9IGhkci0+
ZGF0YTsKIAotCQkvKiBqdW1wIG92ZXIgdGhlIHBhZGRpbmcgKi8KLQkJaWVfbGVuID0gQUxJR04o
aWVfbGVuLCA0KTsKLQotCQlpZiAobGVuIDwgaWVfbGVuKSB7CisJCWlmIChsZW4gPCBBTElHTihp
ZV9sZW4sIDQpKSB7CiAJCQlhdGgxMGtfZXJyKGFyLCAiaW52YWxpZCBsZW5ndGggZm9yIGJvYXJk
IGllX2lkICVkIGllX2xlbiAlenUgbGVuICV6dVxuIiwKIAkJCQkgICBpZV9pZCwgaWVfbGVuLCBs
ZW4pOwogCQkJcmV0ID0gLUVJTlZBTDsKQEAgLTEzMTgsNiArMTMxNSw4IEBAIHN0YXRpYyBpbnQg
YXRoMTBrX2NvcmVfZmV0Y2hfYm9hcmRfZGF0YV9hcGlfbihzdHJ1Y3QgYXRoMTBrICphciwKIAkJ
CWdvdG8gb3V0OwogCQl9CiAKKwkJLyoganVtcCBvdmVyIHRoZSBwYWRkaW5nICovCisJCWllX2xl
biA9IEFMSUdOKGllX2xlbiwgNCk7CiAJCWxlbiAtPSBpZV9sZW47CiAJCWRhdGEgKz0gaWVfbGVu
OwogCX0KQEAgLTE0NDgsOSArMTQ0Nyw2IEBAIGludCBhdGgxMGtfY29yZV9mZXRjaF9maXJtd2Fy
ZV9hcGlfbihzdHJ1Y3QgYXRoMTBrICphciwgY29uc3QgY2hhciAqbmFtZSwKIAkJbGVuIC09IHNp
emVvZigqaGRyKTsKIAkJZGF0YSArPSBzaXplb2YoKmhkcik7CiAKLQkJLyoganVtcCBvdmVyIHRo
ZSBwYWRkaW5nICovCi0JCWllX2xlbiA9IEFMSUdOKGllX2xlbiwgNCk7Ci0KIAkJaWYgKGxlbiA8
IGllX2xlbikgewogCQkJYXRoMTBrX2VycihhciwgImludmFsaWQgbGVuZ3RoIGZvciBGVyBJRSAl
ZCAoJXp1IDwgJXp1KVxuIiwKIAkJCQkgICBpZV9pZCwgbGVuLCBpZV9sZW4pOwpAQCAtMTU1Niw2
ICsxNTUyLDkgQEAgaW50IGF0aDEwa19jb3JlX2ZldGNoX2Zpcm13YXJlX2FwaV9uKHN0cnVjdCBh
dGgxMGsgKmFyLCBjb25zdCBjaGFyICpuYW1lLAogCQkJYnJlYWs7CiAJCX0KIAorCQkvKiBqdW1w
IG92ZXIgdGhlIHBhZGRpbmcgKi8KKwkJaWVfbGVuID0gQUxJR04oaWVfbGVuLCA0KTsKKwogCQls
ZW4gLT0gaWVfbGVuOwogCQlkYXRhICs9IGllX2xlbjsKIAl9Cg==
--f403043af58829455305647ebbbe--
