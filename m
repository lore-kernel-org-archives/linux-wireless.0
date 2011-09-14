Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55120 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933201Ab1INVWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 17:22:08 -0400
Received: by gyg10 with SMTP id 10so1764794gyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 14:22:07 -0700 (PDT)
Message-ID: <4E711AFB.7030806@lwfinger.net> (sfid-20110914_232212_398965_F78B5FD4)
Date: Wed, 14 Sep 2011 16:22:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Semigod King <semigodking@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211 driver for RT3070 wifi card does not work on big-endian
 platform
References: <CA+TXxM3EgGZmo1F9GS+-QNWfTTgWFD4XHvG31JH=kabrr=ES=A@mail.gmail.com> <4E6911C2.2030309@lwfinger.net> <CA+TXxM0EOBs2x+6jh=0uwDTMTUD+9ZXQ8W-ZR+=TjSARV3kAeQ@mail.gmail.com> <4E6A1AB7.8080605@lwfinger.net> <CA+TXxM23gnbt5JG+s0QTCFm0Ljcc8nZnXH9PNkBaqqhBwMcVYA@mail.gmail.com>
In-Reply-To: <CA+TXxM23gnbt5JG+s0QTCFm0Ljcc8nZnXH9PNkBaqqhBwMcVYA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050009040104050602020909"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050009040104050602020909
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/09/2011 12:30 PM, Semigod King wrote:
> I noticed two lines of code:
>                  static const u32 wcid[2] = { 0xffffffff, 0x00ffffff };
>                  rt2800_register_multiwrite(rt2x00dev, MAC_WCID_ENTRY(i),
>                                                wcid, sizeof(wcid));
>
> Do you think the first line should be changed as below to eliminate
> platform difference?
>                  static const u32 wcid[2] = { 0xffffffff,
> cpu_to_le32(0x00ffffff) };

No, that kind of thing should not be done. Internal data that are not 
specifically set to be little- or big-endian should be in cpu order. The 
conversions need to be done when writing to or reading from the device when the 
order differs from that of the cpu.

The changes were minimal. Most of the time it took me were in getting Linux 
running on my Powerbook G4 and getting the code to compile - I had to work 
around a bug in gcc version 4.4.5 on the PowerMac platform. The patch I needed 
is attached. The performance of rt2800usb is not great. With netperf, I'm 
getting about 5 Mbps for the netperf MAERTS, STREAM, and SENDFILE tests.

Larry



--------------050009040104050602020909
Content-Type: text/plain;
 name="rt2x00_big_endian"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="rt2x00_big_endian"

