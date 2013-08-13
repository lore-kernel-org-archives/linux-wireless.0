Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:50675 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542Ab3HMOsJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 10:48:09 -0400
MIME-Version: 1.0
In-Reply-To: <52090C37.2000103@hauke-m.de>
References: <1375865563-1196-1-git-send-email-arik@wizery.com>
 <5202D173.4050408@hauke-m.de> <CA+XVXfdAUZGj7FjfRUxT2noa1b35xk1vn0bdcO70Vic6h9yXcg@mail.gmail.com>
 <52090C37.2000103@hauke-m.de>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 13 Aug 2013 17:47:53 +0300
Message-ID: <CA+XVXfe65N5+iXQ6-5fST=PDKk4Hk0sRk04UH+oXoDpc1DTVyw@mail.gmail.com> (sfid-20130813_164814_176142_559CE65C)
Subject: Re: [PATCH] backports: rename some mem functions to not break custom kernels
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@kernel.org,
	"backports@vger.kernel.org" <backports@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b2e0e6f4663b804e3d55447
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--047d7b2e0e6f4663b804e3d55447
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Aug 12, 2013 at 7:24 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> adding the LINUX_BACKPORT() line should be enough to rename it
> everywhere in backprots, so you do not have to modify
> backport/compat/backport-3.11.c or manually add the prefix anywhere else.
>
> Could you try if this fixes your problems with phys_wc_to_mtrr_index:
>
>  ...
> +#define phys_wc_to_mtrr_index LINUX_BACKPORT(phys_wc_to_mtrr_index)
>  #ifdef CONFIG_MTRR
>  extern int phys_wc_to_mtrr_index(int handle);
>  #else
>  static inline int phys_wc_to_mtrr_index(int handle)
>  {
>         return -1;
>  }
>  #endif /* CONFIG_MTRR */
>

Thanks. It seems to do the trick. The attached patch solves the issue.
Luis - any comments on this one?

Regards,
Arik

--047d7b2e0e6f4663b804e3d55447
Content-Type: application/octet-stream;
	name="0001-backports-rename-some-mem-functions-to-not-break-cus.patch"
Content-Disposition: attachment;
	filename="0001-backports-rename-some-mem-functions-to-not-break-cus.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkb84n650

