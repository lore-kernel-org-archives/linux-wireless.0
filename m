Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:55649 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaANS2k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 13:28:40 -0500
Received: by mail-ob0-f182.google.com with SMTP id wn1so7712281obc.13
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jan 2014 10:28:40 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 14 Jan 2014 19:28:39 +0100
Message-ID: <CABikg9yZrXX=qfqeR+V77u+Ndegx50D1_POAYMeq63qJuEzv=w@mail.gmail.com> (sfid-20140114_192843_552779_7398B6D0)
Subject: USB rt2x00 driver regression
From: Sergei Antonov <saproj@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Content-Type: multipart/mixed; boundary=f46d044789c381bbe004eff25c62
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--f46d044789c381bbe004eff25c62
Content-Type: text/plain; charset=UTF-8

Hello!
I use a USB Wi-Fi adapter identified as follows.

usb 2-4: new high-speed USB device number 5 using ehci-pci
usb 2-4: New USB device found, idVendor=148f, idProduct=5370
usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-4: Product: 802.11 n WLAN
usb 2-4: Manufacturer: Ralink
usb 2-4: SerialNumber: 1.0
usb 2-4: reset high-speed USB device number 5 using ehci-pci
ieee80211 phy3: rt2x00_set_rt: Info - RT chipset 5390, rev 0502 detected
ieee80211 phy3: rt2x00_set_rf: Info - RF chipset 5370 detected

It worked well with older kernels and does not with newer kernels.
Specifically it fails to find any AP when scanning.
The first bad commit is:

commit 76773f301f2210dcc20c466aebda7118062673eb
Author: Gabor Juhos <juhosg@openwrt.org>
Date:   Sat Aug 17 14:09:30 2013 +0200

    rt2x00: rt2800lib: use a MCU command for frequency adjustment on USB devices

    According to the Ralink driver, there is an MCU
    command which can be used to send the frequency
    offset value directly to the USB device without
    going through the RFCSR writing sequence.

    Based on the DPO_RT5572_LinuxSTA_2.6.0.1_20120629
    driver.

    Reference:
      RTMPAdjustFrequencyOffset function in common/rt_rf.c

    Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

After I removed this special USB handling (see the patch) the adapter
works again.

--f46d044789c381bbe004eff25c62
Content-Type: text/plain; charset=US-ASCII; name="rt2800.diff"
Content-Disposition: attachment; filename="rt2800.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hqfhq8cn0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0MngwMC9ydDI4MDAuaCBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3J0MngwMC9ydDI4MDAuaAppbmRleCBhYWI2YjVlLi44MzVlOTFkIDEw
MDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydDJ4MDAvcnQyODAwLmgKKysrIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvcnQyeDAwL3J0MjgwMC5oCkBAIC0yNzk4LDcgKzI3OTgsNiBAQCBl
bnVtIHJ0MjgwMF9lZXByb21fd29yZCB7CiAjZGVmaW5lIE1DVV9SQURBUgkJCTB4NjAKICNkZWZp
bmUgTUNVX0JPT1RfU0lHTkFMCQkJMHg3MgogI2RlZmluZSBNQ1VfQU5UX1NFTEVDVAkJCTBYNzMK
LSNkZWZpbmUgTUNVX0ZSRVFfT0ZGU0VUCQkJMHg3NAogI2RlZmluZSBNQ1VfQkJQX1NJR05BTAkJ
CTB4ODAKICNkZWZpbmUgTUNVX1BPV0VSX1NBVkUJCQkweDgzCiAjZGVmaW5lIE1DVV9CQU5EX1NF
TEVDVAkJCTB4OTEKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0MngwMC9ydDI4
MDBsaWIuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0MngwMC9ydDI4MDBsaWIuYwppbmRleCA3
NzZhZmYzLi4xZjgwY2YzIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydDJ4MDAv
cnQyODAwbGliLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnQyeDAwL3J0MjgwMGxpYi5j
CkBAIC0xOTAyLDEyICsxOTAyLDYgQEAgc3RhdGljIHZvaWQgcnQyODAwX2FkanVzdF9mcmVxX29m
ZnNldChzdHJ1Y3QgcnQyeDAwX2RldiAqcnQyeDAwZGV2KQogCWlmIChyZmNzciA9PSBwcmV2X3Jm
Y3NyKQogCQlyZXR1cm47CiAKLQlpZiAocnQyeDAwX2lzX3VzYihydDJ4MDBkZXYpKSB7Ci0JCXJ0
MjgwMF9tY3VfcmVxdWVzdChydDJ4MDBkZXYsIE1DVV9GUkVRX09GRlNFVCwgMHhmZiwKLQkJCQkg
ICBmcmVxX29mZnNldCwgcHJldl9yZmNzcik7Ci0JCXJldHVybjsKLQl9Ci0KIAlwcmV2X2ZyZXFf
b2Zmc2V0ID0gcnQyeDAwX2dldF9maWVsZDgocHJldl9yZmNzciwgUkZDU1IxN19DT0RFKTsKIAl3
aGlsZSAocHJldl9mcmVxX29mZnNldCAhPSBmcmVxX29mZnNldCkgewogCQlpZiAocHJldl9mcmVx
X29mZnNldCA8IGZyZXFfb2Zmc2V0KQo=
--f46d044789c381bbe004eff25c62--
