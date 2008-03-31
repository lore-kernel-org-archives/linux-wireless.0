Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:38813 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755649AbYCaVT1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 17:19:27 -0400
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C89374.AF6DEB82"
Subject: FW: [ipw3945-devel] iwl3945: disassociation from AP (reason=4) andtimeout, a solution
Date: Mon, 31 Mar 2008 14:17:54 -0700
Message-ID: <D936D925018D154694D8A362EEB08920040FA26C@orsmsx416.amr.corp.intel.com> (sfid-20080331_221930_077589_D00C37B6)
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Cc: <ipw3945-devel@lists.sourceforge.net>, <abertensu@yahoo.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C89374.AF6DEB82
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Forwarding this to linux-wireless where there is more knowledge about
association. The attached patch is also to the mac80211 stack, so we
need to involve the mac80211 maintainer.

Reinette

On Friday, March 28, 2008 4:00 PM, Andres Bertens  wrote:

> Hi,
>=20
> Recently I moved from ipw3945 to iwl3945 and I was having an AP
> association timeout after some inactivity.
> Card is Intel 3945bg, router is DLink DI524, driver is
> compat-wireless-2.6 (2008-03-28) or older and mode is (WEP, open) on
> linux-2.6.24.4. It does not recover magically.
>=20
> The trace is:
>=20
> wlan0: RX disassociation from 00:17:9a:63:d2:21 (reason=3D4)
> wlan0: disassociated
> wlan0: associate with AP 00:17:9a:63:d2:21
> wlan0: RX ReassocResp from 00:17:9a:63:d2:21 (capab=3D0x431 =
status=3D17
> aid=3D1) wlan0: AP denied association (code=3D17)
> wlan0: associate with AP 00:17:9a:63:d2:21
> wlan0: RX AssocResp from 00:17:9a:63:d2:21 (capab=3D0x431 status=3D17
> aid=3D1073) wlan0: AP denied association (code=3D17)
> wlan0: associate with AP 00:17:9a:63:d2:21
> wlan0: RX AssocResp from 00:17:9a:63:d2:21 (capab=3D0x431 status=3D17
> aid=3D1073) wlan0: AP denied association (code=3D17)
> wlan0: association with AP 00:17:9a:63:d2:21 timed out
>=20
> After browsing the internet, I found a lot of people with the same
> problem and no solution. So, I dived into the code and found a simple
> solution: ignore disassociation. When a new request arrives to the
> wireless, a reconnection is done automatically.
>=20
> I patched the code, modifying net/mac80211/ieee80211_sta.c, and trace
> is as follow:
>=20
> wlan0: RX disassociation for reason=3D4 received from =
00:17:9a:63:d2:21
> - ignored
> wlan0: RX deauthentication from 00:17:9a:63:d2:21 (reason=3D6)
> wlan0: deauthenticated
> wlan0: authenticate with AP 00:17:9a:63:d2:21
> wlan0: RX authentication from 00:17:9a:63:d2:21 (alg=3D0 =
transaction=3D2
> status=3D0)
> wlan0: authenticated
> wlan0: associate with AP 00:17:9a:63:d2:21
> wlan0: RX ReassocResp from 00:17:9a:63:d2:21 (capab=3D0x431 status=3D0
> aid=3D2) wlan0: associated
>=20
> and these entries repeats in time. As you can see, the disassociation
> still ocurrs but a new request afterwards generates a deauthentication
> (reason=3D6) and a reconnection takes place (transparent to the user).
>=20
> Attached is patch to compat-wireless-2.6 (2008-03-28).  Please note
> that this is for iwl3945+dlink+WEP combination (according to other
> people, it seems to work for other combinations).
>=20
> Hope this help.
>=20
> Regards,
> Andres Bertens

=09

------_=_NextPart_001_01C89374.AF6DEB82
Content-Type: text/plain;
	name="compat-wireless-2.6-ap-timeout.patch"
Content-Transfer-Encoding: base64
Content-Description: compat-wireless-2.6-ap-timeout.patch
Content-Disposition: inline;
	filename="compat-wireless-2.6-ap-timeout.patch"

