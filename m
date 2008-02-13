Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48370 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344AbYBMW0l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 17:26:41 -0500
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C86E8E.AB95B7BD"
Subject: RE: [HOTFIX] Re: mac80211/iwl4965: ad-hoc broken in 2.6.25-rc1
Date: Wed, 13 Feb 2008 14:20:41 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003A7FB3E@orsmsx416.amr.corp.intel.com> (sfid-20080213_222700_759663_7C076476)
In-Reply-To: <47B2B332.1030404@scherping.de>
References: <47B1F422.4060501@scherping.de> <D936D925018D154694D8A362EEB0892003A461BF@orsmsx416.amr.corp.intel.com> <47B2268D.7060205@scherping.de> <47B2B332.1030404@scherping.de>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Richard Scherping" <richard@scherping.de>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C86E8E.AB95B7BD
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Wednesday, February 13, 2008 1:07 AM, Richard Scherping  wrote:

>> iwl4965: I iwl4965_tx_skb Dropping - !iwl4965_is_associated:
>> iwl4965_is_associated(priv)=3D1; priv->assoc_id=3D0;
>> priv->assoc_station_added=3D1
>=20
> Simply uncommenting the check for priv->assoc_id to be
> non-zero (line 2938 in iwl4965-base.c) made ad-hoc working.
> Thanks for helping me to find this!
> Does this change have any negative side effects?
>=20
> Richard

Could you please try the attached patch instead?

Thanks

Reinette

------_=_NextPart_001_01C86E8E.AB95B7BD
Content-Type: application/octet-stream;
	name="0001-iwlwifi-only-check-for-association-id-when-associat.patch"
Content-Transfer-Encoding: base64
Content-Description: 0001-iwlwifi-only-check-for-association-id-when-associat.patch
Content-Disposition: attachment;
	filename="0001-iwlwifi-only-check-for-association-id-when-associat.patch"

RnJvbSAxYzE3ZjdjMmRhM2UzODFkYWQzMDlmNjEyZGJmNTZkYjFlNGQ4NjhmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSZWluZXR0ZSBDaGF0cmUgPHJlaW5ldHRlLmNoYXRyZUBpbnRl
bC5jb20+CkRhdGU6IFdlZCwgMTMgRmViIDIwMDggMTQ6MTc6NDAgLTA4MDAKU3ViamVjdDogW1BB
VENIXSBpd2x3aWZpOiBvbmx5IGNoZWNrIGZvciBhc3NvY2lhdGlvbiBpZCB3aGVuIGFzc29jaWF0
aW5nIHdpdGggQVAKClRoZXJlIGlzIG5vIGFzc29jaWF0aW9uIHByb2Nlc3MgaW4gSUJTUyBtb2Rl
IC0gc28gdGVzdGluZyB0aGUKYXNzb2NpYXRpb24gaWQgaXMgbm90IG5lZWRlZC4KClNpZ25lZC1v
ZmYtYnk6IFJlaW5ldHRlIENoYXRyZSA8cmVpbmV0dGUuY2hhdHJlQGludGVsLmNvbT4KLS0tCiBk
cml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bDM5NDUtYmFzZS5jIHwgICAgMyArKy0KIGRy
aXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsNDk2NS1iYXNlLmMgfCAgICAyICstCiAyIGZp
bGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bDM5NDUtYmFzZS5jIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wzOTQ1LWJhc2UuYwppbmRleCBjMGQ5OWNhLi42YjViNmRl
IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bDM5NDUtYmFzZS5j
CisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsMzk0NS1iYXNlLmMKQEAgLTI4
MDYsNyArMjgwNiw4IEBAIHN0YXRpYyBpbnQgaXdsMzk0NV90eF9za2Ioc3RydWN0IGl3bDM5NDVf
cHJpdiAqcHJpdiwKICNlbmRpZgogCiAJLyogZHJvcCBhbGwgZGF0YSBmcmFtZSBpZiB3ZSBhcmUg
bm90IGFzc29jaWF0ZWQgKi8KLQlpZiAoKCFpd2wzOTQ1X2lzX2Fzc29jaWF0ZWQocHJpdikgfHwg
IXByaXYtPmFzc29jX2lkKSAmJgorCWlmICgoIWl3bDM5NDVfaXNfYXNzb2NpYXRlZChwcml2KSB8
fAorCSAgICAgKChwcml2LT5pd19tb2RlID09IElFRUU4MDIxMV9JRl9UWVBFX1NUQSkgJiYgIXBy
aXYtPmFzc29jX2lkKSkgJiYKIAkgICAgKChmYyAmIElFRUU4MDIxMV9GQ1RMX0ZUWVBFKSA9PSBJ
RUVFODAyMTFfRlRZUEVfREFUQSkpIHsKIAkJSVdMX0RFQlVHX0RST1AoIkRyb3BwaW5nIC0gIWl3
bDM5NDVfaXNfYXNzb2NpYXRlZFxuIik7CiAJCWdvdG8gZHJvcF91bmxvY2s7CmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bDQ5NjUtYmFzZS5jIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2w0OTY1LWJhc2UuYwppbmRleCAzZmEwYmI0Li5jYTAzYTli
IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bDQ5NjUtYmFzZS5j
CisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsNDk2NS1iYXNlLmMKQEAgLTI5
MzIsNyArMjkzMiw3IEBAIHN0YXRpYyBpbnQgaXdsNDk2NV90eF9za2Ioc3RydWN0IGl3bDQ5NjVf
cHJpdiAqcHJpdiwKIAkvKiBkcm9wIGFsbCBkYXRhIGZyYW1lIGlmIHdlIGFyZSBub3QgYXNzb2Np
YXRlZCAqLwogCWlmICgoKGZjICYgSUVFRTgwMjExX0ZDVExfRlRZUEUpID09IElFRUU4MDIxMV9G
VFlQRV9EQVRBKSAmJgogCSAgICghaXdsNDk2NV9pc19hc3NvY2lhdGVkKHByaXYpIHx8Ci0JICAg
ICFwcml2LT5hc3NvY19pZCB8fAorCSAgICAoKHByaXYtPml3X21vZGUgPT0gSUVFRTgwMjExX0lG
X1RZUEVfU1RBKSAmJiAhcHJpdi0+YXNzb2NfaWQpIHx8CiAJICAgICFwcml2LT5hc3NvY19zdGF0
aW9uX2FkZGVkKSkgewogCQlJV0xfREVCVUdfRFJPUCgiRHJvcHBpbmcgLSAhaXdsNDk2NV9pc19h
c3NvY2lhdGVkXG4iKTsKIAkJZ290byBkcm9wX3VubG9jazsKLS0gCjEuNS4zLjQKCg==

------_=_NextPart_001_01C86E8E.AB95B7BD--
