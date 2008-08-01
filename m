Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:61380 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbYHAKL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 06:11:27 -0400
Received: by fg-out-1718.google.com with SMTP id 19so482820fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 01 Aug 2008 03:11:26 -0700 (PDT)
Message-ID: <4892E14A.4000203@gmail.com> (sfid-20080801_121131_210562_A4D1A440)
Date: Fri, 01 Aug 2008 13:11:22 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: [IWL3945]Fix statistics in monitor mode
Content-Type: multipart/mixed;
 boundary="------------010000050608070103010603"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010000050608070103010603
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I guess it is time for me to add my .02 cents to iwlwifi driver.
Recently I reported a bug about crazy statistics (> 100 quality for 
example) when turning on the monitor interface (this bug actually is 
triggered when card is put in monitor mode, thus shows up when promisc 
mode enabled as well)

It turns out that iwl3945_rx_reply_rx wasn't filling in the statistics 
when running in monitor on, instead a garbage was passed.


Best regards,
	Maxim Levitsky

--------------010000050608070103010603
Content-Type: application/mbox;
 name="0001-IWL3945-Fix-statistics-in-monitor-mode.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="0001-IWL3945-Fix-statistics-in-monitor-mode.patch"

RnJvbSA5MmI3NTk0ZGM0MDI1NDQ5NWMzMmRlNDJhMjE2M2E0MDkwMjVkZmNlIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBNYXhpbSBMZXZpdHNreSA8bWF4aW1sZXZpdHNreUBn
bWFpbC5jb20+CkRhdGU6IEZyaSwgMSBBdWcgMjAwOCAxMjo1NDoyNyArMDMwMApTdWJqZWN0
OiBbUEFUQ0hdIFtJV0wzOTQ1XSBGaXggc3RhdGlzdGljcyBpbiBtb25pdG9yIG1vZGUKCml3
bDM5NDVfcnhfcmVwbHlfcnggd2FzIHNlbmRpbmcgcGFja2V0cyB0b28gZWFybHkgdG8KbWFj
ODAyMTEsIGJlZm9yZSB1cGRhdGluZyBzaWduYWwgc3RyZW5ndGgvcXVhbGl0eS4KVGhpcyBy
ZXN1bHRlZCBpbiBnYXJiYWdlIHBvd2VyIGxldmVscy4KClNpZ25lZC1vZmYtYnk6IE1heGlt
IExldml0c2t5IDxtYXhpbWxldml0c2t5QGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL25ldC93
aXJlbGVzcy9pd2x3aWZpL2l3bC0zOTQ1LmMgfCAgIDEwICsrKysrKy0tLS0KIDEgZmlsZXMg
Y2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLTM5NDUuYyBiL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2l3bHdpZmkvaXdsLTM5NDUuYwppbmRleCBjYWIxZjRiLi45ZTgzZWMwIDEw
MDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC0zOTQ1LmMKKysr
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtMzk0NS5jCkBAIC03MDgsMTAg
KzcwOCw3IEBAIHN0YXRpYyB2b2lkIGl3bDM5NDVfcnhfcmVwbHlfcngoc3RydWN0IGl3bDM5
NDVfcHJpdiAqcHJpdiwKIAkJcmV0dXJuOwogCX0KIAotCWlmIChwcml2LT5pd19tb2RlID09
IElFRUU4MDIxMV9JRl9UWVBFX01OVFIpIHsKLQkJaXdsMzk0NV9wYXNzX3BhY2tldF90b19t
YWM4MDIxMShwcml2LCByeGIsICZyeF9zdGF0dXMpOwotCQlyZXR1cm47Ci0JfQorCiAKIAkv
KiBDb252ZXJ0IDM5NDUncyByc3NpIGluZGljYXRvciB0byBkQm0gKi8KIAlyeF9zdGF0dXMu
c2lnbmFsID0gcnhfc3RhdHMtPnJzc2kgLSBJV0xfUlNTSV9PRkZTRVQ7CkBAIC03NzMsNiAr
NzcwLDExIEBAIHN0YXRpYyB2b2lkIGl3bDM5NDVfcnhfcmVwbHlfcngoc3RydWN0IGl3bDM5
NDVfcHJpdiAqcHJpdiwKIAkJcHJpdi0+bGFzdF9yeF9ub2lzZSA9IHJ4X3N0YXR1cy5ub2lz
ZTsKIAl9CiAKKwlpZiAocHJpdi0+aXdfbW9kZSA9PSBJRUVFODAyMTFfSUZfVFlQRV9NTlRS
KSB7CisJCWl3bDM5NDVfcGFzc19wYWNrZXRfdG9fbWFjODAyMTEocHJpdiwgcnhiLCAmcnhf
c3RhdHVzKTsKKwkJcmV0dXJuOworCX0KKwogCXN3aXRjaCAobGUxNl90b19jcHUoaGVhZGVy
LT5mcmFtZV9jb250cm9sKSAmIElFRUU4MDIxMV9GQ1RMX0ZUWVBFKSB7CiAJY2FzZSBJRUVF
ODAyMTFfRlRZUEVfTUdNVDoKIAkJc3dpdGNoIChsZTE2X3RvX2NwdShoZWFkZXItPmZyYW1l
X2NvbnRyb2wpICYKLS0gCjEuNS40LjMKCg==
--------------010000050608070103010603--
