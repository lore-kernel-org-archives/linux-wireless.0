Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:39612 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaALORn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jan 2014 09:17:43 -0500
Received: by mail-oa0-f53.google.com with SMTP id h16so7014015oag.12
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jan 2014 06:17:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52B43718.504@broadcom.com>
References: <CAKH5=Lv=7CroQcx6x_JONnE+6mOTH1sLLcSxntGq2fogn-t4+Q@mail.gmail.com>
	<52B2E638.8060906@hauke-m.de>
	<CAKH5=LsaEw7GEHs5nb1omDeSMmcoFSXo8EEy+DeXvyXF5_1M_g@mail.gmail.com>
	<52B300FC.7070204@hauke-m.de>
	<52B31392.2070705@broadcom.com>
	<CACna6rwU8hroahpVsM7KTJD1iM2=12JuErr5LgCvswx+XsTjjA@mail.gmail.com>
	<52B43718.504@broadcom.com>
Date: Sun, 12 Jan 2014 15:17:42 +0100
Message-ID: <CACna6rx_6yyJ88YZ2A5=XjK61xC=F2fX9B54MQcuzcZBOotOrg@mail.gmail.com> (sfid-20140112_151748_939116_987280A5)
Subject: Re: bcm43236 complient in the compat-wireless-3.6.81???
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Naughtboy <skylvlinux@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e0116060056ee4404efc69f00
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--089e0116060056ee4404efc69f00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

2013/12/20 Arend van Spriel <arend@broadcom.com>:
> On 12/20/2013 08:57 AM, Rafa=C5=82 Mi=C5=82ecki wrote:
>> 2013/12/19 Arend van Spriel <arend@broadcom.com>:
>>> It is in the kernel tree under
>>> 'drivers/net/wireless/brcm80211/brcmfmac'. We only support rev 3 becaus=
e
>>> rev 2 and earlier do not have enough memory to run fullmac firmware.
>>> However, I have not found any rev 3 on the market. If you have please
>>> let me know.
>>
>> Could you say something more about rev 2? How does it work with
>> internal Broadcom driver? Is the firmware stored somewhere else? Does
>> it have some another kind of memory?
>
> It has a split-mac design. So at one end the spectrum there is
> mac80211-type drivers and at the other side are fullmac drivers like
> brcmfmac. rev 2 driver sits right in the middle of that with part of the
> 802.11 stack running on the host and part on the device. This device has
> not enough memory to run the fullmac firmware.

Thanks for your explanation. I think I understand now what means
WLC_HIGH, WLC_LOW, WLC_SPLIT you can see in
0001-Staging-Add-initial-release-of-brcm80211-Broadcom-80.patch. I
guess that softmac devices need WLC_HIGH and WLC_LOW, split devices
(like BCM43231) need WLC_HIGH (because LOW is implemented in firmware)
and full MAC devices need none of above.

As questions about these chipset come over and over, I added a new
section to the brcm80211 wiki page:
http://wireless.kernel.org/en/users/Drivers/brcm80211#Unsupported_Chips
I hope it's OK for you.

Btw. if anyone is interested, I've written a minimal user-space app to
read device info (DL_GETVER) from Broadcom USB dongle.
gcc -lusb-1.0 main.c -o bcmid

--=20
Rafa=C5=82

