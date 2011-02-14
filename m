Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45780 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1BNWcH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 17:32:07 -0500
Received: by qyk12 with SMTP id 12so4297970qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 14:32:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297720877.5683.3.camel@maggie>
References: <AANLkTimfTt7kiwtSiPfE0kYRXwgHXJPAv19xuiv-M=NG@mail.gmail.com>
	<1297282621.9734.5.camel@maggie>
	<AANLkTinjDMSCqxWbAfjZO_JkfBZeRoAZOG5Pxvf1v8Xr@mail.gmail.com>
	<1297720877.5683.3.camel@maggie>
Date: Mon, 14 Feb 2011 23:32:05 +0100
Message-ID: <AANLkTi=ayavFKJw9s-n-AvMDrtMxXdDcjV+BnoxO-qkE@mail.gmail.com>
Subject: Re: Notes on ssb specs and implementation
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: multipart/mixed; boundary=0016363b7e3e0e6012049c459ef4
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0016363b7e3e0e6012049c459ef4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

W dniu 14 lutego 2011 23:01 u=C5=BCytkownik Michael B=C3=BCsch <mb@bu3sch.d=
e> napisa=C5=82:
> On Mon, 2011-02-14 at 20:51 +0100, Rafa=C5=82 Mi=C5=82ecki wrote:
>> W dniu 9 lutego 2011 21:17 u=C5=BCytkownik Michael B=C3=BCsch <mb@bu3sch=
.de> napisa=C5=82:
>> > On Wed, 2011-02-09 at 21:00 +0100, Rafa=C5=82 Mi=C5=82ecki wrote:
>> >> Michael: was there any reasons why we didn't implement some parts of
>> >> core-disabling code?
>> >
>> > The function are complete as of latest reverse engineering efforts.
>> > Broadcom added stuff, if they do more stuff in latest code.
>>
>> Nothing has changed in specs since 2006:
>> http://bcm-v4.sipsolutions.net/Backplane?action=3Dinfo
>> For some reason routines that were present even in 2006 was not implemen=
ted.
>
> Well, so the function was implemented prior to 2006. Which doesn't
> surprise me. It was one of the first ones.
>
>> I've just written missing parts,
>
> May I see them?

Sure. It's not for submission, so you have to expect magic values.


>> tested and it still does not work :|
>> The only advantage discovered so far is that ssb detects sth is wrong
>> with IM state:
>> [ 2661.449647] ssb: Timeout waiting for bitmask 01800000 on register
>> 0F90 to clear.
>>
>> I can see wl experiencing the same problems after loading b43. It
>> reads 0xf90 dozen of times in a row.
>
> And that's the thing why I always avoid touching that function.
> There's so much magic going on, so that completely weird things happen
> all the time. :D

Hm, that looks pretty easy and not really complicated. Of course, if
you figure out how it's working.

Personally I don't like for example description at
http://bcm-v4.sipsolutions.net/802.11/PHY . It's really messed in "Put
PHY Into Reset".
Section "Put PHY Into Reset" is really "How to reset PHY" and it
duplicates code of takine PHY out of reset.

We also have a lot of magic in ssb_device_enable. We reset SB and PHY
at the same time. I guess it introduces some optimization but makes it
harder to understand, especially if you try to understand implemented
code and look as specs at the same time.

--=20
Rafa=C5=82

