Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31850 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab2EAQxC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 12:53:02 -0400
From: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Antonio Quartulli <ordex@autistici.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Emmanuel Grumbach (egrumbach@gmail.com)" <egrumbach@gmail.com>
Subject: RE: iwlwifi warn_slowpath with 3.*
Date: Tue, 1 May 2012 16:52:23 +0000
Message-ID: <4595B4D22AB93C4FABBA84AAD5AA37FD143115@ORSMSX103.amr.corp.intel.com> (sfid-20120501_185306_319082_1B5F2892)
References: <20120422182928.GA2854@ritirata.org>
 <20120430145803.GE2630@ritirata.org> <20120430170337.GA2560@tuxdriver.com>
In-Reply-To: <20120430170337.GA2560@tuxdriver.com>
Content-Type: multipart/mixed;
	boundary="_002_4595B4D22AB93C4FABBA84AAD5AA37FD143115ORSMSX103amrcorpi_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_4595B4D22AB93C4FABBA84AAD5AA37FD143115ORSMSX103amrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi John, Antonio,

Emmanuel found a race condition in rx buffer allocation/deallocation, and a=
ttached is a patch that fixes it.

>> > since linux-3.0 (I don't remember if it was the case even before),
>> > I'm getting this output in dmesg:
>> >
>> > [   53.662990] ------------[ cut here ]------------
>> > [   53.663016] WARNING: at drivers/iommu/intel-iommu.c:2911
>> > intel_unmap_page+0x14b/0x180()
>> > [   53.663047] Hardware name: Latitude E5420
>> > [   53.663066] Driver unmaps unmatched page at PFN ffd1a000
>>
>>
>> I see that I always get the same addr passed to the unmap function:
>>
>> [   23.950535] Driver unmaps unmatched page at PFN ffd1a000
>>
>> is it a coincidence?
>> I'm running linux-3.3.3 right now. I can try wireless-testing if it woul=
d help.

[MV] Antonio -- can you try out the patch attached and let us know if you c=
ontinue to see the problem?

>Just for the record, we are seeing a similar problem on RHEL 6.3 (which ha=
s an
>iwlwifi driver derived from linux-3.2).
>
>	https://bugzilla.redhat.com/show_bug.cgi?id=3D815998

[MV] John -- I'll update the redhat bugzilla as well.

Thanks
Meenakshi

--_002_4595B4D22AB93C4FABBA84AAD5AA37FD143115ORSMSX103amrcorpi_
Content-Type: application/octet-stream;
	name="0001-iwlwifi-fix-a-potential-race-in-receive-buffer-alloc.patch"
Content-Description: 0001-iwlwifi-fix-a-potential-race-in-receive-buffer-alloc.patch
Content-Disposition: attachment;
	filename="0001-iwlwifi-fix-a-potential-race-in-receive-buffer-alloc.patch";
	size=1612; creation-date="Tue, 01 May 2012 16:51:07 GMT";
	modification-date="Tue, 01 May 2012 16:51:07 GMT"
Content-Transfer-Encoding: base64

RnJvbSA1MzUzNDcyMzQ1ZTc2ZGVmZjhjNjc0ZjZkYTM1ZjUwZWY4OThkZjQ0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNZWVuYWtzaGkgVmVua2F0YXJhbWFuIDxtZWVuYWtzaGkudmVu
a2F0YXJhbWFuQGludGVsLmNvbT4KRGF0ZTogTW9uLCAzMCBBcHIgMjAxMiAxNjoyODowOSAtMDcw
MApTdWJqZWN0OiBbUEFUQ0hdIGl3bHdpZmk6IGZpeCBhIHBvdGVudGlhbCByYWNlIGluIHJlY2Vp
dmUgYnVmZmVyIGFsbG9jYXRpb24KClRoZSBkcml2ZXIgY2FuIHBvdGVudGlhbGx5IHVubWFwIHBh
Z2VzIHRoYXQKaGF2ZSBub3QgYmVlbiBtYXBwZWQgeWV0LiBGaXggdGhpcyByYWNlCmNvbmRpdGlv
bi4KCkNoYW5nZS1JZDogSWRjNjBjZmFhMGQ0ODNiYzgzNWY2OTc4OGRjNjA4NzA4ZGQ2ZjUyNGQK
Q2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKUmVwb3J0ZWQtYnk6IEVtbWFudWVsIEdydW1iYWNo
IDxlbW1hbnVlbC5ncnVtYmFjaEBpbnRlbC5jb20+ClNpZ25lZC1vZmYtYnk6IE1lZW5ha3NoaSBW
ZW5rYXRhcmFtYW4gPG1lZW5ha3NoaS52ZW5rYXRhcmFtYW5AaW50ZWwuY29tPgotLS0KIGRyaXZl
cnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLXRyYW5zLXBjaWUtcnguYyB8ICAgIDQgKysrLQog
MSBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtdHJhbnMtcGNpZS1yeC5jIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtdHJhbnMtcGNpZS1yeC5jCmluZGV4IDQ1
ZDhjYTkuLjg0ODNlOGEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkv
aXdsLXRyYW5zLXBjaWUtcnguYworKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3
bC10cmFucy1wY2llLXJ4LmMKQEAgLTMxMyw3ICszMTMsNiBAQCBzdGF0aWMgdm9pZCBpd2xhZ25f
cnhfYWxsb2NhdGUoc3RydWN0IGl3bF90cmFucyAqdHJhbnMsIGdmcF90IHByaW9yaXR5KQogCQlz
cGluX3VubG9ja19pcnFyZXN0b3JlKCZyeHEtPmxvY2ssIGZsYWdzKTsKIAogCQlCVUdfT04ocnhi
LT5wYWdlKTsKLQkJcnhiLT5wYWdlID0gcGFnZTsKIAkJLyogR2V0IHBoeXNpY2FsIGFkZHJlc3Mg
b2YgdGhlIFJCICovCiAJCXJ4Yi0+cGFnZV9kbWEgPSBkbWFfbWFwX3BhZ2UodHJhbnMtPmRldiwg
cGFnZSwgMCwKIAkJCQlQQUdFX1NJWkUgPDwgdHJhbnNfcGNpZS0+cnhfcGFnZV9vcmRlciwKQEAg
LTMyMyw2ICszMjIsOSBAQCBzdGF0aWMgdm9pZCBpd2xhZ25fcnhfYWxsb2NhdGUoc3RydWN0IGl3
bF90cmFucyAqdHJhbnMsIGdmcF90IHByaW9yaXR5KQogCQkvKiBhbmQgYWxzbyAyNTYgYnl0ZSBh
bGlnbmVkISAqLwogCQlCVUdfT04ocnhiLT5wYWdlX2RtYSAmIERNQV9CSVRfTUFTSyg4KSk7CiAK
KwkJLyogUGFnZSAqbXVzdCogYmUgbWFwcGVkIGJlZm9yZSBiZWZvcmUgdXBkYXRpbmcgdGhlIHJ4
Yi4gKi8KKwkJcnhiLT5wYWdlID0gcGFnZTsKKwogCQlzcGluX2xvY2tfaXJxc2F2ZSgmcnhxLT5s
b2NrLCBmbGFncyk7CiAKIAkJbGlzdF9hZGRfdGFpbCgmcnhiLT5saXN0LCAmcnhxLT5yeF9mcmVl
KTsKLS0gCjEuNy40LjEKCg==

--_002_4595B4D22AB93C4FABBA84AAD5AA37FD143115ORSMSX103amrcorpi_--
