Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50603 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759593Ab2BJR5H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Feb 2012 12:57:07 -0500
Received: by qcqw6 with SMTP id w6so1787960qcq.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Feb 2012 09:57:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAObL_7Ha5JKBcxBFAG1VDvF0rcAxvWkLVe2Opi4mCcL0kR2YFg@mail.gmail.com>
References: <CAObL_7E2eW9aqz3VLsBU-=4+kMXrfPvfz6wCNUEdDHuJWVaSLA@mail.gmail.com>
	<CAFZTsKk9ojw9_XodisHf-dtHpL1n6xSRmmWDVniZ-Ps4-JLwvA@mail.gmail.com>
	<1328455870.7290.43.camel@wwguy-huron>
	<1DC40B07CD6EC041A66726C271A73AE611F67E@IRSMSX102.ger.corp.intel.com>
	<CAFZTsKnjkJSmMdNpNkQWzUggNcN+3Qx0OGVXzuPDsXr8+h1SiA@mail.gmail.com>
	<1328563980.3466.10.camel@jlt3.sipsolutions.net>
	<CAObL_7Ha5JKBcxBFAG1VDvF0rcAxvWkLVe2Opi4mCcL0kR2YFg@mail.gmail.com>
Date: Fri, 10 Feb 2012 18:57:05 +0100
Message-ID: <CAFZTsKmpDOv6aHBT70-0_0muaTNvqPJQpqqC-04OisGC4_Ymog@mail.gmail.com> (sfid-20120210_185713_194710_6261A25C)
Subject: Re: [Ilw] Re: 6300agn: queue stuck and driver doesn't recover
From: Alexander Schnaidt <alex.schnaidt@googlemail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Johannes Berg <johannes.berg@intel.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0023544707605e401804b89fdb08
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0023544707605e401804b89fdb08
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

>> Ok this makes sense. A few other people also recently reported this. I'm
>> currently (still) away from home so I can't reproduce this issue, and I
>> didn't find anything by just looking at the code. Traces for mac80211
>> and iwlwifi subsystems would be useful to look at in this case, I think,
>> if you want to record the failure case see:
>> http://wireless.kernel.org/en/developers/Documentation/mac80211/tracing
>> (-e mac80211 -e iwlwifi). If you do record it, please don't send the
>> traces to the list, bzip2 it and send it to me directly.
>
> I just reproduced the problem (or at least the similar problem
> affecting me) with swcrypto=3D1. =C2=A0I'll try to get a trace.
>
> --Andy

Hey!

Before you get started; Johannes Berg already came up with a patch for this=
.
Unfortunately the discussion drifted off the list so i reattach the patch h=
ere.
I hope that's fine with Johannes.

Applying it against 3.3.0-rc2 fixes my problem, you might want to give it a=
 try.

alex

Here's Johannes' original message:

>From: Berg, Johannes <johannes.berg@intel.com>
>Date: Tue, Feb 7, 2012 at 11:50 PM
>
>Great, thanks. I attached a more complete patch, if you want to give it a =
try -- I'll be putting that into the tree.
>
>johannes

--0023544707605e401804b89fdb08
Content-Type: application/octet-stream; name="crypto-fix.patch"
Content-Disposition: attachment; filename="crypto-fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gyhikp6h0