ZGlmZiAtTmF1ciBjb21wYXQtd2lyZWxlc3MtMjAwOC0wMy0yOC9uZXQvbWFjODAyMTEvaWVlZTgw
MjExX3N0YS5jIGNvbXBhdC13aXJlbGVzcy0yMDA4LTAzLTI4LW5ldy9uZXQvbWFjODAyMTEvaWVl
ZTgwMjExX3N0YS5jDQotLS0gY29tcGF0LXdpcmVsZXNzLTIwMDgtMDMtMjgvbmV0L21hYzgwMjEx
L2llZWU4MDIxMV9zdGEuYwkyMDA4LTAzLTI4IDAxOjE0OjE1LjAwMDAwMDAwMCAtMDQwMA0KKysr
IGNvbXBhdC13aXJlbGVzcy0yMDA4LTAzLTI4LW5ldy9uZXQvbWFjODAyMTEvaWVlZTgwMjExX3N0
YS5jCTIwMDgtMDMtMjggMTY6MTk6NTcuMDAwMDAwMDAwIC0wNDAwDQpAQCAtMTgwOSw2ICsxODA5
LDE1IEBADQogDQogCXJlYXNvbl9jb2RlID0gbGUxNl90b19jcHUobWdtdC0+dS5kaXNhc3NvYy5y
ZWFzb25fY29kZSk7DQogDQorLyogQUJVICovDQorCWlmKCByZWFzb25fY29kZSA9PSA0ICkgew0K
KwkJcHJpbnRrKEtFUk5fREVCVUcgIiVzOiBSWCBkaXNhc3NvY2lhdGlvbiBmb3IgcmVhc29uPTQg
Ig0KKwkJCSJyZWNlaXZlZCBmcm9tICVzIC0gaWdub3JlZFxuIiwNCisJCQlkZXYtPm5hbWUsIHBy
aW50X21hYyhtYWMsIG1nbXQtPnNhKSk7DQorCQlyZXR1cm47DQorCX0NCisvKiBBQlUgKi8NCisN
CiAJcHJpbnRrKEtFUk5fREVCVUcgIiVzOiBSWCBkaXNhc3NvY2lhdGlvbiBmcm9tICVzIg0KIAkg
ICAgICAgIiAocmVhc29uPSVkKVxuIiwNCiAJICAgICAgIGRldi0+bmFtZSwgcHJpbnRfbWFjKG1h
YywgbWdtdC0+c2EpLCByZWFzb25fY29kZSk7DQoNCg==

------_=_NextPart_001_01C89374.AF6DEB82
Content-Type: text/plain;
	name="ATT3729987.txt"
Content-Transfer-Encoding: base64
Content-Description: ATT3729987.txt
Content-Disposition: attachment;
	filename="ATT3729987.txt"

LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLQ0KQ2hlY2sgb3V0IHRoZSBuZXcgU291cmNlRm9yZ2UubmV0IE1hcmtl
dHBsYWNlLg0KSXQncyB0aGUgYmVzdCBwbGFjZSB0byBidXkgb3Igc2VsbCBzZXJ2aWNlcyBmb3IN
Cmp1c3QgYWJvdXQgYW55dGhpbmcgT3BlbiBTb3VyY2UuDQpodHRwOi8vYWQuZG91YmxlY2xpY2su
bmV0L2NsazsxNjQyMTYyMzk7MTM1MDMwMzg7dz9odHRwOi8vc2YubmV0L21hcmtldHBsYWNl

------_=_NextPart_001_01C89374.AF6DEB82
Content-Type: text/plain;
	name="ATT3729988.txt"
Content-Transfer-Encoding: base64
Content-Description: ATT3729988.txt
Content-Disposition: attachment;
	filename="ATT3729988.txt"

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18NCklwdzM5NDUt
ZGV2ZWwgbWFpbGluZyBsaXN0DQpJcHczOTQ1LWRldmVsQGxpc3RzLnNvdXJjZWZvcmdlLm5ldA0K
aHR0cHM6Ly9saXN0cy5zb3VyY2Vmb3JnZS5uZXQvbGlzdHMvbGlzdGluZm8vaXB3Mzk0NS1kZXZl
bA0K

------_=_NextPart_001_01C89374.AF6DEB82--
