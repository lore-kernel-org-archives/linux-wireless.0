Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:10713 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab2JOPO5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 11:14:57 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: RE: Lots of trans->state != IWL_TRANS_FW_ALIVE warnings
Date: Mon, 15 Oct 2012 15:14:51 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB3B7D4BB@HASMSX106.ger.corp.intel.com> (sfid-20121015_171459_953395_69B6BD73)
References: <20121015144722.GA12560@redhat.com> 
Content-Type: multipart/mixed;
	boundary="_002_0BA3FCBA62E2DC44AF3030971E174FB3B7D4BBHASMSX106gercorpi_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_0BA3FCBA62E2DC44AF3030971E174FB3B7D4BBHASMSX106gercorpi_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

> =

> >
> > On Fedora (3.5 and 3.6 kernels) we are currently overwhelmed by tons
> > of iwlwifi warnings at iwlagn_mac_flush() and iwl_dvm_send_cmd()
> reports.
> >
> > iwlagn_mac_flush warning is triggered at:
> >
> > static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans=
) {
> >         WARN_ONCE(trans->state !=3D IWL_TRANS_FW_ALIVE,
> >                   "%s bad state =3D %d", __func__, trans->state);
> >
> >         return trans->ops->wait_tx_queue_empty(trans);
> > }
> >
> > We have 2 instances of this issue:
> >
> > - started at ieee80211_scan()
> > https://bugzilla.redhat.com/show_bug.cgi?id=3D866013
> > - started at ieee80211_sta_monitor_work()
> > https://bugzilla.redhat.com/show_bug.cgi?id=3D861753
> >
> > iwl_dvm_send_cmd is triggered at:
> >
> > static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
> >                                 struct iwl_host_cmd *cmd) {
> >         WARN_ONCE(trans->state !=3D IWL_TRANS_FW_ALIVE,
> >                   "%s bad state =3D %d", __func__, trans->state);
> >
> >         return trans->ops->send_cmd(trans, cmd); }
> >
> > And have 3 instances:
> >
> > - started at ieee80211_set_disassoc()
> > https://bugzilla.redhat.com/show_bug.cgi?id=3D861599
> > - started at ieee80211_restart_work()
> > https://bugzilla.redhat.com/show_bug.cgi?id=3D865072
> > - started at ieee80211_auth()
> > https://bugzilla.redhat.com/show_bug.cgi?id=3D866015
> >
> =

> I glanced at the bugs and I can only see the trace dump. I am pretty sure
> there is an issue before the dump - fw assert of something like that. Can=
 it be
> possible to get the full log?
> =


Can you ask people to try the attached patch?
This will let us know where the fw is brought down.

> > Can those be fixed in some reasonable time ?
> >
> > I'm not sure if they are related with some user visible problem like
> > disconnects.
> =

> Well... if the fw isn't ALIVE then something bad happens, bad enough to g=
et
> disconnected, yes.
> >
> > I'll probably revert f0d120af8f55649571c681f49c920b0822050fa5
> > on Fedora, just to stop getting those warnings ...
> >
> =

> You will stop get the warnings, but that of course won't solve anything e=
lse.

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--_002_0BA3FCBA62E2DC44AF3030971E174FB3B7D4BBHASMSX106gercorpi_
Content-Type: application/octet-stream;
	name="0001-iwlwifi-print-state-changes-in-transport-layer.patch"
Content-Description: 0001-iwlwifi-print-state-changes-in-transport-layer.patch
Content-Disposition: attachment;
	filename="0001-iwlwifi-print-state-changes-in-transport-layer.patch";
	size=2388; creation-date="Mon, 15 Oct 2012 15:12:05 GMT";
	modification-date="Mon, 15 Oct 2012 15:12:05 GMT"
Content-Transfer-Encoding: base64