RnJvbSBmZmNiNzE2YWFmMmEzZmU2MWFmMjllNzRmZTIzYzQ2ODhmMzlhNTNkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBcmlrIE5lbXRzb3YgPGFyaWtAd2l6ZXJ5LmNvbT4KRGF0ZTog
VHVlLCA2IEF1ZyAyMDEzIDE4OjI4OjU2ICswMzAwClN1YmplY3Q6IFtQQVRDSF0gYmFja3BvcnRz
OiByZW5hbWUgc29tZSBtZW0gZnVuY3Rpb25zIHRvIG5vdCBicmVhayBjdXN0b20KIGtlcm5lbHMK
CldoZW4gY3VzdG9tIHBhdGNoZXMgYXJlIGNoZXJyeS1waWNrZWQgdG8gYSBrZXJuZWwsIHNvbWUg
c3ltYm9scyBleHBvcnRlZApieSBiYWNrcG9ydHMgbWF5IGNsYXNoIHdpdGggdGhlIGJ1aWx0LWlu
IG9uZXMuIFJlbmFtZSB0aGUgYmFja3BvcnRzCnN5bWJvbHMgdXNpbmcgdGhlIHN0YW5kYXJkIGJh
Y2twb3J0XyBwcmVmaXggdG8gcHJldmVudCB0aGF0LgoKVGhlIG9mZmVuZGluZyBzeW1ib2xzIHdl
cmUgZXhwb3J0ZWQgYnkgdGhlIHBhdGNoIGJlbG93OgoKY29tbWl0IDJjZTVjMjI0NDhiYjQ1OTk4
MzE4MjY3YzAwYjVkNmVmOWNmZjMxNzAKQXV0aG9yOiBIYXVrZSBNZWhydGVucyA8aGF1a2VAaGF1
a2UtbS5kZT4KRGF0ZTogICBUaHUgSnVuIDYgMTM6NDg6MDQgMjAxMyArMDIwMAoKICAgIGJhY2tw
b3J0czogYmFja3BvcnQgc29tZSBtZW1vcnkgZnVuY3Rpb25zCgpTaWduZWQtb2ZmLWJ5OiBBcmlr
IE5lbXRzb3YgPGFyaWtAd2l6ZXJ5LmNvbT4KLS0tCiBiYWNrcG9ydC9iYWNrcG9ydC1pbmNsdWRl
L2FzbS9tdHJyLmggfCAxICsKIGJhY2twb3J0L2JhY2twb3J0LWluY2x1ZGUvbGludXgvaW8uaCB8
IDMgKysrCiAyIGZpbGVzIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2Jh
Y2twb3J0L2JhY2twb3J0LWluY2x1ZGUvYXNtL210cnIuaCBiL2JhY2twb3J0L2JhY2twb3J0LWlu
Y2x1ZGUvYXNtL210cnIuaAppbmRleCBjZjBmNmZkLi44NjE0MzhhIDEwMDY0NAotLS0gYS9iYWNr
cG9ydC9iYWNrcG9ydC1pbmNsdWRlL2FzbS9tdHJyLmgKKysrIGIvYmFja3BvcnQvYmFja3BvcnQt
aW5jbHVkZS9hc20vbXRyci5oCkBAIC03LDYgKzcsNyBAQAogICogVGhlIGZvbGxvd2luZyBmdW5j
dGlvbnMgYXJlIGZvciB1c2UgYnkgb3RoZXIgZHJpdmVycyB0aGF0IGNhbm5vdCB1c2UKICAqIGFy
Y2hfcGh5c193Y19hZGQgYW5kIGFyY2hfcGh5c193Y19kZWwuCiAgKi8KKyNkZWZpbmUgcGh5c193
Y190b19tdHJyX2luZGV4IExJTlVYX0JBQ0tQT1JUKHBoeXNfd2NfdG9fbXRycl9pbmRleCkKICNp
ZmRlZiBDT05GSUdfTVRSUgogZXh0ZXJuIGludCBwaHlzX3djX3RvX210cnJfaW5kZXgoaW50IGhh
bmRsZSk7CiAjZWxzZQpkaWZmIC0tZ2l0IGEvYmFja3BvcnQvYmFja3BvcnQtaW5jbHVkZS9saW51
eC9pby5oIGIvYmFja3BvcnQvYmFja3BvcnQtaW5jbHVkZS9saW51eC9pby5oCmluZGV4IDlhNWIz
MDguLjU0NDdkZjggMTAwNjQ0Ci0tLSBhL2JhY2twb3J0L2JhY2twb3J0LWluY2x1ZGUvbGludXgv
aW8uaAorKysgYi9iYWNrcG9ydC9iYWNrcG9ydC1pbmNsdWRlL2xpbnV4L2lvLmgKQEAgLTEzLDYg
KzEzLDkgQEAKICAqIGFyY2hfcGh5c19kZWxfd2MoMCkgb3IgYXJjaF9waHlzX2RlbF93Yyhhbnkg
ZXJyb3IgY29kZSkgaXMgZ3VhcmFudGVlZAogICogdG8gaGF2ZSBubyBlZmZlY3QuCiAgKi8KKyNk
ZWZpbmUgYXJjaF9waHlzX3djX2FkZCBMSU5VWF9CQUNLUE9SVChhcmNoX3BoeXNfd2NfYWRkKQor
I2RlZmluZSBhcmNoX3BoeXNfd2NfZGVsIExJTlVYX0JBQ0tQT1JUKGFyY2hfcGh5c193Y19kZWwp
CisKICNpZm5kZWYgYXJjaF9waHlzX3djX2FkZAogI2lmZGVmIENPTkZJR19NVFJSCiBleHRlcm4g
aW50IF9fbXVzdF9jaGVjayBhcmNoX3BoeXNfd2NfYWRkKHVuc2lnbmVkIGxvbmcgYmFzZSwKLS0g
CjEuOC4xLjIKCg==
--047d7b2e0e6f4663b804e3d55447--
