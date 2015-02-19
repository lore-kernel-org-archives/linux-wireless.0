Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37036 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbbBSSTY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2015 13:19:24 -0500
Received: by mail-ob0-f174.google.com with SMTP id wo20so17392128obc.5
        for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2015 10:19:23 -0800 (PST)
Message-ID: <54E6292A.3040106@lwfinger.net> (sfid-20150219_191927_684604_CF4531F2)
Date: Thu, 19 Feb 2015 12:19:22 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mike Turner <miketurner.forum@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8192cu beacon fix unreliable
References: <loom.20150213T114021-973@post.gmane.org>	<54E503B0.8020904@lwfinger.net> <CALA4C6XecJ+zGGfWkO51red7S-2mNoVC6vkD0ama1AGat2QOHg@mail.gmail.com>
In-Reply-To: <CALA4C6XecJ+zGGfWkO51red7S-2mNoVC6vkD0ama1AGat2QOHg@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090107080908030503030108"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090107080908030503030108
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/19/2015 11:37 AM, Mike Turner wrote:
> Sorry,
>
> I know personal replies aren't liked, however couldn't see how to send a reply
> to your reply to my original post. (if you can tell me how to do that then I
> will in future)
>
> Anyway, I had already checked the send_beacon_frame() call and it gets called
> whether or not the beacon starts.

If you use the web interface at Gmail, you can enable "reply all" in 
Settings=>Settings.

One other thing. Most mailing lists prefer bottom, not top, posting. That way 
you can read the thread in chronological order.

There must be some kind of race condition that sometimes makes the beacon start 
fail. Please try the attached patch to see if it helps.

Larry


--------------090107080908030503030108
Content-Type: text/plain; charset=UTF-8;
 name="rtl8192cu_beacon_start"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="rtl8192cu_beacon_start"

