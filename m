Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44970 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab1IZJYU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 05:24:20 -0400
Received: by wwf22 with SMTP id 22so6486024wwf.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 02:24:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <14be9f3b-4c91-481d-9e52-f3119659fd59@email.android.com>
References: <CAD2nsn2Bbxxy9ZYpBe_QEqCkGYYROHE+j7qASRq3OkKmWD5PMg@mail.gmail.com>
	<CAD2nsn1+5QWtzeG-3RHEJi8+oDthAfXYunHnDTLie84oJPOQuw@mail.gmail.com>
	<CAD2nsn1roVNB5+H1CYHVnerLN3pjGB5KmEX1mJZ4yJhHqFGOVA@mail.gmail.com>
	<20110830064137.GA4719@ecki>
	<CAD2nsn2Reu+T=g6HwdQT5cdkD0C-06y7GJ_B2q-UzpRnshxAWw@mail.gmail.com>
	<14be9f3b-4c91-481d-9e52-f3119659fd59@email.android.com>
Date: Mon, 26 Sep 2011 14:54:18 +0530
Message-ID: <CAD2nsn1+WVaLR_TR37Z6YRCFnQH1hJkSOri=nxc8Ff3pa9N8dw@mail.gmail.com> (sfid-20110926_112423_718263_E4A8DF2C)
Subject: Re: ath9k: irq storm after suspend/resume
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Clemens Buchacher <drizzd@aon.at>
Cc: linux-wireless@vger.kernel.org, beta992@gmail.com
Content-Type: multipart/mixed; boundary=0016368318d437242b04add4b903
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0016368318d437242b04add4b903
Content-Type: text/plain; charset=ISO-8859-1

Hi,
On Thu, Sep 1, 2011 at 11:54 AM, Clemens Buchacher <drizzd@aon.at> wrote:
> Mohammed Shafi <shafi.wireless@gmail.com> wrote:
>>
>>i am bit confused looking at bug comments. please correct me.
>>the bug comments say that disabling/making the Network-Manager to
>>sleep triggers the problem.
> That is correct.

is the issue still seen? any improvement with the attached patch..
will just again take a look at this thread and ath_pci_probe once i
finish my work. thanks!

>



-- 
shafi

--0016368318d437242b04add4b903
Content-Type: text/x-diff; charset=US-ASCII;
	name="0001-ath9k-disable-interrupt-before-free_irq.patch"
Content-Disposition: attachment;
	filename="0001-ath9k-disable-interrupt-before-free_irq.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gt18xxjx0

RnJvbSAzNTUwY2Q3YTExM2UxN2M0ZTdjZWQ4YWNiZDdmMTRhM2E3MzU4NmVkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNb2hhbW1lZCBTaGFmaSBTaGFqYWtoYW4gPG1vaGFtbWVkQHFj
YS5xdWFsY29tbS5jb20+CkRhdGU6IFNhdCwgMjQgU2VwIDIwMTEgMjE6MDc6MTYgKzA1MzAKU3Vi
amVjdDogW1BBVENIXSBhdGg5azogZGlzYWJsZSBpbnRlcnJ1cHQgYmVmb3JlIGZyZWVfaXJxCgpm
cmVlX2lycSBjbGFpbXMgdGhhdCBmb3IgYSBzaGFyZWQgSVJRIHRoZSBjYWxsZXIgbXVzdCBlbnN1
cmUgdGhhdCB0aGUgaW50ZXJydXB0IGlzCmRpc2FibGVkIG9uIHRoZSBjYXJkIGl0IGRyaXZlcyBi
ZWZvcmUgY2FsbGluZyBpdC4gd2lsbCBzb29uIHRlc3QgYW5kCnNlbmQgYSBwcm9wZXIgcGF0Y2gK
ClNpZ25lZC1vZmYtYnk6IE1vaGFtbWVkIFNoYWZpIFNoYWpha2hhbiA8bW9oYW1tZWRAcWNhLnF1
YWxjb21tLmNvbT4KLS0tCiBkcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvcGNpLmMgfCAg
ICA3ICsrKysrKysKIDEgZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9wY2kuYyBi
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9wY2kuYwppbmRleCBkNjdkNmVlLi4zNTUz
N2NhIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvcGNpLmMKKysr
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL3BjaS5jCkBAIC0yODUsMTEgKzI4NSwx
OCBAQCBzdGF0aWMgdm9pZCBhdGhfcGNpX3JlbW92ZShzdHJ1Y3QgcGNpX2RldiAqcGRldikKIHsK
IAlzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodyA9IHBjaV9nZXRfZHJ2ZGF0YShwZGV2KTsKIAlzdHJ1
Y3QgYXRoX3NvZnRjICpzYyA9IGh3LT5wcml2OworCXN0cnVjdCBhdGhfaHcgKmFoID0gc2MtPnNj
X2FoOwogCXZvaWQgX19pb21lbSAqbWVtID0gc2MtPm1lbTsKIAogCWlmICghaXNfYXRoOWtfdW5s
b2FkZWQpCiAJCXNjLT5zY19haC0+YWhfZmxhZ3MgfD0gQUhfVU5QTFVHR0VEOworCisJLyogZGlz
YWJsZSBpbnRlcnJ1cHRzICovCisJYWgtPmltYXNrICY9IH5BVEg5S19JTlRfR0xPQkFMOworCWF0
aDlrX2h3X2Rpc2FibGVfaW50ZXJydXB0cyhhaCk7CisKIAlhdGg5a19kZWluaXRfZGV2aWNlKHNj
KTsKKwogCWZyZWVfaXJxKHNjLT5pcnEsIHNjKTsKIAlpZWVlODAyMTFfZnJlZV9odyhzYy0+aHcp
OwogCi0tIAoxLjcuMC40Cgo=
--0016368318d437242b04add4b903--
