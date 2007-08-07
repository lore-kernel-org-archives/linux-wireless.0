Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MGW3.Sony.CO.JP ([137.153.0.15]:32831 "EHLO mgw3.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758124AbXHGHlS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 03:41:18 -0400
Date: Tue, 07 Aug 2007 16:41:00 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] remove duplicated ioctl entries in compat_ioctl.c
Cc: linux-wireless@vger.kernel.org, jt@hpl.hp.com,
	geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <20070730144726.GA6586@tuxdriver.com>
References: <20070730145358.327D.MOKUNO@sm.sony.co.jp> <20070730144726.GA6586@tuxdriver.com>
Message-Id: <20070807153150.A867.MOKUNO@sm.sony.co.jp>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------_46B7F48ABDC603FCAF68_MULTIPART_MIXED_"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------_46B7F48ABDC603FCAF68_MULTIPART_MIXED_
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit

	Hi

On Mon, 30 Jul 2007 10:47:26 -0400
"John W. Linville" <linville@tuxdriver.com> wrote:

> Have you tested the both the old and the new wireless-tools on
> a kernel with your patch applied?  Both 32- and 64-bit versions?
> Do they all work equally well?

Sorry for my late reply.

OK, I tested the following this week:
  - kernel 2.6.23-rc2 (geoff's PS3 tree)
     - the patch applied(*1) and unpatched
      (*1) another patch also applied.  See later section
      
  - wirlesstools version 28 and 29 pre22
     - 64bit and 32bit compiled
     - iwpriv and iwconfig
  
Test 
  - boot each kernel of two versions (patched and unpatched) on PS3
  - associate zd1211rw to an access point with wpa_supplicant (64bit
    compiled)
  - run 'iwconfig eth1' and 'iwpriv eth1'
    four versions 
       wirelesstools v28/32bit, v28/64bit
       wirelesstools v29/32bit, v29/64bit
  - compare the outputs
  
As I expected, 32bit iwconfig and iwpriv did not show proper result on
unpatched kernel, like:

> [root@localhost wireless_tools.28.32]# ./iwpriv eth1
> eth1      no private ioctls.
> 
> [root@localhost wireless_tools.28.32]# ./iwconfig eth1
> Warning: Driver for device eth1 has been compiled with version 22
> of Wireless Extension, while this program supports up to version 20.
> Some things may be broken...
> 
> eth1      IEEE 802.11b/g  ESSID:off/any  Nickname:"zd1211"
>           Mode:Managed  Frequency:2.462 GHz  Access Point: 00:16:01:3A:F5:FD   
>           Bit Rate:24 Mb/s   
>           Encryption key:<too big>
> [root@localhost wireless_tools.29.32]# ./iwpriv eth1
> eth1      no private ioctls.
> 
> [root@localhost wireless_tools.29.32]# ./iwconfig eth1
> eth1      IEEE 802.11b/g  ESSID:off/any  Nickname:"zd1211"
>           Mode:Managed  Frequency:2.462 GHz  Access Point: 00:16:01:3A:F5:FD   
>           Bit Rate=24 Mb/s   
>           Encryption key:<too big>


On the patched kernel, 32bit iwconfig and iwpriv showed appropriate
outputs and were same as 64bit's output:

> [root@localhost wireless_tools.28.32]# ./iwpriv eth1
> eth1      Available private ioctls :
>           set_regdomain    (8BE0) : set   1 byte  & get   0      
>           get_regdomain    (8BE1) : set   0       & get   1 byte 
> 
> [root@localhost wireless_tools.28.32]# ./iwconfig eth1
> Warning: Driver for device eth1 has been compiled with version 22
> of Wireless Extension, while this program supports up to version 20.
> Some things may be broken...
> 
> eth1      IEEE 802.11b/g  ESSID:"planexuser"  Nickname:"zd1211"
>           Mode:Managed  Frequency:2.462 GHz  Access Point: 00:16:01:3A:F5:FD   
>           Bit Rate:24 Mb/s   
>           Encryption key:9741-5654-B44F-7C71-2B3A-F918-1908-431F   Security mode:open
>           Link Quality=81/100  Signal level=45/100  
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> [root@localhost wireless_tools.28.64]# ./iwpriv eth1
> eth1      Available private ioctls :
>           set_regdomain    (8BE0) : set   1 byte  & get   0      
>           get_regdomain    (8BE1) : set   0       & get   1 byte 
> 
> [root@localhost wireless_tools.28.64]# ./iwconfig eth1
> Warning: Driver for device eth1 has been compiled with version 22
> of Wireless Extension, while this program supports up to version 20.
> Some things may be broken...
> 
> eth1      IEEE 802.11b/g  ESSID:"planexuser"  Nickname:"zd1211"
>           Mode:Managed  Frequency:2.462 GHz  Access Point: 00:16:01:3A:F5:FD   
>           Bit Rate=24 Mb/s   
>           Encryption key:9741-5654-B44F-7C71-2B3A-F918-1908-431F   Security mode:open
>           Link Quality=82/100  Signal level=45/100  
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0

So I think SIOCGIWPRIV and SOICGIWSTAT issues were fixed without
regressions.


While this testing, I've found another problem for iocompat32. 

fs/compat_ioctl.c:do_wireless_ioctl() copies the contents of the
argument of the 32bit ioctls into allocated area.  But it does not copy
back the contents on the return from 64bit ioctl calls.  So the caller
would get the unmodified argument even if the ioctl handler modified it.
For example, SIOCGIWENCODE could not return proper key length to the
caller, then iwconfig would show the strange result:

>           Encryption key:<too big>

The applied patch fixes the issue.

As I mentioned early in this mail, I did testing showed above with this
patch and found no obvious issue, but I did not have time/test-suite to
do comprehensive testing.  Please someone do review this new patch and
test more.

regards

--
Masakazu MOKUNO

--------_46B7F48ABDC603FCAF68_MULTIPART_MIXED_
Content-Type: application/octet-stream;
 name="fix_do_wirless_ioctl.diff"
Content-Disposition: attachment;
 filename="fix_do_wirless_ioctl.diff"
Content-Transfer-Encoding: base64

QXMgc3RydWN0IGl3X3BvaW50IGlzIGJpLWRpcmVjdGlvbmFsIHBheWxvYWQsIHdlIHNob3VsZCBj
b3B5IGJhY2sgdGhlIGNvbnRlbnQKb24gcmV0dXJuIGZyb20gaW9jdGwgY2FsbHMKClNpZ25lZC1v
ZmYtYnk6IE1hc2FrYXp1IE1va3VubyA8bW9rdW5vQHNtLnNvbnkuY28uanA+Ci0tLQogZnMvY29t
cGF0X2lvY3RsLmMgfCAgIDIyICsrKysrKysrKysrKysrKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2Vk
LCAxOCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKLS0tIGEvZnMvY29tcGF0X2lvY3Rs
LmMKKysrIGIvZnMvY29tcGF0X2lvY3RsLmMKQEAgLTIzMTEsOCArMjMxMSwxMCBAQCBzdGF0aWMg
aW50IGRvX3dpcmVsZXNzX2lvY3RsKHVuc2lnbmVkIGluCiAJc3RydWN0IGl3cmVxIF9fdXNlciAq
aXdyX3U7CiAJc3RydWN0IGl3X3BvaW50IF9fdXNlciAqaXdwOwogCXN0cnVjdCBjb21wYXRfaXdf
cG9pbnQgX191c2VyICppd3BfdTsKLQljb21wYXRfY2FkZHJfdCBwb2ludGVyOworCWNvbXBhdF9j
YWRkcl90IHBvaW50ZXJfdTsKKwl2b2lkIF9fdXNlciAqcG9pbnRlcjsKIAlfX3UxNiBsZW5ndGgs
IGZsYWdzOworCWludCByZXQ7CiAKIAlpd3JfdSA9IGNvbXBhdF9wdHIoYXJnKTsKIAlpd3BfdSA9
IChzdHJ1Y3QgY29tcGF0X2l3X3BvaW50IF9fdXNlciAqKSAmaXdyX3UtPnUuZGF0YTsKQEAgLTIz
MzAsMTcgKzIzMzIsMjkgQEAgc3RhdGljIGludCBkb193aXJlbGVzc19pb2N0bCh1bnNpZ25lZCBp
bgogCQkJICAgc2l6ZW9mKGl3ci0+aWZyX2lmcm4uaWZybl9uYW1lKSkpCiAJCXJldHVybiAtRUZB
VUxUOwogCi0JaWYgKF9fZ2V0X3VzZXIocG9pbnRlciwgJml3cF91LT5wb2ludGVyKSB8fAorCWlm
IChfX2dldF91c2VyKHBvaW50ZXJfdSwgJml3cF91LT5wb2ludGVyKSB8fAogCSAgICBfX2dldF91
c2VyKGxlbmd0aCwgJml3cF91LT5sZW5ndGgpIHx8CiAJICAgIF9fZ2V0X3VzZXIoZmxhZ3MsICZp
d3BfdS0+ZmxhZ3MpKQogCQlyZXR1cm4gLUVGQVVMVDsKIAotCWlmIChfX3B1dF91c2VyKGNvbXBh
dF9wdHIocG9pbnRlciksICZpd3AtPnBvaW50ZXIpIHx8CisJaWYgKF9fcHV0X3VzZXIoY29tcGF0
X3B0cihwb2ludGVyX3UpLCAmaXdwLT5wb2ludGVyKSB8fAogCSAgICBfX3B1dF91c2VyKGxlbmd0
aCwgJml3cC0+bGVuZ3RoKSB8fAogCSAgICBfX3B1dF91c2VyKGZsYWdzLCAmaXdwLT5mbGFncykp
CiAJCXJldHVybiAtRUZBVUxUOwogCi0JcmV0dXJuIHN5c19pb2N0bChmZCwgY21kLCAodW5zaWdu
ZWQgbG9uZykgaXdyKTsKKwlyZXQgPSBzeXNfaW9jdGwoZmQsIGNtZCwgKHVuc2lnbmVkIGxvbmcp
IGl3cik7CisKKwlpZiAoX19nZXRfdXNlcihwb2ludGVyLCAmaXdwLT5wb2ludGVyKSB8fAorCSAg
ICBfX2dldF91c2VyKGxlbmd0aCwgJml3cC0+bGVuZ3RoKSB8fAorCSAgICBfX2dldF91c2VyKGZs
YWdzLCAmaXdwLT5mbGFncykpCisJCXJldHVybiAtRUZBVUxUOworCisJaWYgKF9fcHV0X3VzZXIo
cHRyX3RvX2NvbXBhdChwb2ludGVyKSwgJml3cF91LT5wb2ludGVyKSB8fAorCSAgICBfX3B1dF91
c2VyKGxlbmd0aCwgJml3cF91LT5sZW5ndGgpIHx8CisJICAgIF9fcHV0X3VzZXIoZmxhZ3MsICZp
d3BfdS0+ZmxhZ3MpKQorCQlyZXR1cm4gLUVGQVVMVDsKKworCXJldHVybiByZXQ7CiB9CiAKIC8q
IFNpbmNlIG9sZCBzdHlsZSBicmlkZ2UgaW9jdGwncyBlbmR1cCB1c2luZyBTSU9DREVWUFJJVkFU
RQo=
--------_46B7F48ABDC603FCAF68_MULTIPART_MIXED_--

