Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:55560 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3IITDc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 15:03:32 -0400
Received: by mail-oa0-f49.google.com with SMTP id i7so6860299oag.22
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 12:03:32 -0700 (PDT)
Message-ID: <522E1B7D.5010107@lwfinger.net> (sfid-20130909_210336_106496_C847640E)
Date: Mon, 09 Sep 2013 14:03:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
CC: Timothy Rundle <tgrundlesr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTL8192CU continually reconnecting
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com> <522D054B.5060205@lwfinger.net> <522DD856.7050309@ilande.co.uk> <522DE1BE.6070904@lwfinger.net> <522DE8CA.9010008@ilande.co.uk> <522DFF83.6000605@lwfinger.net> <522E0573.4000804@ilande.co.uk>
In-Reply-To: <522E0573.4000804@ilande.co.uk>
Content-Type: multipart/mixed;
 boundary="------------040909090805070705000900"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040909090805070705000900
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/09/2013 12:29 PM, Mark Cave-Ayland wrote:
> Please find the attached dmesg output from my current environment which is
> Linus' git commit 6a7492a4b2e05051a44458d7187023e22d580666 along with your
> beacon patch.
>
> Does that help provide any further insight? To my untrained eye, it really looks
> as if I'm not getting beacons every 6s as suggested by the comments in base.c.
>
> (Feel free to CC any replies back to the list if you're happy no secrets are
> being revealed)

There were no secrets in that dump, but it did reveal a major clue.

A response from your system for your AP was:

mode 2, state 0, is_beacon 0, is_probe_resp 1, length 147

For the number of beacons to be updated, the state has to be 2 or 3. My system 
has scan_ssid=1 in the wpa_supplicant configuration file. When the scan 
finishes, then a value of 2 is set into the mode variable.

The attached updated patch should set the correct mode even if scanning is not 
enabled.

Larry


--------------040909090805070705000900
Content-Type: text/plain; charset=UTF-8;
 name="rtl8192cu_dump_AP_off"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="rtl8192cu_dump_AP_off"

SW5kZXg6IHdpcmVsZXNzLXRlc3Rpbmctc2F2ZS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3
aWZpL2Jhc2UuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSB3aXJlbGVzcy10ZXN0aW5nLXNhdmUub3Jp
Zy9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL2Jhc2UuYworKysgd2lyZWxlc3MtdGVz
dGluZy1zYXZlL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvYmFzZS5jCkBAIC0xMjg3
LDcgKzEyODcsMTMgQEAgdm9pZCBydGxfYmVhY29uX3N0YXRpc3RpYyhzdHJ1Y3QgaWVlZTgw
MgogewogCXN0cnVjdCBydGxfcHJpdiAqcnRscHJpdiA9IHJ0bF9wcml2KGh3KTsKIAlzdHJ1
Y3QgaWVlZTgwMjExX2hkciAqaGRyID0gKHN0cnVjdCBpZWVlODAyMTFfaGRyICopc2tiLT5k
YXRhOworCXN0YXRpYyBpbnQgY291bnQ7CiAKKwlpZiAoY291bnQrKyA8IDEwMCkgeworCQlw
cl9pbmZvKCJtb2RlICVkLCBzdGF0ZSAlZCwgaXNfYmVhY29uICVkLCBpc19wcm9iZV9yZXNw
ICVkLCBsZW5ndGggJWQsIE1BQyAlcE1cbiIsCisJCQlydGxwcml2LT5tYWM4MDIxMS5vcG1v
ZGUsIHJ0bHByaXYtPm1hYzgwMjExLmxpbmtfc3RhdGUsIGllZWU4MDIxMV9pc19iZWFjb24o
aGRyLT5mcmFtZV9jb250cm9sKSwKKwkJCWllZWU4MDIxMV9pc19wcm9iZV9yZXNwKGhkci0+
ZnJhbWVfY29udHJvbCksIHNrYi0+bGVuLCBoZHItPmFkZHIzKTsKKwl9CiAJaWYgKHJ0bHBy
aXYtPm1hYzgwMjExLm9wbW9kZSAhPSBOTDgwMjExX0lGVFlQRV9TVEFUSU9OKQogCQlyZXR1
cm47CiAKSW5kZXg6IHdpcmVsZXNzLXRlc3Rpbmctc2F2ZS9kcml2ZXJzL25ldC93aXJlbGVz
cy9ydGx3aWZpL3VzYi5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIHdpcmVsZXNzLXRlc3Rpbmctc2F2
ZS5vcmlnL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvdXNiLmMKKysrIHdpcmVsZXNz
LXRlc3Rpbmctc2F2ZS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3VzYi5jCkBAIC00
ODQsNiArNDg0LDggQEAgc3RhdGljIHZvaWQgX3J0bF91c2JfcnhfcHJvY2Vzc19hZ2coc3Ry
dQogCQkJaWYgKHVuaWNhc3QpCiAJCQkJcnRscHJpdi0+bGlua19pbmZvLm51bV9yeF9pbnBl
cmlvZCsrOwogCQl9CisJCS8qIHN0YXRpYyBiY24gZm9yIHJvYW1pbmcgKi8KKwkJcnRsX2Jl
YWNvbl9zdGF0aXN0aWMoaHcsIHNrYik7CiAJfQogfQogCkluZGV4OiB3aXJlbGVzcy10ZXN0
aW5nLXNhdmUvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9jb3JlLmMKPT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PQotLS0gd2lyZWxlc3MtdGVzdGluZy1zYXZlLm9yaWcvZHJpdmVycy9uZXQvd2lyZWxl
c3MvcnRsd2lmaS9jb3JlLmMKKysrIHdpcmVsZXNzLXRlc3Rpbmctc2F2ZS9kcml2ZXJzL25l
dC93aXJlbGVzcy9ydGx3aWZpL2NvcmUuYwpAQCAtMTg0LDYgKzE4NCw3IEBAIHN0YXRpYyBp
bnQgcnRsX29wX2FkZF9pbnRlcmZhY2Uoc3RydWN0IGkKIAkJCQkJcnRscHJpdi0+Y2ZnLT5t
YXBzCiAJCQkJCVtSVExfSUJTU19JTlRfTUFTS1NdKTsKIAkJfQorCQltYWMtPmxpbmtfc3Rh
dGUgPSBNQUM4MDIxMV9MSU5LRUQ7CiAJCWJyZWFrOwogCWNhc2UgTkw4MDIxMV9JRlRZUEVf
QURIT0M6CiAJCVJUX1RSQUNFKHJ0bHByaXYsIENPTVBfTUFDODAyMTEsIERCR19MT1VELAo=
--------------040909090805070705000900--
