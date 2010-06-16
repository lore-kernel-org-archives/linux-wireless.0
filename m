Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57009 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758804Ab0FPOFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 10:05:53 -0400
Received: by fxm10 with SMTP id 10so808965fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 07:05:52 -0700 (PDT)
Message-ID: <4C18DA3D.1030303@googlemail.com>
Date: Wed, 16 Jun 2010 16:05:49 +0200
From: Dennis Borgmann <dennis.borgmann@googlemail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
Subject: "ressource temporarily unavailable" on 2.4 GHz, not on 5GHz
Content-Type: multipart/mixed;
 boundary="------------020303010908080508030408"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020303010908080508030408
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hello wireless-list!
Hello hostapd-list!

I am using ath5k with hostapd-0.6.9 on a debian running kernel 2.6.34
and I am observing a "ressource temporarily unavailable" - error code 11
if I pump out multicast-packets quite fast. I wrote a small
test-program, that handles this test and as soon as I go down to a
8ms-pause or below in betweens the packets, the error is thrown quite
soon after starting the program. Funny thing is, that this error only
occurs in g-band (2.4 GHz), not in a-band (5GHz).

What could be the problem? Is this due to backoff-times in 2.4 GHz, that
don't occur on 5 GHz? Or could this be a bug?

Find attached my small piece of code to test and reproduce this effect.

Kind regards,
Dennis

--------------020303010908080508030408
Content-Type: text/x-csrc;
 name="connection_test_multicast.c"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="connection_test_multicast.c"

