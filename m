Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43921 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab2AFDMl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 22:12:41 -0500
Received: by iaeh11 with SMTP id h11so1895968iae.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jan 2012 19:12:40 -0800 (PST)
Message-ID: <4F0666A5.6070004@lwfinger.net> (sfid-20120106_041300_270240_7BBD36BC)
Date: Thu, 05 Jan 2012 21:12:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jean-Luc Duprat <jld@acm.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: Realtek rtl8192se in AP mode?
References: <CAP6E9idrT=gu6cnKqMzVMVEXqRHdyuADgBNJTdCebt1Rf1dcfg@mail.gmail.com>
In-Reply-To: <CAP6E9idrT=gu6cnKqMzVMVEXqRHdyuADgBNJTdCebt1Rf1dcfg@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080209080809080107040707"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080209080809080107040707
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/25/2011 06:59 PM, Jean-Luc Duprat wrote:
> I am trying to find out whether the Realtek rtl8192se is
> known to be stable and reliable in AP mode.  It certainly
> became functional with kernel 3.0 and I can get the interface
> into master mode, but whenever I try to connect to it my laptop reports
> connection timeouts.  Digging a little more with wireshark, it
> seems that authentication packets exchanged, but no association
> packets are coming through...
>
> I have detailed the details of my configuration in a post in the fedora forums:
> http://forums.fedoraforum.org/showthread.php?p=1533542
>
> Since this is a small-factor mini-ITX box, I'd like to get the
> built-in adapter to work.  Any reports of success using this chip in AP mode?
> I'm happy to help track down and debug any issues.

Jean-Luc,

I have had some success in getting rtl8192se to work as an AP using the attached 
patch on top of the latest wireless-testing. A recent compat-wireless should 
also work.

I need to do a lot more testing, but I had a ping going for 8100 seconds with 2% 
packet loss. Obviously, there is room for improvement but at least there is 
progress. BTW, I'm using a 10ec:8174 device for testing.

Larry



--------------080209080809080107040707
Content-Type: text/plain;
 name="rtl8192se_ap_fix"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="rtl8192se_ap_fix"

RHJpdmVyIHJ0bDgxOTJzZSBkb2VzIG5vdCB3b3JrIGluIEFQIG1vZGUgdW50aWwgdGhpcyBj
aGFuZ2UgaXMKYXBwbGllZC4KClNpZ25lZC1vZmYtYnk6IExhcnJ5IEZpbmdlciA8TGFycnku
RmluZ2VyQGx3ZmluZ2VyLm5ldD4KQ2M6IFN0YWJsZSA8c3RhYmxlQHZnZXIua2VybmVsLm9y
Zz4KLS0tCgpJbmRleDogd2lyZWxlc3MtdGVzdGluZy1uZXcvZHJpdmVycy9uZXQvd2lyZWxl
c3MvcnRsd2lmaS9wcy5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIHdpcmVsZXNzLXRlc3RpbmctbmV3
Lm9yaWcvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9wcy5jCisrKyB3aXJlbGVzcy10
ZXN0aW5nLW5ldy9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3BzLmMKQEAgLTIzOSw5
ICsyMzksNiBAQCB2b2lkIHJ0bF9pcHNfbmljX29uKHN0cnVjdCBpZWVlODAyMTFfaHcKIAll
bnVtIHJmX3B3cnN0YXRlIHJ0c3RhdGU7CiAJdW5zaWduZWQgbG9uZyBmbGFnczsKIAotCWlm
IChtYWMtPm9wbW9kZSAhPSBOTDgwMjExX0lGVFlQRV9TVEFUSU9OKQotCQlyZXR1cm47Ci0K
IAlzcGluX2xvY2tfaXJxc2F2ZSgmcnRscHJpdi0+bG9ja3MuaXBzX2xvY2ssIGZsYWdzKTsK
IAogCWlmIChwcHNjLT5pbmFjdGl2ZXBzKSB7Cg==
--------------080209080809080107040707--