--0016363b7e3e0e6012049c459ef4
Content-Type: application/octet-stream; name="ssb.initiator.patch"
Content-Disposition: attachment; filename="ssb.initiator.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gk5ym3zc0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3NiL21haW4uYyBiL2RyaXZlcnMvc3NiL21haW4uYwppbmRl
eCAzOTE4ZDJjLi5hOTE3MjYxIDEwMDY0NAotLS0gYS9kcml2ZXJzL3NzYi9tYWluLmMKKysrIGIv
ZHJpdmVycy9zc2IvbWFpbi5jCkBAIC0xMjIwLDcgKzEyMjIsNyBAQCBzdGF0aWMgaW50IHNzYl93
YWl0X2JpdChzdHJ1Y3Qgc3NiX2RldmljZSAqZGV2LCB1MTYgcmVnLCB1MzIgYml0bWFzaywKIAog
dm9pZCBzc2JfZGV2aWNlX2Rpc2FibGUoc3RydWN0IHNzYl9kZXZpY2UgKmRldiwgdTMyIGNvcmVf
c3BlY2lmaWNfZmxhZ3MpCiB7Ci0JdTMyIHJlamVjdDsKKwl1MzIgcmVqZWN0LCB2YWw7CiAKIAlp
ZiAoc3NiX3JlYWQzMihkZXYsIFNTQl9UTVNMT1cpICYgU1NCX1RNU0xPV19SRVNFVCkKIAkJcmV0
dXJuOwpAQCAtMTIyOSwxMiArMTIzMSwyNCBAQCB2b2lkIHNzYl9kZXZpY2VfZGlzYWJsZShzdHJ1
Y3Qgc3NiX2RldmljZSAqZGV2LCB1MzIgY29yZV9zcGVjaWZpY19mbGFncykKIAlzc2Jfd3JpdGUz
MihkZXYsIFNTQl9UTVNMT1csIHJlamVjdCB8IFNTQl9UTVNMT1dfQ0xPQ0spOwogCXNzYl93YWl0
X2JpdChkZXYsIFNTQl9UTVNMT1csIHJlamVjdCwgMTAwMCwgMSk7CiAJc3NiX3dhaXRfYml0KGRl
diwgU1NCX1RNU0hJR0gsIFNTQl9UTVNISUdIX0JVU1ksIDEwMDAsIDApOworCisJaWYgKHNzYl9y
ZWFkMzIoZGV2LCBTU0JfSURMT1cpICYgU1NCX0lETE9XX0lOSVRJQVRPUikgeworCQl2YWwgPSBz
c2JfcmVhZDMyKGRldiwgU1NCX0lNU1RBVEUpOworCQlzc2Jfd3JpdGUzMihkZXYsIFNTQl9JTVNU
QVRFLCB2YWwgfCAweDAyMDAwMDAwKTsKKwkJc3NiX3dhaXRfYml0KGRldiwgU1NCX0lNU1RBVEUs
IDB4MDE4MDAwMDAsIDEwMDAsIDApOworCX0KKwogCXNzYl93cml0ZTMyKGRldiwgU1NCX1RNU0xP
VywKIAkJICAgIFNTQl9UTVNMT1dfRkdDIHwgU1NCX1RNU0xPV19DTE9DSyB8CiAJCSAgICByZWpl
Y3QgfCBTU0JfVE1TTE9XX1JFU0VUIHwKIAkJICAgIGNvcmVfc3BlY2lmaWNfZmxhZ3MpOwogCXNz
Yl9mbHVzaF90bXNsb3coZGV2KTsKIAorCWlmIChzc2JfcmVhZDMyKGRldiwgU1NCX0lETE9XKSAm
IFNTQl9JRExPV19JTklUSUFUT1IpIHsKKwkJdmFsID0gc3NiX3JlYWQzMihkZXYsIFNTQl9JTVNU
QVRFKTsKKwkJc3NiX3dyaXRlMzIoZGV2LCBTU0JfSU1TVEFURSwgdmFsICYgfjB4MDIwMDAwMDAp
OworCX0KKwogCXNzYl93cml0ZTMyKGRldiwgU1NCX1RNU0xPVywKIAkJICAgIHJlamVjdCB8IFNT
Ql9UTVNMT1dfUkVTRVQgfAogCQkgICAgY29yZV9zcGVjaWZpY19mbGFncyk7Cg==
--0016363b7e3e0e6012049c459ef4--