I2luY2x1ZGUgPHN5cy90eXBlcy5oPiAgICAgICAgICAvKiBTZWUgTk9URVMgKi8KI2luY2x1
ZGUgPHN5cy9zb2NrZXQuaD4KI2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxuZXRpbmV0
L2luLmg+CiNpbmNsdWRlIDxhcnBhL2luZXQuaD4gICAgIAojaW5jbHVkZSA8ZXJybm8uaD4K
I2luY2x1ZGUgPGxpbnV4L2lwLmg+CiNpbmNsdWRlIDxzdHJpbmcuaD4KI2luY2x1ZGUgPHN0
ZGxpYi5oPgojZGVmaW5lIE1VTFRJQ0FTVF9JUAkJCSIyMjQuMC4wLjEiCiNkZWZpbmUgUE9S
VAkJCQkxMjM0NQogICAgCnN0cnVjdCBzb2NrYWRkcl9pbiBzZXJ2ZXJfYWRkcmVzczsKaW50
IGZkX3NvY2tldDsKCmludCBpbml0X2Nvbm5lY3Rpb25fY2xpZW50KCB2b2lkICkgewoJaW50
IHNvY2ssIG9wdDsKCgllcnJubyA9IDA7CgkvL2NyZWF0ZSBhIHNvY2tldAoJc29jayA9IHNv
Y2tldCggUEZfSU5FVCwgU09DS19ER1JBTSwgMCApOwoJaWYoIHNvY2sgPT0gLTEgKSB7CgkJ
cHJpbnRmKCIlczoldSBzb2NrZXQoKSBlcnJvciAoJXMpLCBlcnJvci1jb2RlOiAlZFxuIiwg
X19GSUxFX18sIF9fTElORV9fLCBzdHJlcnJvcihlcnJubyksIHNvY2spOwoJCWV4aXQoRVhJ
VF9GQUlMVVJFKTsKCX0KCXNlcnZlcl9hZGRyZXNzLnNpbl9mYW1pbHkgPSBQRl9JTkVUOwoJ
c2VydmVyX2FkZHJlc3Muc2luX2FkZHIuc19hZGRyID0gaW5ldF9hZGRyKCBNVUxUSUNBU1Rf
SVAgKTsKCXNlcnZlcl9hZGRyZXNzLnNpbl9wb3J0ID0gaHRvbnMoIFBPUlQgKTsKCglpZigg
YmluZCggc29jaywgKHN0cnVjdCBzb2NrYWRkciopJnNlcnZlcl9hZGRyZXNzLCBzaXplb2Yo
c3RydWN0IHNvY2thZGRyKSkgPT0gLTEgKSB7CgkJcHJpbnRmKCIlczoldSBiaW5kIGVycm9y
ICglcyksIGVycm9yLWNvZGU6ICVkXG4iLCBfX0ZJTEVfXywgX19MSU5FX18sIHN0cmVycm9y
KGVycm5vKSwgZXJybm8pOwoJCWV4aXQoRVhJVF9GQUlMVVJFKTsKCX0KCS8vc2V0IHNvY2tl
dCBvcHRpb25zCgkvL0lQVE9TID0gdHlwZSBvZiBzZXJ2aWNlIGFuZCBwcmVjZWRlbmNlCgkv
L0lQVE9TX0xPV0RFTEFZID0gbWluaW1pemUgZGVsYXkKCS8vSVBUT1NfUFJFQ19QUklPUklU
WSA9IAoJb3B0ID0gSVBUT1NfUFJFQ19QUklPUklUWSB8IElQVE9TX0xPV0RFTEFZOwoJaWYo
IHNldHNvY2tvcHQoIHNvY2ssIElQUFJPVE9fSVAsIElQX1RPUywgJm9wdCwgc2l6ZW9mKG9w
dCkpID09IC0xICkgewoJCXByaW50ZigiJXM6JXUgc2V0c29ja29wdChJUF9UT1MpIGVycm9y
ICglcyksIGVycm9yLWNvZGU6ICVkXG4iLCBfX0ZJTEVfXywgX19MSU5FX18sIHN0cmVycm9y
KGVycm5vKSwgZXJybm8pOwoJCWV4aXQoRVhJVF9GQUlMVVJFKTsKCX0KCS8vZ2l2ZSB0aGVz
ZSBwYWNrZXRzIHRoZSBtYXhpbXVtIHByaW9yaXR5CgkvL1NPTF9TT0NLRVQgPSBtYW5pcHVs
YXRlIGF0IHNvY2tldCBsZXZlbAoJb3B0ID0gNzsKCWlmKCBzZXRzb2Nrb3B0KCBzb2NrLCBT
T0xfU09DS0VULCBTT19QUklPUklUWSwgJm9wdCwgc2l6ZW9mKG9wdCkpID09IC0xICkgewoJ
CXByaW50ZigiJXM6JXUgc2V0c29ja29wdChTT19QUklPUklUWSkgZXJyb3IgKCVzKSwgZXJy
b3ItY29kZTogJWRcbiIsIF9fRklMRV9fLCBfX0xJTkVfXywgc3RyZXJyb3IoZXJybm8pLCBl
cnJubyk7CgkJZXhpdChFWElUX0ZBSUxVUkUpOwoJfQoKCXJldHVybiBzb2NrOwp9CmludCBz
ZW5kX2RhdGEoIHVuc2lnbmVkIGNoYXIgKm5ldHdvcmtfZGF0YSwgc2l6ZV90IGxlbiApIHsK
CWlmKCBzZW5kdG8oIGZkX3NvY2tldCwgbmV0d29ya19kYXRhLCBsZW4sIE1TR19ET05UV0FJ
VCwgXAoJCShzdHJ1Y3Qgc29ja2FkZHIqKSZzZXJ2ZXJfYWRkcmVzcywgc2l6ZW9mKHN0cnVj
dCBzb2NrYWRkcl9pbikgKSA9PSAtMSApIHsKCQkJcHJpbnRmKCIlczoldSBzZW5kdG8oKSBl
cnJvciAoJXMpLCBlcnJvci1jb2RlOiAlZFxuIiwgX19GSUxFX18sIF9fTElORV9fLCBzdHJl
cnJvcihlcnJubyksIGVycm5vKTsKCQkJcmV0dXJuIGVycm5vOwoJfQoKCXJldHVybiAwOwp9
CgppbnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpIHsKICB1bnNpZ25lZCBjaGFyICpk
YXRhX2Zvcl90cmFuc21pc3Npb247CiAgaW50IHNsZWVwZXI9YXRvaShhcmd2WzFdKTsKICBw
cmludGYoIiVkXG4iLHNsZWVwZXIpOwogIGRhdGFfZm9yX3RyYW5zbWlzc2lvbiA9IG1hbGxv
YyggMTA2OCApOwogIGZkX3NvY2tldD1pbml0X2Nvbm5lY3Rpb25fY2xpZW50KCk7CiAgd2hp
bGUoMSkgewoJc2VuZF9kYXRhKCBkYXRhX2Zvcl90cmFuc21pc3Npb24sIDEwNjggKTsgCgl1
c2xlZXAoc2xlZXBlcik7CiAgfQogcmV0dXJuIDA7Cn0=
--------------020303010908080508030408--