SW5kZXg6IHdpcmVsZXNzLWRyaXZlcnMvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9j
b3JlLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PQotLS0gd2lyZWxlc3MtZHJpdmVycy5vcmlnL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL3J0bHdpZmkvY29yZS5jCisrKyB3aXJlbGVzcy1kcml2ZXJzL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvY29yZS5jCkBAIC0xMDEwLDggKzEwMTAsNyBAQCBz
dGF0aWMgaW50IHJ0bF9vcF9jb25mX3R4KHN0cnVjdCBpZWVlODAyCiAJcmV0dXJuIDA7CiB9
CiAKLXN0YXRpYyB2b2lkIHNlbmRfYmVhY29uX2ZyYW1lKHN0cnVjdCBpZWVlODAyMTFfaHcg
Kmh3LAotCQkJICAgICAgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZikKK3ZvaWQgcnRsX3Nl
bmRfYmVhY29uX2ZyYW1lKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgw
MjExX3ZpZiAqdmlmKQogewogCXN0cnVjdCBydGxfcHJpdiAqcnRscHJpdiA9IHJ0bF9wcml2
KGh3KTsKIAlzdHJ1Y3Qgc2tfYnVmZiAqc2tiID0gaWVlZTgwMjExX2JlYWNvbl9nZXQoaHcs
IHZpZik7CkBAIC0xMDE5LDYgKzEwMTgsNyBAQCBzdGF0aWMgdm9pZCBzZW5kX2JlYWNvbl9m
cmFtZShzdHJ1Y3QgaWVlCiAJaWYgKHNrYikKIAkJcnRscHJpdi0+aW50Zl9vcHMtPmFkYXB0
ZXJfdHgoaHcsIE5VTEwsIHNrYiwgTlVMTCk7CiB9CitFWFBPUlRfU1lNQk9MKHJ0bF9zZW5k
X2JlYWNvbl9mcmFtZSk7CiAKIHN0YXRpYyB2b2lkIHJ0bF9vcF9ic3NfaW5mb19jaGFuZ2Vk
KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAogCQkJCSAgICBzdHJ1Y3QgaWVlZTgwMjExX3Zp
ZiAqdmlmLApAQCAtMTA1MCw3ICsxMDUwLDcgQEAgc3RhdGljIHZvaWQgcnRsX29wX2Jzc19p
bmZvX2NoYW5nZWQoc3RydQogCiAJCQkJaWYgKHJ0bHByaXYtPmNmZy0+b3BzLT5saW5rZWRf
c2V0X3JlZykKIAkJCQkJcnRscHJpdi0+Y2ZnLT5vcHMtPmxpbmtlZF9zZXRfcmVnKGh3KTsK
LQkJCQlzZW5kX2JlYWNvbl9mcmFtZShodywgdmlmKTsKKwkJCQlydGxfc2VuZF9iZWFjb25f
ZnJhbWUoaHcsIHZpZik7CiAJCQl9CiAJCX0KIAkJaWYgKChjaGFuZ2VkICYgQlNTX0NIQU5H
RURfQkVBQ09OX0VOQUJMRUQgJiYKSW5kZXg6IHdpcmVsZXNzLWRyaXZlcnMvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvcnRsd2lmaS9jb3JlLmgKPT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gd2lyZWxlc3Mt
ZHJpdmVycy5vcmlnL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvY29yZS5oCisrKyB3
aXJlbGVzcy1kcml2ZXJzL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvY29yZS5oCkBA
IC04NSw1ICs4NSw2IEBAIHZvaWQgcnRsX2JiX2RlbGF5KHN0cnVjdCBpZWVlODAyMTFfaHcg
KmgKIGJvb2wgcnRsX2NtZF9zZW5kX3BhY2tldChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywg
c3RydWN0IHNrX2J1ZmYgKnNrYik7CiBib29sIHJ0bF9idGNfc3RhdHVzX2ZhbHNlKHZvaWQp
Owogdm9pZCBydGxfZG1fZGlnaW5pdChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgdTMyIGN1
cl9pZ3ZhbCk7Cit2b2lkIHJ0bF9zZW5kX2JlYWNvbl9mcmFtZShzdHJ1Y3QgaWVlZTgwMjEx
X2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZik7CiAKICNlbmRpZgpJbmRleDog
d2lyZWxlc3MtZHJpdmVycy9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3J0bDgxOTJj
dS9ody5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0KLS0tIHdpcmVsZXNzLWRyaXZlcnMub3JpZy9kcml2ZXJz
L25ldC93aXJlbGVzcy9ydGx3aWZpL3J0bDgxOTJjdS9ody5jCisrKyB3aXJlbGVzcy1kcml2
ZXJzL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvcnRsODE5MmN1L2h3LmMKQEAgLTMw
LDYgKzMwLDcgQEAKICNpbmNsdWRlICIuLi93aWZpLmgiCiAjaW5jbHVkZSAiLi4vZWZ1c2Uu
aCIKICNpbmNsdWRlICIuLi9iYXNlLmgiCisjaW5jbHVkZSAiLi4vY29yZS5oIgogI2luY2x1
ZGUgIi4uL2NhbS5oIgogI2luY2x1ZGUgIi4uL3BzLmgiCiAjaW5jbHVkZSAiLi4vdXNiLmgi
CkBAIC0xNTI5LDYgKzE1MzAsNyBAQCB2b2lkIHJ0bDkyY3Vfc2V0X2JlYWNvbl9pbnRlcnZh
bChzdHJ1Y3QKIAlSVF9UUkFDRShydGxwcml2LCBDT01QX0JFQUNPTiwgREJHX0RNRVNHLCAi
YmVhY29uX2ludGVydmFsOiVkXG4iLAogCQkgYmNuX2ludGVydmFsKTsKIAlydGxfd3JpdGVf
d29yZChydGxwcml2LCBSRUdfQkNOX0lOVEVSVkFMLCBiY25faW50ZXJ2YWwpOworCXJ0bF9z
ZW5kX2JlYWNvbl9mcmFtZShodywgbWFjLT52aWYpOwogfQogCiB2b2lkIHJ0bDkyY3VfdXBk
YXRlX2ludGVycnVwdF9tYXNrKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAo=
--------------090107080908030503030108--