--089e0116060056ee4404efc69f00
Content-Type: text/x-csrc; charset=US-ASCII; name="main.c"
Content-Disposition: attachment; filename="main.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hqcdxuml1

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxlbmRpYW4uaD4KI2luY2x1ZGUgPGxpYnVzYi0x
LjAvbGlidXNiLmg+CgojZGVmaW5lIEJDTV9WRU5ET1JfSUQJMHgwODQ2CiNkZWZpbmUgQkNNX0RF
VklDRV9JRAkweDkwMTEKCiNkZWZpbmUgRExfR0VUVkVSCTUKCnN0cnVjdCBiY211c2JfaWQgewoJ
dWludDMyX3QgY2hpcDsKCXVpbnQzMl90IGNoaXByZXY7CgkvKiBCZWxvdyBhcmUgcmV0dXJuZWQg
YnkgcmVjZW50IGNhcmRzIG9ubHkgKi8KCXVpbnQzMl90IHJhbXNpemU7Cgl1aW50MzJfdCByZW1h
cGJhc2U7Cgl1aW50MzJfdCBib2FyZHR5cGU7Cgl1aW50MzJfdCBib2FyZHJldjsKfTsKCmludCBt
YWluKCkgewoJbGlidXNiX2NvbnRleHQgKmNvbnRleHQgPSBOVUxMOwoJbGlidXNiX2RldmljZV9o
YW5kbGUgKmhhbmRsZTsKCXN0cnVjdCBiY211c2JfaWQgaWQ7CglpbnQgYnl0ZXMsIGVycjsKCgls
aWJ1c2JfaW5pdCgmY29udGV4dCk7CgoJaGFuZGxlID0gbGlidXNiX29wZW5fZGV2aWNlX3dpdGhf
dmlkX3BpZChjb250ZXh0LCBCQ01fVkVORE9SX0lELCBCQ01fREVWSUNFX0lEKTsKCWlmICghaGFu
ZGxlKSB7CgkJcHJpbnRmKCJDb3VsZG4ndCBmaW5kL29wZW4gJTA0WDolMDRYIGRldmljZSAoaXMg
aXQgYXZhaWxhYmxlPyBhcmUgeW91IHJvb3Q/KVxuIiwgQkNNX1ZFTkRPUl9JRCwgQkNNX0RFVklD
RV9JRCk7CgkJcmV0dXJuIC0xOwoJfQoKCWVyciA9IGxpYnVzYl9jbGFpbV9pbnRlcmZhY2UoaGFu
ZGxlLCAwKTsKCWlmIChlcnIpIHsKCQlwcmludGYoIkNvdWxkbid0IGNsYWltICUwNFg6JTA0WCBk
ZXZpY2UgaW50ZXJmYWNlIChhbm90aGVyIGRyaXZlciB1c2luZyBpdD8pXG4iLCBCQ01fVkVORE9S
X0lELCBCQ01fREVWSUNFX0lEKTsKCQlyZXR1cm4gLTI7Cgl9CgoJYnl0ZXMgPSBsaWJ1c2JfY29u
dHJvbF90cmFuc2ZlcihoYW5kbGUsCgkJCQkJTElCVVNCX0VORFBPSU5UX0lOIHwgTElCVVNCX1JF
UVVFU1RfVFlQRV9WRU5ET1IgfCBMSUJVU0JfUkVDSVBJRU5UX0lOVEVSRkFDRSwKCQkJCQlETF9H
RVRWRVIsCgkJCQkJMCwgLyogd1ZhbHVlICovCgkJCQkJMCwgLyogd0luZGV4ICovCgkJCQkJKHVu
c2lnbmVkIGNoYXIgKikmaWQsCgkJCQkJc2l6ZW9mKHN0cnVjdCBiY211c2JfaWQpLAoJCQkJCTUw
MCk7CglpZiAoYnl0ZXMgPCAwKSB7CgkJcHJpbnRmKCJsaWJ1c2JfY29udHJvbF90cmFuc2ZlciBl
cnJvcjogJWRcbiIsIGJ5dGVzKTsKCQlyZXR1cm4gYnl0ZXM7Cgl9CglpZiAoYnl0ZXMgPT0gOCB8
fCBieXRlcyA9PSAyNCkgewoJCXByaW50ZigiW2lkXSAgICAgIGNoaXA6ICUwNFhcbiIsIGxlMzJ0
b2goaWQuY2hpcCkpOwoJCXByaW50ZigiW2lkXSAgIGNoaXByZXY6ICUwNFhcbiIsIGxlMzJ0b2go
aWQuY2hpcHJldikpOwoJCWlmIChieXRlcyA9PSAyNCkgewoJCQlwcmludGYoIltpZF0gICByYW1z
aXplOiAlMDRYXG4iLCBsZTMydG9oKGlkLnJhbXNpemUpKTsKCQkJcHJpbnRmKCJbaWRdIHJlbWFw
YmFzZTogJTA0WFxuIiwgbGUzMnRvaChpZC5yZW1hcGJhc2UpKTsKCQkJcHJpbnRmKCJbaWRdIGJv
YXJkdHlwZTogJTA0WFxuIiwgbGUzMnRvaChpZC5ib2FyZHR5cGUpKTsKCQkJcHJpbnRmKCJbaWRd
ICBib2FyZHJldjogJTA0WFxuIiwgbGUzMnRvaChpZC5ib2FyZHJldikpOwoJCX0KCX0gZWxzZSB7
CgkJcHJpbnRmKCJsaWJ1c2JfY29udHJvbF90cmFuc2ZlciByZXR1cm5lZCB1bmV4cGVjdGVkIGFt
b3VudCBvZiBieXRlcyAoJWQpXG4iLCBieXRlcyk7CgkJcmV0dXJuIC0zOwoJfQoKCWVyciA9IGxp
YnVzYl9yZWxlYXNlX2ludGVyZmFjZShoYW5kbGUsIDApOwoJaWYgKGVycikgewoJCXByaW50Zigi
Q291bGRuJ3QgcmVsZWFzZSAlMDRYOiUwNFggZGV2aWNlIGludGVyZmFjZVxuIiwgQkNNX1ZFTkRP
Ul9JRCwgQkNNX0RFVklDRV9JRCk7CgkJcmV0dXJuIC00OwoJfQoKCWxpYnVzYl9jbG9zZShoYW5k
bGUpOwoJbGlidXNiX2V4aXQoY29udGV4dCk7Cn0K
--089e0116060056ee4404efc69f00--