SW5kZXg6IHdpcmVsZXNzLXRlc3RpbmctbmV3L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0Mngw
MC9ydDI4MDBsaWIuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSB3aXJlbGVzcy10ZXN0aW5nLW5ldy5v
cmlnL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0MngwMC9ydDI4MDBsaWIuYwkyMDExLTA5LTE0
IDE1OjI1OjAxLjU5NTczNTM0OCAtMDUwMAorKysgd2lyZWxlc3MtdGVzdGluZy1uZXcvZHJp
dmVycy9uZXQvd2lyZWxlc3MvcnQyeDAwL3J0MjgwMGxpYi5jCTIwMTEtMDktMTQgMTU6MjU6
MDkuMjkxNjQ0NjQ2IC0wNTAwCkBAIC0zNjk3LDE0ICszNjk3LDE1IEBACiAJcnQyODAwX3Jl
Z2J1c3lfcmVhZChydDJ4MDBkZXYsIEVGVVNFX0NUUkwsIEVGVVNFX0NUUkxfS0lDSywgJnJl
Zyk7CiAKIAkvKiBBcHBhcmVudGx5IHRoZSBkYXRhIGlzIHJlYWQgZnJvbSBlbmQgdG8gc3Rh
cnQgKi8KLQlydDI4MDBfcmVnaXN0ZXJfcmVhZF9sb2NrKHJ0MngwMGRldiwgRUZVU0VfREFU
QTMsCi0JCQkJCSh1MzIgKikmcnQyeDAwZGV2LT5lZXByb21baV0pOwotCXJ0MjgwMF9yZWdp
c3Rlcl9yZWFkX2xvY2socnQyeDAwZGV2LCBFRlVTRV9EQVRBMiwKLQkJCQkJKHUzMiAqKSZy
dDJ4MDBkZXYtPmVlcHJvbVtpICsgMl0pOwotCXJ0MjgwMF9yZWdpc3Rlcl9yZWFkX2xvY2so
cnQyeDAwZGV2LCBFRlVTRV9EQVRBMSwKLQkJCQkJKHUzMiAqKSZydDJ4MDBkZXYtPmVlcHJv
bVtpICsgNF0pOwotCXJ0MjgwMF9yZWdpc3Rlcl9yZWFkX2xvY2socnQyeDAwZGV2LCBFRlVT
RV9EQVRBMCwKLQkJCQkJKHUzMiAqKSZydDJ4MDBkZXYtPmVlcHJvbVtpICsgNl0pOworCXJ0
MjgwMF9yZWdpc3Rlcl9yZWFkX2xvY2socnQyeDAwZGV2LCBFRlVTRV9EQVRBMywgJnJlZyk7
CisJLyogVGhlIHJldHVybmVkIHZhbHVlIGlzIGluIENQVSBvcmRlciwgYnV0IGVlcHJvbSBp
cyBsZSAqLworCXJ0MngwMGRldi0+ZWVwcm9tW2ldID0gY3B1X3RvX2xlMzIocmVnKTsKKwly
dDI4MDBfcmVnaXN0ZXJfcmVhZF9sb2NrKHJ0MngwMGRldiwgRUZVU0VfREFUQTIsICZyZWcp
OworCSoodTMyICopJnJ0MngwMGRldi0+ZWVwcm9tW2kgKyAyXSA9IGNwdV90b19sZTMyKHJl
Zyk7CisJcnQyODAwX3JlZ2lzdGVyX3JlYWRfbG9jayhydDJ4MDBkZXYsIEVGVVNFX0RBVEEx
LCAmcmVnKTsKKwkqKHUzMiAqKSZydDJ4MDBkZXYtPmVlcHJvbVtpICsgNF0gPSBjcHVfdG9f
bGUzMihyZWcpOworCXJ0MjgwMF9yZWdpc3Rlcl9yZWFkX2xvY2socnQyeDAwZGV2LCBFRlVT
RV9EQVRBMCwgJnJlZyk7CisJKih1MzIgKikmcnQyeDAwZGV2LT5lZXByb21baSArIDZdID0g
Y3B1X3RvX2xlMzIocmVnKTsKIAogCW11dGV4X3VubG9jaygmcnQyeDAwZGV2LT5jc3JfbXV0
ZXgpOwogfQpAQCAtMzg3MCwxOSArMzg3MiwyMyBAQAogCQlyZXR1cm4gLUVOT0RFVjsKIAl9
CiAKLQlpZiAoIXJ0MngwMF9yZihydDJ4MDBkZXYsIFJGMjgyMCkgJiYKLQkgICAgIXJ0Mngw
MF9yZihydDJ4MDBkZXYsIFJGMjg1MCkgJiYKLQkgICAgIXJ0MngwMF9yZihydDJ4MDBkZXYs
IFJGMjcyMCkgJiYKLQkgICAgIXJ0MngwMF9yZihydDJ4MDBkZXYsIFJGMjc1MCkgJiYKLQkg
ICAgIXJ0MngwMF9yZihydDJ4MDBkZXYsIFJGMzAyMCkgJiYKLQkgICAgIXJ0MngwMF9yZihy
dDJ4MDBkZXYsIFJGMjAyMCkgJiYKLQkgICAgIXJ0MngwMF9yZihydDJ4MDBkZXYsIFJGMzAy
MSkgJiYKLQkgICAgIXJ0MngwMF9yZihydDJ4MDBkZXYsIFJGMzAyMikgJiYKLQkgICAgIXJ0
MngwMF9yZihydDJ4MDBkZXYsIFJGMzA1MikgJiYKLQkgICAgIXJ0MngwMF9yZihydDJ4MDBk
ZXYsIFJGMzMyMCkgJiYKLQkgICAgIXJ0MngwMF9yZihydDJ4MDBkZXYsIFJGNTM3MCkgJiYK
LQkgICAgIXJ0MngwMF9yZihydDJ4MDBkZXYsIFJGNTM5MCkpIHsKLQkJRVJST1IocnQyeDAw
ZGV2LCAiSW52YWxpZCBSRiBjaGlwc2V0IGRldGVjdGVkLlxuIik7CisJc3dpdGNoIChydDJ4
MDBkZXYtPmNoaXAucmYpIHsKKwljYXNlIFJGMjgyMDoKKwljYXNlIFJGMjg1MDoKKwljYXNl
IFJGMjcyMDoKKwljYXNlIFJGMjc1MDoKKwljYXNlIFJGMzAyMDoKKwljYXNlIFJGMjAyMDoK
KwljYXNlIFJGMzAyMToKKwljYXNlIFJGMzAyMjoKKwljYXNlIFJGMzA1MjoKKwljYXNlIFJG
MzMyMDoKKwljYXNlIFJGNTM3MDoKKwljYXNlIFJGNTM5MDoKKwkJYnJlYWs7CisJZGVmYXVs
dDoKKwkJRVJST1IocnQyeDAwZGV2LCAiSW52YWxpZCBSRiBjaGlwc2V0IDB4JXggZGV0ZWN0
ZWQuXG4iLAorCQkgICAgICBydDJ4MDBkZXYtPmNoaXAucmYpOwogCQlyZXR1cm4gLUVOT0RF
VjsKIAl9CiAK
--------------050009040104050602020909--