RnJvbSBlN2RiMzczNmM4NTBlNWFmZjlhMWEwY2ZjMGQ0YzExZDJjZTkzOTE0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFbW1hbnVlbCBHcnVtYmFjaCA8ZW1tYW51ZWwuZ3J1bWJhY2hA
aW50ZWwuY29tPgpEYXRlOiBNb24sIDE1IE9jdCAyMDEyIDIwOjA0OjU1ICswMjAwClN1YmplY3Q6
IFtQQVRDSF0gaXdsd2lmaTogIHByaW50IHN0YXRlIGNoYW5nZXMgaW4gdHJhbnNwb3J0IGxheWVy
CgpUaGlzIHdpbGwgaGVscCB0byBkZWJ1Zy4uLgoKU2lnbmVkLW9mZi1ieTogRW1tYW51ZWwgR3J1
bWJhY2ggPGVtbWFudWVsLmdydW1iYWNoQGludGVsLmNvbT4KLS0tCiBkcml2ZXJzL25ldC93aXJl
bGVzcy9pd2x3aWZpL2l3bC1kZWJ1Zy5oIHwgICAgMiArKwogZHJpdmVycy9uZXQvd2lyZWxlc3Mv
aXdsd2lmaS9pd2wtdHJhbnMuaCB8ICAgIDYgKysrKysrCiAyIGZpbGVzIGNoYW5nZWQsIDggaW5z
ZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9pd2x3aWZpL2l3bC1kZWJ1Zy5oIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9p
d2wtZGVidWcuaAppbmRleCA3YWUxODFhLi43MjdiNTIwIDEwMDY0NAotLS0gYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9pd2x3aWZpL2l3bC1kZWJ1Zy5oCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2l3bHdpZmkvaXdsLWRlYnVnLmgKQEAgLTEyNiw2ICsxMjYsNyBAQCBkbyB7ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAJCQlcCiAvKiAweDAwMDBGMDAwIC0gMHgw
MDAwMTAwMCAqLwogI2RlZmluZSBJV0xfRExfQVNTT0MJCTB4MDAwMDEwMDAKICNkZWZpbmUgSVdM
X0RMX0RST1AJCTB4MDAwMDIwMDAKKyNkZWZpbmUgSVdMX0RMX1RSQU5TCQkweDAwMDA0MDAwCiAj
ZGVmaW5lIElXTF9ETF9DT0VYCQkweDAwMDA4MDAwCiAvKiAweDAwMEYwMDAwIC0gMHgwMDAxMDAw
MCAqLwogI2RlZmluZSBJV0xfRExfRlcJCTB4MDAwMTAwMDAKQEAgLTE4Myw1ICsxODQsNiBAQCBk
byB7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAJCQlcCiAjZGVm
aW5lIElXTF9ERUJVR19SQURJTyhwLCBmLCBhLi4uKQlJV0xfREVCVUcocCwgSVdMX0RMX1JBRElP
LCBmLCAjIyBhKQogI2RlZmluZSBJV0xfREVCVUdfUE9XRVIocCwgZiwgYS4uLikJSVdMX0RFQlVH
KHAsIElXTF9ETF9QT1dFUiwgZiwgIyMgYSkKICNkZWZpbmUgSVdMX0RFQlVHXzExSChwLCBmLCBh
Li4uKQlJV0xfREVCVUcocCwgSVdMX0RMXzExSCwgZiwgIyMgYSkKKyNkZWZpbmUgSVdMX0RFQlVH
X1RSQU5TKHAsIGYsIGEuLi4pCUlXTF9ERUJVRyhwLCBJV0xfRExfVFJBTlMsIGYsICMjIGEpCiAK
ICNlbmRpZgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtdHJh
bnMuaCBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLXRyYW5zLmgKaW5kZXggNjk1
YjhkNS4uZDZkNmUxMiAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9p
d2wtdHJhbnMuaAorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC10cmFucy5o
CkBAIC01MDgsNiArNTA4LDggQEAgc3RhdGljIGlubGluZSB2b2lkIGl3bF90cmFuc19zdG9wX2h3
KHN0cnVjdCBpd2xfdHJhbnMgKnRyYW5zLAogCiAJdHJhbnMtPm9wcy0+c3RvcF9odyh0cmFucywg
b3BfbW9kZV9sZWF2aW5nKTsKIAorCUlXTF9ERUJVR19UUkFOUyh0cmFucywgInRyYW5zLT5zdGF0
ZTogJWQgLT4gJWRcbiIsCisJCQl0cmFucy0+c3RhdGUsIElXTF9UUkFOU19OT19GVyk7CiAJdHJh
bnMtPnN0YXRlID0gSVdMX1RSQU5TX05PX0ZXOwogfQogCkBAIC01MTUsNiArNTE3LDggQEAgc3Rh
dGljIGlubGluZSB2b2lkIGl3bF90cmFuc19md19hbGl2ZShzdHJ1Y3QgaXdsX3RyYW5zICp0cmFu
cykKIHsKIAltaWdodF9zbGVlcCgpOwogCisJSVdMX0RFQlVHX1RSQU5TKHRyYW5zLCAidHJhbnMt
PnN0YXRlOiAlZCAtPiAlZFxuIiwKKwkJCXRyYW5zLT5zdGF0ZSwgSVdMX1RSQU5TX0ZXX0FMSVZF
KTsKIAl0cmFucy0+c3RhdGUgPSBJV0xfVFJBTlNfRldfQUxJVkU7CiAKIAl0cmFucy0+b3BzLT5m
d19hbGl2ZSh0cmFucyk7CkBAIC01MzYsNiArNTQwLDggQEAgc3RhdGljIGlubGluZSB2b2lkIGl3
bF90cmFuc19zdG9wX2RldmljZShzdHJ1Y3QgaXdsX3RyYW5zICp0cmFucykKIAogCXRyYW5zLT5v
cHMtPnN0b3BfZGV2aWNlKHRyYW5zKTsKIAorCUlXTF9ERUJVR19UUkFOUyh0cmFucywgInRyYW5z
LT5zdGF0ZTogJWQgLT4gJWRcbiIsCisJCQl0cmFucy0+c3RhdGUsIElXTF9UUkFOU19OT19GVyk7
CiAJdHJhbnMtPnN0YXRlID0gSVdMX1RSQU5TX05PX0ZXOwogfQogCi0tIAoxLjcuMQoK

--_002_0BA3FCBA62E2DC44AF3030971E174FB3B7D4BBHASMSX106gercorpi_--

