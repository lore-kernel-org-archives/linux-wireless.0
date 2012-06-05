Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:55505 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab2FEEdf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 00:33:35 -0400
Received: by weyu7 with SMTP id u7so3302440wey.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jun 2012 21:33:34 -0700 (PDT)
MIME-Version: 1.0
From: Linus Torvalds <linus971@gmail.com>
Date: Mon, 4 Jun 2012 21:33:13 -0700
Message-ID: <CA+55aFxcC2mG8OUQ_cgM-vZGfnRZ09573b311G+81616Hgie9g@mail.gmail.com> (sfid-20120605_063338_789673_2F90D2E5)
Subject: iwlwifi: bad error case cleanup for startup failure
To: Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e6dab554431ac104c1b227b2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0016e6dab554431ac104c1b227b2
Content-Type: text/plain; charset=ISO-8859-1

If the iwlwifi firmware loading calling iwl_ucode_callback() fails to
start up the wireless driver - which will happen if CONFIG_PM is not
enabled due to a mac80211 bug - iwlwifi will incorrectly try to
release the firmware twice.

It already released the firmware and completed the firmware loading
event after copying it to the internal driver buffers, if the driver
startup fails it should not try to release it again.

The double release causes very nasty vmalloc() corruption, and results
in some rather non-obvious page faults. To make matters worse, this
happens within the context of the firmware loader callback, usually a
kworker thread - and the killing of that thread then causes further
problems, making the original issue very hard to discern.

The attached patch seems to fix it.

                   Linus

--0016e6dab554431ac104c1b227b2
Content-Type: application/octet-stream; name="iwlwifi.patch"
Content-Disposition: attachment; filename="iwlwifi.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h32h3fj30

Rml4IG5hc3R5IGl3bHdpZmkgZG91YmxlIGZyZWUgKGFuZCBkb3VibGUgY29tcGxldGUpIG9mIGZp
cm13YXJlIGxvYWRpbmcgZGF0YSBzdHJ1Y3R1cmVzCgpJZiB0aGUgd2lyZWxlc3Mgc3RhcnR1cCBm
YWlscyAtIHdoaWNoIGl0IHdpbGwgZG8gaWYgQ09ORklHX1BNIGlzIG5vdAplbmFibGVkIGR1ZSB0
byBhIGRpZmZlcmVudCBtYWM4MDIxMSBidWcsIGZvciBleGFtcGxlIC0gdGhlIGFscmVhZHkKZnJl
ZSdkIGZpcm13YXJlIGRhdGEgaXMgZnJlZWQgYWdhaW4uICBSZXN1bHRpbmcgaW4gbmFzdHkgdm1h
bGxvYyBhcmVhCmNvcnJ1cHRpb24sIG9kZCBwYWdlIGZhdWx0cywgYW5kIGtpbGxpbmcgb2YgdGhl
IHdvcmtlciB0aHJlYWQgdGhhdApsb2FkZWQgdGhlIGZpcm13YXJlLiAKClNpZ25lZC1vZmYtYnk6
IExpbnVzIFRvcnZhbGRzIDx0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZz4KLS0tCiBkcml2
ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC1kcnYuYyB8IDMgKystCiAxIGZpbGUgY2hhbmdl
ZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtZHJ2LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3
aWZpL2l3bC1kcnYuYwppbmRleCBkNzQyOTAwLi43ZjAzYmI3IDEwMDY0NAotLS0gYS9kcml2ZXJz
L25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC1kcnYuYworKysgYi9kcml2ZXJzL25ldC93aXJlbGVz
cy9pd2x3aWZpL2l3bC1kcnYuYwpAQCAtODY2LDcgKzg2Niw3IEBAIHN0YXRpYyB2b2lkIGl3bF91
Y29kZV9jYWxsYmFjayhjb25zdCBzdHJ1Y3QgZmlybXdhcmUgKnVjb2RlX3Jhdywgdm9pZCAqY29u
dGV4dCkKIAlkcnYtPm9wX21vZGUgPSBpd2xfZHZtX29wcy5zdGFydChkcnYtPnRyYW5zLCBkcnYt
PmNmZywgJmRydi0+ZncpOwogCiAJaWYgKCFkcnYtPm9wX21vZGUpCi0JCWdvdG8gb3V0X2ZyZWVf
Znc7CisJCWdvdG8gcmVsZWFzZV9kcml2ZXI7CiAKIAlyZXR1cm47CiAKQEAgLTg4Myw2ICs4ODMs
NyBAQCBzdGF0aWMgdm9pZCBpd2xfdWNvZGVfY2FsbGJhY2soY29uc3Qgc3RydWN0IGZpcm13YXJl
ICp1Y29kZV9yYXcsIHZvaWQgKmNvbnRleHQpCiAJcmVsZWFzZV9maXJtd2FyZSh1Y29kZV9yYXcp
OwogIG91dF91bmJpbmQ6CiAJY29tcGxldGUoJmRydi0+cmVxdWVzdF9maXJtd2FyZV9jb21wbGV0
ZSk7CisgcmVsZWFzZV9kcml2ZXI6CiAJZGV2aWNlX3JlbGVhc2VfZHJpdmVyKGRydi0+dHJhbnMt
PmRldik7CiB9CiAK
--0016e6dab554431ac104c1b227b2--