Y29tbWl0IDg2ZjkxOTk2NjhlODAzNTkzM2M5YzVhMWU0MmJlOWRlM2EzMjBjZDcKQXV0aG9yOiBK
b2hhbm5lcyBCZXJnIDxqb2hhbm5lcy5iZXJnQGludGVsLmNvbT4KRGF0ZTogICBUdWUgRmViIDcg
MjE6MTg6MzMgMjAxMiArMDEwMAoKICAgIGl3bHdpZmk6IGZpeCBrZXkgcmVtb3ZhbAogICAgCiAg
ICBXaGVuIHRyeWluZyB0byByZW1vdmUgYSBrZXksIHdlIGFsd2F5cyBzZW5kIGtleQogICAgZmxh
Z3MganVzdCBzZXR0aW5nIHRoZSBrZXkgdHlwZSwgbm90IGluY2x1ZGluZwogICAgdGhlIG11bHRp
Y2FzdCBmbGFnIGFuZCB0aGUga2V5IElELiBBcyBhIHJlc3VsdCwKICAgIHdoZW5ldmVyIGFueSBr
ZXkgd2FzIHJlbW92ZWQsIHRoZSB1bmljYXN0IGtleSAwCiAgICB3b3VsZCBiZSByZW1vdmVkLCBj
YXVzaW5nIGEgY29tcGxldGUgY29ubmVjdGlvbgogICAgbG9zcyBhZnRlciB0aGUgc2Vjb25kIHJl
a2V5ICh0aGUgZmlyc3QgZG9lc24ndAogICAgY2F1c2UgYSBrZXkgcmVtb3ZhbCkuIEZpeCB0aGUg
a2V5IHJlbW92YWwgY29kZQogICAgdG8gaW5jbHVkZSB0aGUga2V5IElEIGFuZCBtdWx0aWNhc3Qg
ZmxhZywgdGh1cwogICAgcmVtb3ZpbmcgdGhlIGNvcnJlY3Qga2V5LgogICAgCiAgICBDaGFuZ2Ut
SWQ6IElmNjQzMjdkNzhhMDcyNDBiNmQ4NmYzOWZkZWU0YWQ2ZDQzOGJjNGYwCiAgICBDYzogc3Rh
YmxlQHZnZXIua2VybmVsLm9yZwogICAgUmVwb3J0ZWQtYnk6IEFsZXhhbmRlciBTY2huYWlkdCA8
YWxleC5zY2huYWlkdEBnb29nbGVtYWlsLmNvbT4KICAgIFNpZ25lZC1vZmYtYnk6IEpvaGFubmVz
IEJlcmcgPGpvaGFubmVzLmJlcmdAaW50ZWwuY29tPgoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWFnbi1zdGEuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3
bHdpZmkvaXdsLWFnbi1zdGEuYwppbmRleCBkNmFhYjAwLi5mMTI5OGNkIDEwMDY0NAotLS0gYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC1hZ24tc3RhLmMKKysrIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWduLXN0YS5jCkBAIC0xMTkwLDYgKzExOTAsNyBAQCBp
bnQgaXdsX3JlbW92ZV9keW5hbWljX2tleShzdHJ1Y3QgaXdsX3ByaXYgKnByaXYsCiAJdW5zaWdu
ZWQgbG9uZyBmbGFnczsKIAlzdHJ1Y3QgaXdsX2FkZHN0YV9jbWQgc3RhX2NtZDsKIAl1OCBzdGFf
aWQgPSBpd2xhZ25fa2V5X3N0YV9pZChwcml2LCBjdHgtPnZpZiwgc3RhKTsKKwlfX2xlMTYga2V5
X2ZsYWdzOwogCiAJLyogaWYgc3RhdGlvbiBpc24ndCB0aGVyZSwgbmVpdGhlciBpcyB0aGUga2V5
ICovCiAJaWYgKHN0YV9pZCA9PSBJV0xfSU5WQUxJRF9TVEFUSU9OKQpAQCAtMTIxNSw3ICsxMjE2
LDE0IEBAIGludCBpd2xfcmVtb3ZlX2R5bmFtaWNfa2V5KHN0cnVjdCBpd2xfcHJpdiAqcHJpdiwK
IAkJSVdMX0VSUihwcml2LCAib2Zmc2V0ICVkIG5vdCB1c2VkIGluIHVDb2RlIGtleSB0YWJsZS5c
biIsCiAJCQlrZXljb25mLT5od19rZXlfaWR4KTsKIAotCXN0YV9jbWQua2V5LmtleV9mbGFncyA9
IFNUQV9LRVlfRkxHX05PX0VOQyB8IFNUQV9LRVlfRkxHX0lOVkFMSUQ7CisJa2V5X2ZsYWdzID0g
Y3B1X3RvX2xlMTYoa2V5Y29uZi0+a2V5aWR4IDw8IFNUQV9LRVlfRkxHX0tFWUlEX1BPUyk7CisJ
a2V5X2ZsYWdzIHw9IFNUQV9LRVlfRkxHX01BUF9LRVlfTVNLIHwgU1RBX0tFWV9GTEdfTk9fRU5D
IHwKKwkJICAgICBTVEFfS0VZX0ZMR19JTlZBTElEOworCisJaWYgKCEoa2V5Y29uZi0+ZmxhZ3Mg
JiBJRUVFODAyMTFfS0VZX0ZMQUdfUEFJUldJU0UpKQorCQlrZXlfZmxhZ3MgfD0gU1RBX0tFWV9N
VUxUSUNBU1RfTVNLOworCisJc3RhX2NtZC5rZXkua2V5X2ZsYWdzID0ga2V5X2ZsYWdzOwogCXN0
YV9jbWQua2V5LmtleV9vZmZzZXQgPSBXRVBfSU5WQUxJRF9PRkZTRVQ7CiAJc3RhX2NtZC5zdGEu
bW9kaWZ5X21hc2sgPSBTVEFfTU9ESUZZX0tFWV9NQVNLOwogCXN0YV9jbWQubW9kZSA9IFNUQV9D
T05UUk9MX01PRElGWV9NU0s7Cg==
--0023544707605e401804b89fdb08--
