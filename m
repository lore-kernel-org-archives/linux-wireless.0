Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755683AbYDRVqE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 17:46:04 -0400
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C8A19D.9958B9DE"
Subject: RE:  RE:  RE: iwl3945 problem with 2.6.25-rc9
Date: Fri, 18 Apr 2008 14:46:03 -0700
Message-ID: <D936D925018D154694D8A362EEB089200438B6D6@orsmsx416.amr.corp.intel.com> (sfid-20080418_224627_648936_DECA7576)
In-Reply-To: A<fu931e$k1b$1@ger.gmane.org>
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com> <fu5iel$c45$1@ger.gmane.org> <fu5l5r$pm8$1@ger.gmane.org> <1208376292.27708.3.camel@localhost.localdomain> <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com> <D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com> A<fu931e$k1b$1@ger.gmane.org>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Marcus Furlong" <furlongm@hotmail.com>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C8A19D.9958B9DE
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On , Marcus Furlong  wrote:

> iwlist wlan0 scan showed the AP a few times, but mostly found nothing
> at all. When it did find APs, it found at most 2-3 APs, whereas
> the ipw driver
> finds 10 or more APs on the same machine.

I am seeing something very strange in this log and the logs you sent in
your first message. It appears that your driver uses software scanning
while hardware scanning is the default for this driver. This appears to
be the cause of the ucode errors as the A band channels are configured
as part of the scanning process.

Now, how this happens is weird. I tried running 2.6.25-rc9 myself and
was not able to reproduce the problem - hardware scanning was used.  The
driver is also explicit when HW scanning is disabled, this does not
appear in your logs, it is also explicit about when it runs HW scanning,
this also does not appear in your logs. So it does not seem as though
you are disabling the default HW scanning, but yet it uses SW scanning.
How it ends up using software scanning is not clear.

In an effort to trace what could be happening I created a small patch
(attached) that adds more debugging to the scanning code. Could you
please run with this patch and send us the debug output?=20

Thank you very much

Reinette









------_=_NextPart_001_01C8A19D.9958B9DE
Content-Type: application/octet-stream;
	name="scan.patch"
Content-Transfer-Encoding: base64
Content-Description: scan.patch
Content-Disposition: attachment;
	filename="scan.patch"

ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9pZWVlODAyMTFfc3RhLmMgYi9uZXQvbWFjODAyMTEv
aWVlZTgwMjExX3N0YS5jCmluZGV4IGMxNzA2ODUuLmI5Y2E2YTEgMTAwNjQ0Ci0tLSBhL25ldC9t
YWM4MDIxMS9pZWVlODAyMTFfc3RhLmMKKysrIGIvbmV0L21hYzgwMjExL2llZWU4MDIxMV9zdGEu
YwpAQCAtMzMxNywxNiArMzMxNywyMiBAQCBzdGF0aWMgaW50IGllZWU4MDIxMV9zdGFfc3RhcnRf
c2NhbihzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LAogCQlyZXR1cm4gLUVCVVNZOwogCX0KIAorCWR1
bXBfc3RhY2soKTsKKwlwcmludGsoS0VSTl9ERUJVRyAiVGVzdGluZyBpZiBkcml2ZXIncyBodyBz
Y2FubmluZyBlbmFibGVkIC4uLlxuIik7CiAJaWYgKGxvY2FsLT5vcHMtPmh3X3NjYW4pIHsKKwkJ
cHJpbnRrKEtFUk5fREVCVUcgIkRyaXZlciBwcm92aWRlZCBod19zY2FuIGZ1bmN0aW9uIC4uLiBc
biIpOwogCQlpbnQgcmMgPSBsb2NhbC0+b3BzLT5od19zY2FuKGxvY2FsX3RvX2h3KGxvY2FsKSwK
IAkJCQkJICAgICBzc2lkLCBzc2lkX2xlbik7CiAJCWlmICghcmMpIHsKKwkJCXByaW50ayhLRVJO
X0RFQlVHICJEcml2ZXIncyBod19zY2FuIGZ1bmN0aW9uIFNVQ0NFU1MuLi4gXG4iKTsKIAkJCWxv
Y2FsLT5zdGFfaHdfc2Nhbm5pbmcgPSAxOwogCQkJbG9jYWwtPnNjYW5fZGV2ID0gZGV2OwogCQl9
CiAJCXJldHVybiByYzsKIAl9CiAKKwlwcmludGsoS0VSTl9ERUJVRyAiVXNpbmcgc29mdHdhcmUg
c2Nhbm5pbmcgLi4uXG4iKTsKKwogCWxvY2FsLT5zdGFfc3dfc2Nhbm5pbmcgPSAxOwogCiAJcmN1
X3JlYWRfbG9jaygpOwo=

------_=_NextPart_001_01C8A19D.9958B9DE--
